Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6646725852
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 21:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfEUTbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 15:31:06 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45840 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727585AbfEUTbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 15:31:05 -0400
Received: by mail-qk1-f195.google.com with SMTP id j1so11776959qkk.12
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 12:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dLAocCajUA7oYwJWHfsOHcQOB7Rvyu2ClofjxmpS6+M=;
        b=tQg2ktmVoTfz9SPZQK+pksz54oWvV/o+eFNUT1QnKRKqIfxQnUwVR1A+wvJn2mmUSs
         bVeUcPV08RnY5EytlaJ84UAHtgiGHdq5E3bZI5mcSCml5+lCuK1ywxPsJxM9PaQqvfLi
         9q7fCYxQbRJJNF6cwhC29TaAM8LRElF6ggphfTgh/3F1j+WaqbctZa2VEutOEzsHyLHm
         1Ag6FIqj1e3rsatamVNdYjrdQuZ4nZsy6oLlaxP35SAIkpRfDh+Wpjgx67DKEA7UFBvi
         cQnvLSWJVQAicu3RTUCoH29IMRkN1zIcr0u0uE9gXmsDgptXLdN7qVDiA5FqSgQik4jC
         xInQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dLAocCajUA7oYwJWHfsOHcQOB7Rvyu2ClofjxmpS6+M=;
        b=SH9cTd+PhlN/cGRyXCMy6FKD472EDeOUlnuDJz5mEdj7Wc1sEpwTg66GHiF+ClOsZL
         f19myer7ik4RuNmZSfVh1D30wro2QEWLTCxlkvtO8fEOIqiWkCUSV0dvQz+hHRFQL+EJ
         0HHTn1P5vDM5qAWpo7Otk9k0q35y7Fr0AggRc18RWTVRiX1VfEu2pW6NZGj5jRYV0XKN
         0jQNz00XtH5si941SghaDamtJBwMuLOyh3R7Eq+wuwTEuqvEfeAl+ojkzewl2Sd1RnQ6
         T/YbXo2na2MqK4CSNjAhOZ3KNO8JUNNkmPFxKZrgZ7w+RJQZ+GWvspAbPHQ2mU6Ssc3r
         maPA==
X-Gm-Message-State: APjAAAXSJbe1SodoQv7sfGdCp286ZeIXNxEORu1NZTZDAsOoq+SYilPQ
        /fk1Epywdvm1EgwExxFivUgyrhQC
X-Google-Smtp-Source: APXvYqwrntB2VKMkWv5u4Yvf/YZYtFAmo7zk+7RHsBcfxKmhs9EFGudBfM2UdT+nQ8ugiBMFBm0oKw==
X-Received: by 2002:a05:620a:1581:: with SMTP id d1mr8197947qkk.193.1558467063382;
        Tue, 21 May 2019 12:31:03 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id w5sm7970243qtc.50.2019.05.21.12.31.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 12:31:02 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cphealy@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC net-next 8/9] net: dsa: mv88e6xxx: setup RMU port
Date:   Tue, 21 May 2019 15:30:03 -0400
Message-Id: <20190521193004.10767-9-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190521193004.10767-1-vivien.didelot@gmail.com>
References: <20190521193004.10767-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the RMU on the first upstream port found on this switch.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/Makefile |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c   |  9 +----
 drivers/net/dsa/mv88e6xxx/rmu.c    | 58 ++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h    | 33 +++++++++++++++++
 4 files changed, 93 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index e85755dde90b..c95679d0c615 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -11,5 +11,6 @@ mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += hwtstamp.o
 mv88e6xxx-objs += phy.o
 mv88e6xxx-objs += port.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
+mv88e6xxx-objs += rmu.o
 mv88e6xxx-objs += serdes.o
 mv88e6xxx-objs += smi.o
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 3aa2b315b96d..048fdaf1335e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -42,6 +42,7 @@
 #include "phy.h"
 #include "port.h"
 #include "ptp.h"
+#include "rmu.h"
 #include "serdes.h"
 #include "smi.h"
 
@@ -1199,14 +1200,6 @@ static int mv88e6xxx_trunk_setup(struct mv88e6xxx_chip *chip)
 	return 0;
 }
 
-static int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
-{
-	if (chip->info->ops->rmu_disable)
-		return chip->info->ops->rmu_disable(chip);
-
-	return 0;
-}
-
 static int mv88e6xxx_pot_setup(struct mv88e6xxx_chip *chip)
 {
 	if (chip->info->ops->pot_clear)
diff --git a/drivers/net/dsa/mv88e6xxx/rmu.c b/drivers/net/dsa/mv88e6xxx/rmu.c
new file mode 100644
index 000000000000..71dabe6ecb46
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/rmu.c
@@ -0,0 +1,58 @@
+/*
+ * Marvell 88E6xxx Remote Management Unit (RMU) support
+ *
+ * Copyright (c) 2019 Vivien Didelot <vivien.didelot@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "chip.h"
+#include "rmu.h"
+
+static int mv88e6xxx_rmu_setup_port(struct mv88e6xxx_chip *chip, int port)
+{
+	int err;
+
+	/* First disable the RMU */
+	if (chip->info->ops->rmu_disable) {
+		err = chip->info->ops->rmu_disable(chip);
+		if (err)
+			return err;
+	}
+
+	/* Then enable the RMU on this dedicated port */
+	if (chip->info->ops->rmu_enable) {
+		err = chip->info->ops->rmu_enable(chip, port, false);
+		if (err)
+			return err;
+
+		dev_info(chip->dev, "RMU enabled on port %d\n", port);
+
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
+{
+	struct dsa_switch *ds = chip->ds;
+	int port;
+	int err;
+
+	/* Find a local port (in)directly connected to the CPU to enable RMU on */
+	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
+		if (dsa_is_upstream_port(ds, port)) {
+			err = mv88e6xxx_rmu_setup_port(chip, port);
+			if (err)
+				continue;
+
+			return 0;
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/net/dsa/mv88e6xxx/rmu.h b/drivers/net/dsa/mv88e6xxx/rmu.h
new file mode 100644
index 000000000000..f7d849b169d2
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/rmu.h
@@ -0,0 +1,33 @@
+/*
+ * Marvell 88E6xxx System Management Interface (RMU) support
+ *
+ * Copyright (c) 2019 Vivien Didelot <vivien.didelot@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _MV88E6XXX_RMU_H
+#define _MV88E6XXX_RMU_H
+
+#define MV88E6XXX_RMU_REQUEST_FORMAT_SOHO	0x0001
+
+#define MV88E6XXX_RMU_REQUEST_CODE_GET_ID	0x0000
+#define MV88E6XXX_RMU_REQUEST_CODE_DUMP_ATU	0x1000
+#define MV88E6XXX_RMU_REQUEST_CODE_DUMP_MIB	0x1020
+#define MV88E6XXX_RMU_REQUEST_CODE_READ_WRITE	0x2000
+
+#define MV88E6XXX_RMU_REQUEST_DATA_DUMP_MIB_CLEAR	0x8000
+
+#define MV88E6XXX_RMU_RESPONSE_CODE_GET_ID	MV88E6XXX_RMU_REQUEST_CODE_GET_ID
+#define MV88E6XXX_RMU_RESPONSE_CODE_DUMP_ATU	MV88E6XXX_RMU_REQUEST_CODE_DUMP_ATU
+#define MV88E6XXX_RMU_RESPONSE_CODE_DUMP_MIB	MV88E6XXX_RMU_REQUEST_CODE_DUMP_MIB
+#define MV88E6XXX_RMU_RESPONSE_CODE_READ_WRITE	MV88E6XXX_RMU_REQUEST_CODE_READ_WRITE
+
+#include "chip.h"
+
+int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip);
+
+#endif /* _MV88E6XXX_RMU_H */
-- 
2.21.0

