Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827EE34E537
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 12:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhC3KQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 06:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhC3KQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 06:16:26 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0E51C061574;
        Tue, 30 Mar 2021 03:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=JQBxnmUDmt
        k5ywlnAxjrHC7Iq8Hzm8YvT88z/1P/DpI=; b=n+UXrA0YXLyaXFLwHoVOYU195l
        llgP8AH2gF2lor487Dr6/RzBdgI9Z6EuTJc1aif4w/+mfyFO9bD13AoRrNADjYr+
        ysx1/gj+KS9BGMOnvSv16R7Rw2nAorpqdCq+jPZeqcqax0k49p59v8XUsoWYu+19
        WhgwV28FoHPweIrKc=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygDHzU1k+mJgvL5vAA--.283S4;
        Tue, 30 Mar 2021 18:16:04 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] net/rds: Fix a use after free in rds_message_map_pages
Date:   Tue, 30 Mar 2021 03:16:02 -0700
Message-Id: <20210330101602.22505-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygDHzU1k+mJgvL5vAA--.283S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtrWrGF1kZFW3Cw13AF1kKrg_yoWfZFg_Zr
        W7JFn7W347XF1Iyws7Gws3Jr4Sqr1kJw18ua42gFyFyayDCF1kXw4rtrnxuwnxCFW2qr1x
        Ww4DXr9xC34vvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbsAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7MxkIecxEwVAFwVW8twCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUbQVy7UUUUU==
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rds_message_map_pages, the rm is freed by rds_message_put(rm).
But rm is still used by rm->data.op_sg in return value.

My patch replaces ERR_CAST(rm->data.op_sg) to ERR_PTR(-ENOMEM) to avoid
the uaf.

Fixes: 7dba92037baf3 ("net/rds: Use ERR_PTR for rds_message_alloc_sgs()")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 net/rds/message.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 071a261fdaab..cecd968c9b25 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -348,7 +348,7 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 	rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs);
 	if (IS_ERR(rm->data.op_sg)) {
 		rds_message_put(rm);
-		return ERR_CAST(rm->data.op_sg);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	for (i = 0; i < rm->data.op_nents; ++i) {
-- 
2.25.1


