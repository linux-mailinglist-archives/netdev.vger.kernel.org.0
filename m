Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F4C207A1B
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405458AbgFXRTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405391AbgFXRTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:19:23 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB01C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:22 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id q17so1433615pfu.8
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sqicd+21/6vyqmBwMtIT4lwIz534aUuSXUaVL318pzE=;
        b=A/zA8aE8oRFQllAOhI3c/+Ei1r4WrWirmQP/9z4mnJ7ByX5DuG8vDewRtTy0CZIMBU
         7bdWKz4HOulVJupx3uQRzkJpbWvI7reQoDh5QWzhqpyfHv0tU05AR71HmneYsp6WRy/Z
         Is6wGSrUqPuM4JzA79zZWhIcSlhfY5mN9Po319Pq6YQ8b7PDpMrKkm1Yw/xAjJfHUVuI
         lT3j/H4/1CG2pUn8xWE67eTzkSurVO1Qry1ut1fuP+1hgoVXAIlOfxrpYj1m4X0m3+jN
         F3w86eyr+WQ1b/X+iMT45rcP2Sy4xMZto3sdIvdQfWazNa5V8xsdGGGkdNPtDJdUGGA/
         x3Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sqicd+21/6vyqmBwMtIT4lwIz534aUuSXUaVL318pzE=;
        b=kavLAdqJ/fO2A3obsy9/J8Xoj6lbslB4b1/A/56puX/K6pYE0zRF2qJi1F+5mcOJ5x
         Jv2x+9/2Ph3x98zXBv31byX21qY4YcRUX2Zs77WJOLPqPxzWwL9PYLNVrnBCx3FDxTpy
         WfCeC5Pj+dAY/Tt880e2TqGRoGrjllG2fBoUbYlBFr9G+u88R9pCkEtYaEwsvKFFPsqr
         BSyknVYv/HYAUYiAx9zr0HT39bk9TtRFhUUIzj2T+BFuTEIOe2RaJb3nTbxCxxMLN7kx
         anOt5lgNY4GAq1tXQ4ELYVILNe0anMgJRtARgaRQDgnyXBS/WnVZpVJIwq0UuojMpKnS
         N61Q==
X-Gm-Message-State: AOAM533+f/CgjwwR7YipiWuVPSIGrHNyhySwkfdO60ngPmMOrcys0X9a
        VkkKUjdnK2rVTnrRAtZPlV7ptWyzPoE=
X-Google-Smtp-Source: ABdhPJzvU/Rr/WaOpr+VifMasEdAaxNBaA1XZUnHtNde3jeQzlhlEJoL9VXWV3z1cycV/Al8s8snkw==
X-Received: by 2002:a63:5761:: with SMTP id h33mr22288890pgm.175.1593019161885;
        Wed, 24 Jun 2020 10:19:21 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id w18sm17490241pgj.31.2020.06.24.10.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:19:21 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH 04/11] net-sysfs: Create rps_create_sock_flow_table
Date:   Wed, 24 Jun 2020 10:17:43 -0700
Message-Id: <20200624171749.11927-5-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624171749.11927-1-tom@herbertland.com>
References: <20200624171749.11927-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move code for writing a sock_flow_table to its own function so that it
can be called for other use cases.
---
 net/core/sysctl_net_core.c | 102 +++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 45 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index f93f8ace6c56..9c7d46fbb75a 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -46,66 +46,78 @@ int sysctl_devconf_inherit_init_net __read_mostly;
 EXPORT_SYMBOL(sysctl_devconf_inherit_init_net);
 
 #ifdef CONFIG_RPS
+static int rps_create_sock_flow_table(size_t size, size_t orig_size,
+				      struct rps_sock_flow_table *orig_table,
+				      bool force)
+{
+	struct rps_sock_flow_table *sock_table;
+	int i;
+
+	if (size) {
+		if (size > 1 << 29) {
+			/* Enforce limit to prevent overflow */
+			return -EINVAL;
+		}
+		size = roundup_pow_of_two(size);
+		if (size != orig_size || force) {
+			sock_table = vmalloc(RPS_SOCK_FLOW_TABLE_SIZE(size));
+			if (!sock_table)
+				return -ENOMEM;
+
+			sock_table->mask = size - 1;
+		} else {
+			sock_table = orig_table;
+		}
+
+		for (i = 0; i < size; i++)
+			sock_table->ents[i] = RPS_NO_CPU;
+	} else {
+		sock_table = NULL;
+	}
+
+	if (sock_table != orig_table) {
+		rcu_assign_pointer(rps_sock_flow_table, sock_table);
+		if (sock_table) {
+			static_branch_inc(&rps_needed);
+			static_branch_inc(&rfs_needed);
+		}
+		if (orig_table) {
+			static_branch_dec(&rps_needed);
+			static_branch_dec(&rfs_needed);
+			synchronize_rcu();
+			vfree(orig_table);
+		}
+	}
+
+	return 0;
+}
+
+static DEFINE_MUTEX(sock_flow_mutex);
+
 static int rps_sock_flow_sysctl(struct ctl_table *table, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
 {
 	unsigned int orig_size, size;
-	int ret, i;
+	int ret;
 	struct ctl_table tmp = {
 		.data = &size,
 		.maxlen = sizeof(size),
 		.mode = table->mode
 	};
-	struct rps_sock_flow_table *orig_sock_table, *sock_table;
-	static DEFINE_MUTEX(sock_flow_mutex);
+	struct rps_sock_flow_table *sock_table;
 
 	mutex_lock(&sock_flow_mutex);
 
-	orig_sock_table = rcu_dereference_protected(rps_sock_flow_table,
-					lockdep_is_held(&sock_flow_mutex));
-	size = orig_size = orig_sock_table ? orig_sock_table->mask + 1 : 0;
+	sock_table = rcu_dereference_protected(rps_sock_flow_table,
+					       lockdep_is_held(&sock_flow_mutex));
+	size = sock_table ? sock_table->mask + 1 : 0;
+	orig_size = size;
 
 	ret = proc_dointvec(&tmp, write, buffer, lenp, ppos);
 
-	if (write) {
-		if (size) {
-			if (size > 1<<29) {
-				/* Enforce limit to prevent overflow */
-				mutex_unlock(&sock_flow_mutex);
-				return -EINVAL;
-			}
-			size = roundup_pow_of_two(size);
-			if (size != orig_size) {
-				sock_table =
-				    vmalloc(RPS_SOCK_FLOW_TABLE_SIZE(size));
-				if (!sock_table) {
-					mutex_unlock(&sock_flow_mutex);
-					return -ENOMEM;
-				}
-				rps_cpu_mask = roundup_pow_of_two(nr_cpu_ids) - 1;
-				sock_table->mask = size - 1;
-			} else
-				sock_table = orig_sock_table;
-
-			for (i = 0; i < size; i++)
-				sock_table->ents[i] = RPS_NO_CPU;
-		} else
-			sock_table = NULL;
-
-		if (sock_table != orig_sock_table) {
-			rcu_assign_pointer(rps_sock_flow_table, sock_table);
-			if (sock_table) {
-				static_branch_inc(&rps_needed);
-				static_branch_inc(&rfs_needed);
-			}
-			if (orig_sock_table) {
-				static_branch_dec(&rps_needed);
-				static_branch_dec(&rfs_needed);
-				synchronize_rcu();
-				vfree(orig_sock_table);
-			}
-		}
-	}
+	if (write)
+		ret = rps_create_sock_flow_table(size, orig_size,
+						 sock_table, false);
 
 	mutex_unlock(&sock_flow_mutex);
 
-- 
2.25.1

