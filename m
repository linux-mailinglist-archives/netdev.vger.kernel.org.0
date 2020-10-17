Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779B72914C8
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439728AbgJQVhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:37:03 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:7653
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439699AbgJQVg6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyZEmukpT1hYxw2Q1bg+Q+5Wbm/SYWmsaUb7eYxr5iEpM9NkGJwIjGWoCzzFSElReHLVPaqFwoUQNgVcwr5eoSyYNBXMfW7JGvUHKGDYECbSvIXK+UQciEXJh9Ou9Iy3EanjN+VyciodqHHPXvuzMe4RC1L2AGQqxNE9SpgkADmla1qQJGMOzVxoYXMPp6yaHU+CapuviOiiVNEQvPuKV4Rwg8o7Ghmk22rR4KFeoO6ZQvFKKCz3DCw5BH6R/EM0EmW37VpLrC32B27IAa05Rinj4YGtN7jSyDb9q7ZzKcxMJrFDi1uWt6Uh8JbJV/lF4BRHYZTPzsAic3yKEvMkCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p73WWmDCd67JyQxZyxr/XfFjJCuJt0t7Busat5pIn0Y=;
 b=Rfu0I+rw5q0O11LIxg830YnwNIelfYhqU0I9T8s7VHCsJM2ara4xCk6oawPVfGHjeK+oTxEkzxmLTikypYZjCbb4xSsgBxlq/i8SMjYWlmDaL+V9II5uUPgqelFdm/T7xKiwo993jRfgTOYv9BEyOn2PXlv1omzM8bOzsFoVyx0V7Hsk+CGZGsF8jp6cfB+iZlH59MYNWGas1nAfvNJkfEE++zjiSyLuy+BovavFKLRQZF7gIYONKUuqHwTUpWZ25S1vjZvUwnBaTwBB5CLzboxEIiPxt0bor1xDzag/m3fzl20TunKIzaOrKtI03BOY22QnJWe70hT+8wsDNxsj7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p73WWmDCd67JyQxZyxr/XfFjJCuJt0t7Busat5pIn0Y=;
 b=EIoqGWKIdsC3gQU/yTqEeJEntjtJV+y3D3Uic9kC4VySyjA2dX6NfBuRTFdaWAHef/cIDMXigtw8vh2W/p7N2F6qTs8wH9ELXlkxw4iaiQQuwZ4QoNmCgTAAvLl9wPJTtiVkF9fSBwWCNtZEsZ6ntgaXWpNM4jh/valWtfruZQI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 21:36:43 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 21:36:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Per Forlin <per.forlin@axis.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: [RFC PATCH 13/13] net: dsa: tag_ar9331: let DSA core deal with TX reallocation
Date:   Sun, 18 Oct 2020 00:36:11 +0300
Message-Id: <20201017213611.2557565-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: VI1P195CA0091.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by VI1P195CA0091.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:59::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 21:36:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c4e0d65b-3abe-4a5e-7a33-08d872e4bd42
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5854096255453F14B8986045E0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hl3bQJr8AxgwKkFfCtJ4XqNA7kaxGGkX45IMpOkBOH1XpW840Ryt9mzfVZkpS6tP73VKn0ljcdmneDwRQPzaOjmtgGS4CP1C4maV1s0kztVe3I0YWH9kNTkmzky6S9sKeHtVQUF0c/oXXKth1PG3aBrEYtGJ7gavD/UistbErLEn6pCO4zqxwfI1RYWq444w2TI8+tq/PF+7h8V40LrieaIgkbmkW+EAj6v8vEMlVMQM8No5QsNamenRrwEuhRCkup7UtsEpDnPXBzcGklifYamEu4m8uDjMssJiFw1YrocNobM6DTw46vNfyZNCIzecNPv4bC5mEragAYZ1Ii1Z1xu/rc/9o7eae4cYpS5mjEbWlpxxGPA4PcAkxByK4HZJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(4744005)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cFQIXLvaCSXa3BT9SRkAVX5xkAIqxRqD0ZAfQVnEhWzuQWPorTLWrSt3JpIXqjg1RXJ6ykyjZtf5rYfHwv3pquZzx0hxiFOPE5Ml/xjJvs4oqxy62qmDJCSAj+dw/DelJL5dDnRkKGAxlimONsTAZWOlPdaZLlbr6xxap2LjL/cc/XnPbqqLG3bGfJtvQEw+vLNOWJj+LkPm7OfNYbNxVXloLI9jv05FRPfkEjHUr6HJEts6qNPJ8lkXpTY3cLPtLIH3OGc2CaFWqIieD8rMLu4yqFg+1uI6cpGsph2neTFOFqFcSRJu9XAw/YyRXHVzGsJM74UmYZsmBK/eAzhPuRmu9BJUNWZNpwdhp7bhm0aW0KtAan1H9MrnfPDEiLw4bqckcsN1WJixfyH8cgh26rhqoPnSF1zL9dl99ziswAcL6Z5UOj1iD1VvQ/ay64wbhzqn1gwnU09M5xVX9JqkFKWeeEm5oRZBXJLCI+ji6m05wh1GqfkhwGhllWVNpIPd2b/jK2tWchdXQkrxZJ22xeXRlU1nrQeL8ISv4gwh5h5N5La1KygT4kr5RCOoF1vlZWnjIV4YyNT53MNrUmmLYauiESRNBuQW8fWMTd78oJHSPx2A8stTIqurkunj0FqVUoENAjqk6l/vDFYdXMZ1tQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4e0d65b-3abe-4a5e-7a33-08d872e4bd42
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:42.8194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8WIG8LoUPodrlMN7fktxZ07Vtjq+vTMdiFJlvmiGrkaQd4d8JSC0DUY26f+BZYouogNXT6YurF2ZnB4h+MqrFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
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

