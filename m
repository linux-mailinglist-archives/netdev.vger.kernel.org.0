Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23435630C09
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 06:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbiKSFTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 00:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiKSFTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 00:19:09 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBB86D491;
        Fri, 18 Nov 2022 21:19:07 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NDhgs2spmzFqQ8;
        Sat, 19 Nov 2022 13:15:53 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 19 Nov 2022 13:19:04 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <srini.raju@purelifi.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH net] wifi: plfxlc: fix potential memory leak in __lf_x_usb_enable_rx()
Date:   Sat, 19 Nov 2022 13:19:00 +0800
Message-ID: <20221119051900.1192401-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

urbs does not be freed in exception paths in __lf_x_usb_enable_rx().
That will trigger memory leak. To fix it, add kfree() for urbs within
"error" label. Compile tested only.

Fixes: 68d57a07bfe5 ("wireless: add plfxlc driver for pureLiFi X, XL, XC devices")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/wireless/purelifi/plfxlc/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
index 39e54b3787d6..76d0a778636a 100644
--- a/drivers/net/wireless/purelifi/plfxlc/usb.c
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -247,6 +247,7 @@ static int __lf_x_usb_enable_rx(struct plfxlc_usb *usb)
 		for (i = 0; i < RX_URBS_COUNT; i++)
 			free_rx_urb(urbs[i]);
 	}
+	kfree(urbs);
 	return r;
 }
 
-- 
2.25.1

