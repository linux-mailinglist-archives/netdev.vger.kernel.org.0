Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1481F581DBA
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 04:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240119AbiG0Cwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 22:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiG0Cwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 22:52:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018963B96B;
        Tue, 26 Jul 2022 19:52:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9463F61761;
        Wed, 27 Jul 2022 02:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E95C433D6;
        Wed, 27 Jul 2022 02:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658890352;
        bh=mOvAqtymjKTyNB33hg2ZKI/KGchB0ZSy5/mlAYTBUOA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NiMqKvPl/nfHT0J/79eWG9MQcSvoCr/GfTZfPO5Y4E0dmORqA4TuvLHFCNFM9kop+
         juo3Nj/x196GIHtKN7+tkp3imeXXdGaS8VP25mdKZaTO3GqR4UNBBknJlvbLEOG5s3
         Gj3Os8kZJthXVknYUaY4zKJzOSgZbgnaYyFndF7AzyBi7MbWDRnumqsrD3ikIOxoO8
         v6flBlepBQyWY1pfkUbJIoSKi1KbstGCaoBqxjeW3sx8UeTqYbP9r+14C/dQ9/j5oL
         pSC96vJ0XqHL0kdFcWAT+93nswod7CfsP2OF2Kuvfx6SWUt1Im9g6LuHLuEMH6oTs1
         15Gfk+jeTf+7w==
Date:   Tue, 26 Jul 2022 19:52:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 6/6] net/ipv6: sr: Switch to using crypto_pool
Message-ID: <20220726195230.1ba174fb@kernel.org>
In-Reply-To: <20220726201600.1715505-7-dima@arista.com>
References: <20220726201600.1715505-1-dima@arista.com>
        <20220726201600.1715505-7-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 21:16:00 +0100 Dmitry Safonov wrote:
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

Build problems on allmodconfig:

ERROR: modpost: "crypto_pool_reserve_scratch" [net/ipv6/ipv6.ko] undefined!
