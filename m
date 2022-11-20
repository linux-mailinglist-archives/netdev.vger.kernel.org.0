Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E005A631360
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 11:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiKTKlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 05:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiKTKlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 05:41:01 -0500
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A93A776DD;
        Sun, 20 Nov 2022 02:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=aXgL1
        lM3sRYeyi04GakbtXwdv/WkYeER8Uv5v5dvzsc=; b=V9ZXqJJvq44eyTwmWcYMf
        bv17EezQT6z4Pdh+v4xCo8/DINXeH9jl/QnZyHjcoi4oGN5u3Jfkc/VLnrCHX52Q
        hzON8I7Q6e25QNkk7Y0xOHCgc/DNHW9GLiNC5QcmyVFFJJ09vc5D498BUn3M1uhB
        a7RQqsIqAJEtI2Yr90M+SY=
Received: from localhost.localdomain (unknown [36.112.3.106])
        by smtp4 (Coremail) with SMTP id HNxpCgBHnueRA3pjuzJ6tA--.22005S4;
        Sun, 20 Nov 2022 18:38:16 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        alsi@bang-olufsen.dk, rmk+kernel@armlinux.org.uk,
        linus.walleij@linaro.org, marcan@marcan.st
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] net: brcmfmac: fix potential resource leak in brcmf_usb_probe_phase2()
Date:   Sun, 20 Nov 2022 18:38:07 +0800
Message-Id: <20221120103807.7588-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgBHnueRA3pjuzJ6tA--.22005S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr1fGr4DKFW3JF4fXF43KFg_yoWkGwc_ZF
        48uFnrJr1FqwnY934jvFya9rsYk3Wqq397GrsxtFWfZw48XFWUCrykZFs3Gw17GrsFqFn8
        urnxJ3WUC3W0vjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRE1xR3UUUUU==
X-Originating-IP: [36.112.3.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiQxy-jFc7cQ3QaAAAsE
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

brcmf_usb_probe_phase2() allocates resource for dev with brcmf_alloc().
The related resource should be released when the function gets some error.
But when brcmf_attach() fails, relevant resource is not released, which
will lead to resource leak.

Fix it by calling brcmf_free() when brcmf_attach() fails.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 85e18fb9c497..5d8c12b2c4d7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1215,6 +1215,7 @@ static void brcmf_usb_probe_phase2(struct device *dev, int ret,
 	return;
 error:
 	brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), ret);
+	brcmf_free(devinfo->dev);
 	complete(&devinfo->dev_init_done);
 	device_release_driver(dev);
 }
-- 
2.25.1

