Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DE933D618
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237459AbhCPOsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236665AbhCPOr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:47:59 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD212C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:47:58 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id o19so21853757edc.3
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0JAq1q5tCN/v7xeyqA8I2lBkvE5Excawis9bpCSfpO0=;
        b=QRHYrTz/i2sLlL+XhTw5o0eEjMcyGSnREwnW4h7XEaDeaAcvcVVe0wIbEckbknqy+e
         YhYk/RUazKmmRvMN6bsn7in5ihJI4kpDqLWqHiZ1vF7/QuH92a5tosJkDeOAw6fTmPP4
         FutBA/N+j3iwrfPig08KDNfwDMD3DpcxINcxdrfnfNJJOQjdoVlNhiX210UdO0YXVL1v
         daJK5Cz38vMDLymHdT0o5RdxhubSVPQJQBY4vvgm2NNcf+bvlXzE+NOr7L31BglhryAn
         KetpJ0ZY9EZObzgZX50rSbtAyZiZeWsssQgRUcpev0eBzGJ/Bnb7dvk3B1NQ6nFRIB6T
         dOFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0JAq1q5tCN/v7xeyqA8I2lBkvE5Excawis9bpCSfpO0=;
        b=b5QzZRU2+edwCMjhl7rnUspbI79sfjkoLP3hPfrA6sm0AUF4Do1V+08dXANE9kFLGM
         GmPvRdcOVMnafqSmHxqE7O3nZSotpsMdOgC4hZwX+31kIeEtisVMOxVWxujbhm8raTuM
         AbI7nj/qhvhofUE7XcJV7LTTWXgMCpCYfAayywXcnmTUeVuvm4/D5vgPVuv2vxgQIQ54
         Ear7sh3W9+TgJ0XJoYE4PJLtspBXNXJ/0lN7KAF1pGnI9pApQdyKiuPGXqMJOKHIpptH
         blXn0OOVVwl8qx7MuIImA15Rci8KPvwQ0v0LX28XimUYpY+RSiuywLzgKYs5UoEIhAAM
         nPoQ==
X-Gm-Message-State: AOAM531GA15BLZUVcCxQYcwr8UHK7IPEetQheIKDr0ImWpylnspmUzIJ
        F0CcFs5wWdu1vs7JbG9rTnk=
X-Google-Smtp-Source: ABdhPJyzkJMT1yhh4UB1SEiO2XJm02hDMWaOKoeemAT95b/jtpC19BwOTobC8y3TV6yOwRyEk/ow6A==
X-Received: by 2002:a05:6402:17d6:: with SMTP id s22mr36152727edy.232.1615906077498;
        Tue, 16 Mar 2021 07:47:57 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id de17sm9467441ejc.16.2021.03.16.07.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 07:47:57 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/3] dpaa2-switch: use an indirect call wrapper instead of open-coding
Date:   Tue, 16 Mar 2021 16:47:30 +0200
Message-Id: <20210316144730.2150767-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210316144730.2150767-1-ciorneiioana@gmail.com>
References: <20210316144730.2150767-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Instead of open-coding the call to the consume function of each frame
queue, use the provided INDIRECT_CALL_2.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 12 ++++++------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h |  1 +
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 2fd05dd18d46..e6ec5de0e303 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1917,11 +1917,13 @@ static int dpaa2_switch_setup_fqs(struct ethsw_core *ethsw)
 
 	ethsw->fq[i].fqid = ctrl_if_attr.rx_fqid;
 	ethsw->fq[i].ethsw = ethsw;
-	ethsw->fq[i++].type = DPSW_QUEUE_RX;
+	ethsw->fq[i].type = DPSW_QUEUE_RX;
+	ethsw->fq[i++].consume = dpaa2_switch_rx;
 
 	ethsw->fq[i].fqid = ctrl_if_attr.tx_err_conf_fqid;
 	ethsw->fq[i].ethsw = ethsw;
-	ethsw->fq[i++].type = DPSW_QUEUE_TX_ERR_CONF;
+	ethsw->fq[i].type = DPSW_QUEUE_TX_ERR_CONF;
+	ethsw->fq[i++].consume = dpaa2_switch_tx_conf;
 
 	return 0;
 }
@@ -2208,10 +2210,8 @@ static int dpaa2_switch_store_consume(struct dpaa2_switch_fq *fq)
 			continue;
 		}
 
-		if (fq->type == DPSW_QUEUE_RX)
-			dpaa2_switch_rx(fq, dpaa2_dq_fd(dq));
-		else
-			dpaa2_switch_tx_conf(fq, dpaa2_dq_fd(dq));
+		INDIRECT_CALL_2(fq->consume, dpaa2_switch_rx, dpaa2_switch_tx_conf,
+				fq, dpaa2_dq_fd(dq));
 		cleaned++;
 
 	} while (!is_last);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 933563064015..e4d8a99a6d32 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -84,6 +84,7 @@ extern const struct ethtool_ops dpaa2_switch_port_ethtool_ops;
 struct ethsw_core;
 
 struct dpaa2_switch_fq {
+	void (*consume)(struct dpaa2_switch_fq *fq, const struct dpaa2_fd *fd);
 	struct ethsw_core *ethsw;
 	enum dpsw_queue_type type;
 	struct dpaa2_io_store *store;
-- 
2.30.0

