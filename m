Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 328EADDC18
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfJTDVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:21:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33917 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfJTDUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:14 -0400
Received: by mail-qt1-f194.google.com with SMTP id 3so15295737qta.1;
        Sat, 19 Oct 2019 20:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iOKndeBThovubtjZKn69z94e2VS0eKsqBVqPTnn21W0=;
        b=X4NEMCWmmXQEESFzx2YJyASjyiG37Cakm7LWNaIp2JtjeO7FwAHCj/yCPYqlY/Lm6h
         cvwtSRqnmoOjjdKEyCpVq8BrPaQ+wFWKD503/XIsbKp9Q3gCxn+h3ITfuYJwLmPjMHDz
         5vwd1Q/QGAT/y5Qzwi8hoBDjKZdKQW/Fz6Cvt3k1baZZmyiFloaIqd9clPdyDPVeGVMR
         XplSXOetntTPn0QUsFMfT/m4hCqW/xGdWq037Lq01artIuIRIkEr2OAhotjq1fhy3O0k
         B8pkVCthrwWjSZTAt0jhIF837KxPcSZqQno0/RqHYITrlT5J/Njz/ZSah/TACZGHlMGD
         b4qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iOKndeBThovubtjZKn69z94e2VS0eKsqBVqPTnn21W0=;
        b=QfGbIZH36b2eQuKlSBbJHUCJH/fyqIRAh4pLb8YzBcaQgQ4/qTxE4otWn8N9h37Xah
         slxnLBvqPubyzriZhq4HFbDIgy/iBBaYna5+eurXkRvBcoPD0eXCdZ7Pk2n0B0gAgP95
         yqQU5K9QY/gpxrbFhYFM4W4/88gEE7GVKh3kOYmDoFI9Y0CkSK6eG+AxygcxfotUeGdx
         v0gdLiE5WLd9M/HORGXa1/rRr0igx0aff2WzVdtxo9iQ8JIBcduljSP2U2lUTiYtR/I2
         SZuN8Urqb/ZGGLRN/cYidSRw60SPlaSFq1FRSRKHiL8mvRtQ7jrEy3w3gKDn/GS6iOyn
         nIaQ==
X-Gm-Message-State: APjAAAX9n7Bz7Bh6xG1klj/8O9d1agzYQg5Zu9EfoDzwGDzuB5SMqujc
        6DVzsiX0YFNM7EYA4MsTVvr4Dsfy
X-Google-Smtp-Source: APXvYqwdxx/Wb5LEDmKnqo46NOtKId8II/Sx2GzbUdXKPa2Kxq+rBPjfJB4JPi+6sA4lL1dmD/6drA==
X-Received: by 2002:ac8:28a3:: with SMTP id i32mr17952799qti.42.1571541612944;
        Sat, 19 Oct 2019 20:20:12 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id l93sm49757qtd.86.2019.10.19.20.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:12 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 04/16] net: dsa: use ports list to find slave
Date:   Sat, 19 Oct 2019 23:19:29 -0400
Message-Id: <20191020031941.3805884-5-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ports list instead of iterating over switches and their
ports when looking for a slave device from a given master interface.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa_priv.h | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 12f8c7ee4dd8..53e7577896b6 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -104,25 +104,14 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 	struct dsa_switch_tree *dst = cpu_dp->dst;
-	struct dsa_switch *ds;
-	struct dsa_port *slave_port;
+	struct dsa_port *dp;
 
-	if (device < 0 || device >= DSA_MAX_SWITCHES)
-		return NULL;
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->ds->index == device && dp->index == port &&
+		    dp->type == DSA_PORT_TYPE_USER)
+			return dp->slave;
 
-	ds = dst->ds[device];
-	if (!ds)
-		return NULL;
-
-	if (port < 0 || port >= ds->num_ports)
-		return NULL;
-
-	slave_port = &ds->ports[port];
-
-	if (unlikely(slave_port->type != DSA_PORT_TYPE_USER))
-		return NULL;
-
-	return slave_port->slave;
+	return NULL;
 }
 
 /* port.c */
-- 
2.23.0

