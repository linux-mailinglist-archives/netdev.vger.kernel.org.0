Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54FB5F04C9
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 08:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiI3GaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 02:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiI3GaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 02:30:07 -0400
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0CA42D1D8;
        Thu, 29 Sep 2022 23:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=TeC9G
        wZOg9/n2xD1WVfGuCZoPfKYMRWZ2un6aSADwLY=; b=T5B8wTcUH2T9lpmd4DtsY
        xbwZWA5gAysDiN99ay9JZfXLrzI2IAtq02ZtA6/D3aXbu3vMcK8mJ7/DCeI0XHDN
        aMhgeMjv6NaCDm5i5UGLFp+z4rPN3Ytt6xJpmbFVxcyt7Ri7q/sj2KpaS9ZSVpOH
        b1WG+x3kcpgXuTQbACMc4w=
Received: from localhost.localdomain (unknown [36.112.3.106])
        by smtp5 (Coremail) with SMTP id HdxpCgAXcgicjDZjHxHXgQ--.36896S4;
        Fri, 30 Sep 2022 14:29:03 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] bnx2x: fix potential memory leak in bnx2x_tpa_stop()
Date:   Fri, 30 Sep 2022 14:28:43 +0800
Message-Id: <20220930062843.5654-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgAXcgicjDZjHxHXgQ--.36896S4
X-Coremail-Antispam: 1Uf129KBjvJXoWrKF13CF1rWw17Gry3WF1rZwb_yoW8Jr1kp3
        yqqFyDAr18trsYka1DJ3W8Zr98Z3y5t34j9ay3Z3yF93y5tr4UJrsrKay29ryDJrWrKr12
        vr45Z3sxXa4qvw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziCPfPUUUUU=
X-Originating-IP: [36.112.3.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiWw+MjGI0Wa2DewAAsO
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnx2x_tpa_stop() allocates a memory chunk from new_data with
bnx2x_frag_alloc(). The new_data should be freed when gets some error.
But when "pad + len > fp->rx_buf_size" is true, bnx2x_tpa_stop() returns
without releasing the new_data, which will lead to a memory leak.

We should free the new_data with bnx2x_frag_free() when "pad + len >
fp->rx_buf_size" is true.

Fixes: 07b0f00964def8af9321cfd6c4a7e84f6362f728 ("bnx2x: fix possible
panic under memory stress")
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 712b5595bc39..24bfc65e28e1 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -789,6 +789,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 			BNX2X_ERR("skb_put is about to fail...  pad %d  len %d  rx_buf_size %d\n",
 				  pad, len, fp->rx_buf_size);
 			bnx2x_panic();
+			bnx2x_frag_free(fp, new_data);
 			return;
 		}
 #endif
-- 
2.25.1

