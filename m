Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9296B4D25E9
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 02:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiCIBGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiCIBF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:05:59 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2071f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::71f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA8213FAC7;
        Tue,  8 Mar 2022 16:44:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INauKfqk+pwkhclosqCI9UPMdLMu/x55Uy/IJoH463uZh91nJoRR1DgwSPW71tBKyh9/VIpGbpvIMX076lYrk8//7hr1OvNErL9xkCsrD25ne77xGkxJOdm53d1L3pNXBR+UWYXh3jcCaWt4ZcNuVAAixKHSbZZlWdKi0ZlZx8SktfpN0qCwP7crrwUp+oRlpm1tP936GFsI3uaAMPoMpvqghqBE7p6rLnusfedNkZXcXP0Lzi3sKXy/B2FNKCrxIx3Xd6toCf0g/Cummq5n8C9zi4ylLD5GyLm2NCknrcCBCVFdacarS/eACArlqVboJZbjMhuPcqnVMfQF5Vc6Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPQyc+PYeLyTetwYJKqNzHXHVMMhkZMXjKNn4F2pPKc=;
 b=Fh84UbygvHRs1L5xUgsWI+ZOP12ktiM4IXIudnne9JxmMfnomLLqIrTZXrFbW9EKQ0C0wV+UHW51NZ6HJ1smCoGLqWwqRJ/dfB+cbArSiLYA5zSn85c3U7lsxhkUePuyHrz5JgJRdrCWMr1qmZONbcSPCDHDWxZSis1DOeFI8DPmj9r16Qd12RpAMsurf0Y1Dal6uObAxYjcudjTMoiGHA9byswVoq4hamhAiRttK6IjiFmJX0hplU0QMdyksLev7h7QjfO7oXgD3mEuapYr7FDg2dI2CuNJrwlPH3s5InspAF6Xe7jIe8GjDV5rgWsyPtWOYuVx/LJnT7Ys5aviRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPQyc+PYeLyTetwYJKqNzHXHVMMhkZMXjKNn4F2pPKc=;
 b=OUmLf2pshMQotTI76IZqk5v1xwPjn68s09pcbbXh/4vf6c9gj5BXdfuBKgkbzDSeKDSQEn7elaF1HX3QfGOlPdhp2gEFe8n9oshf7FNPMbJysh+8ZtXDBgzc/wCNRhTGRIGvZARuFQLGhIGtxs0MsW/H5AAHJ8aZPgq779beKqI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB4448.namprd10.prod.outlook.com
 (2603:10b6:a03:2ad::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Tue, 8 Mar
 2022 23:34:58 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 23:34:58 +0000
Date:   Tue, 8 Mar 2022 23:34:52 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RFC v7 net-next 00/13] add support for VSC7512 control over SPI
Message-ID: <20220309073452.GA3124@COLIN-DESKTOP1.localdomain>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
 <20220308143956.jik5bvszvqmrukgb@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308143956.jik5bvszvqmrukgb@skbuf>
X-ClientProxiedBy: MWHPR18CA0051.namprd18.prod.outlook.com
 (2603:10b6:300:39::13) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a7c5ef1-d926-4545-d43b-08da015c41ee
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4448:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB444868FE7FA6E1254733B66CA4099@SJ0PR10MB4448.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S9F/m3k4U8JnhbFQwMn7qCiJe8acddYRKMCiHjvQNZChrgfhSdtVluezjkNu1Io7lB/Ygh4qyNOsu6uQflrVbhE+MBKZtlfcO6TIRRdhCj3rQ61Il+KNX7yhJlmbgXUc9J1DjhTHNoijMwfHNC619XyYRTRiWa9e9F50BDHnkX1Lk/V4++5VaE/YdJ9E4ZbhWAIyabTPg1SRt8X3DbHJZGSa/pBJbTuaj5gnuXuJyGX7pojJOBMfHxVjghDS3+NECRkwk8YzWEzto4jRfXofy3KWJksco7MvdRsADYKT6HgPNPsu6G7ht8D9EJEIg1YsjuUH8Gqaltq8PKkWuVb9xILz51wRMLofzulsRTHigoyAmn3RnZXcbjpV8RAuNSXqTI2dCzrrP7Jx0mqhVgyNoL0lgvaqohl+gmXYHgyONlBiweFyVso4+WA75DUFL8mb24b3ceVhdyNi97nEVj6aJp/KESCnnhl5GA126nFSO7NPHMW5zY0lOvDqrIJBFYY2EMVy012LXCuY46pnJsjNa/o0jpuG3uhSqiUWND65d0TPh+D6JsL9G4MvDIP8+bFWiJZEJ4SGRqTfxF9tzuAhqsVnXD+DiAnNtLg4QYkBre+a5qAuVvVanA3mOePHwAtNZUSC5U+ybfXWIl5sdv9JkYxNLGNcYg4WZxxDt3GUFWBt2kyAvOa2+mUHuSP5PJcR11iG1DXl4Avx0HdreRtNMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(136003)(346002)(42606007)(396003)(366004)(39830400003)(1076003)(7416002)(38100700002)(8936002)(44832011)(9686003)(186003)(38350700002)(26005)(86362001)(6512007)(2906002)(107886003)(52116002)(6506007)(508600001)(54906003)(66476007)(66556008)(6666004)(66946007)(6916009)(316002)(33656002)(83380400001)(8676002)(6486002)(4326008)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PRPshDcyXRMcm7ZHl5JybiC7gZdEuftD3ZAw69wjn2drmYDDSmLo2q3hZHFu?=
 =?us-ascii?Q?AbhnAIJeKn81235EqpwtvpDMaS/CmvcmzFwg3XBLBka78vqhziGisBrWo7XY?=
 =?us-ascii?Q?Ia8HkW2iom+Ude30mrMO7uidgvsW7t6KZbnsavMd6JSxMvsO3QAacpaTaXP4?=
 =?us-ascii?Q?DEVupSoDEM1pADz9RqN1xJ1JCVTJvPDbL9DUF//79kS1VTzK2uZCyE+84RWM?=
 =?us-ascii?Q?JAxZ6DNBg5rkXnb6owDuiisVmRFtr3cPZx3d7d4sMjaiF4Cib4xf10uzl7TJ?=
 =?us-ascii?Q?p2a1a5x/rY2m06PD2/3970K46xbMRC6jMagOMwKsDsXIGPdE1SD7018VNGHO?=
 =?us-ascii?Q?JTslm2UjleRVzuTinUOvyqt9X02xyrTCUzl5rzyyGOs5ZBgh9dSG6tRNuSNL?=
 =?us-ascii?Q?boYYe2m6+6H8MDjO60FhBcOCWrQD5gBZ9EljlV9noIfU62vQBREtceT1X128?=
 =?us-ascii?Q?2F5gThvocLcDxFJzMayCcwjsNYFaX4RACVDZj/mouCghsm5JZoBbrnZYGwTQ?=
 =?us-ascii?Q?gr8y/3scWBGXqLPqQB8ArHnBoQ198WWFIm/LHhWIrWusluR+U+bCP+TYbr8H?=
 =?us-ascii?Q?yNKDoU2pWBGmdFc6T8Rp9NZfZcwYm0G4LZYNT0S2itu0uxjcYoXvLl7Thfw1?=
 =?us-ascii?Q?2B6uEB8Qj6zFH1N6N1bY3/wvKiUtGYDwl2J4iitZSAb718Z5poSwf9lEru+v?=
 =?us-ascii?Q?iTkN6pjwUQFb8222zLbWW9qEnB0BccxONLwobIcpzpK1N2hEwLjUffcRzua5?=
 =?us-ascii?Q?XLIz88GWtv4E9TW9VV4dgTP+ssVq3tOY+jrmC5TxQUb+shFFT7Pv9i1N29rY?=
 =?us-ascii?Q?pJfm32kRzoawih48AQAqGex5wqVbRJn/jwCPprCZe4lB0T5E6QRMg9EQMQ+h?=
 =?us-ascii?Q?ittMGHx+f76WjAt2VSKiP2tcnDB0PLO8rgQ7IV6LYO7thgd35XSH4tIWq59L?=
 =?us-ascii?Q?UU6DD7VPWXbD8GM7VjwecjQM1pvCdngKdIoqTnyzYyEj9xJkfmWFQvjJOBct?=
 =?us-ascii?Q?Hc2b/EH4tt2e7+JbM+rT3UFgt2a2/w5p6LO6kM5h9+Mxj5UZ938YpjMYjHRw?=
 =?us-ascii?Q?aZzrHYS+9SAc8jVMREh50jNOMHLYj6N4ykOQGun6/tJegbn4wCOTThJK/QgR?=
 =?us-ascii?Q?8aU1o10+BTRqjiZXVipCl90DehKAxmtU05sQivz2PY7WfF6+pYkgwFEZhmOr?=
 =?us-ascii?Q?C5ubsqNFq2PIGU5iXUIFX/KrOt1fHlz3XLO//MDYyAVaERkaIpBm9RkZJXL7?=
 =?us-ascii?Q?phQdSwnRnWbPIgOfRPx3tPzUom9H7kwSVyOInbIcZNKyAXWQM6D5dYfNlK+n?=
 =?us-ascii?Q?8f1Gqzl0SPWaPOKsAeFKaleIUL48RacwsM1M9ExPVyzCHMGKOvlqOvvw5XdH?=
 =?us-ascii?Q?d1ba4484VRKGYotQtjD66Gg/h227Mjp/Te2u61S99p/5oaX6zQhgFCLacnDf?=
 =?us-ascii?Q?4J80GR0t0kuE9oQ9OPGXO848Xj1fPDlxHRW1GvaNfH3fA47aIaHaxIGzokaZ?=
 =?us-ascii?Q?fcLEvePDAOBKTOq+iSxk201YrLUhIR54NCCEBLyK2tPMarqbfvPsQ4mpkfE2?=
 =?us-ascii?Q?BaWrGE2h41ytHi5McD9VbAqK/lE0DUZy01QY6SjWrpoN0qR4eWRJ/tMV22V/?=
 =?us-ascii?Q?Aagwfv3bPz4/IIecM5LiDQYBI4WyohpKwqn8c9UH4m2fiI/TCOtKYj5CbKVK?=
 =?us-ascii?Q?ZC39Pz8a8lRDoq6ISHoO/YmZjIQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7c5ef1-d926-4545-d43b-08da015c41ee
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 23:34:58.4886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tZdZOv/vGLQEyWqzjnxpNqf1JwwLUS6UYxmQ5XHjQ2yGvTQu3fq7lFdA/uceMPpFTboXmqj8lGF1aSLsgFJEW9hnipXDumWNbW+UhCNiJtA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4448
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 02:39:57PM +0000, Vladimir Oltean wrote:
> On Sun, Mar 06, 2022 at 06:11:55PM -0800, Colin Foster wrote:
> > The patch set in general is to add support for the VSC7512, and
> > eventually the VSC7511, VSC7513 and VSC7514 devices controlled over
> > SPI. The driver is believed to be fully functional for the internal
> > phy ports (0-3)  on the VSC7512. It is not yet functional for SGMII,
> > QSGMII, and SerDes ports.
> > 
> > I have mentioned previously:
> > The hardware setup I'm using for development is a beaglebone black, with
> > jumpers from SPI0 to the microchip VSC7512 dev board. The microchip dev
> > board has been modified to not boot from flash, but wait for SPI. An
> > ethernet cable is connected from the beaglebone ethernet to port 0 of
> > the dev board.
> > 
> > The relevant sections of the device tree I'm using for the VSC7512 is
> > below. Notably the SGPIO LEDs follow link status and speed from network
> > triggers.
> > 
> > In order to make this work, I have modified the cpsw driver, and now the
> > cpsw_new driver, to allow for frames over 1500 bytes. Otherwise the
> > tagging protocol will not work between the beaglebone and the VSC7512. I
> > plan to eventually try to get those changes in mainline, but I don't
> > want to get distracted from my initial goal. I also had to change
> > bonecommon.dtsi to avoid using VLAN 0.
> > 
> > 
> > Of note: The Felix driver had the ability to register the internal MDIO
> > bus. I am no longer using that in the switch driver, it is now an
> > additional sub-device under the MFD.
> > 
> > I also made use of IORESOURCE_REG, which removed the "device_is_mfd"
> > requirement.
> > 
> > 
> > / {
> > 	vscleds {
> > 		compatible = "gpio-leds";
> > 		vscled@0 {
> > 			label = "port0led";
> > 			gpios = <&sgpio_out1 0 0 GPIO_ACTIVE_LOW>;
> > 			default-state = "off";
> > 			linux,default-trigger = "ocelot-miim0.2.auto-mii:00:link";
> > 		};
> > 		vscled@1 {
> > 			label = "port0led1";
> > 			gpios = <&sgpio_out1 0 1 GPIO_ACTIVE_LOW>;
> > 			default-state = "off";
> > 			linux,default-trigger = "ocelot-miim0.2.auto-mii:00:1Gbps";
> > 		};
> > [ ... ]
> > 		vscled@71 {
> > 			label = "port7led1";
> > 			gpios = <&sgpio_out1 7 1 GPIO_ACTIVE_LOW>;
> > 			default-state = "off";
> > 			linux,default-trigger = "ocelot-miim1-mii:07:1Gbps";
> > 		};
> > 	};
> > };
> > 
> > &spi0 {
> > 	#address-cells = <1>;
> > 	#size-cells = <0>;
> > 	status = "okay";
> > 
> > 	ocelot-chip@0 {
> > 		compatible = "mscc,vsc7512_mfd_spi";
> > 		spi-max-frequency = <2500000>;
> > 		reg = <0>;
> > 
> > 		ethernet-switch@0 {
> 
> I'm not exactly clear on what exactly does the bus address (@0)
> represent here and in other (but not all) sub-nodes.
> dtc probably warns that there shouldn't be any unit address, since
> #address-cells and #size-cells are both 0 for ocelot-chip@0.

They most likely shouldn't be there. There are some warnings (make W=1
...) but they're hidden inside all sorts of warnings from am33*.dtsi
warnings. I should have been looking for those.

You're right. A lot of "has a unit name, but no reg or ranges property"
Removing the @s and giving them all unique names resolves these
warnings.

> 
> > 			compatible = "mscc,vsc7512-ext-switch";
> > 			ports {
> > 				#address-cells = <1>;
> > 				#size-cells = <0>;
> > 
> > 				port@0 {
> > 					reg = <0>;
> > 					label = "cpu";
> > 					status = "okay";
> > 					ethernet = <&mac_sw>;
> > 					phy-handle = <&sw_phy0>;
> > 					phy-mode = "internal";
> > 				};
> > 
> > 				port@1 {
> > 					reg = <1>;
> > 					label = "swp1";
> > 					status = "okay";
> > 					phy-handle = <&sw_phy1>;
> > 					phy-mode = "internal";
> > 				};
> > 			};
> > 		};
> > 
> > 		mdio0: mdio0@0 {
> > 			compatible = "mscc,ocelot-miim";
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 
> > 			sw_phy0: ethernet-phy@0 {
> > 				reg = <0x0>;
> > 			};
> > 
> > 			sw_phy1: ethernet-phy@1 {
> > 				reg = <0x1>;
> > 			};
> > 
> > 			sw_phy2: ethernet-phy@2 {
> > 				reg = <0x2>;
> > 			};
> > 
> > 			sw_phy3: ethernet-phy@3 {
> > 				reg = <0x3>;
> > 			};
> > 		};
> > 
> > 		mdio1: mdio1@1 {
> > 			compatible = "mscc,ocelot-miim";
> > 			pinctrl-names = "default";
> > 			pinctrl-0 = <&miim1>;
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 
> > 			sw_phy4: ethernet-phy@4 {
> > 				reg = <0x4>;
> > 			};
> > 
> > 			sw_phy5: ethernet-phy@5 {
> > 				reg = <0x5>;
> > 			};
> > 
> > 			sw_phy6: ethernet-phy@6 {
> > 				reg = <0x6>;
> > 			};
> > 
> > 			sw_phy7: ethernet-phy@7 {
> > 				reg = <0x7>;
> > 			};
> > 
> > 		};
> > 
> > 		gpio: pinctrl@0 {
> > 			compatible = "mscc,ocelot-pinctrl";
> > 			gpio-controller;
> > 			#gpio_cells = <2>;
> > 			gpio-ranges = <&gpio 0 0 22>;
> > 
> > 			led_shift_reg_pins: led-shift-reg-pins {
> > 				pins = "GPIO_0", "GPIO_1", "GPIO_2", "GPIO_3";
> > 				function = "sg0";
> > 			};
> > 
> > 			miim1: miim1 {
> > 				pins = "GPIO_14", "GPIO_15";
> > 				function = "miim";
> > 			};
> > 		};
> > 
> > 		sgpio: sgpio {
> > 			compatible = "mscc,ocelot-sgpio";
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 			bus-frequency=<12500000>;
> > 			clocks = <&ocelot_clock>;
> > 			microchip,sgpio-port-ranges = <0 15>;
> > 			pinctrl-names = "default";
> > 			pinctrl-0 = <&led_shift_reg_pins>;
> > 
> > 			sgpio_in0: sgpio@0 {
> > 				compatible = "microchip,sparx5-sgpio-bank";
> > 				reg = <0>;
> > 				gpio-controller;
> > 				#gpio-cells = <3>;
> > 				ngpios = <64>;
> > 			};
> > 
> > 			sgpio_out1: sgpio@1 {
> > 				compatible = "microchip,sparx5-sgpio-bank";
> > 				reg = <1>;
> > 				gpio-controller;
> > 				#gpio-cells = <3>;
> > 				ngpios = <64>;
> > 			};
> > 		};
> > 
> > 		hsio: syscon {
> > 			compatible = "mscc,ocelot-hsio", "syscon", "simple-mfd";
> > 
> > 			serdes: serdes {
> > 				compatible = "mscc,vsc7514-serdes";
> > 				#phy-cells = <2>;
> > 			};
> > 		};
> > 	};
> > };
> 
> The switch-related portion of this patch set looks good enough to me.
> I'll let somebody else with more knowledge provide feedback on the
> mfd/pinctrl/gpio/phylink/led integration aspects.

Thanks for looking. As I mentioned - I don't have any intention to make
a .dts/.dtsi for this rather obscure dev environment. It seems like it
wouldn't be useful. But the feedback has really helped keep me on track,
and hopefully avoiding scenarios where two wrongs make a right.
