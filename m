Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F742A2101
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgKATR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:17:28 -0500
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:31354
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727153AbgKATRV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:17:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTehu5b9+Lg0sqYVt4Tlk1qSdLtqqPHkSaZ/Nvm4xXZ1sthu4bZPYpLAn+ilCNF3te/kOiJu7iozc7caAo4pTWM5gva5qudjhQAwnmFSTHc0Va8oJx/+2aMvoRPGmyg0IylHMPV+bz5AsOxAaTc8skA0sDclycS6JkIj3/7x1HwYbsPaE3qyRqrkp3Qn6qXzT15J/zzEi7t804FtT3K3RbzSA4nFFTyaYm8ACLCi80gBqKW6EU8UKavIQWAa9MpyQJGemXiCaZKobdhrvs7Oc/HZqimNbKM0LNuXGV4Ho6kFY3IJMf16jzMG5UQpv2n6fLbQ4gCLF/275cCl+Qkc1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lMXv/JySk41a0EdK6MbX7MsMtOw0nuUEKX98T0E0fc=;
 b=eesUU25wIDZQG4G+nT50SMoB9D2wYbFq0CRdevtDGHe/kygNkhOoQTc4Qpm0svPDXrbNDKWK5nx3UOfJvXsuyxnWcBJtGcegC6b5wIP9ToXfxPd9sKS0VxsV4Azu2rfyN8mbRpsynImNRz2Lfbu5M5QqeA33SFrVVkKcKa1+bdQJWy7XUOShySZ2kwYdMPS53r9VQrrq3OobDEs4cmKrZHSDnIeoHjblpBd3EFMtB9UfuLLJdoaGOK3/VboIMuKu9Ehb0+y7ipYs/NDgKaO+AOir0NXrjPswpN9UIlX9Dcja/KDeQ6/1mxheSTxtK760KGmdey49n9kHCWNJ0+5tYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lMXv/JySk41a0EdK6MbX7MsMtOw0nuUEKX98T0E0fc=;
 b=NilnH51EyGmOuknlxIGADx92w44cTHtDOBtbOm+qjeT7hNGlJJuGMFo8SRLXjCoX+0wol6xHzExod4viT4wfflH0xJxTaLZpo6Z8CE3jv8uG9sVwyuNz4HLWbOQFwUx9U4ptTXHjob9TV7AA5c0eZPUryR8w9xnzTFgC1IXiTLg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 19:17:00 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sun, 1 Nov 2020
 19:16:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Per Forlin <per.forlin@axis.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v3 net-next 12/12] net: dsa: tag_ar9331: let DSA core deal with TX reallocation
Date:   Sun,  1 Nov 2020 21:16:20 +0200
Message-Id: <20201101191620.589272-13-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.177) by VI1PR0401CA0001.eurprd04.prod.outlook.com (2603:10a6:800:4a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sun, 1 Nov 2020 19:16:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f3f64b6b-f892-4b4a-daaf-08d87e9ab4de
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2861ACCB1EB4E63F50440E87E0130@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: euG6Nsfa+/uf+j5MYhCa3D4J82UWYFqOsJIRzpeC4VP2PoMJw8BjSrrxtw/BY6S2qYwwnnPgwJKBIiIbjyjlEss44M0q/Ew8ETM4z7kFkNJxh912BO9eqPJ2PBspzg+94mGmcT0Mxe4v3xDpnEM3JytnusYbw36pReHgJluDaZxvLmyloP9MvtTc7KnClcc0PQQmrD3HOYdUcb9j1/TJ6rlz4UMcTscZovZl6wUHXpsaFT7xztUCvSi9jBNG43a3DJvG3zbW0nvIs7ArzFjrPw+mRZrCW0NGzAfk1jLT1nxg/lKcY+cF5jLcvgsVKM6HPVCn1be6bHIpL3uegIGvDADiD15N7vQ/ddv2IiH2swM8dgrKESCg9P5dpcdjnE2D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(2906002)(8936002)(16526019)(6916009)(186003)(6506007)(86362001)(2616005)(4744005)(8676002)(26005)(36756003)(66556008)(956004)(66946007)(5660300002)(478600001)(66476007)(6486002)(6666004)(52116002)(6512007)(4326008)(1076003)(83380400001)(44832011)(69590400008)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: S6QIvhe/uKWkrS7piHV8y4/b7s8V5RsjQMdvkoYRgmHRbMu1XHyAs496B1OWS/c9V3wENNJ2r1rYjhMco017rUYm7qecAAOeWpr4JX4z3WwWWsAXrBGpF0C/3qmPUTEZUgh7430i3+ZlreojYWu/4tjt6CXMw9Wzw8wq6bOeG10dfrx4KfYBMFG7pG4qKo3RhdDZAeBQsF96nEdlbhoesZD54kZrGi0nhAIudMb2rh7UD2VrbSA00PcSb+E8wZZon3Wc0QZ9SyvUW+Qo2ESP4HvraIMpQYdAAGr03oPzKWO50OMMP3e2ZQGV2pdrhMM5asuuruzCGn83VHQYjpEzmsJbPqgPA0dhFhCgXUZARehCHZF8XesnS82ADEEIpeDdwOJesqfA8LoDxrYjibJ2FPqCfaph5Be9Qv4ajy5SflZL5ODkXgSgJOPChOR6dt4UY1Tsd/QlwpwXg7mTPN++FeW6ob0yv5FOzfMuZhzJ2lcplXuCwEb8uYoxozvcRS0MtV3dTCEDn6qEjC39t4TuK85erPQdUiHxAz7mRAZVFTxd0+H8j7m24LYHeXt4FMME302dgzrpzE4jcI+dpVQKld0ReYuRiUx1j2AfA36LBEFlvkXjMgw6Vot/0OcMs95Ha7nYIxmE1zmG8xusfrI28g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3f64b6b-f892-4b4a-daaf-08d87e9ab4de
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2020 19:16:59.9571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VBSsguxdva5/7GTJoI6Dsrz0e30Wa72vDTRoTpAIMFuAX0Q4S6t8gyFvK6sOQyO8hwRIHIKnByxjtydOCT+vjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: Per Forlin <per.forlin@axis.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Oleksij Rempel <linux@rempel-privat.de>
---
Changes in v3:
None.

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

