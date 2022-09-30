Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E0E5F0375
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 06:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiI3EDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 00:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiI3EDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 00:03:40 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24AED1F9CB4;
        Thu, 29 Sep 2022 21:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=a8Mfm
        sQrUP3PQIq6ff31cKawpYNRcV+JbGr6NhhHNFI=; b=UiAIX6QH1wgxswgoexNY9
        DzqVChxm/kdqISxpni/bpw2U5+Eb6Ja6h93X4db8dchMuttsNadSbXUysHV5QGkj
        WJ50Neh72EGCYY2tCIkqf22KrnjaJMPnMoad14ENK7cjJi5yNm50EUaSu63Rq9M+
        dcpms65Uv3a25NYKWYTYec=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by smtp4 (Coremail) with SMTP id HNxpCgD3_PF_ajZjEPG5gw--.50385S2;
        Fri, 30 Sep 2022 12:03:11 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     netdev@vger.kernel.org
Cc:     wellslutw@gmail.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        alex000young@gmail.com, security@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH] eth: sp7021: fix use after free bug in spl2sw_nvmem_get_mac_address
Date:   Fri, 30 Sep 2022 12:03:10 +0800
Message-Id: <20220930040310.2221344-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgD3_PF_ajZjEPG5gw--.50385S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruw1xXF15XFyxtr4fJFWxXrb_yoWDGrXE9r
        1jvryfJw4DGa15ta15tr4fZ340vwn5Xrs3CFnrt393tay7ZF17Cwn7Zr1fJry7ur48CF9r
        Jw17X347C342qjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRMFAp7UUUUU==
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiXAaLU1Xl4VLlKwABsO
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This frees "mac" and tries to display its address as part of the error
message on the next line.  Swap the order.

Fixes: fd3040b9394c ("net: ethernet: Add driver for Sunplus SP7021")

Reported-by: Zheng Wang <hackerzheng666@gmail.com>

Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 drivers/net/ethernet/sunplus/spl2sw_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
index 546206640492..61d1d07dc070 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
@@ -248,8 +248,8 @@ static int spl2sw_nvmem_get_mac_address(struct device *dev, struct device_node *
 
 	/* Check if mac address is valid */
 	if (!is_valid_ether_addr(mac)) {
-		kfree(mac);
 		dev_info(dev, "Invalid mac address in nvmem (%pM)!\n", mac);
+		kfree(mac);
 		return -EINVAL;
 	}
 
-- 
2.25.1

