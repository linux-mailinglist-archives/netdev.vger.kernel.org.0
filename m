Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED9762EFDB
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241545AbiKRIob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241523AbiKRIoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:44:10 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A2910F6;
        Fri, 18 Nov 2022 00:44:01 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ND9Kq4pcXzHvgx;
        Fri, 18 Nov 2022 16:43:27 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 18 Nov
 2022 16:43:59 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-sctp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net] sctp: fix memory leak in sctp_stream_outq_migrate()
Date:   Fri, 18 Nov 2022 16:50:30 +0800
Message-ID: <20221118085030.121297-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sctp_stream_outq_migrate() is called to release stream out resources,
the memory pointed to by prio_head in stream out is not released.

The memory leak information is as follows:
unreferenced object 0xffff88801fe79f80 (size 64):
  comm "sctp_repo", pid 7957, jiffies 4294951704 (age 36.480s)
  hex dump (first 32 bytes):
    80 9f e7 1f 80 88 ff ff 80 9f e7 1f 80 88 ff ff  ................
    90 9f e7 1f 80 88 ff ff 90 9f e7 1f 80 88 ff ff  ................
  backtrace:
    [<ffffffff81b215c6>] kmalloc_trace+0x26/0x60
    [<ffffffff88ae517c>] sctp_sched_prio_set+0x4cc/0x770
    [<ffffffff88ad64f2>] sctp_stream_init_ext+0xd2/0x1b0
    [<ffffffff88aa2604>] sctp_sendmsg_to_asoc+0x1614/0x1a30
    [<ffffffff88ab7ff1>] sctp_sendmsg+0xda1/0x1ef0
    [<ffffffff87f765ed>] inet_sendmsg+0x9d/0xe0
    [<ffffffff8754b5b3>] sock_sendmsg+0xd3/0x120
    [<ffffffff8755446a>] __sys_sendto+0x23a/0x340
    [<ffffffff87554651>] __x64_sys_sendto+0xe1/0x1b0
    [<ffffffff89978b49>] do_syscall_64+0x39/0xb0
    [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
Reported-by: syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sctp/stream.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index ef9fceadef8d..a17dc368876f 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -70,6 +70,9 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 		 * sctp_stream_update will swap ->out pointers.
 		 */
 		for (i = 0; i < outcnt; i++) {
+			if (SCTP_SO(new, i)->ext)
+				kfree(SCTP_SO(new, i)->ext->prio_head);
+
 			kfree(SCTP_SO(new, i)->ext);
 			SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
 			SCTP_SO(stream, i)->ext = NULL;
@@ -77,6 +80,9 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 	}
 
 	for (i = outcnt; i < stream->outcnt; i++) {
+		if (SCTP_SO(stream, i)->ext)
+			kfree(SCTP_SO(stream, i)->ext->prio_head);
+
 		kfree(SCTP_SO(stream, i)->ext);
 		SCTP_SO(stream, i)->ext = NULL;
 	}
-- 
2.17.1

