Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3003AFBEC
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 06:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhFVEaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 00:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhFVEaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 00:30:23 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7499FC061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 21:28:07 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 6-20020a9d07860000b02903e83bf8f8fcso19949419oto.12
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 21:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pSefQczLxOE9Xar6/6JZIDthzcM4JCQ+EHyb7jdZHDQ=;
        b=RZpBgBPMOwsM8ztD/8xZr8BiQs8ZnibOJsz6nOfslPsRgv2aIQxDoBTW4SDTS1T0Q4
         XamrppiL2aEbc1io/U1burngrkM4xWv2bEXc3qQpra5AbwV7zpmC1OelmYXV5ak6mexn
         GDdS7Rtln7vMe/Q1Mx9m9a/ojZUMXkOBA2fvoosulAkIwD99M+axLOc65wnbEwKXfJgw
         E+65Fih4mie4/lXDUqi6CxZKW7iaJGsUSx5Kh/xLdhTUSpcLsjulGRSm4kPWO62skbPJ
         lN7PM/TLJm9l7kLo0pvnHtCKnJjzK83j8ejHlet4/1LTEY9n9E3JJ7TWZPXl5JVuIXQY
         72WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pSefQczLxOE9Xar6/6JZIDthzcM4JCQ+EHyb7jdZHDQ=;
        b=EswYhdVAWhTEF7OFEMW1wQII0+5am1qMr/XMfUTKMiNAgqVoPG/R41V13YvRjB7cEW
         9ssIlgehfvBdlUV65+7hRZoF+7YJ+JAYaCzXBntGbowlXfBY0dDHGykvcR9/bKw51h3g
         Nym5BC+WUxh1bmw5zQ3N1/+1oSGdRdFjY3OkvpOmvV1NJ+bsFaCVKpYe1rlQ+8pANcyp
         gF3mUVZphujxvYzZBkRu4q1zHow+spOnik4VZmhThXRoGj+gUU4HU4lGMUWlTrfpYz71
         HuR3SJUgOjUKXAgA6OTxQHA8L77pV9Cju8FctUDpl8Io7xKCcRZXdJK1eSM4GsWQc0wG
         Exow==
X-Gm-Message-State: AOAM533ikZw6lfnuk4mY4WnUA2PuaDx9l83wMK5quXiSIGAcoIl6NXMX
        kNluS4q7B4JytD+LhFaOitI=
X-Google-Smtp-Source: ABdhPJy9RXy72pS3tMYevKL9XBaTjJVEUgnyTfrKwtdSBlAHZwFW2WuGiEqBQ6POpxqjMcTIQxnSMw==
X-Received: by 2002:a05:6830:1e70:: with SMTP id m16mr1385074otr.96.1624336086897;
        Mon, 21 Jun 2021 21:28:06 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id y66sm266362ooa.48.2021.06.21.21.28.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 21:28:06 -0700 (PDT)
Subject: Re: [PATCH net] ip6_tunnel: fix GRE6 segmentation
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, vfedorenko@novek.ru
References: <20210622015254.1967716-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <33902f8c-e14a-7dc6-9bde-4f8f168505b5@gmail.com>
Date:   Mon, 21 Jun 2021 22:28:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622015254.1967716-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/21 7:52 PM, Jakub Kicinski wrote:
> Commit 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
> moved assiging inner_ipproto down from ipxip6_tnl_xmit() to
> its callee ip6_tnl_xmit(). The latter is also used by GRE.
> 
> Since commit 38720352412a ("gre: Use inner_proto to obtain inner
> header protocol") GRE had been depending on skb->inner_protocol
> during segmentation. It sets it in gre_build_header() and reads
> it in gre_gso_segment(). Changes to ip6_tnl_xmit() overwrite
> the protocol, resulting in GSO skbs getting dropped.
> 
> Note that inner_protocol is a union with inner_ipproto,
> GRE uses the former while the change switched it to the latter
> (always setting it to just IPPROTO_GRE).
> 
> Restore the original location of skb_set_inner_ipproto(),
> it is unclear why it was moved in the first place.
> 
> Fixes: 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ipv6/ip6_tunnel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

would be good to capture the GRE use case that found the bug and the
MPLS version as test cases under tools/testing/selftests/net. Both
should be doable using namespaces.

