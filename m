Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB4C279C2F
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgIZTdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:39 -0400
Received: from mail-eopbgr130041.outbound.protection.outlook.com ([40.107.13.41]:63047
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730240AbgIZTdc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SM5FVlVXGGCDoOm/s21d3Ik9oI7wTflgrciEHzzjiAoaDoHpBe1a/hilvHrRw3gzBi+2g7w/ITehMcXH1UvevlcGn/+eWPnkWsMIt4D/VDOEsY8Ql9whUOuqZmLDM8iaZPh/bFKv/gxxjpOGHBZ+ztjwq30LJkiHLnA2QOpRkbwB7J4eKVs+KEWHH/1Ag+5500mGswfb3yi2e7Dja859Srlpw541n/MwOaaDGXgYHeyzmPtg6YUTiEBX+xUjE9d3Rhmb759TH7z/65xSTSFm/ERqINXxQzqyNUMRPrIPiRXNLsV4IWgg1zOlqsFoO4SePspVWIPySwp+rsuOj0NVVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsSEC2QldRrUBCVYkOpsBQuCNSOezYoEozNjExhbPAQ=;
 b=LyA1v3D3L7cHZJmQ3yAO+VBpZgy/E95HaTX3W64aYw2hNvkbHAbJKpwA5JgQJzqKoK5yCo0GpsOST9KsE4XwZSUyeXKSSEGYSpk/fBqbNlOffWFiZjFtqMFV7O3qYSQ+P/aiTWXc2rbaRcF1oh8mdCU5M9HnotcNB5IJytKpWodTVwkLqgOw2IT+NfYmTNtZJ5yEhmrkp2AtqhaQ0HNCrtm7cvjyrzAWTQ5MDRAoGksuuBDRnLwRUsYo+qHgDwgnX11LIOuPnoyhJvvrUef6O921bJmlqVEoMcbwF1K/faAq7vdqRKRxfzqvN1ACeB1BnDJkVz6KeRUxW79bYqYnmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsSEC2QldRrUBCVYkOpsBQuCNSOezYoEozNjExhbPAQ=;
 b=ord4+P69U5i9OGumJED/q8poPl08pMKc8aVMiisSK9TX2O1FSum/wcvZQH+fdd/bsKH0s1MvTnZE1koJXGQxaxDnKe70CM+H72mR/sNpLBj21lxruHZQj5pSiVfALReScSoUQzYyk1c8/68K+u51fQNrjN7sAV9JFRcS52Rhlfs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:11 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, John Crispin <john@phrozen.org>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v3 net-next 13/15] net: dsa: tag_qca: use the generic flow dissector procedure
Date:   Sat, 26 Sep 2020 22:32:13 +0300
Message-Id: <20200926193215.1405730-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::27) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:33:10 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b958a43b-a951-4f76-e801-08d86253012c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB529594835466AE3CE57FB7A4E0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IC3QQXt2LBJD+wc50PSBbZxMDKXFs9HncGIYwE+f1bBkR9Drg04c1XV4nV4eSv5djyWh4CMZYXlM4Oaiznux8Yf2kQ0HGgkLeY9FWx+ujCK2gyIKUGOUsn8a3snoie53IS0+ygHu8r8TB5muY+w4YX4pJ3hieZwTHV86WZlnsHO6SA/xbAqByUCZQwDC+fZxcMFvDLmMwUptp9qfaZLjS+Onj6VIy2nC74I1m5YTUkVRMBtIV5/SRuVQ4JmjSqi8YtvnKgHSI3Kd7rK7y9Ek9dul4I26+mIqBz2hpKuXKe9O9/XEC2cDEFmekThv5b9Zlrn9vzM0uKASi5rjuZydfZGSrsfCJpLJ6x2tyF3T4MSjXP31D4KNVM5LlLLWJHTqtyhzdlXjZ0RgAhR+rwC+AeU6FKcYjH/o7mm62b1HA5xaY3pcGOgIcDSUsX9Try2Nm/ah97UCZQBSzJCgZTLfjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(83380400001)(54906003)(4326008)(69590400008)(66946007)(316002)(5660300002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: m4s+VE9ep7skpWPgDVaBT7DARmd++Tzi7g+A0kGRl5T3lcujQio8CkSnOZE8tUO2Eewix7KY35kHOVU4qcXPLxNJla7mHsXzAtFVbUdH1/Bpk28yLgsDN8vH8ocPg/QyHPDLVJqLQn4R9fswoelNvSs67AvyrRBfSF+S/nUSGyhf+yPV5/Sliqd/N7XctsTjItH6Y1pzlJOmBQfDftLcFGuQs3pbdxX3G7B+DP9z+0+vAZtTjdsNdeP36rx41xU525auc+d+cY9xC6Yy5qpy1hK1d8T3xWapp5gnmggIVMYAzvpsBhn3Yq3qjCUUcI268ZCUJIxqrom3VnIaZ0K+BckKuUBThryuoEwS7cC7jK3uU+Ydt4gdUL98CiB41PKcXnKvUZfjjaeveWPSv9HrFWFrh+HHZIqqVxJP2Z/pRKSc+604PzowdSXHFhUxnD+Kb7TEsMc86BL0WIX8QrS3JNN5S4HQ5DUIivsPZsoNL09s0qE0b9U41CLN4MpwwHF1oPErypOL6nRLgy3ugULuwxcZiNutfAAVep8TPdFq5LWhGst1IUidrhZjWfN2tiO9GWnIL4Hzkx1Ct0CmxIY8nrFgeFEaaWBw4jmNrG446f4S2GHKL0wwY4s9rJwP0yvutnbNPxq/iQek8AUCPm3niw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b958a43b-a951-4f76-e801-08d86253012c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:11.6501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TQn40lVFjtnp+29nSU+KQMC+NORvnTGBSzk3mSAwhYwXaFrTaBC2SJgclh8028rVmQIbMBvmN7bRdjBsHPHB6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the .flow_dissect procedure, so the flow dissector will call the
generic variant which works for this tagging protocol.

Cc: John Crispin <john@phrozen.org>
Cc: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Remove the .flow_dissect callback altogether.
Actually copy the people from cc to the patch.

 net/dsa/tag_qca.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index a75c6b20c215..1b9e8507112b 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -89,19 +89,11 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static void qca_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				 int *offset)
-{
-	*offset = QCA_HDR_LEN;
-	*proto = ((__be16 *)skb->data)[0];
-}
-
 static const struct dsa_device_ops qca_netdev_ops = {
 	.name	= "qca",
 	.proto	= DSA_TAG_PROTO_QCA,
 	.xmit	= qca_tag_xmit,
 	.rcv	= qca_tag_rcv,
-	.flow_dissect = qca_tag_flow_dissect,
 	.overhead = QCA_HDR_LEN,
 };
 
-- 
2.25.1

