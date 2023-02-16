Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E121C698E15
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 08:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjBPHxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 02:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjBPHxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 02:53:41 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2137.outbound.protection.outlook.com [40.107.237.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B1A3C784;
        Wed, 15 Feb 2023 23:53:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LeuxpTam5sMwQWpLpSBrevQ8auHxVcfNtGNZh6nT1rLe5ZEGmL0GfKsoOEsJigRlBXOem+CzzElGEflFFk2/modDar7u5WHn1A+GKVJyZGOcWgrsk4SfsIN6h8n9ihQqo8xo+AUjR/4Wwy4ozs/f4h42YZaY5iaMq08ynIYttQgwoB+kaISRRbvWPPDebnLd0GoPCjIx9RC1xJ7gvfuwQbj9QLggZJrPlqvq9YWdRqRe9D/mMSuUxKpxESxfm0Aj/kNS6RJdxX1KO40VtgipeqJJX7EI8bhrsJyQcQN+eSYGS0MOY6sMSD39WQvJZw+2Y0WLn63lUkxo1M+ZvpUC1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ScHgxMLnDkP1REO65KTp/bBpV/tNHlhYgdPvi8DUeH0=;
 b=oYmPftScrObF+UmNSk0tSYADYoac5lHZZNltC4AF475ccS2CeH3iC4JrezFvcB/YgS+GUg6Wcn4K0BIvKvmLPgMb9Ddhuy/56fEpikJPIQG240ZX9OiTmP6uzr3TJmiKe/m0Gsn1lBKEm6xXTvDjXMpL1qznhsdfoAnQxgwlY+tNb1/yFC0HZdwxd/YpETPTt05Tt1bZLyjawbTiD1U7WiG/mgTtGP5ZdEjfYbHK1EBol6dBY++e+NyR4DDCmhZtaFQKh6W5u5gyg4kmcht6QbUiKUpmuFu/YXrAXh5DT7bonc6qMrFQQ/cfurkK9E6PumRD12jWGCLDOAqsAfYOKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScHgxMLnDkP1REO65KTp/bBpV/tNHlhYgdPvi8DUeH0=;
 b=sZBp4EczZSfoiR6pQLPg60ZDSfdnZPfwoerAyZP3ZF57ptwkRyd1ferAlIUotViILLvC82iH2Zt9NxguQ7Jql0kvWWUsQQUFpw8iKimNVtC0HAlnNhVvNGH9KW7FyZILris+bqcvtBmZS9YA17xLFVTvaB0LDQ93lwCDM8nesgo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by IA1PR10MB5993.namprd10.prod.outlook.com
 (2603:10b6:208:3ef::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Thu, 16 Feb
 2023 07:53:35 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6111.010; Thu, 16 Feb 2023
 07:53:35 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 0/7] add support for ocelot external ports
Date:   Wed, 15 Feb 2023 23:53:14 -0800
Message-Id: <20230216075321.2898003-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:254::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|IA1PR10MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: a833af51-97ce-4b2d-8627-08db0ff2e7b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bVaX4aaxmz19T9tCbYHS/ZOGXpxr+2QLDEiAT8vIz/QBYoQ5p3QH+yu83LIrVdFACCrZJgYNwPP7GlicmbfgBxH78CjPnscVfoERwsBMbMD6ABTtgMJ5Py1S2HK3yb9QORBI5G5Rk+9k9D6/u0mMbcU7fTEz2tX/66t2M9zlo9EtkfgDuPAeTraLVMPCWzT7FaXv98nZqF1OLIyTfNveifFP3W1BmS9Y1rIGfn+iQCtWLfNG2m1alI1NTFui09JvSXfdou23TCBsZ+Ej+NMJvruLckOTXOtNd3ZeUReenSiS+HHRiSOtMMfatnGhD8J5ZCfrdi+s0xjNnrVfU8jKSvglcTFYnbMUb8shWowGeqSme76pvnTj2wtrQ4ggGHyiYPqstBA/xs+yrOiPCwuRtoGa3GeXBJ8cOSu2J+JBFCaJ+RPygL05spXojemwHxMCU184sb9XieZgabQdtKnLGu41DlZ1O9pQT54hNHzGuViDb/Sjg7+PgGGYcLPsp8lMJQ0lR6Ngt1fxUd2HaXMT/XDXm1vxqKYowLaiGZiHXYR/K51SVZSLfxviVJPxLY563PGMAMgjBilf6A0OElg7nVI342vIfwoDVi87b+69d/iNZHSXMY+S5CKM0ctY2icyIioJuCfBG/MfHpnv33Y7PagWVf7+n9wub9VDvmOPgwHIB5QjtaAXAI8mpSp8lQxC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39830400003)(396003)(366004)(346002)(376002)(451199018)(83380400001)(5660300002)(38350700002)(41300700001)(2906002)(8936002)(38100700002)(2616005)(6506007)(26005)(6512007)(186003)(6666004)(478600001)(966005)(52116002)(6486002)(44832011)(1076003)(86362001)(316002)(66476007)(66946007)(54906003)(4326008)(8676002)(66556008)(7416002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/HL29o9MStVcfLktDCzs3L/2crW+lo0nzGMQ5QqiQba0kedslHloo9Js2FKu?=
 =?us-ascii?Q?QbK8ndoPhrGctzy55CfyhpjGka5xJDU4VuZXldHcLoykgKuXrguN8LHqmOJg?=
 =?us-ascii?Q?yF7dlAzzFjSp2NIYYyEYs8YmS/8RCXxfPHCtvnPa8B9PZRdgkY+F/2LALOou?=
 =?us-ascii?Q?kut+h74EQnfKjRto8ZUkGjBuFqxbMF95bakYI+keUXeNYPdAUTeM0RHoYWA6?=
 =?us-ascii?Q?vo/5QKQlqnJS+gAsfdA+vQTTjy+kGwTIjPnoYzlkCAlE3ZnYkNTTTQ9aLsJi?=
 =?us-ascii?Q?JOtKEQ+8JlVmZMbaCInYRfa1ZtN3/USD+r1rhJNJ8E/ao9Tvx1sf41cQLqi2?=
 =?us-ascii?Q?Eunsoc9KLTT4DjH9Km4gjE43MWbqeZLB0jBr5KYNZFAWifsE8PPPB1EJSOOU?=
 =?us-ascii?Q?88FSPRPJ9TqmMZiOVpGoDhw2iMCFSOAY14vEPPQ+VoZmCCnDuKnGDDgmxNU3?=
 =?us-ascii?Q?GZZGVOmFS0YQgbqg86m/5DINCMe7Deq8g92uJsYO/W/peL9rFbIxXQHYvShP?=
 =?us-ascii?Q?TkDu4w061HR1jyEhW5+q6+qFE0XJfOfLdCtpe+W+NX3RkhM+1JoRTkrMy7Sx?=
 =?us-ascii?Q?MQfzZtm8dwyFhk4uiaxl+2CiDkCfDw3epfJevbDVrcUwbqT0I8x73iNk1atH?=
 =?us-ascii?Q?zACkjcrlrUnbeeeG/uJ8yFfv8gTZOw0GtCNI/FaIStAqSSJcGuJ27SnOVc5a?=
 =?us-ascii?Q?RlJMmVu7Zbg/oF98Y6SW0FRS8kN4pC5fw0/F3u7IgpgMmxeH2MYqJmwhv8Yl?=
 =?us-ascii?Q?vPjnLhmUHbhoQkUYuG2fvYZgJEf2IIhdPHFiIsS2EvXHsQ8G7iFcVlPuZIMq?=
 =?us-ascii?Q?wQmdXzPekVB4iLhmxQ5kz/2VC9crL+576C1Ao2UnXnWcR2ECb/REBdcmFvzc?=
 =?us-ascii?Q?pf+n1I8KwRpYvMmqfmLrgVVpGkTxLix3XZZwUMOm9qh2ujmZhvqLyx0NjSva?=
 =?us-ascii?Q?rxb8LgNIt0rhVI60OiBkRfmbkvBMGKS2+G7BRaMLTRzya4o3w2SPbxNpEeGT?=
 =?us-ascii?Q?29zPhQSkaxSFjhijo6uwwCFY3k+N4elpQ6ZAdtPajpKg8A9kdi1EncJWW8uj?=
 =?us-ascii?Q?7aoKAyYt6vaw0uiJD3e39VG1ypsWiOb/iybhc3zAppRbZsT4hNr18svz5U2V?=
 =?us-ascii?Q?n2TAe7MkLF+FkYIQxcXrbCSw2iR21RG7y/J8MhTe7UVZkXZR4lXceKcCl97f?=
 =?us-ascii?Q?yK2HiTwsKdO2PwPEXJB6e79ztw//UN/gz6kIYkv/IfnppDZ1TtvJoJhjT6ht?=
 =?us-ascii?Q?SDIyPp1kJKD+goxsTriWeTHmrwTsd4ww7T6eLfJ4n5BDG3Mo3l9pEf+45Mew?=
 =?us-ascii?Q?/1WMpMDMkOtKQbTleaqsTyP4C3WEiT5JbBAkLwvTi7sBes5hLGH+kwovsowc?=
 =?us-ascii?Q?Kt8Z0yxWMZzcpPqniLFHIF3NK/Wmwkk7qoLqLPD67jwJvryF6qucgnVVMAbS?=
 =?us-ascii?Q?XhOFQ9nCBapb7OccAtGFJOKQJyzKDEr9YeuP1zkHXM6AW5UZgLtvkArbGF0W?=
 =?us-ascii?Q?it+AmfB7lMdYKqpQpR+tCBX72EiMCbbKR5jTYJESzydoPzyPcVsNh/eeLBPl?=
 =?us-ascii?Q?D9DrJbQuyAS0PPZtdT+AV9JPUdVaZHVDdQny4EW75cdYmo34nF42LeQcskY0?=
 =?us-ascii?Q?7OOW6TZaUvxefMsye2FtaMA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a833af51-97ce-4b2d-8627-08db0ff2e7b9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 07:53:34.9129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUNnUEyEpS4PFnc7s/P3UXXY14Cbf+MSrqymHXmeNAJIqwdw066DL6WHhEG7R8JcqaitPw4q69JFc/TaA4qmjRgQKTfzLLHyB6FnzJXYn2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5993
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the start of part 3 of what is hopefully a 3-part series to add
Ethernet switching support to Ocelot chips.

Part 1 of the series (A New Chip) added general support for Ocelot chips
that were controlled externally via SPI.
https://lore.kernel.org/all/20220815005553.1450359-1-colin.foster@in-advantage.com/

Part 2 of the series (The Ethernet Strikes Back) added DSA Ethernet
support for ports 0-3, which are the four copper ports that are internal
to the chip.
https://lore.kernel.org/all/20230127193559.1001051-1-colin.foster@in-advantage.com/

Part 3 will, at a minimum, add support for ports 4-7, which are
configured to use QSGMII to an external phy (Return Of The QSGMII). With
any luck, and some guidance, support for SGMII, SFPs, etc. will also be
part of this series.


This patch series is absolutely an RFC at this point. While all 8 copper
ports on the VSC7512 are currently functional, I recognize there are a
couple empty function callbacks in the last patch that likely need to be
implemented.

Aside from that, there is feedback I'd greatly appreciate. Specifically
patch 6 ("net: dsa: felix: allow external parsing of port nodes") and
whether that is an acceptable way to solve the problem at hand.

Also, with patch 7 ("net: dsa: ocelot_ext: add support for external phys")
my basis was the function mscc_ocelot_init_ports(), but there were several
changes I had to make for DSA / Phylink. Are my implementations of
ocelot_ext_parse_port_node() and ocelot_ext_phylink_create() barking up
the right tree?


For reference, a boot log in case it is useful:

[    3.222208] pinctrl-ocelot ocelot-pinctrl.0.auto: DMA mask not set
[    3.231781] pinctrl-ocelot ocelot-pinctrl.0.auto: driver registered
[    3.241747] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: DMA mask not set
[    3.260366] mscc-miim ocelot-miim0.2.auto: DMA mask not set
[    3.787309] mscc-miim ocelot-miim1.3.auto: DMA mask not set
[    3.822367] mscc,ocelot-serdes ocelot-serdes.4.auto: DMA mask not set
[    3.837637] ocelot-switch ocelot-switch.5.auto: DMA mask not set
[    5.368119] ocelot-switch ocelot-switch.5.auto: PHY [ocelot-miim1.3.auto-mii:04] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    5.668093] ocelot-switch ocelot-switch.5.auto: PHY [ocelot-miim1.3.auto-mii:05] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    5.968342] ocelot-switch ocelot-switch.5.auto: PHY [ocelot-miim1.3.auto-mii:06] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    6.288098] ocelot-switch ocelot-switch.5.auto: PHY [ocelot-miim1.3.auto-mii:07] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    6.364114] ocelot-switch ocelot-switch.5.auto: PHY [ocelot-miim0.2.auto-mii:00] driver [Generic PHY] (irq=POLL)
[    6.375061] ocelot-switch ocelot-switch.5.auto: configuring for phy/internal link mode
[    6.391843] ocelot-switch ocelot-switch.5.auto swp1 (uninitialized): PHY [ocelot-miim0.2.auto-mii:01] driver [Generic PHY] (irq=POLL)
[    6.410033] ocelot-switch ocelot-switch.5.auto swp2 (uninitialized): PHY [ocelot-miim0.2.auto-mii:02] driver [Generic PHY] (irq=POLL)
[    6.427761] ocelot-switch ocelot-switch.5.auto swp3 (uninitialized): PHY [ocelot-miim0.2.auto-mii:03] driver [Generic PHY] (irq=POLL)
[    6.598305] ocelot-switch ocelot-switch.5.auto swp4 (uninitialized): PHY [ocelot-miim1.3.auto-mii:04] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    6.778331] ocelot-switch ocelot-switch.5.auto swp5 (uninitialized): PHY [ocelot-miim1.3.auto-mii:05] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    6.958337] ocelot-switch ocelot-switch.5.auto swp6 (uninitialized): PHY [ocelot-miim1.3.auto-mii:06] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    7.138379] ocelot-switch ocelot-switch.5.auto swp7 (uninitialized): PHY [ocelot-miim1.3.auto-mii:07] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    7.156375] device eth0 entered promiscuous mode
[    7.161140] DSA: tree 0 setup


And a couple device tree snippets of the ports:

&spi0 {
        #address-cells = <1>;
        #size-cells = <0>;
        status = "okay";

        soc@0 {
                compatible = "mscc,vsc7512";
                spi-max-frequency = <2500000>;
                reg = <0 0>;
                #address-cells = <1>;
                #size-cells = <1>;

                ethernet-switch@71010000 {
                        compatible = "mscc,vsc7512-switch";
                        ...

                        ports {
                                ...
                                port@4 {
                                       reg = <4>;
                                       label = "swp4";
                                       status = "okay";
                                       phy-handle = <&sw_phy4>;
                                       phy-mode = "qsgmii";
                                       phys = <&serdes 4 SERDES6G(0)>;
                               };
                               ...
                        };
                        ...
                };

                mdio@710700c0 {
                        compatible = "mscc,ocelot-miim";
                        pinctrl-names = "default";
                        pinctrl-0 = <&miim1>;
                        #address-cells = <1>;
                        #size-cells = <0>;
                        reg = <0x710700c0 0x24>;

                        sw_phy4: ethernet-phy@4 {
                                reg = <0x4>;
                        };
                        ...
                };
                ...

                serdes: serdes {
                        compatible = "mscc,vsc7514-serdes";
                        #phy-cells = <2>;
                };
        };
};



Colin Foster (7):
  phy: phy-ocelot-serdes: add ability to be used in a non-syscon
    configuration
  mfd: ocelot: add ocelot-serdes capability
  net: mscc: ocelot: expose ocelot_pll5_init routine
  net: mscc: ocelot: expose generic phylink_mac_config routine
  net: dsa: felix: attempt to initialize internal hsio plls
  net: dsa: felix: allow external parsing of port nodes
  net: dsa: ocelot_ext: add support for external phys

 drivers/mfd/ocelot-core.c                  |  13 +
 drivers/net/dsa/ocelot/felix.c             |  57 +++-
 drivers/net/dsa/ocelot/felix.h             |   6 +
 drivers/net/dsa/ocelot/ocelot_ext.c        | 319 ++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot.c         |  57 ++++
 drivers/net/ethernet/mscc/ocelot_net.c     |  21 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  30 --
 drivers/phy/mscc/phy-ocelot-serdes.c       |   9 +
 include/soc/mscc/ocelot.h                  |   5 +
 9 files changed, 440 insertions(+), 77 deletions(-)

-- 
2.25.1

