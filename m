Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C663E01CB
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238419AbhHDNRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:17:50 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:63904
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238369AbhHDNRn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:17:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T521XhAKySN7SQ+VWJx0a7CewTatDU+SjONF3hYb1Gne9WsB17+B5VL07nvtJw12ncaTrfzYIUPaut84FMbobqOPfcKueLMPsC7sLV0UiA9aq1IoDwyWGUidBVHleEb/6zlQ5F9f8s2w3MSAjHfmfHVkVYjdvIrXOUYNXH5q5I2jhZpIBy5ozz//zSMVMLI/rYYgUzmy87z0mI8hPfrcvVubQUA2VlqAzidT8O6E3R5zpbtKY8S55X0M8ztBOUVgTDaAKUHhv0EPHA/83xAtv8LJ7CaV63ZwNGbNIlPsclLI2H/fL2GxEPxXIpu2slayKLgjwzLY0HjdvxOXGeEleQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFP0ZDXnCmxYhygfqgxLl3BCxbUOVWsrQ3TY81MvUAI=;
 b=ehTYP8uCWr/fKNrJoEl7HebRlULlNrXqt0jLdJ4soWw9esjLCyCSXLwF2ae4NrxnGs6A+QVjUH2famyIIl0PU14tJ9f+Oi15cNDbV4pQDWT/7mXcps/46BwZSKDDndvHNcrd4zJFfSJVYqjrDDb3U3CnEuyrugGgQ1/w5DL7RSDKlnefUEtoxHCSc/QaaAqm/Bsl4QPZMz0ud2jkhgDMYbZGrvB3RBrPtUpB7dqkRe+yV34z2+GHpKz/+vG7faQf9o58FXGqiMDBfAhkmgLUoxiJXR9uad0/L9VboG+T81goDnqdCcWclGfJZLeHxDs0/gv/uUO651OrRNZpelw8OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFP0ZDXnCmxYhygfqgxLl3BCxbUOVWsrQ3TY81MvUAI=;
 b=iuhdBCb+iC+XJnHN0Sv5SNlPvepp18r9hU1iOhaybPAP48sKMaedtfGsUGIBe5rlFZaO5lJL85JMbwVXg26wsbvV28vaa2IqSRzB7OiupG3Luw8OF8o78WwXal1vurxePhhq4rWAbJ9AjI+lJ2wmcItJsZFJt8yZ0s/1HyXCX3w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 13:16:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:16:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 8/8] net: dsa: sja1105: enable address learning on cascade ports
Date:   Wed,  4 Aug 2021 16:16:22 +0300
Message-Id: <20210804131622.1695024-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
References: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0083.eurprd03.prod.outlook.com
 (2603:10a6:208:69::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR03CA0083.eurprd03.prod.outlook.com (2603:10a6:208:69::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 13:16:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3879bca-572f-4718-96d7-08d9574a1df8
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39673A559ADA6AF2CC098EE0E0F19@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vXDH+cTQHoGYa6vPZN0MY652/y3qfptoLpohmxJGJSu/hoO7U/+fD7kdq04bE7M1KpoY8rQA1jqE8EKoBywL4MMZAwXJ/85SylYWTuEuW8AudrDdCEj1igsEfdUHDUFW/PIU9Zg4goNePNuhPaiGD5HIysViJaPUbqZ9PNea0h0abOxnjciXlEx1mHWaEgPJnHnRWEcv1MH9QTe5mlD0IAHQzzmlSaEWJC9nVuSCh41cnwwhc4sXxpYGD9W/BAjhO9pXP72/MqnWPNMoB9CsUjo4Hxrk77YXLVK8ODpXlC0PY6h0gXymk+k66TiHJcy4X+M5pMqsC8Ortp7kywI1pUEjRo7pmqdwz5i56vb/buAOmvEOC9ZIIBk3lXTwomX0ui8s/rUrKGNege8mhbcARjcDudY2YFXBu0vKb/0n0Mr70pY1OMqusfWpQXonqXn64IDvNfT6zI6kISVVmGXz87j9LERCUQgofwSHXwD71+Z/6TOy09j1FGPG+luLPSLqrzIBE8AhdGx/lp1XD65Po1ue+645D18AldYpNJfDQ/TGeE5B3DNlrOjugQSBQTuEG8QRGrjN29EhxH6CC3jxbwLIgNnRIbdjPARn2kv7XVyZZhwm/V+0CQILyuZ1dVkew7Y2fpt0Zrf4TLlDgWqlBcCze49w0YHOASuCgrCmX7+/D1lnlb018JYV7dnaPOVGpnw3oEwrswClgqiEHAsGUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(478600001)(36756003)(1076003)(66476007)(2906002)(6512007)(66946007)(83380400001)(66556008)(54906003)(8936002)(86362001)(5660300002)(8676002)(6666004)(316002)(26005)(6486002)(110136005)(6506007)(38350700002)(52116002)(956004)(2616005)(4326008)(38100700002)(44832011)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Oxr7Q6wch5CldzUcxHdiaQsWNMIHCRFX1/5OKZ5/1cyWOTQWpBJeS9R0y8MB?=
 =?us-ascii?Q?6w/3L8k/LGUpnPqZ0QX6dPaKPYPIEEe2CRfWr2AuHFoJldxaHLFApezjgyT4?=
 =?us-ascii?Q?Hsd7nFNTS3zM3QRKYRyxOewNwMW1zHumWdCCKwRdFcyZ0ouwiyiJ6DbNlfpy?=
 =?us-ascii?Q?OloKHRVr/HFSw7GnIreK24PkaiCGd9B1zX55qBnQg5qVCWfT2S1Cca5U9TlG?=
 =?us-ascii?Q?h0nyuF9jHW8kkGvJhZAXIclbmZ3zkQG7148S3Z+YAUvCKRV7VPLdLxmCX2UX?=
 =?us-ascii?Q?rgR9N1WiI70XwzEZ+SG9ySfm09oW98gx1rgGSE4SYwfi5VEbgz6LUpsqYw5j?=
 =?us-ascii?Q?0sPk9BKGjDe9ywQIUUcZGIFoRxP2/fqzp93IBxCNcgm/YI6rRfz7CUZz3S08?=
 =?us-ascii?Q?c/e0RPOyKBYuWxomlesL2Dc1W4V375/UZCghIIEtp8P6aVyz/gP/yZ4jgxl9?=
 =?us-ascii?Q?ybnENAIb/dlAUorTLH0DLfuyk8wQ+0g/zmNN33GB0boO3yssLF+CkUG0KAFp?=
 =?us-ascii?Q?lkdrFJCan4nSDDrGvTe91TDfqXp9PTIg/W5y1HuLdLNid2DuzM83mJALm+Al?=
 =?us-ascii?Q?Ug/4dq4DsV3VWJu7ndm5xX7rxwlZyfswruRJXuM6RwaLj0S3H0E/hCM42xQX?=
 =?us-ascii?Q?xlnWFP30W7I2eWdLOyKNcoik1I+TnBGHsiu3KIkEISX9g1HgtTfddS/Pf2pI?=
 =?us-ascii?Q?Zccrh9Ivz8MVPujkTGqj/BILkOrKfENNb+sR9EZnXtwWtcqftNx8G+ivb0od?=
 =?us-ascii?Q?PaQN43qs+DtVQb2nP2JUr6Gws+v/c5c6MxaAl+G1fkuwbMFe6fAnxPmb0F3t?=
 =?us-ascii?Q?zdozXuoOKOR4gMx7K3xxfPKa6/2vV4TDps2Lnj4D8Kr7sHK4smmharH7e+Rh?=
 =?us-ascii?Q?BDzSe30RpJixKtuH+R7pMPZv2BGENeOcEmAONg/lV5H7qW4LqDzYY3yVg66v?=
 =?us-ascii?Q?lriSbKltNfIU2vXyd2gEbcood3WGvmKCe0vIX4MaOrI76GkVKb6ioeJkQMvn?=
 =?us-ascii?Q?yiIDQSCBa0XWk0K396PszV3JrFhrBJ+JtgNAtrZxWHw8H6lG30Dhi9cYvMHi?=
 =?us-ascii?Q?VS3FOB1Hjex1l0VyabFZNns50WzckuyVrMNoaXvuBLq2y1TAdtx2b1cQWf1n?=
 =?us-ascii?Q?88qEInvRTxQcry77M8rg6xNBWOnsCuVxHKJnOKLzYoDGdNpfY4q4Cw9+XRq2?=
 =?us-ascii?Q?zb2Mxnz2I5ijgnkzOYzMz6J9hYqAjkn2Q2jRXrW5JVutCGJZqDFPCPDWmlFU?=
 =?us-ascii?Q?umfbx//zcXVTOcBQf3MDKIUOlRqtm9OMsi1h/G+BLJBGYjEeWwix+sBqH/XV?=
 =?us-ascii?Q?EViRQLr96u+SFpsiTyMJzPoO?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3879bca-572f-4718-96d7-08d9574a1df8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:16:49.3242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z+ueLq+eFtJ4RzZZ8V7jiiPU9Qbf2nIyen2OBHLlKF18RrPTMc4XgAp5DNNq69c3LLL9uqNn58YHJVz6AxL65Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, address learning is disabled on DSA ports, which means that a
packet received over a DSA port from a cross-chip switch will be flooded
to unrelated ports.

It is desirable to eliminate that, but for that we need a breakdown of
the possibilities for the sja1105 driver. A DSA port can be:

- a downstream-facing cascade port. This is simple because it will
  always receive packets from a downstream switch, and there should be
  no other route to reach that downstream switch in the first place,
  which means it should be safe to learn that MAC address towards that
  switch.

- an upstream-facing cascade port. This receives packets either:
  * autonomously forwarded by an upstream switch (and therefore these
    packets belong to the data plane of a bridge, so address learning
    should be ok), or
  * injected from the CPU. This deserves further discussion, as normally,
    an upstream-facing cascade port is no different than the CPU port
    itself. But with "H" topologies (a DSA link towards a switch that
    has its own CPU port), these are more "laterally-facing" cascade
    ports than they are "upstream-facing". Here, there is a risk that
    the port might learn the host addresses on the wrong port (on the
    DSA port instead of on its own CPU port), but this is solved by
    DSA's RX filtering infrastructure, which installs the host addresses
    as static FDB entries on the CPU port of all switches in a "H" tree.
    So even if there will be an attempt from the switch to migrate the
    FDB entry from the CPU port to the laterally-facing cascade port, it
    will fail to do that, because the FDB entry that already exists is
    static and cannot migrate. So address learning should be safe for
    this configuration too.

Ok, so what about other MAC addresses coming from the host, not
necessarily the bridge local FDB entries? What about MAC addresses
dynamically learned on foreign interfaces, isn't there a risk that
cascade ports will learn these entries dynamically when they are
supposed to be delivered towards the CPU port? Well, that is correct,
and this is why we also need to enable the assisted learning feature, to
snoop for these addresses and write them to hardware as static FDB
entries towards the CPU, to make the switch's learning process on the
cascade ports ineffective for them. With assisted learning enabled, the
hardware learning on the CPU port must be disabled.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b3b5ae3ef408..f13a6766dd41 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -199,9 +199,13 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 		mac[i] = default_mac;
 
 		/* Let sja1105_bridge_stp_state_set() keep address learning
-		 * enabled for the CPU port.
+		 * enabled for the DSA ports. CPU ports use software-assisted
+		 * learning to ensure that only FDB entries belonging to the
+		 * bridge are learned, and that they are learned towards all
+		 * CPU ports in a cross-chip topology if multiple CPU ports
+		 * exist.
 		 */
-		if (dsa_is_cpu_port(ds, i))
+		if (dsa_is_dsa_port(ds, i))
 			priv->learn_ena |= BIT(i);
 	}
 
@@ -2509,6 +2513,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 	ds->num_tx_queues = SJA1105_NUM_TC;
 
 	ds->mtu_enforcement_ingress = true;
+	ds->assisted_learning_on_cpu_port = true;
 
 	rc = sja1105_devlink_setup(ds);
 	if (rc < 0)
-- 
2.25.1

