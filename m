Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D28E32A3BB
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379013AbhCBJhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 04:37:33 -0500
Received: from mail-dm6nam08on2072.outbound.protection.outlook.com ([40.107.102.72]:23425
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239062AbhCBJUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 04:20:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bIEMZWYEQGHjUnankgqPQc6/rDgUoO7vrBlUFOoVqa5ufYySouNT4djXV9cdaBdWel0KjLZ639gpxd3nOSBQVU52ajp/PMGjI5NUW1/Xbwb74l3KcCLcoHAZcWYzjQAevo6CrJDbQrLhx0TNV03S2kR0E6oLzt+a2koSRCAD9bzzgGeffWs77OCnnuhnPNr6JrZ56RzbX9upouTJY4y7EL1l8K0BZ1/a+YdsZfSWlKwq2vvAeIp5lw2CX4ddBA7xx5jMKhATIjp3Oir8hU6gPN3k0ouY3BCsZv0XTnVEcVLbqAEXQq7ZKCxaXRD12JEtj79UjOvoiqD4AuUkY6QqlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4XQrRfgAynun7UdTuK8NkI8AkgW2+MMxQU7TyEvfK0=;
 b=C6rofvlOAzLb5Tk/1pN2HnJU5yZVowVCOSCyahTUaKZeBz5WY0x80cuNrR5UJ9gIG+KK286cKpeT7hRrhDLumM95UPHUxHbOeOGd4v7An1MEcr8AQm2BguWCm2aNg/YbRuZTtRL/LId/G0wAJuukY0evLsBUFC+loV8V0popV4MBmXWNe0FteInxnp3ZI9druoU2qMw0gjqvhNHaBAB7IbTtv8ZXqYKDvd+1jcnxgB+bLv7F3cwwfQzlkDHYz5cLgTkMhHhuqJKj6KMyriVunJkkdLR+isgRKeSwXtQPCi3NupVvT+hYOzRdPcLU6bHXNCN3Msh9ADW+a3EBGi6CXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4XQrRfgAynun7UdTuK8NkI8AkgW2+MMxQU7TyEvfK0=;
 b=lF3KRlGrP1Nafq5DK6urBkkArzfLBv9WyOd2r47eWAssNtFX2Rrt8fRkUgubicbdrnGOQ+QwAN+yENkWUhxV1HAL//+klMMMh69+hxrSTOtW+MgLx+G0nAz+a1hgAhJ3epqj09anQlpF4g1T2i75u6DVcK7fG5mjG2cSXY2KaYk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synaptics.com;
Received: from BN3PR03MB2307.namprd03.prod.outlook.com
 (2a01:111:e400:7bb1::16) by BN6PR03MB2898.namprd03.prod.outlook.com
 (2603:10b6:404:117::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Tue, 2 Mar
 2021 09:19:46 +0000
Received: from BN3PR03MB2307.namprd03.prod.outlook.com
 ([fe80::246d:2f3d:93bf:ee56]) by BN3PR03MB2307.namprd03.prod.outlook.com
 ([fe80::246d:2f3d:93bf:ee56%4]) with mapi id 15.20.3890.030; Tue, 2 Mar 2021
 09:19:46 +0000
Date:   Tue, 2 Mar 2021 17:19:32 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: 9p: advance iov on empty read
Message-ID: <20210302171932.28e86231@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BYAPR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::30) To BN3PR03MB2307.namprd03.prod.outlook.com
 (2a01:111:e400:7bb1::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BYAPR05CA0017.namprd05.prod.outlook.com (2603:10b6:a03:c0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Tue, 2 Mar 2021 09:19:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c645eeee-38c8-44b7-c689-08d8dd5c5223
X-MS-TrafficTypeDiagnostic: BN6PR03MB2898:
X-Microsoft-Antispam-PRVS: <BN6PR03MB28984509C5F5634565970679ED999@BN6PR03MB2898.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/eYnTzyp2tcBtEavnRm4P7ywRxAW9AV04EB3w2p3SxQm9hKz5ggKKvFUgcB2dn7bET9QiI5IEiQjNibeTvQENMrmgHn9kCcCE0AWpDHKvqXyhwwid7aOYYiSS1Kpt0uYJtkC4RTVqF/Mj9can4LFbpOEeXxiZ23h6L9C8aUwRM31NqwWMkwLdu19b1DMZTW0hIgtA8wVUunOUhpZxteNpo0xnhpm7qSEiNNpZoAs4cMYffOEndf4Am1E3KVACPDLdbT8+FqFqe0do6cZmSnnfceV70s0bKhGgDxL9TPB3WVjN1XuXVu0Yb7waR/kRVgFnfBD/YoHNVe29K1bl+NHIwOYDP/AOdsHLK+cWW+hJWVQCYLx+sdaqT+SxDRNCN1diufYQXF48WnJGgkjj0aZ4IJCqK+lb4+l+b6qs2eandOZ8FYtc0PkoTWHnE3Hd3I55nazN+rYbObs+/ppDHhH8YUK88cvSI7xxW0tneEePfz1FySeT5XlFK0MfxP7J+SF/j3OzvS+Kmtm2VWjIP2Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN3PR03MB2307.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(396003)(346002)(39860400002)(1076003)(2906002)(478600001)(9686003)(6666004)(66946007)(26005)(4326008)(66556008)(45080400002)(5660300002)(6506007)(55016002)(66476007)(86362001)(83380400001)(7696005)(8936002)(52116002)(8676002)(956004)(110136005)(16526019)(186003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2KXOr78df4XWDyGplSklJzCQW+VidWBn5sq5Hvl6ROMksci6UBXrNsa6Pomp?=
 =?us-ascii?Q?Ux65NayhqN9Qlsz/PrqqrKyYYUCw30V7x4EdxBp9q0mdyWcZoU/N3AqeRj1D?=
 =?us-ascii?Q?eFJJ4y9SGPwjqJ2mp8Igo1mnBhNQ2kmdfzcB2Py79KPxlXHt0g0aWsyD8M2Y?=
 =?us-ascii?Q?W4UMg8S72salx9hfIQ9laHDHtGKc/E4dlhWqVyRuOF5wKxV39Z9uwjduhsc3?=
 =?us-ascii?Q?sV1kHG139HGpdJ97c1rOd++vlNqx/3Osr6K0G7wfCDXPzLPDcWHH2LnEciUH?=
 =?us-ascii?Q?b4hiwKvipkNKNA/vkiu0VB7iFi22i95VCUcC2neTE+qgCNPAhOZu0DnIDHJW?=
 =?us-ascii?Q?wh1BuY+Ss9cDr+5J/cnB9an1YYxAeuVLD96+EDzH0W2NWiLXspnj8aUGwHG5?=
 =?us-ascii?Q?8iamIhk16msl0XawW8lu+8s2vzFlcxs6ciDEx7jT3445rUEvGR7ujJACpeMc?=
 =?us-ascii?Q?6d3hyN+TiBh+4otbKUauF1nFWRZRxUYPfIGceGruNyxvzue7A17h0GS4V+qT?=
 =?us-ascii?Q?Zb6ROBfblc8Bx5SR6yz7lMPvQts5URDUKSOoe2C8t6sOS1d+AJQ098BnjoQp?=
 =?us-ascii?Q?0IoRd95XbiCfn1Efg3R8BYwRjC+knCm8odVcAQfqE05hxGU67ND7ElFA821e?=
 =?us-ascii?Q?gQaLx5PsRexafqgTxqn3fQcX2sIphVBADEXcuny0vIczzSNxpbBkCETTe/ST?=
 =?us-ascii?Q?FbY4sy2wtAiIsrOw5eeNYgCFYWSbHUEDWeO+Mdn19p5SOzesCdc0aOTvG9wM?=
 =?us-ascii?Q?gwOFAfQOcsfbH3ABzmB+x1iyjw9wdVrwVd8UFLIH8lNuqsw4DhNZa6Ejliwk?=
 =?us-ascii?Q?nGeo9QmPt4ZIhVeQcUbFhVJtdnxhLtm5hY05peNh7H4FwnmhW5UKj3sRelEU?=
 =?us-ascii?Q?EHTLwlo/tQeHziWG7PZ60tS+t9GfbokLFDFnQoZGfowyM3HKIByZoOPWSsVK?=
 =?us-ascii?Q?4XFw+wpUGilQCIuuq0TkEa8limTefsLujPqDBgC/PozB5t9PTV2fIhtn6ptj?=
 =?us-ascii?Q?Zq6bX9MjtCMlOkHEe5G1MAZrbnKUrw2s4XTEkCp70L+L1OQpZR2WFHiS2JuO?=
 =?us-ascii?Q?vx9QiB88BGj/80x7KG6f6B38jyC24gYc8RsLDhJaZ8h641D4LcABneO9xVC0?=
 =?us-ascii?Q?kTp1My8eQBD8nUAaNLqY1NMFZ4TqX+oh5qhcprq0wl90AP5n0rpqQ4JCRjUv?=
 =?us-ascii?Q?gLEOAzSl32bu5cPM7YIGwOw4Zyx+bmib86eR619NnXIo29mvcWf31tQiCJK9?=
 =?us-ascii?Q?I7ddI9rVTk9D4K4MM7GOnJaLfCBlbJbL8R6rL/GxD87IUao9p841Iw54ZoaP?=
 =?us-ascii?Q?4tXiUmy9kPqVlqDRF/VT3w+b?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c645eeee-38c8-44b7-c689-08d8dd5c5223
X-MS-Exchange-CrossTenant-AuthSource: BN3PR03MB2307.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 09:19:46.0100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5TgPBtFKRSFweAEEp3SatIvEen8WUV3nQFQTk2Cxfwev0jmGsg0E092lK5fsSMHiGEIXdkgKhU8QZc31pzhOAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB2898
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I met below warning when cating a small size(about 80bytes) txt file
on 9pfs(msize=2097152 is passed to 9p mount option), the reason is we
miss iov_iter_advance() if the read count is 0 for zerocopy case, so
we didn't truncate the pipe, then iov_iter_pipe() thinks the pipe is
full. Fix it by removing the exception for 0 to ensure to call
iov_iter_advance() even on empty read for zerocopy case.

[    8.279568] WARNING: CPU: 0 PID: 39 at lib/iov_iter.c:1203 iov_iter_pipe+0x31/0x40
[    8.280028] Modules linked in:
[    8.280561] CPU: 0 PID: 39 Comm: cat Not tainted 5.11.0+ #6
[    8.281260] RIP: 0010:iov_iter_pipe+0x31/0x40
[    8.281974] Code: 2b 42 54 39 42 5c 76 22 c7 07 20 00 00 00 48 89 57 18 8b 42 50 48 c7 47 08 b
[    8.283169] RSP: 0018:ffff888000cbbd80 EFLAGS: 00000246
[    8.283512] RAX: 0000000000000010 RBX: ffff888000117d00 RCX: 0000000000000000
[    8.283876] RDX: ffff88800031d600 RSI: 0000000000000000 RDI: ffff888000cbbd90
[    8.284244] RBP: ffff888000cbbe38 R08: 0000000000000000 R09: ffff8880008d2058
[    8.284605] R10: 0000000000000002 R11: ffff888000375510 R12: 0000000000000050
[    8.284964] R13: ffff888000cbbe80 R14: 0000000000000050 R15: ffff88800031d600
[    8.285439] FS:  00007f24fd8af600(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
[    8.285844] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    8.286150] CR2: 00007f24fd7d7b90 CR3: 0000000000c97000 CR4: 00000000000406b0
[    8.286710] Call Trace:
[    8.288279]  generic_file_splice_read+0x31/0x1a0
[    8.289273]  ? do_splice_to+0x2f/0x90
[    8.289511]  splice_direct_to_actor+0xcc/0x220
[    8.289788]  ? pipe_to_sendpage+0xa0/0xa0
[    8.290052]  do_splice_direct+0x8b/0xd0
[    8.290314]  do_sendfile+0x1ad/0x470
[    8.290576]  do_syscall_64+0x2d/0x40
[    8.290818]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    8.291409] RIP: 0033:0x7f24fd7dca0a
[    8.292511] Code: c3 0f 1f 80 00 00 00 00 4c 89 d2 4c 89 c6 e9 bd fd ff ff 0f 1f 44 00 00 31 8
[    8.293360] RSP: 002b:00007ffc20932818 EFLAGS: 00000206 ORIG_RAX: 0000000000000028
[    8.293800] RAX: ffffffffffffffda RBX: 0000000001000000 RCX: 00007f24fd7dca0a
[    8.294153] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000001
[    8.294504] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
[    8.294867] R10: 0000000001000000 R11: 0000000000000206 R12: 0000000000000003
[    8.295217] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
[    8.295782] ---[ end trace 63317af81b3ca24b ]---

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
Since v1:
 - reword the commit msg
 - fix the issue by removing exception for 0 code path, thank Dominique!

 net/9p/client.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 4f62f299da0c..0a9019da18f3 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1623,10 +1623,6 @@ p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
 	}
 
 	p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", count);
-	if (!count) {
-		p9_tag_remove(clnt, req);
-		return 0;
-	}
 
 	if (non_zc) {
 		int n = copy_to_iter(dataptr, count, to);
-- 
2.30.1

