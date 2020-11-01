Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FFF2A20FB
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbgKATRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:17:11 -0500
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:31354
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727009AbgKATRI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:17:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RG1P2zblI6rp5A5BrlwxZenmG38pFsB3imfJwaEwvPyJUvCwBYi8/H0+WGYiIfOYfnKVs6GA9fJQLqt6VACNmfQLj5x4grQWHPS1iuMTjfUtFSESPzuwYKqWDZPDpOT28PZGDkJ/fhAySU/NR7BCQRxSbOObWKOSD96ho4flRyUW13H5GJzWl/atTcfe7qCctcaGwFDO/cL4OQVm+vbLTybDX3sOqpf7Fuah9L85T4niL3mvT5gXMJpJO9mBz4TGNd9myVJtRSqXYXhcTdRqgkfKqUGvE3Xp8oQ+7SkEz4NPVuGdQ5o0fqkGbxXnP+uanezjjjn5FJrdKJH+liIA7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uq76J4iwFrbsdrG/Sl3aIpnc377zqZmLrNAAr3jkjo8=;
 b=b1hhv/YQo8TrbDsp/wEfYu6N0n87DCmsgEGI77mqN+BbPrfnCGAf++xbzbZSRcWGEJZ9gjRx0fuUM3LPRizj/sEwv1c2bDBfBeDprJomLQqRtF8NvNP0ZxBE/17Gc+YmFud4UzRkvsstzEr0Yf0Nraz6K55WOJyb50IzEOP5LX+qLeYTmbqlc+wEgHOMYtBe0yE4EI7m2bWYdSvqVLJJ9RqZ87hNGvRe0P8q2tJ1eVfmSo5FgtfM743YwUFyhzOYZ2excK/1Iwz3lmP5QCu9iiQ7uon0qJmhL52yVdqeplq7FTAeunoWPKp65lng1jNqt12ffXDjROQOYL0bTzH0fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uq76J4iwFrbsdrG/Sl3aIpnc377zqZmLrNAAr3jkjo8=;
 b=kbG2pNCTg/6M3Rvr6tSiDsAMpQA1OFeQCbD/6hfzALOnHYlPfEMbD07d9YNElgKWxcV9S9N0pBrkFWou3Tw/iRkSL3P28oOQoaz73zmhx2hSCE/wQ0+Rdkj+v3YCISCVKdOR5DHh9knoIMxe1GycbobtOaAUmrBfvDuFTDbmcbY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 19:16:56 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sun, 1 Nov 2020
 19:16:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>
Subject: [PATCH v3 net-next 06/12] net: dsa: tag_mtk: let DSA core deal with TX reallocation
Date:   Sun,  1 Nov 2020 21:16:14 +0200
Message-Id: <20201101191620.589272-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 60630fc6-8ea7-4ec4-6bb2-08d87e9ab2b5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB286139FF14A8E7C9FB789B91E0130@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GvR4Fs4DqAxasBkDoBQm2psjL8BSI1RTnRsYu+hHApFFWJMjqU7Uk0CJqgPzFTeGs5nc6Pr7bdV2bQyoBvKj9DkvjcbcTNEYiX99vbgpi3THVmrFe7lBWAQMb3wkWKfG0snBPPyP340LH8pYNKHakgHa8JOwLhb7L2NBYAtftdEAcDcg2HnHg/bSFHRp2kwUGK4yHVpUql67UPQCet2WSDZMiDuxInjY3RiKIdKlTkZB0oy8Y16YQ1CEeM66qoNz/47Av7WZidOnvdCtBe1wLIcaMT2YKmD6JMIa8quATGXwVGlT4WPx/b6r8OyNHL+mu8QjLrA2o5icYt4P2YMltPJ8ybBpjAUXqGqcOJM7j1ICUcDjWEmiGAi4Hlu84zv2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(2906002)(8936002)(16526019)(6916009)(186003)(6506007)(86362001)(2616005)(4744005)(8676002)(26005)(36756003)(66556008)(956004)(66946007)(5660300002)(478600001)(66476007)(6486002)(6666004)(52116002)(6512007)(4326008)(1076003)(83380400001)(44832011)(69590400008)(54906003)(316002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IYMTDXqrqO6QjmhbhFlvYUbGvirO0zPCB9FFyYDQVWteBCHV/FQsGCtteY8YkT22mrD+WpvSyjIozFL4QRXi8K2Zkmkol+kAufkp36DOSY8Mtblqtg+3nEhe1GBSlHMxu30KGU7+JcyIp51Bt8Vpq0kawXGszLl7yt//fHuw8v2ICXvMHtOJo7bbO3dF2Qv6d+pb2jrkI8farxKm+uHJFAX1lpGvTSzDU5AZpEg/3SfG9xJuOynUzmgfg/VzuZa6Zh8wQ4w4VuA9/lwFHq13M1Wtb4xRZX+4nlW14ojNUAtXU6r1LmZdZRq5gahya5xxqu+5sZ3IYEQ2B92lbJpDdEg8dpjc6RTXvJjs0ZYO349jY2Vx+gnX160tr1f6xfwXeuFanakRPeZJd/euCjBkMKQvyjr4hFDeJG3iczdLjS2p+njPIGDmh2gfUX1V99MaPS2n2RXGX5y7AEhbWNhHelsemCIaWb58UnHRCxrHXkB1d7+TlPd95qRlDj2uMwSUNFi0NXzLxNOfzEXFiPpUCIxiD+VkrSkmydMDAaxzjl1lBxuXpjZ7+Gt9OVyUyWGQj8GOHPz8f+jNpFAWjyNhFSXuvST9taFWBszAOUbCGYOY0uvfdUof2l6wmJvB/DgpCkHH3mmzn+3HJMJovfjdIg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60630fc6-8ea7-4ec4-6bb2-08d87e9ab2b5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2020 19:16:56.3501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UGke3k86yaAxkmwFH1YqOtMGRAdTCZNxkrB9xj1TX6CppyG4dZtyqRFQy4oHhZCizA+6XWiEAMl02ja66B1Wow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
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
Changes in v3:
None.

Changes in v2:
None.

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

