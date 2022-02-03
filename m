Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB454A815A
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 10:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbiBCJUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 04:20:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237231AbiBCJUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 04:20:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643880005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ed91ejT6Qv4UYNQcsSF04ux9NYnxjovxP50xRrIa5Z4=;
        b=Dgoi/t32U9i0+mz3y3WXzj9EMiJs8b5PFIWUaPizdmICee2GKvl//6MgNZfGG3iexOcsy1
        +YkZN1i3bz6pMEh8dW/60HOXXy25EFUhT6ql5x0GCPvjoppkm4B/zICZ9BtckIYTbyOXkj
        GrhHWLDo6CJf4bUlcM7GcxcCd3Nl4ls=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-hLKh89zuP262HpXzlji1ug-1; Thu, 03 Feb 2022 04:20:04 -0500
X-MC-Unique: hLKh89zuP262HpXzlji1ug-1
Received: by mail-qk1-f197.google.com with SMTP id n3-20020ae9c303000000b00477e4f3dfd2so1645043qkg.21
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 01:20:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Ed91ejT6Qv4UYNQcsSF04ux9NYnxjovxP50xRrIa5Z4=;
        b=Wx7QsXDiNgniao1/yCj9DMu65h75zK33CZ7fltWMWqCZLkx+6ize3YWU5TgxckpJYl
         9Up79Y0pvW5hg8aKEn1DFng38SGr52h+8Fbz5dfeKywir7XttFmyAYogkNWTi6ak7mte
         TUg5AkeXH5Leu6xqd8NQ2QytXbScxs/u8nLCuFG/mtX83WBwbubwfxIgTvjEsfmZL7Sk
         dNnNViFjAdIQ/bDA4oydSUPxlif90PLZQLV0q7jSuPl7elUVKgu3u6anFppyvCafLUfz
         UjrEG5+uxT4AS+X9CW1OpVRajF6LaFLLKKBIAF3L8i7+zjG/eCzbXdz7Yh/RieaG/QJI
         /sTA==
X-Gm-Message-State: AOAM5318RkIz1OjlzoR98zhpGWAKfXeW6T30esCZZ/cyAi6S24hyPS9M
        psdigT35XU/stKT/qYjU/jbuWZwrJCKscb4L1ngHQ3TtcaIe4YOLgQG0hsB/8/Lk+xKkvMTyxOX
        oWcWAKMZiT8r2DM7b
X-Received: by 2002:ac8:5d8e:: with SMTP id d14mr24937014qtx.278.1643880003673;
        Thu, 03 Feb 2022 01:20:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzbFotJqi5EwUrmENwVhzHu9Ul5n+RCC+kx81MGE/ZasS1pWzRd25yWwywWi6Ry0U9dGHXiwA==
X-Received: by 2002:ac8:5d8e:: with SMTP id d14mr24937001qtx.278.1643880003461;
        Thu, 03 Feb 2022 01:20:03 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id o3sm6193782qtw.3.2022.02.03.01.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 01:20:03 -0800 (PST)
Message-ID: <99e23f620a798d6cfb9c9b20fb37ba6ba8137a05.camel@redhat.com>
Subject: Re: [PATCH net-next 06/15] ipv6/gro: insert temporary HBH/jumbo
 header
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Date:   Thu, 03 Feb 2022 10:19:59 +0100
In-Reply-To: <20220203015140.3022854-7-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
         <20220203015140.3022854-7-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-02 at 17:51 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Following patch will add GRO_IPV6_MAX_SIZE, allowing gro to build
> BIG TCP ipv6 packets (bigger than 64K).
> 
> This patch changes ipv6_gro_complete() to insert a HBH/jumbo header
> so that resulting packet can go through IPv6/TCP stacks.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv6/ip6_offload.c | 32 ++++++++++++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> index d37a79a8554e92a1dcaa6fd023cafe2114841ece..dac6f60436e167a3d979fef02f25fc039c6ed37d 100644
> --- a/net/ipv6/ip6_offload.c
> +++ b/net/ipv6/ip6_offload.c
> @@ -318,15 +318,43 @@ static struct sk_buff *ip4ip6_gro_receive(struct list_head *head,
>  INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
>  {
>  	const struct net_offload *ops;
> -	struct ipv6hdr *iph = (struct ipv6hdr *)(skb->data + nhoff);
> +	struct ipv6hdr *iph;
>  	int err = -ENOSYS;
> +	u32 payload_len;
>  
>  	if (skb->encapsulation) {
>  		skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IPV6));
>  		skb_set_inner_network_header(skb, nhoff);
>  	}
>  
> -	iph->payload_len = htons(skb->len - nhoff - sizeof(*iph));
> +	payload_len = skb->len - nhoff - sizeof(*iph);
> +	if (unlikely(payload_len > IPV6_MAXPLEN)) {
> +		struct hop_jumbo_hdr *hop_jumbo;
> +		int hoplen = sizeof(*hop_jumbo);
> +
> +		/* Move network header left */
> +		memmove(skb_mac_header(skb) - hoplen, skb_mac_header(skb),
> +			skb->transport_header - skb->mac_header);

I was wondering if we should check for enough headroom and what about
TCP over UDP tunnel, then I read the next patch ;) 

I think a comment here referring to the constraint enforced by
skb_gro_receive() could help, or perhaps squashing the 2 patches?!?

Thanks!

Paolo

