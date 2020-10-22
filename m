Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F30A295812
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 07:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444613AbgJVFmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 01:42:49 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:55330 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437582AbgJVFms (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 01:42:48 -0400
Received: from localhost.localdomain (unknown [210.32.148.79])
        by mail-app2 (Coremail) with SMTP id by_KCgBXX+vKG5FfEIM4AA--.38547S4;
        Thu, 22 Oct 2020 13:42:37 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net-veth: Fix memleak in veth_newlink
Date:   Thu, 22 Oct 2020 13:42:33 +0800
Message-Id: <20201022054233.17326-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgBXX+vKG5FfEIM4AA--.38547S4
X-Coremail-Antispam: 1UD129KBjvdXoW5Kry3XFy7WF1fCr4xurWxJFb_yoWxXFbEkr
        18WFyxXr1YyFn0kw4j9r43Zryq93Z5XFykJFWvqrZ3CwsrZr9rWryfuF1UJrsxC3yxuFyD
        AFZ7Xrn7A347GjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbIxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWU
        XwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_GrWl42xK82IYc2Ij64vIr41l
        42xK82IY6x8ErcxFaVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
        8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWU
        twCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
        0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAF
        wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
        7VU1eT5JUUUUU==
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgABBlZdtQiRQQABsi
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rtnl_configure_link() fails, peer needs to be
freed just like when register_netdevice() fails.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/net/veth.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 8c737668008a..6c68094399cc 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1405,8 +1405,6 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 	/* nothing to do */
 err_configure_peer:
 	unregister_netdevice(peer);
-	return err;
-
 err_register_peer:
 	free_netdev(peer);
 	return err;
-- 
2.17.1

