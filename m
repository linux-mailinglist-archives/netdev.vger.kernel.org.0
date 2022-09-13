Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56105B6806
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 08:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiIMGka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 02:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiIMGk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 02:40:29 -0400
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89E0650067;
        Mon, 12 Sep 2022 23:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=sFjDE
        3FMbVcbIWhkgqbv+dg2JpKyTv79I9Bu7jtu/kQ=; b=Rp0Ft/1FSZ1pRfFIDfv44
        3S4OKNqnmoMDnDG+SDIVV3wc5X6uqVyLIYoOYVBKIoSZM6BPgKcLwuYI4ooZoZaN
        8YQIhzPCaqD9I+9Sxr54R0e6o0KfSe5CT7qb5ZR0Q4WBjdl+GQL8CT4m3gkYXRWb
        TxUuzDw5JJuzBlfN0fatcw=
Received: from localhost.localdomain (unknown [36.112.3.164])
        by smtp5 (Coremail) with SMTP id HdxpCgCHGDKuJSBjsS_pcA--.50336S4;
        Tue, 13 Sep 2022 14:39:56 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] net: atlantic: fix potential memory leak in aq_ndev_close()
Date:   Tue, 13 Sep 2022 14:39:41 +0800
Message-Id: <20220913063941.83611-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgCHGDKuJSBjsS_pcA--.50336S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFWrtrWfCF4xWF4kAr1rCrg_yoWDJFX_Cr
        4rX3Z7tw4UKr4jvw4Utr43A3s2vrs2q397Za47trW3K3WkGw47JryqvF43J3yUu34IvFn8
        GFnrXF42v34jkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRMjgxUUUUUU==
X-Originating-IP: [36.112.3.164]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiQxl7jFc7bXJxXwAAsw
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If aq_nic_stop() fails, aq_ndev_close() returns err without calling
aq_nic_deinit() to release the relevant memory and resource, which
will lead to a memory leak.

We can fix it by deleting the if condition judgment and goto statement to
call aq_nic_deinit() directly after aq_nic_stop() to fix the memory leak.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 88595863d8bc..362f8077ff97 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -94,8 +94,6 @@ static int aq_ndev_close(struct net_device *ndev)
 	int err = 0;
 
 	err = aq_nic_stop(aq_nic);
-	if (err < 0)
-		goto err_exit;
 	aq_nic_deinit(aq_nic, true);
 
 err_exit:
-- 
2.25.1

