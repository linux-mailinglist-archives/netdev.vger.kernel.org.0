Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C021A52FFA4
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 23:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346779AbiEUViJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 17:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346686AbiEUViE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 17:38:04 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4F6527F0
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 14:38:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYA8b0J0Ocm9yDJXgW5/aoOYXmcbniobmKw2xopwmYEMS1GZamqFwtEQCderiGKkQHAT8aCNOKqYe8i3KmsdpOXwqSMM/8jZoWQ3MitOMfnu2QvLhnGiMHNiBQgoIRBGQbZTXxkkoF7RnFhsDX18Y1rlO1E22sfBqDuK/i9PXTQLf6lL72KXsW2mAh55gI8atOH/S4uFaVnOgmRvKCqLp1fJOoriNo8wWNgmCkewbYHbLhUH5m5GLBbUOMSjhXPgkwhviHtzblM98DUDUR4WaekaEuEpHcSxoqROf+7cMdfsj6WreXvpX5w8Qt55xhFF0QzRDDdYjOb/yuRMt7KrgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9zT6ne/QRMR/gkZyrn2u+CqZkdgijeoRgil493fcCwU=;
 b=BToKY125FwdPadOV716lHKO4uUXHKTnYClgH4eSmyHkHD7DX+ZsxCi4KLLsBmkwk88KdOrLxPSCE1txL1y7uYQQNum3o3JPrN2kKNNSES6vuZE5BXYVtDFlOM3jBbCW4ewTLJJXkJYRJd3t33q88zzGKOr/2os3a7Sfy83XG8HHFu5RGeMgn7QzH/45/v2bmQc4jgLihy6WyHMlR57WAiBmO0AIuXY0BJL8LZtDDHVc+FuBjqMPAGb00JevWOx5vcD/ttmYZzW79p+cQjC3ROPW0Ei5sVMGbmkTcciPKuYnNFWI0sQ6u98mmfWnMcCrjed04tdM+qab1lylN2ub97g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zT6ne/QRMR/gkZyrn2u+CqZkdgijeoRgil493fcCwU=;
 b=so25qgMj+vrDocSfzCJDl4kciR8jY2SzimM4N2f7nBiYPby7RSp2z4sOgXykyUM0APeiiMtaMiwXQxYGoReRjaKTB/Y9QLENg95NXVLVkHWww7B4T/CkcEWgvb+ypshqGEEQwmDPPnX2H6E9tXe1Y2W6XyqN67mvm0er5bRNkEE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6275.eurprd04.prod.outlook.com (2603:10a6:208:147::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 21:38:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Sat, 21 May 2022
 21:38:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 2/6] net: dsa: felix: move the updating of PGID_CPU to the ocelot lib
Date:   Sun, 22 May 2022 00:37:39 +0300
Message-Id: <20220521213743.2735445-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
References: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0079.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 321eb2ca-c1c0-453f-a859-08da3b722d87
X-MS-TrafficTypeDiagnostic: AM0PR04MB6275:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6275C2781D6C754B6F763A1FE0D29@AM0PR04MB6275.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XkKzcc5rkb6PfbVutGDe/umu4q9H0wEQUJs2h9UmKq2TeeiI5Gs3uUDQzCJRDM5GerLLSt1b5VJRBjiJRP4J7PAjBF9tSQV80ZYRMRdv8UIkG06eY33tHodc2pIK4jX+WVQ4doGZmTD2dEO/7Aganew57GBB1S7i+A8rsCqSjVeMnc2cMLy6pzAGwkTIm2LFKRgen4bAzwUv9stfF7/HuD7NChKXZs7KtlPNaOkg578R1PIsctQdOu/NAz9JzsZdwRKr9YtJ876XQFf+d7csWovPMadmcMsUpxg4O8y8eK0Y/HDisV2KRch8igsObFkkLRSn2BkB6K5SqRoENEd345rYyv5WHXLhtPOi7As5xJNoaRu6m18jMll/7j4k9WpsfsKvclhF4MSRQQ/4fdaI0V7j6HJ2x90XqL9yXrEyrLR+7iF2oM6CpG4Sd9DOPHwVYzWmEBOUqD95/8Mt0RPRbWPcwkYrNTnwC3aR+7fO0Y38rNluoDtLAZyRkM5LMNZ4cJvDD0DH+SvZATPUunBTewaa1d0guyDsk5R5pp4yLhCr8YjqQlb69C2wRfSkBM2BblH1utKvpax9PnKNX3xXoYVFWHGpzc6I+cotbB9kiYYzO+2BQCuax2plQnDCROMkfSOYJvnuYRCR4632nr87idezixbuSFcl/GPTfmGh8Std/7agNmGYr7TQD487gI/XFf7jzNLGJCmZ/gWZHIkEyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(86362001)(26005)(6512007)(6506007)(52116002)(36756003)(2906002)(6486002)(8676002)(66946007)(4326008)(66476007)(66556008)(54906003)(44832011)(83380400001)(7416002)(2616005)(186003)(508600001)(38350700002)(8936002)(38100700002)(5660300002)(316002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WP/zHdY6XvI3VM92Gm1If6AJDImZbnXYTxLF36W1XH7Y33XUEw9yKVqW2sDM?=
 =?us-ascii?Q?7hTLqJKNelKtP4gjQU+SS+DkRHWKLzH9ZGawUrCMdzKNWihfYpk2GU8/SIzU?=
 =?us-ascii?Q?ghcXlQm3fswPMikYdtAqURX2175e0L26DBZib5pDAWj/gx9MOgoled1qPfcB?=
 =?us-ascii?Q?qJgzLSvKXKi4T2rS58hRQSom+JZxxcR/WPTHzw9nAzGajZweXGDF1TFd/TEJ?=
 =?us-ascii?Q?WWbEauurfSN8z7YVDFsv1Ls3Ce5SiYuN5VoPxeTy0zLUtJfCP554Is+Ri6F5?=
 =?us-ascii?Q?xvDekwjf3RYAnT5m1cC5qvXm66g1xteZEI6oUnv50lZ+lC2fgYHdUwDtVroh?=
 =?us-ascii?Q?F0kzkMPb+AVF8IoU9pg9J1g+asrNysugBsXGaOMHoqAUy486e9rOAx761Zwc?=
 =?us-ascii?Q?QpcVIFBal4rbpT0QFlQAucdPUpUwx2q7lFeerbE5ED5Qn867ib8Yrl09zz0u?=
 =?us-ascii?Q?v3157wy3MHPxeem6FhbCH/opMd8mdNNYRjzIVS2hN/mwld0xdZWqZwN5baQV?=
 =?us-ascii?Q?VHe35tAJ4Q239CDLsv0QZfeUiYW43KHdqzEZnZpgXwgwa2q8z4UZrrRCYJZl?=
 =?us-ascii?Q?U2Mv/Eyr+w9h0WACC/kaI3PuCX79pOroG9Z7w7SdteIFU+l+alcB9HRz4f2P?=
 =?us-ascii?Q?be2JEUn9+x84VKrA7T+nn5qEpFNWeUFlEBCiHRMnvTAH9JIn0oUaIIsQZfFl?=
 =?us-ascii?Q?Pw8hCo2qdmyIByywZiK4PKEUA3zdNdqCb1IxVyX/zWVR1u5bZOAfudkBV5Cw?=
 =?us-ascii?Q?yfFkDGndXjwLfM1wmu+aTwdsK+S5Ortb0O7lFJ/m1WV8GAqolEUF9dAC+Tr5?=
 =?us-ascii?Q?R7P20tClTPIqNJ/K/fHIJAKXzJ0/XMVwGTsB5ecOV73e8P4Dgp/5RQzwBH7Z?=
 =?us-ascii?Q?0jmXZ8vfKBoDhl+XJcJijAt5h7LEydDq+RTgovR4s2IMplHatZh4kRXhj04/?=
 =?us-ascii?Q?C6UxkWhaap0ZG4yMSBDTLv0bYYVZNbqLa7XMHhJMiOWo4C1ji2w4iV6HBRCP?=
 =?us-ascii?Q?pBtQEJ6r2n4L+WiyUuam8MTsRYaxE/w9UJPED/fr8j2pfUDxQ+SYl7KYhJb4?=
 =?us-ascii?Q?00gKyCfJv6FF8Uyua8vv8HFihMFNedRJOIAOX4wXEC55KjZMO70zsmeBc45o?=
 =?us-ascii?Q?DDiCDKHqPk7a+cLNVg5ieUgTnseUtLeKYJVYKsAlPTJpfPx6Kqj9MZc/rsUg?=
 =?us-ascii?Q?m/tw10pyH9Jav1bDlygxZizzdNrj+BwqkxkYhsjMNHp4D0BixXU0S0OKH+jE?=
 =?us-ascii?Q?zHMQIVTMkrCsMswNKLYQkYXtDtuvPgWO1MiDh9AjDCp4fLWdW11Ck1rNremg?=
 =?us-ascii?Q?Gd2A3u/dHRoNBmjKHvMND+zimT71vlFN/WVOOBhrFlztvddQbbSldBz9OQHr?=
 =?us-ascii?Q?xNM0a+ebLU/7eNlrRs1DoLzRJxAqBNn8Gtjqj/ViI+v1Z5WYmE8ljoVNcfiP?=
 =?us-ascii?Q?Hq5Bs0DiDiNo2UaTqA492061e9QDusQjFLC1U6bZfAA2gZqbI8Xz6YeAV9Vw?=
 =?us-ascii?Q?sXCuAcpDDij3okciVFin9giezIBHesfPVKoO18HOSlDTf0iKcCWY/zUhUGyI?=
 =?us-ascii?Q?kfcbDhMl+ErgDBs8z6mZSUhINI7TFm5LWRcVxY/Dk82cGrSuL4jmiiYoDKx6?=
 =?us-ascii?Q?vjPihlRWG5O+/1B6LdJnrNK9kunPZLWzui2E/wgysd2Sv7oAtUTxg4xp5vwu?=
 =?us-ascii?Q?RKWrjS/3JnQ67dmXJCAgGbf1PpL1BGQlBo6+l4n83w1YfHzMMo5l5a8xajfR?=
 =?us-ascii?Q?BhF1iU07JzZGz2yZPt0IWpDY/0Cqfo8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 321eb2ca-c1c0-453f-a859-08da3b722d87
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 21:38:00.4084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G8syNKZMFXrrGeSdMGKOj2wmvwxN5CCYGfmJ+LEFFQd8S1603w0UIcVzzOKGuGcEwrhfpZXy+b3ZX0XAugjbsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PGID_CPU must be updated every time a port is configured or unconfigured
as a tag_8021q CPU port. The ocelot switch lib already has a hook for
that operation, so move the updating of PGID_CPU to those hooks.

These bits are pretty specific to DSA, so normally I would keep them out
of the common switch lib, but when tag_8021q is in use, this has
implications upon the forwarding mask determined by
ocelot_apply_bridge_fwd_mask() and called extensively by the switch lib.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     |  7 -------
 drivers/net/ethernet/mscc/ocelot.c | 31 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 78c32b7de185..1299f6a8ac5b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -253,9 +253,6 @@ static void felix_8021q_cpu_port_init(struct ocelot *ocelot, int port)
 
 	ocelot_port_set_dsa_8021q_cpu(ocelot, port);
 
-	/* Overwrite PGID_CPU with the non-tagging port */
-	ocelot_write_rix(ocelot, BIT(port), ANA_PGID_PGID, PGID_CPU);
-
 	ocelot_apply_bridge_fwd_mask(ocelot, true);
 
 	mutex_unlock(&ocelot->fwd_domain_lock);
@@ -267,10 +264,6 @@ static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
 
 	ocelot_port_unset_dsa_8021q_cpu(ocelot, port);
 
-	/* Restore PGID_CPU */
-	ocelot_write_rix(ocelot, BIT(ocelot->num_phys_ports), ANA_PGID_PGID,
-			 PGID_CPU);
-
 	ocelot_apply_bridge_fwd_mask(ocelot, true);
 
 	mutex_unlock(&ocelot->fwd_domain_lock);
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e0d1d5b59981..ac9faf1923c5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2165,6 +2165,33 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining)
 }
 EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 
+/* Update PGID_CPU which is the destination port mask used for whitelisting
+ * unicast addresses filtered towards the host. In the normal and NPI modes,
+ * this points to the analyzer entry for the CPU port module, while in DSA
+ * tag_8021q mode, it is a bit mask of all active CPU ports.
+ * PGID_SRC will take care of forwarding a packet from one user port to
+ * no more than a single CPU port.
+ */
+static void ocelot_update_pgid_cpu(struct ocelot *ocelot)
+{
+	int pgid_cpu = 0;
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (!ocelot_port || !ocelot_port->is_dsa_8021q_cpu)
+			continue;
+
+		pgid_cpu |= BIT(port);
+	}
+
+	if (!pgid_cpu)
+		pgid_cpu = BIT(ocelot->num_phys_ports);
+
+	ocelot_write_rix(ocelot, pgid_cpu, ANA_PGID_PGID, PGID_CPU);
+}
+
 void ocelot_port_set_dsa_8021q_cpu(struct ocelot *ocelot, int port)
 {
 	u16 vid;
@@ -2173,6 +2200,8 @@ void ocelot_port_set_dsa_8021q_cpu(struct ocelot *ocelot, int port)
 
 	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
 		ocelot_vlan_member_add(ocelot, port, vid, true);
+
+	ocelot_update_pgid_cpu(ocelot);
 }
 EXPORT_SYMBOL_GPL(ocelot_port_set_dsa_8021q_cpu);
 
@@ -2184,6 +2213,8 @@ void ocelot_port_unset_dsa_8021q_cpu(struct ocelot *ocelot, int port)
 
 	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
 		ocelot_vlan_member_del(ocelot, port, vid);
+
+	ocelot_update_pgid_cpu(ocelot);
 }
 EXPORT_SYMBOL_GPL(ocelot_port_unset_dsa_8021q_cpu);
 
-- 
2.25.1

