Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F513EBF2D
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 03:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbhHNBEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 21:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbhHNBEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 21:04:14 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1989C061756;
        Fri, 13 Aug 2021 18:03:46 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n12so13525487plf.4;
        Fri, 13 Aug 2021 18:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0yJYp34jS7HaoczU14zrBhvwWwEhufHlCd1XxfoZIoE=;
        b=k3vuKjD6AIK+QNGAOsIiDAzgPh6+IW4zRAIrJsFhWiBaOCYmD4D1igV4tlBjss1IwE
         ZTIpey0xjPbE84lRbz2Qh0ukojdSzdzQaWhmXjtjdePtMLaDZ9eLKaayondv+qQoT+b4
         HmCVqn3YmFdXvSI37ZE3XlaFCqUVf87FIvdqYpumB9JGJjCKtUnsyguzhvy3lJHCXime
         Ncsm/ia0YuoTVjGV1XjvbGgy99itmH95yOuAm1KvyZFM0klBUXsKsn5yQgaSHGCFRNII
         X4M2AsUlpZCSYWj1v76VWmCJ+6NM2x7NKgcLWUPh+Xtsve7Itok2BNr5dLao6ySuPEVf
         M0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0yJYp34jS7HaoczU14zrBhvwWwEhufHlCd1XxfoZIoE=;
        b=bVXHG/AnHbJ10oj3NZEax1chN8u2JjwCU6L5xeKHgxQD+J1fs90n6KiAkdS5AUBVjN
         PCkc2s3ErzRkXhuD9TcvFLxBr1JLpsg9dXjt6m7+QDbTjrFRgFeTPEAxnhwFPZgkdgR0
         z7mVyYNH0q66VKMgluQRB1CvNpq4vyGQGDEOD4LBU7xkIZ6SGSshig8+ZWqEecGrkywo
         NrTH8JXXDwfeB2P02OEEhLNTgX/msP9q+PSfzru0t2MVEBLACF3aWZEflVnn1dfiMuDc
         8oLm13tzX5OoehKi6MMoCNpqywL/86MSxtCOvS6SlBOAhzykiojmabaJTLxdQv4q6gKt
         dD6Q==
X-Gm-Message-State: AOAM533/9Pytw9SqLmVeC55kHVBagwNzFprrgEHWgXmP59xmfUwynpSE
        QdLGtSVjWiiuZSUtY8IzJas=
X-Google-Smtp-Source: ABdhPJz483SR0lnCz682BIATmNAGb8xdrQqdDWSF24iul+HZ2k4nvgZVSCXhHmdUwrENK+39pE5rQg==
X-Received: by 2002:a62:8042:0:b029:3cd:8339:7551 with SMTP id j63-20020a6280420000b02903cd83397551mr4943639pfd.79.1628903026391;
        Fri, 13 Aug 2021 18:03:46 -0700 (PDT)
Received: from WRT-WX9.. ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id on15sm2776859pjb.19.2021.08.13.18.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 18:03:46 -0700 (PDT)
From:   Changbin Du <changbin.du@gmail.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Changbin Du <changbin.du@gmail.com>
Subject: [PATCH] s390/net: replace in_irq() with in_hardirq()
Date:   Sat, 14 Aug 2021 09:03:34 +0800
Message-Id: <20210814010334.4075-1-changbin.du@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the obsolete and ambiguos macro in_irq() with new
macro in_hardirq().

Signed-off-by: Changbin Du <changbin.du@gmail.com>
---
 drivers/s390/net/ctcm_fsms.c | 2 +-
 drivers/s390/net/ctcm_mpc.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
index 377e3689d1d4..06281a0a0552 100644
--- a/drivers/s390/net/ctcm_fsms.c
+++ b/drivers/s390/net/ctcm_fsms.c
@@ -1444,7 +1444,7 @@ static void ctcmpc_chx_rx(fsm_instance *fi, int event, void *arg)
 			if (do_debug_ccw)
 			ctcmpc_dumpit((char *)&ch->ccw[0],
 					sizeof(struct ccw1) * 3);
-		dolock = !in_irq();
+		dolock = !in_hardirq();
 		if (dolock)
 			spin_lock_irqsave(
 				get_ccwdev_lock(ch->cdev), saveflags);
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index 19ee91acb89d..f0436f555c62 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -1773,7 +1773,7 @@ static void mpc_action_side_xid(fsm_instance *fsm, void *arg, int side)
 	CTCM_D3_DUMP((char *)ch->xid, XID2_LENGTH);
 	CTCM_D3_DUMP((char *)ch->xid_id, 4);
 
-	if (!in_irq()) {
+	if (!in_hardirq()) {
 			 /* Such conditional locking is a known problem for
 			  * sparse because its static undeterministic.
 			  * Warnings should be ignored here. */
-- 
2.30.2

