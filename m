Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1943DC1D6
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 02:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbhGaAOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 20:14:42 -0400
Received: from mail-eopbgr40043.outbound.protection.outlook.com ([40.107.4.43]:13735
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234366AbhGaAOh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 20:14:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACEom6KtdgHClUlCG3BKSs8O5mXX3FYXaEQiSbAomha2XSSs1DVJfYCfvs7/ssPu1lNPCKCcs52HQ+ap2KOP3yumThkwZQxbtGFpw+a21P2IePNlmtDX+/a4BPlRV2pnuuqv82c8YAHXak5EW+BTmBMjDSHhy7ZPteCs7A9jvVIQdvJvqvij2KVGAkh13FmVQ+Wni915AfAwF/7uUQcJHUGp+VcF+vfliYSeBsV5SI8bQJL5SnI/09Q//8NxDwtb/cc5x5VX3r6V65GEk0B8GGQNfMOspjRqM4psOwIL28CfwbVts3nSt0/zqA+jLo6fkfkb1UMs6LGMDYZukYolPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwI0jm+ZWgmCnORWmGh1d1TegTIKQ6d1GNKUNNMaqnI=;
 b=AOoWftExYeWn/rT/Mu+2w2OpdG6usRb/FoT3l9hSEjbfnfnmpFdvdxWDXopdDhA9R1YKTtgeFAxfjxVCX5DjqWoslhJueRd692rlwxbwbfsdk1ZyEwTDooTnLE8Y0b4Nwr0J8UpVLlnLAaSuXmqU4yvY09rtUxLg/5D7MpmyyXTUYMD69VCejwsBgRPMhlvKAxJ0g6UG9zDwpG0IN/mzTICjPbPwvj42oz0siaSEk9EBGcoDjDD2qzN/qRWvaf/naKuNg2zRJFdsBuivwASnW0dUi54In1eRBUlWDPAfQBdmgGbAeEvu8AWmvnD/Uac19WUUuHBeFpgc8JvsCL08gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwI0jm+ZWgmCnORWmGh1d1TegTIKQ6d1GNKUNNMaqnI=;
 b=AUPLAKVyveRjFrt5A72NQTL/Hwiyg46zi2ZyEUpj4LJ3DzYnEdv/15S7YtoFG3FpoLUYjYjnc5MhBbWE322DoWTmqZoicld4a1Lg9IS8Ui1k41QTG26Uwoalq4UuAA3bpac9rKK0SpcWahDvwoyZNzM+QgCJwwE9xunOOwpVPW0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Sat, 31 Jul
 2021 00:14:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 00:14:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH net-next 05/10] net: dsa: sja1105: manage VLANs on cascade ports
Date:   Sat, 31 Jul 2021 03:14:03 +0300
Message-Id: <20210731001408.1882772-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
References: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0161.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR02CA0161.eurprd02.prod.outlook.com (2603:10a6:20b:28d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Sat, 31 Jul 2021 00:14:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4243b2e8-0478-4abc-46d2-08d953b8275d
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:
X-Microsoft-Antispam-PRVS: <VE1PR04MB65117CE4FF499817FEB73EB8E0ED9@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gL5FSY5wGz45NWg1e3qeGxEqZcpM9qtFIaVoDN4XiVd0Jhz//0mv+5Ojo4w9+NzQnySROiXcr9o5aucE9SqSxV2PNXK7hQdxKVMP4EqPAZFGmqpHEiXAF+WNaShGaJcDv9UfGXfUNaKehA+XLfvQdZQEWA4bsVt2mXERTtyjFuLbWp8YWzWz6/+2kSDPbgjBIx/8FDRmevjchTVAtEeDucYO0uf69dofKE66n0SB8CP9ziMEWvpUzXvJ4pIccBg2B+oIyx72ZYM3+DmDbfkEcJde7KE2Tij0MHLzX0ZSVtdgSRds+sRJSw6xVG6yJZONT2UrsFwNc7iKh5eyUfiSE0CP9+uLELAZseWcizlSBJuzP1v1qtacBWSGrlBONU5E/aTotYanlh1UWI1U+3X44rRCr4YjOmf2oUyrx6IZTFVQurpoeU5gW4U0WtneHnZQgWyJ8czS3B0ZrFysNjwVsD3wNG1j95hDDMYJ6T9DF/2Pyq/PQNYLY7MQ6LR5HLf1J9L0Hy4d47A6UrsNcddZjxBuTlqYVzCtAV0RakcZgI6HqXbNDrHJXwVkAhgQIHTwQYshiohK5vvNOMRy3mWBmCVkAgb5hh1Vl/GlSbl0CUwa9MmqARdkDMIVLX6TY9ThRGq+Vo/fXTZVxJ/SMSGc01w60dpHvDAzdmdtUBIX6E+ArOINO42dspYTaEi0pUqaWvx4L0W9vsg733quy4E5eA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(8936002)(6486002)(6506007)(52116002)(6512007)(508600001)(66946007)(66476007)(4326008)(66556008)(956004)(5660300002)(36756003)(44832011)(38100700002)(38350700002)(83380400001)(54906003)(2906002)(8676002)(6666004)(1076003)(110136005)(2616005)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y7Yc7PoI0FhtLyR3+74hC6AeU5AHPcPcnQ17UqmDF+WuYmGyBl+RZeVg+2rS?=
 =?us-ascii?Q?3aEc3AeaY2YRY6koDYxhSzQewp5NEOf0fpdlzMOpYNxAhcJF90QklYfpxFui?=
 =?us-ascii?Q?EZbciQ0yPQyopswarK8t8lQINuIRUVa/HF57vXEL3JMJfj5Ft8RfTd6SvYHj?=
 =?us-ascii?Q?6y1Fitl+/t0lp2F1noQ2HpkMeAbgQlapeEuYnsJ9+MgORBTzYXj6S5LzvrVh?=
 =?us-ascii?Q?2jK5Jj3Cokxq/85lYYj70lCWlPxIaIjnI+mtG824WF6KbL4amLhNZXZ/PCOJ?=
 =?us-ascii?Q?htuAffNUNJ7au5iOdNyo4mTNmcRPhXnpy1nMr477EKBi7j+/Wb3r/0nu41Ds?=
 =?us-ascii?Q?r6c0eRqVuiAldVrOvR40/pBOs1rHrRNSnfNL1sDMCD+O/jj/oZtc9SMC5sZx?=
 =?us-ascii?Q?ZrssDOZq2JF/M1Jf6T7ZLXrfdFOAbzhjmz+yzDIflnESbbmsnI0kjtPRe/Yp?=
 =?us-ascii?Q?0DGqxiDm8ppR0ZXqukVdEhhW0A4BP8lGFDXz4XyJQzq0HsbuI5rcLkp64O4m?=
 =?us-ascii?Q?/Ci1JUseheUD26adZWTR6z7YL1dfwvJfKzf2uJB4OpqRlyZO1UcWjzoFbs0o?=
 =?us-ascii?Q?Hb/q0fNyatR19kg7nsacL190CGACDqZfYEj8RWv2e4IvnCOGlMdtBnZbNZQJ?=
 =?us-ascii?Q?dodS0uOfu6xX7RAm5EMDp2XbdChEa+8mJ+KHHW8BTs+tNWUl/qWRnlmJbzhq?=
 =?us-ascii?Q?XhdPprS+vpXjvL1/YbencogVw/ME2t37od0/z7y+IhFFEqubrqrKsmt0BmRe?=
 =?us-ascii?Q?8C1rfVSIqBpa4mYNmvnvXCft5gDZUVi+1kc3Qd7EkXZEUXAYlfETYyWoLOOJ?=
 =?us-ascii?Q?xsFOP//d4wt6rTopB2i2UmSMSqz6Z7qA3afl8T8sWwB87Dmsl/bTVDMaNxmp?=
 =?us-ascii?Q?VN8ncIBri2v58y9TguEmDvfMmn/hl9FOsLfN6vEHP7GcO2RSmiexmeBmdktY?=
 =?us-ascii?Q?37eFAdmmLTIUc4H277gxrRUrkLap4kKNkvPZ1uogomJ9Mk0I9DKMN363Cy61?=
 =?us-ascii?Q?GQGRd1gSCJBD7K3wJyQaBS/Ooxo7dv2M8MWnLD/5o2Q3DVrOcyTowk2sr+ah?=
 =?us-ascii?Q?o2SRmrx/6OX2NXQoJEHs7FkJr0nLH+QwQNGPP69yzPktkGqUnx49Hx3SOyUx?=
 =?us-ascii?Q?Leo9tsbDBjLXgLvgyNEyFSxLAsAEXH049JqI4jedNFn7yLXj3IuwAFivPIgt?=
 =?us-ascii?Q?FTmLe0eVqlQRp+4Sce3MUr815gaFR4etlV35rIlpIu0vpOfPC37s0bafqtTQ?=
 =?us-ascii?Q?J4wg1n0NekAq0gamV83zvt5NcVzbGeM0Gg1fO73xFNRLCD9YkxMI8vszGAC3?=
 =?us-ascii?Q?vHKwAlSP2nrFrfj1qQd8NK+Z?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4243b2e8-0478-4abc-46d2-08d953b8275d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 00:14:25.0647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TG0LY1wOPKJewc3DHrU4rRoPiQ8wErIzMBNsPBAxmZy1MZfIh9NF23w3e0wVNjjlU11BZKfK4MAK6IGMkxjQ/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit ed040abca4c1 ("net: dsa: sja1105: use 4095 as the private
VLAN for untagged traffic"), this driver uses a reserved value as pvid
for the host port (DSA CPU port). Control packets which are sent as
untagged get classified to this VLAN, and all ports are members of it
(this is to be expected for control packets).

Manage all cascade ports in the same way and allow control packets to
egress everywhere.

Also, all VLANs need to be sent as egress-tagged on all cascade ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 66a54defde18..d1d4d956cae8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -460,7 +460,7 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 		pvid.vlan_bc |= BIT(port);
 		pvid.tag_port &= ~BIT(port);
 
-		if (dsa_is_cpu_port(ds, port)) {
+		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port)) {
 			priv->tag_8021q_pvid[port] = SJA1105_DEFAULT_VLAN;
 			priv->bridge_pvid[port] = SJA1105_DEFAULT_VLAN;
 		}
@@ -2310,8 +2310,8 @@ static int sja1105_bridge_vlan_add(struct dsa_switch *ds, int port,
 		return -EBUSY;
 	}
 
-	/* Always install bridge VLANs as egress-tagged on the CPU port. */
-	if (dsa_is_cpu_port(ds, port))
+	/* Always install bridge VLANs as egress-tagged on CPU and DSA ports */
+	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
 		flags = 0;
 
 	rc = sja1105_vlan_add(priv, port, vlan->vid, flags);
-- 
2.25.1

