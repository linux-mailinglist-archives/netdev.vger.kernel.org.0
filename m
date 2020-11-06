Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB9B2A8B28
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732680AbgKFAMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732660AbgKFAMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 19:12:34 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2721EC0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 16:12:34 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id v12so2650733pfm.13
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 16:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H4nDhqegF0EjT05ul4Hwr7UIDTMUmNY72Ijv6z2hAS0=;
        b=31zQo4w/qe1ztrYsbSVkHOm7mv6ghuMskhV8VvFg22P3ZVhJ9TD/lxJsHuZ21XtEvi
         WjXdHqmFxkQHrvDJ393p0/xaix54uXaEbEBeTjWpFMWLb6Rggqhxj9YquT0Vc6AOCDXu
         l2FJAV6EzJwS+zpl9B4jtRO5eRXOwLzK0xDJh9gh6dQ0f9yXU/dOTdOdLDUKCn5EeW/n
         FYJc3lmZhVPV1yrei9tvpJvOUzaaJ7u9hD1jD4e4eckJUuBx4sllPqz4KUaB4o87XgQj
         kbG9xBYtUGyLT5k61CSm+h3K1b6XBnwBikKM+yRhHjBEGqZPXCTKXRT3Sy0s4foZfm98
         Lf/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H4nDhqegF0EjT05ul4Hwr7UIDTMUmNY72Ijv6z2hAS0=;
        b=IQgP07V2gtRdG9v970RNCKh78DxvyLrytfNE5oDiuNplkn9qe9qRXNPx3Qp/H36sKZ
         v+/ZxXafn2keJNFE95NuLRsISd3cbzwe9Q9qqCTVb37inz6hktPCStD3D2PQhjyYuGrE
         tlN9S4X0XmB38tU6JjoISibL5sTub1cqSuUUhLcGRhu0ro0j5T7XdPLlUR2/kcWjwzbA
         LjODtVAdVQjimJ2en5SeP3AtU8oD/OXn/MAgddiGUdslX1b/BXr2RYIU9B0y6IHKOn+3
         SiWN8MFSp9yKBhbLSa4+L7Yh6w7cZwZg087j/cBToeeC7Rn5G1gHt3EuiD7NEscle8/p
         LJiQ==
X-Gm-Message-State: AOAM533O62DyrdXPASBTQRH/gNzoxl5uojQebQUCCu0A1AvJwib+S5qM
        uFXhfR9FJYUtxCRExG11H3rfCdudTPMV2w==
X-Google-Smtp-Source: ABdhPJxtuGsCbR8nHf5g+pPfXJsJZrcwODxPvINWMu/Bf8lE92Dw3jiKi4xTd/WVnW2CA40bmIJePw==
X-Received: by 2002:a62:8f8b:0:b029:164:9e98:c0e with SMTP id n133-20020a628f8b0000b02901649e980c0emr4981323pfd.80.1604621553290;
        Thu, 05 Nov 2020 16:12:33 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 22sm3236009pjb.40.2020.11.05.16.12.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 16:12:32 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 3/8] ionic: add lif quiesce
Date:   Thu,  5 Nov 2020 16:12:15 -0800
Message-Id: <20201106001220.68130-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106001220.68130-1-snelson@pensando.io>
References: <20201106001220.68130-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the queues are stopped, expressly quiesce the lif.
This assures that even if the queues were in an odd state,
the firmware will close up everything cleanly.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 519d544821af..990bd9ce93c2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1625,6 +1625,28 @@ static void ionic_lif_rss_deinit(struct ionic_lif *lif)
 	ionic_lif_rss_config(lif, 0x0, NULL, NULL);
 }
 
+static int ionic_lif_quiesce(struct ionic_lif *lif)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = IONIC_CMD_LIF_SETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_STATE,
+			.state = IONIC_LIF_QUIESCE,
+		},
+	};
+	int err;
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err) {
+		netdev_err(lif->netdev, "lif quiesce failed %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 static void ionic_txrx_disable(struct ionic_lif *lif)
 {
 	unsigned int i;
@@ -1639,6 +1661,8 @@ static void ionic_txrx_disable(struct ionic_lif *lif)
 		for (i = 0; i < lif->nxqs; i++)
 			err = ionic_qcq_disable(lif->rxqcqs[i], (err != -ETIMEDOUT));
 	}
+
+	(void)ionic_lif_quiesce(lif);
 }
 
 static void ionic_txrx_deinit(struct ionic_lif *lif)
-- 
2.17.1

