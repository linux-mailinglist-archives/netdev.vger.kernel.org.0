Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1CE677C1E
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbjAWNHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbjAWNG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:06:59 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74687ABE;
        Mon, 23 Jan 2023 05:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hzFIQ4rUQrV/+gtpTCkktKC72PNIwUgOSkDk5/GlCVI=; b=p48IMyBeghx053kjk7XZhnV994
        Tb7F+a7AN48I1pNnwyvFip8jR0TmBlr+qwG0Fzs8bjGtuB+/EgUuWJZGMN8ETkh65jvoV0RC8ttWF
        ISXkJtcmFPSqHzRJD4hOvQl7hNnXtg4aa5VVJ9ukMypmyT3kI1d7xaFy8PNfDHawjHjU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pJwXF-002uBt-Jn; Mon, 23 Jan 2023 14:06:53 +0100
Date:   Mon, 23 Jan 2023 14:06:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arun.ramadoss@microchip.com, UNGLinuxDriver@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next] net: phy: microchip: run phy initialization
 during each link update
Message-ID: <Y86GbRyc09cjtGyZ@lunn.ch>
References: <20230120104733.724701-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120104733.724701-1-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 04:17:33PM +0530, Rakesh Sankaranarayanan wrote:
> PHY initialization is supposed to run on every mode changes.
> "lan87xx_config_aneg()" verifies every mode change using
> "phy_modify_changed()" function. Earlier code had phy_modify_changed()
> followed by genphy_soft_reset. But soft_reset resets all the
> pre-configured register values to default state, and lost all the
> initialization done. With this reason gen_phy_reset was removed.
> But it need to go through init sequence each time the mode changed.
> Update lan87xx_config_aneg() to invoke phy_init once successful mode
> update is detected.
> 
> PHY init sequence added in lan87xx_phy_init() have slave init
> commands executed every time. Update the init sequence to run
> slave init only if phydev is in slave mode.
> 
> Test setup contains LAN9370 EVB connected to SAMA5D3 (Running DSA),
> and issue can be reproduced by connecting link to any of the available
> ports after SAMA5D3 boot-up. With this issue, port will fail to
> update link state. But once the SAMA5D3 is reset with LAN9370 link in
> connected state itself, on boot-up link state will be reported as UP. But
> Again after some time, if link is moved to DOWN state, it will not get
> reported.
> 
> Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
