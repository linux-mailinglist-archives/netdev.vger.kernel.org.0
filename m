Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B491C3E01C9
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238370AbhHDNRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:17:43 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:63904
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238339AbhHDNR0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:17:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kl8LVN1BohSM5jRJgLCoH5amO2ZZ9R9JfMhxe2EZYzGxbMtLIxEKFr8JBoAaqq6KwebJvKTjA4wtbb/QV5lMCaVK2wbWe3rxNQWT5GgIrABliYsRDo8F7jkqTwBx1iyRNYvJKTRA7A5ZpAAfTuJ8Ebeo1BmsaBDMzgIuCvSxaRCedIsCuzo3FiHQ+jMdideoy0U07bMFUdzfdaXHedgmonMYxqXa9SbNKMkJtrCW/IHlLp2wNslKIiCdwt426XatnC+GpDDksoF4HwPnmh49EUMy89Eajxuda+J26b4rKX7rDktR7ZyY0kKiQ5iCW1JdlKknT+0X5wfJzlXtpEBKow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xv8psI/5kz8emCRqcS+SdgKVUIb5qDFIY0g5PQAGfMo=;
 b=U84aBqN1pd7vkympd/H5jYmTs6xz0anbsZyBk0HmMcSJVUWrJSu0q5XGR8+sp8CoX2UphaXq8FvNeShsdU0GfaGmI6VVVkymLc0fQGcdIgS4inHN+FGR7xmzVf5aD6AakEp9kGAQh6dgNQJvxqOHRvdr+RwpVigGLxz/M5oHRwy4l36HEndGGOGY1kONVQqLjZHZtblb4yqUBpUwA2+H2NdrSvKVx3AfqdqD9jkswQJlqEDbeWaxqVIpBC12HLPTzTfOdUw/PTGicazNsEG95AdKWGtHKHVZmdX38bRvw7pXy+Ot6YrJ3lzE6dfHXOxqYpxYjvnBe6h4xYRaFbOfNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xv8psI/5kz8emCRqcS+SdgKVUIb5qDFIY0g5PQAGfMo=;
 b=mBBR3ULgrACowoFMsZSzRJZZuA0/unNo06sXcghEb4Bk3ufpg2IiAjqbA0LAV9QoYzLQF8/KXm7/rZv3Mjg/wlqvunP6M/KrE0WnDAqDLGti9hOQeWgzVoUuB36tXetjeHuulUU9v1cyFpHgyR2hBCiePHaxHvk/xRCEFnWk1xg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 13:16:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:16:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 6/8] net: dsa: sja1105: increase MTU to account for VLAN header on DSA ports
Date:   Wed,  4 Aug 2021 16:16:20 +0300
Message-Id: <20210804131622.1695024-7-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM0PR03CA0083.eurprd03.prod.outlook.com (2603:10a6:208:69::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 13:16:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e457acb-b1f6-4499-d23d-08d9574a1cd8
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3967761A1EABEFDE9297EC0EE0F19@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pr3wSC6gdX76m1ojd/NQIVk5GuPSoAgbzUbSNAyvjFp+/sSHYcXvYqGFvxdF6yflKyIW2wdobInyZk+Ygydyi6gycEOcNYbNDTK+oMhGENR5t7vwu2ij/+QDK/asHL1v77iK8k0IH3Fo+D4G1PmoLydMgfQGK1w9IANoSoztXkrV7/3iGeakZUoTUPU5YYj8myUW7OsfWnfHIbh3SADk4qw80g+cq7YEYvUtuZ19DjkmELr+tzID8PNT+vhBmslJ1KuJb5iDlCF0S33ST6SOmpDb+y4/y8hYm7p388DOnDk7fp9N8spnZlIGlGq6p0MOtyRQzPcyhbzKB61dpFVM3WNS5g/ZkqjSaJfpcb9eJ9rcgB2t2J34r2DaIeOt5dILuJm5fKQNxnzi/z2J1cZQ9y05tNqhjRutu58yh68e7QiDeUYq1R6Saq3JWVz5GvmSI+PImZiYRdAaWzqJVb2iy3PasNklaNFab+5fMi62yK2uRWtZYBPDQAZcEv8ZAw98opXmxm2emZYX8Nge9txpp+/6qwh8E923HM+dajb6vpbBiSx4DrlXsQQUP7gsq1zseXtl4NDmQplvQtf2OU/d58JdbQp00kEBRu+hZcwtHVMa81JDKc7SSZThDEgUvX9aG1wg57rl9RYcqSDtpKQeZSpeI11rUckdqSXh5VZLcS6A8p0yDfL5grtyFm3IVgkFNsXOhp7+QTygC5tzZArAMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(478600001)(36756003)(1076003)(66476007)(2906002)(6512007)(66946007)(83380400001)(66556008)(54906003)(8936002)(15650500001)(86362001)(5660300002)(8676002)(6666004)(316002)(26005)(6486002)(110136005)(6506007)(38350700002)(52116002)(956004)(2616005)(4326008)(38100700002)(44832011)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JzSHmmItf8B019K8/6riASiRiJuOBzT0Cqs4L7Lc5+9nEsZVQosxnayju0Aa?=
 =?us-ascii?Q?wz2TRWUuhV3GE1a8tW1L3q32hd/DIcz3miG+RG+P1nNkNu7MMmilOWlDbTN5?=
 =?us-ascii?Q?2IBfUuYtpmPNTD72SlTECsbWxPuc2ke/6K5rDGnxNPb3JuVwsxoja+Yp6Xsx?=
 =?us-ascii?Q?co0g+J6pO0pfmFYiwydmyjpcbpW4rG4stpGP8unlvOP62wc5zEIsNMpYGvhm?=
 =?us-ascii?Q?R7/vxOlcLfkdEcJgWAPBUL3NDhG8ed7qSfI3mbFSTgOGUx31dtQt5t/ywCcS?=
 =?us-ascii?Q?+ShsZTKS84wPVjHysRfkOK5jrXbzQK77uASLYgr0x3jSGpeXUhgRLS66u5ru?=
 =?us-ascii?Q?frj9qaiMfzHbUTMF/qt1i3C5z0QCRli/HxYEYtBVvyOAIkZkyrIWcSDBULId?=
 =?us-ascii?Q?Di0Fa6Kg2TkEHSEExSki89WoJ8kWMB8WWM3egfKHz3vWn+Abs18vjrjEAc7p?=
 =?us-ascii?Q?zp3KAFv6Bhc/fwJOUpRqcbvMl3YvFwWI2Pg7SIUhG3jxzYXwgJ0XUqwxbegn?=
 =?us-ascii?Q?oYaKx1pTsQUG2w5aTmMnRBfCh8KerTOWZDsKNFJySgEI9+bjNQ8fbSHdDEGU?=
 =?us-ascii?Q?pJ+Rg45XK1GQBisdjKAJehNjuUOmkgLdA9+PNR/5didymNxIRsb/pCmaGySo?=
 =?us-ascii?Q?dgojG0qVYybe4VpL4FfhK8dkpcRrtb7CdgXRj9d0DVCvX1ZofE6Oyvw4uX+k?=
 =?us-ascii?Q?A1ItHMfL1GLuwcE4BKK9AhwPPU/4IXxLTAO3MBWSnYlDpTZ1YyJKxZRy3+GM?=
 =?us-ascii?Q?H+9+XqFDNNXmvdkmdu+dX5OZf03P6tH06i/i+bhiK9CsoKUWKTZ2kFXMFtSh?=
 =?us-ascii?Q?65FyP5lrgc1O1I60P4OZeVlrpH1OeBIjWeMDdctUYxKuCG/3PC/Al/h7iC5F?=
 =?us-ascii?Q?3zjCrzr0RuOUHyt/1N6F3qJrWXiQc1ltiKg3XrJ0X+N3+aTjKl96EVpT8RZD?=
 =?us-ascii?Q?sA0b3jOPoqHTHajlt2/0M+XkM40eqXur1JYeXZx8uXwhQ1ewl1mab4lgIf17?=
 =?us-ascii?Q?MfBKp2Zradxjfb8fRfFX9t+Q2GByjPqToYjPcwLhpeSnC0PDqrNZVIqvWR2+?=
 =?us-ascii?Q?ZeNL/RB2EWpzKtQsgU23Ey5V/yybPeXifSyYweiF/TAb+TfalK3K6705w1ct?=
 =?us-ascii?Q?2ZRon0sO9eXMTFjWENNA/rAPrmAdNwHkvaWfR6oRjrnJ/hHO5dKlURetza4p?=
 =?us-ascii?Q?/pYoYYASs8bw3LBQHF273sW/jecvz3tkMC2jgjgfrRio7gE6zFZ+TlZglA2B?=
 =?us-ascii?Q?LnN+NWYM3c2H7KggEavPT7k8PchiuNUdZxZXizLDGLg/FUVGDFOgiG68Hq/a?=
 =?us-ascii?Q?Aq654pCkHUFTPMqfHVcwNK2h?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e457acb-b1f6-4499-d23d-08d9574a1cd8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:16:47.4642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pqFw0MuxdICnNuXBjTdICDF1C0649fbXRmOcNvNnk0H7si8WlfIzObF4MtvbKay9QfcV+lHQe7iPnVu0nJU9+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since all packets are transmitted as VLAN-tagged over a DSA link (this
VLAN tag represents the tag_8021q header), we need to increase the MTU
of these interfaces to account for the possibility that we are already
transporting a user-visible VLAN header.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d1d4d956cae8..fffcaef6b148 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -982,7 +982,7 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 	for (port = 0; port < ds->num_ports; port++) {
 		int mtu = VLAN_ETH_FRAME_LEN + ETH_FCS_LEN;
 
-		if (dsa_is_cpu_port(priv->ds, port))
+		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
 			mtu += VLAN_HLEN;
 
 		policing[port].smax = 65535; /* Burst size in bytes */
@@ -2664,7 +2664,7 @@ static int sja1105_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 
 	new_mtu += VLAN_ETH_HLEN + ETH_FCS_LEN;
 
-	if (dsa_is_cpu_port(ds, port))
+	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
 		new_mtu += VLAN_HLEN;
 
 	policing = priv->static_config.tables[BLK_IDX_L2_POLICING].entries;
-- 
2.25.1

