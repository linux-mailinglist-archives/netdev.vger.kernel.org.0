Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD28EC9003
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbfJBReE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:34:04 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:40262 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727751AbfJBReD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:34:03 -0400
Received: by mail-pl1-f202.google.com with SMTP id f10so8855plr.7
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 10:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/VBWQDNKn3TcIxOb7t7vmD6iPumOa4yGB+aJzx52tYg=;
        b=DEk3iio1O9Gkhdd1Bper2FkWRUZzlO8B0LsCrwcIq8bYfHbGhyvnjf5yXAT7B8D4gL
         HNaGBOzgculbN+413WEAO1tmP96PUi2U4ZT4L5eX9LxfWyMMMUd+rHLqvU/C1Q5FwWGZ
         Ob/bbYycfhO1OwkeLul/bmuq+9roomEwUh9OxW0f2xEAUPRTWoyTH4ZD7rIYpxqY4vFC
         oFsNwFYtPtB3rG7UDUd0lwV3d37NRTH0dEVqpiH9onFHNaaWFMWxN6lzMsnTCA+j129N
         gdO/BhRpUrn4Esgtq//3GvkuCa1xj5AAD8qStgbiZZuwpQQbySlft5eFqCXHWjDC82Gw
         aZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/VBWQDNKn3TcIxOb7t7vmD6iPumOa4yGB+aJzx52tYg=;
        b=LFc5hQevR7bH0Zh6W+qrKbXMSAvKKDv5IIin3D49iXrHDi0Gp0QULnUxfdMULX2zGG
         wzq5u1Jon30JNFRhG8jnuRNU3HQWKOa7jhH/S3qff1jZSP7ry3aFG8nP65skjSAFzA1l
         EnH3KjK5keAU9QqW2II6q2Y1rhfH0+IwgxalRjpoR2zQe5tf81Sj+IytkLCChrXzn9hO
         Q6jmsgMhrj13/8SssLzRyGJ2KZpTvMbluknSalSObamAufHoKlq7V2de/1forczgGhwT
         SrFsdd1diEW+ASYn/SOv6iQC6XYie/1Tc03t1Fd9Qo/OqXJI5/vnNNNAIPPyd/BrRZwi
         g2Qg==
X-Gm-Message-State: APjAAAWtEP+Wtth7Zk4QQOf9+KAQXiTDKQlqTjySFLMAk4L6suryLxtu
        /1o/2sFDZboX0KvbTx9RfpaZTtZICeg4agc5ROdiP51rkRfIsYQWDV50AYlp6ziHEhr/ywI4kgF
        AX9vQcwhDsFtctu3rtFs6q2I3umXaBKvkgKVfqTL+23jy5+ERnsjrcg==
X-Google-Smtp-Source: APXvYqyglF8UNEdYS45EjThGZAdjDsmAiJEwYvzOjxuOTeUF0fFP+fCSQ5Sg1OkkXelUfa5xabRuhmU=
X-Received: by 2002:a63:40c7:: with SMTP id n190mr4900842pga.446.1570037642776;
 Wed, 02 Oct 2019 10:34:02 -0700 (PDT)
Date:   Wed,  2 Oct 2019 10:33:56 -0700
In-Reply-To: <20191002173357.253643-1-sdf@google.com>
Message-Id: <20191002173357.253643-2-sdf@google.com>
Mime-Version: 1.0
References: <20191002173357.253643-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH bpf-next 1/2] bpf/flow_dissector: add mode to enforce global
 BPF flow dissector
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Always use init_net flow dissector BPF program if it's attached and fall
back to the per-net namespace one. Also, deny installing new programs if
there is already one attached to the root namespace.
Users can still detach their BPF programs, but can't attach any
new ones (-EPERM).

Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/bpf/prog_flow_dissector.rst |  3 +++
 net/core/flow_dissector.c                 | 11 ++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

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
index 7c09d87d3269..494e2016fe84 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -115,6 +115,11 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
 	struct bpf_prog *attached;
 	struct net *net;
 
+	if (rcu_access_pointer(init_net.flow_dissector_prog)) {
+		/* Can't override root flow dissector program */
+		return -EPERM;
+	}
+
 	net = current->nsproxy->net_ns;
 	mutex_lock(&flow_dissector_mutex);
 	attached = rcu_dereference_protected(net->flow_dissector_prog,
@@ -910,7 +915,11 @@ bool __skb_flow_dissect(const struct net *net,
 	WARN_ON_ONCE(!net);
 	if (net) {
 		rcu_read_lock();
-		attached = rcu_dereference(net->flow_dissector_prog);
+		attached =
+			rcu_dereference(init_net.flow_dissector_prog);
+
+		if (!attached)
+			attached = rcu_dereference(net->flow_dissector_prog);
 
 		if (attached) {
 			struct bpf_flow_keys flow_keys;
-- 
2.23.0.444.g18eeb5a265-goog

