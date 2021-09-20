Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E67411B73
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 18:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238707AbhITQ6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 12:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244745AbhITQ4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 12:56:46 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690AEC0611C2;
        Mon, 20 Sep 2021 09:47:58 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id eg28so41093661edb.1;
        Mon, 20 Sep 2021 09:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ODjPastsD2NOA/L+wDqQJKwRxMJSl3wumfFhFRpLojE=;
        b=oIFJgq83weqYLjUU9K6+CJHBB3FwK+mrgj8dCZ9WaQgXlRpm/Senzgc8oCf9s+7N+E
         bWRg0Frk33m9uZY00gST2iIfKb2G+D/cMoYLlZegA/hTOo7wYL5zp5DJ9vRTBSfGPr4K
         YqNrzVa2XCdGQUZyVQWJQooVFyXNuAWsXraicDykF6I3L6Bi4Ifk0bPf4KFeYg2zjwZH
         Gi9MDosqJ0+Xsvfq8k+fEd182st0JrR6h/TuyY4UceAQGXSFjVGb5aK2NZJatJOgA03s
         htyhKsKxbcE/rcMYKuHN3K0/EiyLBzY9qgUxhKEwBCWs1fB/yJOTz3wd8r0LWGpLOg1P
         fhLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ODjPastsD2NOA/L+wDqQJKwRxMJSl3wumfFhFRpLojE=;
        b=jJlqpa1C6bZfFwF5SZ7s7pZK2qChnGDCYfhssIiVH4gdPLj4WsrdrA8q8UvudmSVta
         Gv4Tr1Sve8ErnZriOfoEvfSlpIcr+vS3s3gwbvNDRABdkFN2cjtaGIoqlidXP0uy8GpX
         TpkyZl0SLQp+UPEWp7KMjqYOLrZ6zhxWjPcNU7gPs75lQxc7uFg2+qQ+0jfo9u2eds80
         q/1OSGILDwQIuAY0l0ltAigt6BUg/WYrxa7NQMvOemmVZh6aAFJ2nxP/byixP5+2zSYM
         RTn212KQf+iXQVfngi4bWeKPgYBXaZQekeItLDwhWUL5urgWzo4gzqHaddzszqwhK2g1
         +SSA==
X-Gm-Message-State: AOAM5311pt8FdarDe8EpohHcikyfQgXYr+f4BCGhl8/J6lFL/LakFr9e
        6ORB+cU0nBshJoiFIGfnh+zaGzAwLIY=
X-Google-Smtp-Source: ABdhPJwcik+CyJY/m/YLMovDRxl/WkYdPqADj2GSaLWRgWX3lw7c1A1s67/EY0mn17hoXaXql7ZYTw==
X-Received: by 2002:a17:906:b14d:: with SMTP id bt13mr28796269ejb.39.1632156476868;
        Mon, 20 Sep 2021 09:47:56 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.googlemail.com with ESMTPSA id 6sm6385232ejx.82.2021.09.20.09.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 09:47:56 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH 1/1] drivers: net: dsa: qca8k: fix sgmii with some specific switch revision
Date:   Mon, 20 Sep 2021 18:47:45 +0200
Message-Id: <20210920164745.30162-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210920164745.30162-1-ansuelsmth@gmail.com>
References: <20210920164745.30162-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable sgmii pll, tx driver and rx chain only on switch revision 1. This
is not needed on later revision and with qca8327 cause the sgmii
connection to not work at all. This is a case with some router that use
the qca8327 switch and have the cpu port 0 using a sgmii connection.
Without this, routers with this specific configuration won't work as the
ports won't be able to communicate with the cpu port with the result of
no traffic.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index bda5a9bf4f52..efeed8094865 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1227,8 +1227,14 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		if (ret)
 			return;
 
-		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
-			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
+		/* SGMII PLL, TX driver and RX chain is only needed in
+		 * switch revision 1, later revision doesn't need this.
+		 */
+		if (priv->switch_revision == 1)
+			val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
+			       QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
+		else
+			val |= QCA8K_SGMII_EN_SD;
 
 		if (dsa_is_cpu_port(ds, port)) {
 			/* CPU port, we're talking to the CPU MAC, be a PHY */
-- 
2.32.0

