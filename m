Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8E557D9A4
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiGVEeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbiGVEeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:34:18 -0400
Received: from m12-11.163.com (m12-11.163.com [220.181.12.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3935287F5A
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 21:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=L5FMe4DiXQZDPvzG9V
        liD9vfeB80xyvqaoeLxnLvibw=; b=IYsDpQsATvyWsIaJ3cweu298EE7dtaoVnp
        HEIeWL+4mNiolNFGxDrSr8KShITYfe5OzsqYt8uHit9TY+C8/dACdz1b0Ni/vCK/
        VIoID/VhwhXt3b5d/re2w5c8uZVeuWvcVXFxBmyqKQ6VB371y9CepPJSxkddMjfO
        rai3rqeyo=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp7 (Coremail) with SMTP id C8CowABXu5CZKNpiKw5PPA--.51114S4;
        Fri, 22 Jul 2022 12:33:53 +0800 (CST)
From:   Yuanjun Gong <ruc_gongyuanjun@163.com>
To:     Yuanjun Gong <ruc_gongyuanjun@163.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        netdev@vger.kernel.org
Subject: [PATCH 1/1] drivers/net/ethernet: fix a memory leak
Date:   Fri, 22 Jul 2022 12:33:27 +0800
Message-Id: <20220722043327.2259-1-ruc_gongyuanjun@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: C8CowABXu5CZKNpiKw5PPA--.51114S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF1ktrWUAryrKr18uw4Uurg_yoWxtFXE9w
        17Zrs7Xa1DCryYv3y3CrW5AryFkF1Duw10g3Z8K3yrZFW7Jr15Xr1kur17Ja9rWw4xGF9x
        Cr9rXFWSy343tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUU8wI3UUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: 5uxfsw5rqj53pdqm30i6rwjhhfrp/xtbB0BFG5WEsrazCPQAAsR
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ave_remove, ndev should be freed with free_netdev before return.

Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
---
 drivers/net/ethernet/socionext/sni_ave.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index f0c8de2c6075..9d1c1cdd04af 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1725,6 +1725,7 @@ static int ave_remove(struct platform_device *pdev)
 	unregister_netdev(ndev);
 	netif_napi_del(&priv->napi_rx);
 	netif_napi_del(&priv->napi_tx);
+	free_netdev(ndev);
 
 	return 0;
 }
-- 
2.17.1

