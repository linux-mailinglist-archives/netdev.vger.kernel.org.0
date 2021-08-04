Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F773E01C2
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbhHDNQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:16:56 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:63904
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237394AbhHDNQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:16:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFSlcUFOWMT1zdtd1hsohbRgBKQGVMqB8X7jPzcTmZ9ISRHN8darxIeRkMM/Rcmc6aaiwK6ZkQVBOaB48spbUBIDJXBycx4JeoMJu5USpVimgWw5x1Ozstq53G6tf1uJsM8OfklIphw6nvQs7KO6aZF+gIX+iNBmcZoXPjcuIdWTTZQufElX+uW19udh3diZkl13RBlI1+pgtKy2mEKfzUEpH2LefDTX0X2NvccvaUbxmP9cgYfe+N7vAlddBoHWkXMhdawjTMSnEZPojNPVSvEaIhJHtxpkYL7/zQu7eUXufoLvoBhZIJ3ZPBnbk7OsLkz5y/SvPiUkFYavh4/53g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwm4+o/k+ktftJ+fc3fPeFVgghXj0jSymo0QXyrSHt0=;
 b=HuHzgOf5Xh5DPsZrfeXUNxnTyLqe3LzP9WGaIk6ZWTBWECVGn7oG7M74a4DH17fYsyB0RRlO7+LEZQZziEVdKt/MXiEtklyApDt1Yx/fVbQN63lq20BUJMRzRyBQUEOY0SjM0whOcREGlOAOy+S/a5J9NG93nMA3Sjq1DUR/XrDVuPhkCQ6nSySkngWhEbXywKG9w98clUi44246/XLYV4bVrs3vYomeVHzQw6EFqoxgLD6TNljJ635jYvwjJPftCP4Pe+R2c3KKOSPX+pASn9RB/62d7yDR57Ycl2t0AWqym0qzjI9XGjUq9KYsjYqzw0TFA32cXAkHHfJai8Lg9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwm4+o/k+ktftJ+fc3fPeFVgghXj0jSymo0QXyrSHt0=;
 b=bxbnN+N8zxV+1Ul7mDe4DEIm7PFswXbcNs47zIWExOtZG/gqBYAJIyhox/k0DxiU889c6tK37wy0vNPMAGttO4eszTSiXKrJ/9D0Ha278EJ/ALdSElv/R5nD5rt/ojrMCjDdSaKZ2Ahlf/Y7fJ6HcjztUvOlFPHy0cgVQMMxkaM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 13:16:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:16:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 0/8] NXP SJA1105 driver support for "H" switch topologies
Date:   Wed,  4 Aug 2021 16:16:14 +0300
Message-Id: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0083.eurprd03.prod.outlook.com
 (2603:10a6:208:69::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR03CA0083.eurprd03.prod.outlook.com (2603:10a6:208:69::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 13:16:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e204339-dcc3-4e42-1700-08d9574a194a
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3967E0A1DB2D2F124DEDD941E0F19@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JwP2Jx5/A0K4qIYNvf4bpbT1HKzlXLmNNq2mWf/mL8IzfKDQv0ajw9dJ2+TnXGvUkFU60YFP4D5xK+HVx+G4cyf2IdC2e3BJryk25Dn2BjjXZNdivvgK7ZOZUbu4rT2ET30EVJKE7FAfDyX9fRdN3A0e+qNxYYBGD8D3klMeDR6xGuYIHtNb9irgItavIl/kv8Nxd2pEh0oycLu/3ZtBnCBvhy5fuHT5CXA/vAxbWbOPx2mi5W2P6iiY8L5bjqXnUPeR7cDO00n+7jFNYcWQdj+52yL48514YmVKKMaSzA1VzxLICrvipMNNc6qVOugSOFRj//bOmb6lm2nnwrybL43qh7kGIP4RHGx4ntBNIv8XCabDg5y9tq2d6vC8JA9OLt3YsmSyrZf8xB04jEo1rLcPY3vuAJkvihJEAzcE0tz0gjpcixQsCbPu7eqLzs6a9jE3u0JEjiJFX9QLhqV0dhEJjFpSkrbU6jmFeLKCpjEAXoSCBmVdKSC0kMxtquRa//yqapKMF3/05A8dkKE8705XXxYqeOGMVXUU9nRpM6uetGXNxsNXXphpi88zlbDLpWZRrxJ6/+E7yJj63C7UF98x0M3a4br9ivlAeECBVVxIpBcQU6rmN0qBOF7AgeK+RCrClAGQ3YMuX1fZ63ohk93Wqt6MC5vjA9M00YGJjJE4SM3TQtESzOQZWvxDuElAX25LRVIYqRTDQno7tYUkSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(478600001)(36756003)(1076003)(66476007)(2906002)(6512007)(66946007)(83380400001)(66556008)(54906003)(8936002)(86362001)(5660300002)(8676002)(6666004)(316002)(26005)(6486002)(110136005)(6506007)(38350700002)(52116002)(956004)(2616005)(4326008)(38100700002)(44832011)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gxx3YFZBYYuEpKYioYfNYP7+Kl0uq2fF3u3vydaa12ZBfFkAtA0sx8UCJPaF?=
 =?us-ascii?Q?LO6rMgBHtd097RQdED8HO0DafWTiB0rhWFor1eOUL4nDdsOSMqj9P12GDsbl?=
 =?us-ascii?Q?ob7zvUZpzbq5Ncdn5ggkJwdx3oQB7YSX3Wwwtbi+RKjSyLrmK429uQpbcUr/?=
 =?us-ascii?Q?QtNf4ejgBsX3rVMT8ZNsSELDtZ6VG++wszu71rq8N0aYx3XpTT5RBBi36+Qh?=
 =?us-ascii?Q?uiOzpLkswMdIMKtjvA02aPfeMxUubeVWzZ2qQkBawyPYP7kYg9mwlAmoA/+1?=
 =?us-ascii?Q?9mAP135lxylaV+K4KWDE6yQAj1VEJxinvcYpKFHqspkgUCaNcRHeg4k8W56Y?=
 =?us-ascii?Q?EA5zD9v2cQzF8BDCPUT7ZQJ9zJ/Fjpjlc1Fk8cLpQKCBPPoH4IGYE2KlcDs8?=
 =?us-ascii?Q?qJGy8YnlekRvaXxRvq5e/zswf8Qu6r7cWDsMMMjpWBy1qDqyxWxhzu1oWgmu?=
 =?us-ascii?Q?T/H03k7HjAQFVvTNMb/+McvjgRFm9uJgEku1eoQWdXbfzH8AwbCO8udWXY3I?=
 =?us-ascii?Q?iY7EVUVnvy7KuLGeZ6Xs5xm8RrDKGulDz0RHGj1fWvo/tY7q4nRspH9Ql8nZ?=
 =?us-ascii?Q?3GJLQvWKMVpwGa5iz29NkeufztXUpmOJacKkNqk6I0yxCMpCJNf58sFXPsHu?=
 =?us-ascii?Q?mczAFtBCUENEMkNK2Dq0N+DxQfFhsOlSIgx3b3+SN0uhg8aMDp2Gh9OfeOIG?=
 =?us-ascii?Q?qJzjze9munt+yWuixwwzibouUd3A++KPZQNAGUe4scVLO57QM09Vq594M0Gg?=
 =?us-ascii?Q?B4JFxDu2SELxFE95zVyNNbZLLQVYzDyJL4rXcfZU/btZM3UVJzsMZWWnHJD1?=
 =?us-ascii?Q?T6S/tpFfKQrvsMWuGcWKQPWbllRVixUMABM1NxArxIp8mDbv2NkeN2kgN9nn?=
 =?us-ascii?Q?buLY4OolwO3Fi1Pg7AA+e1rlSXg/xKU4ZQYhOUw/vZcwuYTvI2fz6OP7rGeD?=
 =?us-ascii?Q?TlSbh2wEIusBnFUL/HBfgyY2V3O2Lz71ZcFCsZOcUlVjEoxZZJHZypvThHwq?=
 =?us-ascii?Q?x0mKLCYkaaANzSnjET/6TEwo6oQ7JRqB22aZIdsU4WqElSIGnHEkSkLauYhH?=
 =?us-ascii?Q?H0L2gnx/BFwsMAh66ia8n6ocSGwX3xmC5jcJbkpREpaFjX5h9ffzdiZuXF1h?=
 =?us-ascii?Q?G1SWQIwIWAAmw7emcAjnXF+2HsP7VtLE3kasoLlxSncaJdrvB6TYWShZT2fw?=
 =?us-ascii?Q?NS1PqPrnPLbHcU3/BaUu4t6rc+5MT+L4USzOIbQ4yXpFgEyFoCnVLIiotDLl?=
 =?us-ascii?Q?Odyzsc9LHTJGCZsDPXxJySB5bTjTO9BMbPfnTGf1EHr/QrgqypqPXA38tCH3?=
 =?us-ascii?Q?0BKQZEfgkm7BhwGnFVQNwNmh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e204339-dcc3-4e42-1700-08d9574a194a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:16:41.5546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2u7BjWdq9x82eAdRWxrlEUke3gOx+QDp5tKJF2DHsBks4byKXbuWzMU3yyXnW5cH/EzJxprR7MD4svrJC6b2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 net/dsa/dsa2.c                         |  47 ++++-
 2 files changed, 210 insertions(+), 66 deletions(-)

-- 
2.25.1

