Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC71CE902
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 18:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbfJGQVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 12:21:11 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:38707 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727947AbfJGQVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 12:21:10 -0400
Received: by mail-pf1-f201.google.com with SMTP id d126so11463346pfd.5
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 09:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gHuHyva/Nx8wCm1oDORX0MnGjoMiszZlBpqQNixq7Cw=;
        b=J9ZAIBLgW7Vj/prF05UGHDxJvVH7xZnjzOS4s3jT8o9CFa04E67NoWGBnaQuu9rSCk
         qqI+gJMCzHMXuiHsAf3VZLALqzBk4pYPOwKlWnw7yDGpSptLdJKsrAqOMLysiAMH6knJ
         fMuRVjc1mml72bPVvYbdhxBcQBUIML00546tKuGy1qx0fABiVZqwYjYljuapmRYLBAy8
         TwTJP73ncTbN//MT+pUpYrH0BwcpabJkQxxbFVS6h32NAOOtfTqhrATWWhGiCoAdWpm1
         wlG028q41P39eoBuTAb4+ZgZ8Pzty8YQbIC4iTb5G20eyLbjU2FL6BkJ7oDWn9dNvVDP
         pJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gHuHyva/Nx8wCm1oDORX0MnGjoMiszZlBpqQNixq7Cw=;
        b=bnJ+cGHkVs9AU+4x4LVpZfZ4uxwOvadiU6w6MOZ6B9L8Ambo0SNRE/5t5qwUni+Wki
         GPLPmPPn95iba+zwLvw3aRE5U8u0q6H1peL4hZaa0GoyhNb3SLpsUOpbOv1PAvY2kZ6S
         GBece4be2OD7oGMQcpQqPEVfX/gPma7QTsQxieHWiPcvBEG2gd7PjqZg56xNGtXBYW8V
         AnJvfgJsEZytY1C0mgRDb/cm3MnYdkWQ3LO+h46STChLSjPrfnTmrJ4YTpeCd4RjYxO0
         eu8cXaFYQnVnw2n5RSkpsqpOsuq66n28Wn6rMru/JdTCI9QS4cbpTpukNm6Sn47Lyf0D
         9GVg==
X-Gm-Message-State: APjAAAWXZQWNA0GQVHwYXLFVD29uMNyLO0Jjg/wiXgiYyjm+7dNy8HJE
        wSGRIEElG1WRMmgR7pYTx6UCeVpTBYwkEctV+zO0/W8VUcdIsZI88SZn5VRlBSd2XDBX1Cvv7wO
        sshztCBj8wP/KQ2DEjYgx9ZdRQAbdm9n7LjQ3JRIyAxnFA/a9JJB+Ig==
X-Google-Smtp-Source: APXvYqx6m0uEhECEH7gDDxD+lFRgcW6aSiJBNgYsbFL5gjF4vhXXC+kNGMvz8fN16N2BIwcJoLMsrlw=
X-Received: by 2002:a63:91:: with SMTP id 139mr9908143pga.71.1570465268105;
 Mon, 07 Oct 2019 09:21:08 -0700 (PDT)
Date:   Mon,  7 Oct 2019 09:21:02 -0700
In-Reply-To: <20191007162103.39395-1-sdf@google.com>
Message-Id: <20191007162103.39395-2-sdf@google.com>
Mime-Version: 1.0
References: <20191007162103.39395-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH bpf-next v3 1/2] bpf/flow_dissector: add mode to enforce
 global BPF flow dissector
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Always use init_net flow dissector BPF program if it's attached and fall
back to the per-net namespace one. Also, deny installing new programs if
there is already one attached to the root namespace.
Users can still detach their BPF programs, but can't attach any
new ones (-EEXIST).

Cc: Petar Penkov <ppenkov@google.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/bpf/prog_flow_dissector.rst |  3 ++
 net/core/flow_dissector.c                 | 38 ++++++++++++++++++++---
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/Documentation/bpf/prog_flow_dissector.rst b/Documentation/bpf/prog_flow_dissector.rst
index a78bf036cadd..4d86780ab0f1 100644
--- a/Documentation/bpf/prog_flow_dissector.rst
+++ b/Documentation/bpf/prog_flow_dissector.rst
@@ -142,3 +142,6 @@ BPF flow dissector doesn't support exporting all the metadata that in-kernel
 C-based implementation can export. Notable example is single VLAN (802.1Q)
 and double VLAN (802.1AD) tags. Please refer to the ``struct bpf_flow_keys``
 for a set of information that's currently can be exported from the BPF context.
+
+When BPF flow dissector is attached to the root network namespace (machine-wide
+policy), users can't override it in their child network namespaces.
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 7c09d87d3269..6b4b88d1599d 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -114,19 +114,46 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
 {
 	struct bpf_prog *attached;
 	struct net *net;
+	int ret = 0;
 
 	net = current->nsproxy->net_ns;
 	mutex_lock(&flow_dissector_mutex);
+
+	if (net == &init_net) {
+		/* BPF flow dissector in the root namespace overrides
+		 * any per-net-namespace one. When attaching to root,
+		 * make sure we don't have any BPF program attached
+		 * to the non-root namespaces.
+		 */
+		struct net *ns;
+
+		for_each_net(ns) {
+			if (rcu_access_pointer(ns->flow_dissector_prog)) {
+				ret = -EEXIST;
+				goto out;
+			}
+		}
+	} else {
+		/* Make sure root flow dissector is not attached
+		 * when attaching to the non-root namespace.
+		 */
+		if (rcu_access_pointer(init_net.flow_dissector_prog)) {
+			ret = -EEXIST;
+			goto out;
+		}
+	}
+
 	attached = rcu_dereference_protected(net->flow_dissector_prog,
 					     lockdep_is_held(&flow_dissector_mutex));
 	if (attached) {
 		/* Only one BPF program can be attached at a time */
-		mutex_unlock(&flow_dissector_mutex);
-		return -EEXIST;
+		ret = -EEXIST;
+		goto out;
 	}
 	rcu_assign_pointer(net->flow_dissector_prog, prog);
+out:
 	mutex_unlock(&flow_dissector_mutex);
-	return 0;
+	return ret;
 }
 
 int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
@@ -910,7 +937,10 @@ bool __skb_flow_dissect(const struct net *net,
 	WARN_ON_ONCE(!net);
 	if (net) {
 		rcu_read_lock();
-		attached = rcu_dereference(net->flow_dissector_prog);
+		attached = rcu_dereference(init_net.flow_dissector_prog);
+
+		if (!attached)
+			attached = rcu_dereference(net->flow_dissector_prog);
 
 		if (attached) {
 			struct bpf_flow_keys flow_keys;
-- 
2.23.0.581.g78d2f28ef7-goog

