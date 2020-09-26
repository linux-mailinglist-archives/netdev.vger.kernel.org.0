Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AF2279C2C
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgIZTdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:25 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:17545
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730221AbgIZTdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bM9Zurer4LAoSJRY7dPku26oJVUwIXgQ0YwkPI3DhuFLgy7cu+ywwrGBRuu7L7fd32iA+WLZzr7OLYRSVxrLDpWyrXGWxv4g45pfoXMQnhSrwa5hGk6S1wMieoeXwUTtNSiQQ1yDd7EuAiJTZ53tdvIwZRBuU/2aPPNwB7ROswk/8D6rRsgZ0wE4rdxozVXAgU6AizQ1H9rdewP3cYgCtVvy8ipFR3dFQ1bzaCaYmJTEGC/owVxZXnUwPBDqA+DeOvH87k7GGZlMRpu/n1kJM/pBl20n+jx6YXk2i4/eOXr/Gw5IDlqMkaFsEapgT0cFF9Wzd/Kl5uj/9C55+BJSZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luIPDyWsG8mD7MQT8uH4hy2csnc2KUCs8JYgRA/ahfw=;
 b=Rwwj/i0T81+6fV6JDwvGII8ocbaObGnkj9Ho50p1Ny4re5uW9uYh4msKdtqqdbF/P6it1W5jG33A3rkuck5OZsZkejksbrtvDC8yVOwAARMzXKDGl56EyWSrO3Of/p6kFernlrbpIl+NpweWTcCmvU3BI5p5U7CMSXNuU/7JVBMBzzj5/UFRGD6toZKFTYWKG0wIi1oDotSLgb4TSg0pqmMs5m+WeyxCKx9mCHZ5DRhjIqmXTymCL9RIvblu4YCkPG9limUAsJx4IWibkZ3+Vz5TpRYVMvvoZSdcpNzbCeaHHjuAfv3F0qLdMRnOc5Lfa0Vh8Yn9hRPqCW5ENYv59A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luIPDyWsG8mD7MQT8uH4hy2csnc2KUCs8JYgRA/ahfw=;
 b=bRrx40nZjFhu6g6tGgm8kVdhG8wXw/z/pnP+C1wWgMy1klFOVBiYqSKTXT3miIDi1cFKsnxKcX/cu7PesZyGuM6fKUIZUH47Fy9wRtuiPN+XQlZ3fyhD6OTWZ5+9tpAIZApzH4NHADp9yU5uV/eueN/DI+aL+Hfh7nS5uWwB6G0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:06 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v3 net-next 08/15] net: flow_dissector: avoid indirect call to DSA .flow_dissect for generic case
Date:   Sat, 26 Sep 2020 22:32:08 +0300
Message-Id: <20200926193215.1405730-9-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:33:05 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6d094828-4dae-4207-958a-08d86252fde8
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295C8EC6BB34EE8EF5E8AFEE0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k9fBiZ0AgxQUcw5+ijlNJ9bMaESxCIAo9c/cZjNvySk+8KPsr9nMhvwE+3KhJfcMhcZ75357V24ITXD6zNNm5C7s5j77Nk0PNeSGUZdibWEGbvqrOrafYLv8bU+PzG8bAxr1gMdiyYk8UiUWPpS3RNBjsR4/Vw3v4HxTg/7JNa9qyWUqZYHv1JksuoF1eVnSzeUJxjr8sL6LXY0Isx5mIUAtGWLJEqNj7Otgn/44Cln6gvpCD+F5e1GN2dcWcPFDxiRrLAUQQvnI4sc96HHpVSWJ50qAQ6B+vALe3g/zYMUvACCR5DYGJEQNe/zOaLp66mWpZInyzw5FqpHcz/Cutbow9taD6Z/yJSwvxyH9GCUiHc5bbrGzMGMK5o/xpJwAy3kOpuQKxXtNb69I4W0Wziuq3rIQ3RYx1zPdvdkgA42C4fuklfKeCKJYWE6qFrEZSgtjWP6Q5/jfN9OAvTosJdEZ47cvvb/OuylIukoiTdk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(83380400001)(4326008)(69590400008)(66946007)(316002)(5660300002)(41533002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JorKZx5WVaqegRKwiwqaLcFerDkUo9DIfzFVOtBBG+IzRo+sGwZt+hmCd1B4OQxlhZ+KwhnSN7ffQgvMpS25coT8dOuL8bt+xsJiwTelLl+j6A3J9ib7rEbuLkwYCN3JE7OhRSpLRoCwkErmQRLB/P6OyIUn95qoYR5+Y6RF63cFcHMK0FTgX5KxN94jZtttYEAxvp58vyVMGb4zwkOVF7OvUmUt6rA0TViZRFUdw/GGPp8xi5rbEi/4Z1C/nGGvOlAikML36hqxNhjuHdtP78W7AZ9yWv2BQ1/ILWKxDHMGhG+QvdEAmkUA72vDU3fS9pmVLMogOtvmokuPClwHhgt+4gAaSe4pBvn4FyhDLx4W6dy5GjcIOV3xGFz6UTvTjSN24nb+0wqD9B7AiyZcyPRu6wV/ID7CA0XT3+VoKQv4xudDXJtB08S1cWsCLAnAte3zafI66YK/bBK3bbCIaGlcwErz4l8fWWgxEb/tLQXeWJs7hykU2wyvSg0IdAx1uQ0GDAwWYZ++KrQ+/Bje0bmpivoSGGggwAmz5ya5Q0IU/zrnAw4oQm+51kqp6VsenbPBBrfReKhVeE6dW5SfdR6nfMvqZIiD0Phr+lyHfmRXpaS8jF7izIzAKKEwk2XMivbjAIcJQaRiG9FKQde0Vg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d094828-4dae-4207-958a-08d86252fde8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:06.1912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WeMXp8sXLneCGOxWKBBjjKIn6m1nMQnCs3D80lSgrNUUXjbNYy96ZOBPVWUlBfOd0KNHvDI65iVO1tJxTMEIlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the recent mitigations against speculative execution exploits,
indirect function calls are more expensive and it would be good to avoid
them where possible.

In the case of DSA, most switch taggers will shift the EtherType and
next headers by a fixed amount equal to that tag's length in bytes.
So we can use a generic procedure to determine that, without calling
into custom tagger code. However we still leave the flow_dissect method
inside struct dsa_device_ops as an override for the generic function.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Patch is new.

 net/core/flow_dissector.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 13cc4c0a8863..e21950a2c897 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -932,8 +932,14 @@ bool __skb_flow_dissect(const struct net *net,
 			int offset = 0;
 
 			ops = skb->dev->dsa_ptr->tag_ops;
-			if (ops->flow_dissect) {
-				ops->flow_dissect(skb, &proto, &offset);
+			/* Tail taggers don't break flow dissection */
+			if (!ops->tail_tag) {
+				if (ops->flow_dissect)
+					ops->flow_dissect(skb, &proto, &offset);
+				else
+					dsa_tag_generic_flow_dissect(skb,
+								     &proto,
+								     &offset);
 				hlen -= offset;
 				nhoff += offset;
 			}
-- 
2.25.1

