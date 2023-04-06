Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9339B6D937D
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 12:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbjDFKBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 06:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbjDFKAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 06:00:39 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEFC868F;
        Thu,  6 Apr 2023 03:00:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1/Xs2YszkDemYrk5DqOCaEEMHHdo78F2uyZFQDIiet3NSBObnbHxQWCUt5YY0Uz5lZ0w7fCVRTDHnBXLqmWzYzFbeaHoE6MCoezYaABWHCryfV9f5Eu9/wQkGTuAUs2HQFS8Gyddvc4StMygwL77WXo6+HXt5jYv1e7PQcW6zF5mnnyLEkGVScGTSIYcFmMYbX8EYNPqDYQBa761TTssU4R7cShuf5Gz5piS7ipn0j88kHag/R35AANZx5RvErYitG937z+DPp69hqQngFpXMG/YDzQME6/kCQIiISt4EHKjhNysvCNIcUYgp8VU8yN8952uH59Sw74pRR56yZHbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1qk3bivjPsFZ7aVqLlUWUZ6HNx93+XPlfc41xoaGiLA=;
 b=FbWJ/evkKFQMvMHNNRtMHii2gOwHmHEymSmpv333nmCK1RtSzsS+/aBx+1lAIGsLW6ka9cJPPv5xzKlgTV/5k7AYmo+8VnNFK021meB80sR4eLYoDPeotYymqiDxxdAAX57eokpGXy0/gMOwi5nznzqHa8IMKqE4hHZZNao6tfeYd4+FoTXkM4YbpbV1dJZtCKPvhQ+PRH9QqskAO0jzUPkYSsbK7+6BFYyT41TsLdskJUyMuAy8HGmfIs2ttZJIGulqZtuyeKJKfzpMBKDj6AuLFBgtr7AcylZaxfmXvqJlurwZIyczerWhtAZKFhRA+eP9NtK5dpgz0sB8bO2CGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qk3bivjPsFZ7aVqLlUWUZ6HNx93+XPlfc41xoaGiLA=;
 b=NMYAlz4ivkdluAtzlCw/UE9V3KFNffGhPvHEIbUKgUVxPjJjTF4WAYtgUOWW1QxsPGxjNgtQJ/sj7S7sWUK2olac0IZ3YpiHaBioGH9lewZYKMS3lIHBlgofXesF+keLh/Z384goZuPGXPNkuw7djvqYhkxS4/w2hHV86YrIXz0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by VE1PR04MB7232.eurprd04.prod.outlook.com (2603:10a6:800:1af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 10:00:05 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733%7]) with mapi id 15.20.6277.031; Thu, 6 Apr 2023
 10:00:05 +0000
From:   "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH net] net: phy: nxp-c45-tja11xx: fix unsigned long multiplication overflow
Date:   Thu,  6 Apr 2023 12:59:53 +0300
Message-Id: <20230406095953.75622-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0127.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::20) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|VE1PR04MB7232:EE_
X-MS-Office365-Filtering-Correlation-Id: 9def8160-098e-4fba-07e4-08db3685b265
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QbGEKu86QMAdgSbbpEaR/d+WPXczPQoZowoUJipKucumePG5UvtA100v8bWjVbnp8FN1pQ81FcBdj0APIQfDY6z3WAmGFmTXFZvbvMPFHUgPNopCymDbwiavOanVk7VmKvX0371E5iEFHcnDFuy1R3uOmXuVO9WPtZ51OaoOMHDACmkjKLBqnJn12XiYjHo8W5FPl18zbtwbeYzqHeOhd1GFDhnT2McPFY2d/IHfZpchOnHhwHz26cdDmAtyKtJSh8XlOkJHuHYGSh2ft98fkyI6rtbbYonS0AQz3WP3tRvNOG794MuCrEE2e50JfsGm5P1O76OVKeteetdSYp43zvwuNwpHsvyUWK7pPzvvO5OYWoIBHSTpf5gJZ2qgtZF0fH24PtUjhUbAEy6gIy5GkcWRGLkqmD0mYzTZsu5YmFMbJjNS62/y6e/2SaqXIkm9RtwvJoN2m07R0HJM/7sSGrWXBDaLALFFzOxhL595yzcc9mHTbRnQUrlVDLtK01ofo8lsJwnEQx8vLWLb4RQnqqARS0TSIzxtc875rWPS+Id1yscWzwJOuiy/3yJCKMgOtW7BvOPdqsjf6dJmvA1+t9dMwusWRl28W7z/VUAiuQjlrVluPPyB66UnqKs5pHiU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199021)(6506007)(26005)(6512007)(1076003)(8676002)(5660300002)(8936002)(6666004)(6486002)(52116002)(316002)(186003)(83380400001)(478600001)(66946007)(66476007)(66556008)(41300700001)(4326008)(2616005)(2906002)(86362001)(38100700002)(38350700002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h1cKfawCvB1ufSRYd+zxte6yaEAAscUudXGi8ygP/xqIWFThAKdxvWFi8fTN?=
 =?us-ascii?Q?F3mN9fhLbpBUYNGqlpyOf091KbKD2UhMfTPTZMO4XmKElsCryT3C+S6oj6bn?=
 =?us-ascii?Q?X/Yxuhp2so+sbPMHGJ08xRC2sVU4KHrQ0/IsP9J+1WDwZUZZo/+YHpAGabYw?=
 =?us-ascii?Q?UD/7tyliXra84hpxEOg1IKyVwbeSLd6Yvw0KMvTwuPl+OcoTeQBX2aNenkLT?=
 =?us-ascii?Q?SIvD3XiBLRt2zyQoERSEydIDG3cjZAu3ETDiSvceGX74UEBrcarXO8LlQSTw?=
 =?us-ascii?Q?dxDkidlGXgIlVG1QeA7yGYLjW9UDKIwzLX5fanrYvOGp7hnPXq8k+rTWVe6V?=
 =?us-ascii?Q?40ohe81EZpOp8rZ+1kaUB56fkhyTOpjitmvnn+RD4yNJR9Z18mQmV3vX7jmm?=
 =?us-ascii?Q?B7MAob8LIBRniFwhN0hOOnbDNX387KWF9LfMFzs2mzrUZBt5cp+b2Z1inN9G?=
 =?us-ascii?Q?GHa+dphGZpcd9JE4jY1qpORt6kvEtnX3oR2+3TMwsg8irylsEtwsjjxKW0ZC?=
 =?us-ascii?Q?GCE9z9oX2EtkNu9GlPD0/aQOfL56kPa32w8JqFrXzpNs72BCOI50lfoiM2eO?=
 =?us-ascii?Q?kEpKsbltMUY3dbdjQZz+enGMDOagJHqgy/34AsQs4iB191LtN4cl2IYn1whI?=
 =?us-ascii?Q?Mtn/xMLj1j6bKTHjVzpdjEgCezheYHovhh4z3M2Mk+2hdbrBC9Rxl/ddGsHq?=
 =?us-ascii?Q?eV38M6zx/8bJT00shAgSfFIS0IjAcKZx7SJDnK3EdhkEsMxJAcnOcYgdHTEQ?=
 =?us-ascii?Q?NS3mUtvZs2r5PGTerwIztppls3pSkBom1mceli7yC5LYp1OllfbJdWflZ9Z8?=
 =?us-ascii?Q?gldDfsqvn/9KG/dh+O8Fv/ViVvWqrcoiCfjpUEb/aadvj55Nl1TB9j7T8yU5?=
 =?us-ascii?Q?yJo9dbDjRG9FW4dz9vXxFgb+LkA6qhIpqxqo2A6Ms8lB5hnS0mpMqgh3aoy1?=
 =?us-ascii?Q?ds+GoEcrRgIakGkXbEi9dz2jjhUfUYJzKQ2XVSO6kmkMb5CMX1O1M++y/S7F?=
 =?us-ascii?Q?51oEiCDuPsd2ftQ91PW//BvWKWPu1xBf3QgMiJ5saplE6rrdw0fsrYwjDJkD?=
 =?us-ascii?Q?y3L9c0KYo1Yre3dVLAotzfuydEwiGsxukN2qNUvuIYlIomcDWK31fYJrRQ+6?=
 =?us-ascii?Q?HzkI9MPPtPAFwU+fBv742/telQ9b+w2BbKKEFcs3BldSrDplQn+ww7L9tKnT?=
 =?us-ascii?Q?nygI29d+dles3FvO13DQ2p8gpld4E5gWJFWJj/VgSsns6OP1XG4OoDzJ3/F9?=
 =?us-ascii?Q?qvO1pM3RGNVt/zUbtZT8r7goznTi3KH/SFSqFDIaHRkGfrDHWW3swKUIXcK/?=
 =?us-ascii?Q?JVNTwCwZz6jAfKFlEs8ie3L/RTiCbddcy+NbiY7zHllkqgS/Q9RavJ/rj6f1?=
 =?us-ascii?Q?4e38Ob5ReBazwZPiuLmvkFFG1r4ZFGXG7rvodClGeVMmlIOU5U5mKznEamG6?=
 =?us-ascii?Q?QDNvTB8+xVe/h5N3oGWVTTtDforITqCfJJH7ehdpKWhoGJFjBDOTFtzwPAUY?=
 =?us-ascii?Q?jpHULZ6sFBY1pS9Mgfwh1JhoZ1/oEi902cmg/yoeHH+cf8FwnLzZOOl/zMXu?=
 =?us-ascii?Q?125QAFExFI/1r/J/YRk9Y2+bpvdoHbBwginkvxS0uchaVkt9d8hmZQ/AZkGL?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9def8160-098e-4fba-07e4-08db3685b265
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 10:00:05.7029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xPt4rZFVfVjahzxxHQbVaj1m3zvpSIJIUcvUtsmZhEgkTB8pKzPMAjM2JSQVEyEhHhyqNnugU8Qry0KSiYTZ3cU/wVKKuZGg9sb4Tz86lzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7232
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Any multiplication between GENMASK(31, 0) and a number bigger than 1
will be truncated because of the overflow, if the size of unsigned long
is 32 bits.

Replaced GENMASK with GENMASK_ULL to make sure that multiplication will
be between 64 bits values.

Cc: <stable@vger.kernel.org> # 5.15+
Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 27738d1ae9ea..029875a59ff8 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -191,7 +191,7 @@
 #define MAX_ID_PS			2260U
 #define DEFAULT_ID_PS			2000U
 
-#define PPM_TO_SUBNS_INC(ppb)	div_u64(GENMASK(31, 0) * (ppb) * \
+#define PPM_TO_SUBNS_INC(ppb)	div_u64(GENMASK_ULL(31, 0) * (ppb) * \
 					PTP_CLK_PERIOD_100BT1, NSEC_PER_SEC)
 
 #define NXP_C45_SKB_CB(skb)	((struct nxp_c45_skb_cb *)(skb)->cb)
-- 
2.34.1

