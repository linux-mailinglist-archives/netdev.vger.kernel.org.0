Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA366B5E5D
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 18:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjCKRJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 12:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCKRJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 12:09:34 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E356EC5D;
        Sat, 11 Mar 2023 09:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=39auS
        PKZnuBFBnPRBUd+UqjHniwggSni0+AncM3Q90Q=; b=MgFxzSOphnh2TvTOZcyXM
        /0HLGVK9wyERR9QjaAT6qbabX1S47rSnXpoubTvXMmmPy5PhhNWpBvIVwrxKxy8T
        P+J4sO7HqQRSUFEoKulAk5Lwim1iFpKLS6jj9sq1dp6M+yeTyjbqGeQZj6HsDyl7
        VI7gsS6Ks4jt3xoN5WZ8pU=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g0-0 (Coremail) with SMTP id _____wAnnhaVtQxkNp8CDA--.24226S2;
        Sun, 12 Mar 2023 01:08:37 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     davem@davemloft.net
Cc:     simon.horman@corigine.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, thomas.lendacky@amd.com,
        wsa+renesas@sang-engineering.com, leon@kernel.org,
        shayagr@amazon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH v2] xirc2ps_cs: Fix use after free bug in xirc2ps_detach
Date:   Sun, 12 Mar 2023 01:08:36 +0800
Message-Id: <20230311170836.3919005-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wAnnhaVtQxkNp8CDA--.24226S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WrWxuF4xKrW5Aw4UCr48WFg_yoW8GFyUpr
        WDJay5Zr4kXwsIvw4xJrWUJF15Was3Kayjgr93C3yFgrn8ArWqgr1rKayjgFyxArWkZF13
        Arn09ryxWF1DAFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziYLv_UUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/xtbBzhkvU2I0XmjvDwAAsr
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
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
v2:
- fix indentation error suggested by Simon Horman,
and stop the timeout tasks  suggested by Yunsheng Lin
---
 drivers/net/ethernet/xircom/xirc2ps_cs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 894e92ef415b..c77ca11d9497 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -503,6 +503,11 @@ static void
 xirc2ps_detach(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
+		struct local_info *local = netdev_priv(dev);
+
+		netif_carrier_off(dev);
+		netif_tx_disable(dev);
+		cancel_work_sync(&local->tx_timeout_task);
 
     dev_dbg(&link->dev, "detach\n");
 
-- 
2.25.1

