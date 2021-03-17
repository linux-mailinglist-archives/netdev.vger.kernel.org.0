Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFF433E778
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 04:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhCQDJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 23:09:45 -0400
Received: from mail-eopbgr770089.outbound.protection.outlook.com ([40.107.77.89]:46946
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229792AbhCQDJb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 23:09:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTBHBnBWe/WZTo/qQRz2UkmQTq+NeFgRoVpl3q0uMsxTdEYTuFGJ0YZVdrNgNLBafP8qsKXsvWRhFCqxw3xhSdIEnn4oIdTdjNena4IpoZE7djFAUXZrBKcqBcmVBtC32Bkb54u6tAuAZJosOceaCbxt4yffY9x9dy4PTVEV5bvOpmTIltaeF5A4Hoq/duoS4TJ1bGSEgLjJpcVJKtm7xHoIT2ka4UJIUKBny2Umr40pzcAczufSdfaHEDkErC/BgTT3170DZT/QO+XNfleqvjjUz5gWDgz7+1R/NS1/uuTW7dAZzx+90Pyvs3GVLBAKY1X8ce+ShedhtZBujLzZXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+XG4sX4rMjmw+ZhU1JOTMJpcjpBCb0UGn8a+FiTYmg=;
 b=Ih3gyk4bugtQBw3iyBkgeg59hUnknCQuuZ4c4SLXOXrwnrw+sWONJmfijbPw0o0jjkuhJQYuDr8ITUWkoCLAEqDn94z2c8zm/B5TkWS1eWTBq9br0AER80wG+g+sQEG4NjOSvpKCj1Ec+LrbdMCmWzIPE4PZ6efVRdYbDtuMgmpulFfu7iqfL87fpgfl5Sa/sNGE0TQfUnVwjvkDIsyaDxvgghBraYHdVQxdgqnzMlnhY/fSM0qUEmOvs3TjkvNAqgoDY72g+WjQGHdN75iGjRVniK5W4yA/izD5wVXFmFxUp47XFKkVR2sOsYX1Gkee5soCrjU4Kh+moJeToFs+JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+XG4sX4rMjmw+ZhU1JOTMJpcjpBCb0UGn8a+FiTYmg=;
 b=XnA6K43YA0qfHpXG+5to2BBdoGLiEMNDAUZ0ynuetCPgo99T60X6eSGvBkpF4uuKCJXq+vHcdCqP67alytjebcC+1dzBI1YB+XmVvUY3ShOVPxB+6T/10u+2gZIwzpOYo35onRkBFK08/xBWaftEiETAJX8tHIEtmRN+rzIu8jM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB4202.namprd11.prod.outlook.com (2603:10b6:5:1df::16)
 by DM6PR11MB4739.namprd11.prod.outlook.com (2603:10b6:5:2a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Wed, 17 Mar
 2021 03:09:28 +0000
Received: from DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::f19f:b31:c427:730e]) by DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::f19f:b31:c427:730e%4]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 03:09:28 +0000
From:   qiang.zhang@windriver.com
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] bpf: Fix memory leak in copy_process()
Date:   Wed, 17 Mar 2021 11:09:15 +0800
Message-Id: <20210317030915.2865-1-qiang.zhang@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK0PR03CA0110.apcprd03.prod.outlook.com
 (2603:1096:203:b0::26) To DM6PR11MB4202.namprd11.prod.outlook.com
 (2603:10b6:5:1df::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-qzhang2-d1.wrs.com (60.247.85.82) by HK0PR03CA0110.apcprd03.prod.outlook.com (2603:1096:203:b0::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 03:09:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27570c4f-0d61-4d69-2bb4-08d8e8f21380
X-MS-TrafficTypeDiagnostic: DM6PR11MB4739:
X-Microsoft-Antispam-PRVS: <DM6PR11MB4739F5C019B0FA722B0E9B3EFF6A9@DM6PR11MB4739.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Vc/MftELNTPWlQoiBgW47Ctq7XUID3IxuuyqTTzmFeLQsM89VNZT/xonswAQXPubFjE7CmUf9ERfd7MwS8Pj0bp9z991/kYDl/R2rKL+TGPj1sabna7xIxHOfSao8AFT5XYYheiFujZmUJ4EGii/8VB9TyqMyyhLWnI53pzJx49XWpl2EEdR4WwGqDja+kWD+B52+/uz6i6kCoY24iM5rN0mtU+pnqXXD6UbtwEix4zI+5vtuatdj6DqApLtJjwGro26GLQ736fePgyYRpUyzZ/mFMlwFfxJDRzU3+jwCf57dFO8igjEsKMUkItxt1pygQbs3yUeaAmGppwTuMyDVHW8wVyVrF3jgs6jAjHHl1fRXDbr/NjSzz5i8QrycwY1DZgwUBNvtn9ux17Z2p6hXy5bHqoFTfS1OCRIFR8V6utZjl3ewu8hGqfZDXntzXh/e4oqNiUy71w6y4M8bmxq6G3js1b7eMUVReUUJ3r4owfN/TCft0o4zttwLW0yTd2cEiWGANeqZRHFXnraKHnt36lo99Go0LCv18nQG0Q1vyfoHlBTcGxsAH9A5zZ8jWS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4202.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(396003)(366004)(136003)(376002)(16526019)(2906002)(66556008)(83380400001)(6666004)(6506007)(8676002)(6486002)(26005)(316002)(186003)(1076003)(86362001)(9686003)(66946007)(66476007)(8936002)(52116002)(36756003)(5660300002)(6512007)(7416002)(478600001)(2616005)(4326008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EFfz3xej4BGUebUxu56qTUOWgKyR/ZL/kB4cz6fAvrbMT3dr80YvCMV+j8eu?=
 =?us-ascii?Q?DHuNCGlrMGLg3U3uBdaYXEgfIeauJKXestgFCjQs+eLc2hdvU5EQ9RfoRBjG?=
 =?us-ascii?Q?RHs8nfhVLKLwBKIQf4gVABcfSHyWWSCB+L/hHiNRIf4zdJGU1hRJ8OUITyWB?=
 =?us-ascii?Q?PtR21n54AsDSCMNyU/R9UjR2Rmmy6tAY590n+Ivvaq9V3nKtXsRODvGEXiUE?=
 =?us-ascii?Q?NYqJNvGKZUw8BS7tQX7EQQWBfmhSOQ74Q2sSe/WT1acMEQh0H6hU3K8zg2zC?=
 =?us-ascii?Q?Q4NbX3oxZLvYMbTB6crkS/DVPSQ5aQzmHEXksTyw3b326bJfoi5/eatbnx5n?=
 =?us-ascii?Q?B86GQqK0avFLi2r+vqMTBpforvzDJrKJ5DnSKkJX/5rz7ZLE6FWpEppmBo1B?=
 =?us-ascii?Q?wnd1rKT4gbFp2anR9nVaeoH3iSL7Kacl68U4yTQ+RBlggoKCHwq2gHOVPO0L?=
 =?us-ascii?Q?hT5DjZ93Arp3w+kAQbOuyFaOEcPEt0kuY/HxLKo2Ff6TnjRb+b05PoVp1lh9?=
 =?us-ascii?Q?cKlQQVZqDmZ67kLaiqlGIe3lC0rqrjMlnHPmgvbMeRRDCGJw1xMiv7Ohpze4?=
 =?us-ascii?Q?uzcCJGYV3OGvkuzwh0HRKtIjElBg8oEgK+yA0yvkRaMtu+BDjiXkC2U/l9cp?=
 =?us-ascii?Q?aw0IJYXh0I4QZW90v32mMenqyL5newb3uMts7AKl9LxY4M57SsWywgkyjAfB?=
 =?us-ascii?Q?1M0axlKGVE2gSdZyzcS2gQRUvBBTPXdO42/2LErIii4aLPjd+dp+R1kePtdT?=
 =?us-ascii?Q?sradBroR/HWQS0PNSIVPgP6LBpYPXIGe5PFsDNdrXYsvGp8bb14ivI5Z5xnt?=
 =?us-ascii?Q?XUGnjvRCkzCNEhdN4dUnRDOCmupfyU6BrGGmcGUI4skgCnWcHUDtJv1S+vsx?=
 =?us-ascii?Q?t6VPrm6QH6JmE0tcZOGbyXZ3lWP5TAlIpd3upWoRNfgN2XGTWKJG3LlgYGrI?=
 =?us-ascii?Q?2SgpF2orFEtgpjCQpbkZowt33/awF9eo2mNPz1bLOrwzr+IrtsiphczQE8d4?=
 =?us-ascii?Q?NnEj+ci4AM4VOKiqNMmo/1k/Wd5Yhb/mTrJgg6bNn+gjtRFTYiyB9pq02LPI?=
 =?us-ascii?Q?LGlU8Z3rTJnkaCnTmyTtB/guwDqzBsMjAE+uVN8PGSlAhHZLnM8bBArxcBYp?=
 =?us-ascii?Q?AWHD7ESliTiBb5mkaK7sjA+FJylTYOKSbz40W8xHBwrmiYHbHlTscm+QJaTN?=
 =?us-ascii?Q?mHc4K8jSIr8H3y5rmPq7hunUs+5Au0rxp4m2hN/mlB6tsb6zwJqmEGuMhze2?=
 =?us-ascii?Q?XFxgcFHl+braskEVcskyZD18CzH58s/chPAlggDDOF3F/DTZP4tzkHzSEDiV?=
 =?us-ascii?Q?oBXjy1Y+Qti6tdOFnleWmaIL?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27570c4f-0d61-4d69-2bb4-08d8e8f21380
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4202.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 03:09:28.2490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5A7tBmarlMmFnbexW8D1H5SMUuL6jhGogHuHhMMEq3MIGR28oTat9u+JHNFTWpOcsQJyI2NPJ9NOvSoJPyb2KX+Ve9EQYtkbbtY8gKuq+T4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4739
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

The syzbot report a memleak follow:
BUG: memory leak
unreferenced object 0xffff888101b41d00 (size 120):
  comm "kworker/u4:0", pid 8, jiffies 4294944270 (age 12.780s)
  backtrace:
    [<ffffffff8125dc56>] alloc_pid+0x66/0x560
    [<ffffffff81226405>] copy_process+0x1465/0x25e0
    [<ffffffff81227943>] kernel_clone+0xf3/0x670
    [<ffffffff812281a1>] kernel_thread+0x61/0x80
    [<ffffffff81253464>] call_usermodehelper_exec_work
    [<ffffffff81253464>] call_usermodehelper_exec_work+0xc4/0x120
    [<ffffffff812591c9>] process_one_work+0x2c9/0x600
    [<ffffffff81259ab9>] worker_thread+0x59/0x5d0
    [<ffffffff812611c8>] kthread+0x178/0x1b0
    [<ffffffff8100227f>] ret_from_fork+0x1f/0x30

unreferenced object 0xffff888110ef5c00 (size 232):
  comm "kworker/u4:0", pid 8414, jiffies 4294944270 (age 12.780s)
  backtrace:
    [<ffffffff8154a0cf>] kmem_cache_zalloc
    [<ffffffff8154a0cf>] __alloc_file+0x1f/0xf0
    [<ffffffff8154a809>] alloc_empty_file+0x69/0x120
    [<ffffffff8154a8f3>] alloc_file+0x33/0x1b0
    [<ffffffff8154ab22>] alloc_file_pseudo+0xb2/0x140
    [<ffffffff81559218>] create_pipe_files+0x138/0x2e0
    [<ffffffff8126c793>] umd_setup+0x33/0x220
    [<ffffffff81253574>] call_usermodehelper_exec_async+0xb4/0x1b0
    [<ffffffff8100227f>] ret_from_fork+0x1f/0x30

after the UMD process exits, the pipe_to_umh/pipe_from_umh and tgid
need to be release.

Fixes: d71fa5c9763c ("bpf: Add kernel module with user mode driver that populates bpffs.")
Reported-by: syzbot+44908bb56d2bfe56b28e@syzkaller.appspotmail.com
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
---
 v1->v2:
 Judge whether the pointer variable tgid is valid.
 v2->v3:
 Add common umd_cleanup_helper() and exported as
 symbol which the driver here can use.

 include/linux/usermode_driver.h       |  1 +
 kernel/bpf/preload/bpf_preload_kern.c | 15 +++++++++++----
 kernel/usermode_driver.c              | 18 ++++++++++++++----
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/include/linux/usermode_driver.h b/include/linux/usermode_driver.h
index 073a9e0ec07d..ad970416260d 100644
--- a/include/linux/usermode_driver.h
+++ b/include/linux/usermode_driver.h
@@ -14,5 +14,6 @@ struct umd_info {
 int umd_load_blob(struct umd_info *info, const void *data, size_t len);
 int umd_unload_blob(struct umd_info *info);
 int fork_usermode_driver(struct umd_info *info);
+void umd_cleanup_helper(struct umd_info *info);
 
 #endif /* __LINUX_USERMODE_DRIVER_H__ */
diff --git a/kernel/bpf/preload/bpf_preload_kern.c b/kernel/bpf/preload/bpf_preload_kern.c
index 79c5772465f1..356c4ca4f530 100644
--- a/kernel/bpf/preload/bpf_preload_kern.c
+++ b/kernel/bpf/preload/bpf_preload_kern.c
@@ -61,8 +61,10 @@ static int finish(void)
 	if (n != sizeof(magic))
 		return -EPIPE;
 	tgid = umd_ops.info.tgid;
-	wait_event(tgid->wait_pidfd, thread_group_exited(tgid));
-	umd_ops.info.tgid = NULL;
+	if (tgid) {
+		wait_event(tgid->wait_pidfd, thread_group_exited(tgid));
+		umd_cleanup_helper(&umd_ops.info);
+	}
 	return 0;
 }
 
@@ -80,10 +82,15 @@ static int __init load_umd(void)
 
 static void __exit fini_umd(void)
 {
+	struct pid *tgid;
 	bpf_preload_ops = NULL;
 	/* kill UMD in case it's still there due to earlier error */
-	kill_pid(umd_ops.info.tgid, SIGKILL, 1);
-	umd_ops.info.tgid = NULL;
+	tgid = umd_ops.info.tgid;
+	if (tgid) {
+		kill_pid(tgid, SIGKILL, 1);
+		wait_event(tgid->wait_pidfd, thread_group_exited(tgid));
+		umd_cleanup_helper(&umd_ops.info);
+	}
 	umd_unload_blob(&umd_ops.info);
 }
 late_initcall(load_umd);
diff --git a/kernel/usermode_driver.c b/kernel/usermode_driver.c
index 0b35212ffc3d..6372deae27a0 100644
--- a/kernel/usermode_driver.c
+++ b/kernel/usermode_driver.c
@@ -140,13 +140,23 @@ static void umd_cleanup(struct subprocess_info *info)
 
 	/* cleanup if umh_setup() was successful but exec failed */
 	if (info->retval) {
-		fput(umd_info->pipe_to_umh);
-		fput(umd_info->pipe_from_umh);
-		put_pid(umd_info->tgid);
-		umd_info->tgid = NULL;
+		umd_cleanup_helper(umd_info);
 	}
 }
 
+/**
+ * umd_cleanup_helper - release the resources which allocated in umd_setup
+ * @info: information about usermode driver
+ */
+void umd_cleanup_helper(struct umd_info *info)
+{
+	fput(info->pipe_to_umh);
+	fput(info->pipe_from_umh);
+	put_pid(info->tgid);
+	info->tgid = NULL;
+}
+EXPORT_SYMBOL_GPL(umd_cleanup_helper);
+
 /**
  * fork_usermode_driver - fork a usermode driver
  * @info: information about usermode driver (shouldn't be NULL)
-- 
2.17.1

