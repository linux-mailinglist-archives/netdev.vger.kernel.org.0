Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1EE6ACBA5
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjCFR45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCFR4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:56:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C7B3AA8;
        Mon,  6 Mar 2023 09:55:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE88761058;
        Mon,  6 Mar 2023 17:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09792C433EF;
        Mon,  6 Mar 2023 17:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678125317;
        bh=tPlXjG7fq0sTP12q7R0JSH+JTt6YBwCm664lnJwGbsw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FwWzHJUhGDPFKlKdYtCnh5OHOShY6aACx8VOQATs/1k0GxGtZKeTIC9Goq13jhKRN
         1hbn2aDhIu2q9HM2PpslaPtxpuLUQg57UovETpG+pXptLbkGIa04h7CPWYUhigr8DD
         LpbeQPSgaFIRyaIcF9IJVE3QgyGHYBW+sYXZ0hvVl/GMVTvtwIKcdiu2xU0p5U9NIn
         oGUy83mU/desT6b//rtBtYbuI46myUQj86m/eMMUzRhxNpO8HQ7PvEgrPrNcrche1W
         9VuxJJRkQ5PU5NIkLrLqJ09SyCp3MLY/AlCcKgV8/T6knVl+8TxcsHamb8Zcg2YyK3
         gv6lbUsbFdeeQ==
Date:   Mon, 6 Mar 2023 09:55:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
Message-ID: <20230306095515.20e819d1@kernel.org>
In-Reply-To: <94544cd0-18da-40d1-8691-66e50d42bfb4@lunn.ch>
References: <20230303164248.499286-1-kory.maincent@bootlin.com>
        <20230303164248.499286-4-kory.maincent@bootlin.com>
        <011d63c3-e3ff-4b67-8ab7-d39f541c7b31@lunn.ch>
        <ZANu37JHCKwsiCTT@shell.armlinux.org.uk>
        <94544cd0-18da-40d1-8691-66e50d42bfb4@lunn.ch>
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

On Sat, 4 Mar 2023 20:46:05 +0100 Andrew Lunn wrote:
> > Since the ioctl is to do with requesting what we want the timestamping
> > layer to be doing with packets, putting it in ptp_clock_info makes
> > very little sense.  
> 
> So there does not appear to be an object to represent a time stamper?
> 
> Should one be added? It looks like it needs two ops hwtstamp_set() and
> hwtstamp_get(). It would then be registered with the ptp core. And
> then the rest of what i said would apply...

IMHO time stamper is very much part of the netdev. I attribute the lack
of clarity palatially to the fact that (for reasons unknown) we still
lug the request as a raw IOCTL/ifreq. Rather than converting it to an
NDO/phydev op in the core.. Also can't think of a reason why modeling
it as a separate object would be useful?
