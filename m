Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160C253B7B3
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 13:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiFBLVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 07:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbiFBLVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 07:21:53 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD5D20E500
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 04:21:50 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id f35so3117260qtb.11
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 04:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mtu.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SLgonzI0VScBYhnwylVA+bbXs3ZiekQ33fitxBCDl5s=;
        b=A2Fm1HpxkVGF2FTTsOA/UDzfbouzZBtTw3QG+6mkf7Zl/Ope/BGFtICnK0/bCfrPOy
         DpLBSudOjwuTLh2P6KgCjU6rmb4wwXg52978wXTA/KUc5M0l5rc9TckUEYStrUIBNCDU
         B2cQPQsc6WEgjUSKHa0RGCdmr7GmV0jgc8zLtSWA/4GTYCf0d17hIxF4RR+RIW3DH3ZL
         Zbb3Sf1B+QUDKVP8bCF7oDwmLHvxk0tE7Vc8pAjf8ApZQmSPVUs1tl04NgJYGjxWk7kt
         dO5oX/4IUMZLJOhnamJRorXeWm5rnwJeoi2Fect3lRCU8YxB1wJ1xZReQ+FaUqiv63FF
         RyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SLgonzI0VScBYhnwylVA+bbXs3ZiekQ33fitxBCDl5s=;
        b=Hxd0Xgnwe9QU1nuXIPlPSx9CwURy1JSZ2Q6xPnESAPbwsWqYZaxcft88OaEHWXKhUk
         xmDR2uo50HK9YIrS+RiHqbyCiTWKIpUCyahE2d4meC+I8k0vv+vJIie5Efv3nDLkq0H9
         8Sz8RMN6/6iyalWpM0Psxf0B3xEs7EaWIHYx/nPjOO/ht8+nIW8bb8PnU379jr4GHc7d
         EOu43IY/4+q2f1wbEHvWR03cFLYDtaCRhzfm999Q140hkBgKrdc4igYEP4CeS6zWyA1x
         kmpibbAc0U81Q0ulf8BmFTjmydg7HPTtb5n5I43S62LMZa+I6HYWYegkfW61eTUhL/T7
         qgKg==
X-Gm-Message-State: AOAM533SL7rHO0CRkBh+94f1JdP1KRjgrXr7tlMaF0HFT0pW0sJYwtbQ
        bhpWvik3oOFV02wL2CiRdkG3cQ==
X-Google-Smtp-Source: ABdhPJyrem9Bifu0bCmyxJcYxnWHtctEbDvwq5+xOlPYk4ylOqsbqagwRWbAbZZ/Y1KeWFGXQvDjQQ==
X-Received: by 2002:a05:622a:34e:b0:2f8:695b:ce78 with SMTP id r14-20020a05622a034e00b002f8695bce78mr3098231qtw.548.1654168909188;
        Thu, 02 Jun 2022 04:21:49 -0700 (PDT)
Received: from localhost.localdomain (z205.pasty.net. [71.13.100.205])
        by smtp.gmail.com with ESMTPSA id e17-20020ac85991000000b002f9303ce545sm2986174qte.39.2022.06.02.04.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 04:21:48 -0700 (PDT)
From:   Peter Lafreniere <pjlafren@mtu.edu>
To:     linux-hams@vger.kernel.org
Cc:     ralf@linux-mips.org, netdev@vger.kernel.org,
        Peter Lafreniere <pjlafren@mtu.edu>
Subject: [PATCH] ax25: use GFP_KERNEL over GFP_ATOMIC where possible
Date:   Thu,  2 Jun 2022 07:21:38 -0400
Message-Id: <20220602112138.8200-1-pjlafren@mtu.edu>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few functions that can sleep that use GFP_ATOMIC.
Here we change allocations to use the more reliable GFP_KERNEL
flag.

ax25_dev_device_up() is only called during device setup, which is
done in user context. In addition, ax25_dev_device_up()
unconditionally calls ax25_register_dev_sysctl(), which already
allocates with GFP_KERNEL.

ax25_rt_add() is a static function that is only called from
ax25_rt_ioctl(), which must run in user context already due to
copy_from_user() usage.

Since it is allowed to sleep in both of these functions, here we
change the functions to use GFP_KERNEL to reduce unnecessary
out-of-memory errors.

Signed-off-by: Peter Lafreniere <pjlafren@mtu.edu>
---
 net/ax25/ax25_dev.c   | 4 ++--
 net/ax25/ax25_route.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index d2a244e1c260..b264904980a8 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -52,7 +52,7 @@ void ax25_dev_device_up(struct net_device *dev)
 {
 	ax25_dev *ax25_dev;
 
-	if ((ax25_dev = kzalloc(sizeof(*ax25_dev), GFP_ATOMIC)) == NULL) {
+	if ((ax25_dev = kzalloc(sizeof(*ax25_dev), GFP_KERNEL)) == NULL) {
 		printk(KERN_ERR "AX.25: ax25_dev_device_up - out of memory\n");
 		return;
 	}
@@ -60,7 +60,7 @@ void ax25_dev_device_up(struct net_device *dev)
 	refcount_set(&ax25_dev->refcount, 1);
 	dev->ax25_ptr     = ax25_dev;
 	ax25_dev->dev     = dev;
-	dev_hold_track(dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
+	dev_hold_track(dev, &ax25_dev->dev_tracker, GFP_KERNEL);
 	ax25_dev->forward = NULL;
 
 	ax25_dev->values[AX25_VALUES_IPDEFMODE] = AX25_DEF_IPDEFMODE;
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index b7c4d656a94b..c77b848ccfc7 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -91,7 +91,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 			kfree(ax25_rt->digipeat);
 			ax25_rt->digipeat = NULL;
 			if (route->digi_count != 0) {
-				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
+				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_KERNEL)) == NULL) {
 					write_unlock_bh(&ax25_route_lock);
 					ax25_dev_put(ax25_dev);
 					return -ENOMEM;
@@ -110,7 +110,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 		ax25_rt = ax25_rt->next;
 	}
 
-	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_ATOMIC)) == NULL) {
+	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_KERNEL)) == NULL) {
 		write_unlock_bh(&ax25_route_lock);
 		ax25_dev_put(ax25_dev);
 		return -ENOMEM;
-- 
2.36.1

