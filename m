Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58EC47EE48
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403808AbfHBIFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:05:39 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44163 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbfHBIFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:05:39 -0400
Received: by mail-pf1-f195.google.com with SMTP id t16so35590991pfe.11;
        Fri, 02 Aug 2019 01:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U/7XoqSbD9Dh68AovFvHr1hJrd/DYYI+CgMoNNTSf9w=;
        b=E4HDzTBYcVRY+uhx0pJGuE5aYV4TLgaLTxLql7D5D9pYtLSQBW+894bZEXO3kenuDd
         RA4H8ot7DsojEfJIjWqe0kgoiDsd0kVhFj0/pcs0ppwzHabW4AN+x4ieL4kcgAktVThi
         KQRalNusev7QfVMH0lkvzVWUkEmT1sddu4D+DMUl5ew5rgx1wWuQ5sRnWwST2ZPzYi8/
         V3OD7u9IuqJ+D/cGKxX2dnIBhhLzKh5/Q+UnccdHWvEKqgjmUZDTIUPefuqfBV2J2ROW
         VOWVBTwLzwX/eSBxrwuaQe1xGmV7svRYUrQ42V5lI1CzFc85nNShL6Tswk3io7/mE+xz
         bAxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U/7XoqSbD9Dh68AovFvHr1hJrd/DYYI+CgMoNNTSf9w=;
        b=tIDwRZaHBxZbywP/kpVIiN2OVO2Lcc0orao1jbJKAMmrgfdoFgVu1W23pHzDDy0EGp
         CdzDZnDY2OGK2SYLjrKhWe2gjmjN3EunhhBwQ7EoYOIaLUjD4C1qejlgR5MIUvjW2Q0g
         x80heLvVrRvY/FKLv9lTsocxBawaMaQoYql4Z6GD7x/VxrkyYKWbWyb5pHgq0YxufkJ4
         FGZlVxnprktTPZkhdnXBANzyv+uZF2sc+cmLC1ZIg6wShlf8GKSP2s9VrxjQ4JkElLCB
         ubezGvlh+sfTStfwi59CN+HVE0EN9lMiq2gN9vVed2dVS/k1vXpry+lhixXT7deLgXux
         RyJQ==
X-Gm-Message-State: APjAAAU9dR2VfnBYf/T+kOf9/msdurcQtEHGxzLJbfccpm3Upzq3Apes
        R+f8iQzOg21K6hCbO3tJa5A=
X-Google-Smtp-Source: APXvYqxbIaCCRdoCWFGtSRh5dk57uTj494w6QLCHTlcVOSHX1DgbUZZGszohaHCfaR0bHuNA2FI0WQ==
X-Received: by 2002:a65:5584:: with SMTP id j4mr92405426pgs.258.1564733138457;
        Fri, 02 Aug 2019 01:05:38 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id 3sm77759066pfg.186.2019.08.02.01.05.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 01:05:37 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2 1/2] bnxt_en: Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 16:05:29 +0800
Message-Id: <20190802080529.11168-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v2:
  - Convert refcount from 0-base to 1-base.

 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 8 ++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index fc77caf0a076..742a8ed200cb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -49,7 +49,7 @@ static int bnxt_register_dev(struct bnxt_en_dev *edev, int ulp_id,
 			return -ENOMEM;
 	}
 
-	atomic_set(&ulp->ref_count, 0);
+	refcount_set(&ulp->ref_count, 1);
 	ulp->handle = handle;
 	rcu_assign_pointer(ulp->ulp_ops, ulp_ops);
 
@@ -87,7 +87,7 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, int ulp_id)
 	synchronize_rcu();
 	ulp->max_async_event_id = 0;
 	ulp->async_events_bmap = NULL;
-	while (atomic_read(&ulp->ref_count) != 0 && i < 10) {
+	while (refcount_read(&ulp->ref_count) != 1 && i < 10) {
 		msleep(100);
 		i++;
 	}
@@ -246,12 +246,12 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev, int ulp_id,
 
 static void bnxt_ulp_get(struct bnxt_ulp *ulp)
 {
-	atomic_inc(&ulp->ref_count);
+	refcount_inc(&ulp->ref_count);
 }
 
 static void bnxt_ulp_put(struct bnxt_ulp *ulp)
 {
-	atomic_dec(&ulp->ref_count);
+	refcount_dec(&ulp->ref_count);
 }
 
 void bnxt_ulp_stop(struct bnxt *bp)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index cd78453d0bf0..fc4aa582d190 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -52,7 +52,7 @@ struct bnxt_ulp {
 	u16		max_async_event_id;
 	u16		msix_requested;
 	u16		msix_base;
-	atomic_t	ref_count;
+	refcount_t	ref_count;
 };
 
 struct bnxt_en_dev {
-- 
2.20.1

