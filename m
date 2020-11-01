Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD94A2A20FD
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgKATRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:17:19 -0500
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:47874
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727129AbgKATRN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:17:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VV4kmNXZKCj/yauIvk1gAr13bnSmFJF+NwSEc6oHd6JrNSfr4VnbFthsML4YgdYttPz78cNj10xX0cTSd/SCPe09m/YFCi5z0DHs379YBHuUApqgbFALlxdF4U9hc92LbvmKG+2a1aLgBTL9bwFYDE1upEE8A/c2FwHrzvny9+xG2QTkwHVvuela3p6QN+8Xc+S4YXH/6S7R3kpccRbpdSnBWtZVeJcZYI/4nT0kqT9FR1/rTSF4RO5hzBFUOswmUd5r3OVYPKB1fH3VWFr3NwQZV7vVK/+E2FFupN/ElzTW8dOQUfOIkFJVbcvag1FDcvaN8rpme/0ydlpLrCB6Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TutlZQUGln3FF2yuycC/Z0uMOMQCO3tpJeH09+x0xTg=;
 b=UI/SS+GHnqEDqBYQ9VUhC6HVvaj3/3iK75Ala21qlM0EJzy5/XXerfPoEUsgbxjCxsCc7LO+HBpQI5qg0u80tlwdUM6wv0zfmm4pJezeQSRQx+P1+Q+aNwuYxPKomUGUw366rTaILVPzCC+qAtlvv+97YU9dkrHomqIJy29KO5u+JpNKgXORzjCuLjaOu+dW0BT08JSdjG/YDISb0DOcke2w0uVlxMcjJsft8zIlepsOgwWxvD5lFeSAPkJFV4T5JCN+8+//DPDUC6ReupN8VLRCm54L03OcmLM26XNFMihOGOVqLA1+j0KKfVXzt7SdEESsBgUkF7T5D5TNsrGEtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TutlZQUGln3FF2yuycC/Z0uMOMQCO3tpJeH09+x0xTg=;
 b=H6BYgJU0Y6Ej0XYjkQ9iGKmnCphdEDY1yc4KqUmpBFZiPJIf/cYuvwS9tzDCVgrsSgK0FCTff6Q/CQgRjwCo+mSBZzZVEXCptjF3fdtH/OPru3ts3Rxhtm7VIl0ardvxeaZRKnuwLlWe4/1QizFn2Fm1Z7cMi2q3xxXy0YQlMA4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 19:16:58 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sun, 1 Nov 2020
 19:16:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 net-next 09/12] net: dsa: tag_brcm: let DSA core deal with TX reallocation
Date:   Sun,  1 Nov 2020 21:16:17 +0200
Message-Id: <20201101191620.589272-10-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.177) by VI1PR0401CA0001.eurprd04.prod.outlook.com (2603:10a6:800:4a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sun, 1 Nov 2020 19:16:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a6b95685-4b58-4afe-edb0-08d87e9ab3be
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28613AFCEF869F2E067F5111E0130@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uv7PFiOwCJfCepvw76g35OHDczLPbq/rldlBGCHROJO0Xp/mDKfcq6AloQl3+6NrJy0ftY7LCWBTqGg0tw3Ut67RBWrh5My19sJeA32vk9Ikc3l2p0pfJbMNC5c4u1PVv5R7+WQxJLwCcTROPy4V5qp+fafltO4fV3XFSkX4hB/EKBNNl4M7XvQLLd7/IzdykzYWYhoUqMRdSNuxJ4g/6WVY4fZwqOGbBoCylBa9THl2LRDAbHs6SONJNVepzIqUCkr62Rko0nW03sGL/hlm6eiU4Lt82wnT0A1zicAwyUmJoHusdAKBEeO4eB+eU6cEbT6lkd8IDQHNvP2r8QHe7mxcrsFwevRZPb6biLQRZrKAEpXEIvyNOX4PBUCmsSqZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(2906002)(8936002)(16526019)(6916009)(186003)(6506007)(86362001)(2616005)(4744005)(8676002)(26005)(36756003)(66556008)(956004)(66946007)(5660300002)(478600001)(66476007)(6486002)(6666004)(52116002)(6512007)(4326008)(1076003)(83380400001)(44832011)(69590400008)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GZwUI+TY0L+/1exlnWlOAFfHP3pnoRsNubPoN/DgaEyU8D/pzdx9mtgvTDxNTD4RZEpD+L17WcT6SovgYxhWMOY2UwvVvUMbQT1yNU5ijvkqhul2Aj7+FjLu+OK3otCdwrGWz7K7Ru07eFIRCCTy62MPCWjXaDyXrupF/QOwOHQz3mZLS6emKDv/2SIIf9cJa/tgAEQtzWvucIfs7QshTb7UYmfUJSioeUao9u4ArB9viadGCmHn81lkN92orNU6ds1Y+geTndrX/Z6Xp0mwxAdjMNcn5dds4rndijjJ99FptB1mQAOOcj6kvBXgNHJcxFxqIB+wGQbqSLvpxgNjhTdZao6szK1iDoB1mqCyQV5UFRTdJJsmIOQEbjOfkuU81G2tAmQgG6DuWgHtQoE2ov7qiKAHfwEHaJtN6vqrppjMSl/+oh303/DdCdKiVsqYm0fnLoo0UdPTWVthL4cDqGgiyJ4f29PGrO1ZhJmnyd8auEA0WiRkif9wEtmMmImTDUfKzvNsWiCfPF7FcXIGmMWP5q6vfJPMnHo60MiJ5MpvUnKgVTK8zUOMxQOyEq1hZ1LE7jwGUHc/2zplo6w75TfV90trLH7qwqQqR5fK4ttSft+auiusmsq2Hu8vBao/fryLUlP0NdhfQUnzDUxYhA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6b95685-4b58-4afe-edb0-08d87e9ab3be
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2020 19:16:58.0841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g6KLEqqmSN+yfNdrbeqlSgHF1/CVQNfcRlwkhrHgMIwZJUxhgcoZqV+DvxqqxhdGKMVGBNKBRO3FKmmnuvWCHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 net/dsa/tag_brcm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index ad72dff8d524..e934dace3922 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -66,9 +66,6 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 	u16 queue = skb_get_queue_mapping(skb);
 	u8 *brcm_tag;
 
-	if (skb_cow_head(skb, BRCM_TAG_LEN) < 0)
-		return NULL;
-
 	/* The Ethernet switch we are interfaced with needs packets to be at
 	 * least 64 bytes (including FCS) otherwise they will be discarded when
 	 * they enter the switch port logic. When Broadcom tags are enabled, we
-- 
2.25.1

