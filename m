Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F002CCADD
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 01:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgLCAHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 19:07:25 -0500
Received: from www62.your-server.de ([213.133.104.62]:60742 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbgLCAHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 19:07:25 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kkc8w-0007jR-89; Thu, 03 Dec 2020 01:06:42 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kkc8v-00080X-Ux; Thu, 03 Dec 2020 01:06:41 +0100
Subject: Re: [PATCH bpf-next V8 6/8] bpf: make it possible to identify BPF
 redirected SKBs
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
References: <160650034591.2890576.1092952641487480652.stgit@firesoul>
 <160650040800.2890576.9811290366501747109.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cb5dca49-1c73-47c4-d21a-819da8a75b1c@iogearbox.net>
Date:   Thu, 3 Dec 2020 01:06:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160650040800.2890576.9811290366501747109.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26006/Wed Dec  2 14:14:18 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/20 7:06 PM, Jesper Dangaard Brouer wrote:
> This change makes it possible to identify SKBs that have been redirected
> by TC-BPF (cls_act). This is needed for a number of cases.
> 
> (1) For collaborating with driver ifb net_devices.
> (2) For avoiding starting generic-XDP prog on TC ingress redirect.
> 
> It is most important to fix XDP case(2), because this can break userspace
> when a driver gets support for native-XDP. Imagine userspace loads XDP
> prog on eth0, which fallback to generic-XDP, and it process TC-redirected
> packets. When kernel is updated with native-XDP support for eth0, then the
> program no-longer see the TC-redirected packets. Therefore it is important
> to keep the order intact; that XDP runs before TC-BPF.

I don't follow the statement in the very last sentence here.. the order is
still intact just that these rediected packets are invoked for generic XDP
as well, so from an ingress path perspective it's still generic XDP and then
tc ingress. What this aims to achieve is to bypass the generic XDP instead.

> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   net/core/dev.c    |    2 ++
>   net/sched/Kconfig |    1 +
>   2 files changed, 3 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6ceb6412ee97..26b40f8005ae 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3872,6 +3872,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
>   		return NULL;
>   	case TC_ACT_REDIRECT:
>   		/* No need to push/pop skb's mac_header here on egress! */
> +		skb_set_redirected(skb, false);
>   		skb_do_redirect(skb);
>   		*ret = NET_XMIT_SUCCESS;
>   		return NULL;
> @@ -4963,6 +4964,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
>   		 * redirecting to another netdev
>   		 */
>   		__skb_push(skb, skb->mac_len);
> +		skb_set_redirected(skb, true);
>   		if (skb_do_redirect(skb) == -EAGAIN) {
>   			__skb_pull(skb, skb->mac_len);
>   			*another = true;

I'm not sure I follow the logic in the two cases here.. why mark it in one but
not the other? Both are used in practice to recircle back to ingress. Also, this
is not BPF specific.. same goes for other subsystems that recircle from TX into
RX where they will still go into generic XDP (think of action attached to actual
qdisc as an example).

> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index a3b37d88800e..a1bbaa8fd054 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -384,6 +384,7 @@ config NET_SCH_INGRESS
>   	depends on NET_CLS_ACT
>   	select NET_INGRESS
>   	select NET_EGRESS
> +	select NET_REDIRECT
>   	help
>   	  Say Y here if you want to use classifiers for incoming and/or outgoing
>   	  packets. This qdisc doesn't do anything else besides running classifiers,
> 
> 

