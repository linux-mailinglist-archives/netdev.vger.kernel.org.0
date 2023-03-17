Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207D86BE0EF
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 07:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCQGCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 02:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCQGCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 02:02:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837655551F
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 23:02:49 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pd3AV-0008Kv-Jr; Fri, 17 Mar 2023 07:02:23 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pd3AS-0001va-K6; Fri, 17 Mar 2023 07:02:20 +0100
Date:   Fri, 17 Mar 2023 07:02:20 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT PATCH net-next 0/4] KSZ DSA driver: xMII speed
 adjustment and partial reg_fields conversion
Message-ID: <20230317060220.GC13320@pengutronix.de>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thu, Mar 16, 2023 at 06:12:46PM +0200, Vladimir Oltean wrote:
> Hi,
> 
> Yesterday I picked up this patch and resubmitted it:
> https://patchwork.kernel.org/project/netdevbpf/patch/20230222031738.189025-1-marex@denx.de/
> here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20230315231916.2998480-1-vladimir.oltean@nxp.com/
> 
> and today I'm trying to address the rest of the points brought up in
> that conversation, namely:
> 
> - commit c476bede4b0f ("net: dsa: microchip: ksz8795: use common xmii
>   function") stopped adjusting the xMII port speed on KSZ8795, does it
>   still work? No idea. Patch 3/4 deals with that.
> 
> - Mapping P_XMII_CTRL_0 and P_XMII_CTRL_1 to the same value on KSZ8795
>   raised some eyebrows, and some reading shows that it is also partially
>   incorrect (see patch 2/4). This is also where I propose to convert to
>   reg_fields.
> 
> As it turns out, patch 2/4 is a dependency for patch 3/4, even if 3/4
> may be a fix.
> 
> Patch 1/4 is a dependency of 2/4.
> 
> Patch 4/4 is something I also noticed during review. I left it at the
> end so that it won't conflict with something that could reasonably be
> submitted as a bug fix.
> 
> ABSOLUTELY NO TESTING WAS DONE. I don't have the hardware.
> 
> THIS BREAKS EVERYTHING EXCEPT FOR KSZ8795. Any testers should test on
> that if possible (due to both patches 2/4, and 3/4).

I can test it on KSZ8873, but currently it is not compiling on top of net-next.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
