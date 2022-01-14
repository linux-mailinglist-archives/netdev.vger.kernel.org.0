Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6F348E6BD
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 09:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbiANIm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 03:42:58 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:34770 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230049AbiANIm6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 03:42:58 -0500
Received: from localhost.localdomain (unknown [124.16.141.244])
        by APP-05 (Coremail) with SMTP id zQCowAAXH39+N+FhaP8xBg--.45727S2;
        Fri, 14 Jan 2022 16:42:38 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     wintera@linux.ibm.com, wenjia@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@linux.ibm.com,
        agordeev@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] s390/qeth: Remove redundant 'flush_workqueue()' calls
Date:   Fri, 14 Jan 2022 08:42:18 +0000
Message-Id: <20220114084218.42586-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowAAXH39+N+FhaP8xBg--.45727S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKF1rKw18ZryDWrWkJr15twb_yoWfJwb_Gr
        WxKrW2yr4DKr9F934YyFn5ZFyF9w1qg3WS9a9agrZ5Jw1UW345Xr1DZr4UW3yUX3yUGFy7
        ZFyUX3WqvrnrCjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb2xYjsxI4VWkKwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY02Avz4vE14v_GFyl42xK82IY
        c2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
        026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF
        0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0x
        vE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUgwFxDUUUU
X-Originating-IP: [124.16.141.244]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgkGA10Tf6iqfAACsH
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'destroy_workqueue()' already drains the queue before destroying it, so
there is no need to flush it explicitly.

Remove the redundant 'flush_workqueue()' calls.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/s390/net/qeth_l3_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 9251ad276ee8..d2f422a9a4f7 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1961,7 +1961,6 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
 	if (card->dev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(card->dev);
 
-	flush_workqueue(card->cmd_wq);
 	destroy_workqueue(card->cmd_wq);
 	qeth_l3_clear_ip_htable(card, 0);
 	qeth_l3_clear_ipato_list(card);
-- 
2.25.1

