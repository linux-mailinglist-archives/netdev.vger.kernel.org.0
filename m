Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2744527A8
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 03:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243701AbhKPC34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 21:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236770AbhKORQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:16:35 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72DDC061220
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:11:59 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id x7so13351128pjn.0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ztiZtpvaPEESRC+ARrg5moYa1E+yP0K/qu/oBI/4DRE=;
        b=pNZ1JIHCUGbBz0R0xepzgkii0ulprOHCuUUjAa9NWraJIajU0WSxxEayO6pT0IICRs
         ZOQ6a5+w1rBzfs9RG7pZ5hHayvqtbN4vhKz1VIVMWKv5uKHEjWFjFLacJUKo4P97Iz4y
         nsdxPetw0KcEBHWImbjyaeHYUlINzRiU4kJnCFJjq32GOZ1w/US19FehSNg3MUCgptRN
         Rk/yoz19Lbxgr7HoE7ATKh1NlQn0+6Hf2wmabJaOd2rN92twpbd2yEbjH7HuyqJe6g4O
         jcREE6I+Yu0b3SGS0qhfgucLxRb1ijAcVTQrISEorW43c7PrmPhFPIKDfWb+ErWIEGqf
         FHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ztiZtpvaPEESRC+ARrg5moYa1E+yP0K/qu/oBI/4DRE=;
        b=ml6CqGNrMjOHpwjpSis2zpC90PmSIyiDl/ivGz7oIHa/hLUKtccbJmAjNYJmAUWzkh
         Od0XooENkUikIS8QD2lwLb9KlXC/CjJXCeWVEw5lhirjS1uU3H4cJCf4FY/CI5UyZoHP
         wSRlTKNvhpdcD0Sure6xHB7j7g0BoGZg+h6qdKdbK1d2cNcQEx8UWKywVvB4bBwQrVpy
         hqxkjKp6xr6dmnYOzm2N1zi81FSS6KlAtRAkhmmcI/kPD95+yK4OQLPMrVvxni5tLX/c
         d+dpDFy3dJ/S2bA3yR8XwAWmiZhTXI+NTadb93zCtvXom+1BvF6ttqtSleMoarTikHF5
         i1ng==
X-Gm-Message-State: AOAM530Us3/aWP750O3BwMDytRPn1qNGRXWBQ5qBTu/STPqcnr1V3ws/
        5WiDiidEJ/BNFdKHQ1lclEfbOFDEchw=
X-Google-Smtp-Source: ABdhPJzLhrXFe0/yyqjswPdHvEDSNNtxcSZIQxX42gJTwC9NE7T33kOD0c1uYPc4XDeBxTRR4Yocyw==
X-Received: by 2002:a17:90a:d48f:: with SMTP id s15mr161188pju.64.1636996319379;
        Mon, 15 Nov 2021 09:11:59 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id j127sm16466632pfg.14.2021.11.15.09.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:11:59 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/4] net: merge net->core.prot_inuse and net->core.sock_inuse
Date:   Mon, 15 Nov 2021 09:11:49 -0800
Message-Id: <20211115171150.3646016-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115171150.3646016-1-eric.dumazet@gmail.com>
References: <20211115171150.3646016-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

net->core.sock_inuse is a per cpu variable (int),
while net->core.prot_inuse is another per cpu variable
of 64 integers.

per cpu allocator tend to place them in very different places.

Grouping them together makes sense, since it makes
updates potentially faster, if hitting the same
cache line.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/core.h |  1 -
 include/net/sock.h       |  3 ++-
 net/core/sock.c          | 12 +-----------
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/include/net/netns/core.h b/include/net/netns/core.h
index 36c2d998a43c015c4b917428ec33f5839cde89b1..552bc25b19335e2ee07effa2550bbe5944eb33aa 100644
--- a/include/net/netns/core.h
+++ b/include/net/netns/core.h
@@ -12,7 +12,6 @@ struct netns_core {
 	int	sysctl_somaxconn;
 
 #ifdef CONFIG_PROC_FS
-	int __percpu *sock_inuse;
 	struct prot_inuse __percpu *prot_inuse;
 #endif
 };
diff --git a/include/net/sock.h b/include/net/sock.h
index cdc7ebc049b41b00aa7c851a6f1df6e58bae8430..fefffeb1cc3d5a11615afbc34e5cd7521bd6f502 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1421,6 +1421,7 @@ proto_memory_pressure(struct proto *prot)
 #ifdef CONFIG_PROC_FS
 #define PROTO_INUSE_NR	64	/* should be enough for the first time */
 struct prot_inuse {
+	int all;
 	int val[PROTO_INUSE_NR];
 };
 /* Called with local bh disabled */
@@ -1432,7 +1433,7 @@ static inline void sock_prot_inuse_add(const struct net *net,
 
 static inline void sock_inuse_add(const struct net *net, int val)
 {
-	this_cpu_add(*net->core.sock_inuse, val);
+	this_cpu_add(net->core.prot_inuse->all, val);
 }
 
 int sock_prot_inuse_get(struct net *net, struct proto *proto);
diff --git a/net/core/sock.c b/net/core/sock.c
index 214c2e816c63dba9146557a622516e73c1da142e..2f58e4d3e76296280aece28314b8695d0d40cf02 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3549,7 +3549,7 @@ int sock_inuse_get(struct net *net)
 	int cpu, res = 0;
 
 	for_each_possible_cpu(cpu)
-		res += *per_cpu_ptr(net->core.sock_inuse, cpu);
+		res += per_cpu_ptr(net->core.prot_inuse, cpu)->all;
 
 	return res;
 }
@@ -3561,22 +3561,12 @@ static int __net_init sock_inuse_init_net(struct net *net)
 	net->core.prot_inuse = alloc_percpu(struct prot_inuse);
 	if (net->core.prot_inuse == NULL)
 		return -ENOMEM;
-
-	net->core.sock_inuse = alloc_percpu(int);
-	if (net->core.sock_inuse == NULL)
-		goto out;
-
 	return 0;
-
-out:
-	free_percpu(net->core.prot_inuse);
-	return -ENOMEM;
 }
 
 static void __net_exit sock_inuse_exit_net(struct net *net)
 {
 	free_percpu(net->core.prot_inuse);
-	free_percpu(net->core.sock_inuse);
 }
 
 static struct pernet_operations net_inuse_ops = {
-- 
2.34.0.rc1.387.gb447b232ab-goog

