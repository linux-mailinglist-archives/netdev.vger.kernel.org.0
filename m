Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CA65927F2
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 05:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiHODBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 23:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiHODBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 23:01:15 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5372BD7;
        Sun, 14 Aug 2022 20:01:14 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M5fBH3vdWzmVGL;
        Mon, 15 Aug 2022 10:59:03 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 15 Aug
 2022 11:01:12 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: sched: remove the unused return value of unregister_qdisc
Date:   Mon, 15 Aug 2022 11:04:17 +0800
Message-ID: <20220815030417.271894-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return value of unregister_qdisc is unused, remove it.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/pkt_sched.h | 2 +-
 net/sched/sch_api.c     | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 3372a1f67cf4..29f65632ebc5 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -100,7 +100,7 @@ struct Qdisc *fifo_create_dflt(struct Qdisc *sch, struct Qdisc_ops *ops,
 			       struct netlink_ext_ack *extack);
 
 int register_qdisc(struct Qdisc_ops *qops);
-int unregister_qdisc(struct Qdisc_ops *qops);
+void unregister_qdisc(struct Qdisc_ops *qops);
 void qdisc_get_default(char *id, size_t len);
 int qdisc_set_default(const char *id);
 
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index bf87b50837a8..8b4d575a3bbd 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -171,7 +171,7 @@ int register_qdisc(struct Qdisc_ops *qops)
 }
 EXPORT_SYMBOL(register_qdisc);
 
-int unregister_qdisc(struct Qdisc_ops *qops)
+void unregister_qdisc(struct Qdisc_ops *qops)
 {
 	struct Qdisc_ops *q, **qp;
 	int err = -ENOENT;
@@ -186,7 +186,8 @@ int unregister_qdisc(struct Qdisc_ops *qops)
 		err = 0;
 	}
 	write_unlock(&qdisc_mod_lock);
-	return err;
+
+	WARN(err, "unregister qdisc(%s) failed\n", qops->id);
 }
 EXPORT_SYMBOL(unregister_qdisc);
 
-- 
2.17.1

