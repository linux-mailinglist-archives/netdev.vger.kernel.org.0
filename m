Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972795F1142
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 19:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiI3R6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 13:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiI3R54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 13:57:56 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03F7F157FDF;
        Fri, 30 Sep 2022 10:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=zRqlK
        +Z5OrehcRr3RsfUwmtFXjy6h6AE3UAtz0+5/14=; b=Kr0POa5Fk3D/mgQtqw0Pt
        jP1TLgbKCEF60Qd2vYcXRW7J1K4DcadDI54FV0CnRUy2eNTpJqJcHE0BXxKo172C
        4PZTw5gb3tfv+rxu72mqE84NPQptaaG4YhRZXKKPDe5RGjDv6x507oCfxsyv6S6o
        2uLv3A+4Ccjk90+0sAeBos=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by smtp1 (Coremail) with SMTP id GdxpCgBXm+UGLjdjgRbfgg--.33987S2;
        Sat, 01 Oct 2022 01:57:26 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     netdev@vger.kernel.org
Cc:     wellslutw@gmail.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        alex000young@gmail.com, security@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH] eth: sp7021: fix use after free bug in spl2sw_nvmem_get_mac_address
Date:   Sat,  1 Oct 2022 01:57:25 +0800
Message-Id: <20220930175725.2548233-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgBXm+UGLjdjgRbfgg--.33987S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruw1xXF15XFyxtr4fJFWxXrb_yoWfZFgE9r
        1j9ryfJw4DGa15ta1Fyr4fZ340vwn5Xrs3CFnrK393tay7uF17Cwn7Zr1xJFy7ur4rCF9r
        Jw17X347C34xKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRMwZ2DUUUUU==
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/xtbB2A+MU2BHMHCVfwAAsF
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

