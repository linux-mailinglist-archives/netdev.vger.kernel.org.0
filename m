Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDC36B2B82
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjCIREb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjCIREC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:04:02 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 185BF867C9;
        Thu,  9 Mar 2023 08:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=+YLvt
        Aw1RkPh8qoj7cZhCX44FGwcl1C12NIIvd2P/2I=; b=ccWRu8Hm9sYXkeeHluOTg
        UrGEZg3xidRjLlGx8UzOvATb62Aw1+lwy4QWDvAlmKw3siWAaSiQfxCKO0y0Gma6
        nvcMPw3xD/bAX4O9S31cCToa/VeAQI3pcw7mjujNN3lDwgOwWS025xQF5LgKt82Z
        +gX8LmUb+zEx39P8k9QJWc=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g2-1 (Coremail) with SMTP id _____wAHC8_7Dwpk4UvxCg--.34008S2;
        Fri, 10 Mar 2023 00:57:32 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, thomas.lendacky@amd.com,
        wsa+renesas@sang-engineering.com, leon@kernel.org,
        shayagr@amazon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH net] xirc2ps_cs: Fix use after free bug in xirc2ps_detach
Date:   Fri, 10 Mar 2023 00:57:29 +0800
Message-Id: <20230309165729.164440-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wAHC8_7Dwpk4UvxCg--.34008S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7GFykZFW8Xr45JrykKFW5Awb_yoW8Jr13pr
        W3tay5Zr1kXwsIvws7JryUJFy5Was3Kry8Wr9xC3yS9wn8A3yqgr15KayjgFy7ZrWkZF13
        Zrn09ryxWFnrAaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziWSoAUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiQgAtU1aEEmrg+QAAsP
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

Fix it by finishing the work before cleanup in xirc2ps_detach

CPU0                  CPU1

                    |xirc2ps_tx_timeout_task
xirc2ps_detach      |
  free_netdev       |
    kfree(dev);     |
                    |
                    | do_reset
                    |   //use

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 drivers/net/ethernet/xircom/xirc2ps_cs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 894e92ef415b..ea7b06f75691 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -503,7 +503,10 @@ static void
 xirc2ps_detach(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
-
+		struct local_info *local;
+
+		local = netdev_priv(dev);
+		cancel_work_sync(&local->tx_timeout_task)
     dev_dbg(&link->dev, "detach\n");
 
     unregister_netdev(dev);
-- 
2.25.1

