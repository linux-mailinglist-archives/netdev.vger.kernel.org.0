Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D017B452AA4
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhKPG1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:27:33 -0500
Received: from mail-bn8nam12on2139.outbound.protection.outlook.com ([40.107.237.139]:56205
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230222AbhKPG0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:26:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFpG5xp6RKBGJoyzvLEgfaILnLEOzu29KMYDNCO7RebHy36C8htMbKuXU3OQB3I9837qyJ+eXb6hZu9Gljllw9HrO3LmxJFbvsVsQ+WvJZ6i9pM9HnlVRukRhh2IxIHXl6kNV6q99Krgg6qqL/9DwkoiXObxHC+6X5vk4hGJq6mAfAmNyGW0274JnWSXrJAP0eNd984jOflNoKEOcyJepUdR6dC8m3LHrfNj2edF2g3BTQlHLLftjMBie0Yl9HWtAtYvGGaMKS89uF4ICarwoneOi9r9M+eQuW40MDYpIW2tqnau6R2MsSiVYJdFkhGpGa8wOt9BhBSs4j/ZzKABAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YldOgDdU++5A2lXJQN+VI81DRsAUOXlqhDIkMxDiuKY=;
 b=ZYHt+jOCbmraEhE1bAkY/a3r8QZtvU2Y2JlBZaNlgm0GuHGufl+QNribqxKlfJ5ccUATKZTZbjLsN2QJdKZ6FxafJTJufHUipmArZXmJ0wIILfLStF10GtyvKkxiur4FLW0eSyfVNaOigbAJ9FW5BTAZk2Bg/dyGYHwb/87tBAHDeZnpULzAlizNaT9Ir3Qy03QhKi2melb1eu11GdKUhs/wXtayXu5jkDc1VnSVHiF6+sW/j6pm6Zw4LJxl4vZOhLeHELCpTNPgGrin+HD29Zvpq6ih8MNoyWqkrpt6ef7K05Hwu8lzFQ5IUx0RSZkWO+J7/uPzdmWdKmvz4yW2Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YldOgDdU++5A2lXJQN+VI81DRsAUOXlqhDIkMxDiuKY=;
 b=sb2FWGHYKxmzSW9YHinwVKm561I5VeDOMJLH0PFL20bM9tuXn22e5UsOGgF93UBPeU5rIbZClz5YhdLWgOSZyrv7H+++32IX7ju6WCe3eeVhxlD1VfpSXnMo010hCyRad7uvezKYszmw10JhVuCLdYdWlBb+6JkELVvuEayo6dY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2383.namprd10.prod.outlook.com
 (2603:10b6:301:31::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Tue, 16 Nov
 2021 06:23:42 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:42 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 00/23] add support for VSC75XX control over SPI
Date:   Mon, 15 Nov 2021 22:23:05 -0800
Message-Id: <20211116062328.1949151-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08aa0a9c-5f66-4b9f-bb16-08d9a8c9a29d
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2383:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2383FF161D329B1C1300F57EA4999@MWHPR1001MB2383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rGlK9OIvpj/YlMOhDc3ciaQLO4K5hjiShqTO57jZIghRFa+cpqeVRBpxQsFYm7b+OR7SQh6/t3BAQNBoxRQM4spkJLA+rm6wmFZrwTtN1TG/kqrXPsb6aVLAk7LusSf6NteBKj2+y+TNdd6KvS7A5mczvc8uHyUR63aJbmgJ0UFyfagnFiR03WDCyqITkuqYSFgPMRUtrX3TmChTLGaxBHJCmvRKnbf3AmxK5avr1XYmrhhEmobKqiGuF8qAow1+Ddg/S5pC+lAhhszZpBmQlcPm3t0xXa0JcTk3VHhC/Ju+mu0TTXDcSpSTWgFeIY8lwf8LrL2L3M7Dx6MchV/3na0BQ/5hhUWWimCAOhuQnUorWBen4RXzqBwhHC3ByE8x6DIbNvrr8c9q9dw0cBqahMqYl0fRxYCSY21PN6d9UsGrmZQs+52TYE1dxoEug7d6yGCraAfiZmQOStOg4QMMm4P93dZknPQWuAbPq1klj+30UfyqnDHcCjUldFkazj1cHGAcXuEnhHQQf+Fm9HXJsTt3KCfutx9dmIMtOR1dP9UkU0NWve87h6enebTAeep8yeuqgCSa9CQonU23c46tuiClNThxu/hMO1baPyl8XUldza/+lP/JT1Z0rWhBpIER5viNbBLYS2olERU8T8JdeRFIGVWSpcR1g0xYtY8sYSv4/RnmhKishT29nu2MS/SODInVULJ+t1g1lF1KNSz75A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39830400003)(136003)(366004)(346002)(396003)(6512007)(54906003)(316002)(4326008)(83380400001)(8676002)(86362001)(44832011)(1076003)(2906002)(66946007)(38100700002)(38350700002)(508600001)(956004)(26005)(66476007)(66556008)(6666004)(30864003)(6486002)(6506007)(52116002)(5660300002)(36756003)(7416002)(8936002)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TtNYJAsRVijuthaMQCCoD3+aBUwrvISO54+NmXEWlQxFT43iqIEEoExuvfNH?=
 =?us-ascii?Q?wT3BHxo1w16wFdsbCgSBM32OWPI8z/GEaQyzScK5bgc5YJJ8KB+noBA92Ifs?=
 =?us-ascii?Q?uUFSBJTpfzPYQme02vLwPAJ4MWepowug8fxuToe+4gH5atiEbUKEUBgNl7Er?=
 =?us-ascii?Q?JcTpOqKu7GVG3qBlVWFwSmwioo4i5G+pJsYf08pO3nYYuG1lWecIwkJw5Sa+?=
 =?us-ascii?Q?HE5jyeOyBfzyc1HFNXMAtqcL+6AQL83esA/EIv8gXdGt/8SBXm/Io3fNEao/?=
 =?us-ascii?Q?J1RUMqe92H3YmqABgtWEXEwvhxQA/ZZ6KWxYUV9f6NyagdFMiY1B3dus7XN8?=
 =?us-ascii?Q?i3J7KrOoHom70yw8oG+tF0Jo2zBvRIIWTYxiNbRqG8jtDtSTUOcXyPLtA60j?=
 =?us-ascii?Q?5JcJM18AgrxA+uZ4mj+DDbgiq5kNc2NdkpW+CXXD/FTk4xTuLdjmXsR++l4F?=
 =?us-ascii?Q?F61AfPrDcdoJhhrYh/AQArYAX9PyvqigjjyZCAyYoD828SeAbRm0EN/uE2W5?=
 =?us-ascii?Q?i5f4V1AcX6NI257t4qRUxLVd/3Hx5/KALKSDQWYsHbCjhoJFK5Qw6SkUupjA?=
 =?us-ascii?Q?ZJVFGUkbThroYxIvAAL4kXTmxnJLoJeaS2t25peE3ISrSXdlPEO44Mr1RnUU?=
 =?us-ascii?Q?Wi1ldB37e9yMXGBD15xXCAGlyJoF9apViIjBM7geAix71y1RnS/VYPJ3uqI0?=
 =?us-ascii?Q?s5XaACiyCYMULquIwn/MOLurGAOlOHaNvIlRQOFmg265DACkwBYZ+8BD1XQx?=
 =?us-ascii?Q?Y9RGvFuj1HmGheWjqd9N+5JrRDxrjzTZW2xtIeVmrurgT3NUcA6MiJueP/ft?=
 =?us-ascii?Q?SW697abopgOYqPE2Srg9/Gte9dC/6cgE4hUUJwyotEOrADwAIqa2pl/Ih27M?=
 =?us-ascii?Q?gsez2BVGqW3A5NwRIF+tBHj2wFjCNkym/qcaKyfNqXD1kTVY4vNUo18CM6dt?=
 =?us-ascii?Q?gzFSbxOG0Btl+rn2BXo8Hu9XJHnPw+h46mlHEvU4X1sv7j1FmLbRt60XrZVh?=
 =?us-ascii?Q?anj6wTFBBSkLrHbXjIX34k/BQSMJkLInXYEftVoZXDZlmere7e3/OoYq8cuR?=
 =?us-ascii?Q?6GqR6DaSbDC1QFXAVfk/AxuPex76UPY6mfx93hRaDbueQUU18mW5bB8ogvAe?=
 =?us-ascii?Q?yXdXf/Dn9++E/C4e+p+cq5fwkNolO7WN7y0p+8GLwtXNlN2OquBfyvb0YZIh?=
 =?us-ascii?Q?B3NUYnpd8ryTSq4k0D9bRnMgG2q+4dxviqOM/C2iQ6CbAlLXmvUCf5UVKcJc?=
 =?us-ascii?Q?S9qjBi/UxmaT3G+xpwd4/PxK1dE3tpWx/YeWx6NUIvQEMNqfOjN3r759Z2Fa?=
 =?us-ascii?Q?ELy08yS2ROkvirHNsTVrGMq0at77WEghKq6WgYmj9xoYWi2VhzZMjHy5D/2o?=
 =?us-ascii?Q?2I2Ou+tfFCnUKJLXbKXDA6NFHVnht9DHZFF6ZvA2ccT7ytm3raoRAAYYem7t?=
 =?us-ascii?Q?MFm5EooUZpKP+PKv/p6EqaihLEPHwjj8XB2qL0QNVoTH1tquZwQI1teLe77O?=
 =?us-ascii?Q?wloPrjNTZCEmLQoiabarROOVv2nJG2LQhENocIn+jt4eTy43/VmN2DSPgKiM?=
 =?us-ascii?Q?kYL79BxCwBJk6QKFAdyFK+nRnEwcwigqWLGB8JlPKShsHBzvZwuCD9qILi3F?=
 =?us-ascii?Q?DzdKf4qUJ9Cd7mRHMYPTGTZEp/ooVgwDfE5vTpX6E4jVbAw2kYos5c6vDnA+?=
 =?us-ascii?Q?wFVMgNj+8deGzWiZ4PpVwN285EE=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08aa0a9c-5f66-4b9f-bb16-08d9a8c9a29d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:42.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t0NhQdVJjAgTfER66o0Xvm4u1sHFI6v/MnrROWXRJRr4wI7pufKpnbMAMeSNVsC3RGN53//lpWkaZlHo4RNkJRr5pFbyjYGVM9kP/zM56cw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2383
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My apologies for this next RFC taking so long. Life got in the way.


The patch set in general is to add support for the VSC7511, VSC7512,
VSC7513 and VSC7514 devices controlled over SPI. The driver is
relatively functional for the internal phy ports (0-3) on the VSC7512.
As I'll discuss, it is not yet functional for other ports yet.


I still think there are enough updates to bounce by the community
in case I'm terribly off base or doomed to chase my tail.


The main changes for V4 are trying to get pinctrl-ocelot and
pinctrl-microchip-sgpio functional. Without pinctrl-ocelot,
communication to external phys won't work. Without communication to
external phys, PCS ports 4-7 on the dev board won't work. Nor will any
fiber ports. 


The hardware setup I'm using for development is a beaglebone black, with
jumpers from SPI0 to the microchip VSC7512 dev board. The microchip dev 
board has been modified to not boot from flash, but wait for SPI. An
ethernet cable is connected from the beaglebone ethernet to port 0 of
the dev board.


The device tree I'm using for the VSC7512 is below. Note that ports 4-7
are still not expected to work, but left in as placeholders for when
they do.


&spi0 {
	#address-cells = <1>;
	#size-cells = <0>;
	status = "okay";

	ethernet-switch@0{
		 compatible = "mscc,vsc7512";
		 spi-max-frequency = <250000>;
		 reg = <0>;

		 ports {
			#address-cells = <1>;
			#size-cells = <0>;

			port@0 {
				reg = <0>;
				label = "cpu";
				status = "okay";
				ethernet = <&mac_sw>;
				phy-handle = <&sw_phy0>;
				phy-mode = "internal";
			};

			port@1 {
				reg = <1>;
				label = "swp1";
				status = "okay";
				phy-handle = <&sw_phy1>;
				phy-mode = "internal";
			};

			port@2 {
				reg = <2>;
				label = "swp2";
				status = "okay";
				phy-handle = <&sw_phy2>;
				phy-mode = "internal";
			};

			port@3 {
				reg = <3>;
				label = "swp3";
				status = "okay";
				phy-handle = <&sw_phy3>;
				phy-mode = "internal";
			};

			port@4 {
				reg = <4>;
				label = "swp4";
				status = "okay";
				phy-handle = <&sw_phy4>;
				phy-mode = "sgmii";
			};

			port@5 {
				reg = <5>;
				label = "swp5";
				status = "okay";
				phy-handle = <&sw_phy5>;
				phy-mode = "sgmii";
			};

			port@6 {
				reg = <6>;
				label = "swp6";
				status = "okay";
				phy-handle = <&sw_phy6>;
				phy-mode = "sgmii";
			};

			port@7 {
				reg = <7>;
				label = "swp7";
				status = "okay";
				phy-handle = <&sw_phy7>;
				phy-mode = "sgmii";
			};
		};

		mdio {
			#address-cells = <1>;
			#size-cells = <0>;

			sw_phy0: ethernet-phy@0 {
				#address-cells = <1>;
				#size-cells = <0>;
				reg = <0x0>;
			};

			sw_phy1: ethernet-phy@1 {
				#address-cells = <1>;
				#size-cells = <0>;
				reg = <0x1>;
			};

			sw_phy2: ethernet-phy@2 {
				#address-cells = <1>;
				#size-cells = <0>;
				reg = <0x2>;
			};

			sw_phy3: ethernet-phy@3 {
				#address-cells = <1>;
				#size-cells = <0>;
				reg = <0x3>;
			};

			sw_phy4: ethernet-phy@4 {
				#address-cells = <1>;
				#size-cells = <0>;
				reg = <0x4>;
			};

			sw_phy5: ethernet-phy@5 {
				#address-cells = <1>;
				#size-cells = <0>;
				reg = <0x5>;
			};

			sw_phy6: ethernet-phy@6 {
				#address-cells = <1>;
				#size-cells = <0>;
				reg = <0x6>;
			};

			sw_phy7: ethernet-phy@7 {
				#address-cells = <1>;
				#size-cells = <0>;
				reg = <0x7>;
			};
		};

		gpio: pinctrl {
			compatible = "mscc,ocelot-pinctrl";
			#address-cells = <1>;
			#size-cells = <0>;
			#gpio_cells = <2>;
			gpio-ranges = <&gpio 0 0 22>;

			led_shift_reg_pins: led-shift-reg-pins {
				pins = "GPIO_0", "GPIO_1", "GPIO_2", "GPIO_3";
				function = "sg0";
			};
		};

		sgpio: sgpio {
			compatible = "mscc,ocelot-sgpio";
			#address-cells = <1>;
			#size-cells = <0>;
			bus-frequency=<12500000>;
			clocks = <&ocelot_clock>;
			microchip,sgpio-port-ranges = <0 31>;

			sgpio_in0: sgpio@0 {
				compatible = "microchip,sparx5-sgpio-bank";
				reg = <0>;
				gpio-controller;
				#gpio-cells = <3>;
				ngpios = <32>;
			};

			sgpio_out1: sgpio@1 {
				compatible = "microchip,sparx5-sgpio-bank";
				reg = <1>;
				gpio-controller;
				gpio-cells = <3>;
				ngpios = <32>;
			};
		};
	};
};


My main focus is getting the ocelot-pinctrl driver fully functional. My
current hope is that it would correctly set GPIO pins 0-3 into the "sg0"
state. That is not the case right now, and I'll be looking into why. The
behavior I'm hoping for is to be able to configure the sgpio LEDs for
activity at the very least. Link status would be a bonus.


I do have pinctrl by way of debugfs and sysfs. There aren't any debug
LEDs that are attached to unused pins, unfortunately. That would've been
really helpful. So there's a key takeaway for dev-board manufacturers.


As you'll see, the main changes to the three drivers I'm utilizing
(mscc_miim, pinctrl-ocelot, and pinctrl-microchip-sgpio) follow a
similar path. First, convert everything to regmap. Second, expose
whatever functions are necessary to fully utilize an external regmap.


One thing to note: I've been following a pattern of adding "offset"
variables to these drivers. I'm looking for feedback here, because I
don't like it - however I feel like it is the "least bad" interface I
could come up with. 


Specifically, ocelot has a regmap for GCB. ocelot-pinctrl would create a
smaller regmap at an address of "GCB + 0x34".


There are three options I saw here:
1. Have vsc7512_spi create a new regmap at GCB + 0x34 and pass that to
ocelot-pinctrl
2. Give ocelot-pinctrl the concept of a "parent bus" by which it could
request a regmap. 
3. Keep the same GCB regmap, but pass in 0x34 as an offset.


I will admit that option 2 sounds very enticing, but I don't know if
that type of interaction exists. If not, implementing it is probably
outside the scope of a first patch set. As such, I opted for option 3.


Version 4 also fixes some logic for MDIO probing. It wasn't using the
device tree by way of of_mdiobus_register. Now it is.


The relevant boot log for the switch / MDIO bus is here. As expected,
devices 4-7 are missing. If nothing else, that is telling me that the
device tree is working.

[    4.005195] mdio_bus spi0.0-mii:03: using lookup tables for GPIO lookup
[    4.005205] mdio_bus spi0.0-mii:03: No GPIO consumer reset found
[    4.006586] mdio_bus spi0.0-mii: MDIO device at address 4 is missing.
[    4.014333] mdio_bus spi0.0-mii: MDIO device at address 5 is missing.
[    4.022009] mdio_bus spi0.0-mii: MDIO device at address 6 is missing.
[    4.029573] mdio_bus spi0.0-mii: MDIO device at address 7 is missing.
[    8.386624] vsc7512 spi0.0: PHY [spi0.0-mii:00] driver [Generic PHY] (irq=POLL)
[    8.397222] vsc7512 spi0.0: configuring for phy/internal link mode
[    8.419484] vsc7512 spi0.0 swp1 (uninitialized): PHY [spi0.0-mii:01] driver [Generic PHY] (irq=POLL)
[    8.437278] vsc7512 spi0.0 swp2 (uninitialized): PHY [spi0.0-mii:02] driver [Generic PHY] (irq=POLL)
[    8.452867] vsc7512 spi0.0 swp3 (uninitialized): PHY [spi0.0-mii:03] driver [Generic PHY] (irq=POLL)
[    8.465007] vsc7512 spi0.0 swp4 (uninitialized): no phy at 4
[    8.470721] vsc7512 spi0.0 swp4 (uninitialized): failed to connect to PHY: -ENODEV
[    8.478388] vsc7512 spi0.0 swp4 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 4
[    8.489636] vsc7512 spi0.0 swp5 (uninitialized): no phy at 5
[    8.495371] vsc7512 spi0.0 swp5 (uninitialized): failed to connect to PHY: -ENODEV
[    8.502996] vsc7512 spi0.0 swp5 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 5
[    8.514186] vsc7512 spi0.0 swp6 (uninitialized): no phy at 6
[    8.519882] vsc7512 spi0.0 swp6 (uninitialized): failed to connect to PHY: -ENODEV
[    8.527539] vsc7512 spi0.0 swp6 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 6
[    8.538716] vsc7512 spi0.0 swp7 (uninitialized): no phy at 7
[    8.544451] vsc7512 spi0.0 swp7 (uninitialized): failed to connect to PHY: -ENODEV
[    8.552079] vsc7512 spi0.0 swp7 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 7
[    8.571962] device eth0 entered promiscuous mode
[    8.576684] DSA: tree 0 setup
[   10.490093] vsc7512 spi0.0: Link is Up - 100Mbps/Full - flow control off


Much later on, I created a bridge with STP (and two ports jumped
together) as a test. Everything seems to be working as expected. 


[59839.920340] cpsw-switch 4a100000.switch: starting ndev. mode: dual_mac
[59840.013636] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver (mii_bus:phy_addr=4a101000.mdio:00, irq=POLL)
[59840.031444] 8021q: adding VLAN 0 to HW filter on device eth0
[59840.057406] vsc7512 spi0.0 swp1: configuring for phy/internal link mode
[59840.089302] vsc7512 spi0.0 swp2: configuring for phy/internal link mode
[59840.121514] vsc7512 spi0.0 swp3: configuring for phy/internal link mode
[59840.167589] br0: port 1(swp1) entered blocking state
[59840.172818] br0: port 1(swp1) entered disabled state
[59840.191078] device swp1 entered promiscuous mode
[59840.224855] br0: port 2(swp2) entered blocking state
[59840.229893] br0: port 2(swp2) entered disabled state
[59840.245844] device swp2 entered promiscuous mode
[59840.270839] br0: port 3(swp3) entered blocking state
[59840.276003] br0: port 3(swp3) entered disabled state
[59840.291674] device swp3 entered promiscuous mode
[59840.663239] vsc7512 spi0.0: Link is Down
[59841.691641] vsc7512 spi0.0: Link is Up - 100Mbps/Full - flow control off
[59842.167897] cpsw-switch 4a100000.switch eth0: Link is Up - 100Mbps/Full - flow control off
[59842.176481] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[59843.216121] vsc7512 spi0.0 swp1: Link is Up - 1Gbps/Full - flow control rx/tx
[59843.231076] IPv6: ADDRCONF(NETDEV_CHANGE): swp1: link becomes ready
[59843.237593] br0: port 1(swp1) entered blocking state
[59843.242629] br0: port 1(swp1) entered listening state
[59843.301447] vsc7512 spi0.0 swp3: Link is Up - 1Gbps/Full - flow control rx/tx
[59843.309027] IPv6: ADDRCONF(NETDEV_CHANGE): swp3: link becomes ready
[59843.315544] br0: port 3(swp3) entered blocking state
[59843.320545] br0: port 3(swp3) entered listening state
[59845.042058] br0: port 3(swp3) entered blocking state
[59858.401566] br0: port 1(swp1) entered learning state
[59871.841910] br0: received packet on swp1 with own address as source address (addr:24:76:25:76:35:37, vlan:0)
[59873.761495] br0: port 1(swp1) entered forwarding state
[59873.766703] br0: topology change detected, propagating
[59873.776278] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
[59902.561908] br0: received packet on swp1 with own address as source address (addr:24:76:25:76:35:37, vlan:0)
[59926.494446] vsc7512 spi0.0 swp2: Link is Up - 1Gbps/Full - flow control rx/tx
[59926.501959] IPv6: ADDRCONF(NETDEV_CHANGE): swp2: link becomes ready
[59926.508702] br0: port 2(swp2) entered blocking state
[59926.513868] br0: port 2(swp2) entered listening state
[59941.601540] br0: port 2(swp2) entered learning state
[59956.961493] br0: port 2(swp2) entered forwarding state
[59956.966711] br0: topology change detected, propagating
[59968.481839] br0: received packet on swp1 with own address as source address (addr:24:76:25:76:35:37, vlan:0)


In order to make this work, I have modified the cpsw driver, and now the
cpsw_new driver, to allow for frames over 1500 bytes. Otherwise the
tagging protocol will not work between the beaglebone and the VSC7512. I
plan to eventually try to get those changes in mainline, but I don't
want to get distracted from my initial goal.


RFC history:
v1 (accidentally named vN)
	* Initial architecture. Not functional
	* General concepts laid out

v2
	* Near functional. No CPU port communication, but control over all
	external ports
	* Cleaned up regmap implementation from v1

v3
	* Functional
	* Shared MDIO transactions routed through mdio-mscc-miim
	* CPU / NPI port enabled by way of vsc7512_enable_npi_port /
	felix->info->enable_npi_port
	* NPI port tagging functional - Requires a CPU port driver that supports
	frames of 1520 bytes. Verified with a patch to the cpsw driver

v4
    * Functional
    * Device tree fixes
    * Add hooks for pinctrl-ocelot - some functionality by way of sysfs
    * Add hooks for pinctrl-microsemi-sgpio - not yet fully functional
    * Remove lynx_pcs interface for a generic phylink_pcs. The goal here
    is to have an ocelot_pcs that will work for each configuration of
    every port. 



Colin Foster (23):
  net: dsa: ocelot: remove unnecessary pci_bar variables
  net: mdio: mscc-miim: convert to a regmap implementation
  net: dsa: ocelot: seville: utilize of_mdiobus_register
  net: dsa: ocelot: felix: switch to mdio-mscc-miim driver for indirect
    mdio access
  net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
  net: dsa: ocelot: felix: add interface for custom regmaps
  net: dsa: ocelot: felix: add per-device-per-port quirks
  net: mscc: ocelot: split register definitions to a separate file
  net: mscc: ocelot: expose ocelot wm functions
  pinctrl: ocelot: combine get resource and ioremap into single call
  pinctrl: ocelot: update pinctrl to automatic base address
  pinctrl: ocelot: convert pinctrl to regmap
  pinctrl: ocelot: expose ocelot_pinctrl_core_probe interface
  pinctrl: microchip-sgpio: update to support regmap
  device property: add helper function fwnode_get_child_node_count
  pinctrl: microchip-sgpio: change device tree matches to use nodes
    instead of device
  pinctrl: microchip-sgpio: expose microchip_sgpio_core_probe interface
  net: phy: lynx: refactor Lynx PCS module to use generic phylink_pcs
  net: dsa: felix: name change for clarity from pcs to mdio_device
  net: dsa: seville: name change for clarity from pcs to mdio_device
  net: ethernet: enetc: name change for clarity from pcs to mdio_device
  net: pcs: lynx: use a common naming scheme for all lynx_pcs variables
  net: dsa: ocelot: felix: add support for VSC75XX control over SPI

 drivers/base/property.c                       |  20 +-
 drivers/net/dsa/ocelot/Kconfig                |  16 +
 drivers/net/dsa/ocelot/Makefile               |   7 +
 drivers/net/dsa/ocelot/felix.c                |  29 +-
 drivers/net/dsa/ocelot/felix.h                |  10 +-
 drivers/net/dsa/ocelot/felix_mdio.c           |  54 +
 drivers/net/dsa/ocelot/felix_mdio.h           |  13 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  38 +-
 drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c   | 946 ++++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c      | 136 +--
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  12 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |   3 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  27 +-
 .../net/ethernet/freescale/enetc/enetc_pf.h   |   4 +-
 drivers/net/ethernet/mscc/Makefile            |   3 +-
 drivers/net/ethernet/mscc/ocelot.c            |   8 +
 drivers/net/ethernet/mscc/ocelot_devlink.c    |  31 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 548 +---------
 drivers/net/ethernet/mscc/vsc7514_regs.c      | 522 ++++++++++
 drivers/net/mdio/mdio-mscc-miim.c             | 167 +++-
 drivers/net/pcs/pcs-lynx.c                    |  36 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c     | 127 ++-
 drivers/pinctrl/pinctrl-ocelot.c              | 207 ++--
 include/linux/mdio/mdio-mscc-miim.h           |  19 +
 include/linux/pcs-lynx.h                      |   9 +-
 include/linux/property.h                      |   1 +
 include/soc/mscc/ocelot.h                     |  60 ++
 include/soc/mscc/vsc7514_regs.h               |  27 +
 28 files changed, 2219 insertions(+), 861 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.c
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.h
 create mode 100644 drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c
 create mode 100644 drivers/net/ethernet/mscc/vsc7514_regs.c
 create mode 100644 include/linux/mdio/mdio-mscc-miim.h
 create mode 100644 include/soc/mscc/vsc7514_regs.h

-- 
2.25.1

