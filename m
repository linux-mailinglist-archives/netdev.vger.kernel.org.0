Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEB565E971
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 11:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbjAEK7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 05:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjAEK7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 05:59:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CF8551F7;
        Thu,  5 Jan 2023 02:59:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51A3A619C4;
        Thu,  5 Jan 2023 10:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320D5C433D2;
        Thu,  5 Jan 2023 10:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672916354;
        bh=+IIsWM8YYZYXinv0ohzNX9S/OngYpPsYeWi+JVWCV/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bjJVYaPIUKUf+dScUlU9GpFP5LDs9e0CrpQXu8cu9ivurFkKgUKS+Zea5Qv66FXST
         KUQGia/VGDiXBTiQHTR6bgmiHAcT5XAqxHevh8vstVQBF5qfXxT2oVB1xIwuCkQn/o
         8sMJfvZDs9lpTclCcEiNUovctzQrHN2k6iIK/CAHU5azGLHCq1huzA7EZ51JMI8gUe
         ZRo/+8mMZiSiHaGnnpubhXNpzy6dM9+wLKQjC/kJvHThMTf9ENNKp1wHeJ+5Aeck2l
         VdQtASUSCWO3x1BcuFARcE9+cETbzkBVZvP9kaoQUdoEJEjxYePIpcYBnAUYaTQ6kV
         60fO7C7QOSfkA==
Date:   Thu, 5 Jan 2023 12:59:10 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <Y7atfqnih0bQArjf@unreal>
References: <cover.1672840325.git.piergiorgio.beruto@gmail.com>
 <5d9b49cb21c97bf187502d4f6000f1084a7e4df7.1672840326.git.piergiorgio.beruto@gmail.com>
 <Y7aSco7bDOHQhQv7@unreal>
 <Y7arLoRBJ40eMizO@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7arLoRBJ40eMizO@gvm01>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 11:49:18AM +0100, Piergiorgio Beruto wrote:
> On Thu, Jan 05, 2023 at 11:03:46AM +0200, Leon Romanovsky wrote:
> > On Wed, Jan 04, 2023 at 03:06:30PM +0100, Piergiorgio Beruto wrote:
> > > This patch adds the required connection between netlink ethtool and
> > > phylib to resolve PLCA get/set config and get status messages.
> > > 
> > > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > > ---
> > >  drivers/net/phy/phy.c        | 172 +++++++++++++++++++++++++++++++++++
> > >  drivers/net/phy/phy_device.c |   3 +
> > >  include/linux/phy.h          |   7 ++
> > >  3 files changed, 182 insertions(+)
> > 
> > <...>
> > 
> > > +	curr_plca_cfg = kmalloc(sizeof(*curr_plca_cfg), GFP_KERNEL);
> > > +	if (unlikely(!curr_plca_cfg)) {
> > 
> > Please don't put likely/unlikely on kamlloc and/or in in control path
> > flow.
> Fixed. Although, I am curious to know why exactly it is bad to
> linkely/unlikely on kmalloc. Is this because if we're in a situation of
> low memory we don't want to put more "stress" on the system failing
> branch predictions?

likely/unlikely is helpful when you are sure that compiler won't be able
to guess the right flow and probably will get it wrong. It is usually not
the case for any "return to error" flows and sure not the case here.

Bottom line, you won't see any difference in assembly if you put or
remove unlikely keyword.

Thanks

> > 
> > Thanks
