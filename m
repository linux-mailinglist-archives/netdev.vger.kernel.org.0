Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D33046F785
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbhLIXi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:38:58 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:21854
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234467AbhLIXiz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 18:38:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hg16tLwIM8J3tWcPHaE5vTHVdljSGJUe1qvMd+C855GCASqLdWijgYuxBhk+c7vwt5uLzu98e69iHw8wTFZVvpFmPE3ex7eYOi5ABKZaCUIbO45NB8kmvjUdvWPGC0UzWtibixwX2TpG89rYwpB1wr5/2AfzacGHzSwOKQoL8BVVcP0lgCO0MWXMUnRLHnTdIjih/C3ZQHcTT1FLFczxCnaeqEb8P5Y3PiG38izlMa8nPMTC2NLkhNuMovl2QR53QoydscGLy/Ved2hjGiHU9PwSwLD4IYr+hNxwZta1xfa+51alcvitnIMfpeiEOA5nGwANJLIeP4FonKWeJFK6Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTEXxwp3992ahCYR1n6KekFAKiLniZNX+oMnUMuCgXE=;
 b=N2SYbeBRm2azDyir0qtU7o8U0h3kslsvxz4bhRXY8DAOSAoldMOc0mhBBwhPhRreFc1zHXDGNvhkboTl8zTV7ras+6L7BVuORWK0KonLXW65rly7EfTpwDh4g8AzQBpvSRb0Y/d27K95WUPYIHcY/S+RmxdeJwTAp+tzh9jKB9Tqmr9Gwpwhnzw4o3PQCm8qlqMPkmXJ9oewSabjg6kdOJ48EIlao8E/KNJGlJrBO0p0ybo+grWCiCGeNLiSH0JI1wyB7NKA8NBqX47BJM/htOb39HDEe2s01T1h8VBDShwjO+E5VaBWxbkRI8K/VbRPdmRDEGjgzhhCs9XKbyJBfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTEXxwp3992ahCYR1n6KekFAKiLniZNX+oMnUMuCgXE=;
 b=SaqgXLEBkV0p8bzn7kPzNdzuS+Uidg2q4W8m+rT+DGQQq4m8cCWA+lYJAOZRD6HsYW5OKBAH4EEio11ifXimUpKGIURyEDYkmWb0ktmsCunefPbUuX7LfrG0nktBqhGeZy8m8UN9x8AZ5+P3yJR4I//57Ms1yBdxaW96JOd1rH8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 23:35:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 23:35:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v2 net-next 07/11] net: dsa: sja1105: move ts_id from sja1105_tagger_data
Date:   Fri, 10 Dec 2021 01:34:43 +0200
Message-Id: <20211209233447.336331-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209233447.336331-1-vladimir.oltean@nxp.com>
References: <20211209233447.336331-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 23:35:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 532a9fd8-ff2f-4ecb-9e5d-08d9bb6c8e06
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408C36C185CF371DE8EBEA6E0709@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4rjGCykRy3+W3WJmtC0NzeJZruwVlHwk6EbvXv9Ykxh+scrsJeRI0h6zqa1XhkwK+XDkiN41wgyW7vgDbUBLi0RdTmH3/C78KjdlJapv/6jKR/xKEtTh7g60bRJOORaoO4kWHIuP0Vd4M9aW97taM2V4UK8dV9Gp4f00AbBaTB1RJbOaVtmsPpc6F1kwT/1pUJgSrORAkhWLLh5NrmirNMWSoqBO6DxYcMT/Mx3npEPLWAFE7vfMkoTwB65CNUZglkH5a+75mk/qEuCYTxC6uPg4mziH9vSnvEdW66Z2hpUR7Tgu7TnYWkLv1mRZmU62h7UF1w3OcEaL7BffrobxYgErJu0TiwOyyCtxD2tZ78ZnIVjq6jZ95ER1XuRCd1f1KitqOv/oCuEaLA+njjbfyhEP+Jmtp2rc8R9VAT1vOb1Ct25KJixboLLWn9JX4lWor68MwvkHqpHn6UpgmaGfs1ytiGCt7VV/DPGqBb0bJGW2wjzvq38lQZPyAJrIL2Cd2kymmHd4zurov2OIr6Iw0KLHtBe3AyOJ7em+fOVGvYJQ7UQXlVxRmjEbXGlI1XIxbvn2oX6C9pWe0aw0pwpKXDgNeZW7Nry8ZMy3vvzwtOt0V2wwV4TqezYMbacaAa3UVgomm+JnHMAtL4vTXGEKED9/Ylk8pyGFa3g16FjmVpYP4fIldA4HKwFx+tVFkQa2WRg0sFyHz9is9LWKy49p6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(83380400001)(66946007)(6506007)(66476007)(1076003)(44832011)(86362001)(6666004)(7416002)(2616005)(36756003)(956004)(38350700002)(6916009)(26005)(5660300002)(186003)(38100700002)(4326008)(8676002)(8936002)(52116002)(54906003)(66556008)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Im38RbDhzbhma2eFF6/YgUIZXba0SnG5KV8jAODZrcCXk+Qne4Ws1KxauJQj?=
 =?us-ascii?Q?Uf9D+zwKXA8l3mE3a8XzqydAsAFrf8Jqie8J+M9SfJxD7Bzk4KJW6FyGdXaE?=
 =?us-ascii?Q?AIsx+io32+QyL9L7qRtZwoSz7dLgWuVBarIY40Rb8HAQoJ07tcTf3d37GPjy?=
 =?us-ascii?Q?0CqnNdxR0IwuC2RvUupI0biLXKPo3H94b8tJGzniPDgTywoBuUFStx2bW+ZZ?=
 =?us-ascii?Q?JUjPV/ZxoE6OOaNeR8yHWBwZPwXGM6jg7G7h/x2pU8xCfNd3zzXV3dDginFM?=
 =?us-ascii?Q?6iu84NheFFDMhrGkArIDEOXRoxDyqSjO5NCbeCbijVDJV+a49weZXF77P7WV?=
 =?us-ascii?Q?EghWf6tpRo/ifw0zYvvg8mWcl5qploIVyEFy3fgaCirLs8BFO/7pD8VSADFK?=
 =?us-ascii?Q?ruREuF+FlyqN/peu1xMSVHFkw6sp6smj+UlHqDsrfbMjh22XjARswBf7etkG?=
 =?us-ascii?Q?RtzkZFlxlAAtPG7aTOSAQEFE7dBOECq0rIYkQ63Hr1KQ4QJDm5d72nlu9g2Z?=
 =?us-ascii?Q?kpSjwXVW15s+5toSrkVmqXnRSURAtifE7LJBq8NBY6A+2XkqpebyvSDDPJGe?=
 =?us-ascii?Q?V0KUGhT/vZze7+vi8Yrvt001JK9LXE2uQQLhLwYY2LwT6AvqwV55QUZQZB9g?=
 =?us-ascii?Q?3D/rUCxtMu7kEAVe6KUCYBZ7JFUvlSPpdum01U8MhimqA0BKIwQ0tmf2EkWk?=
 =?us-ascii?Q?QMbzDKoaLye/n7RMI8Ka/2h2lMTUt7QITcg+oysaAzEYhz2/qe4KkxdwvLeS?=
 =?us-ascii?Q?/sJss7y/fWNMqXMq3KZcEEz115Tq+JDPH0Mvnf6rZCzp/L+91kKZLg1gaSKa?=
 =?us-ascii?Q?F6zJBihNc4SA0GIQIsUMZ+7DeoClKs+RU8vpnQaFP8HV/WZAY25RjqqU4gSk?=
 =?us-ascii?Q?W3Rx/AOBbbaAuIM4ie1vkHTdBC5KL+8oNtV7KYnVVhR40tQcPgdsCqeeTLoV?=
 =?us-ascii?Q?JfskYCCIJG1zZC84jG+lyM5yqO0mYHVxkzfY6SUV6V6suAqUmuKG9QHfuVsv?=
 =?us-ascii?Q?e7NTauZsgExvDxyHl/s3IIKwiTKQWhtm3/nogbi8J8hHi1fhuLLwI9id9Cia?=
 =?us-ascii?Q?sGFFRBIPYa3Mu9haQc4WDiG8TQXxxSQJRHSoAPKFcbx1plt/BrHbiNaY1DlD?=
 =?us-ascii?Q?bHQzJEUErlwKYh4uZPLBmXm3TWehgf9HW2AdK/V+1gPmL8rsKKIgR3feovOZ?=
 =?us-ascii?Q?2aYaqxbeLfw8zIGyWyYzfNApL6BmUQCrNNOf6gY/yKxmOWUWej6DDfLK6sbB?=
 =?us-ascii?Q?zSXYJdazr3SU7JiuWsMY/gSsigSyjBmNQ4tfxcDGFIfA5kGN68G/if5TKQlb?=
 =?us-ascii?Q?rn3i0ya7BYdkPdSE9HaiGh1cf8JtHZLG+ygairCpOuHimdw1aXaCbFwFJNXV?=
 =?us-ascii?Q?zFH660YLPVICXgTM11bk3RhnANhJb7BH+CERubEwQYeCW3VBFmjfY99SEQnw?=
 =?us-ascii?Q?9xxp7tDB82L0xm7n1eG8qL9iyAtgKn1xSb2etersShp0Jej91j5w8mTTmk2L?=
 =?us-ascii?Q?r0U3ThNZbGVUhG+RES8PwubAWGhxBlB0Q24Hd+L6PRyfMkw12bDig8OWN8p+?=
 =?us-ascii?Q?5btWFvZ337sqeOw/oEX/Ql24Cb01DwAIAEs4D0erKteF0MdwOzCmgbZOLBhk?=
 =?us-ascii?Q?VRNAb5C5C6BTzOSZhZkQX/M=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 532a9fd8-ff2f-4ecb-9e5d-08d9bb6c8e06
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 23:35:16.5014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbuKsekNQ1HCu3GIpXewpOr419z8efHuuumnoARXPJ+5kiXdSUB/iK1eRF0plKINC00y/PI/V6tFTw1I3rUTpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TX timestamp ID is incremented by the SJA1110 PTP timestamping
callback (->port_tx_timestamp) for every packet, when cloning it.
It isn't used by the tagger at all, even though it sits inside the
struct sja1105_tagger_data.

Also, serialization to this structure is currently done through
tagger_data->meta_lock, which is a cheap hack because the meta_lock
isn't used for anything else on SJA1110 (sja1105_rcv_meta_state_machine
isn't called).

This change moves ts_id from sja1105_tagger_data to sja1105_private and
introduces a dedicated spinlock for it, also in sja1105_private.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      | 3 +++
 drivers/net/dsa/sja1105/sja1105_main.c | 1 +
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 8 ++++----
 include/linux/dsa/sja1105.h            | 1 -
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 6ef6fb4f30e6..850a7d3e69bb 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -261,6 +261,9 @@ struct sja1105_private {
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
+	/* PTP two-step TX timestamp ID, and its serialization lock */
+	spinlock_t ts_id_lock;
+	u8 ts_id;
 	/* Serializes access to the dynamic config interface */
 	struct mutex dynamic_config_lock;
 	struct devlink_region **regions;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index e7a6cc7f681c..880f28ea184f 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3348,6 +3348,7 @@ static int sja1105_probe(struct spi_device *spi)
 	mutex_init(&priv->ptp_data.lock);
 	mutex_init(&priv->dynamic_config_lock);
 	mutex_init(&priv->mgmt_lock);
+	spin_lock_init(&priv->ts_id_lock);
 
 	rc = sja1105_parse_dt(priv);
 	if (rc < 0) {
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 9077067328c2..0904ab10bd2f 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -468,15 +468,15 @@ void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 
 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
-	spin_lock(&tagger_data->meta_lock);
+	spin_lock(&priv->ts_id_lock);
 
-	ts_id = tagger_data->ts_id;
+	ts_id = priv->ts_id;
 	/* Deal automatically with 8-bit wraparound */
-	tagger_data->ts_id++;
+	priv->ts_id++;
 
 	SJA1105_SKB_CB(clone)->ts_id = ts_id;
 
-	spin_unlock(&tagger_data->meta_lock);
+	spin_unlock(&priv->ts_id_lock);
 
 	skb_queue_tail(&tagger_data->skb_txtstamp_queue, clone);
 }
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 1dda9cce85d9..d8ee53085c09 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -51,7 +51,6 @@ struct sja1105_tagger_data {
 	 */
 	spinlock_t meta_lock;
 	unsigned long state;
-	u8 ts_id;
 	/* Used on SJA1110 where meta frames are generated only for
 	 * 2-step TX timestamps
 	 */
-- 
2.25.1

