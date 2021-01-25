Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E213B302724
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 16:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbhAYPqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 10:46:00 -0500
Received: from mail-eopbgr10138.outbound.protection.outlook.com ([40.107.1.138]:20037
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730329AbhAYPpd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 10:45:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCmPnvRKfbuM1Unjc+pPWs3tVo6WWZhiVDDhEyFvnM5UW28mzVQI4AzbYGBS47V5wEWuTmOVGQs6wPb5fI6OZOksipHSFNNOScucIWSEh6nEIWJCRl9g/uDT+Q91YbJcleykDEhkK4x2dM3OCqcL08mb9QWjnEGv8XrB/t1pHS/LNFaCiMCr3PPCyaXEIYnWq/IN8SLF9tKZzMtxJbw4JMt4lozXSUGBh/tQLJR8RexGwitjh5fyI9N37ab2pNmewtI1iYc0Zngk+LkUTyl+RCD5FQvvIxj8Yq2NcgimWdXMVhIYM79vm/fz8S/30qYcoCtcUTAuuq2uqPuu3dWcuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfYRDUF3SArLheaRMmMBrOobpukxBVqzPEcTRMbyrbo=;
 b=KznbACWU4nlPESkzTX9sb2RxxiJQwrXKkCU9lVjaV5+ONShKU3f4na+r/uOMsaDTbshIfWD4vrFAG3mh5nwNM6lYHNxmuDSsnZhw1HJGg6K75YkLJOt6bc9Y9kKloMTGEB5IZo6w2WPS4QVh5rTqeHxhQz5uIkT+9Dyu/VNMiR5B+vmhOWJhA29klrOgb/row3FsjfL3jsgTWfThbNjQIdvqWH9vB0WfhkxscSsq1wbQQa2eJFDwTWGqFqlTRO3tgK6k8yAWzdbQH9wtBlWjjS9fYaeMK2hDcLq/LxkbIc2W3fxHoMr7yh1cVZ4AFu9XY42En/TTyvPR1EoHZul4Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfYRDUF3SArLheaRMmMBrOobpukxBVqzPEcTRMbyrbo=;
 b=GsSBRcrb2+qTue4MpUiiZSFdWyq72yMfff4x6gEzfjK/hWD3ckQhmpbqdO2WiwytqX79c9K5Kn7TCGJ6wObhYABaRo1XIPAhp+UFKFJ6p8HCW2h+/FYbkDzOAjp4uVtuW5QX7eHgzmgChKDaac68iyigDmhkKob5ZFqYCz4Njd4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3331.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:18b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Mon, 25 Jan
 2021 15:04:58 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 15:04:58 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 1/2] net: dsa: mv88e6xxx: use mv88e6185_g1_vtu_getnext() for the 6250
Date:   Mon, 25 Jan 2021 16:04:48 +0100
Message-Id: <20210125150449.115032-2-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210125150449.115032-1-rasmus.villemoes@prevas.dk>
References: <20210125150449.115032-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR1001CA0048.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR1001CA0048.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Mon, 25 Jan 2021 15:04:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8827f3f1-5d7e-44e1-2bf7-08d8c1429495
X-MS-TrafficTypeDiagnostic: AM0PR10MB3331:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB333103802A1DF35A2F0186F793BD0@AM0PR10MB3331.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:590;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cD+XG/E7eirKW4gp1XzL+BuKmL9GPOQvC4dTToPhBoCDSAaQALsMocSVHPnOeIxHZhIlMrYTa+ZvRCqQYydj35IVShkAXqzFFMUnXAAr1KDfTrbp677VHxGbEF7K7/9p/yaGoK5LA8lRTipspTlvTrC0sw8bki6eHofZs7GDtu0cppgis3Ql0lmQsfs//FUbxkRBEjBt933/tSiZCXhRB4Kn3kd15QBYaZolA2blYR4JvYo3gUso3Nodle0R7i0FZasCI6lrx4CozlGos22irhAYSKkL0ogunsYG+gLMxjwdi9WXpfvzUB5RIbxVIn8YjChowEzWolWnzxXxEisIBwfI0bxWKyTyQYEJSl5dewK+rHi38rtvTF43MJemFSREz6JVNNXb+HTrLa4N4A4y4iof1yCeij3Jxlkz3AJe4Gh9GHW+PjymE7bAsUjL613Tipld7o9e60vwSyEO6nqVewVW5RJwkvRY2rbEw/WDoMFK9fMOISqhwTQsWZkHA4Aquk/Bhpon/Pr9uRGrmXJNBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(39850400004)(136003)(396003)(376002)(52116002)(83380400001)(4326008)(8676002)(6486002)(66476007)(5660300002)(66556008)(107886003)(66946007)(36756003)(54906003)(44832011)(6512007)(8976002)(16526019)(316002)(8936002)(478600001)(186003)(26005)(2906002)(6916009)(6666004)(1076003)(2616005)(86362001)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?o+NW5QC651klYvH3uHaFTbjWjb++7sSIoZlQBfvAPh7ODvTXLHAnkjAilGK6?=
 =?us-ascii?Q?VC1KScAEaUHA/jMEQVyyBW17ctrSdjxIUsTjqZOWEpFvWZjrmL243wHAVfF4?=
 =?us-ascii?Q?O9QDy9WSljj3Z3OhGHtF8t89EgX79Z0ER6bFSBH9l9o6MW9RiiqJzzTeTUSS?=
 =?us-ascii?Q?tTgP8N/QRQpbk7Rndz8F9Wl+0L7rjzPRd0g5LM/9aNzB2uDXJNqbr6ThOhUs?=
 =?us-ascii?Q?UZnfjXPUOShzHOq3NAsNuHQZu8oS2ZdIi8BBGIUc5Ic/bc4HsmoDi6s0tgA8?=
 =?us-ascii?Q?ALATY9Ig7Rn3w8tHngKUvVRqeVSdSAVmGMI1GoEHuYdJeDs9c069sLjrJb2s?=
 =?us-ascii?Q?F85CMh2n8vdsFjWQKJJ82RXsFvE3w8O0EYF1T1V6RxBJGG+2U7xd0s4R46P0?=
 =?us-ascii?Q?BQAA29uYrO9ahA52jE5REorc7N+F31k0qS8BMIDz8TgiejOI9A6hnNyHc9UR?=
 =?us-ascii?Q?XzvyekuY23uoZ/8J+5EHhrG7dTJmX9t8zvY6bDEWEyiQuHeDJL68kPTAfUHf?=
 =?us-ascii?Q?FdDOFiJr8Xyd/zTNA2n1Jy3O6jbTc+77pkXzXwQaqq3M8vQZESGjNfaAPZuj?=
 =?us-ascii?Q?irWO3nwdRZO+0j6mQNG5UexKGCwY8Ju+RXFbC4sRVLdaVTe+6AREDaZUxrrs?=
 =?us-ascii?Q?6VEfp8w0eqj9GzPypgVIQn1IXoDf7TpwgZe5zdV9+G0ICGihC819x6reC+hu?=
 =?us-ascii?Q?7PlI0k2k8TumcHpwIQCTl8TCqDnJgg/YltRcugHpvT91vmxDZi33NdhJ8Zwt?=
 =?us-ascii?Q?Y9mxPrWP2YCNwaS0/+kp/Pjb9/cuOzlbOh8bAWGbngB8W4kt0Jn166PqMtP5?=
 =?us-ascii?Q?0gGGtA4QXfiqE9WoukQ7TDrjNH33c/w71d8GCeSBPLaFlzn141E4A1DJKEdO?=
 =?us-ascii?Q?/mBMT47PLhPrf+Yi32Zast4oB7hBVaVzTrtT9OARt5aOQoR98Aa+GcbDSHtQ?=
 =?us-ascii?Q?nTEFjhE7KqdnYxFJQGTMJqiArYlxn5Edmt0mU4vzXO4lvjitE5ohdp+yDLi4?=
 =?us-ascii?Q?LsFP?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 8827f3f1-5d7e-44e1-2bf7-08d8c1429495
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 15:04:58.3608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JaiG+6KJ6jUj/AW9DMShyI0mgMJwZ3RL53NclHjmBnaYsCH135DSUeDPBFyljqf0rtm3UjfHtCSUybGJ954bPi3lRgSfR55rurtxTAgN3GM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3331
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mv88e6250_g1_vtu_getnext is almost identical to
mv88e6185_g1_vtu_getnext, except for the 6250 only having 64 databases
instead of 256. We can reduce code duplication by simply masking off
the extra two garbage bits when assembling the fid from VTU op [3:0]
and [11:8].

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
Tested-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/dsa/mv88e6xxx/chip.c        |  2 +-
 drivers/net/dsa/mv88e6xxx/global1.h     |  2 --
 drivers/net/dsa/mv88e6xxx/global1_vtu.c | 36 ++-----------------------
 3 files changed, 3 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5cc1465fd635..8a0df1e903bf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4023,7 +4023,7 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6250_g1_reset,
-	.vtu_getnext = mv88e6250_g1_vtu_getnext,
+	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6250_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6250_ptp_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 80a182c5b98a..d2dd2f4e4730 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -336,8 +336,6 @@ int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 			     struct mv88e6xxx_vtu_entry *entry);
 int mv88e6185_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 			       struct mv88e6xxx_vtu_entry *entry);
-int mv88e6250_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
-			     struct mv88e6xxx_vtu_entry *entry);
 int mv88e6250_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 			       struct mv88e6xxx_vtu_entry *entry);
 int mv88e6352_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/dsa/mv88e6xxx/global1_vtu.c b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
index 7b96396be609..519ae48ba96e 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -336,39 +336,6 @@ int mv88e6xxx_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 	return mv88e6xxx_g1_vtu_vid_read(chip, entry);
 }
 
-int mv88e6250_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
-			     struct mv88e6xxx_vtu_entry *entry)
-{
-	u16 val;
-	int err;
-
-	err = mv88e6xxx_g1_vtu_getnext(chip, entry);
-	if (err)
-		return err;
-
-	if (entry->valid) {
-		err = mv88e6185_g1_vtu_data_read(chip, entry);
-		if (err)
-			return err;
-
-		err = mv88e6185_g1_stu_data_read(chip, entry);
-		if (err)
-			return err;
-
-		/* VTU DBNum[3:0] are located in VTU Operation 3:0
-		 * VTU DBNum[5:4] are located in VTU Operation 9:8
-		 */
-		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_VTU_OP, &val);
-		if (err)
-			return err;
-
-		entry->fid = val & 0x000f;
-		entry->fid |= (val & 0x0300) >> 4;
-	}
-
-	return 0;
-}
-
 int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 			     struct mv88e6xxx_vtu_entry *entry)
 {
@@ -389,7 +356,7 @@ int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 			return err;
 
 		/* VTU DBNum[3:0] are located in VTU Operation 3:0
-		 * VTU DBNum[7:4] are located in VTU Operation 11:8
+		 * VTU DBNum[7:4] ([5:4] for 6250) are located in VTU Operation 11:8 (9:8)
 		 */
 		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_VTU_OP, &val);
 		if (err)
@@ -397,6 +364,7 @@ int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 
 		entry->fid = val & 0x000f;
 		entry->fid |= (val & 0x0f00) >> 4;
+		entry->fid &= mv88e6xxx_num_databases(chip) - 1;
 	}
 
 	return 0;
-- 
2.23.0

