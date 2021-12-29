Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56954811A0
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 11:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbhL2KWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 05:22:08 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:43446 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231732AbhL2KWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 05:22:07 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-05 (Coremail) with SMTP id zQCowACHa0G1Nsxhi1hCBQ--.9142S2;
        Wed, 29 Dec 2021 18:21:41 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] fjes: Check possible NULL pointer returned by vzalloc
Date:   Wed, 29 Dec 2021 18:21:40 +0800
Message-Id: <20211229102140.1776466-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowACHa0G1Nsxhi1hCBQ--.9142S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZw18Kry5Gr4DKrW3urW7urg_yoWfGFb_ur
        s2qF13W34qgr1ktF1UAr43ZryqyrWvqr1Ig34ftrWaq3yDC3Z3AryxurnrG3yUW3y5ZFnr
        Jr9Fqr13A34SqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbcxFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
        1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0
        cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8Jw
        ACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r4DMxAI
        w28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
        CI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUboKZJUUUUU==
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the possible alloc failure of the vzalloc(), the 'hw->hw_info.trace'
could be NULL pointer.
Therefore it should be better to check it to guarantee the complete
success of the initiation.

Fixes: 8cdc3f6c5d22 ("fjes: Hardware initialization routine")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/fjes/fjes_hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/fjes/fjes_hw.c b/drivers/net/fjes/fjes_hw.c
index 065bb0a40b1d..4c83f637a135 100644
--- a/drivers/net/fjes/fjes_hw.c
+++ b/drivers/net/fjes/fjes_hw.c
@@ -329,6 +329,9 @@ int fjes_hw_init(struct fjes_hw *hw)
 	ret = fjes_hw_setup(hw);
 
 	hw->hw_info.trace = vzalloc(FJES_DEBUG_BUFFER_SIZE);
+	if (!hw->hw_info.trace)
+		return -ENOMEM;
+
 	hw->hw_info.trace_size = FJES_DEBUG_BUFFER_SIZE;
 
 	return ret;
-- 
2.25.1

