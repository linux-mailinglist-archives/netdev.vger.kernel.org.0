Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F686467A8
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 04:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiLHDZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 22:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLHDZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 22:25:15 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40AD880FF;
        Wed,  7 Dec 2022 19:25:14 -0800 (PST)
Received: from dggpemm500013.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NSKFK05lBzJp6x;
        Thu,  8 Dec 2022 11:21:41 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 11:25:12 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <syzbot+2f9183cb6f89b0e16586@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>, <netdev@vger.kernel.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <chenzhongjin@huawei.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <gregkh@linuxfoundation.org>
Subject: [PATCH net] net/sched: Fix memory leak in tcindex_set_parms
Date:   Thu, 8 Dec 2022 11:22:16 +0800
Message-ID: <20221208032216.63513-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller reported a memleak:
https://syzkaller.appspot.com/bug?id=e061e6cd46417ee6566dc249d8f982c0b5977a52

unreferenced object 0xffff888107813900 (size 256):
  backtrace:
    kcalloc include/linux/slab.h:636 [inline]
    tcf_exts_init include/net/pkt_cls.h:250 [inline]
    tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
    tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
    tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
    ...

The reproduce calls tc_new_tfilter() continuously:

tc_new_tfilter()...
tcindex_set_parms()
  tcf_exts_init(&e, ...) // alloc e->actions
  tcf_exts_change(&r->exts, &e)

tc_new_tfilter()...
tcindex_set_parms()
  old_r = r // same as first r
  tcindex_filter_result_init(old_r, cp, net);
  // old_r is holding e->actions but here it calls memset(old_r, 0)
  // so the previous e->actions is leaked

So here tcf_exts_destroy() should be called to free old_r->exts.actions
before memset(old_r, 0) sets it to NULL.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: syzbot+2f9183cb6f89b0e16586@syzkaller.appspotmail.com
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
#syz test https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 355479c70a48
---
 net/sched/cls_tcindex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 1c9eeb98d826..00a6c04a4b42 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -479,6 +479,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	}
 
 	if (old_r && old_r != r) {
+		tcf_exts_destroy(&old_r->exts);
 		err = tcindex_filter_result_init(old_r, cp, net);
 		if (err < 0) {
 			kfree(f);
-- 
2.17.1

