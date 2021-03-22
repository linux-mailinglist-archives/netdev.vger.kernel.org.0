Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6EE34514A
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhCVVAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhCVU7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:59:30 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5039C061763
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:29 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id w3so23566490ejc.4
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fe3BoLQtT+MYeWphkgPPUy4gZYSXnnDRm0wnWDtqhuM=;
        b=ERKxET+J9tC+CGRqZLrAZbe3Kc3WWQdA2UclKl/rXaK00KJIP0RVTfoBgyZ1qbrs/l
         Wx3ak6/aDLNEI2Mco2PeurDUda6eHQIYNyAWgsgwQ9rVAVjWxYK4YnD8hIOo0W9WnMi2
         gx8f1vgrYmOt5hZWiavbcjpY7AI0gLYabMmTcqFBGS7th1DfQi/v6ZyhHExHd0QFIJJg
         jLZ9R8sEqtFlL8/+zXeWceWRKDAGOzR7UFJBkV9ApqSpyNzvUp9RRCEksM0UspB+TM8C
         wlDuiuDWu8zvklM+8K8rKaaL3Q0tu51UvPDoQnUE3EyP3WmSge3nO3JAS0GokkfM2Cin
         inWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fe3BoLQtT+MYeWphkgPPUy4gZYSXnnDRm0wnWDtqhuM=;
        b=BDhDtRYUIBtsi4xWQzDcIjfyklHMdz+s43a3DnGKBnDu/T/YA14B6f2vB+6AeW42zP
         Huw+S6o/CAJZs/fX2LGnjemsc8PgiVbOjvx7cITStgqtqcnHIcQsfmtzT2bVc+Q0PTQU
         yFfE0fcGXN6QxGc7/dZ6mQhI9SSZe6s0vOVosJ8vh7I9AxKlqr63/UQ9P0QQDcgUYb4w
         rs7Do7GjdGS3gYb7AAi4VIVmNBK+PobxwaTCrCap5oZdTlyYWnQR+77/kkpTz7clDNx6
         QC88Y6OhvPq3OFuvS/7EUu5rvWqtxPDTJU+dl1gbWUC7jmvuOqnAVZQNlJr3Xx+IcluB
         WATQ==
X-Gm-Message-State: AOAM533/g/76gmm/L+1UYnU+C4tWPesmyCNVQ76sUWMdlSSsZBXbzGEf
        uV41E9Y63/yGD8XBR0aABKyPySgtt3DSwQ==
X-Google-Smtp-Source: ABdhPJwuB4Qodpvhr56cguVhch1SJzPZqztFfg8kFVxCuEm4T51QSg/o4oww0d4iZd334X1Zq2k4jQ==
X-Received: by 2002:a17:906:f1d6:: with SMTP id gx22mr1617304ejb.59.1616446768434;
        Mon, 22 Mar 2021 13:59:28 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id v25sm11621074edr.18.2021.03.22.13.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:59:28 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 6/6] dpaa2-switch: mark skbs with offload_fwd_mark
Date:   Mon, 22 Mar 2021 22:58:59 +0200
Message-Id: <20210322205859.606704-7-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210322205859.606704-1-ciorneiioana@gmail.com>
References: <20210322205859.606704-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

If a switch port is under a bridge, the offload_fwd_mark should be setup
before sending the skb towards the stack so that the bridge does not try
to flood the packet on the other switch ports.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 9f1a59219435..a9b30a72ddad 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2005,6 +2005,9 @@ static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 	skb->dev = netdev;
 	skb->protocol = eth_type_trans(skb, skb->dev);
 
+	/* Setup the offload_fwd_mark only if the port is under a bridge */
+	skb->offload_fwd_mark = !!(port_priv->fdb->bridge_dev);
+
 	netif_receive_skb(skb);
 
 	return;
-- 
2.30.0

