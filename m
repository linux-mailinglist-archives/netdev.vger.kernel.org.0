Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC663AE9A4
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFUNGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhFUNGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:06:00 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1360C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 06:03:45 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id a11so17028689lfg.11
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 06:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eEGnUXzQ996BJpMIasePcbw9avTSlX8fIylKg1LFy+k=;
        b=ZVaSbj1ggahME5iV3JzPOpUVeHxjNtpA5wtQaDGtVISMoP6Ji2i5wN+339RCpnXhNV
         /EdtPsujxJ1OuGuh2bfwwAdVoV/NRoHP7yRN7S61Img//FIMdnt0wWeG9pIYejoMU0+2
         JR9XIZFXO8K9Kr6D/feOl0bhI0DAGWzO++yBnferDRbReLi6Y601WfYHMPkXs0JiPjA6
         TGkuyVfJ1DT6URnOTAjK5K8Iq9QE4d3r3YbsesNO0fchS+QS3qNpanbHbmJzcwLiK68x
         DjOoD9Ii2eN87pAB7LAxvd3tZioLzMHiaAACYTOcue/T73B/wloge7XNI0lgdfQVj26H
         ++rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eEGnUXzQ996BJpMIasePcbw9avTSlX8fIylKg1LFy+k=;
        b=a8oQsGmijwMWBF90jNwspykDXKvQeG4GTVLUiQfil8OUKm+RgqaSMKsG+2u/nWG7VI
         C4nzO75FhxnBXHGKKX060VWKT9bytVP7atxoE11P8T67qKh6ozA1knBXrLGbs3CKAOnk
         yIpX9wUkheXF2DvtEvCqchBwMNgXLg7GVKw5v6dXc0ciom7fay9xlG4tB+RRrlyCfFn6
         7QOadTAYANlzJuz1NamxUN3mFnfpNFlDszeR4L0MIMYmxzPRKNNz4ZV2hma3SI7aA4j1
         e+RHWPTQAqHQVriYU0oL3VB7/TvweVaf32V00/4m7P16NRJWAtPYdj9JYg1kdqdtnkJC
         SkmA==
X-Gm-Message-State: AOAM533E/WQD6T0ZSfS9R7+SAQk8B8mnvzcEPP14iV/FVJOrBS3RXbym
        HQxIo2kidzLrUGTOck+9TJgYvhZ/rJt/Ww==
X-Google-Smtp-Source: ABdhPJzau2YjwqJuCKGkMJXreGO+FRhwq7DWbYZKVp9OIbyqwU3qXBXxxD0wSlfcWZmbhlFsJbUjgA==
X-Received: by 2002:ac2:5612:: with SMTP id v18mr14854150lfd.385.1624280623733;
        Mon, 21 Jun 2021 06:03:43 -0700 (PDT)
Received: from localhost.localdomain ([185.6.236.169])
        by smtp.googlemail.com with ESMTPSA id d2sm1870347lfv.294.2021.06.21.06.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:03:43 -0700 (PDT)
From:   Eldar Gasanov <eldargasanov2@gmail.com>
Cc:     netdev@vger.kernel.org, Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net] net: dsa: mv88e6xxx: Fix adding VLAN 0
Date:   Mon, 21 Jun 2021 16:01:41 +0300
Message-Id: <20210621130140.33011-1-eldargasanov2@gmail.com>
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
Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")
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

