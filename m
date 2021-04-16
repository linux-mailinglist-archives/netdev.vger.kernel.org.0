Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2603F362A33
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344339AbhDPVXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344323AbhDPVXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 17:23:41 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859A4C061756
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:15 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id 20so10704990pll.7
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O3g2qhM6mlcVIMTVrQ6cO0+6INLxw+AiLv0b4IUQItk=;
        b=SfIE3VrxwuCAgL3+/zlq+jQg4EPgi+m39ejT0pBTUhJtj4x+dATJctsHsbJUBqS42i
         1h3Fh43uJ2L+vHQ5qPpAkUFb69rTsFbeb04CuirSL4RUjSIGjq1Eo1M01pJe4rTnSotq
         WZ9C+6dppZObWReKng7+TiAQHbkVmSWKaFAweFlvAO9Nb6E1CgLjMXHwbNvb9f7KJ8Ef
         mc5Q33W7jleXSPqebiCYjm4xHve44I3CUDsk/3apUsY1GpEjEifH8x3YBLV6snibjmDz
         BZco6aRYP2Ue+UAZxniyWkoT4b9ryq/N6tyMYPHnMcVcAr+Yxm1NSmY7TmJCc7qSP2uH
         8W8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O3g2qhM6mlcVIMTVrQ6cO0+6INLxw+AiLv0b4IUQItk=;
        b=rRWJSJwakaHcu+0p7jVRCs57O1BNgLfcTP1r0H40g/eDw38DZ7/iD+9AiN29yIJ7Su
         L7USFCdo5pvpkBTj0vVJMdbz0soBkWZ4owKu1mRDnxTOJrab0uildPkfZAYzLUOpoG30
         BPleXGljd3wOj0xKyWh5rezQm+xOMlsdIt6ABks0zoK/0ogdZ1Iiq/vK0TtSWdTMYsD4
         pyIMEMBfQf7iy3A0gkdjnP+S/TI4jJo6PWL/7fxLEgMYHq0s/Kh3X2VSbYyJ0Gntw0XG
         4H+6x0YJNoaJw0GMV7btpzfYLIZ85JtjohLZi8i021bdSIrGvLwM7sriltHdR/RboLpJ
         yxvA==
X-Gm-Message-State: AOAM532IM1GX54hTdZqmtrhwoU22ev/eGE9NQPEvhKRoMyWXc3ze/D6q
        eMp2X34GbnpE9DwRUgleX04=
X-Google-Smtp-Source: ABdhPJyDUIZldlwz9wwGe4MLaZ4TGpxkOuB4LRl9IlzgfkqxDt2NZYMn/4SYy35xkbk87skSE5msSA==
X-Received: by 2002:a17:90a:2f89:: with SMTP id t9mr11990518pjd.177.1618608195186;
        Fri, 16 Apr 2021 14:23:15 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t23sm6069132pju.15.2021.04.16.14.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 14:23:14 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 03/10] net: enetc: recycle buffers for frames with RX errors
Date:   Sat, 17 Apr 2021 00:22:18 +0300
Message-Id: <20210416212225.3576792-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416212225.3576792-1-olteanv@gmail.com>
References: <20210416212225.3576792-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When receiving a frame with errors, currently we do nothing with it (we
don't construct an skb or an xdp_buff), we just exit the NAPI poll loop.

Let's put the buffer back into the RX ring (similar to XDP_DROP).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index c4ff090f29ec..c6f984473337 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -822,12 +822,14 @@ static bool enetc_check_bd_errors_and_consume(struct enetc_bdr *rx_ring,
 	if (likely(!(bd_status & ENETC_RXBD_LSTATUS(ENETC_RXBD_ERR_MASK))))
 		return false;
 
+	enetc_put_rx_buff(rx_ring, &rx_ring->rx_swbd[*i]);
 	enetc_rxbd_next(rx_ring, rxbd, i);
 
 	while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
 		dma_rmb();
 		bd_status = le32_to_cpu((*rxbd)->r.lstatus);
 
+		enetc_put_rx_buff(rx_ring, &rx_ring->rx_swbd[*i]);
 		enetc_rxbd_next(rx_ring, rxbd, i);
 	}
 
-- 
2.25.1

