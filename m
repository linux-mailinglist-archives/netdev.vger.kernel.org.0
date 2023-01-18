Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D0E67121D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjARDtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjARDtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:49:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25A15087D;
        Tue, 17 Jan 2023 19:48:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CC4261615;
        Wed, 18 Jan 2023 03:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05909C433D2;
        Wed, 18 Jan 2023 03:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674013738;
        bh=3KxMIHARERjccjn87E5q/Isvv9axqXiuByE+8f1JDvM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QFnlsWY7Pn/7SjXTN36JFKLLFLwc93CDI385dWSeQTNxGVD/QWThZB5BHAm+iuSo8
         I497yK2GQfuoSyzwbp2de9sO9EE8nIEOh/o/NEDuw6H7rc7y0tFYde/kKyglZWbc2k
         dl+23TPR8iO908F4rZMXxZ5+rGe9CTzjbuyKP/5+TY8FTrw01l/jDTdzJWR33AM3gP
         LFlJ2HchCCKVqLlSCDzXDIiZkE/fa7Ss9g1Y72ZJGntmqDVnjr0Ho7u+htLEse/cHe
         B2jkOE0BB1Xdiib/haXO5XAgcxnlQKx/XWNzNTF8gu7Od9+6t7CrAv2xdc1PAmnEne
         daFORN5Pc1dWg==
Date:   Tue, 17 Jan 2023 19:48:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 3/4] crypto/net/ipv6: sr: Switch to using crypto_pool
Message-ID: <20230117194856.55ec5458@kernel.org>
In-Reply-To: <20230116201458.104260-4-dima@arista.com>
References: <20230116201458.104260-1-dima@arista.com>
        <20230116201458.104260-4-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Jan 2023 20:14:57 +0000 Dmitry Safonov wrote:
> The conversion to use crypto_pool has the following upsides:
> - now SR uses asynchronous API which may potentially free CPU cycles and
>   improve performance for of CPU crypto algorithm providers;
> - hash descriptors now don't have to be allocated on boot, but only at
>   the moment SR starts using HMAC and until the last HMAC secret is
>   deleted;
> - potentially reuse ahash_request(s) for different users
> - allocate only one per-CPU scratch buffer rather than a new one for
>   each user
> - have a common API for net/ users that need ahash on RX/TX fast path

breaks allmodconfig build:

ERROR: modpost: "seg6_hmac_init" [net/ipv6/ipv6.ko] undefined!
make[2]: *** [../scripts/Makefile.modpost:138: Module.symvers] Error 1
make[1]: *** [/home/nipa/net-next/Makefile:1960: modpost] Error 2
make: *** [Makefile:242: __sub-make] Error 2
