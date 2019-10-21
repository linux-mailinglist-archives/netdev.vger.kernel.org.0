Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB40EDF73C
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 23:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbfJUVEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 17:04:13 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37263 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730273AbfJUVEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 17:04:13 -0400
Received: by mail-wr1-f68.google.com with SMTP id e11so6833256wrv.4
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 14:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SJv1PDeyKQxzosO6KQSoZipAwqZnnSGMrGr+gZL05jo=;
        b=MD0O/1tFwl9gbCSw7ePGVr5jKyn5EQUhXBSfHuFskA8lP0LugmHf5zTsW2UbnMtzrf
         nKXWK94J/eVAvmDRqhX2/YClDP/EwybhemMNpSuloYZILrxvu8sm2k1/2Huj9zfclNne
         jFUCE/fGhn9slc6fZpca+uajgiS+HZAl34YgPFP3oVfbsjk+HoI0GWQwzgrpOPttDB5H
         jZE9V5y3xWsafPerloNSzs/Ve1y0+V3D6M2y6jtY/Z5IDEAI9cV5DEH+ElOhPcuKqda9
         zYVgnguA1RZB9PYNSUM5PvUajYLtCVuwUWC+D13fVRgdONdipCAfM0yG6gFgy6lLWvks
         CxJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SJv1PDeyKQxzosO6KQSoZipAwqZnnSGMrGr+gZL05jo=;
        b=btEmCBBeSeWebCHhgd7FjGdqTWdMgvR9qUhzLSQCojL7oEIOlACdexnPLIMWVvPvWY
         OvdPJ8rrV1PkXUjN2lbA+PmJi9JiSVHiv5vngvl/sUR5McJvKJjs0BeZ2Y/HL3EgbETQ
         mWQzhXVZ4WyQqDopxsRD6jROyCWRKnIjdOvuzov0/TCzUDlnz4IIJkReY0cd0SE2DhaD
         sb9b53jIrgdba8zkHUV5SdHJ9l825Wi9PvozoQJhGxhbQ9yg6V13FGeNn+ZMN8/FQBEx
         MmW/quZ1XUy7r4AJQItvb+rTXsJCE2yFOiKGf/qqVCR+gSvb9HtUEZ4kaAU0Dh0x8jSw
         6Naw==
X-Gm-Message-State: APjAAAU5SWKdcZMDKWQ4DRICnvLXWcFU77ugab0/Oq1ql/6CzIeIKkJ+
        1I7EHulneK5Oqu/8ri19Ghd+2US+eTXTHg==
X-Google-Smtp-Source: APXvYqw8U8nD33hMnO1B3qVy8ga3winJeoIeXIirWe6bNMcSnZp5T9GSL3E7Bk9LOkzXw2TKY3gY0w==
X-Received: by 2002:a5d:4aca:: with SMTP id y10mr209471wrs.292.1571691850681;
        Mon, 21 Oct 2019 14:04:10 -0700 (PDT)
Received: from i5wan.lan (214-247-144-85.ftth.glasoperator.nl. [85.144.247.214])
        by smtp.gmail.com with ESMTPSA id g5sm14309949wmg.12.2019.10.21.14.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 14:04:10 -0700 (PDT)
From:   Iwan R Timmer <irtimmer@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, Iwan R Timmer <irtimmer@gmail.com>
Subject: [PATCH net-next v2 1/2] net: dsa: mv88e6xxx: Split monitor port configuration
Date:   Mon, 21 Oct 2019 23:01:42 +0200
Message-Id: <20191021210143.119426-2-irtimmer@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021210143.119426-1-irtimmer@gmail.com>
References: <20191021210143.119426-1-irtimmer@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate the configuration of the egress and ingress monitor port.
This allows the port mirror functionality to do ingress and egress
port mirroring to separate ports.

Signed-off-by: Iwan R Timmer <irtimmer@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  9 ++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h    |  3 ++-
 drivers/net/dsa/mv88e6xxx/global1.c | 23 +++++++++++------------
 drivers/net/dsa/mv88e6xxx/global1.h |  6 ++++--
 4 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6787d560e9e3..e9735346838d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2378,7 +2378,14 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 
 		if (chip->info->ops->set_egress_port) {
 			err = chip->info->ops->set_egress_port(chip,
-							       upstream_port);
+							       true,
+							       upstream_port);
+			if (err)
+				return err;
+
+			err = chip->info->ops->set_egress_port(chip,
+							       false,
+							       upstream_port);
 			if (err)
 				return err;
 		}
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e9b1a1ac9a8e..42ce3109ebc9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -464,7 +464,8 @@ struct mv88e6xxx_ops {
 	int (*stats_get_stats)(struct mv88e6xxx_chip *chip,  int port,
 			       uint64_t *data);
 	int (*set_cpu_port)(struct mv88e6xxx_chip *chip, int port);
-	int (*set_egress_port)(struct mv88e6xxx_chip *chip, int port);
+	int (*set_egress_port)(struct mv88e6xxx_chip *chip, bool ingress,
+			       int port);
 
 #define MV88E6XXX_CASCADE_PORT_NONE		0xe
 #define MV88E6XXX_CASCADE_PORT_MULTIPLE		0xf
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 25ec4c0ac589..35b9610cbe73 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -263,7 +263,8 @@ int mv88e6250_g1_ieee_pri_map(struct mv88e6xxx_chip *chip)
 /* Offset 0x1a: Monitor Control */
 /* Offset 0x1a: Monitor & MGMT Control on some devices */
 
-int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip, int port)
+int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip, bool ingress,
+				 int port)
 {
 	u16 reg;
 	int err;
@@ -272,11 +273,12 @@ int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
-	reg &= ~(MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK |
-		 MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK);
+	reg &= ~(ingress ? MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK :
+			   MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK);
 
-	reg |= port << __bf_shf(MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK) |
-		port << __bf_shf(MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK);
+	reg |= port << (ingress ?
+	       __bf_shf(MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK) :
+	       __bf_shf(MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK));
 
 	return mv88e6xxx_g1_write(chip, MV88E6185_G1_MONITOR_CTL, reg);
 }
@@ -310,17 +312,14 @@ static int mv88e6390_g1_monitor_write(struct mv88e6xxx_chip *chip,
 	return mv88e6xxx_g1_write(chip, MV88E6390_G1_MONITOR_MGMT_CTL, reg);
 }
 
-int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip, int port)
+int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip, bool ingress,
+				 int port)
 {
 	u16 ptr;
 	int err;
 
-	ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST;
-	err = mv88e6390_g1_monitor_write(chip, ptr, port);
-	if (err)
-		return err;
-
-	ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST;
+	ptr = ingress ? MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST :
+			MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST;
 	err = mv88e6390_g1_monitor_write(chip, ptr, port);
 	if (err)
 		return err;
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 0870fcc8bfc8..ef7e13f71927 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -287,8 +287,10 @@ int mv88e6095_g1_stats_set_histogram(struct mv88e6xxx_chip *chip);
 int mv88e6390_g1_stats_set_histogram(struct mv88e6xxx_chip *chip);
 void mv88e6xxx_g1_stats_read(struct mv88e6xxx_chip *chip, int stat, u32 *val);
 int mv88e6xxx_g1_stats_clear(struct mv88e6xxx_chip *chip);
-int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip, int port);
-int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip, int port);
+int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip, bool ingress,
+				 int port);
+int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip, bool ingress,
+				 int port);
 int mv88e6095_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_g1_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip);
-- 
2.23.0

