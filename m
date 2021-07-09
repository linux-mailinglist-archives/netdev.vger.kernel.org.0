Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DB93C2592
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 16:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhGIOMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 10:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhGIOMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 10:12:46 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AA9C0613DD;
        Fri,  9 Jul 2021 07:10:02 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id t17so23586802lfq.0;
        Fri, 09 Jul 2021 07:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BcZP/dMv+LJ1QPyB/xk0twZZ75kS4mkrcUJiW/RXVtM=;
        b=BQfWEhuSdChqo/sGlnKMMThv/67QGfT21UYWvdaSoAeb1UObBTRR7yF+NbkNIMg3V5
         QhDc0nB3Q3ZDF9VAjAymxigZDRJhMK2QsxDs+FtrWlqwsdkxE5b6ExS9eLPHVuw9wDhF
         NnFdxrdeKIIp/BeA6ggMeleu0y159mZ9pHQVwSsjv7mkDEVxJ9+UBah+HhHvgD+xrbbg
         TZ6b492oKgrhyafPhdsdhQObe5XziKJ/3w+1gkDKMbdgy1C6bhltzZg+MpkGlE1g2oR8
         v4ozgGGNfWqhv5stlpBfrqpdiXNYcboSXI/ajUXNRywzH8+ajSnnKvATJ4LKT5W3TmW8
         ycPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BcZP/dMv+LJ1QPyB/xk0twZZ75kS4mkrcUJiW/RXVtM=;
        b=ZIF4RsW8cYY1KVbn/XjSku1qi3TQaj4weP8QiGBTZlfcndI4wTlsSnBjAJKRs7D3dj
         tEmehZqZUdjvbR0ZXGmbStpobTf4czoGO8rOoVGkhEPeAFy9sgobZa1r6pfeeSRPQTj0
         KLKw+EjkOmQkGlQURh5TJLBKniCxul4ql6A14+dJc0mTB/mEK1qJbSs9b2Shc/mxo++H
         lcygjCVODKXnS+wR/PI/owzPoISfRhXfvkqUzHVpvHAoi7lxfw4wGQpBUZHbo5Elcqso
         18HPqN/etu14FCbsqphzNDzelzTniksaMLWsQ+CXQgL50kXmrzZgekeYdy6qZ8jiR3bO
         rlsw==
X-Gm-Message-State: AOAM530mygIP6d8juEtCtRob25KS25sjO36jNWh6EFH9woXjLmXqVgU1
        DV3eoF3LzOc+IDFCJpYyG3w=
X-Google-Smtp-Source: ABdhPJwr0qVXuUkriN20AC8cwgTrLf8FtXYMrhOr+W2QxFlWI6dCuwnHzWJVEC8GXigcjSLtOqM87Q==
X-Received: by 2002:ac2:5a1d:: with SMTP id q29mr21660907lfn.550.1625839800876;
        Fri, 09 Jul 2021 07:10:00 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id l25sm483865ljc.77.2021.07.09.07.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 07:10:00 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, huangguobin4@huawei.com,
        jonas.jensen@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: moxa: fix UAF in moxart_mac_probe
Date:   Fri,  9 Jul 2021 17:09:53 +0300
Message-Id: <20210709140953.1063-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of netdev registration failure the code path will
jump to init_fail label:

init_fail:
	netdev_err(ndev, "init failed\n");
	moxart_mac_free_memory(ndev);
irq_map_fail:
	free_netdev(ndev);
	return ret;

So, there is no need to call free_netdev() before jumping
to error handling path, since it can cause UAF or double-free
bug.

Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index b85733942053..b46bba9f4846 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -541,10 +541,8 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	ret = register_netdev(ndev);
-	if (ret) {
-		free_netdev(ndev);
+	if (ret)
 		goto init_fail;
-	}
 
 	netdev_dbg(ndev, "%s: IRQ=%d address=%pM\n",
 		   __func__, ndev->irq, ndev->dev_addr);
-- 
2.32.0

