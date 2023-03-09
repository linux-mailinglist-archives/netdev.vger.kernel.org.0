Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F3B6B20DE
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCIKD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCIKD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:03:56 -0500
Received: from m12.mail.163.com (m12.mail.163.com [123.126.96.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 986AC6427C;
        Thu,  9 Mar 2023 02:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=qovOw
        vicZU4vTpXXhGsBzD0cFYCZA70jXWH/VBFx1Vs=; b=T4NL3WGBYewtn8ET/4KJa
        bPo8OWrO5xx4K0Uh28ZSgp89yZllxfqXgdbNjYjpqeED0u4DHVGJpu7ZC+YtygQH
        96SBMJm8vUNCP2oTtDdyeCsx/Mho5ozUyTkn5cChzrnlfyzOgi4pQm/wvkFDoeO6
        ffInWOOOSfnge1WSuO9EtQ=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by smtp17 (Coremail) with SMTP id NdxpCgDn_nrJrglkhu3eGw--.53030S2;
        Thu, 09 Mar 2023 18:02:49 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     s.shtylyov@omp.ru
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH net] net: ravb: Fix possible UAF bug in ravb_remove
Date:   Thu,  9 Mar 2023 18:02:48 +0800
Message-Id: <20230309100248.3831498-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NdxpCgDn_nrJrglkhu3eGw--.53030S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr48Xw4UKFW3KFW7Aw4fXwb_yoWDCrbEga
        4qvr1fK3y5Gr1vka10ka13urW2yr1kX34rCa17K3yaqa9rAw13Jrs5ZrnxXr1UuwsrXF9x
        Wrn3tF4Iyw1jvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRZZ2a3UUUUU==
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiXQktU1WBo2lZogAAsP
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ravb_probe, priv->work was bound with ravb_tx_timeout_work.
If timeout occurs, it will start the work. And if we call
ravb_remove without finishing the work, ther may be a use
after free bug on ndev.

Fix it by finishing the job before cleanup in ravb_remove.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 0f54849a3823..07a08e72f440 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2892,6 +2892,7 @@ static int ravb_remove(struct platform_device *pdev)
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
 
+	cancel_work_sync(&priv->work);
 	/* Stop PTP Clock driver */
 	if (info->ccc_gac)
 		ravb_ptp_stop(ndev);
-- 
2.25.1

