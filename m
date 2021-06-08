Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6FC39F4BF
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 13:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhFHLRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 07:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbhFHLRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 07:17:50 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B35FC061574
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 04:15:46 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id i13so24068965edb.9
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 04:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/l2ljIhGSBwBmvZYEvaOBhtYvOFfY7UkCrWbfRGkwRc=;
        b=MDB/MbwzDoVedSmL0TDXKZ5ee8LcV6MDqda4LlWHLgg8ruS+rXC70nAuTSoDxITKXo
         2Pk+xznQC3wilnf91FJu2y+7vXq9SMyLGTOzW7hbz55zw0SO8sftMxwF8M3LMR82/gB2
         f+ZQ2cTKhtOIw2sfLVoDIwDwXOX0+hoGy4wR3gazSYTVbEwaDo11F/pOeangHUR87wgc
         Zz+XN0SIAgHlhu5biSrDAvAF6uJMLMHPKXQa/ZL1kBtZosVsThEVTcOFjMJX6ykRxiE0
         cLf7lK33Sa9CxCDE0lZ/W0EPJnZt5M+lfGRjvVxL+5WSmm8Y860SHhdCMEOuJYwGTu7X
         frSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/l2ljIhGSBwBmvZYEvaOBhtYvOFfY7UkCrWbfRGkwRc=;
        b=Yk5VdYKT2HXLQ+eREJhHvykRbrH71gTUAMNRBQr03lLJ9ZjO35C4YG05wh874d9JQG
         Nv79P3SDBsSvx4OHixFkzh56uIac2BzCsFSA2He5bPzrqQrviJDeM7GmIA6S7wK78guk
         Gjt4VVQYwoxqfKLm5VZStfQpuBgMCxx3Q0MoMzrL4Jqf4t4ZdTzL6u4kouUuBSYRRwmn
         nI6i1asPdFwLmVq2jm2ExuUBMzv3y80GEmG4pD05LgbNVwb0TJrChXbr//MaVhqcTUPE
         D3sFkAKtmvTEfbR3OLpIcYKjjDXWFTt3y2v/jqNyFseWQfbSo55K/ZU62KVRetPRELTq
         txsQ==
X-Gm-Message-State: AOAM531mEvH3qXlwqvuelAptrubibdTzlXIfu06RVgb7C977Ciz4yoYC
        09zMwv/4TvTgO+JDVh9HhGA=
X-Google-Smtp-Source: ABdhPJzsXtg4JQCQ+OHqD/7tkLvaj6gSkfnk815db5HMYPcm5VQWxhPqOarKEw9KtG1w9YvNfDJzgQ==
X-Received: by 2002:aa7:cb5a:: with SMTP id w26mr25414720edt.139.1623150944805;
        Tue, 08 Jun 2021 04:15:44 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id h19sm4493439ejy.82.2021.06.08.04.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 04:15:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net] net: dsa: felix: re-enable TX flow control in ocelot_port_flush()
Date:   Tue,  8 Jun 2021 14:15:35 +0300
Message-Id: <20210608111535.4084131-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Because flow control is set up statically in ocelot_init_port(), and not
in phylink_mac_link_up(), what happens is that after the blamed commit,
the flow control remains disabled after the port flushing procedure.

Fixes: eb4733d7cffc ("net: dsa: felix: implement port flushing on .phylink_mac_link_down")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 0c4283319d7f..adfb9781799e 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -379,6 +379,7 @@ static u32 ocelot_read_eq_avail(struct ocelot *ocelot, int port)
 
 int ocelot_port_flush(struct ocelot *ocelot, int port)
 {
+	unsigned int pause_ena;
 	int err, val;
 
 	/* Disable dequeuing from the egress queues */
@@ -387,6 +388,7 @@ int ocelot_port_flush(struct ocelot *ocelot, int port)
 		       QSYS_PORT_MODE, port);
 
 	/* Disable flow control */
+	ocelot_fields_read(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, &pause_ena);
 	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
 
 	/* Disable priority flow control */
@@ -422,6 +424,9 @@ int ocelot_port_flush(struct ocelot *ocelot, int port)
 	/* Clear flushing again. */
 	ocelot_rmw_gix(ocelot, 0, REW_PORT_CFG_FLUSH_ENA, REW_PORT_CFG, port);
 
+	/* Re-enable flow control */
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, pause_ena);
+
 	return err;
 }
 EXPORT_SYMBOL(ocelot_port_flush);
-- 
2.25.1

