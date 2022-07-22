Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA3157DF21
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiGVJkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236703AbiGVJkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:40:32 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12B65DB3;
        Fri, 22 Jul 2022 02:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=yKfIz
        zQLxyVD8Rlhk1R5sQ3hBPvIDShzjIbk3Wq6FGM=; b=CmdA2sNNdAyF5NSTYtJdP
        aw2t8tlDUPavJUnR9RNCEKUTEQV51ERlQkjI/QnezZG+jpO952521NKtsa9XsxLq
        2/AdmzYxrj1fXfTm6COPNtfnT/y6xZfiXPBNdefaXJ3kY8DrfnIBhbNRJtd7R0su
        JT9eJtPAaEKovORowL24YY=
Received: from localhost.localdomain (unknown [123.112.69.106])
        by smtp1 (Coremail) with SMTP id GdxpCgDH0+XfbdpiIqUoPw--.2565S4;
        Fri, 22 Jul 2022 17:29:26 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, atenart@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] net: macsec: fix potential resource leak in macsec_add_rxsa() and macsec_add_txsa()
Date:   Fri, 22 Jul 2022 17:29:02 +0800
Message-Id: <20220722092902.2528745-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgDH0+XfbdpiIqUoPw--.2565S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar4rWF4fCF17Zw1xZr43ZFb_yoW8GFyrpa
        1rZwsrCF1qqrWIg3WDCw4UWFy5XayUtryagry7C3yfua4kJw1rWFy0kFy09Fy5AryxGF4U
        ZrWvyr47JF1DC37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRIfOxUUUUU=
X-Originating-IP: [123.112.69.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiWxlGjGI0VjNM6wACse
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
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

