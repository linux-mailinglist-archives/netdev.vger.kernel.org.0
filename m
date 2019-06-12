Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6ACE42C88
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438275AbfFLQnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:43:16 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38925 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfFLQm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:42:59 -0400
Received: by mail-qk1-f194.google.com with SMTP id i125so10767251qkd.6
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZkJZZ1tAQ/ilTwGepa8nzjic6S5B96xSATPVpwR2cKg=;
        b=YbPNHirtVsPibGOwHHNGzQqeYWF/tOosPBKJEDE812ESVB7o6aFnTxwISf+uYL8hbR
         0dONWCNvUMIZHB+GraoWkp/Q3UfLvril49OxcQJkvciDWDd3dOSwVAMesSCD4xfkQhcG
         qZAsuBqqfl246fPRH71DUAnFAU688JfeP3D62VPgIH4IVhLU5NHaAysciTrTZmAZW3Ex
         D5lM61pWzNzx2JL4FiLoWgXU0PseRgzq9WiInKcjv5+zvcLJmsN9hsbcUgAiu4cHWNq8
         DN6Biu3SG67JFQuSg+rnpOVwaxL0Wgy3sI+MVz5/AMCMh8ZEeYLREywgdWwO+ixVogje
         VVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZkJZZ1tAQ/ilTwGepa8nzjic6S5B96xSATPVpwR2cKg=;
        b=Z7raBWrRmnELs3thkAJOQg6dSwxdFKK2Ka3ISEOOT2NGmSn31e7GAyAva9z7nn6mpp
         tiO1qDIAX63zFUhUmE+gi9WRS4b8B6fdmJL3lZ3eMlNvGoDlq2xLWf9UZwLy84Q8kBOf
         LTXZ67kQt80xitf3DYkUWlDwcrfUjxqLU1+z5faVPuGW+sGVx33Ewmps/6+FsyXlCOz3
         SXUoSfP80eny/0jt3gZrkLJCvESu8WwZ2qY7HWGdK9MLDoHp1ZsHo+HRB6/0LEsG7ncR
         Ml0g7tYf3/yZ6qDfem8x1kMZcIMmJgzc6KggSbk7LqBGIB6h5MFhctg8W7+dm9v25jVy
         Eb0w==
X-Gm-Message-State: APjAAAUhCGrqhbpA3OiW15CB7iVXqWFfcirl2r4mAMo8FWmetmPawOt2
        cp08M97pPo7T3sb0f1LOPN+CTGMiJ9I=
X-Google-Smtp-Source: APXvYqzg18c1YTlCnvvRvrpdYWuzYcxGvkwY8ToojbzweNBaGvkr53tRD59jNqIqQT9aXk8KnON1Ug==
X-Received: by 2002:a37:d8e:: with SMTP id 136mr53982669qkn.259.1560357777806;
        Wed, 12 Jun 2019 09:42:57 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 77sm87190qkd.59.2019.06.12.09.42.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 09:42:57 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, andrew@lunn.ch,
        f.fainelli@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: lock mutex in port_fdb_dump
Date:   Wed, 12 Jun 2019 12:42:47 -0400
Message-Id: <20190612164247.29921-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During a port FDB dump operation, the mutex protecting the concurrent
access to the switch registers is currently held by the internal
mv88e6xxx_port_db_dump and mv88e6xxx_port_db_dump_fid helpers.

It must be held at the higher level in mv88e6xxx_port_fdb_dump which
is called directly by DSA through ds->ops->port_fdb_dump. Fix this.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 4b2f8d6f0744..6691120bd283 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1767,9 +1767,7 @@ static int mv88e6xxx_port_db_dump_fid(struct mv88e6xxx_chip *chip,
 	eth_broadcast_addr(addr.mac);
 
 	do {
-		mutex_lock(&chip->reg_lock);
 		err = mv88e6xxx_g1_atu_getnext(chip, fid, &addr);
-		mutex_unlock(&chip->reg_lock);
 		if (err)
 			return err;
 
@@ -1802,10 +1800,7 @@ static int mv88e6xxx_port_db_dump(struct mv88e6xxx_chip *chip, int port,
 	int err;
 
 	/* Dump port's default Filtering Information Database (VLAN ID 0) */
-	mutex_lock(&chip->reg_lock);
 	err = mv88e6xxx_port_get_fid(chip, port, &fid);
-	mutex_unlock(&chip->reg_lock);
-
 	if (err)
 		return err;
 
@@ -1815,9 +1810,7 @@ static int mv88e6xxx_port_db_dump(struct mv88e6xxx_chip *chip, int port,
 
 	/* Dump VLANs' Filtering Information Databases */
 	do {
-		mutex_lock(&chip->reg_lock);
 		err = mv88e6xxx_vtu_getnext(chip, &vlan);
-		mutex_unlock(&chip->reg_lock);
 		if (err)
 			return err;
 
@@ -1837,8 +1830,13 @@ static int mv88e6xxx_port_fdb_dump(struct dsa_switch *ds, int port,
 				   dsa_fdb_dump_cb_t *cb, void *data)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
 
-	return mv88e6xxx_port_db_dump(chip, port, cb, data);
+	mutex_lock(&chip->reg_lock);
+	err = mv88e6xxx_port_db_dump(chip, port, cb, data);
+	mutex_unlock(&chip->reg_lock);
+
+	return err;
 }
 
 static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
-- 
2.21.0

