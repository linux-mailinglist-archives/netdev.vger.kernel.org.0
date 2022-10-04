Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7075F4092
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 12:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiJDKM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 06:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiJDKMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 06:12:24 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9AC28711;
        Tue,  4 Oct 2022 03:12:23 -0700 (PDT)
Received: from lenovo.Home (unknown [39.45.148.204])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 713DC6601A43;
        Tue,  4 Oct 2022 11:12:17 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1664878342;
        bh=i0FOyOJitjB3rivlOUVsPgHHrU9fXSmrQW1VoDwnAqk=;
        h=From:To:Cc:Subject:Date:From;
        b=LGloIE8hXSiui08//z5wEic2e+LZAD8ZPaHHFGl6eL4NpDKnSc2Ce0vKDoJ8ko6QP
         yI+SXxdH9JGKcWbunxKhdBonWb9nf2oE3XmmCbl1K8EJU/v6JNyVsQFgTJk//jafLf
         vRsYOpTvivWUNIS0nhD4XInIZynwBBeTXa8jV/7zzcr+MCsQTnTtQ1jMLWujkq5FZY
         D6IAIFoUhNADowuBLyNdyjHqASBzg9q4W2H74Y4B28TlJ4ZclAiwHmrGBxVrbAaOI7
         99bGMV6OgaRdx5019SZw7hC7sFSmIO+cqI0pfczgEv5kyqOQHBOHFy0Z2t1qqFJJIx
         0TOM37dCXltRg==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Long Li <longli@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Ajay Sharma <sharmaajay@microsoft.com>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com, kernel-janitors@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: mana: store return status in signed variable
Date:   Tue,  4 Oct 2022 15:11:57 +0500
Message-Id: <20221004101200.758009-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mana_adev_idx_alloc() can return negative value. Save its return
value in ret which is signed variable and check if it is correct value.

Fixes: ee928282bfa7 ("net: mana: Add support for auxiliary device")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 7ca313c7b7b3..1c59502d34b5 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2203,11 +2203,10 @@ static int add_adev(struct gdma_dev *gd)
 		return -ENOMEM;
 
 	adev = &madev->adev;
-	adev->id = mana_adev_idx_alloc();
-	if (adev->id < 0) {
-		ret = adev->id;
+	ret = mana_adev_idx_alloc();
+	if (ret < 0)
 		goto idx_fail;
-	}
+	adev->id = ret;
 
 	adev->name = "rdma";
 	adev->dev.parent = gd->gdma_context->dev;
-- 
2.30.2

