Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079C65FBF18
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 04:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiJLCQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 22:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiJLCQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 22:16:10 -0400
X-Greylist: delayed 411 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Oct 2022 19:16:09 PDT
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17397754AF
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 19:16:09 -0700 (PDT)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 578D2200E7; Wed, 12 Oct 2022 10:09:11 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1665540551;
        bh=D2hiRF0lLKd66CyRfU3xluW5hyNgIhgPf5y8CLjGkEA=;
        h=From:To:Cc:Subject:Date;
        b=f+sQbNvH+h51iuLm9T2qMGdXu/VLXcQmhVfj3GTr3eiB6xXneSTFnTTy9rizxpNGz
         LzI91hpDT7EgG47nWZ74TfRuVeehTbssyOt5H1XOVudbQM2VTAQ/o/U6NVd6yrZegs
         uZA/3lJ9caZwBV5eucdPIYhd0Kw/soAa9+LtGqFFbVQ4RBgfvJ0Zw1cLZZDy2p8FQf
         3J7a5Jc3LB3AcqN9zVjiuDqy6Dbu/GajdSdmd0dFcrP6sy5dNk/Zu7TenuWj0+r9kV
         ix8h5MRsMg3jaalgKeOUD/4jjbhUk0LIUZYXIDWzI9pY/vhVNitKNGdMxx1sHYHU/Q
         X2ONHEMz2R1WA==
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        butterflyhuangxx@gmail.com
Subject: [PATCH net] mctp: prevent double key removal and unref
Date:   Wed, 12 Oct 2022 10:08:51 +0800
Message-Id: <20221012020851.931298-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we have a bug where a simultaneous DROPTAG ioctl and socket
close may race, as we attempt to remove a key from lists twice, and
perform an unref for each removal operation. This may result in a uaf
when we attempt the second unref.

This change fixes the race by making __mctp_key_remove tolerant to being
called on a key that has already been removed from the socket/net lists,
and only performs the unref when we do the actual remove. We also need
to hold the list lock on the ioctl cleanup path.

This fix is based on a bug report and comprehensive analysis from
butt3rflyh4ck <butterflyhuangxx@gmail.com>, found via syzkaller.

Cc: stable@vger.kernel.org
Fixes: 63ed1aab3d40 ("mctp: Add SIOCMCTP{ALLOC,DROP}TAG ioctls for tag control")
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/af_mctp.c | 23 ++++++++++++++++-------
 net/mctp/route.c   | 10 +++++-----
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index c2fc2a7b2528..b6b5e496fa40 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -295,11 +295,12 @@ __must_hold(&net->mctp.keys_lock)
 	mctp_dev_release_key(key->dev, key);
 	spin_unlock_irqrestore(&key->lock, flags);
 
-	hlist_del(&key->hlist);
-	hlist_del(&key->sklist);
-
-	/* unref for the lists */
-	mctp_key_unref(key);
+	if (!hlist_unhashed(&key->hlist)) {
+		hlist_del_init(&key->hlist);
+		hlist_del_init(&key->sklist);
+		/* unref for the lists */
+		mctp_key_unref(key);
+	}
 
 	kfree_skb(skb);
 }
@@ -373,9 +374,17 @@ static int mctp_ioctl_alloctag(struct mctp_sock *msk, unsigned long arg)
 
 	ctl.tag = tag | MCTP_TAG_OWNER | MCTP_TAG_PREALLOC;
 	if (copy_to_user((void __user *)arg, &ctl, sizeof(ctl))) {
-		spin_lock_irqsave(&key->lock, flags);
-		__mctp_key_remove(key, net, flags, MCTP_TRACE_KEY_DROPPED);
+		unsigned long fl2;
+		/* Unwind our key allocation: the keys list lock needs to be
+		 * taken before the individual key locks, and we need a valid
+		 * flags value (fl2) to pass to __mctp_key_remove, hence the
+		 * second spin_lock_irqsave() rather than a plain spin_lock().
+		 */
+		spin_lock_irqsave(&net->mctp.keys_lock, flags);
+		spin_lock_irqsave(&key->lock, fl2);
+		__mctp_key_remove(key, net, fl2, MCTP_TRACE_KEY_DROPPED);
 		mctp_key_unref(key);
+		spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
 		return -EFAULT;
 	}
 
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 3b24b8d18b5b..2155f15a074c 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -228,12 +228,12 @@ __releases(&key->lock)
 
 	if (!key->manual_alloc) {
 		spin_lock_irqsave(&net->mctp.keys_lock, flags);
-		hlist_del(&key->hlist);
-		hlist_del(&key->sklist);
+		if (!hlist_unhashed(&key->hlist)) {
+			hlist_del_init(&key->hlist);
+			hlist_del_init(&key->sklist);
+			mctp_key_unref(key);
+		}
 		spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
-
-		/* unref for the lists */
-		mctp_key_unref(key);
 	}
 
 	/* and one for the local reference */
-- 
2.35.1

