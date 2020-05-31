Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB95A1E963E
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 10:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgEaI2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 04:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgEaI2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 04:28:52 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6490DC03E969
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:28:52 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id l27so6315550ejc.1
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l2Eb8GGMDugwQb65omjm2Nb5C9ef279aa+xFS+o9SUg=;
        b=MnxmjGffNZUIPGgYTVU0R2FMNEVVPnsqxWKPNCmasqZNK2a5aFP/9xE869MGYT5Ede
         JwOBbhJsC9rd5xAhfl9OWhtQ4Gjb7zGvya4ipKN3VluMLYVp6CKM5nrInffAe7AMAFAA
         4ox+GJeA43PTdRqeC/X7Fd03YEFS6W1wWVD/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l2Eb8GGMDugwQb65omjm2Nb5C9ef279aa+xFS+o9SUg=;
        b=pUEtf8ycNVsuuQLeRVV4GJRs6VEM9CehWXjaguq8kRojn4Zgpzyrk7apW8Es40a6fG
         P5GgcNPayYELhk4uBO8/06D7mW52sjbPxI9ZVuR7U6JbmstGPji1K32UF4BlZGSmIGMk
         W+BRNC+LeuMw05ex+5l6GJuy85lfaMcGVuOzBRSvJP46NiS8oTxPeX9/CfyEPTl4o0dD
         CA69nvKoahkITlmemguSXfhVvnqoC5AVaYJZ1w6zkec9Q4Hw66B+EM55Tcb81O7cKgOl
         eCjrdqJZDQG53Q8d2llkO2FxZjiiAp0tfsWHmJxLijf8iFUE3SJPk9Xht1zCn/eEWutx
         NH5A==
X-Gm-Message-State: AOAM531739OKPZjRvJIfXVIF52fiD67UPZo838hBAP7QqH8ncAoGQlvP
        V4Ip7fupqom5EVjE0UOAZWaHWA==
X-Google-Smtp-Source: ABdhPJxJDjclfY3XnFhbqybAKqHNVQE48U6hJVHFw3iIalUSOeqmYelrOBl5qXzA0K/8DGw/FecGEw==
X-Received: by 2002:a17:906:670d:: with SMTP id a13mr11520617ejp.290.1590913731090;
        Sun, 31 May 2020 01:28:51 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id v29sm3499252edb.62.2020.05.31.01.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 01:28:50 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Stanislav Fomichev <sdf@google.com>
Subject: [PATCH bpf-next v2 01/12] flow_dissector: Pull locking up from prog attach callback
Date:   Sun, 31 May 2020 10:28:35 +0200
Message-Id: <20200531082846.2117903-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200531082846.2117903-1-jakub@cloudflare.com>
References: <20200531082846.2117903-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split out the part of attach callback that happens with attach/detach lock
acquired. This structures the prog attach callback in a way that opens up
doors for moving the locking out of flow_dissector and into generic
callbacks for attaching/detaching progs to netns in subsequent patches.

Reviewed-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/flow_dissector.c | 40 +++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 5dceed467f64..ad08b51c781e 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -109,15 +109,10 @@ int skb_flow_dissector_prog_query(const union bpf_attr *attr,
 	return 0;
 }
 
-int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
-				       struct bpf_prog *prog)
+static int flow_dissector_bpf_prog_attach(struct net *net,
+					  struct bpf_prog *prog)
 {
 	struct bpf_prog *attached;
-	struct net *net;
-	int ret = 0;
-
-	net = current->nsproxy->net_ns;
-	mutex_lock(&flow_dissector_mutex);
 
 	if (net == &init_net) {
 		/* BPF flow dissector in the root namespace overrides
@@ -130,33 +125,38 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
 		for_each_net(ns) {
 			if (ns == &init_net)
 				continue;
-			if (rcu_access_pointer(ns->flow_dissector_prog)) {
-				ret = -EEXIST;
-				goto out;
-			}
+			if (rcu_access_pointer(ns->flow_dissector_prog))
+				return -EEXIST;
 		}
 	} else {
 		/* Make sure root flow dissector is not attached
 		 * when attaching to the non-root namespace.
 		 */
-		if (rcu_access_pointer(init_net.flow_dissector_prog)) {
-			ret = -EEXIST;
-			goto out;
-		}
+		if (rcu_access_pointer(init_net.flow_dissector_prog))
+			return -EEXIST;
 	}
 
 	attached = rcu_dereference_protected(net->flow_dissector_prog,
 					     lockdep_is_held(&flow_dissector_mutex));
-	if (attached == prog) {
+	if (attached == prog)
 		/* The same program cannot be attached twice */
-		ret = -EINVAL;
-		goto out;
-	}
+		return -EINVAL;
+
 	rcu_assign_pointer(net->flow_dissector_prog, prog);
 	if (attached)
 		bpf_prog_put(attached);
-out:
+	return 0;
+}
+
+int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
+				       struct bpf_prog *prog)
+{
+	int ret;
+
+	mutex_lock(&flow_dissector_mutex);
+	ret = flow_dissector_bpf_prog_attach(current->nsproxy->net_ns, prog);
 	mutex_unlock(&flow_dissector_mutex);
+
 	return ret;
 }
 
-- 
2.25.4

