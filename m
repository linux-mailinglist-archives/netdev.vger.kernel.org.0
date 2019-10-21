Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5BDDF713
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbfJUUv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:51:57 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45413 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730479AbfJUUvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:51:52 -0400
Received: by mail-qt1-f196.google.com with SMTP id c21so23283665qtj.12;
        Mon, 21 Oct 2019 13:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=95u7W4dCH8VRKrE2WocVBnfZD85GAOe+WTprB4izR4Q=;
        b=rFjFQmsj/K9JUmV1Ip+/mX7lyFMaK9S3vjySnnl8+B0buvPqovA/KBsqGlCbit2wnK
         slplXz0QR3ACQ+EfQNmbZfMC0NBZYq4j/oBnDOkPJtQwz0F7mtqNIeGejtXe363VCNHZ
         kqDjNwF9NP8zItAWG54RHsPiJm8ZgopmixzoN9US7mB9FmM5o+VRe+g3ihWbOrgHkirI
         hovh+EBLO2ud9TxLkaDPAlcu+tdPWb/PwLdmfD23ZCkNrFeupMTX9cxp0pRSPh4g/o7j
         k7PjCNmngN7fNZeykrc2MZMvqF1DVLB2tTMxaFWtGL8yRxNVS1m3CqGjIdFk41em3D7r
         ZQ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=95u7W4dCH8VRKrE2WocVBnfZD85GAOe+WTprB4izR4Q=;
        b=jzHdiG6z/LfkpFCsvwBnoFg3Gy1j3mFVV7ZJhMKLWmLCjZHSIcaRiuthzigIlVPas1
         6utG67Li27BAQqha2tVetqFPOKinxxs3DNHTCEEn1cpzcsgCiK29fIK+h68fTJXekyT6
         HDyr7peES3fcs8eQT6Su8Jcql2C3NGkO0bWw6Wc19MCYs+wWmfFVzJ9HY+MB0AFu5kBt
         bCGsfBEdXXh3ph69AV80bPP+SsZuCKr2uNXfbYsfGkSPjVsyGC9Cxbq2KUXCWYP7OxNF
         X8vo5MQashcKs7F0/7H/9eNWlo+pGBkiXV4J9vuxaR3llPCA58/5EiCN4faQ1CRkvLkg
         Qytg==
X-Gm-Message-State: APjAAAVK30+txxQjDvNpJfvw4q0j6mXC7gCOERj55L+WW27SpIqHkVwr
        qeyBgVzEVnBBszOwm3R9T8I=
X-Google-Smtp-Source: APXvYqxAOGBIpTMYVoPuonKVtvSWnGgJeJSFFkXAosdMS0XAePN4PleMe3NhVtPzf0HstCbbQ1eZEQ==
X-Received: by 2002:ac8:3408:: with SMTP id u8mr26697057qtb.380.1571691111709;
        Mon, 21 Oct 2019 13:51:51 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id x19sm8036460qkf.26.2019.10.21.13.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:51 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 10/16] net: dsa: use ports list to setup default CPU port
Date:   Mon, 21 Oct 2019 16:51:24 -0400
Message-Id: <20191021205130.304149-11-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021205130.304149-1-vivien.didelot@gmail.com>
References: <20191021205130.304149-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ports list instead of iterating over switches and their
ports when setting up the default CPU port. Unassign it on teardown.

Now that we can iterate over multiple CPU ports, remove dst->cpu_dp.

At the same time, provide a better error message for CPU-less tree.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/net/dsa.h |  5 -----
 net/dsa/dsa2.c    | 33 ++++++++++++---------------------
 2 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index bd08bdee8341..f572134eb5de 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -120,11 +120,6 @@ struct dsa_switch_tree {
 	 */
 	struct dsa_platform_data	*pd;
 
-	/*
-	 * The switch port to which the CPU is attached.
-	 */
-	struct dsa_port		*cpu_dp;
-
 	/* List of switch ports */
 	struct list_head ports;
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 80191c7702a9..bf8b4e0fcb4f 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -197,38 +197,29 @@ static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
 
 static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
 {
-	struct dsa_switch *ds;
-	struct dsa_port *dp;
-	int device, port;
+	struct dsa_port *cpu_dp, *dp;
 
-	/* DSA currently only supports a single CPU port */
-	dst->cpu_dp = dsa_tree_find_first_cpu(dst);
-	if (!dst->cpu_dp) {
-		pr_warn("Tree has no master device\n");
+	cpu_dp = dsa_tree_find_first_cpu(dst);
+	if (!cpu_dp) {
+		pr_err("DSA: tree %d has no CPU port\n", dst->index);
 		return -EINVAL;
 	}
 
 	/* Assign the default CPU port to all ports of the fabric */
-	for (device = 0; device < DSA_MAX_SWITCHES; device++) {
-		ds = dst->ds[device];
-		if (!ds)
-			continue;
-
-		for (port = 0; port < ds->num_ports; port++) {
-			dp = &ds->ports[port];
-
-			if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
-				dp->cpu_dp = dst->cpu_dp;
-		}
-	}
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
+			dp->cpu_dp = cpu_dp;
 
 	return 0;
 }
 
 static void dsa_tree_teardown_default_cpu(struct dsa_switch_tree *dst)
 {
-	/* DSA currently only supports a single CPU port */
-	dst->cpu_dp = NULL;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
+			dp->cpu_dp = NULL;
 }
 
 static int dsa_port_setup(struct dsa_port *dp)
-- 
2.23.0

