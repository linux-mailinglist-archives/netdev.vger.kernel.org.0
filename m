Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F912DDC17
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfJTDUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:21 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41394 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfJTDUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:19 -0400
Received: by mail-qt1-f195.google.com with SMTP id c17so12253684qtn.8;
        Sat, 19 Oct 2019 20:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j9hDHfsSAKK+yajqRer2bUPE7TxRgMBzPOn+n08Gyj4=;
        b=PjdrYfVGdYPMFjrMWWt2SOPJ3ML/vTGkTbpPs1vepNzjDygt2q/VdB8doop4iLs2se
         h057Dv4X9HnXLC6TCa+UGQRJdbgyuCLw7bwK5psIc79YZvCdgWG6vfI3A4QENpj3w+4H
         dU9ETm6mqWYApWp1mlPqNcr17PRXjGFyg7WoZw18OYvMiOEnj96LO2toG77A+Q8ZhMs5
         Xw2fYYSltHokvZwTBpKSgcr3qUayEjucUa/dKC8Exex4uqRa4r3fCw3btBpvDcOhYNR0
         BQMSx7pKIIKpnp3hskq50pOEg7YuEnrEDThfSBHDNaSF7hJHoXgTmMR/JsWkurySZcPf
         Rkqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j9hDHfsSAKK+yajqRer2bUPE7TxRgMBzPOn+n08Gyj4=;
        b=RNnZEIBpDpiJuil8HJwij2HWxPMtZ3VXUVtORXjvBb0rXemv6kJB/rBDv+Zuhz7GB2
         iNvn5ETz2sb0s8i+aeKcvI0IVtLaY8r0zd4b+Wx2yNeHThuhsjip1UK2n3vdcqZndWXI
         +J12tsW6otOUW0iC7fQ2EsC+GkvZ+YN82pcAMqWqtfWmAezhSfBeNpvverfVJhgw9hLn
         GwA78D7uT7AJMpNN3O6Ljr4YCySHe0/Qb/JWDeqFqJk4H2d9fhK5gmkWwnVfKxfRodha
         RUTinuLhvXhFhQc3j+wbYfzj6xFF+BflOMzzpTV5B3U/fAGvKnGySgErrNaFJ9+rE0vF
         vzMg==
X-Gm-Message-State: APjAAAWXqhLN07ttOk6rFHqi9tKIgQQE3u7DGKpEg5RsQTJq3cZW0bro
        UHVbQEzakrW9Ud5t+j7c8O00MeI4
X-Google-Smtp-Source: APXvYqzzGv+GzXIwugfDEY99ZABisV67Z65C1Nlohi/TPcPx2Vv1XyUKF72ATOfzCUAFIOOK3AUemw==
X-Received: by 2002:ac8:27b7:: with SMTP id w52mr18395725qtw.78.1571541618477;
        Sat, 19 Oct 2019 20:20:18 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id g10sm5507994qki.41.2019.10.19.20.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:17 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 08/16] net: dsa: use ports list to setup multiple master devices
Date:   Sat, 19 Oct 2019 23:19:33 -0400
Message-Id: <20191020031941.3805884-9-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a potential list of CPU ports, make use of it instead
of only configuring the master device of an unique CPU port.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa2.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 8b038cc56769..3b8de155bc0b 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -501,19 +501,27 @@ static void dsa_tree_teardown_switches(struct dsa_switch_tree *dst)
 
 static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *cpu_dp = dst->cpu_dp;
-	struct net_device *master = cpu_dp->master;
+	struct dsa_port *dp;
+	int err;
 
-	/* DSA currently supports a single pair of CPU port and master device */
-	return dsa_master_setup(master, cpu_dp);
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dsa_port_is_cpu(dp)) {
+			err = dsa_master_setup(dp->master, dp);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
 }
 
 static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *cpu_dp = dst->cpu_dp;
-	struct net_device *master = cpu_dp->master;
+	struct dsa_port *dp;
 
-	return dsa_master_teardown(master);
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_is_cpu(dp))
+			dsa_master_teardown(dp->master);
 }
 
 static int dsa_tree_setup(struct dsa_switch_tree *dst)
-- 
2.23.0

