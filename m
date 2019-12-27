Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7128E12B01F
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 02:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfL0BLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 20:11:22 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53278 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfL0BLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 20:11:22 -0500
Received: by mail-wm1-f66.google.com with SMTP id m24so6990512wmc.3
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=I/NGBfL92Ady4VpQ8BWmKdGYBEDywZyiDnN/9mGafDg=;
        b=P2VaNIbdQjfLQtUhxrGcMqyXQ5eEp7EsgIujSVfPwRuaFfKOnbCQt6rV6qXeMnIgQx
         jhMtoB5Gvqv4DAxeuZFXISCO+MImjBVG7ZV4tJEwvUnZizSzqrw/bXvbzVGb4bb1n0jh
         mwlvslq6pTUiWWDqmpbi7JUN9xYPlqywPqRw9mBpdGDFDTKTKcEdTlUdpEzM1UwKqVxy
         mK6eIZ48NWX/V0ZDsipYbNW05PonPVUyNw0k3cM/pkfthKgvPz12v3/yyS362WUvQRFh
         f8Bjf0Co8FBGp3M91y4CHCvSMBrIE8byI0BquCZ0eLP6QcoKUIWKpwVrT2ViTn+1hSyY
         JUTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I/NGBfL92Ady4VpQ8BWmKdGYBEDywZyiDnN/9mGafDg=;
        b=TX/2vlVU3GITgjk7CNBgq17zOzVHAdDtvkFmQFvu45rG08aAhIAn5rdc4BhYvpeUFT
         cVbDTNt2IzJne5OWbss4sJwcb35bDX1eBs4sWXo91fXOA+513objTejVqkzJnxYf3Z3N
         gp5N3604062ZVFCnJ+9irp7T/b35ZlXHqAzJSJ1OaKn2JTuCb7cYFlcCClI0/RzYoJYz
         zD+PQyuwlNFYRNZZtcfva2LomzXCsiFWAeC/541/Eq36KN0nCeTCik+Z87XNGQ224GMO
         kLIiKVY8jXwgBhzhWpujbI8q0ge755Gwvt4oTkeip3hmSnaekQCOtWhve/s/g6CdGzp+
         kPVg==
X-Gm-Message-State: APjAAAV+b4oVAtavUqez9/+RlJ5B/UTg9TX2znT1FzPr9DYGCQIkM7Cy
        voG5cs8oTUe9dUAOQ4ERokE=
X-Google-Smtp-Source: APXvYqxW+fCkQMQf4K+K1Y33AoVa1j899o8tXtaIFYaLVTrJHL3xwvFODafzQOnSEgwdaTr+8LtgNA==
X-Received: by 2002:a7b:c342:: with SMTP id l2mr17438090wmj.159.1577409080109;
        Thu, 26 Dec 2019 17:11:20 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id o129sm10075046wmb.1.2019.12.26.17.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 17:11:19 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: sja1105: Reconcile the meaning of TPID and TPID2 for E/T and P/Q/R/S
Date:   Fri, 27 Dec 2019 03:11:13 +0200
Message-Id: <20191227011113.29349-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For first-generation switches (SJA1105E and SJA1105T):
- TPID means C-Tag (typically 0x8100)
- TPID2 means S-Tag (typically 0x88A8)

While for the second generation switches (SJA1105P, SJA1105Q, SJA1105R,
SJA1105S) it is the other way around:
- TPID means S-Tag (typically 0x88A8)
- TPID2 means C-Tag (typically 0x8100)

In other words, E/T tags untagged traffic with TPID, and P/Q/R/S with
TPID2.

So the patch mentioned below fixed VLAN filtering for P/Q/R/S, but broke
it for E/T.

We strive for a common code path for all switches in the family, so just
lie in the static config packing functions that TPID and TPID2 are at
swapped bit offsets than they actually are, for P/Q/R/S. This will make
both switches understand TPID to be ETH_P_8021Q and TPID2 to be
ETH_P_8021AD. The meaning from the original E/T was chosen over P/Q/R/S
because E/T is actually the one with public documentation available
(UM10944.pdf).

Fixes: f9a1a7646c0d ("net: dsa: sja1105: Reverse TPID and TPID2")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c          | 8 ++++----
 drivers/net/dsa/sja1105/sja1105_static_config.c | 7 +++++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2cf32c22e839..d5245e48345a 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1575,8 +1575,8 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	if (enabled) {
 		/* Enable VLAN filtering. */
-		tpid  = ETH_P_8021AD;
-		tpid2 = ETH_P_8021Q;
+		tpid  = ETH_P_8021Q;
+		tpid2 = ETH_P_8021AD;
 	} else {
 		/* Disable VLAN filtering. */
 		tpid  = ETH_P_SJA1105;
@@ -1585,9 +1585,9 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 	general_params = table->entries;
-	/* EtherType used to identify outer tagged (S-tag) VLAN traffic */
-	general_params->tpid = tpid;
 	/* EtherType used to identify inner tagged (C-tag) VLAN traffic */
+	general_params->tpid = tpid;
+	/* EtherType used to identify outer tagged (S-tag) VLAN traffic */
 	general_params->tpid2 = tpid2;
 	/* When VLAN filtering is on, we need to at least be able to
 	 * decode management traffic through the "backup plan".
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index eb143a6506eb..a65f2a437358 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -158,6 +158,9 @@ static size_t sja1105et_general_params_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+/* TPID and TPID2 are intentionally reversed so that semantic
+ * compatibility with E/T is kept.
+ */
 static size_t
 sja1105pqrs_general_params_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op)
@@ -182,9 +185,9 @@ sja1105pqrs_general_params_entry_packing(void *buf, void *entry_ptr,
 	sja1105_packing(buf, &entry->mirr_port,   141, 139, size, op);
 	sja1105_packing(buf, &entry->vlmarker,    138, 107, size, op);
 	sja1105_packing(buf, &entry->vlmask,      106,  75, size, op);
-	sja1105_packing(buf, &entry->tpid,         74,  59, size, op);
+	sja1105_packing(buf, &entry->tpid2,        74,  59, size, op);
 	sja1105_packing(buf, &entry->ignore2stf,   58,  58, size, op);
-	sja1105_packing(buf, &entry->tpid2,        57,  42, size, op);
+	sja1105_packing(buf, &entry->tpid,         57,  42, size, op);
 	sja1105_packing(buf, &entry->queue_ts,     41,  41, size, op);
 	sja1105_packing(buf, &entry->egrmirrvid,   40,  29, size, op);
 	sja1105_packing(buf, &entry->egrmirrpcp,   28,  26, size, op);
-- 
2.17.1

