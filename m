Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E05661C68
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 03:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbjAICmP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Jan 2023 21:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbjAICmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 21:42:14 -0500
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0373FE038
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 18:42:11 -0800 (PST)
X-QQ-mid: bizesmtp65t1673232049txz3ifwd
Received: from smtpclient.apple ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 09 Jan 2023 10:40:47 +0800 (CST)
X-QQ-SSF: 00400000000000M0N000000A0000000
X-QQ-FEAT: pI6bUghcKwP+j8ub+ypoPXnKY7tjbVmCLlaVjhvirFsNFUSJEko6KONvHVvNA
        CxwN/3s0CeZmzFm9BtMG6TKhwT33sCHqBQF/JsL63TVTCJ5f1WIeEecWjLuwvzx/yA3k4gP
        ViEiNfhNhtOlGZNaGXmF3ehk/vUdFReYXg432mXOmlsTjon6EHUDrQ1XnOY89ZQwFoypdsI
        wcYL//j+Vl036K8gjOeLoG+xy9ZpjRzyG+yE0vQfoTaO9vnBFX7gqlIZvvMToFmkOS59+mL
        QHLdOZvKo62Ksl8d9PNzA1lxHrP9rxlQ3mTAB8GQ51YDfnPrIgaUUMpQbkT3tpXfhlEC4SC
        IqDsp2kSMhV7xxuQgjCgr3pMCYUaAe48NKEqeZGWaDTpBt4YP4bkCVyPUib28TFGadYFKw0
X-QQ-GoodBg: 2
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.51\))
Subject: Re: [PATCH net-next v6] net: ngbe: Add ngbe mdio bus driver.
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <Y7roqgyjDN91hSIH@lunn.ch>
Date:   Mon, 9 Jan 2023 10:40:37 +0800
Cc:     netdev@vger.kernel.org, jiawenwu@net-swift.com
Content-Transfer-Encoding: 8BIT
Message-Id: <6A65AA55-3962-4E48-A778-7D1EF0820D89@net-swift.com>
References: <20230108093903.27054-1-mengyuanlou@net-swift.com>
 <Y7roqgyjDN91hSIH@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3731.300.51)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 2023年1月9日 00:00，Andrew Lunn <andrew@lunn.ch> 写道：
> 
>> +static int ngbe_phy_read_reg_internal(struct mii_bus *bus, int phy_addr, int regnum)
>> +{
>> + struct wx *wx = bus->priv;
>> +
>> + if (regnum & MII_ADDR_C45)
>> + return -EOPNOTSUPP;
>> + return (u16)rd32(wx, NGBE_PHY_CONFIG(regnum));
> 
> You ignore phy_addr. Which suggests you only allow one internal
> PHY. Best practice here is to put the internal PHY on phy_addr 0, and
> return 0xffff for all other phy_addr values. If phylib probes the full
> range, or userspace tries to access the full range, it will look like
> there is no PHY at these other addresses.
> 
>> +}
>> +
>> +static int ngbe_phy_write_reg_internal(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
>> +{
>> + struct wx *wx = bus->priv;
>> +
>> + if (regnum & MII_ADDR_C45)
>> + return -EOPNOTSUPP;
>> + wr32(wx, NGBE_PHY_CONFIG(regnum), value);
>> + return 0;
> 
> Here, silently ignore writes to phy_addr != 0.
> 
>> + /* wait to complete */
>> + ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 1000,
>> + 100000, false, wx, NGBE_MSCC);
>> + if (ret) {
>> + wx_err(wx, "PHY address command did not complete.\n");
>> + return ret;
>> + }
>> +
>> + return (u16)rd32(wx, NGBE_MSCC);
>> +}
>> +
>> + /* wait to complete */
>> + ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 1000,
>> + 100000, false, wx, NGBE_MSCC);
>> + if (ret)
>> + wx_err(wx, "PHY address command did not complete.\n");
> 
> You have the exact same error message. When you see such an error in
> the log, it can sometimes be useful to know was it a read or a write
> which failed. So i would suggest you put read/write into the message.
> 
>> +static void ngbe_phy_fixup(struct wx *wx)
>> +{
>> + struct phy_device *phydev = wx->phydev;
>> + struct ethtool_eee eee;
>> +
>> + if (wx->mac_type != em_mac_type_mdi)
>> + return;
> 
> Does this mean that if using the internal PHY the MAC does support EEE
> and half duplex?


1) The MAC does not support half duplex. 
   Internal phy and external phys all need to close half duplex.

2) The internal phy does not support eee. 
   When using the internal phy, we disable eee.
> 
>> + /* disable EEE, EEE not supported by mac */
>> + memset(&eee, 0, sizeof(eee));
>> + phy_ethtool_set_eee(phydev, &eee);
>> +
>> + phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
>> + phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
>> + phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
>> +}
>> +
>> +int ngbe_mdio_init(struct wx *wx)
>> +{
>> + struct pci_dev *pdev = wx->pdev;
>> + struct mii_bus *mii_bus;
>> + int ret;
>> +
>> + mii_bus = devm_mdiobus_alloc(&pdev->dev);
>> + if (!mii_bus)
>> + return -ENOMEM;
>> +
>> + mii_bus->name = "ngbe_mii_bus";
>> + mii_bus->read = ngbe_phy_read_reg;
>> + mii_bus->write = ngbe_phy_write_reg;
>> + mii_bus->phy_mask = GENMASK(31, 4);
>> + mii_bus->probe_capabilities = MDIOBUS_C22_C45;
> 
> That is not strictly true. The internal MDIO bus does not suport
> C45. In practice, it probably does not matter.

>> mii_bus->probe_capabilities = MDIOBUS_C22_C45;
So, it is not necessary?
If I correct handling in read/write.
> 
>     Andrew
> 

