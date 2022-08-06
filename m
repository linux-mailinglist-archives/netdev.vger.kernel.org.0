Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA10F58B320
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 02:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiHFAz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 20:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiHFAz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 20:55:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715A9193DF
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 17:55:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D1755CE2B70
        for <netdev@vger.kernel.org>; Sat,  6 Aug 2022 00:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B03C433D6;
        Sat,  6 Aug 2022 00:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659747354;
        bh=YLyEVaubzHlRnqgEO7orc32CWxAz81Gpn8Qssyoi9wQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IqeA2U/8Y+CGOQHW8wOw3H6gLS50xOyImRylJjIN1cuSBjsGHzHxUCGKSVfIuzUvH
         AyPQio+0/uG16DIpQFtW3V2KQcYSr1yOGJQG4iAk+vJdegrq6sRdHt4EsOKeXXNVFI
         Rj2G7ugoHxMew3b+IlZJsHCvB6GWxZYS3yuh2mQ5USrn2XiMljYygMjM938tWJaWL8
         xYWUKE7txTPyQbvHoW1IAUcqeO3qtH2MMZ526Yss+MVsGq/2p1myYr+Pe1E1dYRP8f
         Wc6HtZq+g2IxrBaOCesNpWaIFNL1+L9WM6O3EBLJ8WMSv/S6Zb8ijbduQUgBahtog3
         N+eF/nZncoglg==
Date:   Fri, 5 Aug 2022 17:55:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Wachowski <maciej.wachowski@codilime.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Cannot change hash functions or use static not random keys on
 E810
Message-ID: <20220805175553.426f39d6@kernel.org>
In-Reply-To: <CAPYuOdw380Ro1_dGm0usewPGaJJFLExM4XYuianBhExNOqg=aw@mail.gmail.com>
References: <CAPYuOdx2jPwOWYPzo5z-xWQtEmNHO==pAKH63xxaOtG6JbGxdw@mail.gmail.com>
        <CAPYuOdw380Ro1_dGm0usewPGaJJFLExM4XYuianBhExNOqg=aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Aug 2022 16:00:43 +0200 Maciej Wachowski wrote:
> I am not able to change hash function on Intel E810 card using ethtool:
> 
> RSS hash function:
>     toeplitz: on
>     xor: off
>     crc32: off
> 
> root@my_server:~# ethtool -X ens802f0 hfunc xor
> Cannot set RX flow hash configuration: Operation not supported
> 
> I also tried with newest ethtool (5.18) and newest ice driver (1.9.11)
> but with no success.
> Do you have any information on how to change hash func using ethtool
> or if it is possible?

ETH_RSS_HASH_XOR is usually implemented by devices doing hashing 
in microcode because it requires fewer cycles. Looking at the driver
ice (E810) only supports Toeplitz which is probably the best choice 
of the 3, anyway.
