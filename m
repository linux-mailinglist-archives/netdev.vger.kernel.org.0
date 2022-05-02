Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40569516D14
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 11:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384138AbiEBJLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 05:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384146AbiEBJJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 05:09:28 -0400
X-Greylist: delayed 572 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 02 May 2022 02:05:59 PDT
Received: from mx-out2.startmail.com (mx-out2.startmail.com [145.131.90.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6C113CE2
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 02:05:59 -0700 (PDT)
From:   "Marty E. Plummer" <hanetzer@startmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=startmail.com;
        s=2020-07; t=1651481784;
        bh=ApzifE+1m0BfNZP/GHlGdK4KcUaGSFW4BKId5xc64K0=;
        h=From:To:Subject:Date:Message-Id:MIME-Version:
         Content-Transfer-Encoding:From:Subject:To:Date:Sender:Content-Type:
         Content-Transfer-Encoding:Content-Disposition:Mime-Version:
         Reply-To:In-Reply-To:References:Message-Id:Autocrypt;
        b=SMN2LV70xecn/4uBPQs6r/pgHXSbvO42gDcaaTZ3uOjMkpCKLw40xjUw95Q4rbQlx
         /Mz5UxAhmLn/bnt2J4TILlHE/FLqEdau9njXdewq6SHn7CYtmEgDayL7u+K6FKogla
         v8QdwUr19Gipk+M4zobr4GBeI0hFgy5A8vPqSQ+qtAU5l5rkTNEplX7EyGJDrvKZtf
         fjz1wvN/D5XgWyRp8pVef0n4GAkiSjtT5QZJQZ4dPtEzkczfuVuPVTnrPQ6og5Uhhu
         ke+hy7p+/IiQshHBZT7JnRPJL3/WvxTDQfmFkQ3RGcTzL3VD3UaGv/qbnHTRwLLYHm
         8pTcmh5N+h2fw==
To:     netdev@vger.kernel.org
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        p.zabel@pengutronix.de, linux-kernel@vger.kernel.org,
        "Marty E. Plummer" <hanetzer@startmail.com>
Subject: hix5hd2_gmac: inconsistent rx_skb crash.
Date:   Mon,  2 May 2022 03:56:18 -0500
Message-Id: <20220502085618.274927-1-hanetzer@startmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello. As part of my work on the Hi3521a SoC, I'm trying to get
networking and persistent storage up. As far as I can tell, the
registers and bitfields for the 'GSF' in the Hi3521a SoC are almost a
1:1 match against the hix5hd2_gmac driver. Setting up the dts like so:

--- hi3521a.dtsi
gmac0: ethernet@100a0000 {
	compatible = "hisilicon,hisi-gmac-v2";
	reg = <0x100a0000 0x1000>, <0x1204008c 0x4>;
	interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
	clocks = <&crg HI3521A_ETH_CLK>, <&crg HI3521A_ETH_MACIF_CLK>;
	clock-names = "mac_core", "mac_ifc";
	resets = <&crg 0x78 0>, <&crg 0x78 2>, <&crg 0x78 5>;
	reset-names = "mac_core", "mac_ifc", "phy";
	hisilicon,phy-reset-delays-us = <10000 10000 30000>;
	status = "disabled";
};

--- hi3521a-rs-dm290e.dts
&gmac0 {
	#address-cells = <1>;
	#size-cells = <0>;
	phy-handle = <&phy3>;
	phy-mode = "rgmii";
	mac-address = [00 00 00 00 00 00];
	status = "okay";

	phy3: ethernet-phy@3 {
		compatible = "ethernet-phy-id001c.c816", "ethernet-phy-ieee802.3-c22";
		reg = <3>;
	};
};

Does in fact set up most of the things you'd expect. I can read the phy
id from sysfs and such, seems fine. Relevant dmesg logs are:

--- dmesg | grep -C1 -e eth -e mdio
[    8.386695] 0x000000b00000-0x000001f00000 : "extra"
[    8.449664] mdio_bus fixed-0: GPIO lookup for consumer reset
[    8.455453] mdio_bus fixed-0: using lookup tables for GPIO lookup
[    8.461629] mdio_bus fixed-0: No GPIO consumer reset found
[    8.517993] mdio_bus 100a0000.ethernet-mii: GPIO lookup for consumer reset
[    8.525012] mdio_bus 100a0000.ethernet-mii: using device tree for GPIO lookup
[    8.532710] of_get_named_gpiod_flags: can't parse 'reset-gpios' property of node '/soc/ethernet@100a0000[0]'
[    8.543070] of_get_named_gpiod_flags: can't parse 'reset-gpio' property of node '/soc/ethernet@100a0000[0]'
[    8.552970] mdio_bus 100a0000.ethernet-mii: using lookup tables for GPIO lookup
[    8.560367] mdio_bus 100a0000.ethernet-mii: No GPIO consumer reset found
[    8.567650] mdio_bus 100a0000.ethernet-mii:03: GPIO lookup for consumer reset
[    8.574898] mdio_bus 100a0000.ethernet-mii:03: using device tree for GPIO lookup
[    8.582860] of_get_named_gpiod_flags: can't parse 'reset-gpios' property of node '/soc/ethernet@100a0000/ethernet-phy@3[0]'
[    8.594620] of_get_named_gpiod_flags: can't parse 'reset-gpio' property of node '/soc/ethernet@100a0000/ethernet-phy@3[0]'
[    8.605808] mdio_bus 100a0000.ethernet-mii:03: using lookup tables for GPIO lookup
[    8.613455] mdio_bus 100a0000.ethernet-mii:03: No GPIO consumer reset found
[    8.627212] (unnamed net_device) (uninitialized): using random MAC address c6:57:fb:4d:47:ff

However. Setting an ip address (ip addr add 192.168.99.77/24 dev eth0)
and setting the link up (ip link set eth0 up) spams the console with:
[   49.103197] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   49.419046] hisi-gmac 100a0000.ethernet eth0: inconsistent rx_skb
[   49.434159] hisi-gmac 100a0000.ethernet eth0: inconsistent rx_skb
quite a lot. I even saw it crash the system once, but I think that was a
misconfiguration on my part. attached at phy3 is a realtek phy.

At this point everything looks like it should work,
[  628.063999] hisi-gmac 100a0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off
but I cannot ping any other devices on that subnet. Am I missing
something here?
-- 
2.35.1

