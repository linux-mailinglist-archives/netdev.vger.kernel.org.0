Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979002A20FA
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgKATRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:17:09 -0500
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:47874
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726790AbgKATRG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:17:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBurz5peJFLSdqoJOFnzaEIpDfUkKdGTencuQlBKHUrAHv0tJ8ny2cGCx3eg9rHXCfw777duzUy2ZKyo0CSX/+P8ytc2Nuy3Ut1Z9ZakYK9Ux7CzUoVa9q8e1hG5OEv3hIkCjfudwUkaZfE3jj3k6wR8xjTEaXpxrtadpWWlZG40GXIXscFBfXLkWGqIF/+uoLqGLwNNT5ZWeOcEl8KdcxVq0hqa0w0FWHxqeglZ6NpKptMIJRkumcp6GsRJg6Pgw0xWGMweV+GUssKRbaIP/2i0Rej+5T8UBSHdNxWG8KB1ww9N4bW9e6LjIbmAMRevTNAbIGRX9Wdt4U0tBr6ToQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1np9QKJfTh/Mo6c3ThjKuVrhfSQqsYmPFnHOOZHEGSo=;
 b=GNBj2+ZwyGMzXs/duSnWo3/qfYozD9uYSJRk2qorkXMvPhA/vOghwFFch1WAi2q0p9v5naM1RoRbAExkAFNDEHmOgLdB4lnLDoR4HfLEarUfmaet/r6/lqgkZ3cIfGBpFdmGRVrlpHQ9h6EC4qgmIXQcAn+C4MFsN/kjP6Stpebr4OU3rbAmgDvAOkO9qE/FPlbfWJ3oTfp7ihJqmXpuJQszBEfv6JJbvRbz9XOFZ3si/+SG8Z54dTm95GAIanOB82Qk93thNjVKRDP8EaOQlcmryyY7q4bNngVODHTzBsm0fNCL/lAbeCs6iwtQB/EJ4jIVDaWrgrAQ9R2OWHA9lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1np9QKJfTh/Mo6c3ThjKuVrhfSQqsYmPFnHOOZHEGSo=;
 b=rk9q07gRo9NcNkiwSa0pU3kV6QzBgZqKGFAWki/y7nOkx/ooGTDImXAbyiT8hpqE8fiUhin1c1QA69+6rwWH2hl0SR86/kAC3gw08GPC9OodQTB39ubVH3/BtzqpxmbZi/ys+TwldiB7LkfDlJKCgRiUNGm5nhQK7/PJwr0mALc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 19:16:55 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sun, 1 Nov 2020
 19:16:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 net-next 05/12] net: dsa: tag_ocelot: let DSA core deal with TX reallocation
Date:   Sun,  1 Nov 2020 21:16:13 +0200
Message-Id: <20201101191620.589272-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201101191620.589272-1-vladimir.oltean@nxp.com>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR0401CA0001.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::11) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR0401CA0001.eurprd04.prod.outlook.com (2603:10a6:800:4a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sun, 1 Nov 2020 19:16:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 03084932-36ab-43d9-bfb4-08d87e9ab25b
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28617F0957B6E399557C96FAE0130@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ky5UZiZAQwyovIUldEQVyin+K/17EkJnpF/ZaM3XkeYu7O8eKtQxkGNsgzbKQbnSMxfeZtMJ5vOwhVDQvJ5KSpH3rPIkrBYovZtXiwEs1kdjMBTHHb1/EFbv2ocfeQXe+1UTZQCyXk+6nfMLpmtlZ7w9FidLGcsTztN53OT3ONKeJ8lbwDxRuJvBKpCi1lHjSmLE10m5jRn8sef4XzEtIKGYUUarQ+LtA4+WYzUbZt3wl+soHGZRjrvJxCpfo6fuJe7jqeFVNTPdOp/sTMcJtIRWIa9UhYhoRCa2fvn5mIudKL3rUBVw5MS1P2AZxTYF2XesBrubie5qz40uc2yRuYyPvnRBuT62MAJLvdvWPJ0ppUZ4ynzPscvx35HcPINF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(2906002)(8936002)(16526019)(6916009)(186003)(6506007)(86362001)(2616005)(4744005)(8676002)(26005)(36756003)(66556008)(956004)(66946007)(5660300002)(478600001)(66476007)(6486002)(6666004)(52116002)(6512007)(4326008)(1076003)(83380400001)(44832011)(69590400008)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Q6TCmVxNu6ScuN3+x7h5ewxBtQzfREdgrnMZSXFNgIILzl+cT0MfH+u39fJ5recwHd74tdS3VDumj5IQ5nXEAIEmgP+bUrLX9h/GMY0JbMcpYLYZ2VniKHvvnlBkLrAPJUY4C37W865Ur1ee31jqyJA3gGIWGSzS6peXPqD9+t6tewkBqxu6i8LnHY8B0GKxx57NBxfBMMKxRslzLedlxm3O66IErqyah08kp4hFVbVBT/DPn4J8dRddJlLjoBBsruUCGO1SdonXacPNagnLxMLevvrWNYfz5ur7exSZ23EecRHbCx7pmTkJzKMCvudhzVzp6rTnoG/6w/sS+psSPAGvt+p9oMsNE7OxKRwAmP7R9E1nwxWEQ6VLl1baCGxc1lOBVoW0QT2WIhl8lFs07B0RED4umxbvD4hHfg7dJOA9jZd98O37DIS7cCG4cjj52DNqiUvuM0vnCvinFRCVzW6cx3/x1CGXLMk1uSRyiYXUJjfhYrIuXjphDKT4lkN10jwq8lAwvXW8DJvzaOvaA7Y+pIiMAFI0yFTlAfK7Q3QjOCLtp4vmV+z6t1Iprp+lCkAh4eSlXb04X+KIu/j8/uY/K+2/ZsmujpihyFE76mhj428dY7T9GTKZqtTY5hk0Rtas4lo/8HmJzfR7ZwCJYQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03084932-36ab-43d9-bfb4-08d87e9ab25b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2020 19:16:55.6874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1JUg+P8Or9551mcNt7N4Bcm5rc6m5BPLz744t8q8Vi0PUvEmL5lmTxV7sv3L1Lvby60imFkbVAuhWWRiJhSBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 net/dsa/tag_ocelot.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 3b468aca5c53..16a1afd5b8e1 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -143,13 +143,6 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	struct ocelot_port *ocelot_port;
 	u8 *prefix, *injection;
 	u64 qos_class, rew_op;
-	int err;
-
-	err = skb_cow_head(skb, OCELOT_TOTAL_TAG_LEN);
-	if (unlikely(err < 0)) {
-		netdev_err(netdev, "Cannot make room for tag.\n");
-		return NULL;
-	}
 
 	ocelot_port = ocelot->ports[dp->index];
 
-- 
2.25.1

