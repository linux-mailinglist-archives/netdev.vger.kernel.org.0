Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C551E9786
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgEaM1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgEaM1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 08:27:15 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462D9C061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:15 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n24so6595787ejd.0
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o/H5SU2rzWG3PmLibjNlklGiOkgkyD8qwNziQAmgdtc=;
        b=e7KAc5Y4E/KaMtGBlTQgqC4A07A/XyWNCjatFAhiAPh4oTvZOBfpFEWWQN7jE7rxf/
         CCDZ8Sz1IOKNnqIqwA4UhpjAhE+Q0+RD7eU4Gyf22RFgU8IstFiXqmijmJmjQilmA6Wt
         PNb4nrsWssw7bXXCvhiPO3C1d18WYba4qpbELawMAzcwRPVDnPDeQ1SGxa4T7tHJUPTv
         tagqLX43x+PqIrCE1ZDcwDY50A3P6BX6zvNqmdfXej777E7R64sDEm8Cl3DX3CMzto+s
         dDqwb10t3xll4GQyXpbyCFODJkDMmD8Ge1t3VhE9g/8wW4fiCBq6aeK+Wlf5qz4INB40
         6u+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o/H5SU2rzWG3PmLibjNlklGiOkgkyD8qwNziQAmgdtc=;
        b=n1iq3BgmgnpkKmiGvvsQay0jeY74cExwj5p6YoXbCT6PszyPKtoS7Xnyu5RThbVtC/
         HtvUwfNVSfmAAVK7LdWjTxQ5t0dK7rrDafwABYkFBxjz44e5yf0OE3E0d71ABwURxk9f
         6RNXsoqXg8dZ21miyvSmhQTOxCXo/Edy+r5bsouu84CPMH7ci52OsuSzBBlLJkeoHljH
         uilvIC+nDe8Yg5BoHUL1BJDUKQwWeOop7pzC4hO7TDdc3ktyf8YKYID/WNYF5BzxRhb/
         nbdl1C59waqyHl+vdGzp+FwyIGEEIEq+GDz/7AE4eOrGW0ikSILUjUqbE7u6O5c61P+N
         FLKg==
X-Gm-Message-State: AOAM533DhgWQThRXjBkEcZxvseFWWITX4nSdt7TADBnq9jURs4GnZEfI
        tJC5MbafPSWKal2MPW5XPhI=
X-Google-Smtp-Source: ABdhPJxcfALj9OoKMR1I2c3NAPauKtkTu6uqxp3Nrt2NOCaPx6AsfuKsexd049uqhP1flML6dlUMfw==
X-Received: by 2002:a17:906:7395:: with SMTP id f21mr4697135ejl.178.1590928034019;
        Sun, 31 May 2020 05:27:14 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id b16sm12870024edu.89.2020.05.31.05.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 05:27:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v3 net-next 08/13] net: mscc: ocelot: disable flow control on NPI interface
Date:   Sun, 31 May 2020 15:26:35 +0300
Message-Id: <20200531122640.1375715-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200531122640.1375715-1-olteanv@gmail.com>
References: <20200531122640.1375715-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d9b0918080c5..c36d29974092 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2202,6 +2202,10 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
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

