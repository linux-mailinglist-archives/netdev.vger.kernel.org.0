Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7BD2914C4
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439697AbgJQVgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:36:55 -0400
Received: from mail-vi1eur05on2079.outbound.protection.outlook.com ([40.107.21.79]:2205
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439623AbgJQVgs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZamk9T9W+j0IUcVfRqeUar0nUrEFphDxi9snn7QEg49zO37LSzkAYsMXdwXQgBiKqV5hm+5lpM1CnEMmEHBfD0gYZSGbFEv0NjVGH9/aU1GbbeF+BJOSbX45/PjFXNeXsTjpmh4dEISqzpEVSvepsW18wky5VEO15+nXGioIVwrBrsZgnMv7JrUDvO3hlD0UXJcwL7q5E38wL9xv5/jRk8KFAbfNf3iVSAoXi+qrdRbaX/IyCfpiiKoGIViTLPr4PsX/McakO6E488POIvKr86FrUKatnovBkpZjUwj9HWvAPGP8xh0egtwdXOz++Bs7WP9geTOwyL2ffA37v2Dqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hM0tCaZLzUEx4RfqFqMD/rPY6+TdWtPNUmVN14oWLkQ=;
 b=GUj+LD4mPN5ITOPOzA74QVkTMXnJmo0xXKlKnendlUYiF9z/WkPz1gsQhNbNDJmO9oSrzJhWuKHXZ33KTFcK5hNP5iVuo3X1UXj8DTZkCaiKfisH2j+ARzcHz9ClRQSu9rxn7iaK0es6Qe87nmWpXn5UJ3ixkpu4anXySQkG3v+9/AvrDwQatnSa2Ak1ZJMXt9Jhxk5cceonCVVkfnp70Qq81I9kwdMgL99Hb7r30uoMEAJFGhgKf8ZKmoDlGHOQsvEkF4TYnlulFRzMyhDFXZYaCGpsHvncZwru72Ho9i/sSqIvtrdCbMT7OW7fbzQ7vqO0QepbAk0th6CrQOWHxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hM0tCaZLzUEx4RfqFqMD/rPY6+TdWtPNUmVN14oWLkQ=;
 b=QUAnhgZDZLNyF21TwdXe1oYQgXBU1Ii4MAeWfT6ruCcwkx2fz+tEh+oNoFhER0QnUQ1vASVjbCEET8i0yIunVG31iqBQXbJ7EWgh9ZelkCnjxG7paKrkPuefG/k7ajiO66Jh9+an9CeC1KgUIM80FXvWwiQsefkqVQO7tMIro+w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 21:36:37 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 21:36:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 06/13] net: dsa: tag_ocelot: let DSA core deal with TX reallocation
Date:   Sun, 18 Oct 2020 00:36:04 +0300
Message-Id: <20201017213611.2557565-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 12713aeb-ad83-4e15-bcdd-08d872e4ba36
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB585405CFE7DF419EE62FA131E0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vesey1PIX5r03RI82I7zJ4dmT1gQIoEq285yqxfMCLsekdwEJtqeRLsUw/DGGv64j6WuxInERAu3cJF5N6QymdfyDTLZqcusV4aL5OTpBOToAZuShOYFcRnpYJvb4WULWwDrL+y9geHugWaBkcoGH8cdOFQzMIJ2GOpkiRIbbCT4mH81gnATMJ0SoijUf073MFHGcsL9weaQy2S61LKiTLc5YAJxondVsrr3FF9hDSz+erZmpZXbzMTExw8UIMHHz6HNlQF8BDPfngwHY8eYbWnZ5BQNqnDebOT/sSon0btv6JCVP0fU+BKi3VY2NS9jyq4KWs9lAEldITysU7x8pVVIZvaLa96X0WwrHBjOpKduJQsO9bxC5PUqyOsi3sFd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(4744005)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4oxpXUKrs+YTwIHPY1D6B4zepmprKNZy+tT4P1N6OoVsUcU6T8kHnEYLiwkZ4CMUyW546xf4Boinwfnm/vt1Rrj696JsVPiyO5FZg4ZzKH0K9fQjL0kx86p66ozIzMKMfV2OOMWuaaaZPPYGvEqZniy4xZC/TdHFTUWUXaMs5XQlXUgqiv0FQcmKZvx9R8kf4gWdLgr+5Yx1vVbuuGWSnHE9M/zvtaUt1N/uePQFjSvefaAUfrRzetqjXxcnUpzcHiDS46r2/s9bmKZyYmodxqRJoneLSHa3c+kYjhK0g5UChPojwkvsIs2XMtWQZMUAYNE0bzuiBBSIuoHI97Fd8bZ1tJzu/EVts3tUZcJ+4CEKqBLntg9HPLvTCCA8ZqWDVJ6jGRwC/6zbtUW6cwDphsYO0erKpMUNTNoJguVw+OxkFf6FaYxHTfy4EwBVGkvLhj7Hh9o/T+sWXIYYsyEbJjuoWiSOTIDUPtX9iQ4+9ZGJk37+z28tomwce9Wcs7OZ8g/Ho8Ke0s43q3bICTA76zAZZpQLwbqJzKOB4YJKbemHp+b1u+bKir2iT1VjIxDCRxdctkoIqez2ho1O+qBUb5PnFa/L60sneHo6rSxtxPVDOwgZhERouk0+pywkccSG+AXulh8FbW1f2wwwGVaUIw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12713aeb-ad83-4e15-bcdd-08d872e4ba36
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:37.8242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXeWTZ0Ye7jdOXNx7YMPov+UiVhjPiHmOt9bJLVdsrT5/EYpBw8AWN6eRK9wi9gCOVka9D10SNrFrFPOXJ2MRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

