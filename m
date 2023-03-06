Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159CB6ACD7A
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 20:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCFTEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 14:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjCFTD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 14:03:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080252D56;
        Mon,  6 Mar 2023 11:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Hs9cE/jMhmLn1aS6B5/r7nVSBq794QvOcPkISP8ZkTg=; b=hn3abSiVLOqaRsTZ+E6NnB8mom
        2zllyK4b4NpXmIy/3w3Saj6IaKRQ04TPR16e9Ez4RaBx+xU4bg/4sOcfDO/vvTNK5fLv/0QnsumjS
        Hc4KsSCgjI8jnC15Zvcnzh+Oapp0x68RKWkOkFnbE4L/W6IT04i11+CtV1/103XF10lY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZG6h-006bAl-Vp; Mon, 06 Mar 2023 20:02:47 +0100
Date:   Mon, 6 Mar 2023 20:02:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-aspeed@lists.ozlabs.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH net-next v2 4/6] net: mdio: scan bus based on bus
 capabilities for C22 and C45
Message-ID: <db6b8a09-b680-4baa-8963-d355ad29eb09@lunn.ch>
References: <20230116-net-next-remove-probe-capabilities-v2-0-15513b05e1f4@walle.cc>
 <20230116-net-next-remove-probe-capabilities-v2-4-15513b05e1f4@walle.cc>
 <449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com>
 <100c439a-2a4d-4cb2-96f2-5bf273e2121a@lunn.ch>
 <712bc92ca6d576f33f63f1e9c2edf0030b10d3ae.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <712bc92ca6d576f33f63f1e9c2edf0030b10d3ae.camel@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> dev_warn_ratelimited(bus->parent, "<function_name> %d\n", mii_id);
> 
> at the entry point of each function. And here we go.
> 
> 
> 
> ########
> # good: [3486593374858b41ae6ef7720cb28ff39ad822f3] net: mdio: Add workaround for Micrel PHYs which are not C45 compatible
> 
> *** snip ***
> [    0.194348] Creating 3 MTD partitions on "spi0.0":
> [    0.194353] 0x000000000000-0x0000000f0000 : "U-Boot"
> [    0.194534] 0x000000100000-0x000000800000 : "Rescue system"
> [    0.194652] 0x0000000f0000-0x000000100000 : "u-boot-env"
> [    0.195518] orion-mdio f1072004.mdio: orion_mdio_smi_read 1
> [    0.195592] orion-mdio f1072004.mdio: orion_mdio_smi_read 1
> [    0.202202] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.202280] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.202346] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.202470] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.202534] mv88e6085 f1072004.mdio-mii:10: switch 0x1760 detected: Marvell 88E6176, revision 1
> [    0.202542] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.202674] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.202799] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.202921] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.320192] mvneta_bm f10c8000.bm: Buffer Manager for network controller enabled

So there are no xmdio reads for c45. That is what the commit you
pointed to is about, should it scan C22, C45 or both C45.

> *** snip ***
> [    1.598893] Run /init as init process
> [    1.598896]   with arguments:
> [    1.598898]     /init
> [    1.598900]   with environment:
> [    1.598902]     HOME=/
> [    1.598904]     TERM=linux
> *** snip ***
> [    4.628127] mv88e6085 f1072004.mdio-mii:10 lan3: Link is Up - 1Gbps/Full - flow control rx/tx
> [    4.628150] IPv6: ADDRCONF(NETDEV_CHANGE): lan3: link becomes ready
> [    4.628210] br0: port 2(lan3) entered blocking state
> [    4.628219] br0: port 2(lan3) entered forwarding state
> [    4.629187] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
> [  283.962353] orion_mdio_smi_read: 9231 callbacks suppressed
> [  283.962361] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  283.962492] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  283.962617] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  283.962799] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  283.962981] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  283.963162] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  283.963344] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  283.963466] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  283.963588] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  283.963652] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  310.572411] orion_mdio_smi_read: 56 callbacks suppressed
> [  310.572419] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  310.572550] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  310.572675] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  310.572857] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  310.573039] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  310.573220] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  310.573402] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  310.573524] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  310.573647] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  310.573711] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  726.308614] orion_mdio_smi_read: 56 callbacks suppressed
> [  726.308623] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  726.308754] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  726.308879] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  726.309060] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  726.309242] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  726.309423] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  726.309604] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  726.309727] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  726.309850] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  726.309914] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  841.713791] orion_mdio_smi_read: 56 callbacks suppressed
> [  841.713800] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  841.713931] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  841.714056] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  841.714239] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  841.714420] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  841.714602] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  841.714783] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  841.714906] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  841.715029] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  841.715093] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> 
> 
> 
> #####
> # first bad commit: [1a136ca2e089d91df8eec0a796a324171373ffd8] net: mdio: scan bus based on bus capabilities for C22 and C45
> 
> *** snip ***
> [    0.191685] Creating 3 MTD partitions on "spi0.0":
> [    0.191690] 0x000000000000-0x0000000f0000 : "U-Boot"
> [    0.191871] 0x000000100000-0x000000800000 : "Rescue system"
> [    0.191991] 0x0000000f0000-0x000000100000 : "u-boot-env"
> [    0.192830] orion-mdio f1072004.mdio: orion_mdio_smi_read 1
> [    0.192906] orion-mdio f1072004.mdio: orion_mdio_smi_read 1
> [    0.199530] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.199610] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.199677] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.199799] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.199864] mv88e6085 f1072004.mdio-mii:10: switch 0x1760 detected: Marvell 88E6176, revision 1
> [    0.199871] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.199994] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.200117] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.200239] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    0.396608] ata2: SATA link down (SStatus 0 SControl 300)
> [    0.554697] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    0.555370] ata1.00: supports DRM functions and may not be fully accessible
> [    0.555375] ata1.00: ATA-10: KINGSTON SKC600MS512G, S4800105, max UDMA/133
> [    0.555385] ata1.00: 1000215216 sectors, multi 1: LBA48 NCQ (depth 32)
> [    0.556058] ata1.00: Features: Trust Dev-Sleep
> [    0.556158] ata1.00: supports DRM functions and may not be fully accessible
> [    0.556811] ata1.00: configured for UDMA/133
> [    0.556985] scsi 0:0:0:0: Direct-Access     ATA      KINGSTON SKC600M 0105 PQ: 0 ANSI: 5
> [    0.557485] sd 0:0:0:0: [sda] 1000215216 512-byte logical blocks: (512 GB/477 GiB)
> [    0.557493] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [    0.557515] sd 0:0:0:0: [sda] Write Protect is off
> [    0.557520] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    0.557553] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.557620] sd 0:0:0:0: [sda] Preferred minimum I/O size 4096 bytes
> [    0.558111]  sda: sda1
> [    0.558230] sd 0:0:0:0: [sda] Attached SCSI removable disk
> [    2.741909] mvneta_bm f10c8000.bm: Buffer Manager for network controller enabled
> *** snip ***
> [    3.213998] sfp sfp: module TP-LINK          TL-SM321B        rev      sn 1403076900       dc 140401
> [    3.214020] mvneta f1034000.ethernet eth2: switched to inband/1000base-x link mode
> [    5.194695] orion_mdio_smi_read: 43968 callbacks suppressed
> [    5.194701] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    5.194767] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    5.194891] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    5.195014] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    5.195137] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    5.195259] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    5.195324] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    5.195446] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    5.195510] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    5.195633] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [    6.223184] mv88e6085 f1072004.mdio-mii:10: configuring for fixed/rgmii-id link mode
> [    6.224852] mv88e6085 f1072004.mdio-mii:10: configuring for fixed/rgmii-id link mode
> [    6.226126] mv88e6085 f1072004.mdio-mii:10: Link is Up - 1Gbps/Full - flow control off
> [    6.229455] mv88e6085 f1072004.mdio-mii:10: Link is Up - 1Gbps/Full - flow control off
> [    6.294120] mv88e6085 f1072004.mdio-mii:10 lan0 (uninitialized): PHY [mv88e6xxx-1:00] driver [Marvell 88E1540] (irq=68)
> [    6.366663] mv88e6085 f1072004.mdio-mii:10 lan1 (uninitialized): PHY [mv88e6xxx-1:01] driver [Marvell 88E1540] (irq=69)
> [    6.438843] mv88e6085 f1072004.mdio-mii:10 lan2 (uninitialized): PHY [mv88e6xxx-1:02] driver [Marvell 88E1540] (irq=70)
> [    6.510122] mv88e6085 f1072004.mdio-mii:10 lan3 (uninitialized): PHY [mv88e6xxx-1:03] driver [Marvell 88E1540] (irq=71)
> [    6.582302] mv88e6085 f1072004.mdio-mii:10 lan4 (uninitialized): PHY [mv88e6xxx-1:04] driver [Marvell 88E1540] (irq=72)
> [    6.584680] device eth1 entered promiscuous mode
> [    6.585573] device eth0 entered promiscuous mode
> [    6.585593] DSA: tree 0 setup
> [    6.586408] Freeing unused kernel image (initmem) memory: 1024K
> [    6.586547] Run /init as init process
> [    6.586551]   with arguments:
> [    6.586553]     /init
> [    6.586555]   with environment:
> [    6.586557]     HOME=/
> [    6.586559]     TERM=linux
> *** snip ***
> [    9.437029] mv88e6085 f1072004.mdio-mii:10 lan3: Link is Up - 1Gbps/Full - flow control rx/tx
> [    9.437052] IPv6: ADDRCONF(NETDEV_CHANGE): lan3: link becomes ready
> [    9.437116] br0: port 2(lan3) entered blocking state
> [    9.437125] br0: port 2(lan3) entered forwarding state
> [    9.438061] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
> [    9.469466] systemd-journald[207]: Time jumped backwards, rotating.
> [  414.675728] orion_mdio_smi_read: 11201 callbacks suppressed
> [  414.675736] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  414.675869] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  414.675996] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  414.676179] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  414.676361] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  414.676543] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  414.676725] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  414.676847] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  414.676970] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  414.677034] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  540.809740] orion_mdio_smi_read: 56 callbacks suppressed
> [  540.809748] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  540.809879] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  540.810004] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  540.810186] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  540.810368] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  540.810551] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  540.810732] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  540.810855] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  540.810978] orion-mdio f1072004.mdio: orion_mdio_smi_read 16
> [  540.811042] orion-mdio f1072004.mdio: orion_mdio_smi_read 16

> "orion_mdio_smi_read: 43968 callbacks suppressed" after 5 seconds - quite impressive!

That is probably the switch being configured. I assume it uses address
16?

But it looks like there are many more after the bad commit. So is the
return value messed up, putting the switch driver into a loop? Maybe
print the smi address, register and the return value in
orion_mdio_smi_read(). And maybe the same in the switch driver, if all
reads happen to go through one function.

      Andrew
