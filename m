Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3939B1D6CEF
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 22:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgEQUpN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 17 May 2020 16:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgEQUpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 16:45:12 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A897C061A0C;
        Sun, 17 May 2020 13:45:12 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=roelofs-mbp.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jaQ9Y-0004sd-UM; Sun, 17 May 2020 22:44:57 +0200
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] lan743x: Added fixed link support
From:   Roelof Berg <rberg@berg-solutions.de>
In-Reply-To: <20200517183710.GC606317@lunn.ch>
Date:   Sun, 17 May 2020 22:44:56 +0200
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6E144634-8E2F-48F7-A0A4-6073164F2B70@berg-solutions.de>
References: <20200516192402.4201-1-rberg@berg-solutions.de>
 <20200517183710.GC606317@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1589748312;3d2e5435;
X-HE-SMSGID: 1jaQ9Y-0004sd-UM
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To Everyone: I need a test hardware recommendation for a lan7431/0 NIC in normal mode (not fixed-link mode). In prior patches this was not necessary, because I was able to ensure 100% backwards compatibility by careful coding alone. But I might soon come to a point where I need to test phy-connected devices as well.

Hi Andrew,

thanks for commenting on my patch.


> Am 17.05.2020 um 20:37 schrieb Andrew Lunn <andrew@lunn.ch>:
> 
>> @@ -946,6 +949,9 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
>> {
>> 	struct lan743x_adapter *adapter = netdev_priv(netdev);
>> 	struct phy_device *phydev = netdev->phydev;
>> +	struct device_node *phynode;
>> +	phy_interface_t phyifc = PHY_INTERFACE_MODE_GMII;
>> +	u32 data;
>> 
>> 	phy_print_status(phydev);
>> 	if (phydev->state == PHY_RUNNING) {
>> @@ -953,6 +959,48 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
>> 		int remote_advertisement = 0;
>> 		int local_advertisement = 0;
>> 
>> +		/* check if a fixed-link is defined in device-tree */
>> +		phynode = of_node_get(adapter->pdev->dev.of_node);
>> +		if (phynode && of_phy_is_fixed_link(phynode)) {
> 
> Hi Roelof
> 
> The whole point for fixed link is that it looks like a PHY. You should
> not need to care if it is a real PHY or a fixed link.
> 

Ok, I can try to remove the additional speed and baud configuration, when the PHY simulation should lead to the same result. Understood, thanks, I’ll test this and remove the overhead.

> 
>> +			/* Configure MAC to fixed link parameters */
>> +			data = lan743x_csr_read(adapter, MAC_CR);
>> +			/* Disable auto negotiation */
>> +			data &= ~(MAC_CR_ADD_ | MAC_CR_ASD_);
> 
> Why does the MAC care about autoneg? In general, all the MAC needs to
> know is the speed and duplex.
> 

My assumption is, that in fixed-link mode we should switch off the autonegotiation between MAC and remote peer (e.g. a switch). I didn’t test, if it would also wun with the hardware doing auto-negotiation, however it feels cleaner to me to prevent the hardware from initiating any auto-negotiation in fixed-link mode.

>> +			/* Set duplex mode */
>> +			if (phydev->duplex)
>> +				data |= MAC_CR_DPX_;
>> +			else
>> +				data &= ~MAC_CR_DPX_;
>> +			/* Set bus speed */
>> +			switch (phydev->speed) {
>> +			case 10:
>> +				data &= ~MAC_CR_CFG_H_;
>> +				data &= ~MAC_CR_CFG_L_;
>> +				break;
>> +			case 100:
>> +				data &= ~MAC_CR_CFG_H_;
>> +				data |= MAC_CR_CFG_L_;
>> +				break;
>> +			case 1000:
>> +				data |= MAC_CR_CFG_H_;
>> +				data |= MAC_CR_CFG_L_;
>> +				break;
>> +			}
> 
> The current code is unusual, in that it uses
> phy_ethtool_get_link_ksettings(). That should do the right thing with
> a fixed-link PHY, although i don't know if anybody uses it like
> this. So in theory, the current code should take care of duplex, flow
> control, and speed for you. Just watch out for bug/missing features in
> fixed link.

Ok, I test and report if it works. Now I understand the concept.

> 
> 
>> +			/* Set interface mode */
>> +			of_get_phy_mode(phynode, &phyifc);
>> +			if (phyifc == PHY_INTERFACE_MODE_RGMII ||
>> +			    phyifc == PHY_INTERFACE_MODE_RGMII_ID ||
>> +			    phyifc == PHY_INTERFACE_MODE_RGMII_RXID ||
>> +			    phyifc == PHY_INTERFACE_MODE_RGMII_TXID)
>> +				/* RGMII */
>> +				data &= ~MAC_CR_MII_EN_;
>> +			else
>> +				/* GMII */
>> +				data |= MAC_CR_MII_EN_;
>> +			lan743x_csr_write(adapter, MAC_CR, data);
>> +		}
>> +		of_node_put(phynode);
> 
> It is normal to do of_get_phy_mode when connecting to the PHY, and
> store the value in the private structure. This is also not specific to
> fixed link.
> 
> There is also a helper you can use phy_interface_mode_is_rgmii().

Thanks for pointing to the method is_rgmii, very handy.

Using get_phy_mode() in all cases is not possible on a PC as it returns SGMII on a standard PC, but using GMII is today’s driver behavior. So what I basically did (on two places) is:

if(fixed-link)
   Use get_phy_mode()’s result in of_phy_connect() and in the lan7431 register configuration.
else
   Keep the prior behavior for backwards compatibility (i.e. ignoring the wrong interface mode config on a PC and use GMII constant)

The method is_rgmii you mention can lessen the pain here, thanks, and lead to:

if(is_rgmii()
	use RGMII
else
	use GMII

I need to think about this, because NOT passing get_phy_mode’s result directly into of_phy_connect or phy_connect_direct (and instead use above's (is_rgmii() ? RGMII : GMII) code) could have side effects.

However I don’t dare to pass get_phy_mode’s result directly into of_phy_connect or phy_connect_direct on a PC because then I might change the behavior of all standard PC NIC drivers. I haven’t researched yet why on a PC SGMII is returned by get_phy_mode(), does someone know ?. 

> 
>> +
>> 		memset(&ksettings, 0, sizeof(ksettings));
>> 		phy_ethtool_get_link_ksettings(netdev, &ksettings);
>> 		local_advertisement =
>> @@ -974,6 +1022,8 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
>> 
>> 	phy_stop(netdev->phydev);
>> 	phy_disconnect(netdev->phydev);
>> +	if (of_phy_is_fixed_link(adapter->pdev->dev.of_node))
>> +		of_phy_deregister_fixed_link(adapter->pdev->dev.of_node);
>> 	netdev->phydev = NULL;
>> }
>> 
>> @@ -982,18 +1032,44 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
>> 	struct lan743x_phy *phy = &adapter->phy;
>> 	struct phy_device *phydev;
>> 	struct net_device *netdev;
>> +	struct device_node *phynode = NULL;
>> +	phy_interface_t phyifc = PHY_INTERFACE_MODE_GMII;
>> 	int ret = -EIO;
> 
> netdev uses reverse christmas tree, meaning the lines should be
> sorted, longest first, getting shorter.
Ok
> 
>> 
>> 	netdev = adapter->netdev;
>> -	phydev = phy_find_first(adapter->mdiobus);
>> -	if (!phydev)
>> -		goto return_error;
>> 
>> -	ret = phy_connect_direct(netdev, phydev,
>> -				 lan743x_phy_link_status_change,
>> -				 PHY_INTERFACE_MODE_GMII);
>> -	if (ret)
>> -		goto return_error;
>> +	/* check if a fixed-link is defined in device-tree */
>> +	phynode = of_node_get(adapter->pdev->dev.of_node);
>> +	if (phynode && of_phy_is_fixed_link(phynode)) {
>> +		netdev_dbg(netdev, "fixed-link detected\n");
> 
> This is something which is useful during debug. But once it works can
> be removed.
Ok
> 
>> +		ret = of_phy_register_fixed_link(phynode);
>> +		if (ret) {
>> +			netdev_err(netdev, "cannot register fixed PHY\n");
>> +			goto return_error;
>> +		}
>> +
>> +		of_get_phy_mode(phynode, &phyifc);
>> +		phydev = of_phy_connect(netdev, phynode,
>> +					lan743x_phy_link_status_change,
>> +					0, phyifc);
>> +		if (!phydev)
>> +			goto return_error;
>> +	} else {
>> +		phydev = phy_find_first(adapter->mdiobus);
>> +		if (!phydev)
>> +			goto return_error;
>> +
>> +		ret = phy_connect_direct(netdev, phydev,
>> +					 lan743x_phy_link_status_change,
>> +					 PHY_INTERFACE_MODE_GMII);
>> +		/* Note: We cannot use phyifc here because this would be SGMII
>> +		 * on a standard PC.
>> +		 */
> 
> I don't understand this comment.
> 

See above the lengthy section. On a PC SGMII is returned when I call of_get_phy_mode(phynode, &phyifc); but the original driver is using PHY_INTERFACE_MODE_GMII; and I don’t dare to change this behavior. Which I would do when I would pass on the result of of_get_phy_mode(). That’s what I meant by the comment.

Thanks a lot directing me to the proper way,
Roelof


