Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E4E34F670
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhCaCAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhCaCAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:00:15 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B6B1C061574;
        Tue, 30 Mar 2021 19:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=OycOHuyRcI
        IO+xylTwknRNm1rxJYX7lsX0dug9h2cBI=; b=D3MgoIexR9DmyQIRzDsE0CeZBI
        DO+NCf3lvx1JXaa5ZvVy2G7vKCuXH1SKGqA19+PF+ftSDBizL7NL/96RVICR8MQB
        KvaObYsS0cBflktfQbg2wvRB+3387TYcEgYmlCV9Jf+KeRDZd9YNSQnIwUA36qmn
        5ybhziOxiJIqQCfKs=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAXIqyk12NgIbl0AA--.651S4;
        Wed, 31 Mar 2021 10:00:04 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH v2] net/rds: Fix a use after free in rds_message_map_pages
Date:   Tue, 30 Mar 2021 18:59:59 -0700
Message-Id: <20210331015959.4404-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygAXIqyk12NgIbl0AA--.651S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtrWrGF1UCF1fJw4Duw45KFg_yoWDAFg_Zr
        WxJFn7W347XFnFy397GrsxAr4fXr1kJw109a42qFn5tFWDAFn5Xw4ktrn8uwnrCF42qr1x
        W3yDXr9xA34kZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lc2xSY4AK67AK6r4UMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VU1wZ23UUUUU==
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rds_message_map_pages, the rm is freed by rds_message_put(rm).
But rm is still used by rm->data.op_sg in return value.

My patch assigns ERR_CAST(rm->data.op_sg) to err before the rm is
freed to avoid the uaf.

Fixes: 7dba92037baf3 ("net/rds: Use ERR_PTR for rds_message_alloc_sgs()")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 net/rds/message.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 071a261fdaab..799034e0f513 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -347,8 +347,9 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 	rm->data.op_nents = DIV_ROUND_UP(total_len, PAGE_SIZE);
 	rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs);
 	if (IS_ERR(rm->data.op_sg)) {
+		void *err = ERR_CAST(rm->data.op_sg);
 		rds_message_put(rm);
-		return ERR_CAST(rm->data.op_sg);
+		return err;
 	}
 
 	for (i = 0; i < rm->data.op_nents; ++i) {
-- 
2.25.1


