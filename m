Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7BC654220
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 14:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbiLVNtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 08:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLVNtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 08:49:11 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2049.outbound.protection.outlook.com [40.107.20.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2F11F9E7;
        Thu, 22 Dec 2022 05:49:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTP5Qh+QZih+jNU+0/Kjf9lgefnZOc/6jm0hxsb26AY1w33zAb8YEQJmPKY+JumsZLFDWZHetmfyDtrTCIFAo4lI5Iu/w4HBh6jnq0SuN5zffb25rwVLOLKshm2S7CfLtZG4Zr/vrgPeE/p0R8r2K5hiG83L5hs4iR0y5bmZ79rA84blvoBx/nqft0jS897d2lqsFaFQnGiHMdXJWSXguYHmQnCNwZjB0ndGeStw9XmnANHloAX8No2/ddss8d3Xqk4O+5pcQ5RXdbFHJi0arVeDK2TGjFzX/LDwpHXPC5tXK0krZa+6w9IsyVX54a2qu448AOYvzN82WxxFTJAnMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p5bbqkVjZ49i6O24a68r6Wgjd1bYrViXQXdtgvlU7v4=;
 b=d3QXgFSxZiPQEwidWeOygNW1XYuMmZraucVl0uONQpfvQBwcKA0s5HkRGuAftR79/wCq5cDUGRjDrSiekQUAwmw5RBEAYAJA9aNBVTlq6Dd7IlC0B/DNNw5YCqh+/+F9J8fSrkmyBwXiqfZ2SvznRnue5bVnJwFxJXiWPipBOvjYaZOuKdNgKkPixGLwQBH5s1KfItEHMjHkGc91SSgm4EoMGxeh/99TnQTv3YAdFglb47gucEtXRsRWQI/uFeylL4nlPhen8LCHHiOrnzbF5axvNHgetuBJT5cFl5w/Qj/2K9dxtPrjvvnN6iAEEsIbXoxj/nQRJUQufwlT3WYE9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5bbqkVjZ49i6O24a68r6Wgjd1bYrViXQXdtgvlU7v4=;
 b=qH81m6dDMOjP9Hs2BvjUjBe1fv1d+T0ck0TPd1C06qak5SwYRamj8k5XUw5U8TKedCAo+UmGDiVhNm5mJIcu1Zoy3F2X6qd7356zWqtIFOnagXEYPaPdGf3qn1OZOf8gveQemNKq1j03iCEUZjPIu3t1Lq3Tjc7wKP1F9yqmumo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9217.eurprd04.prod.outlook.com (2603:10a6:102:232::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 13:49:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::7c13:ef9:b52f:47d8]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::7c13:ef9:b52f:47d8%6]) with mapi id 15.20.5924.016; Thu, 22 Dec 2022
 13:49:07 +0000
Date:   Thu, 22 Dec 2022 15:48:44 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lee Jones <lee@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Advice on MFD-style probing of DSA switch SoCs
Message-ID: <20221222134844.lbzyx5hz7z5n763n@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: VI1PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9217:EE_
X-MS-Office365-Filtering-Correlation-Id: d20eba9d-72f2-4ac8-a386-08dae4234b81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8gFxgOKkRdwg5tX0KdOGK4ACkZ1iJFlyci1vZrfSR4BzlL3gconMP6kXQw68FGfopQolj0Jpwj/gUGxFR2csKqj/Yh2Q/OcNEogZJ+xPll0sG4n/yJtucXF7iJeiv00Utm+PDLIUU3sgzC/nrIyuv4bV2nHM9PKtl2HHo64cq+TVl8iOTcbdrs9YXoljuLVbTQILrPqyYR5Y59YWnqUL6Vb/PeRTDtp0VICI8ZZAKHzZp2iU9pWMjPpYd3z3aE0Gx8czN0NXy00+MHGaYEHF8oTMIfmzUPtVO3M/XRcbNf+8J+JI7ue1S/afty3FfMyhh4h7SY8yHFuTrnWdlKequm/uF2X7n8cC5Wv5xyAIjZZdO0ybFyBWYJ3Ro09Og5d0UBrRzXOXwK2j20gEshsnHZggpYeGMfsyRO+vfaEq/bzYEr30AfJGl1zw9RHQpPMOoBhwz7/k5jszm+jHFGojv1CosldF+AB16/czPacyl+WpTRWnMKcEoj3MnAGaZeUMf+jj1EFvUQG/oG5IFmuj0n2umKvUSuoNYi7QLSXEfuf+GiDjXXkQJ4Z60L1e9MO/bawfxAOKprqxWkv/+vCCkB8o1/pBhPQZFcU2vqBCiGv4SugrTsFduD2UQOmkJ+IZFPyJcsTm+hHjXtJLYGZ92CzU7ZElbby4ZMTIRsm2v414WsxVLfpFElHlLikMD3YI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(6029001)(4636009)(7916004)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(316002)(110136005)(6512007)(186003)(9686003)(8936002)(921005)(66476007)(26005)(83380400001)(33716001)(44832011)(5660300002)(7416002)(38100700002)(66946007)(66556008)(8676002)(1076003)(30864003)(2906002)(86362001)(66899015)(41300700001)(478600001)(6666004)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3eXXj57d/jPF7Rt3OtcoHy1sQwbParGZcmau4WnsO7WqZF8YNhhD7S1bAzPb?=
 =?us-ascii?Q?os1D3YpxBhDu1V49fhdw36t9UE2EmTqANvIBAPG+0p/fgSg7Nd4TL2lT7fXD?=
 =?us-ascii?Q?TJzw1+2cDW6o7xwzBQpj62jdS5Gv9Wj/uUrozgS/qslTJls46RaM9suGRgzD?=
 =?us-ascii?Q?+F0D904kEvZvb1oQG54lPf8Kj9a6OS5diZ8eryFkMqBQMPULYQVSd+rxe6i3?=
 =?us-ascii?Q?COTYkJJrbEzkz25M0bA6cuR69MbIgBrF00PF1w47pHiG4gcOQ5B/qPmUQyuF?=
 =?us-ascii?Q?iztw+GDUnvc9VnYeWNtLkvl/afbpvWMUJEyFKj1GCiaeXU4sSPz33ckKdU7G?=
 =?us-ascii?Q?eSHv6PFxeC1ZeuZs4hmgDUk+rp2Nk5qKLiKhOMTqeGJbnzQM6w17jmtSdfXC?=
 =?us-ascii?Q?iD3DUeemYzWQIZofNTWsRW9D8qnWViOARpxXtOEqXZ46o43WJ5MKSCXuJGSL?=
 =?us-ascii?Q?UIw7L3kHnTQgFavzCZbQaPYdkZdIlV3cFNyLPeGqUofFhuC+NDGzY7jLVFhf?=
 =?us-ascii?Q?3xNyprm/7XnxvXgA3LQ8r152gZloF+DsDwzVnOg4PxfvpbQk72XM1cy2b4Hb?=
 =?us-ascii?Q?xNEBiHELHzC/zdP4s04BrsEgWWCC3YexEbGyO3mKsST/T1JaXE6LX/Rp6097?=
 =?us-ascii?Q?dZjRRNpTcLoeMizaQovORzylxuN9DgFlEk17xgAsRtuED3gS2wlg6pGYFCnV?=
 =?us-ascii?Q?uUbrzh1QnWlL7LmAwEppyWXvdEOlIfk/D3W/0mWt7tMOk6qUhaJOgF/vMyg+?=
 =?us-ascii?Q?+X8IK4j3lOphjv9JqgfXesJOd0hkyoI2SGRmZ6NmX1N7fQaWmqrq+3UidNM9?=
 =?us-ascii?Q?9XR1+f+ir3l84yhZ0QOmM/e9rF4wCrpxVBp9x7Q8BKDBDlyBN5UL2BnmgFia?=
 =?us-ascii?Q?3gnowJGK7kuY376EGqDPGDe6qSaogQ571Mld4m+XYWEUQh/STspUTHl5t5Lt?=
 =?us-ascii?Q?ppeP0OJTBSFIS9zMx0FPsar20gNkk9mldaV+WTvk2eEX4XuUS6m2g0PefBiB?=
 =?us-ascii?Q?k1LWsj2tgqoAgtHhMNWrovmOeLu7peLS0+5SB3XI7xaXRht9WkuYTEBiWorA?=
 =?us-ascii?Q?aXCpGOVtvBmDUrq35i6uZmCf+WYtFXf32cPQbfNL/MNhuvwSHJ7eVqnPUm03?=
 =?us-ascii?Q?7zM7rsSAhBL6xdqbYpLeXXsImGe4RuJKvKNIRyJG8ipFH27+cBr7YzNBTCeG?=
 =?us-ascii?Q?I5MHtkdmggP/dTRR2uh/asaVGOeK9jGg4ql+FOHYe6lIvX0a4oAhgvA97XMD?=
 =?us-ascii?Q?RQzUhNSgRe7f4cgalYvvfZ+c4XojJlGpUKRwS/KZDbZnEHGhl0JiKhDphVop?=
 =?us-ascii?Q?xy8lAxMROCU/+2YHEHmIlyKM7mOa8KmJNQBz6qcDrK73o78fx+kCPbuZvENE?=
 =?us-ascii?Q?SCni7u7eQsryGdu0DIEGBhsdgmvZVluLLyz8ElLgD1z/UHK7Nd7pa+dHrVTW?=
 =?us-ascii?Q?OioMtjE+gbNstSPyIpxvIZpdfzjreCkhC5fSHoPsYeME4i9DZWH42iot/oRk?=
 =?us-ascii?Q?/WjrLwDgHhwl0CkAZ72TtiqHmdvKDT36VHxIeOsVyevPXOo2Q0GgWdAol8Nq?=
 =?us-ascii?Q?r04QRbb9TxDfDl5G4Lq5gFdoWoO8+/4m9xEVQjg6zemmJFkgoi012FZ1ViBh?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d20eba9d-72f2-4ac8-a386-08dae4234b81
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2022 13:49:07.0309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7CvPl5K9SzPOmzGx86Yiu0jJiFOudsq/c7lHVS/PrCnEHXbwZv90JM8FzyjY2kDTVZeDUnTh3YmrXezmpaUPnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9217
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Many DSA switches (drivers/net/dsa/) are in fact complex SoCs with more
embedded peripherals than just the Ethernet switching IP. For example,
I was trying to add interrupt support for the internal PHYs of the NXP
SJA1110 switch. For context, one SJA1110 switch as seen in fsl-lx2160a-bluebox3.dts
currently has bindings which look like this:

	sw2: ethernet-switch@2 {
		compatible = "nxp,sja1110a";
		reg = <2>;
		spi-max-frequency = <4000000>;
		spi-cpol;
		dsa,member = <0 1>;

		ethernet-ports {
			#address-cells = <1>;
			#size-cells = <0>;

			/* Microcontroller port */
			port@0 {
				reg = <0>;
				status = "disabled";
			};

			sw2p1: port@1 {
				reg = <1>;
				link = <&sw1p4>;
				phy-mode = "sgmii";

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@2 {
				reg = <2>;
				ethernet = <&dpmac18>;
				phy-mode = "rgmii-id";
				rx-internal-delay-ps = <2000>;
				tx-internal-delay-ps = <2000>;

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@3 {
				reg = <3>;
				label = "1ge_p2";
				phy-mode = "rgmii-id";
				phy-handle = <&sw2_mii3_phy>;
			};

			port@4 {
				reg = <4>;
				label = "to_sw3";
				phy-mode = "2500base-x";

				fixed-link {
					speed = <2500>;
					full-duplex;
				};
			};

			port@5 {
				reg = <5>;
				label = "trx7";
				phy-mode = "internal";
				phy-handle = <&sw2_port5_base_t1_phy>;
			};

			port@6 {
				reg = <6>;
				label = "trx8";
				phy-mode = "internal";
				phy-handle = <&sw2_port6_base_t1_phy>;
			};

			port@7 {
				reg = <7>;
				label = "trx9";
				phy-mode = "internal";
				phy-handle = <&sw2_port7_base_t1_phy>;
			};

			port@8 {
				reg = <8>;
				label = "trx10";
				phy-mode = "internal";
				phy-handle = <&sw2_port8_base_t1_phy>;
			};

			port@9 {
				reg = <9>;
				label = "trx11";
				phy-mode = "internal";
				phy-handle = <&sw2_port9_base_t1_phy>;
			};

			port@a {
				reg = <10>;
				label = "trx12";
				phy-mode = "internal";
				phy-handle = <&sw2_port10_base_t1_phy>;
			};
		};

		mdios {
			#address-cells = <1>;
			#size-cells = <0>;

			mdio@0 {
				compatible = "nxp,sja1110-base-t1-mdio";
				#address-cells = <1>;
				#size-cells = <0>;
				reg = <0>;

				sw2_port5_base_t1_phy: ethernet-phy@1 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x1>;
				};

				sw2_port6_base_t1_phy: ethernet-phy@2 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x2>;
				};

				sw2_port7_base_t1_phy: ethernet-phy@3 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x3>;
				};

				sw2_port8_base_t1_phy: ethernet-phy@4 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x4>;
				};

				sw2_port9_base_t1_phy: ethernet-phy@5 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x5>;
				};

				sw2_port10_base_t1_phy: ethernet-phy@6 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x6>;
				};
			};
		};
	};

To add interrupts in a naive way, similar to how other DSA drivers have
done it, it would have to be done like this:

#include <dt-bindings/interrupt-controller/nxp-sja1110-acu-slir.h>

	sw2: ethernet-switch@2 {
		compatible = "nxp,sja1110a";
		reg = <2>;
		spi-max-frequency = <4000000>;
		spi-cpol;
		dsa,member = <0 1>;

		slir2: interrupt-controller {
			compatible = "nxp,sja1110-acu-slir";
			interrupt-controller;
			#interrupt-cells = <1>;
			interrupt-parent = <&gpio 10>;
		};

		ethernet-ports {
			#address-cells = <1>;
			#size-cells = <0>;

			/* Microcontroller port */
			port@0 {
				reg = <0>;
				status = "disabled";
			};

			sw2p1: port@1 {
				reg = <1>;
				link = <&sw1p4>;
				phy-mode = "sgmii";

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@2 {
				reg = <2>;
				ethernet = <&dpmac18>;
				phy-mode = "rgmii-id";
				rx-internal-delay-ps = <2000>;
				tx-internal-delay-ps = <2000>;

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@3 {
				reg = <3>;
				label = "1ge_p2";
				phy-mode = "rgmii-id";
				phy-handle = <&sw2_mii3_phy>;
			};

			port@4 {
				reg = <4>;
				label = "to_sw3";
				phy-mode = "2500base-x";

				fixed-link {
					speed = <2500>;
					full-duplex;
				};
			};

			port@5 {
				reg = <5>;
				label = "trx7";
				phy-mode = "internal";
				phy-handle = <&sw2_port5_base_t1_phy>;
			};

			port@6 {
				reg = <6>;
				label = "trx8";
				phy-mode = "internal";
				phy-handle = <&sw2_port6_base_t1_phy>;
			};

			port@7 {
				reg = <7>;
				label = "trx9";
				phy-mode = "internal";
				phy-handle = <&sw2_port7_base_t1_phy>;
			};

			port@8 {
				reg = <8>;
				label = "trx10";
				phy-mode = "internal";
				phy-handle = <&sw2_port8_base_t1_phy>;
			};

			port@9 {
				reg = <9>;
				label = "trx11";
				phy-mode = "internal";
				phy-handle = <&sw2_port9_base_t1_phy>;
			};

			port@a {
				reg = <10>;
				label = "trx12";
				phy-mode = "internal";
				phy-handle = <&sw2_port10_base_t1_phy>;
			};
		};

		mdios {
			#address-cells = <1>;
			#size-cells = <0>;

			mdio@0 {
				compatible = "nxp,sja1110-base-t1-mdio";
				#address-cells = <1>;
				#size-cells = <0>;
				reg = <0>;

				sw2_port5_base_t1_phy: ethernet-phy@1 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x1>;
					interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY1>;
				};

				sw2_port6_base_t1_phy: ethernet-phy@2 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x2>;
					interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY2>;
				};

				sw2_port7_base_t1_phy: ethernet-phy@3 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x3>;
					interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY3>;
				};

				sw2_port8_base_t1_phy: ethernet-phy@4 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x4>;
					interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY4>;
				};

				sw2_port9_base_t1_phy: ethernet-phy@5 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x5>;
					interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY5>;
				};

				sw2_port10_base_t1_phy: ethernet-phy@6 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x6>;
					interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY6>;
				};
			};
		};
	};

However, the irq_domain/irqchip handling code in this case will go to
drivers/net/dsa/, and it won't really be a "driver" (there is no struct
device of its own). I don't really like that, the drivers/net/dsa/
folder should ideally contain only drivers for the switching IP.
It doesn't scale to find here code for GPIO, interrupts, MDIO, hwmon and
what have you; not only because the folder gets bloated with irrelevant
stuff, but also because DSA maintainers are not the best reviewers of
drivers which really belong to (and make use of infrastructure from)
other subsystems.

Not only that, but "interrupt-controller" cannot even have a unit
address with these bindings, because it's on the same level as
"ethernet-ports" which requires not having it. But there are multiple
interrupt controllers in the SJA1110 block (I could count 3). Not clear
how the other 3 would be defined in the device tree in this format.
The logical continuation of the existing bindings would be to do what
was done for the multiple MDIO controllers: an "interrupt-controllers"
container node, with children with #address-cells = <1>.

I think that doesn't scale very well either, so I was looking into
transitioning the sja1105 bindings to something similar to what Colin
Foster has done with vsc7512 (ocelot). For this switch, new-style
bindings would look like this:

	soc@2 {
		compatible = "nxp,sja1110-soc";
		reg = <2>;
		spi-max-frequency = <4000000>;
		spi-cpol;
		#address-cells = <1>;
		#size-cells = <1>;

		sw2: ethernet-switch@0 {
			compatible = "nxp,sja1110a";
			reg = <0x000000 0x400000>;
			resets = <&sw2_rgu SJA1110_RGU_ETHSW_RST>;
			dsa,member = <0 1>;

			ethernet-ports {
				#address-cells = <1>;
				#size-cells = <0>;

				/* Microcontroller port */
				port@0 {
					reg = <0>;
					status = "disabled";
				};

				sw2p1: port@1 {
					reg = <1>;
					link = <&sw1p4>;
					phy-mode = "sgmii";

					fixed-link {
						speed = <1000>;
						full-duplex;
					};
				};

				port@2 {
					reg = <2>;
					ethernet = <&dpmac18>;
					phy-mode = "rgmii-id";
					rx-internal-delay-ps = <2000>;
					tx-internal-delay-ps = <2000>;

					fixed-link {
						speed = <1000>;
						full-duplex;
					};
				};

				port@3 {
					reg = <3>;
					label = "1ge_p2";
					phy-mode = "rgmii-id";
					phy-handle = <&sw2_mii3_phy>;
				};

				port@4 {
					reg = <4>;
					label = "to_sw3";
					phy-mode = "2500base-x";

					fixed-link {
						speed = <2500>;
						full-duplex;
					};
				};

				port@5 {
					reg = <5>;
					label = "trx7";
					phy-mode = "internal";
					phy-handle = <&sw2_port5_base_t1_phy>;
				};

				port@6 {
					reg = <6>;
					label = "trx8";
					phy-mode = "internal";
					phy-handle = <&sw2_port6_base_t1_phy>;
				};

				port@7 {
					reg = <7>;
					label = "trx9";
					phy-mode = "internal";
					phy-handle = <&sw2_port7_base_t1_phy>;
				};

				port@8 {
					reg = <8>;
					label = "trx10";
					phy-mode = "internal";
					phy-handle = <&sw2_port8_base_t1_phy>;
				};

				port@9 {
					reg = <9>;
					label = "trx11";
					phy-mode = "internal";
					phy-handle = <&sw2_port9_base_t1_phy>;
				};

				port@a {
					reg = <10>;
					label = "trx12";
					phy-mode = "internal";
					phy-handle = <&sw2_port10_base_t1_phy>;
				};
			};
		};

		mdio@704000 {
			compatible = "nxp,sja1110-base-t1-mdio";
			#address-cells = <1>;
			#size-cells = <0>;
			reg = <0x704000 0x1000>;

			sw2_port5_base_t1_phy: ethernet-phy@1 {
				compatible = "ethernet-phy-ieee802.3-c45";
				reg = <0x1>;
				interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY1>;
			};

			sw2_port6_base_t1_phy: ethernet-phy@2 {
				compatible = "ethernet-phy-ieee802.3-c45";
				reg = <0x2>;
				interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY2>;
			};

			sw2_port7_base_t1_phy: ethernet-phy@3 {
				compatible = "ethernet-phy-ieee802.3-c45";
				reg = <0x3>;
				interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY3>;
			};

			sw2_port8_base_t1_phy: ethernet-phy@4 {
				compatible = "ethernet-phy-ieee802.3-c45";
				reg = <0x4>;
				interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY4>;
			};

			sw2_port9_base_t1_phy: ethernet-phy@5 {
				compatible = "ethernet-phy-ieee802.3-c45";
				reg = <0x5>;
				interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY5>;
			};

			sw2_port10_base_t1_phy: ethernet-phy@6 {
				compatible = "ethernet-phy-ieee802.3-c45";
				reg = <0x6>;
				interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY6>;
			};
		};

		mdio@709000 {
			compatible = "nxp,sja1110-base-tx-mdio";
			#address-cells = <1>;
			#size-cells = <0>;
			reg = <0x709000 0x1000>;
		};

		slir2: interrupt-controller@711fe0 {
			compatible = "nxp,sja1110-acu-slir";
			reg = <0x711fe0 0x10>;
			interrupt-controller;
			#interrupt-cells = <1>;
			interrupt-parent = <&gpio 10>;
		};

		gpio@712000 {
			compatible = "nxp,sja1110-gpio";
			reg = <0x712000 0x1000>;
			gpio-controller;
		};

		slir2_gpio: interrupt-controller@712fe0 {
			compatible = "nxp,sja1110-gpio-slir";
			reg = <0x712fe0 0x10>;
			interrupt-controller;
			#interrupt-cells = <1>;
		};

		sw2_rgu: reset@718000 {
			compatible = "nxp,sja1110-rgu";
			reg = <0x718000 0x1000>;
			#reset-cells = <1>;
		};

		sw2_cgu: clock-controller@719000 {
			compatible = "nxp,sja1110-cgu";
			reg = <0x719000 0x1000>;
			#clock-cells = <1>;
		};

		slir2_pmu: interrupt-controller@71afe0 {
			compatible = "nxp,sja1110-pmu-slir";
			reg = <0x71afe0 0x10>;
			interrupt-controller;
			#interrupt-cells = <1>;
		};
	};

In this model, the Ethernet switch is just one of the children of the
SoC driver (the one owning the spi_device, and creating regmaps for its
children). The DSA driver doesn't have to concern itself with the other
drivers, which can live in their own folders.

It seems like mfd is a tool which could help with the driver for
"nxp,sja1110-soc", but mfd_add_devices() requires an array of struct
mfd_cell, and I don't really like that. I want a driver which just
creates IORESOURCE_REG arrays of resources for each child OF node
according to their "reg" properties, creates regmaps for each resource
using a regmap_config that I give it, associates the regmaps with the
parent using devres, and allocates/probes a platform device driver for
each of these child OF nodes. I don't want to spell out a different
mfd_cell for each driver that I'd like the SoC to probe.

It looks like of_platform_populate() would be an alternative option for
this task, but that doesn't live up to the task either. It will assume
that the addresses of the SoC children are in the CPU's address space
(IORESOURCE_MEM), and attempt to translate them. It simply doesn't have
the concept of IORESOURCE_REG. The MFD drivers which call
of_platform_populate() (simple-mfd-i2c.c) simply don't have unit
addresses for their children, and this is why address translation isn't
a problem for them.

In fact, this seems to be a rather large limitation of include/linux/of_address.h.
Even something as simple as of_address_count() will end up trying to
translate the address into the CPU memory space, so not even open-coding
the resource creation in the SoC driver is as simple as it appears.

Is there a better way than completely open-coding the parsing of the OF
addresses when turning them into IORESOURCE_REG resources (or open-coding
mfd_cells for each child)? Would there be a desire in creating a generic
set of helpers which create platform devices with IORESOURCE_REG resources,
based solely on OF addresses of children? What would be the correct
scope for these helpers?
