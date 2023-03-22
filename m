Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685156C539D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjCVSWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjCVSWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:22:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A266700A;
        Wed, 22 Mar 2023 11:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3508BCE1E91;
        Wed, 22 Mar 2023 18:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4E7C433EF;
        Wed, 22 Mar 2023 18:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679509313;
        bh=56JsGW5eCgfRalgGqJZl2yJHK9+3w9i1iVCL27D82zo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g3qHzmpbpvT8XIPS9j46XVIaGHj5vWsiWS2UQ8hf058wlkoMvgDqrjTSrvYisxFCS
         uHhftRiuL2IuajvAp4liukcQZ+/DwAEcUrcABUhmpYRYnK8FgHofjRGk9UhbtADHMA
         WGZDWPezQ5oIbqgR0oxQUjfiqE3eu2XSHvFd/OWzliigFfpm2j4lhtYM9Y504JPV4A
         E6KzEc7j5Az/HuR8qgvTMnw5ZfZmD7taO8TOCTtWAGEt10XBwi42WK6I3WaX6kASpM
         +U5vCs/Sd0ILsJOH8upSQQ3aOH/TPJ8kKEaWopot5AR8UnFdcGUenYVuXbiAMuFPmu
         /2wZRV1KPGhDw==
Date:   Wed, 22 Mar 2023 11:21:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: dsa: realtek: fix out-of-bounds access
Message-ID: <20230322112151.04f12a8e@kernel.org>
In-Reply-To: <e47793af-b409-5e88-c74c-73e76f5e11d1@pengutronix.de>
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
        <20230316210736.1910b195@kernel.org>
        <e47793af-b409-5e88-c74c-73e76f5e11d1@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 16:51:00 +0100 Ahmad Fatoum wrote:
> On 17.03.23 05:07, Jakub Kicinski wrote:
> > On Wed, 15 Mar 2023 14:09:15 +0100 Ahmad Fatoum wrote:  
> >> -	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
> >> +	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv) + var->chip_data_sz, GFP_KERNEL);  
> > 
> > size_add() ?
> > Otherwise some static checker is going to soon send us a patch saying
> > this can overflow. Let's save ourselves the hassle.  
> 
> The exact same line is already in realtek-smi. Would you prefer I send
> a follow-up patch for net-next which switches over both files to size_add
> or should I send a v2?

We can leave the existing code be, but use the helper in the new code
for v2
