Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B092914C5
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439701AbgJQVg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:36:56 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:7653
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439626AbgJQVgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoQakDuBijGPwU5LkB3YCp6Mm1T8JpTkapp5Qpdr5NQWqaOqfs/bkz+ITQVE7Hrf+/M0BA7GDjW/PtQvpqHbTVVLZy4cfXdwqHITbfXyemh93+ADWt5PBbUbmTrirD8YTGOD0PT1RJ3qHEQ+ZRdeuPBgFBu7xQFaSzXAeWUHHsmx2SoDhrbPmyYMIR5ua4kBSpOL6NwLmkAR8MQVkJSRM/P+hBMPXT1P9LFMXCEJ+7lbF511Wy63gjz0ABeXH8yhx3K3hhQ6NNIjBC5CHGy8Hn7fl5Xt4fZ1n+TdyQTQisFddIPAoPDtXq7xnWzcllqNd+Co18sz7lCZB06LKwm0tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fSHE7vhNSjzCwUMoJNcq6XIjIS7yaxs6Myh6wl67p8=;
 b=mDiEzH9tWd3RySnGbtkDi2AGVMikdqr6RSILzm5+MZfT5MSqcD6SDkftZnasyLoCGkBV+ZlmHFlIBfjnqVDs9dMxjzz4AJj+tIbCy4l+34NhUSgLNNjCzJtZ2wUW0sM+ICHIr+NBm2H7iATx7c8Gj89piWmPJcCduryp0L8pQJ7yAsNL4BTIkhsdgbMyZNL7OHWJ/n/q+pWAtyZPnxxHRdcsUHHWV67DUZmKaUWlr6Ib9cyySTIW+ru5vnz1qH+QcPysqcZhhC7urpKnmKNuZ8ad6ro9Ka4+ioc6iO4OUnM0yxy8olkL7rMfUiRW5AGiQOgyNmtqoNANyVULndKIyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fSHE7vhNSjzCwUMoJNcq6XIjIS7yaxs6Myh6wl67p8=;
 b=Sj1INxELi9T37lMIyDIuSQu+vpLojxJysLmLDmGXJ6UOcoVM+2mvWcuaZmKKUR+gIjFgQw9TaoY12Y+3+5onAU172a39XGE1LGfJPiLEMDLN05/eD023htVmj+xVSyaU8npKP+3ar9Rtu30zB7KBw/vhezW7okM/VKGD+yV+6gg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 21:36:38 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 21:36:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>
Subject: [RFC PATCH 07/13] net: dsa: tag_mtk: let DSA core deal with TX reallocation
Date:   Sun, 18 Oct 2020 00:36:05 +0300
Message-Id: <20201017213611.2557565-8-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.174.215) by VI1P195CA0091.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:59::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 21:36:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8b40272c-f65c-4544-e948-08d872e4baa5
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5854C691381B6AFEB5867D76E0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IwFS9mqIrZeV+YUMexpysLno1iXt5j0VV/b82o33C44+Att5mYTiOQoJdRLVNc9GvZKJkDA8A0qyGBAqqypykxxVTdLPbdkYKC40AkbBOoe0cN1zV1HEy/0ZmQWiFNwe1EKGYi0sAikeiAOcl2eXC1oDLHORennqkwoRxtij54Smka8mRt/B8FHum191NCtkwy98jtIh70cPdG6SeNOWgty2d9L9DeB1sagE0ALKCHbJ7sRIg6Z07sIekSHXWMLEwgQZFUJ6CIBBAbpfqQUGAYLuLxM6PCuIlo+rflbrYsPpy9pwhy4P3McLoYliYV1UGcMKlKx7HV77wZj6jCKbOKnaUODjnEXSwu0AsndxCaU+MFSaziBd6Powp5R7wFWk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(4744005)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(7416002)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HrFQBjW0Q6a9/v2fe+x87BgOILVKQvx/c4oD0lNhjpJqeEZ8K3GeXlwYka/UXDARY+WFOgISRg9fOCSoGyaXGvKMOR7pjRyx4nnWLJijeMAeo2yg3LomYA/nllnAZ0aDaXieJOD1LdAOulwJHs795JMQtfnjRlUC+aw4l5pE+0aGzqALRGP8kGo0icMTxcUqIJp6my2smieC7ctVBxdtguqadRrZ1B6n/D0JE2X4kOkKz1rEiBNv0L9lZeIhxrIJvoNmvUwZqRfEKokEvgB7HXOLs7w9Lap2dZCX0FU9AMgxuUiLktzQurCJDiiztuDe6dSEREbY3gzxf/dBtWE9O5fwzi+Mrj7U1kAStH9Fkmjde8KxR4rhYRwxvPUM9hjFzuXZocBoZdAJ9p29ZlFUWKyzMXmkqT8H8AJsojDiDcKcCpZmS8hJMTjTQzEbazD77mcFGnDjv2o0KHuaLuYmMMoMECQRSJGdhhWo1IKH/MdObd3ecUX/4ETybYq4vGSbgj15XqVYcGWOtCZVi5e0rbIc2H0PFZxLH59jiuuPKRUiSb+RFprOWVnilf6pzHaC07N7gY4ckd78/XUvVQwmRvb3YbtzNjBN+Er6HJv0DRkbJopEISaivZqwsN31fbb84fc6tsc/FCtebG7NS8pkeQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b40272c-f65c-4544-e948-08d872e4baa5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:38.5568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xkUaDVGJj7d0CLbmpUlrktIxhfQ/4XoIdWq2beL/SqxXj3TT5ulhfYQUf7Vb0hEyGUdgU7PvIwZQtyyNO7VIvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: John Crispin <john@phrozen.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_mtk.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 4cdd9cf428fb..38dcdded74c0 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -34,9 +34,6 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	 * table with VID.
 	 */
 	if (!skb_vlan_tagged(skb)) {
-		if (skb_cow_head(skb, MTK_HDR_LEN) < 0)
-			return NULL;
-
 		skb_push(skb, MTK_HDR_LEN);
 		memmove(skb->data, skb->data + MTK_HDR_LEN, 2 * ETH_ALEN);
 		is_vlan_skb = false;
-- 
2.25.1

