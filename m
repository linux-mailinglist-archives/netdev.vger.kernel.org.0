Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61579222C10
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbgGPTmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:42:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:44586 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728788AbgGPTmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:42:40 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jw9m9-0004Nc-Hi; Thu, 16 Jul 2020 21:42:37 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jw9m9-000G61-BX; Thu, 16 Jul 2020 21:42:37 +0200
Subject: Re: [PATCH bpf-next v3 2/4] bpf: allow to specify ifindex for skb in
 bpf_prog_test_run_skb
To:     Dmitry Yakunin <zeil@yandex-team.ru>, alexei.starovoitov@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
References: <20200715195132.4286-1-zeil@yandex-team.ru>
 <20200715195132.4286-3-zeil@yandex-team.ru>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <08c685b1-da91-9815-29fe-c7b8f3edc3c1@iogearbox.net>
Date:   Thu, 16 Jul 2020 21:42:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200715195132.4286-3-zeil@yandex-team.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25875/Thu Jul 16 16:46:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/20 9:51 PM, Dmitry Yakunin wrote:
> Now skb->dev is unconditionally set to the loopback device in current net
> namespace. But if we want to test bpf program which contains code branch
> based on ifindex condition (eg filters out localhost packets) it is useful
> to allow specifying of ifindex from userspace. This patch adds such option
> through ctx_in (__sk_buff) parameter.
> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> ---
>   net/bpf/test_run.c                               | 22 ++++++++++++++++++++--
>   tools/testing/selftests/bpf/prog_tests/skb_ctx.c |  5 +++++
>   2 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 0c3283d..0e92973 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -310,6 +310,12 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
>   	/* priority is allowed */
>   
>   	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, priority),
> +			   offsetof(struct __sk_buff, ifindex)))
> +		return -EINVAL;
> +
> +	/* ifindex is allowed */
> +
> +	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, ifindex),
>   			   offsetof(struct __sk_buff, cb)))
>   		return -EINVAL;
>   
> @@ -364,6 +370,7 @@ static void convert_skb_to___skb(struct sk_buff *skb, struct __sk_buff *__skb)
>   
>   	__skb->mark = skb->mark;
>   	__skb->priority = skb->priority;
> +	__skb->ifindex = skb->dev->ifindex;
>   	__skb->tstamp = skb->tstamp;
>   	memcpy(__skb->cb, &cb->data, QDISC_CB_PRIV_LEN);
>   	__skb->wire_len = cb->pkt_len;
> @@ -374,6 +381,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>   			  union bpf_attr __user *uattr)
>   {
>   	bool is_l2 = false, is_direct_pkt_access = false;
> +	struct net *net = current->nsproxy->net_ns;
> +	struct net_device *dev = net->loopback_dev;
>   	u32 size = kattr->test.data_size_in;
>   	u32 repeat = kattr->test.repeat;
>   	struct __sk_buff *ctx = NULL;
> @@ -415,7 +424,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>   		kfree(ctx);
>   		return -ENOMEM;
>   	}
> -	sock_net_set(sk, current->nsproxy->net_ns);
> +	sock_net_set(sk, net);
>   	sock_init_data(NULL, sk);
>   
>   	skb = build_skb(data, 0);
> @@ -429,7 +438,14 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>   
>   	skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
>   	__skb_put(skb, size);
> -	skb->protocol = eth_type_trans(skb, current->nsproxy->net_ns->loopback_dev);
> +	if (ctx && ctx->ifindex > 1) {
> +		dev = dev_get_by_index(net, ctx->ifindex);
> +		if (!dev) {
> +			ret = -ENODEV;
> +			goto out;
> +		}
> +	}
> +	skb->protocol = eth_type_trans(skb, dev);
>   	skb_reset_network_header(skb);
>   
>   	switch (skb->protocol) {
> @@ -481,6 +497,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>   		ret = bpf_ctx_finish(kattr, uattr, ctx,
>   				     sizeof(struct __sk_buff));
>   out:

Overall this looks good. One small note is that dev_get_by_index() will hold the device
for the entire test duration preventing to release it from user side, but I think in this
context it's an acceptable trade-off.

> +	if (dev && dev != net->loopback_dev)
> +		dev_put(dev);
>   	kfree_skb(skb);
>   	bpf_sk_storage_free(sk);
>   	kfree(sk);
