Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7164DE1AD
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 20:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240319AbiCRTVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 15:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbiCRTVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:21:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9BC2E8420;
        Fri, 18 Mar 2022 12:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC0E061BA0;
        Fri, 18 Mar 2022 19:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117C1C340ED;
        Fri, 18 Mar 2022 19:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647631223;
        bh=MiiDT3FzEK6tLZQja3IOFckulnk8Uz/WOuBFOepDFvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g3qYN2Z29gNmucFkvsCvmIHRdNVrKjwLWppWY8aTWhcxjxRaTlR9ZFbksLwcgCtTK
         QPQXMgdvHzmeGhh3GrcQcScoKZ3B+k6ZxUk/FWR1KJvdYyK7Oli5I1CajCzfhRXO4T
         wEQtsdY0T1ddr7Ef0+4SSutSADUhm/yqXmpT5yk+IZo8C7a0y2Re1R6N8Fka3wTAoB
         pBtx/f0oZ+DaMvANz1kHGhhC8L8fzb3R4ehzEVEewjx+TqArobwBAOMmr7+TbaYGBq
         A3IxDMQsGLFDHjQW5qamQgQAlglF2zTp8PSxUX9k/qc1EC7BZcMHljmjkdjANEBAQ+
         wqGGX/BrqNvRw==
Date:   Fri, 18 Mar 2022 12:20:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org,
        opendmb@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bcmgenet: Use stronger register read/writes to
 assure ordering
Message-ID: <20220318122017.24341eb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <472540d2-3a61-beca-70df-d5f152e1cfd1@gmail.com>
References: <20220310045358.224350-1-jeremy.linton@arm.com>
        <f831a4c6-58c9-20bd-94e8-e221369609e8@gmail.com>
        <de28c0ec-56a7-bfff-0c41-72aeef097ee3@arm.com>
        <2167202d-327c-f87d-bded-702b39ae49e1@gmail.com>
        <CALeDE9MerhZWwJrkg+2OEaQ=_9C6PHYv7kQ_XEQ6Kp7aV2R31A@mail.gmail.com>
        <472540d2-3a61-beca-70df-d5f152e1cfd1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 12:01:20 -0700 Florian Fainelli wrote:
> Given the time crunch we should go with Jeremy's patch that uses
> stronger I/O access method and then we will work with Jeremy offline to
> make sure that our version of GCC12 is exactly the same as his, as well
> as the compiler options (like -mtune/-march) to reproduce this.
> 
> If we believe this is only a problem with GCC12 and 5.17 in Fedora, then
> I would be inclined to remove the Fixes tag such that when we come up
> with a more localized solution we do not have to revert "net: bcmgenet:
> Use stronger register read/writes to assure ordering" from stable
> branches. This would be mostly a courtesy to our future selves, but an
> argument could be made that this probably has always existed, and that
> different compilers could behave more or less like GCC12.

Are you expecting this patch to make 5.17? If Linus cuts final this
weekend, as he most likely will, unless we do something special the
patch in question will end up getting merged during the merge window.
Without the Fixes tag you'll need to manually instruct Greg to pull 
it in. Is that the plan?
