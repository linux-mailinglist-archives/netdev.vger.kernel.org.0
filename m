Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D14C54204A
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385023AbiFHAUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588593AbiFGXyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:54:49 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 708E4197614;
        Tue,  7 Jun 2022 16:43:57 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 7F7EBFFB6C;
        Tue,  7 Jun 2022 23:43:56 +0000 (UTC)
Date:   Wed, 8 Jun 2022 01:43:54 +0200
From:   Max Staudt <max@enpas.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
Message-ID: <20220608014248.6e0045ae.max@enpas.org>
In-Reply-To: <20220607150614.6248c504@kernel.org>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-5-mailhol.vincent@wanadoo.fr>
        <CAMuHMdXkq7+yvD=ju-LY14yOPkiiHwL6H+9G-4KgX=GJjX=h9g@mail.gmail.com>
        <CAMZ6RqLEEHOZjrMH+-GLC--jjfOaWYOPLf+PpefHwy=cLpWTYg@mail.gmail.com>
        <20220607182216.5fb1084e.max@enpas.org>
        <20220607150614.6248c504@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jun 2022 15:06:14 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Tue, 7 Jun 2022 18:22:16 +0200 Max Staudt wrote:
> > > Honestly, I am totally happy to have the "default y" tag, the "if
> > > unsure, say Y" comment and the "select CAN_RX_OFFLOAD" all
> > > together.
> > > 
> > > Unless I am violating some kind of best practices, I prefer to
> > > keep it as-is. Hope this makes sense.    
> 
> AFAIU Linus likes for everything that results in code being added to
> the kernel to default to n. If the drivers hard-select that Kconfig
> why bother user with the question at all? My understanding is that
> Linus also likes to keep Kconfig as simple as possible.
> 
> > I wholeheartedly agree with Vincent's decision.
> > 
> > One example case would be users of my can327 driver, as long as it
> > is not upstream yet. They need to have RX_OFFLOAD built into their
> > distribution's can_dev.ko, otherwise they will have no choice but to
> > build their own kernel.  
> 
> Upstream mentioning out-of-tree modules may have the opposite effect 
> to what you intend :( Forgive my ignorance, what's the reason to keep
> the driver out of tree?

None, it's being upstreamed. But even with the best of intentions, it
has been in this process for a long time, and it's still going on!

For some reason, upstream tends to forget about everything that is not
upstream *yet*. I've also convinced Greg K-H to include the
N_DEVELOPMENT ldisc number for this very reason: To allow new drivers
(ldiscs in this case) to be developed comfortably out-of-tree before
they are upstreamed (and then assigned their own ldisc number).

It seems strange to me to magically build some extra features into
can_dev.ko, depending on whether some other .ko files are built in that
very same moment, or not. By "magically", I mean an invisible Kconfig
option. This is why I think Vincent's approach is best here, by making
the drivers a clearly visible subset of the RX_OFFLOAD option in
Kconfig, and RX_OFFLOAD user-selectable.


How about making RX_OFFLOAD a separate .ko file, so we don't have
various possible versions of can_dev.ko?

@Vincent, I think you suggested that some time ago, IIRC?

(I know, I was against a ton of little modules, but I'm changing my
ways here now since it seems to help...)



Max
