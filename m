Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C1C719CA
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 15:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732802AbfGWNx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 09:53:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61283 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbfGWNxZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 09:53:25 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF8688553A;
        Tue, 23 Jul 2019 13:53:24 +0000 (UTC)
Received: from [10.72.12.26] (ovpn-12-26.pek2.redhat.com [10.72.12.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CAEE861377;
        Tue, 23 Jul 2019 13:53:20 +0000 (UTC)
Subject: Re: [PATCH v1] tun: mark small packets as owned by the tap sock
To:     Alexis Bauvin <abauvin@scaleway.com>, stephen@networkplumber.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190723130151.36745-1-abauvin@scaleway.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <359225ef-9bc2-220b-ec93-cf671b705e65@redhat.com>
Date:   Tue, 23 Jul 2019 21:53:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723130151.36745-1-abauvin@scaleway.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 23 Jul 2019 13:53:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/23 下午9:01, Alexis Bauvin wrote:
> Small packets going out of a tap device go through an optimized code
> path that uses build_skb() rather than sock_alloc_send_pskb(). The
> latter calls skb_set_owner_w(), but the small packet code path does not.
>
> The net effect is that small packets are not owned by the userland
> application's socket (e.g. QEMU), while large packets are.
> This can be seen with a TCP session, where packets are not owned when
> the window size is small enough (around PAGE_SIZE), while they are once
> the window grows (note that this requires the host to support virtio
> tso for the guest to offload segmentation).
> All this leads to inconsistent behaviour in the kernel, especially on
> netfilter modules that uses sk->socket (e.g. xt_owner).
>
> Signed-off-by: Alexis Bauvin <abauvin@scaleway.com>
> Fixes: 66ccbc9c87c2 ("tap: use build_skb() for small packet")
> ---
>   drivers/net/tun.c | 71 ++++++++++++++++++++++++-----------------------
>   1 file changed, 37 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 3d443597bd04..ac56b6a29eb2 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1656,6 +1656,7 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
>   {
>   	struct page_frag *alloc_frag = &current->task_frag;
>   	struct bpf_prog *xdp_prog;
> +	struct sk_buff *skb;
>   	int buflen = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>   	char *buf;
>   	size_t copied;
> @@ -1686,44 +1687,46 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
>   	 */
>   	if (hdr->gso_type || !xdp_prog) {
>   		*skb_xdp = 1;
> -		return __tun_build_skb(alloc_frag, buf, buflen, len, pad);
> -	}
> -
> -	*skb_xdp = 0;
> +	} else {
> +		*skb_xdp = 0;
>   
> -	local_bh_disable();
> -	rcu_read_lock();
> -	xdp_prog = rcu_dereference(tun->xdp_prog);
> -	if (xdp_prog) {
> -		struct xdp_buff xdp;
> -		u32 act;
> -
> -		xdp.data_hard_start = buf;
> -		xdp.data = buf + pad;
> -		xdp_set_data_meta_invalid(&xdp);
> -		xdp.data_end = xdp.data + len;
> -		xdp.rxq = &tfile->xdp_rxq;
> -
> -		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> -		if (act == XDP_REDIRECT || act == XDP_TX) {
> -			get_page(alloc_frag->page);
> -			alloc_frag->offset += buflen;
> +		local_bh_disable();
> +		rcu_read_lock();
> +		xdp_prog = rcu_dereference(tun->xdp_prog);
> +		if (xdp_prog) {
> +			struct xdp_buff xdp;
> +			u32 act;
> +
> +			xdp.data_hard_start = buf;
> +			xdp.data = buf + pad;
> +			xdp_set_data_meta_invalid(&xdp);
> +			xdp.data_end = xdp.data + len;
> +			xdp.rxq = &tfile->xdp_rxq;
> +
> +			act = bpf_prog_run_xdp(xdp_prog, &xdp);
> +			if (act == XDP_REDIRECT || act == XDP_TX) {
> +				get_page(alloc_frag->page);
> +				alloc_frag->offset += buflen;
> +			}
> +			err = tun_xdp_act(tun, xdp_prog, &xdp, act);
> +			if (err < 0)
> +				goto err_xdp;
> +			if (err == XDP_REDIRECT)
> +				xdp_do_flush_map();
> +			if (err != XDP_PASS)
> +				goto out;
> +
> +			pad = xdp.data - xdp.data_hard_start;
> +			len = xdp.data_end - xdp.data;
>   		}
> -		err = tun_xdp_act(tun, xdp_prog, &xdp, act);
> -		if (err < 0)
> -			goto err_xdp;
> -		if (err == XDP_REDIRECT)
> -			xdp_do_flush_map();
> -		if (err != XDP_PASS)
> -			goto out;
> -
> -		pad = xdp.data - xdp.data_hard_start;
> -		len = xdp.data_end - xdp.data;
> +		rcu_read_unlock();
> +		local_bh_enable();
>   	}
> -	rcu_read_unlock();
> -	local_bh_enable();
>   
> -	return __tun_build_skb(alloc_frag, buf, buflen, len, pad);
> +	skb = __tun_build_skb(alloc_frag, buf, buflen, len, pad);
> +	if (skb)
> +		skb_set_owner_w(skb, tfile->socket.sk);
> +	return skb;
>   
>   err_xdp:
>   	put_page(alloc_frag->page);


To reduce the change set, anyhow you can move the skb_set_owner_w() to 
__tun_build_skb()?

Thanks


