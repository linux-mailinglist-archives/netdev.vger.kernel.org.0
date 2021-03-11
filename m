Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2C8336E20
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 09:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhCKIqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 03:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbhCKIq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 03:46:29 -0500
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77987C061574;
        Thu, 11 Mar 2021 00:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=2UJb+wsmJ2
        FcUp6+0rWvkv9WpaHiRbHAp+kj50P9o9U=; b=W6EknMUlXpOxz2ooLVWJL9ds6D
        dmTiHOpvqNM5cHU40h3qzWhcn4x9Q7++9SxnUkZ9wIhoGxEkocaRgpp5GjV3A6EP
        OQAjgREHpMzI1z/5ooZfvR7xy5HPyszF1fJ1gIFwHDAY+ZbHS5SQpkeNMHP0bpUg
        gSVzFnN8HS8mqq0sI=
Received: from ubuntu.localdomain (unknown [114.214.226.60])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygDn7x_a2ElglukKAA--.3103S4;
        Thu, 11 Mar 2021 16:46:18 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] net/rds: Fix a use after free in rds_message_map_pages
Date:   Thu, 11 Mar 2021 00:46:16 -0800
Message-Id: <20210311084616.12356-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygDn7x_a2ElglukKAA--.3103S4
X-Coremail-Antispam: 1UD129KBjvdXoWrZrW3JF4UCw4DXr4rKw15urg_yoWDGFg_uF
        WxJrn7W347XFyIkrs7KrsrAw4fZr1kXw18ua42qFn5tryDCFn5Xw48trn8uwnrCFW2vr1x
        C3yDXr93ua4kZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbx8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQZ2
        3UUUUU=
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rds_message_map_pages, rds_message_put() will free rm.
Maybe store the value of rm->data.op_sg ahead of rds_message_put()
is better. Otherwise other threads could allocate the freed chunk
and may change the value of rm->data.op_sg.

Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 net/rds/message.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 071a261fdaab..392e3a2f41a0 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -347,8 +347,9 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 	rm->data.op_nents = DIV_ROUND_UP(total_len, PAGE_SIZE);
 	rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs);
 	if (IS_ERR(rm->data.op_sg)) {
+		struct scatterlist *tmp = rm->data.op_sg;
 		rds_message_put(rm);
-		return ERR_CAST(rm->data.op_sg);
+		return ERR_CAST(tmp);
 	}
 
 	for (i = 0; i < rm->data.op_nents; ++i) {
-- 
2.25.1


