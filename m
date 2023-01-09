Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12616628B0
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 15:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjAIOjK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Jan 2023 09:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjAIOjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 09:39:05 -0500
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB4A1CFF3
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 06:38:58 -0800 (PST)
X-QQ-mid: bizesmtp84t1673275117tn1h663b
Received: from smtpclient.apple ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 09 Jan 2023 22:38:36 +0800 (CST)
X-QQ-SSF: 00400000002000M0N000B00A0000000
X-QQ-FEAT: j86OQQvu8eQcOzkgdVHSDtEdMBJhavRtlAxn+0dpkByJwzEEcRKMM1VLXe9us
        jUYjf2+wmI1lfMxIvf6SVp57n7tCmOZ4dYiiJfr23MPBBYJ6aBQRTPX0h4/XXWFtmJgeXWs
        SU8BsiEyKu6AXYp1S65kF68wQ1pyTuon46ZPUQpf+Kgc/U4Midvxa5/K/62lA65hThGFVLJ
        +Ub+QylfP5ERi79q8QrguxS9Ah3zZzjCqCm23uQ1gb35Uh8VTi3oLOVR/6wLCRhfPdxVS+t
        RB2VRARTHQMRAYeyQ9kUWcmd4xbQvtK4WGrFfQunt6gKpI7QxuXtO6VUozPJqfrPBGedMqc
        iE51S4o0CaBPAb33HgUNNv3UQ/xg3muneAzKJqcn2DUWspATUR5Ce/miwBokKUTGOJQof91
        z+Wss1pz/xE=
X-QQ-GoodBg: 2
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH net-next v6] net: ngbe: Add ngbe mdio bus driver.
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <Y7wSZJC3F5liYvTe@lunn.ch>
Date:   Mon, 9 Jan 2023 22:38:36 +0800
Cc:     netdev@vger.kernel.org, jiawenwu@net-swift.com
Content-Transfer-Encoding: 8BIT
Message-Id: <944E48A5-B112-4E84-8BF9-69DC2565D72C@net-swift.com>
References: <20230108093903.27054-1-mengyuanlou@net-swift.com>
 <Y7roqgyjDN91hSIH@lunn.ch>
 <6A65AA55-3962-4E48-A778-7D1EF0820D89@net-swift.com>
 <Y7wSZJC3F5liYvTe@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 2023年1月9日 21:11，Andrew Lunn <andrew@lunn.ch> 写道：
> 
>>>> +static void ngbe_phy_fixup(struct wx *wx)
>>>> +{
>>>> + struct phy_device *phydev = wx->phydev;
>>>> + struct ethtool_eee eee;
>>>> +
>>>> + if (wx->mac_type != em_mac_type_mdi)
>>>> + return;
>>> 
>>> Does this mean that if using the internal PHY the MAC does support EEE
>>> and half duplex?
>> 
>> 
>> 1) The MAC does not support half duplex. 
>>   Internal phy and external phys all need to close half duplex.
>> 
>> 2) The internal phy does not support eee. 
>>   When using the internal phy, we disable eee.
> 
> So this condition is wrong and need deleting?

The condition is only used to dis eee for internal phy.
I will fix it. Thanks.
> 
>>>> +int ngbe_mdio_init(struct wx *wx)
>>>> +{
>>>> + struct pci_dev *pdev = wx->pdev;
>>>> + struct mii_bus *mii_bus;
>>>> + int ret;
>>>> +
>>>> + mii_bus = devm_mdiobus_alloc(&pdev->dev);
>>>> + if (!mii_bus)
>>>> + return -ENOMEM;
>>>> +
>>>> + mii_bus->name = "ngbe_mii_bus";
>>>> + mii_bus->read = ngbe_phy_read_reg;
>>>> + mii_bus->write = ngbe_phy_write_reg;
>>>> + mii_bus->phy_mask = GENMASK(31, 4);
>>>> + mii_bus->probe_capabilities = MDIOBUS_C22_C45;
>>> 
>>> That is not strictly true. The internal MDIO bus does not suport
>>> C45. In practice, it probably does not matter.
>> 
>>>> mii_bus->probe_capabilities = MDIOBUS_C22_C45;
>> So, it is not necessary?
>> If I correct handling in read/write.
> 
> mii_bus->probe_capabilities controls how the MDIO bus is probed for
> devices. MDIOBUS_C22_C45 means it will first look for C22 devices, and
> then look for C45 devices. One of your busses does not support C45,
> and will always return -EOPNOTSUPP. So it is just a waste of time
> probing that bus for C45 devices. But it will not break, which is why
> i said it probably does not matter. You could if you wanted set
> mii_bus->probe_capabilities based on which bus is being used, internal
> or external, and that might speed up the driver loading a little.
> 
> 	Andrew

