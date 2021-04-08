Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CA83587F8
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 17:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhDHPPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 11:15:08 -0400
Received: from mail-eopbgr40131.outbound.protection.outlook.com ([40.107.4.131]:57927
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231843AbhDHPPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 11:15:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBY0jrTypO/BFICUnsVljcXrf1+dW3RJ1ZKHX2aWi0UIBEDI4GOIIoIM1rT1/y0hSMwSbq4AzDaezVWBs9mrykN5hDQP0FlT4IP7OjFhZlW60+xEuLDIVNqpwiKdYz89hT5ul02MvVf6bTysgE/MYSx2y/zRHhltgmOfnreBGviBHPkFGv9Mfsp8A8DewovxMYRnIJ0/OZuxykjMSs3qB6ocR6GykAF0sVo99C1WnmNTSIZTInQVyTrCpXF8bQOQYMqbcNkTjuoDvGjN0bpXie6FGF6a67/0KONEaK8dkjNQQws06hOgb6bGG2odUct+BvqL5hYt65h/+kex/GGm2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxMZh4lYNGMQ2hdcKyybMt0r/TdEXzI/Lioa5D7B1Jg=;
 b=e2OhfMlTW3A9M5hGMoP9dWu4GSJUYf0WT0d4vYZq/gfKCBO13duBzdBGDtKOJuPKovSEMDIy6aFA4+xbnE+mlOBx0jXjMqZJURHp1/kVZMvhhwkdn8Ez4UINU1egsHn6HrRmlzAuzlFcF1+yQ8bmhjDZeuu957u7PwtlwmVMJ7K1KXK6SAmmU1TDfl875ooX+P4wXtGM8/TH+k/w3AOtxiSFnStkRg2DQOwW/c9mrXGZksBEGfX44hJ9idyK7JUOC5gSr66DdSHDFisVxGUDNPFObUljjzxeosbk2pmoK8xRJMQyebML3oylgXApuF4RquRigX6RIHO/3O31lBCoTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxMZh4lYNGMQ2hdcKyybMt0r/TdEXzI/Lioa5D7B1Jg=;
 b=RgSQAfzf8WvuDTFhzBSJ5p6mj8YuS31FJMWL7G5vKW/j1jseU8RiRImEGyJIsu43oD0c9HoVl2auI3AEhbkYA204RmeJ3itv9VkBfKf6uj0ph5iqAP5VfrF/PqaANFmm9/6CIqqIJWEjhrwpdpwRCYHm+AEBzRSdCyBOVM4Zwf0=
Authentication-Results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com (2603:10a6:803:114::19)
 by VI1PR08MB2894.eurprd08.prod.outlook.com (2603:10a6:802:1c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 8 Apr
 2021 15:14:50 +0000
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::d1ec:aee1:885c:ad1a]) by VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::d1ec:aee1:885c:ad1a%5]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 15:14:50 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: [PATCH] net: sched: sch_teql: fix null-pointer dereference
Date:   Thu,  8 Apr 2021 18:14:31 +0300
Message-Id: <20210408151431.9512-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [81.200.17.122]
X-ClientProxiedBy: AM3PR07CA0075.eurprd07.prod.outlook.com
 (2603:10a6:207:4::33) To VE1PR08MB4989.eurprd08.prod.outlook.com
 (2603:10a6:803:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (81.200.17.122) by AM3PR07CA0075.eurprd07.prod.outlook.com (2603:10a6:207:4::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend Transport; Thu, 8 Apr 2021 15:14:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4791d0a7-6b2e-4aca-caa0-08d8faa10d92
X-MS-TrafficTypeDiagnostic: VI1PR08MB2894:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB289412F37B8BC7593F0E9CE9B7749@VI1PR08MB2894.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ghgnooPgJIQsjW0OpjeRx/RbudxxnuMwd8vF2dbexAJj892qn6rZ0ZXefmSlIXIS9WQ4EKa8FUrZpV1NLYbWsPxQbTsU5/q6S5lRz3aaViEu3C9dN7WYsPd6f+1PlnlViJjKuO0PG+x/pxC6Nbjl/K8z/PXQGMPWCkONQBWTYsa8MR7lt/xveLIkVgr1WlkW9SKnYJrml1SCeffj5UMYQ9XTumobnxVWKcKeDMZpgtKZ+zPNEsgd8MwDzbay6oY2r/v8T81iM3OLXxElNXrOwVlW0sdU/uBR5tCGULZalycJI0an9aduI6Di4YbU+eYjtLD0s28WjqNC3ZXiwlWm4fULrqGDQUlyEmIhMr+P9rpNxKgReI1PXpLYxBW0lgrKUKAAv6rFRn3sl93WMB+9aywQm0tcNyyB3wiP+pVR0l2AC7EzLt+0llBFV4PHl3lv+gRn9hjnCGT/R1DZlOO4SD77xapJlc0gLj38L+vntqdWevTFJHvRQvUgnpjqZpwzRa8h/uwhyNCzXf0+necfhfgxjgJSopox2f7PnWePlFeHZaLSUddpXNuSveDAGVVr8zA9l4xcr8WQv58wzw6Yx41bt2yoO49Y8QpCVWkIVM7jDs8vr9sA6qfhFM5y8qnkit7PG/L/zgWQDPv6B24hIb+0RIaHJJC2xEvqiW79LSHbziAVpTz3VfRRYdDk/pnrdyZwLFydq92+rHVfRrkLrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4989.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39840400004)(366004)(8936002)(38100700001)(54906003)(8676002)(66946007)(66476007)(2906002)(86362001)(186003)(16526019)(6666004)(38350700001)(69590400012)(4326008)(26005)(478600001)(6512007)(6506007)(66556008)(52116002)(956004)(2616005)(36756003)(316002)(107886003)(110136005)(1076003)(5660300002)(6486002)(45080400002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+F+2T2ns6ChGeJjeN4o4S3x9R2wpVROH/HTLV0gvhsihBN5ScOKboFzXY4lX?=
 =?us-ascii?Q?gGr4TQynGdYYCgciJg5HtTIau7BYDoYlLceBthuC55q71nbeZGVG6jmCzoNZ?=
 =?us-ascii?Q?3Hd46L0RiX687swFPu0vPZHc+VnT/lH9on+XvTckufWNEVAyPTvaqyT7d3zZ?=
 =?us-ascii?Q?Avd9Gzv5tlyMOAe03Bs0rnjwi9Vp28q/XgR+zRdOy+dUrBZas2E7SIv+1RT5?=
 =?us-ascii?Q?oIYVmxZcI/nKrNGVA03Xd6kr9FqB86Js6ByOgpZPviyz/2eIzuL/WGeieuFg?=
 =?us-ascii?Q?hWjC5x6aasfKZOjQyojuzDkrFR89/fkAH4Fpw42rkle1C5I3BGHuVDid2YGN?=
 =?us-ascii?Q?qoQUlR95xWzKbQhtgqIF97OXTSB49rjW1eAUgpvg3DoE2chhpVRBi3HfJDj/?=
 =?us-ascii?Q?coxN8zc5+DXQhCk8Bs5dDg8crfQ2jFejRb6NOCOkRiOKjyVPLy68wP1HJgaA?=
 =?us-ascii?Q?kw7Amxkan0gEFkX8HpL5Q+smtSZOXVjdzdlHLE/JIdoDtfJ3bFGMC9idnK9d?=
 =?us-ascii?Q?QuO1TPvCntiqvM9jm/A0JzaHKmctLEffZCIQiUA4LO9Ys0tOZVfKf8C9y3wj?=
 =?us-ascii?Q?tUkBXcQh0/ffT6Zm5HtBMquoPp9xAq/8G2XIE4d14wSv+nev0L234uzsZR24?=
 =?us-ascii?Q?kwJg+D6p5nOIVcs2PaF93NF0qL7tc0QjxlNYpGwEy8gUAkvWzYT55NHUfy7e?=
 =?us-ascii?Q?0rYAHQD1AFFL9QT4opH84eliSEZRQ2xISZJOv/0YwF4nEOBsZXpTOe0jc81+?=
 =?us-ascii?Q?3K1hYD6zyQb0+1HlpZe3qlhlW3EfyjEqRXl3oqbj3rjrziivZMW9zF7Rlsh0?=
 =?us-ascii?Q?c0OeGF3S86WMUgxyNavlY9SqtasqmJJ9asaIIQ3lKgMG+bWhWNxVrBh9HAlN?=
 =?us-ascii?Q?EfpNeCiQ2svH2CJ7rn2nXBUS1/AY3/cnwmREg5BOxYftbV8zQJVaZiSOj2fL?=
 =?us-ascii?Q?Zt6bSQ+KGikcGxmmsJm7pWHmp7h0okPWrtkcX/L/ysp84UDoQlPim/lb7LLC?=
 =?us-ascii?Q?J3RGkjlDHSV5bgprpV1Vhd9QGm9NmMoNcNplbkasVFUw638l6xcPp2zGymga?=
 =?us-ascii?Q?3IFsXjGwfwGRyinRkp4yrumn2idjWf66RaZ45Nh7UQuW7/1djNOU7pYSSECV?=
 =?us-ascii?Q?42BWvO+t/h0HvZnSLYjdv5LHGsEGIAGHAr59F8umyBVGlz+fAkttmpV2To0k?=
 =?us-ascii?Q?2OgV89728Jb/kdM0ABgb2Wlgh7J/sTEt0PkZgd8Opin0UmnjJGoYdzYvhLZQ?=
 =?us-ascii?Q?8AaRrmaojltxR5Bpq7eNZ+QGfUK+6Sr87nGAd5TKFCYtQkDCh3JvzYAf3HFA?=
 =?us-ascii?Q?3VIMnIsW6xMR203UoNOQGxEk?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4791d0a7-6b2e-4aca-caa0-08d8faa10d92
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4989.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 15:14:49.9636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUEApATtvQFZgLXjhW5LVQQoY9EDOkXnO7Y2zl+418CuBVQhufnKnsB/+v6z32WGhZQKqASOMCJhGw4ByT6HWGQZviE93pWlQ57SaMTcBsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB2894
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reproduce:

  modprobe sch_teql
  tc qdisc add dev teql0 root teql0

This leads to (for instance in Centos 7 VM) OOPS:

[  532.366633] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
[  532.366733] IP: [<ffffffffc06124a8>] teql_destroy+0x18/0x100 [sch_teql]
[  532.366825] PGD 80000001376d5067 PUD 137e37067 PMD 0
[  532.366906] Oops: 0000 [#1] SMP
[  532.366987] Modules linked in: sch_teql ...
[  532.367945] CPU: 1 PID: 3026 Comm: tc Kdump: loaded Tainted: G               ------------ T 3.10.0-1062.7.1.el7.x86_64 #1
[  532.368041] Hardware name: Virtuozzo KVM, BIOS 1.11.0-2.vz7.2 04/01/2014
[  532.368125] task: ffff8b7d37d31070 ti: ffff8b7c9fdbc000 task.ti: ffff8b7c9fdbc000
[  532.368224] RIP: 0010:[<ffffffffc06124a8>]  [<ffffffffc06124a8>] teql_destroy+0x18/0x100 [sch_teql]
[  532.368320] RSP: 0018:ffff8b7c9fdbf8e0  EFLAGS: 00010286
[  532.368394] RAX: ffffffffc0612490 RBX: ffff8b7cb1565e00 RCX: ffff8b7d35ba2000
[  532.368476] RDX: ffff8b7d35ba2000 RSI: 0000000000000000 RDI: ffff8b7cb1565e00
[  532.368557] RBP: ffff8b7c9fdbf8f8 R08: ffff8b7d3fd1f140 R09: ffff8b7d3b001600
[  532.368638] R10: ffff8b7d3b001600 R11: ffffffff84c7d65b R12: 00000000ffffffd8
[  532.368719] R13: 0000000000008000 R14: ffff8b7d35ba2000 R15: ffff8b7c9fdbf9a8
[  532.368800] FS:  00007f6a4e872740(0000) GS:ffff8b7d3fd00000(0000) knlGS:0000000000000000
[  532.368885] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  532.368961] CR2: 00000000000000a8 CR3: 00000001396ee000 CR4: 00000000000206e0
[  532.369046] Call Trace:
[  532.369159]  [<ffffffff84c8192e>] qdisc_create+0x36e/0x450
[  532.369268]  [<ffffffff846a9b49>] ? ns_capable+0x29/0x50
[  532.369366]  [<ffffffff849afde2>] ? nla_parse+0x32/0x120
[  532.369442]  [<ffffffff84c81b4c>] tc_modify_qdisc+0x13c/0x610
[  532.371508]  [<ffffffff84c693e7>] rtnetlink_rcv_msg+0xa7/0x260
[  532.372668]  [<ffffffff84907b65>] ? sock_has_perm+0x75/0x90
[  532.373790]  [<ffffffff84c69340>] ? rtnl_newlink+0x890/0x890
[  532.374914]  [<ffffffff84c8da7b>] netlink_rcv_skb+0xab/0xc0
[  532.376055]  [<ffffffff84c63708>] rtnetlink_rcv+0x28/0x30
[  532.377204]  [<ffffffff84c8d400>] netlink_unicast+0x170/0x210
[  532.378333]  [<ffffffff84c8d7a8>] netlink_sendmsg+0x308/0x420
[  532.379465]  [<ffffffff84c2f3a6>] sock_sendmsg+0xb6/0xf0
[  532.380710]  [<ffffffffc034a56e>] ? __xfs_filemap_fault+0x8e/0x1d0 [xfs]
[  532.381868]  [<ffffffffc034a75c>] ? xfs_filemap_fault+0x2c/0x30 [xfs]
[  532.383037]  [<ffffffff847ec23a>] ? __do_fault.isra.61+0x8a/0x100
[  532.384144]  [<ffffffff84c30269>] ___sys_sendmsg+0x3e9/0x400
[  532.385268]  [<ffffffff847f3fad>] ? handle_mm_fault+0x39d/0x9b0
[  532.386387]  [<ffffffff84d88678>] ? __do_page_fault+0x238/0x500
[  532.387472]  [<ffffffff84c31921>] __sys_sendmsg+0x51/0x90
[  532.388560]  [<ffffffff84c31972>] SyS_sendmsg+0x12/0x20
[  532.389636]  [<ffffffff84d8dede>] system_call_fastpath+0x25/0x2a
[  532.390704]  [<ffffffff84d8de21>] ? system_call_after_swapgs+0xae/0x146
[  532.391753] Code: 00 00 00 00 00 00 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 41 55 41 54 53 48 8b b7 48 01 00 00 48 89 fb <48> 8b 8e a8 00 00 00 48 85 c9 74 43 48 89 ca eb 0f 0f 1f 80 00
[  532.394036] RIP  [<ffffffffc06124a8>] teql_destroy+0x18/0x100 [sch_teql]
[  532.395127]  RSP <ffff8b7c9fdbf8e0>
[  532.396179] CR2: 00000000000000a8

Null pointer dereference happens on master->slaves dereference in
teql_destroy() as master is null-pointer.

When qdisc_create() calls teql_qdisc_init() it imediately fails after
check "if (m->dev == dev)" because both devices are teql0, and it does
not set qdisc_priv(sch)->m leaving it zero on error path, then
qdisc_create() imediately calls teql_destroy() which does not expect
zero master pointer and we get OOPS.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 net/sched/sch_teql.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 2f1f0a378408..6af6b95bdb67 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -134,6 +134,9 @@ teql_destroy(struct Qdisc *sch)
 	struct teql_sched_data *dat = qdisc_priv(sch);
 	struct teql_master *master = dat->m;
 
+	if (!master)
+		return;
+
 	prev = master->slaves;
 	if (prev) {
 		do {
-- 
2.30.2

