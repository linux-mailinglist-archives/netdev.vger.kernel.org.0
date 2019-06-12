Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D56448B8
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbfFMRKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:10:54 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45344 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729211AbfFLWeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 18:34:06 -0400
Received: by mail-qt1-f194.google.com with SMTP id j19so20321261qtr.12
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 15:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OUFpTFR7Q1clJWlHqVQPeu8VYScZ+EuKcHUlGl5Wofo=;
        b=owWVOJ/lcf0DY+szbhF9Lw0cCSVrLylF0Ya9cuByrfXKKZ7ZfgnxEY9SiN+hXgUJvA
         U/DcekpW9m0thKM2Ph9dNYvZ82p7S7NKpNu30va0X3o5Z1sRELdZUUkth9oJXWM05B4N
         raXnPOY2sFTF3qnlO2f7vRfhGlkeZIBWrO9627VAAig5lihlLzi7OMQr2GK996h6LMKa
         MnmMTb6zyvqHQSLhDlFN11UKBX49ySsaMYnqdiHjbZ1mMBc27aJxuT/RAzG16Hrk29fu
         Ud0NR6pAloA3SajgnAQ6tO4qTY534WfmoJ5QCWt9btdIhah0vrDQF+60M5QW+y8wWpY/
         /46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OUFpTFR7Q1clJWlHqVQPeu8VYScZ+EuKcHUlGl5Wofo=;
        b=AsE08LkQ6n44nWbV0mXqOchQb6DdrrQeQJbEz7f8S5LbBPw3mVcEyvkF0jH1NK975a
         sruk03I+5mgi9f9r0Qg310iDG/R1KUGX5EBOtdNK9zReBOy61cS5s29t6GuGM1q26f53
         RxBNwFoWDPG7sqlK1G4h+oitfAW+kUvTCQ2xYdf23N0J9Jst4QFMy/fGGFQACUHQZ/CW
         v8V5+osoGKIAdLDn0sfYcMOYENEzXc1ow6qvJs7sUzBDHA87ZxTfcN2Y1D6FlYd0XUz7
         O6I6OW0eLohkjyG80X4USBttfkWToZIcrgGZKzCq7nALT5mtlRbbN4M0rQKLUFbPv0P1
         NxRQ==
X-Gm-Message-State: APjAAAVCEiLKhtm9HYyOv4YtjMpp9iPjDrYnWosLOKGc/zdMAJUlCBMY
        FmXCiCwkBIRr9DM63e/KRGsaZryCw2U=
X-Google-Smtp-Source: APXvYqwliAFAZFvziD1eetfKjSmsP+NGWPp7jMHzc/xANRKarpZFPu7yATJ6fWYDWXwYizRiD3kSPg==
X-Received: by 2002:ac8:2209:: with SMTP id o9mr72973348qto.17.1560378844572;
        Wed, 12 Jun 2019 15:34:04 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o185sm460366qkd.64.2019.06.12.15.34.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 15:34:03 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: do not flood CPU with unknown multicast
Date:   Wed, 12 Jun 2019 18:33:44 -0400
Message-Id: <20190612223344.28781-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA ports must flood unknown unicast and multicast, but the switch
must not flood the CPU ports with unknown multicast, as this results
in a lot of undesirable traffic that the network stack needs to filter
in software.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d8d1781810e2..e412ccabd104 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2111,15 +2111,13 @@ static int mv88e6xxx_setup_message_port(struct mv88e6xxx_chip *chip, int port)
 static int mv88e6xxx_setup_egress_floods(struct mv88e6xxx_chip *chip, int port)
 {
 	struct dsa_switch *ds = chip->ds;
-	bool flood;
+	bool uc = dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port);
+	bool mc = dsa_is_dsa_port(ds, port);
 
-	/* Upstream ports flood frames with unknown unicast or multicast DA */
-	flood = dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port);
-	if (chip->info->ops->port_set_egress_floods)
-		return chip->info->ops->port_set_egress_floods(chip, port,
-							       flood, flood);
+	if (!chip->info->ops->port_set_egress_floods)
+		return 0;
 
-	return 0;
+	return chip->info->ops->port_set_egress_floods(chip, port, uc, mc);
 }
 
 static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
-- 
2.21.0

