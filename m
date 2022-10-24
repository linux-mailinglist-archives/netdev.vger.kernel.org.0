Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F876609B1C
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 09:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiJXHRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 03:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiJXHRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 03:17:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCC64C004;
        Mon, 24 Oct 2022 00:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666595822; x=1698131822;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ahXYXj9DE/pVF8jQHrJ2tqdijJC/al1D0XongLdLCUI=;
  b=OIXAoXXVqquo5+d6v3qiyU9W/30D6qvpc1qnxDMHJw/tW+J1JC4NWPDx
   XsHe0v6C2ywXd715BvuipSkR9ubagy4+AfNQF5exiglQtwZQ3WAVYd178
   SVwfZEUkICFkEe5FeT4wbOPXr1fKMQyhDxpx9uodeG1kA9VNVgEO4z7o7
   kwb00J4J1Nepo6BJvSW2D6uC+4ORAM6jzFu5+FTyugy/2DHUmYfGMAX/k
   1JhETkYfi/ljRUrEUD3v1OMh+8O/D+ESeZ27nXQjKn2ZU5c4aGch+D50r
   /tZiklx3bSfmptmYg33ll/mmeAoG7TqeoxmPoTssCHQN2GZP8WwhxAHry
   g==;
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="186088262"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Oct 2022 00:17:01 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 24 Oct 2022 00:17:01 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Mon, 24 Oct 2022 00:16:57 -0700
Date:   Mon, 24 Oct 2022 12:46:56 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <hkallweit1@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next 1/2] net: lan743x: Add support for
 get_pauseparam and set_pauseparam
Message-ID: <20221024071656.GA653394@raju-project-pc>
References: <20221021055642.255413-1-Raju.Lakkaraju@microchip.com>
 <20221021055642.255413-2-Raju.Lakkaraju@microchip.com>
 <Y1Kiocu3WUubYyVe@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y1Kiocu3WUubYyVe@lunn.ch>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for review comments.

The 10/21/2022 15:46, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> > +static int lan743x_set_pauseparam(struct net_device *dev,
> > +                               struct ethtool_pauseparam *pause)
> > +{
> > +     struct lan743x_adapter *adapter = netdev_priv(dev);
> > +     struct phy_device *phydev = dev->phydev;
> > +     struct lan743x_phy *phy = &adapter->phy;
> > +
> > +     if (!phydev)
> > +             return -ENODEV;
> > +
> > +     if (!phy_validate_pause(phydev, pause))
> > +             return -EINVAL;
> > +
> > +     phy->fc_request_control = 0;
> > +     if (pause->rx_pause)
> > +             phy->fc_request_control |= FLOW_CTRL_RX;
> > +
> > +     if (pause->tx_pause)
> > +             phy->fc_request_control |= FLOW_CTRL_TX;
> > +
> > +     phy->fc_autoneg = pause->autoneg;
> > +
> > +     phy_set_asym_pause(phydev, pause->rx_pause,  pause->tx_pause);
> > +
> > +     if (pause->autoneg == AUTONEG_DISABLE)
> > +             lan743x_mac_flow_ctrl_set_enables(adapter, pause->tx_pause,
> > +                                               pause->rx_pause);
> 
> pause is not too well defined. But i think phy_set_asym_pause() should
> be in an else clause. If pause autoneg is off, you directly set it in
> the MAC and ignore what is negotiated. If it is enabled, you
> negotiate. As far as i understand, you don't modify your negotiation
> when pause autoneg is off.

O.K. I will change.

> 
>         Andrew

--------
Thanks,
Raju
