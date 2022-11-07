Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E16361F724
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 16:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiKGPGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 10:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbiKGPGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 10:06:31 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13211DF2F
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 07:06:30 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4N5ZLn0r7rz4f3kpT
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 23:06:25 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.102.38])
        by APP4 (Coremail) with SMTP id gCh0CgDH69jzHmljdhqMAA--.23492S4;
        Mon, 07 Nov 2022 23:06:28 +0800 (CST)
From:   Wei Yongjun <weiyongjun@huaweicloud.com>
To:     Matt Johnston <matt@codeconstruct.com.au>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org
Subject: [PATCH net] mctp: Fix an error handling path in mctp_init()
Date:   Mon,  7 Nov 2022 15:27:56 +0000
Message-Id: <20221107152756.180628-1-weiyongjun@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgDH69jzHmljdhqMAA--.23492S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw4kGw18uFyUuw1rtFy8uFg_yoW3Wwc_ta
        sxG34kurs8C3W8G3y7u3WYkw1rGw4vkr1xXrWayFZ09F1fWw4DA397Zr95ur4rW392kasx
        Cr93JF9rAwnFgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUboAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
        j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
        bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
        AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
        42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr
        1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
        daVFxhVjvjDU0xZFpf9x07UGYL9UUUUU=
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
-- 
2.34.1

