Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69383279B65
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbgIZRbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:31:38 -0400
Received: from mail-eopbgr50080.outbound.protection.outlook.com ([40.107.5.80]:18948
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729493AbgIZRbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:31:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rg+85P7qbL/fitGTYd6NK6umUi2sNYThEgr9qOsMPoT8ivhlLu0LYHpL9ou1SDXh1uuF3LIoIaU+btWpnymqSWivqOYMiy4z5Yjj8t1MFsY6FSNjIpe3+WTLPNq21E6LoL0O/dWXfI+ILvMyM+etI76FZtUYW1K+MQNx1b2BMLUwUed/1trUtPk8zJT7RApNF/P/Qymwd2FLpouYK9Eu5OrCvnAHKFQkYLSUf6SBFMlj6gOgsjHFUg1cfIuIyUsXOnHlcl3Z0EKPGV3yzOI77/HWulloW+KbMSxVOAfkL180Q4bRMzpjvEbjUck4kD+wyQKHbmQ/jSeaDplh5qZw4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zzc47IL8QPQWLYhygEyc+QXUeZRjGTVVoFNzLTegyfE=;
 b=LktsssroudYP11AWts2/mYyibVzmN7Kja1P5zNY30++yfyRCFfvBennN+qdy7rSE4znj+bh5qApkP+otEbtKgNhk7vqImlq1g0N1xO9TPfdtAendJ1tak6k8q43o4F2uVzBVZSvz6s2jLFhsspxMH7/BywVa/U/nh13mdzdNlwTrVrCDPgl1EQGdMkbfOwcmeXRlKu6XCJrtMIaSWGuQ99XLDrg/3Lty8bav1tNkK7WAUc/Bd8Kis7p01mUhD0NfpAQ5C7iv+XqpLbpBepA87qUGdya6QBDIYffRQDmKInZ+Lk6xH4Q49tXvW4KskV3n7nGaRSNL0amkd6qFsVKH3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zzc47IL8QPQWLYhygEyc+QXUeZRjGTVVoFNzLTegyfE=;
 b=JH2s+JOTMcjamFcoVSOaWUmegkY7WSg00tLL5p68j/Nc3bi17fJq5q9D66ydkPwM08nO9BmOzAPTXCz4IDtToHX2c3dBgbPLx2iMl3XNV0EzcUdnZ5QtZAE299iPA4zz6A2O+oSL8aALUKBWLq3t/HODDI1yCb0BAO1X/+RdlpI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:26 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 06/16] net: dsa: add a generic procedure for the flow dissector
Date:   Sat, 26 Sep 2020 20:30:58 +0300
Message-Id: <20200926173108.1230014-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0095.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::36) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:25 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d5b479dd-932a-458f-0371-08d86241fece
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:
X-Microsoft-Antispam-PRVS: <VI1PR04MB48132DA647CBCC933B720420E0370@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tLq3qOJxiR01b6EC9Ef4RbrzJJst5UUqr4z8DpEo3mDAIYMrkzqiraYctEEihSBb+RnO3Ttw0W37jvgoiRfSqmacAnyfIoWyKxdFUy3R2Jkm5sijDCuG9bbEUA28ji7vRJoGHLRsOZEfG3b+CsUmVOn4G+bIbetpTLBklNyYDg6B/fzYkFngsxiELQS1asCCAIJjpILvMSA2QRK747k7ZyPi5YIqu1EP32jlC40ZwLNGsxET0DgLNXA7/5h3+p4gKXXi65THdeskQ877kxTZxmUImP8VvP6L66afB9nTynsJF+TsSL1Re/x5b8ZplwR5rgbB0vUngASojybgmPD6PMQFyErq7es8rMii+uJH0ynLeMaY9Cqei1LdE3gkt8KINXXH/fX0ZmZ9OzLjk4yncasFupfFWi/HtB3gIFFeCyXvnvGe7G6zLkTou+WlbioBrkt2KCkCWjtARBFfeDRa9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(6666004)(316002)(2906002)(6512007)(956004)(26005)(6486002)(2616005)(478600001)(8676002)(52116002)(83380400001)(8936002)(5660300002)(4326008)(86362001)(44832011)(6506007)(69590400008)(66476007)(66946007)(66556008)(1076003)(16526019)(36756003)(186003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CucQ5ZhExmDD2BEvU1sruCy6tkxikxmAd6LHXClECitIcdPcrJHxUyfjKiu+iXoElqzjLfkvy1+Z/jW1Mz2+f28zpmc8FlLLqJmuzzjwYm3RmmvjV1nApW2fP7rWPlsrPEIYblQsFOo3j7f+0tViqTi3FgHqXHCTKT3H9GXrk5UcvOksB3Gp/yAyrXQ3WGVGCV4CbrtgWv3MQeRIfmxIDcIvHf/3DzfJoibHn+jAyz2C9z27Tv+D1bQTtdjVLfp1kOtwdcVTIAn/tdyxmvHMj98ss5397QJtnbS1gU9BfEWT+VXkqhY9EvnF6eeSMhalFJnt0NxLBCZHQ3S7NVLPJcPHmNrz9ivDEw5/YJQa7LxHQj3mNyXIfRqwVbcPSObELMyL/ZtIHguJOqlIGaaYAT+Ff76SN+yDZKjhkq3fb3Hn0nmNsEL1PA7PshIow0tM2dcCbhO0wPbX2RHLjJhBlu0LGvduGgj0W8BXmaUlcX4ZUO4JEF2tyOZrYEnGX0QyedvH/Qf9KUTsYrWta5WF1SzEawHNun4H1klLv81UFdonTfxQOhTtWilDJJzGF+yJD33M2Ov2GLiUdTDN1SMb0ADNdrI2yjssfQgM2oXtzA6ZJhrws5a2NH8cFNsBrNFONHRYw2VZUrbtI4Qnng+56g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b479dd-932a-458f-0371-08d86241fece
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:26.2104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R4FKFicyNqyT7UY2jZOMIm/k7c3J8GKIbdbLkhGV5v8iKA3fOKjOpX2GJ4DFAkrx82hBDIjqVzTp0ORQItkpBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For all DSA formats that don't use tail tags, it looks like behind the
obscure number crunching they're all doing the same thing: locating the
real EtherType behind the DSA tag. Nonetheless, this is not immediately
obvious, so create a generic helper for those DSA taggers that put the
header before the EtherType.

Another assumption for the generic function is that the DSA tags are of
equal length on RX and on TX. Prior to the previous patch, this was not
true for ocelot and for gswip. The problem was resolved for ocelot, but
for gswip it still remains, so that can't use this helper yet.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa.c      | 25 +++++++++++++++++++++++++
 net/dsa/dsa_priv.h |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 5c18c0214aac..aa925eac7888 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -305,6 +305,31 @@ bool dsa_schedule_work(struct work_struct *work)
 	return queue_work(dsa_owq, work);
 }
 
+/* All DSA tags that push the EtherType to the right (basically all except tail
+ * tags, which don't break dissection) can be treated the same from the
+ * perspective of the flow dissector.
+ *
+ * We need to return:
+ *  - offset: the (B - A) difference between:
+ *    A. the position of the real EtherType and
+ *    B. the current skb->data (aka ETH_HLEN bytes into the frame, aka 2 bytes
+ *       after the normal EtherType was supposed to be)
+ *    The offset in bytes is exactly equal to the tagger overhead (and half of
+ *    that, in __be16 shorts).
+ *
+ *  - proto: the value of the real EtherType.
+ */
+void dsa_tag_generic_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				  int *offset)
+{
+	const struct dsa_device_ops *ops = skb->dev->dsa_ptr->tag_ops;
+	int tag_len = ops->overhead;
+
+	*offset = tag_len;
+	*proto = ((__be16 *)skb->data)[(tag_len / 2) - 1];
+}
+EXPORT_SYMBOL(dsa_tag_generic_flow_dissect);
+
 static ATOMIC_NOTIFIER_HEAD(dsa_notif_chain);
 
 int register_dsa_notifier(struct notifier_block *nb)
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 0348dbab4131..61120145679d 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -99,6 +99,8 @@ void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 
 bool dsa_schedule_work(struct work_struct *work);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
+void dsa_tag_generic_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				  int *offset);
 
 int dsa_legacy_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 		       struct net_device *dev,
-- 
2.25.1

