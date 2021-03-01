Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E25432761C
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 03:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhCACel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 21:34:41 -0500
Received: from mail-mw2nam12on2079.outbound.protection.outlook.com ([40.107.244.79]:8544
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231747AbhCACej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 21:34:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZZKVNCT0bZSVlw/MAS9p8ZP5sDM9N3uid0zVjCP4O7X/4cwq1zoUSBZdUjSDQBcmnUudMtq01CI4P8+IiLiLuM20Mq+Or3/91ny0P7yA0v+nq0xQrTOrznuvsdxhIO9MvemoMJkwadKPoUTSTWisNP1Pxts8l/oHg8l99dlNa2AJt91mOWGuYoU8lm/6vZ6cRjE2qQJismTivinyccmAYHZ3xwyb8xFqULF8KnZkMkePlabcPsbK60VUq/kAb94ULXh13BTxf9gCe5KtfwuIESkGO5AXpHCqUvYDFWNnnjiZ4gpT2f/FsW4gaX7lYb1aJn8hqX5joMmD5pRRvpwLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y68FJWgF9ovD1ROywsEIw1ILtlGsgqE8kPR5HEpJ6e0=;
 b=SSv+GQ+BHdd00B9SOmWFRBHCmTo6WLPeeWCIZX4i1TKXwZn4i+ZpfBQ3I+rezDJtWCaaVep9FaBN6DW+VH0hVUsD1UPnMThmy11fm8gO5QtXEfMrBaFxgWkxgnnCzR9oH64boE1P43p7UId0Pm1owHFEFf4J0FmpcRtuhlKbQl9qWninGPzgZNO3TwtUxTL8Tz0USFlY2QLblewCBg6LVVIA/c5+yXjmBYtNzUkVAHNynDzGy0Dek5Lj2HhxYLJo7dyWJRIeUCYWlTbFX4qm3Ha1ZpOA8ydhi2U6v+HVn97hhH2H+xFerzIlLIJYCSceopJeTjJxkptAmh98RutwdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y68FJWgF9ovD1ROywsEIw1ILtlGsgqE8kPR5HEpJ6e0=;
 b=kw+RZDaPu1CCtDt/LvSBHUWD7hiHxJ0KHBkdTbKPlh3ZzQnflWLNPMMBpxvZRKp4tqYQqqbuV6bms9vnLTi31tRtmB+CRu1c3CYZ+aSr9jnNCCpuJRRIRi9dPlNTFwbFwLrVQFhTVELPBHqhMoY1YByq/pKAtfXp1kyJGBo2TsI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synaptics.com;
Received: from BN3PR03MB2307.namprd03.prod.outlook.com
 (2a01:111:e400:7bb1::16) by BN7PR03MB3602.namprd03.prod.outlook.com
 (2603:10b6:406:c9::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Mon, 1 Mar
 2021 02:33:49 +0000
Received: from BN3PR03MB2307.namprd03.prod.outlook.com
 ([fe80::246d:2f3d:93bf:ee56]) by BN3PR03MB2307.namprd03.prod.outlook.com
 ([fe80::246d:2f3d:93bf:ee56%4]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 02:33:49 +0000
Date:   Mon, 1 Mar 2021 10:33:36 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: 9p: free what was emitted when read count is 0
Message-ID: <20210301103336.2e29da13@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: SJ0PR13CA0075.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::20) To BN3PR03MB2307.namprd03.prod.outlook.com
 (2a01:111:e400:7bb1::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by SJ0PR13CA0075.namprd13.prod.outlook.com (2603:10b6:a03:2c4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Mon, 1 Mar 2021 02:33:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b909d05-0c4d-4639-3b33-08d8dc5a7205
X-MS-TrafficTypeDiagnostic: BN7PR03MB3602:
X-Microsoft-Antispam-PRVS: <BN7PR03MB3602C3A1EA26045A3D66C0AAED9A9@BN7PR03MB3602.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +D5/MA2DKmFbn3Zw7vkBpvuxl/Fuzus7/uUyzwn1gp6LLKiWQTOB3Tbwp0UZUHhR56qO0Sn5tzbb6rOjII6EL2z9oCfOxpuBGBpRdDEmHpT+2YbNe34gSWZ8BofRcMit622TvXgN3fLmjnO8y0hAkRmqdRiMQvU7fKZqE6ptGfAcrEftdtgsbRGbo0G300lTww5nBODdlps/cotcsxqYIksNB/8WahyEyWsO1UXX68c49WPsnhEPF7c54vi1kDwmewrRvpXf2MTZqqDYrKwUUln5Xr18Sh1S0Zc+vC1nwD4x1ygsZj5TnX91e2D7gDiRmxbAcGhP3hvLgRYYp8pY7ihSy3SCJaYwOtlJG2fgEWe7B31NkdlHApcPHGA04J3p45lmQ7Y8QKMoJlyCOKiG0neOY0cTO7jazFsGuaaAJ4n87LM4lUkfEGNDtz/p4OAz2PAz1Gb7dr67qe7ET9Lt6jpiX8Xvg/r5Uh5Iz2W+2RtHBH1qscS6NLtnRePJfXLpk/wPIORI82cGKY7hZcXZsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN3PR03MB2307.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39850400004)(366004)(396003)(136003)(66946007)(8676002)(66556008)(478600001)(8936002)(186003)(26005)(1076003)(956004)(55016002)(5660300002)(66476007)(16526019)(6666004)(4326008)(9686003)(45080400002)(86362001)(83380400001)(110136005)(6506007)(52116002)(2906002)(7696005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LDgukMj6bYbMU4IoS5uJ9PyVZF5wlPCACXHAHplXDo3IIv4yGYq9UyEkiDDE?=
 =?us-ascii?Q?3jCPTP/8xqG5qFjuv3m24wSthJQGzO7lw2++RYE0YH623EALMyojV3yDjEzY?=
 =?us-ascii?Q?LMf//XQ46FEjaW4fEgTebxQVGCUf4MnMOqslXvqytTF7aKoQW9n5RdLs+Dgx?=
 =?us-ascii?Q?EAsDhCLuoWfJRg6ppWNJYjqTvqXgMFq9EWGsToZhx1QhuH8lnOZj357mcstP?=
 =?us-ascii?Q?JwdDA9tqUYMgFzf0MEbpO5wFnaKUnT9WfH6L22PTQ2s61RAGqI5ylpp+LPKt?=
 =?us-ascii?Q?K3zkM/xkYsl7iDgZkYgMZ3xs3xT72SJgs9QTCUmc/0OUZpfpRjcMkPwbJt8b?=
 =?us-ascii?Q?aUrV9md2TT72iLJ88PCQ1/Rd8qZ3Nd0yFsdhQuLR4jEq4+LqTc0T7ub0sC2N?=
 =?us-ascii?Q?s6XWdPVqLALVE0wt4GKTUvpq67DvQaDTEwAi029CxAP7gM48GHFUimzQyH82?=
 =?us-ascii?Q?2/JC0Xx5NiA/6+5ohaumqa4qox8wawg4VmctIeVJEe3q94OVbmKID6VqCdHx?=
 =?us-ascii?Q?wTKjeGCszT0F+kcVmyW756tbwrlIFuHZSUxCZ6NVs1uy9fkwPhk4o+CRJ7KF?=
 =?us-ascii?Q?u2tLvXS8sXrSB+Tfd4VbX/zFaVqjuWsZogZDnPOCrLMVp/rN2LP0A7UnEclM?=
 =?us-ascii?Q?IrwKH7NCJAGtDSeQH2Skqwj6M5dpX7N5ppLXVzLyqJ/2VqbqeKCAo7UInISc?=
 =?us-ascii?Q?w7TQprlNuOsebMOI9aNwXroOYqncffuioDekdbGf+21qvLRUC+qhewyAPR3Z?=
 =?us-ascii?Q?1nbhQYr7YYJI7bWkiB7MJWOV65qCE8bAiVHDp2Q9H6HiuJ1SaX8M/AnK0Yyp?=
 =?us-ascii?Q?zbeD0/mGcgHs9q6AJYVF75WXaHti19anEeGx0iR3tj+inf/18WX+1KWr6OrQ?=
 =?us-ascii?Q?mX1p6U+MI/tcjQAXCGYNE7hrDybik0lcmpXJ2HwI64EK0GiBida6j1sbOsVL?=
 =?us-ascii?Q?nYV8FB7HfWU6xT4vYH5Uodh7A4r8hboKPH87srcEuMHhfkro+3SzXzGDYPgz?=
 =?us-ascii?Q?oXNt+wJo0/6oWdBsatVTkuTEOdfVqvAhLhzynS2HtYCno6yOFlFhAesKfdMy?=
 =?us-ascii?Q?eswlsfOcvzvpvuGQPjVm0Wh0YetLeKCWB/WtB8qSl+YMIjiOkiaW1zQW1VnT?=
 =?us-ascii?Q?mL1ZDWsfAQ2f+zyTgp4QzAI6Mf9BWoRCN3051fe0TBwdPxVPcUyq9L7HgkDG?=
 =?us-ascii?Q?xBvEWK8G9FQdPXZrJNRBT6pypY7HdlGtuPx7vr/cIH9+UiZ9xBhu2Id3AqCQ?=
 =?us-ascii?Q?DlP6c7t2CkckpF5HlSNSzVvrN5ED+mO1yuGq9zdpxFYzze+a0nsZBMiIHCLb?=
 =?us-ascii?Q?piHefC1kDzGLFmKZ9/F1jFZP?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b909d05-0c4d-4639-3b33-08d8dc5a7205
X-MS-Exchange-CrossTenant-AuthSource: BN3PR03MB2307.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2021 02:33:49.1957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A/7FPsZ0K/r91B2f5piQSRMiZMVTs7jc+VGbYdlxQu5/qTYwrLuk9PS0oMwiBkfPzritUU41HCUpcCq4+ZibwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB3602
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I met below warning when cating a small size(about 80bytes) txt file
on 9pfs(msize=2097152 is passed to 9p mount option), the reason is we
miss iov_iter_advance() if the read count is 0, so we didn't truncate
the pipe, then iov_iter_pipe() thinks the pipe is full. Fix it by
calling iov_iter_advance() on the iov_iter "to" even if read count is 0

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
 net/9p/client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/9p/client.c b/net/9p/client.c
index 4f62f299da0c..6dc01008cd3b 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1624,6 +1624,7 @@ p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
 
 	p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", count);
 	if (!count) {
+		iov_iter_advance(to, count);
 		p9_tag_remove(clnt, req);
 		return 0;
 	}
-- 
2.30.1

