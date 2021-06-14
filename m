Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206E13A6753
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhFNNDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:03:52 -0400
Received: from mail-eopbgr50111.outbound.protection.outlook.com ([40.107.5.111]:61697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233450AbhFNNDq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 09:03:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1eh4xN/GT87IU/t7iZ0uUI0Ai8ti8UD7kTYNX2DwvDucZOgc8UMY8Zaetubmm0ecAoIiw8vou99MYJyDTlrZFcinOWiEe1gn2O7qd0lh+ZexIsdlpYMM09vNpDHfwCdDPTCMr/5ayv9vUqtSPDituUG5SNg5uDi4naVVyDyvtg8sxM8fgIOaY9xxWgfW7JdoUup4an05Ig08zLcmw6zzajHaivc/KVTnFOXTQoMOeGb7AudXEBkkIcSWoJUFkkZyLeI0wd0Byxoo5N1Iyp+lopGMheLbuTX8mJ6iuMpeM5pxA5IWYyUV441dF8dIs5CtU84FskzYB8EKafBk9mblA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFxkSwjoKn1xfp5wQEgW+LqTGwSJ4sBvfTsa35Bqq48=;
 b=PcgmBDk0gt4m9MYPjxuAuWadSfzlTWMwuGpIigA7xZh726kgAqHIOByL3NXr1P/zL3tU2Mp1KDctSbBz5ckgDMahjiVOw676PTFsXikJLL0spxw10vxcHY091FysdPhgbcQR9Icf46yA6cHEbpFHL3ozt6diccRyyXKhMdTkOUhlHuWGSZcGdNYd//gyYKGB1zKSRj9Eu5XBNPJr6ESeBM18oIqXwSuzRN703TX/z1lNXYm0+p8rbXMJvWuXMu8egHFF3wt91drq7oZdyQAZ8VIQ9Ywbr0VxU+e4WUw1N1SjEbEkJdF8J5UDoyw8GW2HKqRBFGkVyOHDRcuAbJCMHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFxkSwjoKn1xfp5wQEgW+LqTGwSJ4sBvfTsa35Bqq48=;
 b=lONHFy5u/MXAipcRH+1pNc3pEiiCujBdSCwd0y9qJ+bxV+KJJJDLYuRd3tB8j6hxtoYtBtyAjdb7EaL921siRVUut0M1Yy/NwSa4aPh+RNHVT/9GKukb/rwMZjLkcJrEJ/fHoPgTUceJNMLCi+DjM0pOCpCVndP0VU6j1V3IlCo=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1396.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3b6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 13:01:40 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 13:01:40 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, andrew@lunn.ch,
        nikolay@nvidia.com, idosch@idosch.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next v2 4/7] testing: selftests: drivers: net: netdevsim: devlink: add test case for hard drop statistics
Date:   Mon, 14 Jun 2021 16:01:15 +0300
Message-Id: <20210614130118.20395-5-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
References: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::45) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0140.eurprd06.prod.outlook.com (2603:10a6:208:ab::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 13:01:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4956b812-4000-4fa9-f2f9-08d92f348d1a
X-MS-TrafficTypeDiagnostic: AM9P190MB1396:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB13969EF671421BB4DDF823D2E4319@AM9P190MB1396.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:179;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ALYqXfYKGu8KzjRGp6VkBkcFqxzWjkoPrOY7nv+kQ6/bG6U7OoVJMP2hCHVASA6zQmHglHo/Bv88Mr7HlLx+ttHjEDnaMOXr5KBawNoCQoe0bBsJJRXTJQ7iUi2PTo9yypgsRXytZK+PAwO63HrAm9amL7mTDblXsIrzXtspXZ6t4KEDzNv45wtWLVyXgGXV2RvLkN9xI+LN2Wyx0Pox4CUASasPy6s6Rl3X1YWlmj4boJ10HjVxXyEnTKMMrzziTF9Meqy5mKJxOu3PrY8Q56jCd4uCWM6k+zbxNQlGbGR/r4MFqVva/flw3ADfA9tSenG65KWN+lTr1NXK5FG1j2fPax1YxoWtG2HG0apGOXNkMZtV/fWZ1UCNzoS8ngvTP0lOcOvUlQz86GkUKJbCDLNMx6MpPAgGxCKgrC8hsVe1ZDm7EektbN4tzAH29JcZYqyL/1iGMDPPhrGrfTLWlo+nJDKixAoOOfGMWn7sECdsG5/GZZuPgglkF5TFK9DXbsF6c6FdbrsX6K0NnvmJSFOIhQKsg6wfoxGtM2QDqSOI/Lslh/NNxuwqtKdyxPHzAbq9wU6qZYlgQN2/WWJm9bUczuCDa6zaQKxj/39xa5T9duwXDipfMX94pEnyK5TNqsVBlYuRPM9Q3eUFzgNpQ7V7xMYDxMiIMrHpUoM1pVY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(39830400003)(346002)(6486002)(7416002)(66556008)(16526019)(186003)(66946007)(956004)(66476007)(2616005)(316002)(86362001)(26005)(8936002)(4326008)(8676002)(478600001)(2906002)(44832011)(38350700002)(36756003)(6512007)(6916009)(5660300002)(52116002)(6666004)(6506007)(1076003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xp/+zWMe3Md5n4vaK6MrFdI16c/ydjNnMlkOU0G/8btjQWPewV8jMU2v2ssR?=
 =?us-ascii?Q?nYQ7byxyaou5uqlHRdsWMwLpJWUc1ph3qqD0bqosDPZM7/8Q42UGoKXdquLq?=
 =?us-ascii?Q?nBZV9CPaWMnHhkcO/CDPLfmGOsgrysQUBV9vEd1cFkNIVyzB8eIH/3zi8VkX?=
 =?us-ascii?Q?ypbkkI57iKp9HwpKnLpcSmFNsxR2rHTBJC5EZH0WsMzQ4PlCh3VTr1Kf6hp8?=
 =?us-ascii?Q?liQLGkoKJ9bycXepL74pLgRhUC6/4rX2Ko9phv+ndR+Ksz05aujp2n3BX2rY?=
 =?us-ascii?Q?hYXWKOITR6SCmFUqHioJuFiqzIgoxqc6AzHyvF380qwQ0x9wfwvqLK54Lnuv?=
 =?us-ascii?Q?Dou1O3LWV9vEFZ/S6Ck8k1bSKk+N9GmiMGMTfAb/1Zfg6CW2lf4ikdL3+1bu?=
 =?us-ascii?Q?NSslM+L4pYWiqqjHN18z6GgqjiX/9YFsCWVOgpwUPqr6pUxsvn7wMSdEyz1x?=
 =?us-ascii?Q?3ZBJLYxjvUWJ9p5ZdzgD3O+zZQhxHF3xJI5LAgP+vGT9iGyK8iL4SdcEWgoQ?=
 =?us-ascii?Q?rURWBIhyT0jInM1dUOk7e7sO2jDhnH4tZq81fkLB8Pe2NEwIweZXlJBkwLoB?=
 =?us-ascii?Q?e2VtdR8dro8Xw/9cCJK15BGUy40bBUImoyxeB8dcl4rlC+irVlJWbnisquZ+?=
 =?us-ascii?Q?nPdq7SNxgy8AV3a0lwlvokT1qwAXnY9UXsJzcEDTvXetNiols6wPV65YR2V7?=
 =?us-ascii?Q?XlyPdRAjxq6eLlOpRShmR9N1m4l7UnomvmcLRvSCuczVsCyb/GdD36YDXnBX?=
 =?us-ascii?Q?3ZyeK0Vd21JyAj7YzPlVk7KMBToPjfqhIN5HXjWcwB3Ybv/uISGhBZI7hMDT?=
 =?us-ascii?Q?lCOTuF4xm7lbR0LMM1zfWnOuGijswFY4bHEy7APAwc6KX1KidwfPmqJOFgG4?=
 =?us-ascii?Q?XMdRtANO7+dfkXg7YY+9N0sA3+cUI2XFzzHdPEqui+kJL1EyhuOGffA0dWRt?=
 =?us-ascii?Q?YnthRq9r6ty+yMJaP6USQl/Kh0KdY1Y1muhO2ev6TnpuWodlVW7k6ZfbkKKE?=
 =?us-ascii?Q?/9JbOFxh41nCe4DLg2bjWQmLmQWnmx0u8ixv8p8bBVFFtdfRCAtheAlOSrW8?=
 =?us-ascii?Q?ydKXnYFHGNhR5Nq6r3ReTVoNfxhJBzRe/C/siXPqjgrcYo/yLfFnA4wE/ydl?=
 =?us-ascii?Q?yjfuYA9AOZ5pqtCURP86dJ8La7v8VzUTls8jHqHEn6lDcyJ1Cncg1oAxbbOl?=
 =?us-ascii?Q?G6+k8kM4val3unj+G46cR/S42nZZIgg8xSStfMA5m+eaMlOCtFakisEgJ0g2?=
 =?us-ascii?Q?R68WoQkBe6go3ES9Kxzjmxmr/QimvsoYJslg4pxspu6ThsGVw+eh+ETT0+f0?=
 =?us-ascii?Q?jSQnQlBQ7+8TnHbKunMr83Tt?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4956b812-4000-4fa9-f2f9-08d92f348d1a
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 13:01:40.4203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hn+Y1CoC72HSwe8SFpeGeHmd92pKO86DCVpxLn0uz+UzH9qmjxDiyN+zvh5fE/3ri4JayA/2M3MxREOPtLhsxmxun2FgjOqy27HE4RCmXgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1396
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add hard drop counter check testcase, to make sure netdevsim driver
properly handles the devlink hard drop counters get/set callbacks.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../selftests/drivers/net/netdevsim/devlink_trap.sh    | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
index 6165901a1cf3..109900c817be 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
@@ -165,6 +165,16 @@ trap_stats_test()
 			devlink_trap_action_set $trap_name "drop"
 			devlink_trap_stats_idle_test $trap_name
 			check_err $? "Stats of trap $trap_name not idle when action is drop"
+
+			echo "y"> $DEBUGFS_DIR/fail_trap_drop_counter_get
+			devlink -s trap show $DEVLINK_DEV trap $trap_name &> /dev/null
+			check_fail $? "Managed to read trap (hard dropped) statistics when should not"
+			echo "n"> $DEBUGFS_DIR/fail_trap_drop_counter_get
+			devlink -s trap show $DEVLINK_DEV trap $trap_name &> /dev/null
+			check_err $? "Did not manage to read trap (hard dropped) statistics when should"
+
+			devlink_trap_drop_stats_idle_test $trap_name
+			check_fail $? "Drop stats of trap $trap_name idle when should not"
 		else
 			devlink_trap_stats_idle_test $trap_name
 			check_fail $? "Stats of non-drop trap $trap_name idle when should not"
-- 
2.17.1

