Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3C851213A
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbiD0RWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 13:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbiD0RWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 13:22:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B91843AEA;
        Wed, 27 Apr 2022 10:19:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E7141CE268F;
        Wed, 27 Apr 2022 17:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC4DC385A9;
        Wed, 27 Apr 2022 17:18:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="p09l6Q7k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651079933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IqWbKO2Ia/STBFbkXAEOKtQNiXVUT5pLqnszdw+gft0=;
        b=p09l6Q7kc1sMO44s2uZU3iEupjKNc188wYKquK0wKgnm1ZSxw3Sd4RKNItff4gd4bvmn1K
        7wN10NMegomBMrXSgvzCMM+YmFNvjlGFPLuKbvGhjLFwrk6r9wdc84pNepaox5C1/Ypxtg
        WcdcohwwbK0JjILJvMEn1WGbOaho+M0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3cdbf562 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 27 Apr 2022 17:18:53 +0000 (UTC)
Date:   Wed, 27 Apr 2022 19:18:48 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Willy Tarreau <w@1wt.eu>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/7] secure_seq: return the full 64-bit of the siphash
Message-ID: <Yml6+PKmxW7VSHch@zx2c4.com>
References: <20220427065233.2075-1-w@1wt.eu>
 <20220427065233.2075-2-w@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220427065233.2075-2-w@1wt.eu>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willy,

On Wed, Apr 27, 2022 at 08:52:27AM +0200, Willy Tarreau wrote:
> diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
> index d7d2495f83c2..5cea9ed9c773 100644
> --- a/include/net/secure_seq.h
> +++ b/include/net/secure_seq.h
> @@ -4,7 +4,7 @@
>  
>  #include <linux/types.h>
>  
> -u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
> +u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
>  u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
>  			       __be16 dport);
>  u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
> diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
> index 9b8443774449..2cdd43a63f64 100644
> --- a/net/core/secure_seq.c
> +++ b/net/core/secure_seq.c
> @@ -142,7 +142,7 @@ u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
>  }
>  EXPORT_SYMBOL_GPL(secure_tcp_seq);
>  
> -u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
> +u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
>  {
>  	net_secret_init();
>  	return siphash_3u32((__force u32)saddr, (__force u32)daddr,

Should you be doing the same with secure_ipv6_port_ephemeral() too? Why
the asymmetry?

Jason
