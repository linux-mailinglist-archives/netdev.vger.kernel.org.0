Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7862914C7
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439716AbgJQVg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:36:59 -0400
Received: from mail-vi1eur05on2079.outbound.protection.outlook.com ([40.107.21.79]:2205
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439700AbgJQVg5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEPfdDxvDoVoSUDhNYYAvh37OSsLap4zXFCX/8zDX9HUPp/Z26fp1HAoLKJh00ARRstcQeOhrMvboO4A29jCfYvOvtj0A1qQlLyFkNAnw4Dzboo4uEWypg9GP1b9GQgAptKf5UxdEoYS78Wqcsh1kWNEUFHXR6J6LD7h6XUZeSU/OANUo0RTsLO26cp0UzwXYDvwic+vyQT5OjtW0b7JGawpM4VXlwHunlcLelVjRr3Io8T/MgAZx11VI3QqcXu0uCDmgHQVI+JprtXJXDp/wk7Zx4YeFJb/YCpWiuCH2e6xpfz4j6kc25wXLoE694WObNzYHIk8pdYFz8NG0DioFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0F4uhJQHLIVWymK57XwWSUjZd0g/k1MU3hYn5RPvd2E=;
 b=TO/z2K5F7NbJSW0dMUzJQI8kKehejBUq1ZVXthKmXOQC2o0P1at205D1Kyt5LScm6a88PgkV1cCgUjnSh88FAWHPUTJ5VJSQk45Z0zAL3UxsxkjtXMiqQKL+OD2qhQIAYZY449a3gpzKZhMhEj1ZzEyp0iSGx4ON4wj7/m9xd8SSlFcsaZ3QQoSeSuLcV5Ptr0ENXE8fzXFazJxOaw9MabU1g8loS+BZlzT6cW7UV8GOUZSyiH9weFHeNicnu7iQ/MLK0Pam8UisJegCGLNA3lZR2YtoJnZ1X7v4sHrgQsIlDz3PL8FDYLetdy3UPOkfyZG5lAknpOpOo9Qo8YWH0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0F4uhJQHLIVWymK57XwWSUjZd0g/k1MU3hYn5RPvd2E=;
 b=LCskgm7zKao4AqzwNBWrUFmWNf8/8NEWYWDvMpoYjQWJ2OWsy5x8c0IzmUUxJeZ2+eaos+R4jQGuyX/Ote4D9IcU/2iClfoZtR8aJPGi9z/Rz+rLQnFt0LDgRONJCGoL8B1l8LKZ9iHgd7WG1CyucmNrCwyr2rljkj8pyCYgROA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 21:36:42 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 21:36:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC PATCH 12/13] net: dsa: tag_gswip: let DSA core deal with TX reallocation
Date:   Sun, 18 Oct 2020 00:36:10 +0300
Message-Id: <20201017213611.2557565-13-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.174.215) by VI1P195CA0091.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:59::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 21:36:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 247e1749-2877-40aa-8d33-08d872e4bceb
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB585413C8B7BBAB461354B06BE0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DeVDFSrBMm8Fw7giwk03Y94oXUDbTTr70Ry6pfIRUy70Sds5e8sl9XdYccKJqfd+txf07dhjzFKmyRrler03TMnJqyA7ywzSjTNqg6i10TYttPp/eYyu8afXTL/Wasn9me4g6GX70NLj+1RKiyzWZokij85fnH1FLcdZpjCRz3zdDPnzalNyTcgw6WaELPxIPW1C8ImU2ubEx0oR0aE1bJ6qRHBuMeMk62UluCPAMiHncmyFcZ9qTu+k6V2qmNImNyYfzuNJMu2J7pIETJwvU79xnyqQtwX49gp4E/3f1APABVB3B9OZBNXK9G/bo0G8k1cWJfDJqE/bjWUw/AOdew65i+eIRpkhZ4pkv1Ib5HyuqxIEe/f8c3iDW7Wsefd5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LI44AXV/kfOR2ZHV5ijnUebkaY4bvjzDJy8n73MEeuawsl5NZwUW7SUO5nyqKqfHuOhw4/CFfvMfVjpUQHXAN68jqp30SUdPymPC98ypY8DZsAgpIZckXUwGpFFXKDysQSdGsm+B7NAiutFB5SP7ZRP08X2N77+HgedKm2So+mcOQnfU5+v6VAq1GfJ4FEyxijRJWcJovXuHcAMq1eZWQY80z4Ukjcp0KzKMOnbZMun0OVQNEDih2EhwR1tcFnNyE3RwyYd447xO2QrPw3PUAqK+ak15JNkMq3zgD4JqJ7FmVprB+N09DjU/b2U4YKoPbar+NmriILMlmO2QhAWrjYkxKzcVr8NIl0vUbR84nTlvr+rvWDigUwu3LZCilSqo7oES52HiqZYF5e70zYjTj0w/0MEtUVhma7SWZ/qNatFMQLXI8E0tK9VKkOablAo7tIg65aylE/bIN9v/Vntf2IZ6lA+1wxYtz+sxtxbq15Mo2x5Cpd/0KsVLvHPwwuq+Ze5HC12NlNjoJrP4tPbEfbpG4bnqEsth75WiNM8yx1wh93Xx2KLoMRMJDw5HtZq7u6FDhlWKKMau/sG/eQGRjSiwhvERfgYQSll4nEukpiayvhKZkWkxzFCc3KcOzTw03xrQz3y7oHbQoP9LZB1Qug==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 247e1749-2877-40aa-8d33-08d872e4bceb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:42.2277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/agwHQyMZ4wvQrXn7X6hcrKJBjG+C7t/3Q4u6nwtxkvnTVGWJrZgBQWUKjD13RsKfto1HpQtuVcungNPKYTyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

This one is interesting, the DSA tag is 8 bytes on RX and 4 bytes on TX.
Because DSA is unaware of asymmetrical tag lengths, the overhead/needed
headroom is declared as 8 bytes and therefore 4 bytes larger than it
needs to be. If this becomes a problem, and the GSWIP driver can't be
converted to a uniform header length, we might need to make DSA aware of
separate RX/TX overhead values.

Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_gswip.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/dsa/tag_gswip.c b/net/dsa/tag_gswip.c
index 408d4af390a0..cde93ccb21ac 100644
--- a/net/dsa/tag_gswip.c
+++ b/net/dsa/tag_gswip.c
@@ -63,10 +63,6 @@ static struct sk_buff *gswip_tag_xmit(struct sk_buff *skb,
 	int err;
 	u8 *gswip_tag;
 
-	err = skb_cow_head(skb, GSWIP_TX_HEADER_LEN);
-	if (err)
-		return NULL;
-
 	skb_push(skb, GSWIP_TX_HEADER_LEN);
 
 	gswip_tag = skb->data;
-- 
2.25.1

