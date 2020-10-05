Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CDB283881
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 16:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgJEOsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 10:48:55 -0400
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:19171
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725994AbgJEOsz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 10:48:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L24rGYxwbt+Xc2+rcb8enYAvgyKTbwUKZPzKh9mEe0N5vmnIuJaV/Whfa9H4F9Xn8phA6tuIOERWZN8FQ/PekkcttponD7a2lKstLiw8EbLHS79/9pAcI7O1jLGCZ6clTBOAeCozpa8Vc5OMawJ+oWUUr5icbyxdHKFV45XbWfyuNyBIcWv9c9iX8fvOMJmzguYTizwr6tWas9ru1nZ1lJc5SKyRaB8DP8PxapycjOthAfIEARzq956vWuuMst17uPt2QzFvu2n1/4c9rFkaR408yNcf6+Qe1iT7pC/+9VVrM9lorbS6ejQ68hIbV8vCrs1o9914O2dk15b7ZKndNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tijcSyNYgBcrMIy5TFwCrA8gZcFfG8ZwxmCaw9xsYIY=;
 b=h9tNfQv92kE25E1eWtUJuxd+mry9piPa3iWAhiDoiJRH6odhyJAqT6SOraLrdSkNZ+yYUYSTYuYeV2zs4Ze2fgktAgPqLogh8WiDcK+KlJGw0OEeM/h6Y7bIWgyDCgIGuGxppZXmEbPz5DqM0VTk2TTyTHyWNFbMWJUeaVzCSzXsfb4klN1s3EccrEmmjSH1OIhF5NJP7UiJ5S9OfXcSbppbpGrnMlmNIO1AwADgT9i7DugxepBydL3zlbH21ae4/jJ6Nqk/rSrclVXFWg3Bsqv9CENoqRG+jPXC/nW23SV5pajQDLHfSET+jCCAmvvzhIMx0+kL9uqXO0jG+To4nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tijcSyNYgBcrMIy5TFwCrA8gZcFfG8ZwxmCaw9xsYIY=;
 b=DRti31rpv/23oTiaUQ2SjIPMNwyLRs3qV2O+2VPHY9j6xMMWXPkcxgzBOAKo4kHPyZvR2fzCtmg0sXmEm/qdbJFzpw3EK7uanmhWyCJ9OvICA31coVd/vbo/1NOYn6BkSY9VKOOFwRaY1x2pCBbRJ0iAdXtj37utgL6Bz52H9I0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3710.eurprd04.prod.outlook.com (2603:10a6:803:25::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Mon, 5 Oct
 2020 14:48:52 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 14:48:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     willemdebruijn.kernel@gmail.com
Subject: [PATCH net-next] net: always dump full packets with skb_dump
Date:   Mon,  5 Oct 2020 17:48:38 +0300
Message-Id: <20201005144838.851988-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM0PR10CA0044.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM0PR10CA0044.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38 via Frontend Transport; Mon, 5 Oct 2020 14:48:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f18bd8ac-d10e-4ffe-0e94-08d8693dc5cd
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3710:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB37109026244311D2CAE56379E00C0@VI1PR0402MB3710.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D8o+eOaKdXHQyg9uQlf5mzp9vrbUiwylrjQTvJSfpE5itf8TmCNia1kvXtb8y6HUz61Eyr/bWYHXwe5iMj+A22BPEmkXs0ek3avGxVrKI/4lTsmn3buUH9Pu0/3ctWYZd91JMPwX9u2IkGjVr/ERXOpyVdgD3bnP4NX+dCUpUUBTNXp/lawUdUBogaHQdpDHz+UoKk49o0x4fgpcizqjpreCwdcxXMNyFnw+U0dUaSO0dwCC8k127wJaOPTxq6eeEaNM19/wPUyAyf0KcRjr75cmFuQUXj0weGpkgKFbTB47mHN/L/iCFNlXqn+b8NyIncKn4t8QHfejpWGEeE1LYemPxHZ2GN//FthC/oNtcpDopqPPhwFK1c1cPb6CimjY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(6666004)(4326008)(6512007)(66556008)(66476007)(66946007)(1076003)(83380400001)(8936002)(6506007)(186003)(16526019)(26005)(86362001)(44832011)(316002)(478600001)(52116002)(8676002)(5660300002)(36756003)(6486002)(2906002)(2616005)(69590400008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4gU5ysmEjXW6d+FIMt9omYcBGcgis+Cdtx0m3Zk4HWj2sD6gdcjlLSZdrdKFsjrnJlnMQziOWSRLR0zpJ4DE5WBGYQAl8fSszAEfR6KJot7IoxtEFneLH3kq0w9FtQ+LGWQckPuBuQgAKO7XO2fsTAs5sxNnFYdQiP3td8Zcpih/REQP9i9dCal8ke9J40a63c8adbkZtsIP6nmbKoshvLdK90uL+keP8Yq+E9B5j49G3w2I99L7fMt9CSKllGcx9zgSExL6NPhHm8CEaHSaI190B85sgoN9MpS8DucaK5m/fRLiO5/02185Pd2TybeZCzLr9ivN/+1wvHtmWGKuPGJx8kvQcxYGcwCaHu0SMN4QS3BkJ/41c173swEcobUuqfId3SfgqRu91CwO3FpoVU+rvGCramStNuz3tuDSbtliGDrBNOkPnwlfK0VNu4m4ziZdaIXGwICrkq4qtwCXxi1xUykzI5UUoFVtw4vtCmL+FAO+h+UYsEbIwyjcQanY7bgHoQG6KCJoyFfTOdgzHkGSVwJCNInOwq/n7ErRlLNBC3oANnOoz5KunCmC4BZC9lPoAGgXqs87mDr2YHG1V9UY0k03IUa6S0JfR/mYHlSHew/no2LIYqL3uT5g/auf/uOzWQRFkvoVMG0G5St7hQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f18bd8ac-d10e-4ffe-0e94-08d8693dc5cd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 14:48:50.7815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KAGtw3R24CIybrv9n9mJai58GswKKexp+vxh0bUBxepXsTF25hSY2Q9y5y8uROQ8lXzcACWP0sgcmOIG/vj3Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3710
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently skb_dump has a restriction to only dump full packet for the
first 5 socket buffers, then only headers will be printed. Remove this
arbitrary and confusing restriction, which is only documented vaguely
("up to") in the comments above the prototype.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/skbuff.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e0774471f56d..720076a6e2b1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -712,11 +712,10 @@ EXPORT_SYMBOL(kfree_skb_list);
  *
  * Must only be called from net_ratelimit()-ed paths.
  *
- * Dumps up to can_dump_full whole packets if full_pkt, headers otherwise.
+ * Dumps whole packets if full_pkt, only headers otherwise.
  */
 void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt)
 {
-	static atomic_t can_dump_full = ATOMIC_INIT(5);
 	struct skb_shared_info *sh = skb_shinfo(skb);
 	struct net_device *dev = skb->dev;
 	struct sock *sk = skb->sk;
@@ -725,9 +724,6 @@ void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt)
 	int headroom, tailroom;
 	int i, len, seg_len;
 
-	if (full_pkt)
-		full_pkt = atomic_dec_if_positive(&can_dump_full) >= 0;
-
 	if (full_pkt)
 		len = skb->len;
 	else
-- 
2.25.1

