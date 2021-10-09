Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBABD427CBE
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhJISrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhJISrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:47:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D170DC061762
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 11:45:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ls18so10032937pjb.3
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 11:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7yqKDBx+BYgoTha9tb+h3Ene4dSXgout69kiKn+t0tw=;
        b=L/bp33Z04/KS0KPjSPlXdLMPwSp98zHFP94/SsVsR7s/FBdoBKQT/Oj3ATxebLmLGk
         0/gJ/adgIMoDph7ZkDnB/6sSKHVdPLaTKDVnePstR+sVP2MZXUVphIW42aZH0/A9fog+
         IzqRK3Sg5beL3zTTAi/Mir4kgVswW26NTbZ5dHmG5cyzMlckBm6NatZwbLvuSA3YXJnI
         mhtEyfDq1uwmIKYSlc5+nnRjogo8zDK6MiLy69yE3QeizKJkGp/fDXmBZa4ZhEOimXeb
         7XdnxmxsfSQGu1eIaamyoXa1xXRbFIMGSexcu+hmuL9LpqMso8E3ja36u3npNO0E9Jmt
         np/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7yqKDBx+BYgoTha9tb+h3Ene4dSXgout69kiKn+t0tw=;
        b=E1kMqyUQBQ0f1NpJDR5gZFcvbBfyGCaXaqyO0ns5GaU/d64N6PsfyHxInIe8Ci1f+f
         dza024isshhD8qkkL7aCQWHBDtzeOigetQQ+DlL4oUS6gpMQwyaOuBkSyP2Lwho2pchY
         S8KNVKsK18NS+X8iHvdp+oCis0yPXBc18/W6zw5AME7qZ/VsnGpIJOE2nt8gSBM0JbFa
         aVXOCfI5YwLiXpMackos29thpRBdEBWsgjJQbg8q4yRW1vzc/XMRSeXsyZ/yM8at211b
         6Y9CrZFtsPmeqH3Z+ZC/m8YB4IoJzgh3r2aKTdyeN/YxXb6OYkV/8xb/fQ3aeH29M2OW
         2uIw==
X-Gm-Message-State: AOAM532KoDXUUd/Q/NNdtFnQ2d3nUNL4kBp5Ew++4/jXKJAiAH5s8oY9
        tmGWgydhVVBI6ZMHixMJFp5BoQ==
X-Google-Smtp-Source: ABdhPJz//w4BLF7092fC295xKiu/DLalmQfo6djewaf7iQZtC5jjMsBq/xFgrr8CKLDhBdy6RwBhWA==
X-Received: by 2002:a17:90a:430e:: with SMTP id q14mr20085029pjg.55.1633805134387;
        Sat, 09 Oct 2021 11:45:34 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s30sm3368433pgo.39.2021.10.09.11.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:45:34 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/9] ionic: remove mac overflow flags
Date:   Sat,  9 Oct 2021 11:45:17 -0700
Message-Id: <20211009184523.73154-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211009184523.73154-1-snelson@pensando.io>
References: <20211009184523.73154-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The overflow flags really aren't useful and we don't need lif
struct elements to track them.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 7 ++-----
 drivers/net/ethernet/pensando/ionic/ionic_lif.h | 2 --
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 968403a01477..4a080612142a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1283,14 +1283,11 @@ void ionic_lif_rx_mode(struct ionic_lif *lif)
 	 *       to see if we can disable NIC PROMISC
 	 */
 	nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
+
 	if ((lif->nucast + lif->nmcast) >= nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_PROMISC;
 		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
-		lif->uc_overflow = true;
-		lif->mc_overflow = true;
-	} else if (lif->uc_overflow) {
-		lif->uc_overflow = false;
-		lif->mc_overflow = false;
+	} else {
 		if (!(nd_flags & IFF_PROMISC))
 			rx_mode &= ~IONIC_RX_MODE_F_PROMISC;
 		if (!(nd_flags & IFF_ALLMULTI))
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 41f28154745f..541aa54e4ffd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -189,8 +189,6 @@ struct ionic_lif {
 	u16 rx_mode;
 	u64 hw_features;
 	bool registered;
-	bool mc_overflow;
-	bool uc_overflow;
 	u16 lif_type;
 	unsigned int nmcast;
 	unsigned int nucast;
-- 
2.17.1

