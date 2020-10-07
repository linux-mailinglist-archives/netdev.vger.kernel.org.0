Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B7C286A54
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgJGVhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:37:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:45678 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgJGVhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 17:37:04 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQH7N-0001ts-Tx; Wed, 07 Oct 2020 23:37:01 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQH7N-0005FC-Kf; Wed, 07 Oct 2020 23:37:01 +0200
Subject: Re: [PATCH bpf-next V2 5/6] bpf: Add MTU check for TC-BPF packets
 after egress hook
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
References: <160208770557.798237.11181325462593441941.stgit@firesoul>
 <160208778070.798237.16265441131909465819.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7aeb6082-48a3-9b71-2e2c-10adeb5ee79a@iogearbox.net>
Date:   Wed, 7 Oct 2020 23:37:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160208778070.798237.16265441131909465819.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25950/Wed Oct  7 15:55:10 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/20 6:23 PM, Jesper Dangaard Brouer wrote:
[...]
>   net/core/dev.c |   24 ++++++++++++++++++++++--
>   1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b433098896b2..19406013f93e 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3870,6 +3870,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
>   	switch (tcf_classify(skb, miniq->filter_list, &cl_res, false)) {
>   	case TC_ACT_OK:
>   	case TC_ACT_RECLASSIFY:
> +		*ret = NET_XMIT_SUCCESS;
>   		skb->tc_index = TC_H_MIN(cl_res.classid);
>   		break;
>   	case TC_ACT_SHOT:
> @@ -4064,9 +4065,12 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>   {
>   	struct net_device *dev = skb->dev;
>   	struct netdev_queue *txq;
> +#ifdef CONFIG_NET_CLS_ACT
> +	bool mtu_check = false;
> +#endif
> +	bool again = false;
>   	struct Qdisc *q;
>   	int rc = -ENOMEM;
> -	bool again = false;
>   
>   	skb_reset_mac_header(skb);
>   
> @@ -4082,14 +4086,28 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>   
>   	qdisc_pkt_len_init(skb);
>   #ifdef CONFIG_NET_CLS_ACT
> +	mtu_check = skb_is_redirected(skb);
>   	skb->tc_at_ingress = 0;
>   # ifdef CONFIG_NET_EGRESS
>   	if (static_branch_unlikely(&egress_needed_key)) {
> +		unsigned int len_orig = skb->len;
> +
>   		skb = sch_handle_egress(skb, &rc, dev);
>   		if (!skb)
>   			goto out;
> +		/* BPF-prog ran and could have changed packet size beyond MTU */
> +		if (rc == NET_XMIT_SUCCESS && skb->len > len_orig)
> +			mtu_check = true;
>   	}
>   # endif
> +	/* MTU-check only happens on "last" net_device in a redirect sequence
> +	 * (e.g. above sch_handle_egress can steal SKB and skb_do_redirect it
> +	 * either ingress or egress to another device).
> +	 */

Hmm, quite some overhead in fast path. Also, won't this be checked multiple times
on stacked devices? :( Moreover, this missed the fact that 'real' qdiscs can have
filters attached too, this would come after this check. Can't this instead be in
driver layer for those that really need it? I would probably only drop the check
as done in 1/6 and allow the BPF prog to do the validation if needed.

> +	if (mtu_check && !is_skb_forwardable(dev, skb)) {
> +		rc = -EMSGSIZE;
> +		goto drop;
> +	}
>   #endif
>   	/* If device/qdisc don't need skb->dst, release it right now while
>   	 * its hot in this cpu cache.
> @@ -4157,7 +4175,9 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>   
>   	rc = -ENETDOWN;
>   	rcu_read_unlock_bh();
> -
> +#ifdef CONFIG_NET_CLS_ACT
> +drop:
> +#endif
>   	atomic_long_inc(&dev->tx_dropped);
>   	kfree_skb_list(skb);
>   	return rc;
> 
