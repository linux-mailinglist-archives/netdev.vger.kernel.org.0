Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68CB8863C
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbfHIWu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:50:27 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46554 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729522AbfHIWu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:50:26 -0400
Received: by mail-qt1-f196.google.com with SMTP id j15so3807987qtl.13
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 15:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RNrjwMeySjntH3cW/a3DDIg5yYfXac1vmyqU8bqO6Gw=;
        b=DhqpOuw7MqRpEKKTc9K/8lkQjfiahwNJv9XMTbE9RuhnE1enctDfFXhTYE8yE0zuZf
         xBDUkdEmO9dqqYB01Ff4riYDHlYvE0Ai4fV5+wd0UxR9oHLE77073dWVPq5RN5YCWFyP
         /Wc80OtXEvSXzjfBo5tSOF/yljpk3QJYerCzpVhHSHG2lcYq2VMi5MXHa5YWhlk51C0V
         GgKQkZB98t261lVKorlB630Sx1eK+5A4ISHKfZ8EtGZ6e+AQzsfVdz5LyYC84HupCE6h
         RptqmFrzdZ/1Vxkn1tNPK4jLDrtocKNZO/5iX2Mv48IpnVjC3YSDBPbhQdEpeApftEN8
         79Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RNrjwMeySjntH3cW/a3DDIg5yYfXac1vmyqU8bqO6Gw=;
        b=IYL33NgNEdWhUAOxbQmFpiG66njcW0O4OL0a37oh3+fWNAA2kgvTvq6kREU9hiXEv7
         uzAtjAarJwESej7LvsrI57n/TJFHXTYh9ljBcEo6/qNSFaD0VlHUffkVGZiAI8cXhZ3A
         d0NBrRdzURooqNjCqe7wvWYj7+1gIMdc8u5ImLGAl07bNH1htlk89V7YAIvM3lfSDLBG
         QsyIyVlxQiiD02T/KXDc1AwMhJfOBZmcHNQxjj0U2ppwy7atPDbmIg2zTmvk6NGLHpiL
         mRzbRQDk6F3YO3n7njgX9COXe6N9G6M5hH+pgDH07OxjsxlpZVWUZUrP8GJTLz9ghPvy
         yMLg==
X-Gm-Message-State: APjAAAXWK10CArT5g3G189Xstrd0ePPCrqX6+SKdXiNP+BK5jMkE5JUK
        VTYy3mtsvCIIiMaCi2dKHZ2pZSwT
X-Google-Smtp-Source: APXvYqxG9WfkrVU3O0MXXy1FFrVZ1+A/U0FDMZlWDdoyze/2ZT4TqKz2gckGLmXDBDe2zaq45o5T6Q==
X-Received: by 2002:ac8:70d1:: with SMTP id g17mr20485066qtp.124.1565391025152;
        Fri, 09 Aug 2019 15:50:25 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c5sm45347851qkb.41.2019.08.09.15.50.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 15:50:24 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 4/7] net: dsa: mv88e6xxx: wait for AVB Busy bit
Date:   Fri,  9 Aug 2019 18:47:56 -0400
Message-Id: <20190809224759.5743-5-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809224759.5743-1-vivien.didelot@gmail.com>
References: <20190809224759.5743-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AVB is not an indirect table using an Update bit, but a unit using
a Busy bit. This means that we must ensure that this bit is cleared
before setting it and wait until it gets cleared again after writing
an operation. Reflect that.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/global2_avb.c | 29 +++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global2_avb.c b/drivers/net/dsa/mv88e6xxx/global2_avb.c
index 116b8cf5a6e3..657783e043ff 100644
--- a/drivers/net/dsa/mv88e6xxx/global2_avb.c
+++ b/drivers/net/dsa/mv88e6xxx/global2_avb.c
@@ -11,6 +11,8 @@
  *	Brandon Streiff <brandon.streiff@ni.com>
  */
 
+#include <linux/bitfield.h>
+
 #include "global2.h"
 
 /* Offset 0x16: AVB Command Register
@@ -27,17 +29,33 @@
 /* mv88e6xxx_g2_avb_read -- Read one or multiple 16-bit words.
  * The hardware supports snapshotting up to four contiguous registers.
  */
+static int mv88e6xxx_g2_avb_wait(struct mv88e6xxx_chip *chip)
+{
+	int bit = __bf_shf(MV88E6352_G2_AVB_CMD_BUSY);
+
+	return mv88e6xxx_g2_wait_bit(chip, MV88E6352_G2_AVB_CMD, bit, 0);
+}
+
 static int mv88e6xxx_g2_avb_read(struct mv88e6xxx_chip *chip, u16 readop,
 				 u16 *data, int len)
 {
 	int err;
 	int i;
 
+	err = mv88e6xxx_g2_avb_wait(chip);
+	if (err)
+		return err;
+
 	/* Hardware can only snapshot four words. */
 	if (len > 4)
 		return -E2BIG;
 
-	err = mv88e6xxx_g2_update(chip, MV88E6352_G2_AVB_CMD, readop);
+	err = mv88e6xxx_g2_write(chip, MV88E6352_G2_AVB_CMD,
+				 MV88E6352_G2_AVB_CMD_BUSY | readop);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_g2_avb_wait(chip);
 	if (err)
 		return err;
 
@@ -57,11 +75,18 @@ static int mv88e6xxx_g2_avb_write(struct mv88e6xxx_chip *chip, u16 writeop,
 {
 	int err;
 
+	err = mv88e6xxx_g2_avb_wait(chip);
+	if (err)
+		return err;
+
 	err = mv88e6xxx_g2_write(chip, MV88E6352_G2_AVB_DATA, data);
 	if (err)
 		return err;
 
-	return mv88e6xxx_g2_update(chip, MV88E6352_G2_AVB_CMD, writeop);
+	err = mv88e6xxx_g2_write(chip, MV88E6352_G2_AVB_CMD,
+				 MV88E6352_G2_AVB_CMD_BUSY | writeop);
+
+	return mv88e6xxx_g2_avb_wait(chip);
 }
 
 static int mv88e6352_g2_avb_port_ptp_read(struct mv88e6xxx_chip *chip,
-- 
2.22.0

