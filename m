Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D864D6E11
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 11:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiCLK21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 05:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiCLK2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 05:28:24 -0500
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D631E7A6B;
        Sat, 12 Mar 2022 02:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=13mCydMK3ZTDSn8+n91omN6RvcvIaMym7+9DGgEIYSE=;
  b=ldu364k1QFGBFDbdZ+iM5EyVIXN7g7HSFDJ8SmCVkljd/KV9dyqcOouY
   ZozD09ySl0pKK3dGwCKbBJ9shjatJaa9Kdh8nOlnjI0vbHpmhzz20pbdT
   Ugo33+12IWPJl2KXtIxjvgbS0CfV4H4HaD4aYP1vgpez5VbQgwbY8lzZ3
   o=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,175,1643670000"; 
   d="scan'208";a="25781351"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2022 11:27:11 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] zd1201: use kzalloc
Date:   Sat, 12 Mar 2022 11:27:04 +0100
Message-Id: <20220312102705.71413-6-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220312102705.71413-1-Julia.Lawall@inria.fr>
References: <20220312102705.71413-1-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kzalloc instead of kmalloc + memset.

The semantic patch that makes this change is:
(https://coccinelle.gitlabpages.inria.fr/website/)

//<smpl>
@@
expression res, size, flag;
@@
- res = kmalloc(size, flag);
+ res = kzalloc(size, flag);
  ...
- memset(res, 0, size);
//</smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/net/wireless/zydas/zd1201.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zydas/zd1201.c b/drivers/net/wireless/zydas/zd1201.c
index e64e4e579518..82bc0d44212e 100644
--- a/drivers/net/wireless/zydas/zd1201.c
+++ b/drivers/net/wireless/zydas/zd1201.c
@@ -521,7 +521,7 @@ static int zd1201_setconfig(struct zd1201 *zd, int rid, const void *buf, int len
 	zd->rxdatas = 0;
 	zd->rxlen = 0;
 	for (seq=0; len > 0; seq++) {
-		request = kmalloc(16, gfp_mask);
+		request = kzalloc(16, gfp_mask);
 		if (!request)
 			return -ENOMEM;
 		urb = usb_alloc_urb(0, gfp_mask);
@@ -529,7 +529,6 @@ static int zd1201_setconfig(struct zd1201 *zd, int rid, const void *buf, int len
 			kfree(request);
 			return -ENOMEM;
 		}
-		memset(request, 0, 16);
 		reqlen = len>12 ? 12 : len;
 		request[0] = ZD1201_USB_RESREQ;
 		request[1] = seq;

