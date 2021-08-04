Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449443E027D
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbhHDNzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:55:23 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:28896
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238458AbhHDNzV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:55:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuAaDl0ykOAXOtr9/15LVzo3jiLSy/ezSMLKEYDH0OZcUrvsgGFjjVVlV0aJXOBj2VJM7xj+4ae4YfAMCu7qA62qfvgsh4j/ufruQHBM+Cxk7QSQ4CGOfneS8oP8AEzdq0lpPL20ekLInPTHsAdvv+YLzmo25F43XTqox1W8DhjViHyOqsNo59rz1Gffnixz1bcML/RwCP9TU/O7PMYbpz/tC1jRbRaU+bmMTmCubaJsqU19/kuuRo5m1MdORm6OBko25yLs+LkZnYeZ5zINxl4KjrEzNaOI170ROSxdZiydqowLbF0ipM5Qvrn9KJRgX3Se4BbtpP45TGQs9QqW9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6u00wETCrqHu+lZiUyYtIXrp1C9PN53FIdSGrBNH8yA=;
 b=nobxuwsHrSvHuUVn4XIYkPcKSDrCUF237WSI1sqDUY0+g3vHgW0/7GDFIiLLYXRhWx2SbHr5kvSuYeO8HlMGWgrMJjJMXCvXlivj3sYV5QEEwJSJFWwuIl94o0I6rtTnazQYujjJXFW+OOAKOt+YXkHt80TLUGCnMIOS2qG1Ka3gWWLcZw6YNZ8rXEzbnu7bAs+dXuEP8ERw+q+bm7zOsyodM7KWeY08OKTJhFB34s/Lx9r9bwhFFR+Cku7+/OTKBSeqgYrRnuIJe1xaT6vuVpw2obQEA7zKfOUXV2LpbvtpwgR2OqX1cClaib8V7WIijK1JIeq7x9GxfJHdo4nPzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6u00wETCrqHu+lZiUyYtIXrp1C9PN53FIdSGrBNH8yA=;
 b=dP/4lVR67Jl+xHTE1/pnmZSndVp2tLG7PDb+0mcroQhOk0bfszxFTP4NV8IpYd7HnFqSib0sxhqGo9EWxCX5p08TTRahh1oie6ePha9VV7p2piebbdrLEEEZKwZdtYRoAC6Upb89dd3qFoj01UUrIuXvG03E56z0UzVCCXMk0Zs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 13:55:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:55:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 0/8] NXP SJA1105 driver support for "H" switch topologies
Date:   Wed,  4 Aug 2021 16:54:28 +0300
Message-Id: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0155.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR01CA0155.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 13:55:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba03e4a9-1d76-4d68-90cb-08d9574f77be
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2687A3DBB67507643ED87DCFE0F19@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8gtBfBejjMxUKyVgkdqe4Gfi8gXwG4Q/bt5rByzO7g1uUNZwgCSaEBsB8gYnfBf29i7YgJxQV2QsxvC+PNFx4HklnCfbf/WaC0sBasv5V5IIonAF3O9OgW+RYFzNPBSEtPIEpsewpoe4QPfNCIzjsVDNYBkiRgYRQBEqnDngkHcEOsRyLaJG2/ZXmKBtti777MiTaTyTYn+P61nHB7RA51ZLKIusWzwPCoZPwhitE4BeIpbRnBy5uTNmfceZgof1J4xdzaVpZhU/9DTQpHfSlioVp4M2LnHsbdVu4XCfQw0e0xzEnQ5iP+4tqBAXfY/0LhacbUNY8WpFzeIZpFJimYFO5YS4y3InjhRWngzVPzKY3qPtb48AvOsq8xWzL3FczcsTIWxi3Tr35TKP9S8+j+sntmWpbipd7z9z6ccRVdKguhvEzIu1lKk/9+NMM60TNW5faVJ/3bKYdedCee0dneh6AEwknIgLq363RYEmiiYWiZiWbpoR5hS13r8l7mCMeJvi+UldPB2K//9xmx5fi2nEeAWigVqabkA7PKFXMuJdVA8lzrB8lJs2Ru0DO/E4CwYKp6MbQ+1aNfalvoQd4IYKZ8kr15gmv2RfU8ViyJhz7aM4jLUEHk28Jqna6hbONtQRRysmmVtg8H/lUhTiCLWx/ACSE740NJMVhStKorMFOQmPFpvL9G5FNA4MJWZAMR/XMNqvHb7f/WP+SuUew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(6666004)(6486002)(5660300002)(478600001)(66946007)(1076003)(66476007)(4326008)(66556008)(54906003)(26005)(44832011)(38350700002)(86362001)(2616005)(52116002)(8676002)(6506007)(2906002)(36756003)(110136005)(83380400001)(38100700002)(956004)(6512007)(316002)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bz7GyltKYLdUYGtZnR7vOHbs448GqZClSpVmiZG09aWh4gGz7vXq0J+W6U9h?=
 =?us-ascii?Q?vaw3smd7QQJhHDmw7Gl3aTW2A3xaO0XGTyykQzUjitrvwMDCQ4bbjMo7syB7?=
 =?us-ascii?Q?3D0sqasI4NJg/94ayaG74h+jzBjge4FfHzd673XR+m2Z7RtJeFgsVdqD8kgK?=
 =?us-ascii?Q?n5wSe9RduuFX9bX5WapXUYW7Zzc5oQIUozUOcPGqvnRNXPJd2AGdlCjy7eWk?=
 =?us-ascii?Q?hn66cQxwZLHXbXcHuoqwiL3LKItJPgDs89PMPJ1Bq7c7eZqXEXooXlzTDQ/2?=
 =?us-ascii?Q?tdJ3Cehqj0Pv4FweGSvbsfuXstJVGXh+Z82VdEWJ0O+PopKLuz1wwV+iE5OX?=
 =?us-ascii?Q?0vha3exbXqUMeXnUm4NKVyRsH4+JfnFvduklZy+hWTELcoIf0BTWkkUpYcDy?=
 =?us-ascii?Q?8XCDiD24gWcoeZmor1ZAhmdfz0T2/mstPuk/2cRkvLf4uLpiXvSTf2dkKz2p?=
 =?us-ascii?Q?YO5ItPvcTKvuQXPs/n+pnRTgdqe07+kPgoVrsZBpJr9hrxiX1jh85Rm8fxPM?=
 =?us-ascii?Q?8q0/7l2dT+ev9m2J1xO3cW86pdOvdgDXkBb4dsPFQ0003TZhJuhRXkZTtl/r?=
 =?us-ascii?Q?Z2bxlBgTok6OUjcBjwetmSO/OCIS/I5R11XzR6iL9YdE5sn+/H0/bCY/aCUb?=
 =?us-ascii?Q?dtLqRnHwgQjgItfiraY8okyL4n1rzmbTYAqLoE3d0qXEVrc+WBvKB7DwI2fb?=
 =?us-ascii?Q?COCtLEwvkZKitp1pm7UI3lZJ5SMzZ4WygbqcCMGxSsQbenP/GqItinAXbxhx?=
 =?us-ascii?Q?EHygGEJe0p4DmvyD3Kxq/qVDoZ/fsyG21VI94mem9Kt5hrJHtp7vKSoVGrac?=
 =?us-ascii?Q?2DXTU3N8yMa32YKgta5J21nFgsvh26kf9DmBUlvIF551yYzu4etW4bdrqy3Z?=
 =?us-ascii?Q?gKukmdGAavJ0lkMZ5I7U/q5zcMnKaXYe1C0hl2TKVRuY3upQ4d0qALIZ7Wde?=
 =?us-ascii?Q?kMuxlqVKvxw+KQHnKFRVTbeynzPB8rkP+ilbT10nm6eeRmiYYVByfbk7MxBQ?=
 =?us-ascii?Q?/YowXoOrwfSwASFAf8E8NJP1jKNUV4l4+4gEUns6eKeSuIDdrODZat55XYW1?=
 =?us-ascii?Q?lqkrQGoW1cuopA7OxYi30M99SeL00iM1XhC54LYnssXAy8I3qrRv9SqD/j1N?=
 =?us-ascii?Q?HAgcLbu/KxOh5QGCOAATOMivehXbYNxxDDpzT7teOBglerz+1eXJbrtIJOEo?=
 =?us-ascii?Q?7AvZVd4SELIZcPqu5IeaqHlF1/YIjgvo8IjL41irco7HNN7TMKIh40oHHC/j?=
 =?us-ascii?Q?T7jg7cCbvr8if5vYuUIcbKKhGOTsI7Jmtf9vnQpMVsX/OAnxQ/IhziLgr2No?=
 =?us-ascii?Q?cH7o5qsturM8huy0z5mA2Irg?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba03e4a9-1d76-4d68-90cb-08d9574f77be
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:55:07.4175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cYkBuq8ewh6HVzHeDOPlCFHZ48qTzFJ6VFjUdinpjnSqHk6IQ0mmSevcvQEsW+aOaUkqdOE6RTCmAqW+zCeZSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v3:
Preserve the behavior of dsa_tree_setup_default_cpu() which is to pick
the first CPU port and not the last.

Changes in v2:
Send as non-RFC, drop the patches for discarding DSA-tagged packets on
user ports and DSA-untagged packets on DSA and CPU ports for now.

NXP builds boards like the Bluebox 3 where there are multiple SJA1110
switches connected to an LX2160A, but they are also connected to each
other. I call this topology an "H" tree because of the lateral
connection between switches. A piece extracted from a non-upstream
device tree looks like this:

&spi_bridge {
	/* SW1 */
	ethernet-switch@0 {
		compatible = "nxp,sja1110a";
		reg = <0>;
		dsa,member = <0 0>;

		ethernet-ports {
			#address-cells = <1>;
			#size-cells = <0>;

			/* SW1_P1 */
			port@1 {
				reg = <1>;
				label = "con_2x20";
				phy-mode = "sgmii";

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@2 {
				reg = <2>;
				ethernet = <&dpmac17>;
				phy-mode = "rgmii-id";

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@3 {
				reg = <3>;
				label = "1ge_p1";
				phy-mode = "rgmii-id";
				phy-handle = <&sw1_mii3_phy>;
			};

			sw1p4: port@4 {
				reg = <4>;
				link = <&sw2p1>;
				phy-mode = "sgmii";

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@5 {
				reg = <5>;
				label = "trx1";
				phy-mode = "internal";
				phy-handle = <&sw1_port5_base_t1_phy>;
			};

			port@6 {
				reg = <6>;
				label = "trx2";
				phy-mode = "internal";
				phy-handle = <&sw1_port6_base_t1_phy>;
			};

			port@7 {
				reg = <7>;
				label = "trx3";
				phy-mode = "internal";
				phy-handle = <&sw1_port7_base_t1_phy>;
			};

			port@8 {
				reg = <8>;
				label = "trx4";
				phy-mode = "internal";
				phy-handle = <&sw1_port8_base_t1_phy>;
			};

			port@9 {
				reg = <9>;
				label = "trx5";
				phy-mode = "internal";
				phy-handle = <&sw1_port9_base_t1_phy>;
			};

			port@a {
				reg = <10>;
				label = "trx6";
				phy-mode = "internal";
				phy-handle = <&sw1_port10_base_t1_phy>;
			};
		};
	};

	/* SW2 */
	ethernet-switch@2 {
		compatible = "nxp,sja1110a";
		reg = <2>;
		dsa,member = <0 1>;

		ethernet-ports {
			#address-cells = <1>;
			#size-cells = <0>;

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
};

Basically it is a single DSA tree with 2 "ethernet" properties, i.e. a
multi-CPU-port system. There is also a DSA link between the switches,
but it is not a daisy chain topology, i.e. there is no "upstream" and
"downstream" switch, the DSA link is only to be used for the bridge data
plane (autonomous forwarding between switches, between the RJ-45 ports
and the automotive Ethernet ports), otherwise all traffic that should
reach the host should do so through the dedicated CPU port of the switch.

Of course, plain forwarding in this topology is bound to create packet
loops. I have thought long and hard about strategies to cut forwarding
in such a way as to prevent loops but also not impede normal operation
of the network on such a system, and I believe I have found a solution
that does work as expected. This relies heavily on DSA's recent ability
to perform RX filtering towards the host by installing MAC addresses as
static FDB entries. Since we have 2 distinct DSA masters, we have 2
distinct MAC addresses, and if the bridge is configured to have its own
MAC address that makes it 3 distinct MAC addresses. The bridge core,
plus the switchdev_handle_fdb_add_to_device() extension, handle each MAC
address by replicating it to each port of the DSA switch tree. So the
end result is that both switch 1 and switch 2 will have static FDB
entries towards their respective CPU ports for the 3 MAC addresses
corresponding to the DSA masters and to the bridge net device (and of
course, towards any station learned on a foreign interface).

So I think the basic design works, and it is basically just as fragile
as any other multi-CPU-port system is bound to be in terms of reliance
on static FDB entries towards the host (if hardware address learning on
the CPU port is to be used, MAC addresses would randomly bounce between
one CPU port and the other otherwise). In fact, I think it is even
better to start DSA's support of multi-CPU-port systems with something
small like the NXP Bluebox 3, because we allow some time for the code
paths like dsa_switch_host_address_match(), which were specifically
designed for it, to break in, and this board needs no user space
configuration of CPU ports, like static assignments between user and CPU
ports, or bonding between the CPU ports/DSA masters.

 *** SUBJECT HERE ***

*** BLURB HERE ***

Vladimir Oltean (8):
  net: dsa: rename teardown_default_cpu to teardown_cpu_ports
  net: dsa: give preference to local CPU ports
  net: dsa: sja1105: configure the cascade ports based on topology
  net: dsa: sja1105: manage the forwarding domain towards DSA ports
  net: dsa: sja1105: manage VLANs on cascade ports
  net: dsa: sja1105: increase MTU to account for VLAN header on DSA
    ports
  net: dsa: sja1105: suppress TX packets from looping back in "H"
    topologies
  net: dsa: sja1105: enable address learning on cascade ports

 drivers/net/dsa/sja1105/sja1105_main.c | 229 ++++++++++++++++++-------
 net/dsa/dsa2.c                         |  52 +++++-
 2 files changed, 215 insertions(+), 66 deletions(-)

-- 
2.25.1

