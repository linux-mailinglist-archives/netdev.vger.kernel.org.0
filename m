Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2FD2914C3
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439682AbgJQVgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:36:52 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:7653
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439570AbgJQVgr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUx4eEFaCsRIb2n5ibzRjOHsiJJzW80Wd8JL+4TLnuQ+xB/ssdyW+4Wvc7B1Kvjf9ISqUBgLaPok2GlV0hmFNguP19pcYFZLP3bQX0a0Qc5NUIkSzX+cX2LW7JMltAaNr+KkjWbolf7iH+aYKw98KIcbfYr1ZpM+xmzN/eiMF3tu6b41U+dFlTNplcqDEHa7u3s2ooTWj7jauEPRENVvw66IDAiEnhw4IvcxjdonRsqUE5M3mwAUzi7FRY/NCNkFDnp5+BliKJGwX2Q1hViEOZqnVKfwDCVHvdTMF5SoEILqfCxcQBE+WiyuKhkBZPEv6u1OIGGh1yeyCjW3DMb5fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCLOoKks0yq3cIcsBJTGWJM58SQDJxGMu7IWPhupxmA=;
 b=KssaoPJXfWKnZZveilQxwQClU82AVxXjziScXlceGLo3sjPgGLoZjq/MQBxlcfwc9XPEeTceIz6YhkfSLcHcl3zRCKOH3nzXWOqlCCoNqlF/rA4eJvmgG7C9kIkDzfuhlMJRn0rTdsswS30NBZarrIGqLiyTz5dnEtqCuKXNUw0ehDFwAHzA5n2puN476d1MdGQ5m3wLVgdPrx3DW6Hdnfx7DVPdsKVnzHdYTcWxCdS/P+ftN+rwB5BLWAgr8XnDnCXFFfUzJbbrQKHBzlrdXmVdwswl0J8Jqffh6awdvSvpo73lEgpXoYXDYbbli2mw08kQCNtM8bvpq2rxkhooFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCLOoKks0yq3cIcsBJTGWJM58SQDJxGMu7IWPhupxmA=;
 b=hQ/McDwc2U9IHZSaKixvtPIq7/VdU3nP15LXWJUkea08eD5J/XSll/Jp7pz+7EM7gIVcJQIZ8Mi4nr9fLNaKPHtFdzw7Csl4TatUntG6Yqwir2b9Y3wdQ0oeOUy6g7X4FmqouTeapmzrAIRo//ElpliwP8WC2XgCKLdlzdO1k2w=
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
        Kurt Kanzenbach <kurt@linutronix.de>,
        John Crispin <john@phrozen.org>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [RFC PATCH 05/13] net: dsa: tag_qca: let DSA core deal with TX reallocation
Date:   Sun, 18 Oct 2020 00:36:03 +0300
Message-Id: <20201017213611.2557565-6-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.174.215) by VI1P195CA0091.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:59::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 21:36:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f2d4af4-c8aa-43a7-2e99-08d872e4b9ea
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB58547E9B88BA5A1069F49F30E0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zXQRnicFT+Yky3fXOYPicJjoZFqA19EvLY5fDsPJoeZKTKRakvHKfXYi/Qf+Mp3eKEc+NhgbAnh2lbh6c5+r+/TJNo/d/3C0eggv26vzMBEhkEcK9iYBAV8KP2RTE5fAUCpN9xEZiAsd58KPf8p8TUTGEWG6FrG2Ad4ksWjToDqb0BP3QOYOBtou/ZoRiQraMN9rrBdoynSxnS1ksMyrVLYtm6+wOWVWMUI7CyoQ0BZhKc22FmxgJwNpR+geKKn+GKQQnI2hDw3Kh3/ZLZUcRyUTbgUmh3avJgMeReoEJsaxV34mOaFcPhmcBVf33WVV0Yun/LAZ0z2UoGOZ1jjTyBxdP6rBUkVbivoCB21O9RfZSzWwDLhIL2CDsjd5sqIl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(4744005)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FUvohqFVxrKJ5VlBHQFfE/gvT+Cz6/Zy+JHDFTzZDEdOPjh2VH+YUDEL9DCjaBXGbNx8i8hx0WytyYzEm4F+m9rOAomU+rvl8LLZ4do9/yFVcGQzJ99MjAqMibKJ0cOI5IQNg81fyV9YEuf4eqRQ3/vQRr1K0p7Dqa0+w8Pfa6QV/YA3y+Hk0om07QHGWc+M/8JUAUq7uYeOTYq9rzkm1YTt/SdA3sG58L3Y/BJr4kAa9TiKPfZsb8JNjfDRArXZmJMrW71305EqYsxlW1VAyaV4nE8oeLm/Qg72RTcSQjWsQTGp55esFfvv1IKySKK3PDlonJf386ebJR3lnEi6ArZ0oaLaixxmFX0kAPociC+ezjcjTsC3YN+pXs6Wg1XSRGQeyf+7vFeAF9AA3WRJGnVRh1Es1c1xsrdgqZo8VA1WYb6cFqe6S95JH7Tdm3J6v0FyaNuZvTSNnRJfaBoazxC+/hs3AUDTzrTr8vFPQUT19QCMe0IgyxtQND1F8briijTAItx0OX540MwpyBBTznj76qZNqOyNPrepHJZOYDl0kQ35wOoJSkw9lhSlnW0DaO7ijE98Z00ilxbweJPiEkW/2Hdy9pPBnjfzNPh/T0z2R5PGzPA7U2WX8XgeSiWGEV4nQhyVnFzn+DqKqGOJaw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f2d4af4-c8aa-43a7-2e99-08d872e4b9ea
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:37.1786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YgNhP26uwydhdgY266Vc6YAJNALNlwAF1v3Fy4pzPSPje217Xd0MvCFENfRS7eMdKBDJDxI15wTMrDZF4NVVow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: John Crispin <john@phrozen.org>
Cc: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_qca.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 1b9e8507112b..88181b52f480 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -34,9 +34,6 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 	__be16 *phdr;
 	u16 hdr;
 
-	if (skb_cow_head(skb, QCA_HDR_LEN) < 0)
-		return NULL;
-
 	skb_push(skb, QCA_HDR_LEN);
 
 	memmove(skb->data, skb->data + QCA_HDR_LEN, 2 * ETH_ALEN);
-- 
2.25.1

