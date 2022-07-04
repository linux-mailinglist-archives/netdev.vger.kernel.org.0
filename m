Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CB156556C
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 14:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbiGDMde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 08:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbiGDMdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 08:33:33 -0400
X-Greylist: delayed 1886 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 04 Jul 2022 05:33:31 PDT
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F15D110A;
        Mon,  4 Jul 2022 05:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=I8+m1
        YAsVZ4gl1y1umKlRTUNyEHJgsOKvTyV1H7WmOY=; b=a7yHIyd+riruU9BRhBA3c
        QjZM9E+QfId6cMC/g7FBzsYIQLux1c4EoMi10gSb+L5u1RWRSW2KEybR1NpOsCWy
        urjRBkg0aWk2iaI3tQf2oVEAaMQ/cN4OYbmNrP7jFyrI/Ix8jLKNGh5cY/qWmoI2
        vhDkX1Y9e8NABbDJvXJWW4=
Received: from localhost.localdomain (unknown [123.112.69.106])
        by smtp5 (Coremail) with SMTP id HdxpCgBHyTYB3sJix5uRMQ--.31990S4;
        Mon, 04 Jul 2022 20:33:11 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] net: macsec: fix potential resource leak in macsec_add_rxsa() and macsec_add_txsa()
Date:   Mon,  4 Jul 2022 20:33:04 +0800
Message-Id: <20220704123304.2239147-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgBHyTYB3sJix5uRMQ--.31990S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar4rWF4fCF17Zw1xZr43ZFb_yoW8Jw4Dpa
        15ZwsrCF1qqrWI93ZrCw4UWF1rXayUtryagry7C3yfua4kJw1rWFy0kFyI9Fy5AryxGF48
        ZrWvyr47AFn8C37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRxOz-UUUUU=
X-Originating-IP: [123.112.69.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/xtbBOQU0jF-POU5l6QABsu
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

init_rx_sa() allocates relevant resource for rx_sa->stats and rx_sa->
key.tfm with alloc_percpu() and macsec_alloc_tfm(). When some error
occurs after init_rx_sa() is called in macsec_add_rxsa(), the function
released rx_sa with kfree() without releasing rx_sa->stats and rx_sa->
key.tfm, which will lead to a resource leak.

We should call macsec_rxsa_put() instead of kfree() to decrease the ref
count of rx_sa and release the relevant resource if the refcount is 0.
The same bug exists in macsec_add_txsa() for tx_sa as well. This patch
fixes the above two bugs.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/macsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 817577e713d7..ac3ff624a8dd 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1842,7 +1842,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 cleanup:
-	kfree(rx_sa);
+	macsec_rxsa_put(rx_sa);
 	rtnl_unlock();
 	return err;
 }
@@ -2085,7 +2085,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 
 cleanup:
 	secy->operational = was_operational;
-	kfree(tx_sa);
+	macsec_txsa_put(tx_sa);
 	rtnl_unlock();
 	return err;
 }
-- 
2.25.1

