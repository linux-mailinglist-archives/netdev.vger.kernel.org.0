Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2461C600E
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgEES1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:27:21 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:35492 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728608AbgEES1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:27:21 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 045IQoXs013790;
        Tue, 5 May 2020 13:26:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588703210;
        bh=N8T0PKzyG6BviCMR5+8NSHwmvWxH4GxCu8FwZPUeanU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=yMQ6o19jG3vJoA4khlTPCWSFA8tTsWEpMr+bzvOSwmguu0K4HfDyGlPZsB3rQfoBP
         sNedvxZwrA0JrgPtAY58tAzdYoUtjWuxjxATtfx9SJzqM0th+q64sSomjCwk5whARi
         WzHYdS6MEsmwVNFctlcWdtBw113fouYxT+1UyBmE=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 045IQoWW068476
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 5 May 2020 13:26:50 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 5 May
 2020 13:26:49 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 5 May 2020 13:26:49 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 045IQk96017215;
        Tue, 5 May 2020 13:26:47 -0500
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>, <kernel@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Russell King <linux@armlinux.org.uk>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <71dea993-b420-e994-ffa8-87350e157cda@ti.com>
Date:   Tue, 5 May 2020 21:26:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422072137.8517-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22/04/2020 10:21, Oleksij Rempel wrote:
> Add support for following phy-modes: rgmii, rgmii-id, rgmii-txid, rgmii-rxid.
> 
> This PHY has an internal RX delay of 1.2ns and no delay for TX.
> 
> The pad skew registers allow to set the total TX delay to max 1.38ns and
> the total RX delay to max of 2.58ns (configurable 1.38ns + build in
> 1.2ns) and a minimal delay of 0ns.
> 
> According to the RGMII v1.3 specification the delay provided by PCB traces
> should be between 1.5ns and 2.0ns. The RGMII v2.0 allows to provide this
> delay by MAC or PHY. So, we configure this PHY to the best values we can
> get by this HW: TX delay to 1.38ns (max supported value) and RX delay to
> 1.80ns (best calculated delay)
> 
> The phy-modes can still be fine tuned/overwritten by *-skew-ps
> device tree properties described in:
> Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
> changes v3:
> - change delay on RX line to 1.80ns
> - add warning if *-skew-ps properties are used together with not rgmii
>    mode.
> 
> changes v2:
> - change RX_ID value from 0x1a to 0xa. The overflow bit was detected by
>    FIELD_PREP() build check.
>    Reported-by: kbuild test robot <lkp@intel.com>
> 
>   drivers/net/phy/micrel.c | 128 +++++++++++++++++++++++++++++++++++++--
>   1 file changed, 123 insertions(+), 5 deletions(-)
> 

This patch broke networking on at least 5 TI boards:
am572x-idk
am571x-idk
am43xx-hsevm
am43xx-gpevm
am437x-idk

am57xx I can fix.

am437x need to investigate.

-- 
Best regards,
grygorii
