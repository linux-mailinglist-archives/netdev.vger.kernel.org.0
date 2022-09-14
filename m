Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7215B7E83
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 03:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiINBnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 21:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiINBnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 21:43:12 -0400
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C47D54657;
        Tue, 13 Sep 2022 18:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=RtOkw
        UCRvJPwXAmoRRVYheKTHhq6zc5VRxqZFuoYImA=; b=mAmmxAlW34ruPQpabSTIt
        7TioqdPC/2PDkbKh4VrsA/bbDIjMi1g9qkHToskDH9sV+uthX6DhQ9zR8pRgUjXv
        c88JsE+5Fkpghs1L3XCQ4QuX04LAksAeiOE64MwRrevgKayxjaWdZl73/Dyi98HW
        SqHBEaqq8KLycquU+I4UJQ=
Received: from localhost.localdomain (unknown [36.112.3.106])
        by smtp5 (Coremail) with SMTP id HdxpCgA3ckqPMSFj1pfJcQ--.46101S4;
        Wed, 14 Sep 2022 09:42:48 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] net: atlantic: fix potential memory leak in aq_ndev_close()
Date:   Wed, 14 Sep 2022 09:42:38 +0800
Message-Id: <20220914014238.7064-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgA3ckqPMSFj1pfJcQ--.46101S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFWrtrWfCF4xWF4kAr1rCrg_yoWDXrc_Cr
        4Fq3Wftw4UKr4jvw4Dtr43A3sFvrs2q397Z3W7trWfK3WkKw47GryqvF4fJ3yUuw1IvFnx
        WFnrWFW2v340yjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRMjgxUUUUUU==
X-Originating-IP: [36.112.3.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/xtbB0Rh8jFzICrd1OwAAse
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
 drivers/net/ethernet/aquantia/atlantic/aq_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 88595863d8bc..8a0af371e7dc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -94,11 +94,8 @@ static int aq_ndev_close(struct net_device *ndev)
 	int err = 0;
 
 	err = aq_nic_stop(aq_nic);
-	if (err < 0)
-		goto err_exit;
 	aq_nic_deinit(aq_nic, true);
 
-err_exit:
 	return err;
 }
 
-- 
2.25.1

