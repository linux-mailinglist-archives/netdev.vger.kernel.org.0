Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D563B2FDF
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 15:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhFXNS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 09:18:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229995AbhFXNS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 09:18:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624540567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W2La/+xWtGGFQc9oDSR6+JS3JSfliljWEcUewtoETmE=;
        b=Ry1dulidJsC6hh78ikrg/F6JZ5sshQOnIToK8rE05UpAliI0obU5wlteSxT0w6VL8B9np4
        JDrfy9i6lkSh6JVbaXaekzpJL0ipVBEp99NA0OBLbvhiNtpRB3wnJ/Jf2tB9bqULAcMych
        4EW8G38DxTai9LJKoqUBExKp5/yWscE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-S59wFjDTNs-HwGkutkgWog-1; Thu, 24 Jun 2021 09:16:03 -0400
X-MC-Unique: S59wFjDTNs-HwGkutkgWog-1
Received: by mail-wm1-f71.google.com with SMTP id f11-20020a05600c154bb02901e0210617aaso1494138wmg.1
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 06:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=W2La/+xWtGGFQc9oDSR6+JS3JSfliljWEcUewtoETmE=;
        b=lmAhaVvuKBS4ySIygGFpQ1UaqJWyNzXyqATPys/AvKaKK7nyRbZ1GJZFviW+6Dxhac
         rUGbihWKi/FijkMrcmkddLAJ1mXtalgzmYQfJPupSLsnDt3DyF3UwZpBNLxhQfXp3ICK
         ouQdF9O0P68IYQHYk0pb4frSR+2/j2pmJRKF8VM7WwLjtqFO03BqITWPUedltJ7B1XI+
         bEyA4I+6eTFIsBwSwgTmCHX/pnLGloTj2fe8/szhW1OzB2LPlQ3rtmZnGYiBU6eAK0Hi
         om4At8AhReDJSs8DpYiFuuaOCuKOxWtnLNACZV6JOtgCgH3g+qQFzA3R5IcI5Nntkrpj
         pVig==
X-Gm-Message-State: AOAM532FQ6ZsEgQmW9N0raSZVHafaebPvl4ihejwzE2HsyPLcM6n/LyV
        oJ2VaPII/gjwlTCv8x+gswxjtHzz+qnHmJDHteGAHNfMoeQU4ehSToYOLYgFXbmPAbfS7kxJMXt
        giXFDFhkRA+2TGyth
X-Received: by 2002:adf:fac4:: with SMTP id a4mr4561385wrs.189.1624540560894;
        Thu, 24 Jun 2021 06:16:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQrQKrFkaoyC/yMBOxqTinJ31ke59GrE34hCKRRUdvjJsKrRk82HnEFhz5mHIFUJi5Bhhemw==
X-Received: by 2002:adf:fac4:: with SMTP id a4mr4561368wrs.189.1624540560733;
        Thu, 24 Jun 2021 06:16:00 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-109-224.dyn.eolo.it. [146.241.109.224])
        by smtp.gmail.com with ESMTPSA id l12sm3240682wro.32.2021.06.24.06.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 06:16:00 -0700 (PDT)
Message-ID: <0b2713a4e53f68f2636687c8caeb5a20803a2a1a.camel@redhat.com>
Subject: Re: [PATCH v2 net] ipv6: fix out-of-bound access in ip6_parse_tlv()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tom Herbert <tom@herbertland.com>
Date:   Thu, 24 Jun 2021 15:15:59 +0200
In-Reply-To: <20210624100720.2310271-1-eric.dumazet@gmail.com>
References: <20210624100720.2310271-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-24 at 03:07 -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> First problem is that optlen is fetched without checking
> there is more than one byte to parse.
> 
> Fix this by taking care of IPV6_TLV_PAD1 before
> fetching optlen (under appropriate sanity checks against len)
> 
> Second problem is that IPV6_TLV_PADN checks of zero
> padding are performed before the check of remaining length.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: c1412fce7ecc ("net/ipv6/exthdrs.c: Strict PadN option checking")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Tom Herbert <tom@herbertland.com>
> ---
> v2: Removed not needed optlen assignment for IPV6_TLV_PAD1 handling,
>     added the Fixes: tag for first problem, feedback from Paolo, thanks !
> 
>  net/ipv6/exthdrs.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> index 6f7da8f3e2e5849f917853984c69bf02a0f1e27c..26882e165c9e37a105f988020031f03d6b1a5cf9 100644
> --- a/net/ipv6/exthdrs.c
> +++ b/net/ipv6/exthdrs.c
> @@ -135,18 +135,23 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
>  	len -= 2;
>  
>  	while (len > 0) {
> -		int optlen = nh[off + 1] + 2;
> -		int i;
> +		int optlen, i;
>  
> -		switch (nh[off]) {
> -		case IPV6_TLV_PAD1:
> -			optlen = 1;
> +		if (nh[off] == IPV6_TLV_PAD1) {
>  			padlen++;
>  			if (padlen > 7)
>  				goto bad;
> -			break;
> +			off++;
> +			len--;
> +			continue;
> +		}
> +		if (len < 2)
> +			goto bad;
> +		optlen = nh[off + 1] + 2;
> +		if (optlen > len)
> +			goto bad;
>  
> -		case IPV6_TLV_PADN:
> +		if (nh[off] == IPV6_TLV_PADN) {
>  			/* RFC 2460 states that the purpose of PadN is
>  			 * to align the containing header to multiples
>  			 * of 8. 7 is therefore the highest valid value.
> @@ -163,12 +168,7 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
>  				if (nh[off + i] != 0)
>  					goto bad;
>  			}
> -			break;
> -
> -		default: /* Other TLV code so scan list */
> -			if (optlen > len)
> -				goto bad;
> -
> +		} else {
>  			tlv_count++;
>  			if (tlv_count > max_count)
>  				goto bad;
> @@ -188,7 +188,6 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
>  				return false;
>  
>  			padlen = 0;
> -			break;
>  		}
>  		off += optlen;
>  		len -= optlen;

LGTM!

Reviewd-by: Paolo Abeni <pabeni@redhat.com>

