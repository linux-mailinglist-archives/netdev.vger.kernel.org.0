Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F12306230
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 18:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344011AbhA0RhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 12:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343973AbhA0Rdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 12:33:51 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E974C061756;
        Wed, 27 Jan 2021 09:33:11 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id m13so2752578wro.12;
        Wed, 27 Jan 2021 09:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fj4w5JVOvyYwozMqFrFqKmciej530dUq7pjLBYsvO6g=;
        b=L4kV2uetbp1iN+hKJKMqjvx+UFqpmo9FHr/VWT9T30SvhUa3+/zHpp0gWc74abTjPe
         ta8KLBjNj7NKbkRoesjhTRWY53SRDeRg7pLT7i17qjw64I/quguXRYtaF6GzzGSXXL6k
         1SR83HvCRn6zwg/uLJ2cQv4nBDM/uz/60XMTQtzdQ+NjWxTGBWuGP50mEwGvls3AY6rH
         oMFL74bDXCgKKKDJ+aB6hRN7ZhuEOy6g9vz4SbAhoa+6qn54JOei+JMT1nRhxsML8etb
         zhFQDlZBUZ24iccXs9mBz6a6Xtt6TWFZELHcWqjnxC+1pw6YCziFhPOPGxhIIZocQQfa
         Wg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Fj4w5JVOvyYwozMqFrFqKmciej530dUq7pjLBYsvO6g=;
        b=FpaVv0uYIw3uKWksV9m0azdVZ+RnyjsCZ7THVdyDRdKUQEZdX8mbrWs0wyS87lA6ac
         lSa74bum2MGrs2BuY6TuSaF+5Ue4KoQvd9wXjOMxMhVaCSprTUTWEuVHUl0kjkdXdV4p
         TEazdmRT0W7yxIxyKROTXUHJp8bB17+pOY3RbdFg+crpqzF4rwSD1NkJyBTCm7xe6ZlF
         BgnObUrnbluL8EGNonOvALD2mxCuhzJ7P3NaxVm6Lh/v0hQP9X0lSWN5KIkE0c8IiQeH
         DwfSYkIi1oLKxwX5vY4X+jRs7EwQ0lVXoqPL0EpXGdzqjQZPzxVToJmYDZ1+VKJq2r8q
         aPVQ==
X-Gm-Message-State: AOAM533J69pCI5d5qby/A/mu0DODbkOBGM69MbNz9BtJoMZ4boEX38im
        yTi4ZVX6C5l0XPmehBwHFjfe9pANlh5s6Q==
X-Google-Smtp-Source: ABdhPJxdRMDEuUfGdFPniSDYztxhsAVv8syE4yO8MGO+CgZhnPwF8npZhiaxuTMA3V8VMBrGh8o1dw==
X-Received: by 2002:a5d:4389:: with SMTP id i9mr12164830wrq.272.1611768789081;
        Wed, 27 Jan 2021 09:33:09 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id m8sm3768636wrv.37.2021.01.27.09.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 09:33:08 -0800 (PST)
Sender: Emil Renner Berthing <emil.renner.berthing@gmail.com>
From:   Emil Renner Berthing <kernel@esmil.dk>
To:     netdev@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Mitchell Blank Jr <mitch@sfgoth.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: atm: pppoatm: use tasklet_init to initialize wakeup tasklet
Date:   Wed, 27 Jan 2021 18:32:55 +0100
Message-Id: <20210127173256.13954-1-kernel@esmil.dk>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously a temporary tasklet structure was initialized on the stack
using DECLARE_TASKLET_OLD() and then copied over and modified. Nothing
else in the kernel seems to use this pattern, so let's just call
tasklet_init() like everyone else.

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
 net/atm/pppoatm.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index 579b66da1d95..5f06af098390 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -389,11 +389,7 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, void __user *arg)
 	struct atm_backend_ppp be;
 	struct pppoatm_vcc *pvcc;
 	int err;
-	/*
-	 * Each PPPoATM instance has its own tasklet - this is just a
-	 * prototypical one used to initialize them
-	 */
-	static const DECLARE_TASKLET_OLD(tasklet_proto, pppoatm_wakeup_sender);
+
 	if (copy_from_user(&be, arg, sizeof be))
 		return -EFAULT;
 	if (be.encaps != PPPOATM_ENCAPS_AUTODETECT &&
@@ -415,8 +411,8 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, void __user *arg)
 	pvcc->chan.ops = &pppoatm_ops;
 	pvcc->chan.mtu = atmvcc->qos.txtp.max_sdu - PPP_HDRLEN -
 	    (be.encaps == e_vc ? 0 : LLC_LEN);
-	pvcc->wakeup_tasklet = tasklet_proto;
-	pvcc->wakeup_tasklet.data = (unsigned long) &pvcc->chan;
+	tasklet_init(&pvcc->wakeup_tasklet, pppoatm_wakeup_sender,
+		     (unsigned long)&pvcc->chan);
 	err = ppp_register_channel(&pvcc->chan);
 	if (err != 0) {
 		kfree(pvcc);
-- 
2.30.0

