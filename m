Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE8040447E
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 06:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349958AbhIIEee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 00:34:34 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:39653
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S229549AbhIIEed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 00:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=15PV/LqowfaC+fxf6vWbltb0UNQfC6jSPzN+3vijUwc=; b=3
        DJjFnbhsbzatVfC5kPmsEk1UPwiv7vfjI6C/y/3X8LYWTdtQ7ti4nRqk85rOC9H6
        ns5IPiAoofi7djqHBlyvKC18+JSgSB9zGqSV722nckXNML5Eu3ia5qq91eYOKjlr
        W2pEWVmqTnuiZL6ZpFy5V5oZ6W1Tw/SRbH3kpfSGOA=
Received: from localhost.localdomain (unknown [10.162.127.118])
        by app1 (Coremail) with SMTP id XAUFCgCXn19pjjlhq309AA--.1163S3;
        Thu, 09 Sep 2021 12:32:41 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] net/sunrpc: fix reference count leaks in rpc_sysfs_xprt_state_change
Date:   Thu,  9 Sep 2021 12:32:38 +0800
Message-Id: <1631161958-77832-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XAUFCgCXn19pjjlhq309AA--.1163S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WF1kAry5Kr43Gr1rKF48WFg_yoW8JFyfpr
        y5K34a9F98tr47G3ZrC3W0ga4jvFs8X3W5X3yI9w1kA3WDAasxGr1F9rsrWr18ArWruFW8
        JF109F4ruF4DCaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9G14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMx
        C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
        wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
        vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v2
        0xvaj40_Gr0_Zr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxV
        W8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbZmitUUUUU==
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The refcount leak issues take place in an error handling path. When the
3rd argument buf doesn't match with "offline", "online" or "remove", the
function simply returns -EINVAL and forgets to decrease the reference
count of a rpc_xprt object and a rpc_xprt_switch object increased by
rpc_sysfs_xprt_kobj_get_xprt() and
rpc_sysfs_xprt_kobj_get_xprt_switch(), causing reference count leaks of
both unused objects.

Fix this issue by jumping to the error handling path labelled with
out_put when buf matches none of "offline", "online" or "remove".

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/sunrpc/sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index 64da3bfd28e6..0cce0375107f 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -265,8 +265,10 @@ static ssize_t rpc_sysfs_xprt_state_change(struct kobject *kobj,
 		online = 1;
 	else if (!strncmp(buf, "remove", 6))
 		remove = 1;
-	else
-		return -EINVAL;
+	else {
+		count = -EINVAL;
+		goto out_put;
+	}
 
 	if (wait_on_bit_lock(&xprt->state, XPRT_LOCKED, TASK_KILLABLE)) {
 		count = -EINTR;
-- 
2.7.4

