Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290FD15180B
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 10:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgBDJll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 04:41:41 -0500
Received: from mga12.intel.com ([192.55.52.136]:61978 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgBDJlk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 04:41:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 01:41:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,401,1574150400"; 
   d="scan'208";a="263777702"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 04 Feb 2020 01:41:38 -0800
Received: from [10.226.38.231] (unknown [10.226.38.231])
        by linux.intel.com (Postfix) with ESMTP id B6803580696;
        Tue,  4 Feb 2020 01:41:36 -0800 (PST)
Subject: Re:[RFC net-next] net: phy: Add basic support for Synopsys XPCS using
 a PHY driver
To:     Jose.Abreu@synopsys.com
References: <20200120113935.GC25745@shell.armlinux.org.uk>
 <e942b414-08bd-0305-9128-26666a7a5d5a@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   "Chng, Jack Ping" <jack.ping.chng@linux.intel.com>
Message-ID: <99652f12-c7b4-756d-d169-4770cf1f0d96@linux.intel.com>
Date:   Tue, 4 Feb 2020 17:41:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <e942b414-08bd-0305-9128-26666a7a5d5a@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,
>
>> So, besides not having a DT based setup to test changes, I also don't 
>> have access to SFP bus neither SERDES ... As you suggested, I would 
>> like to integrate XPCS with PHYLINK in stmmac but I'm not entirely 
>> sure on how to implement the remaining connections as the 
>> connect_phy() callbacks will fail because the only MMD device in the 
>> bus will be XPCS. That's why I suggested the Fixed PHY approach ...
>
> Having access to the SFP or not is not that relevent to the data link.
> Generally, the SFP is not like a PHY, and doesn't take part in the
> link negotiation unless it happens to contain a copper PHY.
>
> Also, please, do not use fixed-phy support with phylink. phylink
> implements a replacement for that, where it supports fixed-links
> without needing the fixed-phy stuff. This is far more flexible
> than fixed-phy which is restricted to the capabilities of clause 22
> PHYs only.
>
> To make fixed-phy support modes beyond clause 22 PHY capabilities
> would need clause 45 register set emulation by swphy and a
> corresponding clause 45 phylib driver; clause 45 annoyingly does
> not define the 1G negotiation registers in the standard register
> set, so every PHY vendor implements that using their own vendor
> specific solution.
>
> This is why phylink implements its own solution without using
> fixed-phy (which I wish could be removed some day).
>
> I would strongly recommend supporting the XPCS natively and not
> via phylib. Consider the case:
>
> Host PC x86 -> PCI -> XGMAC -> XPCS -> SERDES 10G-BASE-R -> PHY -> RJ45
>
> You can only have one phylib PHY attached to a network device via
> connect_phy(); that is a restriction in the higher net layers. If you
> use phylib for the XPCS, how do you attach the PHY to the setup and
> configure it?
>
> Also, using a PHY via connect_phy() negates using fixed-link mode in
> phylink, the two have always been exclusive.

Currently our network SoC has something like this:
XGMAC-> XPCS -> Combo PHY -> PHY

In the xpcs driver probe(), get and calibrate the phy:

priv->phy = devm_phy_get(&pdev->dev, "phy");
if (IS_ERR(priv->phy)) {
     dev_warn(dev, "No phy\n");
     return PTR_ERR(priv->phy);
}

ret = phy_init(priv->phy);
if (ret)
     return ret;

ret = phy_power_on(priv->phy);
if (ret) {
     phy_exit(priv->phy);
     return ret;
}
ret = phy_calibrate(priv->phy);
if (ret) {
     phy_exit(priv->phy);
     return ret;
}

xpcs driver needs to handle phy or phy_device depending on the phy?

Best regards,
Chng Jack Ping

