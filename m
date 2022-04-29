Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F109514DB3
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355372AbiD2Ooa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377786AbiD2Onu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:43:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19523616F;
        Fri, 29 Apr 2022 07:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E60DA612FD;
        Fri, 29 Apr 2022 14:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE52C385A4;
        Fri, 29 Apr 2022 14:38:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ob+GsNtH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651243133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gBoINb6VqhxEFMDsy+tLJx5YYgkBz4j/E+7Q8RoDinA=;
        b=ob+GsNtHoyWGdvkaA9cg2Pz8kMCKqECfoiz6h3wRdusGHbnLaD1jUnRukJlDxitQMo+NH6
        Mwz4CesyftB0ail99hig9dZd0eOnSXD0O+8ZXRB2r7PnXz1tp6b6C/YEEtBuRCTJBLjcCx
        JpKG0CaWe3BzL8bJK09H+42OOxiyOns=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8d2000c9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 29 Apr 2022 14:38:52 +0000 (UTC)
Date:   Fri, 29 Apr 2022 16:38:48 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Willy Tarreau <w@1wt.eu>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net 1/7] secure_seq: use the 64 bits of the siphash
 for port offset calculation
Message-ID: <Ymv4ePDDh3Sgg5Ok@zx2c4.com>
References: <20220428124001.7428-1-w@1wt.eu>
 <20220428124001.7428-2-w@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220428124001.7428-2-w@1wt.eu>
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

On Thu, Apr 28, 2022 at 02:39:55PM +0200, Willy Tarreau wrote:
> SipHash replaced MD5 in secure_ipv{4,6}_port_ephemeral() via commit
> 7cd23e5300c1 ("secure_seq: use SipHash in place of MD5"), but the output
> remained truncated to 32-bit only. In order to exploit more bits from the
> hash, let's make the functions return the full 64-bit of siphash_3u32().
> We also make sure the port offset calculation in __inet_hash_connect()
> remains done on 32-bit to avoid the need for div_u64_rem() and an extra
> cost on 32-bit systems.
> 
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
> Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
> Cc: Amit Klein <aksecurity@gmail.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  include/net/inet_hashtables.h |  2 +-
>  include/net/secure_seq.h      |  4 ++--
>  net/core/secure_seq.c         |  4 ++--
>  net/ipv4/inet_hashtables.c    | 10 ++++++----
>  net/ipv6/inet6_hashtables.c   |  4 ++--
>  5 files changed, 13 insertions(+), 11 deletions(-)

For the secure_seq parts:

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com> # For secure_seq.[ch]

Thanks,
Jason
