Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAC72BA498
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 09:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgKTI0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 03:26:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725805AbgKTI0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 03:26:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605860812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U2YimWpDUws6BcP/KA0i+1IY7B/VrO0r4M6jQRKX2a0=;
        b=Js2zSvs312gkLv1XKF02qhYE4RC9JB9oX5+eeqrTre8PehE1/t6yAhxO0NIehAphrUn4ow
        MQF+Ml1aIOM7nPF/crVTOJCuQXJBYdUEZuFNk5X5uYeggbM/gf3AgkeGJhUuScweVVsvcT
        6Ya6/Ebcj2zsaEuSyy6+l9663zz5SS8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-2R1Y9FVCO6Owey6T2y9aKQ-1; Fri, 20 Nov 2020 03:26:50 -0500
X-MC-Unique: 2R1Y9FVCO6Owey6T2y9aKQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17F7C1005D69;
        Fri, 20 Nov 2020 08:26:48 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5AA91002393;
        Fri, 20 Nov 2020 08:26:39 +0000 (UTC)
Date:   Fri, 20 Nov 2020 09:26:38 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V6 2/7] bpf: fix bpf_fib_lookup helper MTU
 check for SKB ctx
Message-ID: <20201120092638.14e09025@carbon>
In-Reply-To: <160571337537.2801246.15228178384451037535.stgit@firesoul>
References: <160571331409.2801246.11527010115263068327.stgit@firesoul>
        <160571337537.2801246.15228178384451037535.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 16:29:35 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> BPF end-user on Cilium slack-channel (Carlo Carraro) wants to use
> bpf_fib_lookup for doing MTU-check, but *prior* to extending packet size,
> by adjusting fib_params 'tot_len' with the packet length plus the
> expected encap size. (Just like the bpf_check_mtu helper supports). He
> discovered that for SKB ctx the param->tot_len was not used, instead
> skb->len was used (via MTU check in is_skb_forwardable()).
> 
> Fix this by using fib_params 'tot_len' for MTU check.  If not provided
> (e.g. zero) then keep existing behaviour intact.

Carlo pointed out (in slack) that the logic is not correctly
implemented in this patch.

I will send a V7.


> Fixes: 4c79579b44b1 ("bpf: Change bpf_fib_lookup to return lookup status")
> Reported-by: Carlo Carraro <colrack@gmail.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  net/core/filter.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 1ee97fdeea64..ae1fe8e6069a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5567,10 +5567,20 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
>  
>  	if (!rc) {
>  		struct net_device *dev;
> +		u32 mtu;
>  
>  		dev = dev_get_by_index_rcu(net, params->ifindex);
> -		if (!is_skb_forwardable(dev, skb))
> +		mtu = dev->mtu;
> +
> +		/* Using tot_len for L3 MTU check if provided by user. Notice at
> +		 * this TC cls_bpf level skb->len contains L2 size, but
> +		 * is_skb_forwardable takes that into account.
> +		 */
> +		if (params->tot_len > mtu) {
>  			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
> +		} else if (!is_skb_forwardable(dev, skb)) {
> +			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
> +		}
>  	}
>  
>  	return rc;

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

