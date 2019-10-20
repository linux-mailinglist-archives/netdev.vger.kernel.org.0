Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73BD0DDC06
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfJTDUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:31 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33548 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfJTDU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:29 -0400
Received: by mail-qk1-f193.google.com with SMTP id 71so5207427qkl.0;
        Sat, 19 Oct 2019 20:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X9xlVGuL8skAUAFw0Gij/npap/PFiX9j4tAkAhvoK5g=;
        b=CNRME8l3ErVV/iBW27ES1rYw6B0TlJZJNibU5jCYZpuPlGvjCrFCwEDfMA1xsmvc71
         aNAkj1NB5iEjwdUFNTHNKZpxl/9CAY92PwUgSprcGXOMJhOuIu/SQ0byCE6Wi6AuMNu/
         az9x0MQl9aXVd8NXMMI397d9IsA91JEYKgtSunbj0gwAgW9D+gInJlJZbS8n2rKzi17N
         PvuNjyfSYgmklKn4W3i9yYvo1WHomJp193I7G4jams1dxZU+kFjU2qoF+iRr01hkq9C9
         8E+5SWtnWFv0ffKfK3trJ65JlW0nB0GVx57mJjG6oUmTP0pvNFRWzPqoLOCxBF1Zn1KH
         9ZLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X9xlVGuL8skAUAFw0Gij/npap/PFiX9j4tAkAhvoK5g=;
        b=e9f1ImzvOatvgkJl5tIbu9dR6n6nKRTwU/surqNE/1n2BybpN4hv9l2esPLs8Bmue8
         KoxYJ6wAXdMYqaAAai5YZp5gns0P/Os0221Gi2FtdX6Hn+yef+GVZgCylN7G+Esqg8gy
         8X2a1O5qeNTWqYJ5khypqqc6dCV9/JLbzNgrOTrJTXaAz9qWvrV/FTGBy3G5oBsc6+EJ
         kG1RQjurW2fhPiIyPIW5GSr8vcfOVW02lz6liIFM/O/hPCH7E0RYu0wENlzTRz03/mMd
         tFjgJon4SyNpqc2V32tGcLKRrOX3CRsphcDWD4mSKyeJDz8CGbD+H/C4Jc6KpfwNqkwh
         M6Fg==
X-Gm-Message-State: APjAAAX8PU4zj4cmlzLPWS1rp8XFY8MR68gEF2uybiBB3V9r/Q/TKrsR
        HB9LBOUbvsa8YEQ1W0ik1i0=
X-Google-Smtp-Source: APXvYqzugvPkLsi3lv66B7jammOL7Fsvi9iTEHyKjU+sL9WLKozE3bkdScJLr/Guv9PZ4Mehv4VJOg==
X-Received: by 2002:a05:620a:2102:: with SMTP id l2mr15601359qkl.363.1571541628607;
        Sat, 19 Oct 2019 20:20:28 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q47sm11924569qtq.95.2019.10.19.20.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:28 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 15/16] net: dsa: allocate ports on touch
Date:   Sat, 19 Oct 2019 23:19:40 -0400
Message-Id: <20191020031941.3805884-16-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allocate the struct dsa_port the first time it is accessed with
dsa_port_touch, and remove the static dsa_port array from the
dsa_switch structure.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h |  2 --
 net/dsa/dsa2.c    | 16 ++++++++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 020f5db8666b..d28ac54cb8c4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -277,9 +277,7 @@ struct dsa_switch {
 	 */
 	bool			vlan_filtering;
 
-	/* Dynamically allocated ports, keep last */
 	size_t num_ports;
-	struct dsa_port ports[];
 };
 
 static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 772deacc33d3..7669a6278c40 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -596,7 +596,13 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 	struct dsa_switch_tree *dst = ds->dst;
 	struct dsa_port *dp;
 
-	dp = &ds->ports[index];
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->ds == ds && dp->index == index)
+			return dp;
+
+	dp = kzalloc(sizeof(*dp), GFP_KERNEL);
+	if (!dp)
+		return NULL;
 
 	dp->ds = ds;
 	dp->index = index;
@@ -865,7 +871,7 @@ struct dsa_switch *dsa_switch_alloc(struct device *dev, size_t n)
 {
 	struct dsa_switch *ds;
 
-	ds = devm_kzalloc(dev, struct_size(ds, ports, n), GFP_KERNEL);
+	ds = devm_kzalloc(dev, sizeof(*ds), GFP_KERNEL);
 	if (!ds)
 		return NULL;
 
@@ -893,6 +899,12 @@ static void dsa_switch_remove(struct dsa_switch *ds)
 {
 	struct dsa_switch_tree *dst = ds->dst;
 	unsigned int index = ds->index;
+	struct dsa_port *dp, *next;
+
+	list_for_each_entry_safe(dp, next, &dst->ports, list) {
+		list_del(&dp->list);
+		kfree(dp);
+	}
 
 	dsa_tree_remove_switch(dst, index);
 }
-- 
2.23.0

