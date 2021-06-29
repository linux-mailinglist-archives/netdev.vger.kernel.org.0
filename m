Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF553B6EAA
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 09:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhF2HZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 03:25:03 -0400
Received: from mail-bn8nam12on2134.outbound.protection.outlook.com ([40.107.237.134]:62305
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232257AbhF2HZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 03:25:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFZrAVN06ka/walgkFb46NmGNg9KKOaIZXKK9TVF4ZwnCdORGt0w7fYeXDC/6C0tl7gagg30FSDzLI7YHkA21wDvq3YmJK/PGaJFQ9JMiY2jEb/qOaR+mQw833M8iGqPGaoF9qFUyLhJUYRtXgyYTVcPHuay9rlQd1UUPaciSuD3DEsXtpYV+pMXr++zx0cdU8VjCnxq7vhgRvwd8Vq7uQVkywukSYi4g6rvFb+qwUV9Bhfl208tCFbrNNWrjepwBqDPuB96QqTKPZfl0ygH7IM0AfKy7Y3VBt75FbDoXNHTpmLGSGUzUhX+RtTA/tPCbtgJG5JnCOWeh++/XBWsbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/tjDxz4gEBsq/9wCBmdPsCzCxVnibz4m+uffckPsM4=;
 b=FIqcF8z2ym8noHZK8zmO9Ufy8FUDbN99+dDn2rdiiMULjxbK7cE4cpeIIgwfXAAwx2xpuO6o7dPit4wMTUkQWD4vHAWVUHW/PQ4OybZNCCdLBN5+2Cmdj4RW7XdaRNgEFqJihUyxylcslaC/lqfIffES4J+xxN6PkFY/JOplM5sdyShA+SfyBOQoEXxBpcBg+GMB1qQkLIpBM78jiIXo8jGSIYwWe9IdIrQHhY2qrOb2WqIfsYNwhyli9Qvk6aBC2y/o6BIftCv8Ggib8G9+IeK0ulKvau2OzdRO82bjHVrUlg8q+KyzyAa+Yd+YKuyKl+ngMtHLJe4JoyBNB6KseA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/tjDxz4gEBsq/9wCBmdPsCzCxVnibz4m+uffckPsM4=;
 b=m+vkEB74CSV8/76THlA4bCfXVJiVezfhZtBM+kW1kFRmRojL3j7KO9CrJw0CJLdn/5UfIevCZNlBswfIYpvKdIm/bwIehrC5wPcP5S0VoUi0cvwdR1wHjThIdCD+N8BLc2Zd0dsh/zuZF8wWK4Lum389jf8uZjxkLVTLffav8to=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4953.namprd13.prod.outlook.com (2603:10b6:510:78::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21; Tue, 29 Jun
 2021 07:22:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4287.021; Tue, 29 Jun 2021
 07:22:33 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-net] openvswitch: Optimize operation for key comparison
Date:   Tue, 29 Jun 2021 09:22:11 +0200
Message-Id: <20210629072211.22487-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR02CA0125.eurprd02.prod.outlook.com (2603:10a6:20b:28c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21 via Frontend Transport; Tue, 29 Jun 2021 07:22:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de7fa194-3677-4353-c249-08d93acea9b9
X-MS-TrafficTypeDiagnostic: PH0PR13MB4953:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4953031BC9F7BA2B04F30B70E8029@PH0PR13MB4953.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fEn4nhLYsd/mpwRSZPhYsLOxj8jGCeSoS7XqOdflFp2rbdxdx8j9ITuZrP2172ifXaGYuBNmwlzsF7JXrXF6y1+bYfoovauvrjReL+S21PAgnnicjghfL7NLHJxYUAbEbVUlzyq/K9xcSiM5GZjaG2CWiWpFS01P5kIBmowpjsLeFUjU1JhS/r5jyIPryrOAIFJNhJ6n2R6ihUEN62v5DqyP3pn6xg1JP4x3sy8KvFGfvx9lyDRtpaownJ0ko3XiU2zv1sH12ET1vC7IWuu8azARnBL+H2pI3/8a9+7YFnrIyNg0Sr7hpIshJckOkl+afaGMxd/QpIUofZLVzQsu7vpMJp0xVwm/0O8vcRcizPHUxlN6wqpsLPzBpo/hTU0F9om/N0F3ciLrxegCcVYc5Xrflgqc+xHP2w9PwXZOix+Sg0PkBILgZ4ky/lTc6QjcKul18y9mWCy4e9bQ6jIJcehTlliPoaK9ia0wNi1Oje0GAxaGo0Z3hZ3IXAFYYS4B1vbHWDhC6jEBYIOqzkGzQ4TO8oN/of8DU3al6KUFm0uoLutP29CD33IuXvNs7P4cIOqWMbyC1n70MsjSE7VBJK5UECfm8q99ItsdiXSB4QanYMfYKhQ3bSrcphSr1ZhUHYQljnA7At1QVP7dgi6a3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(376002)(366004)(346002)(136003)(38100700002)(186003)(6506007)(4326008)(52116002)(1076003)(107886003)(54906003)(110136005)(2616005)(8676002)(36756003)(316002)(6666004)(8936002)(86362001)(6486002)(66476007)(66556008)(44832011)(478600001)(83380400001)(66946007)(5660300002)(6512007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2I5yw0Ghba3FGOAU4A4ED+rtzJnuIN42q4s3TaQ2QNf8kqaLMpr5QR1iT1Je?=
 =?us-ascii?Q?UakPwiC5gHZCbIdJa+TJWJ78Lv65wv491TjrHMshrQDsv0Rhy7zOETfBHr5K?=
 =?us-ascii?Q?4PIpHjJu9sPwLugqX/SAsz6Fh6RLRfLd8E39MiesORet6VAsrCTWnosLqeAf?=
 =?us-ascii?Q?mUdCQAdpIJmYTnsR3RhZGc+krMDpm/e2XEjNYLwpjWY3xZgFK7EGW2hUVI5F?=
 =?us-ascii?Q?mAwMnpRPVllkznU7xTlt7dbTk2IbBgzp/Kxyz6k/LjybqeXvcY5niLV6pKrE?=
 =?us-ascii?Q?wgytE2xsLwctCKyT84AtlLJRakGolwBYEcVgt1XJYFL1V2bW1N/qmNus8SMm?=
 =?us-ascii?Q?U6CdPk0iT8t0EqCK9Sv5t452vkqfL5R8NvTH7USqBMOhpnaKxIqnve8vAvmL?=
 =?us-ascii?Q?wS5cUbK/Ivve23biulGDu0ImRP601CbJPQ7EtMHn3M0wslJ8vxk3SN1NpWFb?=
 =?us-ascii?Q?MLh5L53wiX4cOJXp/egwPokxB3gOpfcc8vgKoFj4Knqfc3f+OysWBjitnFyc?=
 =?us-ascii?Q?/QpC+dkZGp6zUTWi41O7nJUWL1DR/IVJUbjZWUESTEavG/1KQ12wa/Ik9ePi?=
 =?us-ascii?Q?JiLknUAAkf/dEjhn9dQkJySJOAsCKd7Zo1KE5u+RymBf/OU+42t5yD6K9UoN?=
 =?us-ascii?Q?klEmfLrJBjCzXqLvO+stBMeuZkQ7wew9E/kPBL73rXfTuQqFjkqiKqxuE8CC?=
 =?us-ascii?Q?PRZ0mUJ2dWuxteP354wYT3YGff5/eaGojkdFS9GCX1zNXsxTo+QNbwICxT3K?=
 =?us-ascii?Q?Sc8FDzK2+E3iDp4e9KWIJkpLEEgCEFLWfJtKVC4M8ksSJOxv4SOhVNAUwDW0?=
 =?us-ascii?Q?SCac6sNXpd6SPhvZ3B5l1tiTeY8p2Z3Ta/QzAOOztjeEsaEjZXVCbBmQFb2v?=
 =?us-ascii?Q?kxZwdjI6xKygSRzgROY7/D9EyDv8bviY/1DuZm0gIbHphpsVWRMpP4+hc9mh?=
 =?us-ascii?Q?FBXPwU1xD1ia/4+f05rIKCS1kQwXKwpr9AIc4BAjirILnpBwMuQXTjmxJ77x?=
 =?us-ascii?Q?55FNiSPrquXJP3sDLot9BDu4RYGEabd/LXS/pjNM9nFALNwnsTa69krx1E9v?=
 =?us-ascii?Q?Mj05mJg3TV1jfN95M5jlBj16btIh0DmNCX6stOfIOTIKipQhGCeI7scsHotv?=
 =?us-ascii?Q?Vx4dAAy9Y0+W7jPsKetXKw2GlC/wtXeQUlR++mT4UPrb4w8mM3E7MkrwwGcU?=
 =?us-ascii?Q?Fx9pb6YlXrtdCkuOymmh7DNDlnVOyjNEWw60y6zoZ0oT0hXejHS3ExwI/Ess?=
 =?us-ascii?Q?vOI46YEpKE/9B8IVwso6edkYlL9TKWxJmBXSNoL0BsIz71GNw9JYv3BB2EFd?=
 =?us-ascii?Q?gylVXZiJrHI1VBvgiCenDNYTQBnKaSYRnrSZU3ERP7VccbTqILNGCbRqkqur?=
 =?us-ascii?Q?9I3Vl3Td99Wxit2wpLsZ8LzBqYXE?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de7fa194-3677-4353-c249-08d93acea9b9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 07:22:33.7591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ws8TA6uPXAExpVdODKeATLzNZzC6kgzpypBbt1J3sUmA5vwBGZJ+0buf66tXI2bftdEF1KTyxRNxDJB8UXEFf97SS/Yip6CC00JweiTzXlc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

In the current implement when comparing two flow keys, we will return
result after comparing the whole key from start to end.

In our optimization, we will return result in the first none-zero
comparison, then we will improve the flow table looking up efficiency.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 net/openvswitch/flow_table.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index c89c8da99f1a..d4a2db0b2299 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -670,13 +670,13 @@ static bool cmp_key(const struct sw_flow_key *key1,
 {
 	const long *cp1 = (const long *)((const u8 *)key1 + key_start);
 	const long *cp2 = (const long *)((const u8 *)key2 + key_start);
-	long diffs = 0;
 	int i;
 
 	for (i = key_start; i < key_end; i += sizeof(long))
-		diffs |= *cp1++ ^ *cp2++;
+		if (*cp1++ ^ *cp2++)
+			return false;
 
-	return diffs == 0;
+	return true;
 }
 
 static bool flow_cmp_masked_key(const struct sw_flow *flow,
-- 
2.20.1

