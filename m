Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AF36A875D
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 17:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCBQua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 11:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjCBQu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 11:50:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79849D3
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 08:50:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FDEDB8121B
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 16:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B50AC4339B;
        Thu,  2 Mar 2023 16:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677775774;
        bh=rJSYZJupHT7cV7i8wdDq1MgG56MnrDYdgtRHNo0HNhc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hqm7cfmJrzu5h5hndotBpozz5mWU19A1bduyfFAS/E1UJ068t4XDB3e/h8KC85TBo
         VSbVZrqdEarrg8QSj4zY/jxP7nXcXW3sy+JEhAhlYl52pVxh8toBrAjZn81FVp46+S
         haLGUgTFYnJMOfcr+vaMQrjFtZwAW+L5CR178NfeqUw1sgPAtaCPq2WsdKacNyNAoB
         SY4Cr/akYsuLY5HaA/lrAjlFfPyFJ28WuoIz1Xuhml3RM8cc0Qwl0Jcjc+KEAgpRoI
         YmByarvaiBVhYeKwTd6dl9BL4aSxf0tWDxqcR4rAyl5d+AHyQNexGczvOD56eLhajr
         UPb1Q+R8IC5tw==
Date:   Thu, 2 Mar 2023 08:49:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230302084932.4e242f71@kernel.org>
In-Reply-To: <ZACNRjCojuK6tcnl@shell.armlinux.org.uk>
References: <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
        <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
        <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
        <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
        <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
        <20230228142648.408f26c4@kernel.org>
        <Y/6Cxf6EAAg22GOL@shell.armlinux.org.uk>
        <20230228145911.2df60a9f@kernel.org>
        <20230301170408.0cc0519d@kmaincent-XPS-13-7390>
        <ZAAn1deCtR0BoVAm@hoboy.vegasvil.org>
        <ZACNRjCojuK6tcnl@shell.armlinux.org.uk>
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

On Thu, 2 Mar 2023 11:49:26 +0000 Russell King (Oracle) wrote:
> (In essence, because of all the noise when trying the Marvell PHY with
> ptp4l, I came to the conlusion that NTP was a far better solution to
> time synchronisation between machines than PTP would ever be due to
> the nose induced by MDIO access. However, I should also state that I
> basically gave up with PTP in the end because hardware support is
> overall poor, and NTP just works - and I'd still have to run NTP for
> the machines that have no PTP capabilities. PTP probably only makes
> sense if one has a nice expensive grand master PTP clock on ones
> network, and all the machines one wants to synchronise have decent
> PTP implementations.)

Don't wanna waste too much of your time with the questions since
I haven't done much research but - wouldn't MAC timestamp be a better
choice more often (as long as it's a real, to-spec PTP stamp)? 
Are we picking PHY for historical reasons?

Not that flipping the default would address the problem of regressing
some setups..
