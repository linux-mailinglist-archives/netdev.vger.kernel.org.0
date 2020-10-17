Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1352914CB
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439802AbgJQVhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:37:13 -0400
Received: from mail-vi1eur05on2079.outbound.protection.outlook.com ([40.107.21.79]:2205
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439610AbgJQVgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3uo067aRPkO331pZ8jyLcTN/XaAq0QRCkhkm712GC6MtP/PnrwhgGTm5487cVa559YAHSBrvmdgRzSL+OOx3EL0ZjgzJNYxydSeSpvg1YNc8XOXhAQOnNmANyxwIUuep9kDh/iqIR3WiSBRr/ti676T38GhCdLVPL9TdjqfH1zwkE535VfIkvdvKx7nNToYtD3n55DJfc9g6jbmqcEf22C5LV4ll/OL72RuisuYiEJTdNebi+W2F5FZwv8p0RATApO+DNCIScSmmjAiB6D5FpQMSzvWXJAI2ni6wiKQ8yZKFdK7WwUnCAU/zQn69HXeSZ4JtOCkL3DX4qNdbpj7lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gyDAQzWS5xQbxHM5w8/YCylwa7vL+4Ym/gTCk/dVCMw=;
 b=fr/j7ahbJBTXH82F6ONDtAB6Vxk/7xN3eTe3F+4ID7MEs0jefSxUnaobGLIcN7S3EYdC2kOtvHTZ7QITvdbt5YWxr4RDIxgjJADOy4YTBX0j82ZEUQfxaJh8X+6HXACwl3kQBnmXUueWQ9BdWZq8Wlee1q3lyJdlypj/OlnG/g2oir5S4xevi0JfQE4n0wkSZk0j+Zva7w1noO5elPhBmd6UjxvpDIuCWYb/MJnSSBBJOgdHULR7yQJHiT/8ba4cHIhay+ODWEciNwT5NyxLTADDq7xMAvbZJPG8Ywa9WXupnzgvmkPulfmOIIPHdp4kQO5mXaIcdzHTt7/r4fdIlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gyDAQzWS5xQbxHM5w8/YCylwa7vL+4Ym/gTCk/dVCMw=;
 b=E6DjZE11oEoYTd3FDB7z7tBgpi2lqaGNhf27qBuxg+q8eCzWOdpmO9iFEopH9sk9UhuFAIvU/g81UkkGfNlt0WJIvYo7jD8BwOuyCPYeS81BjQzZRxfOq5s8c0PfLe4YeXD1+k5f9iPTMYoD7QHFd5oI7qxKWvIaIXH1nLKdfLc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 21:36:39 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 21:36:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 08/13] net: dsa: tag_lan9303: let DSA core deal with TX reallocation
Date:   Sun, 18 Oct 2020 00:36:06 +0300
Message-Id: <20201017213611.2557565-9-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.174.215) by VI1P195CA0091.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:59::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 21:36:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 79a88770-10f9-456d-e653-08d872e4bb0f
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5854C286471BC85A6CEF989FE0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tG9q+VLK+xcz8cQGmA8UlStxncTvOqEwADlBl0rI++saq6simYY7VnhG56Z34hDlETC0zF0b6i5YmvgjL8wAx7QdA9mD47agBwSUTFPE8cF6E0Fw7pbhBOn6xkLNTJoOuPtEBbehaGR0gDTLLQ3xUe+8vRv8oio9ZM7dfHOG3LNSPnwC8KRtWRwnLp5dWN6QdMk39ImKD5zf1ZG0CY+6BvtOBCK1NyQPIJlLPEmMqHnRhOYAHV585+BXXqDqUjpwsyPn4Vm6pSkgWyXbXptChkXhfqa9NxSx2kuNxk5g/bBdgJGGyvvKzQwHoFuOX8o+1pdlENbL52mPoExZ9goFlWCO9bbvx6EWckWxXoFe5rTpW4H83e+jVPhUrLbSS/NJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(4744005)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EtrVifYxf7jt+GJ/ChEmXzuIsHdhzjAidmnsjZrGnHKRVdX0cROHMnDEA2FBiB88Ff//YhQxri7X2YrGBaFS+iJpLFY/wWF6RfTlrQjuPjy8QM+Ppk3C5krFseO8V71ZMuh4pvQvCkfxleP7nU1KFMwQPVT9r4VZcDGqlTPXHMg4noei5LPHDCLe8YH6+8EMFuniSb9F5EUkOlwPSJisDh/DRDZSNslOYGV7bQIQPXlgv4hPyXX7Ig6qMzptJp5A+1Cwz42LoihLWftp8k/owrlrxr33Z8P4x/VMEPLgpxmb/Cys7VcZ4qxKyfhYmJFfbjkvIk2VKisPGaX+uwB11UyJrTUfPOqi9vEdO3AqgjrssaH6gKQgxcLYf0ttH71XB3c/dGPKlPl/BvMMrzESKamQinBpYuAOQElnMJovRhpYvP9xZo/c9Aj/KPZBIrpecIvjbAEoKYlv3GKnaJsPEA5zYhWt2U7oZ1NExZCURRFzMQRxuLMa2+MliRfUM/jkTi8r/xPw+CxGwwXJ/A7klYtV5/Q1nOLIMUNlvtx8kseE4v+4JurYax5UUxssmNTlQTnzX1e4pdsduhFm130Mci1H78St050pbY58abTnPBqa3zwsOwAPGc1Iv2IT6slHFUyfv3XdZpKoSmgrVUfnhw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79a88770-10f9-456d-e653-08d872e4bb0f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:39.2724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cU4fVTNHGU+6i4jcspTyDji3HDb+3ZaFx3hktosXKUpLIg5ZcrKDJkvgK+Xh+EUF+DPYk7Cgz4k38kvcU3VJQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_lan9303.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index ccfb6f641bbf..aa1318dccaf0 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -58,15 +58,6 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
 	__be16 *lan9303_tag;
 	u16 tag;
 
-	/* insert a special VLAN tag between the MAC addresses
-	 * and the current ethertype field.
-	 */
-	if (skb_cow_head(skb, LAN9303_TAG_LEN) < 0) {
-		dev_dbg(&dev->dev,
-			"Cannot make room for the special tag. Dropping packet\n");
-		return NULL;
-	}
-
 	/* provide 'LAN9303_TAG_LEN' bytes additional space */
 	skb_push(skb, LAN9303_TAG_LEN);
 
-- 
2.25.1

