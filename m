Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2645B344702
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 15:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhCVOVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 10:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhCVOV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 10:21:29 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB0A6C061574;
        Mon, 22 Mar 2021 07:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=Y+D/Gm2scc
        kryg7xKa8VG7X28ryTUEHzDztzCS5WwME=; b=sD6PuOkt9M4T2uxfUx5TI42rXs
        sPoIXM6+HSGIcdcv9oUeu8OdPlPEg3C/zTsSUPhHqKR21Oh1wXiYSGxnLXGsew7R
        usXOvLaFSgU+dRPVEWT1g5SFCL4jIyiDAEvF/FacJiy98Adf91n4xFRzkL2zznFx
        70kHAw278pIVL7IUA=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBHTKTYp1hgKCkOAA--.4791S4;
        Mon, 22 Mar 2021 22:21:12 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        davem@davemloft.net, kuba@kernel.org, maximmi@mellanox.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] net/mlx5: Fix a potential use after free in mlx5e_ktls_del_rx
Date:   Mon, 22 Mar 2021 07:21:09 -0700
Message-Id: <20210322142109.6305-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygBHTKTYp1hgKCkOAA--.4791S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr17ZF1Dur45Cr4fZrWkZwb_yoW8Gr43pr
        1fX34fuayUJFWfJayDX3ykuFn5uayDtFy293WxZwsxurn3tFWUAFy5GFW3uryUCrW5JFnx
        tr4rZ3ZxuFZ8AaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK67AK6ry5MxAIw28IcxkI7VAKI4
        8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
        wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
        v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20E
        Y4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbSdgPUUUUU==
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My static analyzer tool reported a potential uaf in
mlx5e_ktls_del_rx. In this function, if the condition
cancel_work_sync(&resync->work) is true, and then
priv_rx could be freed. But priv_rx is used later.

I'm unfamiliar with how this function works. Maybe the
maintainer forgot to add return after freeing priv_rx?

Fixes: b850bbff96512 ("net/mlx5e: kTLS, Use refcounts to free kTLS RX priv context")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index d06532d0baa4..54a77df42316 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -663,8 +663,10 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 		 */
 		wait_for_completion(&priv_rx->add_ctx);
 	resync = &priv_rx->resync;
-	if (cancel_work_sync(&resync->work))
+	if (cancel_work_sync(&resync->work)) {
 		mlx5e_ktls_priv_rx_put(priv_rx);
+		return;
+	}
 
 	priv_rx->stats->tls_del++;
 	if (priv_rx->rule.rule)
-- 
2.25.1


