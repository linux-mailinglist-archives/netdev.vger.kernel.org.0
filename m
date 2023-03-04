Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65216AAC2B
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 20:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjCDTqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 14:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCDTqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 14:46:16 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAEA1B57D;
        Sat,  4 Mar 2023 11:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mqhIv4BnRUzpQwjss739cv1fDBqva1NryZa6MDjF/Z4=; b=WIb7cDtQ9Pwtt/epJFfAzsYlNu
        uf0G1zcrglU47PJ9TJYNfDSJwmXT53uDxwBrH8ddS1axGuNAY6qwQrCvU4f8vjsIHQBu3573Oz6x8
        iMs8hT+7Q0Bb6F04Pg/Xz7nyVpzNeccIvACQxXz3npeCtU+nMAzkdVyeRp6rkwEFj4qI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pYXpV-006Sj3-IH; Sat, 04 Mar 2023 20:46:05 +0100
Date:   Sat, 4 Mar 2023 20:46:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH v2 3/4] net: Let the active time stamping layer be
 selectable.
Message-ID: <94544cd0-18da-40d1-8691-66e50d42bfb4@lunn.ch>
References: <20230303164248.499286-1-kory.maincent@bootlin.com>
 <20230303164248.499286-4-kory.maincent@bootlin.com>
 <011d63c3-e3ff-4b67-8ab7-d39f541c7b31@lunn.ch>
 <ZANu37JHCKwsiCTT@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZANu37JHCKwsiCTT@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The timestamping part is via the netdev, which is a separate entity,
> and its that entity which is responsible for identifying which PHC it
> is connected to (normally by filling in the phc_index field of
> ethtool_ts_info.)
> 
> Think of is as:
> 
>   netdev ---- timestamping ---- PHC
> 
> since we can have:
> 
>   netdev1 ---- timestamping \
>   netdev2 ---- timestamping -*--- PHC
>   netdev3 ---- timestamping /
> 
> Since the ioctl is to do with requesting what we want the timestamping
> layer to be doing with packets, putting it in ptp_clock_info makes
> very little sense.

So there does not appear to be an object to represent a time stamper?

Should one be added? It looks like it needs two ops hwtstamp_set() and
hwtstamp_get(). It would then be registered with the ptp core. And
then the rest of what i said would apply...

	Andrew
