Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140243AE55C
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 10:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhFUI5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 04:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbhFUI5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 04:57:18 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C110C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 01:55:04 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x24so28873602lfr.10
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 01:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6xt+DFWWLgjAVZ2a989OkV+zFvMqWK3R6aybMnAQbdw=;
        b=K4KsGYML0//YXyH6UfGX5ovi6/DmgdZXdJ+96V9Vdsa40GJO0HHsWgEEP47fE3zqy/
         tXjsslsWTFnxaRO7Pp9Vqa+6KrMusUa5MT9kB+Z+Cu4kAlsOs4VqVuIYZqWtGuXCQivX
         uWFGOav35CCF3J/gckUuINyHZTQXhIS6bVXvgjRajVEF7j7duBP4Gp1aMzij65SQwPO+
         qFSoQ445D/dxdIZEZOR8atwiDrPZADOblZbSpY/iLwBghf9vLcbsfp3hQqfVtqhQQZjy
         1PbQ32h8cG0dnnN88nHgtcPAKuOphaDCuULGpCfphjrSWxhKGy7bGHXZZu3OC2uGL1RN
         vZmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6xt+DFWWLgjAVZ2a989OkV+zFvMqWK3R6aybMnAQbdw=;
        b=XJH2KZXpmDYCp8g3c1a2XFzzg7T9g8rxPKe7Ae4+eQlDqbWZfRj+aoAt+CM39pkSC2
         del/bfyWmd7cWDSUj7LWs5IaZNz1cA9o0Jcx6z1doMA5pFjuC+M5ZGtAQnnnRGJO6cLW
         hI5KFxx1gzMXbWGK0e7Pbo+1LUnu4Bx3cRe2RmRf2+Y802uVv1f2KmrrGx94nNNZ3zJo
         mZB9IzeuZjJcORQYp52TIcYZTk4Z3tx1zCF91EGKN6tDRNM9PMBfo5nQoPPTB26IQihv
         ileQp8nH00P/pQlv8JoZX50tgBvQRoIm6mhrByAZsYdkLWqbZ7YU1DKwfGBcQP3B9C8n
         8JGw==
X-Gm-Message-State: AOAM5313YWFLXvuPaxE9lzomw8rQErCqBrdCnl482IVc5Ha1dSiKkj0p
        wpwIMoeziExd8mnwb6q3Up8N8PgkjS8rbQ==
X-Google-Smtp-Source: ABdhPJxD4UArhFquH8Ao1kg9I5RSl8hWdIJqvqJl3mRljhe9DBRq2cRRevC/6+JcXZ0Rlg32CNmn6Q==
X-Received: by 2002:a05:6512:214a:: with SMTP id s10mr1979301lfr.661.1624265702238;
        Mon, 21 Jun 2021 01:55:02 -0700 (PDT)
Received: from localhost.localdomain ([185.6.236.169])
        by smtp.googlemail.com with ESMTPSA id j16sm2036601ljh.66.2021.06.21.01.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 01:55:01 -0700 (PDT)
From:   Eldar Gasanov <eldargasanov2@gmail.com>
Cc:     netdev@vger.kernel.org, Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] mv88e6xxx: fixed adding vlan 0
Date:   Mon, 21 Jun 2021 11:54:38 +0300
Message-Id: <20210621085437.25777-1-eldargasanov2@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

8021q module adds vlan 0 to all interfaces when it starts.
When 8021q module is loaded it isn't possible to create bond
with mv88e6xxx interfaces, bonding module dipslay error
"Couldn't add bond vlan ids", because it tries to add vlan 0
to slave interfaces.

There is unexpected behavior in the switch. When a PVID
is assigned to a port the switch changes VID to PVID
in ingress frames with VID 0 on the port. Expected
that the switch doesn't assign PVID to tagged frames
with VID 0. But there isn't a way to change this behavior
in the switch.

Signed-off-by: Eldar Gasanov <eldargasanov2@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index eca285aaf72f..961fa6b75cad 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1618,9 +1618,6 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
 
-	if (!vid)
-		return -EOPNOTSUPP;
-
 	/* DSA and CPU ports have to be members of multiple vlans */
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		return 0;
@@ -2109,6 +2106,9 @@ static int mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	u8 member;
 	int err;
 
+	if (!vlan->vid)
+		return 0;
+
 	err = mv88e6xxx_port_vlan_prepare(ds, port, vlan);
 	if (err)
 		return err;
-- 
2.25.1

