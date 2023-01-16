Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD18666B5A5
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 03:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbjAPCmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 21:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbjAPCl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 21:41:59 -0500
Received: from www381.your-server.de (www381.your-server.de [78.46.137.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ADE6E89;
        Sun, 15 Jan 2023 18:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=metafoo.de;
        s=default2002; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=hCZxbNgzCUm7L6wl89cgCzaIwaOm944bt7U2/u6+A/s=; b=F5Lxokx1vKgOV3tLL77tJ2k8tj
        wvbKScP+A/iaNLF3TRDUQzWg79Fna6QajqMSbuPzF5lzZ1LVR70KTSllRtgjiS37NU7VfL05sZbyU
        WxF1D1psqtNFu4X9kKsLi7dS+iNBFO2c4w49VKm+G1FNtI/a7MqlNrBrvnslLbXADcKTcSM3dTLs/
        gFCQrDppmL+DuMqHQqu4wuIyW9czCB6vGuWbG5wxnJKuvJ9ftbliXOyGj5w5TX5x9WnfxP0BxJ+UQ
        oi+rFo6S8fTrTx/u3K1vBPil8APTxM8NdUPNoF9DhkuOLCqrsWiIA3IDh9jwRglY4Ey1PEIOKfScg
        32uyrz2w==;
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www381.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lars@metafoo.de>)
        id 1pHF84-000OdC-Qc; Mon, 16 Jan 2023 03:21:44 +0100
Received: from [2604:5500:c0e5:eb00:da5e:d3ff:feff:933b]
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lars@metafoo.de>)
        id 1pHF84-000HTx-72; Mon, 16 Jan 2023 03:21:44 +0100
Message-ID: <cc338014-8a2b-87e9-7684-20b57aae4ac3@metafoo.de>
Date:   Sun, 15 Jan 2023 18:21:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch> <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
 <Y8SSb+tJsfJ3/DvH@lunn.ch>
From:   Lars-Peter Clausen <lars@metafoo.de>
In-Reply-To: <Y8SSb+tJsfJ3/DvH@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: lars@metafoo.de
X-Virus-Scanned: Clear (ClamAV 0.103.7/26782/Sun Jan 15 09:20:34 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/23 15:55, Andrew Lunn wrote:
>> Specifying the ID as part of the compatible string works for clause 22 PHYs,
>> but for clause 45 PHYs it does not work. The code always wants to read the
>> ID from the PHY itself. But I do not understand things well enough to tell
>> whether that's a fundamental restriction of C45 or just our implementation
>> and the implementation can be changed to fix it.
>>
>> Do you have some thoughts on this?
> Do you have more details about what goes wrong? Which PHY driver is
> it? What compatibles do you put into DT for the PHY?
>
> To some extent, the ID is only used to find the driver. A C45 device
> has a lot of ID register, and all of them are used by phy_bus_match()
> to see if a driver matches. So you need to be careful which ID you
> pick, it needs to match the driver.
>
> It is the driver which decides to use C22 or C45 to talk to the PHY.
> However, we do have:
>
> static int phy_probe(struct device *dev)
> {
> ...
>          else if (phydev->is_c45)
>                  err = genphy_c45_pma_read_abilities(phydev);
>          else
>                  err = genphy_read_abilities(phydev);
>
> so it could be a C45 PHY probed using an ID does not have
> phydev->is_c45 set, and so it looks in the wrong place for the
> capabilities. Make sure you also have the compatible
> "ethernet-phy-ieee802.3-c45" which i think should cause is_c45 to be
> set.
>
> There is no fundamental restriction that i know of here, it probably
> just needs somebody to debug it and find where it goes wrong.
>
> Ah!
>
> int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>                                  struct fwnode_handle *child, u32 addr)
> {
> ...
>          rc = fwnode_property_match_string(child, "compatible",
>                                            "ethernet-phy-ieee802.3-c45");
>          if (rc >= 0)
>                  is_c45 = true;
>
>          if (is_c45 || fwnode_get_phy_id(child, &phy_id))
>                  phy = get_phy_device(bus, addr, is_c45);
>          else
>                  phy = phy_device_create(bus, addr, phy_id, 0, NULL);
>
>
> So compatible "ethernet-phy-ieee802.3-c45" results in is_c45 being set
> true. The if (is_c45 || is then true, so it does not need to call
> fwnode_get_phy_id(child, &phy_id) so ignores whatever ID is in DT and
> asks the PHY.
>
> Try this, totally untested:
>
> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> index b782c35c4ac1..13be23f8ac97 100644
> --- a/drivers/net/mdio/fwnode_mdio.c
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -134,10 +134,10 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>          if (rc >= 0)
>                  is_c45 = true;
>   
> -       if (is_c45 || fwnode_get_phy_id(child, &phy_id))
> +       if (fwnode_get_phy_id (child, &phy_id))
>                  phy = get_phy_device(bus, addr, is_c45);
>          else
> -               phy = phy_device_create(bus, addr, phy_id, 0, NULL);
> +               phy = phy_device_create(bus, addr, phy_id, is_c45, NULL);
>          if (IS_ERR(phy)) {
>                  rc = PTR_ERR(phy);
>                  goto clean_mii_ts;
>
I think part of the problem is that for C45 there are a few other fields 
that get populated by the ID detection, such as devices_in_package and 
mmds_present. Is this something we can do after running the PHY drivers 
probe function? Or is it too late at that point?

