Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F70E6BD339
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjCPPTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjCPPTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:19:14 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8D262B29D;
        Thu, 16 Mar 2023 08:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=H4/Fi
        38q7E5qS/7J86Orolnyf62jTO1JC1vQ1ZYN2Zc=; b=V1WR2ojGiu1UNzboarRI5
        oQEBB3wRf3v6iH9f11uQzdQzALCTm0OLhYXoK00tGSn4MNvdaSGj2LOv6sSLeNmC
        FU1aYShhw4iBZz2FFWyft2OLspsd3KMqM5643euFdvFjUMHbJMWgekOspyPDg02J
        gXA2kFfOomqhtI04OyhbUU=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g5-1 (Coremail) with SMTP id _____wCHicYbMxNkoxocAQ--.17899S2;
        Thu, 16 Mar 2023 23:17:47 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     davem@davemloft.net
Cc:     simon.horman@corigine.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, thomas.lendacky@amd.com,
        wsa+renesas@sang-engineering.com, leon@kernel.org,
        shayagr@amazon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH v4] xirc2ps_cs: Fix use after free bug in xirc2ps_detach
Date:   Thu, 16 Mar 2023 23:17:45 +0800
Message-Id: <20230316151745.1557266-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wCHicYbMxNkoxocAQ--.17899S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WrWxuF4xKrW5Aw4UGw1Dtrb_yoW8XF4DpF
        WUJay5Zr4DX3sIvw4xJFyUJF15Xa93K3yjgrZ3C3ySgrn8ArWqgry5tayjgFyxZrWkZF13
        Ar1Y9ryxWFnrAFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziYLv_UUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiXAw0U1Xl59KrNgACst
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In xirc2ps_probe, the local->tx_timeout_task was bounded
with xirc2ps_tx_timeout_task. When timeout occurs,
it will call xirc_tx_timeout->schedule_work to start the
work.

When we call xirc2ps_detach to remove the driver, there
may be a sequence as follows:

Stop responding to timeout tasks and complete scheduled
tasks before cleanup in xirc2ps_detach, which will fix
the problem.

CPU0                  CPU1

                    |xirc2ps_tx_timeout_task
xirc2ps_detach      |
  free_netdev       |
    kfree(dev);     |
                    |
                    | do_reset
                    |   //use dev

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
v4:
- fix indentation error again

v3:
- fix indentation error suggested by Jakub Kicinski

v2:
- fix indentation error suggested by Simon Horman,
and stop the timeout tasks  suggested by Yunsheng Lin
---
 drivers/net/ethernet/xircom/xirc2ps_cs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 894e92ef415b..e04b3f7f2179 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -503,7 +503,12 @@ static void
 xirc2ps_detach(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
+    struct local_info *local = netdev_priv(dev);

+    netif_carrier_off(dev);
+    netif_tx_disable(dev);
+    cancel_work_sync(&local->tx_timeout_task);
+
     dev_dbg(&link->dev, "detach\n");
 
     unregister_netdev(dev);
-- 
2.25.1

