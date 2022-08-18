Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3C259811D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243860AbiHRJxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbiHRJxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:53:20 -0400
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31792E44;
        Thu, 18 Aug 2022 02:53:12 -0700 (PDT)
X-QQ-mid: bizesmtp79t1660816263t2r7wq2p
Received: from localhost.localdomain ( [123.114.60.34])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 18 Aug 2022 17:51:01 +0800 (CST)
X-QQ-SSF: 01400000002000D0U000B00A0000000
X-QQ-FEAT: CR3LFp2JE4kURDf+4uuh2+zQhPnPITI1fI4gczptBrkPfssSVdeqy5HVNYgoy
        43l7uVO6L0BCDUgiGR3TabhUghhlUQTqjU6dR2XRicWt9v6p3xBXGv6mxfZSSFS8Yc5n5wd
        393aFiT+PHViazcxL8TPsBZBi+i5sbLDtrNmfT0QXOuHSlQpaR74bfsBcKmyYQwAg6S/mkR
        IeObbFMT/Ye2O3C7CLrXerzV99GOA8NRyng4wOLDeMX/kDhE3BbgG9pcY4kp3k0Fq4iA3qN
        UROKQwnq6gX4FFXWLsSjozhsHwbWCuy23Ff6d7GkUz9uCT9OwMVT/R3IcwLHoO3QSl/oPOO
        +yusaqWqIRhb05xnAX6h+a0DcYAqL3P3mtiwkwEZz/sdn9rxGhd95u0tCypN2HIlj1xIzKi
X-QQ-GoodBg: 2
From:   zhaoxiao <zhaoxiao@uniontech.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, morbo@google.com, weiyongjun1@huawei.com,
        colin.king@intel.com
Cc:     tobias@waldekranz.com, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhaoxiao <zhaoxiao@uniontech.com>
Subject: [PATCH] net: freescale: xgmac: Do not dereference fwnode in struct device
Date:   Thu, 18 Aug 2022 17:50:59 +0800
Message-Id: <20220818095059.8870-1-zhaoxiao@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to make the underneath API easier to change in the future,
prevent users from dereferencing fwnode from struct device.
Instead, use the specific dev_fwnode() API for that.

Signed-off-by: zhaoxiao <zhaoxiao@uniontech.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index ec90da1de030..d7d39a58cd80 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -355,7 +355,7 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	fwnode = pdev->dev.fwnode;
+	fwnode = dev_fwnode(&pdev->dev);
 	if (is_of_node(fwnode))
 		ret = of_mdiobus_register(bus, to_of_node(fwnode));
 	else if (is_acpi_node(fwnode))
-- 
2.20.1

