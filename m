Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E181C1CA2
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 20:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729875AbgEASLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 14:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729332AbgEASLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 14:11:17 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488C9C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 11:11:16 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a5so204227pjh.2
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 11:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BZsHf5AKOutJFbCwezhdB10mDOeX5ahmWLrbRQD+uis=;
        b=IJUnfcKzykkbCloTEIGND9p9hq7hQInOu14q4yz1a17W/uLpBz/oxC2RuVi99vq6tC
         oUKabEfG5B4q4D2RCy64WCPG5s+8DT0bJdf8hDL31UavJCdvK8Zccy4Af7f9qcw2ce/x
         KBrONIsOf4FuGosGrZSXi+1BEHP9eYd/FmSXbltJmkFZ010LW+HwEekf7BKTbNgByuna
         ZK78mTMOQqb2ACyZYVDsgwDGEQC7jURm7JMYyb+SJ7bzfSSWxn9CY0ayqHdOyikYXCW8
         oeCVU9iDy5vy5GBhq+x0dbT2o6aJCVCQR2MVt7IOQhAUdGJKTl6UrbP6Zl4/ZqEBoryy
         UuIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BZsHf5AKOutJFbCwezhdB10mDOeX5ahmWLrbRQD+uis=;
        b=RaU9pZsN6O4UpuzN3K1D7rylUncO3UeS8avyPa3jwTFckaEdJZNrEnwSMzyqzcf/zL
         xtxPgoijJgoYOxGsvGFIIEOe7YCjmyV2j/R4InON1vqeqI4x9lId2FSHCWPRFTgDZjCa
         CGQrHtTY9Pr6Opts/q49aJW2gHtkCnvwqqe1PVPZBlUbCXlc35WEx/zhGBdcfkdG/HJD
         lLfzm5NGMf+E6GcwVM3pP31Q8tS1rWrS0TTvr5khkC3BhOlarz5ueEwd4fl2FI1pfI44
         ASHU7cdPU4JqhNvMr1KfzT9JOWMg/qFAwuCS2FSNWXGUxaG863fIxFw9evRc6Y+fAUoY
         xeQg==
X-Gm-Message-State: AGi0PuZa/Dago08vciMVmUAWmtbmbHPDn5876FSPA4JfTaD36KBqEdJj
        /rK6u4DeJLNC6SxH53SJ2uJe3cNRmCU=
X-Google-Smtp-Source: APiQypLBWPbc+69XvCXHR95RmX0VZ3+EN+kYhpo7/GwAr2mxLRdA7qKYu+9i/22WqjfuUcPXzx16Og==
X-Received: by 2002:a17:902:6b85:: with SMTP id p5mr5602802plk.315.1588356675414;
        Fri, 01 May 2020 11:11:15 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id d12sm2881138pfq.36.2020.05.01.11.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 11:11:14 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Gengming Liu <l.dmxcsnsbh@gmail.com>
Subject: [Patch net] atm: fix a UAF in lec_arp_clear_vccs()
Date:   Fri,  1 May 2020 11:11:08 -0700
Message-Id: <20200501181109.14542-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gengming reported a UAF in lec_arp_clear_vccs(),
where we add a vcc socket to an entry in a per-device
list but free the socket without removing it from the
list when vcc->dev is NULL.

We need to call lec_vcc_close() to search and remove
those entries contain the vcc being destroyed. This can
be done by calling vcc->push(vcc, NULL) unconditionally
in vcc_destroy_socket().

Another issue discovered by Gengming's reproducer is
the vcc->dev may point to the static device lecatm_dev,
for which we don't need to register/unregister device,
so we can just check for vcc->dev->ops->owner.

Reported-by: Gengming Liu <l.dmxcsnsbh@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/atm/common.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/atm/common.c b/net/atm/common.c
index 0ce530af534d..8575f5d52087 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -177,18 +177,18 @@ static void vcc_destroy_socket(struct sock *sk)
 
 	set_bit(ATM_VF_CLOSE, &vcc->flags);
 	clear_bit(ATM_VF_READY, &vcc->flags);
-	if (vcc->dev) {
-		if (vcc->dev->ops->close)
-			vcc->dev->ops->close(vcc);
-		if (vcc->push)
-			vcc->push(vcc, NULL); /* atmarpd has no push */
-		module_put(vcc->owner);
-
-		while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
-			atm_return(vcc, skb->truesize);
-			kfree_skb(skb);
-		}
+	if (vcc->dev && vcc->dev->ops->close)
+		vcc->dev->ops->close(vcc);
+	if (vcc->push)
+		vcc->push(vcc, NULL); /* atmarpd has no push */
+	module_put(vcc->owner);
+
+	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
+		atm_return(vcc, skb->truesize);
+		kfree_skb(skb);
+	}
 
+	if (vcc->dev && vcc->dev->ops->owner) {
 		module_put(vcc->dev->ops->owner);
 		atm_dev_put(vcc->dev);
 	}
-- 
2.26.1

