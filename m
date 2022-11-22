Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C01633F94
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiKVO5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbiKVO53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:57:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3EB6DCCD
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:55:32 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oxUgJ-0007MS-Db; Tue, 22 Nov 2022 15:55:27 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oxUgJ-0007yC-5z; Tue, 22 Nov 2022 15:55:27 +0100
Date:   Tue, 22 Nov 2022 15:55:27 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Po-Hao Huang <phhuang@realtek.com>
Cc:     linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        linux-kernel@vger.kernel.org, Viktor Petrenko <g0000ga@gmail.com>,
        Neo Jou <neojou@gmail.com>, Po-Hao Huang <phhuang@realtek.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>
Subject: Re: [PATCH v3 00/11] RTW88: Add support for USB variants
Message-ID: <20221122145527.GA29978@pengutronix.de>
References: <20221122145226.4065843-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122145226.4065843-1-s.hauer@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 03:52:15PM +0100, Sascha Hauer wrote:
> This is the third round of adding support for the USB variants to the
> RTW88 driver. There are a few changes to the last version which make it
> worth looking at this version.
> 
> First of all RTL8723du and RTL8821cu are tested working now. The issue
> here was that the txdesc checksum calculation was wrong. I found the
> correct calculation in various downstream drivers found on github.
> 
> The second big issue was that TX packet aggregation was wrong. When
> aggregating packets each packet start has to be aligned to eight bytes.
> The necessary alignment was added to the total URB length before
> checking if there is another packet to aggregate, so the URB length
> included that padding after the last packet, which is wrong.  Fixing
> this makes the driver work much more reliably.
> 
> I added all people to Cc: who showed interest in this driver and I want
> to welcome you for testing and reviewing.

There still is a problem with the RTL8822cu chipset I have here.  When
using NetworkManager I immediately lose the connection to the AP after
it has been connected:

[  376.213846] wlan0: authenticate with 76:83:c2:ce:81:b1
[  380.085463] wlan0: send auth to 76:83:c2:ce:81:b1 (try 1/3)
[  380.091446] wlan0: authenticated
[  380.108864] wlan0: associate with 76:83:c2:ce:81:b1 (try 1/3)
[  380.136448] wlan0: RX AssocResp from 76:83:c2:ce:81:b1 (capab=0x1411 status=0 aid=2)
[  380.202955] wlan0: associated
[  380.268140] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  380.275328] wlan0: Connection to AP 76:83:c2:ce:81:b1 lost

That doesn't happen when using plain wpa_supplicant. This seems to go
down to cd96e22bc1da ("rtw88: add beacon filter support"). After being
connected I get a BCN_FILTER_CONNECTION_LOSS beacon. Plain
wpa_supplicant seems to go another code patch and doesn't activate
connection quality monitoring.

The connection to the AP works fluently also with NetworkManager though
when I just ignore the BCN_FILTER_CONNECTION_LOSS beacon.

Any idea what may be wrong here?

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
