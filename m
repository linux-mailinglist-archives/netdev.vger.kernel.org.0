Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F0829FAC4
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgJ3Bt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:49:58 -0400
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:30883
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726195AbgJ3Btz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:49:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NO9G/YezJzSAoJRKi3ckolNZOokUf6q3ZAkNztSqr3ZW5MRUmGXYzfueHE8IM/LJAZfiFIBxZ9VbFJQJgET1lNbSnoBeKY0Gt2fqWFjh4658CXDZu2HTzttxwrc9azVMsw0msimy5t7J+wMDoTR+t0iv1d/vCMSPg5KuuefQKsT4cR0voURw5ipAbA3SMA/zhFfuzFaTKd8M7cLZH0FR9oO3+g7VjgPLYA6fjweNeNVO+SpKPLrYXlco8Ho5UqmTRZnYpaunkt30SE5yQc9FiE1hx/Rnwn4+tOi4EHkCv6yKh7YgC/U3rs1djc6cz4K54EZj8zCFn/JaLspqXJ2oFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kCSsNzUEkBL+c+qQtRHxNY32cQhLeaMAAh6GnFxw+E=;
 b=msAKwJzO9waip0SVLXpva2v4knO/0bjXBeWkYNFfO53i90g6oB/YnqRyBKBd7g5BSc9JfoY4FoO+qFdtIRQ7c5ZhjVIidlSf8K8GRwpoy1nLdJs6n+tdsVo3fMzJ/ZrjREk3vnBN0wXAqbz5OJeEaQMQu/hMXzXSkUXXJHCn/V7UEH0vrulIkTHyGjCcaKTaPkOsD9Z9uFjv12QbKEHnqCUzUVrCjjDK8dfNKy1oOEdH1H6KKMiJMyta82JtYzzfLTccftmingT+1GkWKLB5J4JplbzZq/isVBrevTFMhrxuhqMQAbrNTAuZGHhM4MYhlxD69RtszVyKlAEig1ghSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kCSsNzUEkBL+c+qQtRHxNY32cQhLeaMAAh6GnFxw+E=;
 b=cMBcJbI6PNOQaF6DbT0l5wUOQYxQdrkh5RGRJNymjZE5ue+S7zUphRzLKlrxMa+bveWLeibddShWSjebZoDZ1p0otlaN14VQFb4kPU1m9T1ExuHF+g0te9+9+dMAvcdTcbguMHarIBUTbt676+P5c1GsRNh7D13NvaqomQPjfwU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 01:49:39 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 01:49:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Per Forlin <per.forlin@axis.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 net-next 12/12] net: dsa: tag_ar9331: let DSA core deal with TX reallocation
Date:   Fri, 30 Oct 2020 03:49:10 +0200
Message-Id: <20201030014910.2738809-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
References: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: AM0PR03CA0096.eurprd03.prod.outlook.com
 (2603:10a6:208:69::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 01:49:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5ffaed03-e38d-4192-e4ce-08d87c761055
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB250959B34FF9558B9B29A805E0150@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mAzyP02EZ16mNRWNaV1YAMQZ6s1aS9IgDkhk/MRgKGAyPO/WoRcHtLgMwFu4T1vHdnDEI8rVul8AfSMn4v0nDbJR9xHDo+Yp+NPdjoZrk/BmiyA5rE4U+K5CiOtyj7s9EgCSxPa9L5QEaj7d66ZteMguwH56eXHM2vRCsjur429iuudDJ2T9wa6rhj8yoHQknM0Hg4Hlt9UsGd1bttEkqt9esGOWkFTIhqvwsrjX6mzuEiggY5qw1A2HujgAIBqULoiYdMTAHkpQzt58cW4aAKYeO+KUFKYjSUrcfPCX6DYjXnjnhCq3zhRAFi9Nj6x970lBcPeb55o7SYVcxjZue7GaIH22qr9kKwA11t8Pgsxv96AH5S/RaztypxfbeUrJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(5660300002)(54906003)(4744005)(16526019)(6506007)(66946007)(66476007)(1076003)(316002)(186003)(8676002)(69590400008)(36756003)(86362001)(44832011)(52116002)(6512007)(6486002)(66556008)(6666004)(956004)(6916009)(8936002)(478600001)(2616005)(26005)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HHRRx/TIB6+jOGLWhO2eRGIvmTSEbTEH3JoFWUt4pudiu68dq9dDhHwLKqUqBdYtliM0Xi8OyvoqgvMNiC0XQQLapr93gN6hxjW/sg//ivzneiulP7dIVo2otE9pWF6A0k2ajRTesvCYZbSZ/UXP6yrsWhghO4WoDJRv0KZhaPPKfBLXcKhxXW8enkxMZyKoO0Eiq1Han1LxXK2yTHHWd1Dx0L9WLA/EELSD4x7JZO6Z4UE7YL00ojOq4liY47JPZ6XlR1/+omOv5lDWrTr/wHPeVs1k0ayVncfvvleOkJ1XCIr49zidQCjLPRVmgSr8AHYIdnKRP2Dj9uJiV4xRLD2UvCoTpCoFzciHDKRRq6yEBRnySdGbhmu793I/kN/KRYvD5eCChijlGqE8LGotjVo9kkIlqL669q8rvMEoteil1CVAJnmS7maBjpJWsUJr6fT/5CVmcRFUMkOa0NgLMYUofgEixP0F/8a5wxGLNSoKKTXODHqm2Zrb2UeExovKpdTLuN2lQ6Yof4eZLbDE3p4CXgCyWuOcu9GV99L4rX1r+eqnvElAVmgMtqs3XfqAHM5z01YQTTtgtDJhPrW+6i9Py/eyo9ft9eFFFieKAn6FTd3ezncfrCkVC5dtilKbYaRREkS3XSDzH6CAWTmt/Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ffaed03-e38d-4192-e4ce-08d87c761055
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 01:49:39.6903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I1vVMyWjAVORS9HjuSkrhlwMdB0WRA0owb5AgauC/MU9UbaHG6DwEOY5jNaCgKNwkNQr8oPC+xvu51yxpVEMDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: Per Forlin <per.forlin@axis.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 net/dsa/tag_ar9331.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
index 55b00694cdba..002cf7f952e2 100644
--- a/net/dsa/tag_ar9331.c
+++ b/net/dsa/tag_ar9331.c
@@ -31,9 +31,6 @@ static struct sk_buff *ar9331_tag_xmit(struct sk_buff *skb,
 	__le16 *phdr;
 	u16 hdr;
 
-	if (skb_cow_head(skb, AR9331_HDR_LEN) < 0)
-		return NULL;
-
 	phdr = skb_push(skb, AR9331_HDR_LEN);
 
 	hdr = FIELD_PREP(AR9331_HDR_VERSION_MASK, AR9331_HDR_VERSION);
-- 
2.25.1

