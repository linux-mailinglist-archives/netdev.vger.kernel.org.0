Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166EA262AC3
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgIIIqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729529AbgIIIpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:45:52 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1E1C061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:45:52 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id kk9so1007700pjb.2
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eltetlEldzIfJhovhP39Rfc22NaOZQYWWy9LAhYYuUY=;
        b=D5WM86PnwdHnUuJ0ECwpSfP1k3o9DdHvCS/HWRZJVdSQ9cgqnMm0odw6iYFKiTUrP8
         9yj39Z4Bjb1HVOgVmXMY0PT7PGfvSM0rkreVYNzIaIFarny1dBCAmQhMuEFncnVVvEPY
         KSejfj9Z8Zv200sGKdTODiE6XaZWypyysDsloyWpBMdWE419F9+hoB22/H2XSJ/cLili
         GQPYV0Numbi/VckdRg0WxVOVxRpbDc67z9k1FL08qHvR2GY5VYAhXF4pfBx/LRFxebJh
         L2xtBZkdVma5r3jRSf3sgkisZ/8GP7aNzhiVp0ST4GbRm9Y+qK/A5hLO3fXap+fbKYrw
         BYDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eltetlEldzIfJhovhP39Rfc22NaOZQYWWy9LAhYYuUY=;
        b=RBFfTggSEt/8oY9cK9lybFJ8UxK+Cg3c7wKDBn4gEVDAgDnz7wygIDzIu7U9/Qu+Kq
         2iza2wI4KaZpfbzz0QvO9eQpodWPnilvHAkYrfnbru6h8Hpwn1SUAw7m0mtXZLUUogZX
         P4QaEc3+x23ksxKERt3oCsw8Bg0zmQ1HEChQ9VCwXnA9vxS+0xlRCKRo4USigfyWRMz0
         B5Yhe5tuxwf+cIUTQ7DX1YRtRSaBZkgudezNT9A8KDXpIVEkVYkVQzK6kNb/F+w3WtYN
         r3Cy7UVsJJNaMejD1AOALko1vNGYrmgis8v5rIpK9fUZfvZ/a2P2ClF1bCn1sOrSnvWP
         ldnw==
X-Gm-Message-State: AOAM531DXZy3fBvL524KFki/ca2DTRMsLOgwZJWq+s7wT/UOsk1Zb7nj
        a7MArASAFDwT55DMcK22xYE=
X-Google-Smtp-Source: ABdhPJw/yf/WlZMnCfNhnxxGsR3rEfepxlg6v4BcdI0crI9SBlGDJklXroyxGlihwf3SZAu4UB1GCg==
X-Received: by 2002:a17:90a:9912:: with SMTP id b18mr2800280pjp.192.1599641151672;
        Wed, 09 Sep 2020 01:45:51 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:45:51 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 08/20] ethernet: hinic: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:14:58 +0530
Message-Id: <20200909084510.648706-9-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200909084510.648706-1-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index ca8cb68a8d20..6df720115fa1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
@@ -368,11 +368,11 @@ static void eq_irq_work(struct work_struct *work)
 
 /**
  * ceq_tasklet - the tasklet of the EQ that received the event
- * @ceq_data: the eq
+ * @t: pointer to the tasklet associated with this handler
  **/
-static void ceq_tasklet(unsigned long ceq_data)
+static void ceq_tasklet(struct tasklet_struct *t)
 {
-	struct hinic_eq *ceq = (struct hinic_eq *)ceq_data;
+	struct hinic_eq *ceq = from_tasklet(ceq, t, ceq_tasklet);
 
 	eq_irq_handler(ceq);
 }
@@ -782,8 +782,7 @@ static int init_eq(struct hinic_eq *eq, struct hinic_hwif *hwif,
 
 		INIT_WORK(&aeq_work->work, eq_irq_work);
 	} else if (type == HINIC_CEQ) {
-		tasklet_init(&eq->ceq_tasklet, ceq_tasklet,
-			     (unsigned long)eq);
+		tasklet_setup(&eq->ceq_tasklet, ceq_tasklet);
 	}
 
 	/* set the attributes of the msix entry */
-- 
2.25.1

