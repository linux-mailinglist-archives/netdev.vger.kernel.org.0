Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D4872444
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 04:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbfGXCMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 22:12:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726544AbfGXCMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 22:12:02 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C02D43365B;
        Wed, 24 Jul 2019 02:12:01 +0000 (UTC)
Received: from [10.72.12.167] (ovpn-12-167.pek2.redhat.com [10.72.12.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE00060BEC;
        Wed, 24 Jul 2019 02:11:59 +0000 (UTC)
Subject: Re: [PATCH v2] tun: mark small packets as owned by the tap sock
To:     Alexis Bauvin <abauvin@scaleway.com>, stephen@networkplumber.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190723142301.39568-1-abauvin@scaleway.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <78872b4b-1748-83c8-7115-1f2527f8b572@redhat.com>
Date:   Wed, 24 Jul 2019 10:11:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723142301.39568-1-abauvin@scaleway.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 24 Jul 2019 02:12:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/23 下午10:23, Alexis Bauvin wrote:
> - v1 -> v2: Move skb_set_owner_w to __tun_build_skb to reduce patch size
>
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


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/tun.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 3d443597bd04..db16d7a13e00 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1599,7 +1599,8 @@ static bool tun_can_build_skb(struct tun_struct *tun, struct tun_file *tfile,
>   	return true;
>   }
>   
> -static struct sk_buff *__tun_build_skb(struct page_frag *alloc_frag, char *buf,
> +static struct sk_buff *__tun_build_skb(struct tun_file *tfile,
> +				       struct page_frag *alloc_frag, char *buf,
>   				       int buflen, int len, int pad)
>   {
>   	struct sk_buff *skb = build_skb(buf, buflen);
> @@ -1609,6 +1610,7 @@ static struct sk_buff *__tun_build_skb(struct page_frag *alloc_frag, char *buf,
>   
>   	skb_reserve(skb, pad);
>   	skb_put(skb, len);
> +	skb_set_owner_w(skb, tfile->socket.sk);
>   
>   	get_page(alloc_frag->page);
>   	alloc_frag->offset += buflen;
> @@ -1686,7 +1688,8 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
>   	 */
>   	if (hdr->gso_type || !xdp_prog) {
>   		*skb_xdp = 1;
> -		return __tun_build_skb(alloc_frag, buf, buflen, len, pad);
> +		return __tun_build_skb(tfile, alloc_frag, buf, buflen, len,
> +				       pad);
>   	}
>   
>   	*skb_xdp = 0;
> @@ -1723,7 +1726,7 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
>   	rcu_read_unlock();
>   	local_bh_enable();
>   
> -	return __tun_build_skb(alloc_frag, buf, buflen, len, pad);
> +	return __tun_build_skb(tfile, alloc_frag, buf, buflen, len, pad);
>   
>   err_xdp:
>   	put_page(alloc_frag->page);
