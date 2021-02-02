Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6749330CB47
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 20:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239455AbhBBTTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 14:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239216AbhBBTRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 14:17:32 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F48C06174A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 11:17:16 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m22so29604863lfg.5
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 11:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=/rHAS7hnPGeMHqhM9Qe+rHRNz+9ihRq8nhvef1e967k=;
        b=s8Qa+rJ8EuBkdkrzHSnNMyvBBylcW4HudPl8rFBzhwcyUJG5DkH4kGwM1uBGDMTJOZ
         ncQhSvpV1ckjwv7oLpNepZqKZVyoBigQltrryqLEyzeod/pNdwDMTS33kPpXpztqHQmP
         DtpiPXJkUk899EzA9mJsUKJySbBkO2Y9PqwLld7LCFkuwrWmuMYNBXvEUAGwJ+9cu/7X
         US2w4v3rBg2D8zm6VuEttast5/cwqQemhfUbSfonfp7FfOaU1h2H3romjxSVt/01lP86
         czSO67n4Q66+dycttFXv8//oqXYgiAid1gXmsKjCHW7yd1SsRgCXpFzHX3zVwdL4t2aa
         qdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=/rHAS7hnPGeMHqhM9Qe+rHRNz+9ihRq8nhvef1e967k=;
        b=D2YB4/hKJnbARS3+0PEW6cm2oveBieKVaEHPtbp6q385rTV+jGp0LswBl8rOq66wsp
         uz3a7jxaba7GKprDESm+ILecjeIxL+Y45Ni0k3Djq/PsoJWJ3YwAQbc6HDxPoWMM/E3n
         o0uWXkwzCb0jnSRaxYxQHA/rcIPeLZFHx1gSlC35stuSwvTW2FFqLRRqt4xx8FMclcsO
         ZPXGSt59WL5iq8X082bwhTlCB/DZHtjsGckJtMFseLMbl/SkGhMj9oDlKcTcYVhU4iOQ
         3JkZzJ1hBjm2KEhb1EiA/wfbS83JVtUboDnrJaLvL+nCjrlQb8153T3aknPeXdl+fVTT
         9x5Q==
X-Gm-Message-State: AOAM532UIy8Kf0QKHmpKlRzOc1bCwsdSjtzLqsH0Q1nea+z7OCxQ1Yof
        jLzW+GbQxrnkNk4lXYcL//YeZg==
X-Google-Smtp-Source: ABdhPJwk0Zb0b2MZbinehV1/jFust0XpBd9es27Uj5Lm6n52PLVgE1ZjT1e7+I/dxGSpKPWdMrnfZg==
X-Received: by 2002:a05:6512:2206:: with SMTP id h6mr11551898lfu.239.1612293434683;
        Tue, 02 Feb 2021 11:17:14 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q190sm4417402ljb.8.2021.02.02.11.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 11:17:14 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     george.mccollister@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: xrs700x: Correctly address device over I2C
Date:   Tue,  2 Feb 2021 20:16:45 +0100
Message-Id: <20210202191645.439-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On read, master should send 31 MSB of the register (only even values
are ever used), followed by a 1 to indicate read. Then, reading two
bytes, the device will output the register's value.

On write, master sends 31 MSB of the register, followed by a 0 to
indicate write, followed by two bytes containing the register value.

Flexibilis' documentation (version 1.3) specifies the opposite
polarity (#read/write), but the scope indicates that it is, in fact,
read/#write.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---

George, have you used the chip in I2C mode with the code that is on
net-next now? I was not able to get the driver to even read the ID
register correctly.

 drivers/net/dsa/xrs700x/xrs700x_i2c.c | 31 ++++++++++++---------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/xrs700x/xrs700x_i2c.c b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
index a5f8883af829..16a46a78a037 100644
--- a/drivers/net/dsa/xrs700x/xrs700x_i2c.c
+++ b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
@@ -10,33 +10,34 @@
 #include "xrs700x.h"
 #include "xrs700x_reg.h"
 
+struct xrs700x_i2c_cmd {
+	__be32 reg;
+	__be16 val;
+} __packed;
+
 static int xrs700x_i2c_reg_read(void *context, unsigned int reg,
 				unsigned int *val)
 {
 	struct device *dev = context;
 	struct i2c_client *i2c = to_i2c_client(dev);
-	unsigned char buf[4];
+	struct xrs700x_i2c_cmd cmd;
 	int ret;
 
-	buf[0] = reg >> 23 & 0xff;
-	buf[1] = reg >> 15 & 0xff;
-	buf[2] = reg >> 7 & 0xff;
-	buf[3] = (reg & 0x7f) << 1;
+	cmd.reg = cpu_to_be32(reg | 1);
 
-	ret = i2c_master_send(i2c, buf, sizeof(buf));
+	ret = i2c_master_send(i2c, (char *)&cmd.reg, sizeof(cmd.reg));
 	if (ret < 0) {
 		dev_err(dev, "xrs i2c_master_send returned %d\n", ret);
 		return ret;
 	}
 
-	ret = i2c_master_recv(i2c, buf, 2);
+	ret = i2c_master_recv(i2c, (char *)&cmd.val, sizeof(cmd.val));
 	if (ret < 0) {
 		dev_err(dev, "xrs i2c_master_recv returned %d\n", ret);
 		return ret;
 	}
 
-	*val = buf[0] << 8 | buf[1];
-
+	*val = be16_to_cpu(cmd.val);
 	return 0;
 }
 
@@ -45,17 +46,13 @@ static int xrs700x_i2c_reg_write(void *context, unsigned int reg,
 {
 	struct device *dev = context;
 	struct i2c_client *i2c = to_i2c_client(dev);
-	unsigned char buf[6];
+	struct xrs700x_i2c_cmd cmd;
 	int ret;
 
-	buf[0] = reg >> 23 & 0xff;
-	buf[1] = reg >> 15 & 0xff;
-	buf[2] = reg >> 7 & 0xff;
-	buf[3] = (reg & 0x7f) << 1 | 1;
-	buf[4] = val >> 8 & 0xff;
-	buf[5] = val & 0xff;
+	cmd.reg = cpu_to_be32(reg);
+	cmd.val = cpu_to_be16(val);
 
-	ret = i2c_master_send(i2c, buf, sizeof(buf));
+	ret = i2c_master_send(i2c, (char *)&cmd, sizeof(cmd));
 	if (ret < 0) {
 		dev_err(dev, "xrs i2c_master_send returned %d\n", ret);
 		return ret;
-- 
2.17.1

