Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6A12914CA
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439789AbgJQVhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:37:10 -0400
Received: from mail-vi1eur05on2079.outbound.protection.outlook.com ([40.107.21.79]:2205
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439681AbgJQVgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1okFacUZcva2YDUf48JwiT+wUt/npH0TrbSxPb8ZZOPir3VQVy/Q5gC8gI8EqIhRsvoN8FqwYfIsn/4FGg0okyclMg6rWYstE1hFgtaFedNO+OmjCVGmREqL/77ArjmXT36ATfsXWzzprZwf/+Nr9KeV5l8x4ixWxomoKEkFbD2oGfrytpzyCG977tKSQUrZCH6vPMz4gYKdRtYc6YiO4EkMMULqBEZ7RaEl2SPywWBvE539Re5Z7GEtO4+KP1KqYT40lX91cdO8Kg7Wrt9C+uNz9lr50jmUzFoKRUytWvYxw5w6LKWIELIFuL2XPimcDnnvPYiA1mxEXHqWB/BBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z08x4Yhp6QrplNVmWe0AbtwFwbrfBJQeLhnuPkzJAD4=;
 b=Fb2Lf5XADIajeyI4O0usWia1oYFP8x/JWkYVS48WZzZm3sS3k6VylFD0dHJ40Tb+XTtxRp4oHt57UYinndE6d7P5rnXfe/R8q1pJSPQwl/ETGsZzYJT7PQOE96nqN65D0c0Tbynf05JtLhxhC4aIOSvducD1yIr08H7hKMya7juIIWc73mH+7j/fsJmKMd1Gm7MbjasZghGnAubAbp6Fo7QE4o/jjlBQUS7VgzA93MGv4H8/3u/goiCBfePyaFTF/8n2i9rShdNKRkxY5EzT6KGGpZoJ1lEzee3lAtBuQEDivqaQw0eyxHVtZdDSJPwWqWe6zEuJIaMnKEul2IZ8DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z08x4Yhp6QrplNVmWe0AbtwFwbrfBJQeLhnuPkzJAD4=;
 b=mk51+hByDNgWSrMg3VZ7wqezPLSbnsdLVw0a6/zFSGM6Eo3y9p4tq6gWOcVZ/+qlN30LISw6WN0XX0uwx30cS0kWl7gb6Dv0GdUv5t7vahy6xG0LMVVohCcElG9CanoDEfoE0JVDB1dxoKo9WVO9AxVUJTwhgzf/24Jswn3VpRg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 21:36:40 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 21:36:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 10/13] net: dsa: tag_brcm: let DSA core deal with TX reallocation
Date:   Sun, 18 Oct 2020 00:36:08 +0300
Message-Id: <20201017213611.2557565-11-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.174.215) by VI1P195CA0091.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:59::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 21:36:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3e619cdc-56ac-4f54-da17-08d872e4bc00
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5854B54C6BAC27E257DEC7FDE0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0lcfaqyN8Ql1MpPsR0HLkYD46ctCEmV8moIliBpK8smwjTBnsTxDsYIj7UfiymH5nD4ylGC31K7AHWEEY4u0XlYgytpUEfAexuyfkRpqMYYhfxaUJ1qED1N1zxgdGmxUNhG8kZyTUy9K0hkFb8y+9oo5jqetTquzHWHERL90WoD0QhUB2byn4vEA74279XRoqHAHOiJHtoKHApTUTLdwxiMVfSdDI/PsAoFxekGLzGLTRrS7r5Y25Rg97Ux12wxtaM9z9aAnlBm7JH9f5Bxt+UaYPjoSZoz2BakdsXTQWNOtFCForH52GumlwG8kc6qcrl8HHqMNZD4Eas5okAh97yc6Mpax9NRYe+nnLbsoGfmb304S9nXjrQGRvvniBjZK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(4744005)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IaK+UdQkQtuDXC27owL23lmMNuKtNbp5APou5LbMFBm2XI2j1HFfyc1wKZXtcXPW1tYgZ+2+HYASg+ModsqXRcXCMuRsL5cCxUmM1Dk6h72ktNAXp58N0UaD8t+6kKYf5xAYWYJ5ld4jR41ZThY84XALGVCnMAhpV1zz0NxMbCLdmWwotH65bXfzBSRt0LA/xe16sGA1rYPHkO9WRp3xbNWzPu0IbiVulPfLi3ZtJ9X6GBtDHQB1pbDix7M1Vu+oOtDxjIwGFYY0CiR/dAfCWxtSzmr5Ebd/2BlDRAPAQOseAmdqUrnSZXd03NnU6gB2sywJTWUD6EVajOq1/ajA/1tRMrZL57zI+fZW6Nx8mu106owiv/V5gtJa62RbpNjkA9yiXvMy8aMI0vXTJFIhhHx7K0oxnmj/ZqlQ7ZeTfNIKHmhHf9A2hOc+Cm+aFjP3vzwDI98KlV1ZD10ZYJqor7EgexDRBIWXeMKi4WXDo+oxxwRcpVr6w4A1xHDlu4Y3R+RO6YEpvkLiXBwjwZa2rrsByd/763ien+PBBFYajq21eKQQDL4ikjPQ6kYlMscIp1XWerXj5m0WsiMPGMVOR+0us/3ivfyUKFqNPXZEzG3hyWRgLy5uRFUQhnpnxkDhlPiR3kg4vcoP63OAelnwvA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e619cdc-56ac-4f54-da17-08d872e4bc00
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:40.7796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q9Eu8f/pOQkXtg3TKm6z/r+l3n9NF6oID3hUIeXSqog+lSkdlZvLsTJipnDojUH9uKdinJ5DsWJaS1xVJQ5sBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

