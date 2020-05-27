Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA3D1E51F4
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 01:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgE0XmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 19:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgE0Xlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 19:41:35 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414B0C08C5C3
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:35 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id x1so30059752ejd.8
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GS3r8Vt7QeEjfknxzBzMnEpTCh/FQ9Ma0Gd5YTpwGZ8=;
        b=DbHe/ZZrUHtpjfzuvfovEWnooC7wLJ97BT0rhE5GaWyI6/l7iJsa662rtt6A8WekK/
         OtBwaxRe2O8Z4K6cvNSbjnVTugT/Yug5lgmYHyaCU09d4jJ1gNWc54XU/Z1OVdYQ2h2m
         fGJf/jVkhT34l8whqFbMUIuXpTzP+PGbZnokL4oU6ULoN5WyaDsYPchB5dqPecwn2jQ2
         wDzU9W4ZWQT52h0xS6H3Dlsn2uVt0721gE5GuzPylNkCIfHA0W115/x2AEmmH/vvoKqa
         TSVXGoGztFtb8n2gZzLbbrqqHFXDvCZtJvyLj4T/0Axia8vcc1hKpVR+LuhFE+ar0ojB
         QSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GS3r8Vt7QeEjfknxzBzMnEpTCh/FQ9Ma0Gd5YTpwGZ8=;
        b=QPhMGvRLHNtfm0pIL/Tos0I2Uy1+5hj6x3T07ZwGBI3vXlAvbxzd3ETodTJEFQoTOe
         L1TdfR4qYrNdg/hbjQPVcvSrp5BW/GGw+c5dpEszmStFPbKjtjZI40q94cBXVyBPboo2
         12jh2kEyBg0ef5VKh+fkKfcOfSisirqvjBvG70YTFiO7BdnQhMNK/syEiyf9TwdbHkDU
         yn4zJV6SW96sCBilDH/KF0npN3RHvFnTb7WT9cNc7UEajKRnFmsQwB5dj/w0PAhdIm0S
         sCPodC/lVUMrS9/Ud5HhROeTE6o2ye6D+e6IvOO5E19JyjKDVu0RsLKIr3II8R6Amcua
         HaiQ==
X-Gm-Message-State: AOAM532naggMliH5PY/MsMm2yBkH888zj/J7RvUTZfexHDLdhw5WjTIx
        ZN7C4zz0xEX8DhgderjI+fw=
X-Google-Smtp-Source: ABdhPJw4ElOOII1Xa9ZbV6faLn5SsAv0J7xVTEaGOOVrClxCt7GR5ziUHIUDqa0/4K/UIcMxH0vRFQ==
X-Received: by 2002:a17:906:68d2:: with SMTP id y18mr691262ejr.248.1590622894045;
        Wed, 27 May 2020 16:41:34 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id a13sm3236555eds.6.2020.05.27.16.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 16:41:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH net-next 08/11] net: mscc: ocelot: disable flow control on NPI interface
Date:   Thu, 28 May 2020 02:41:10 +0300
Message-Id: <20200527234113.2491988-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200527234113.2491988-1-olteanv@gmail.com>
References: <20200527234113.2491988-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Ocelot switches do not support flow control on Ethernet interfaces
where a DSA tag must be added. If pause frames are enabled, they will be
encapsulated in the DSA tag just like regular frames, and the DSA master
will not recognize them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 6fc5b72c9260..41d1026ec5b3 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2200,6 +2200,10 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
 				    extraction);
 		ocelot_fields_write(ocelot, npi, SYS_PORT_MODE_INCL_INJ_HDR,
 				    injection);
+
+		/* Disable transmission of pause frames */
+		ocelot_rmw_rix(ocelot, 0, SYS_PAUSE_CFG_PAUSE_ENA,
+			       SYS_PAUSE_CFG, npi);
 	}
 
 	/* Enable CPU port module */
-- 
2.25.1

