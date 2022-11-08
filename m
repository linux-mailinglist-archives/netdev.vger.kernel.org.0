Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB76620CB6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbiKHJyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiKHJyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:54:38 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036913BC
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 01:54:36 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4N63NQ6V9tz4f3mHv
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 17:54:30 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.102.38])
        by APP4 (Coremail) with SMTP id gCh0CgCXu9hYJ2pj5Ua3AA--.60002S4;
        Tue, 08 Nov 2022 17:54:33 +0800 (CST)
From:   Wei Yongjun <weiyongjun@huaweicloud.com>
To:     Matt Johnston <matt@codeconstruct.com.au>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org
Subject: [PATCH net v2] mctp: Fix an error handling path in mctp_init()
Date:   Tue,  8 Nov 2022 09:55:17 +0000
Message-Id: <20221108095517.620115-1-weiyongjun@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCXu9hYJ2pj5Ua3AA--.60002S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw17JryUtry8Cr47tF13urg_yoW8GFykp3
        s8tr15tr48trsrKrWkAFWDXas8Wr1DGa1UCrWrurWSv34DuryUKF10kFy2gFWUurZYka9I
        vr4Fvr1ayF1qyF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
        c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
        CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
        MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJV
        Cq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBI
        daVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 5zhl50pqjm3046kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

If mctp_neigh_init() return error, the routes resources should
be released in the error handling path. Otherwise some resources
leak.

Fixes: 4d8b9319282a ("mctp: Add neighbour implementation")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Matt Johnston <matt@codeconstruct.com.au>
---
v1 -> v2: fix build warning, added acked-by

 net/mctp/af_mctp.c | 4 +++-
 net/mctp/route.c   | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index b6b5e496fa40..fc9e728b6333 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -665,12 +665,14 @@ static __init int mctp_init(void)
 
 	rc = mctp_neigh_init();
 	if (rc)
-		goto err_unreg_proto;
+		goto err_unreg_routes;
 
 	mctp_device_init();
 
 	return 0;
 
+err_unreg_routes:
+	mctp_routes_exit();
 err_unreg_proto:
 	proto_unregister(&mctp_proto);
 err_unreg_sock:
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 2155f15a074c..f9a80b82dc51 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1400,7 +1400,7 @@ int __init mctp_routes_init(void)
 	return register_pernet_subsys(&mctp_net_ops);
 }
 
-void __exit mctp_routes_exit(void)
+void mctp_routes_exit(void)
 {
 	unregister_pernet_subsys(&mctp_net_ops);
 	rtnl_unregister(PF_MCTP, RTM_DELROUTE);
-- 
2.34.1

