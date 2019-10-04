Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0800BCBFDA
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390160AbfJDP4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:56:21 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:42511 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390156AbfJDP4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:56:21 -0400
Received: by mail-vk1-f201.google.com with SMTP id n192so2808829vkc.9
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 08:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Gh1FbYTJ0EeHzIz9gACrOhQh1LtHyPbA1EkcoQ1lWhU=;
        b=ayBjwh/d1ym6aU5jXWBrGPed5n5qXI8SxRF+oZO2Kmi0UuHl0j2Pp5a3R+i0ZEnd7Y
         Xb2Efhfgey91imfG0dEN3dmQD8As+ykKX+n2fTb5W9dx4Bw2BgyhGXc0WTWEye3rOz9J
         GItecUVM6JSkMCb46kgYTKdTNKJ9BEiuM4ZIWCz5mO/W+rKxXXFRq9u9541+Uz4F3PN8
         KxWFQLq3wUsX2C45W0pfqfBGWn4M7AWwbCO6ZMMYlKYa/so3/R0/sKt4y/y5/dGqU/74
         R60sTedkQ2ZC48XUyeVoB3v6LrtDRCHWob5vz0+zdHvLAvcp8BcadQzoxP8fGWuAxGNi
         XJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Gh1FbYTJ0EeHzIz9gACrOhQh1LtHyPbA1EkcoQ1lWhU=;
        b=SQ5jsp0Mh7cHnlVLcy0HLsDzh09SiFLN0AYBdXfd0nq5Rn6CzodYY41GSy9kcwoPcH
         dm7DzUoqBKwp2XkV8d3dEvFsK2OacLJ2X5yf1L7JLIIUt6IS5/t0xvvxSYQl7DWSKyiP
         D4pj4Ia9h/57LZpyR3ueRh5HBLuU+sc/VtOKIHUe5PdMmcXRQyPZtkmFYc8/FyA6URYH
         XL24jt0RW3i6KDoY8k1a/Iyh0MYxyN80R+TqWOmt5QL+AOWdrGUQEEpe7E6gNTha6+8U
         RS+SsTJ55MI9Xh9pFamLg9OTQodvDErUo9/a5TcdgUl3sNL8/Jr8v2u02hWA08hw66lT
         4tpA==
X-Gm-Message-State: APjAAAWODyjoCSeD5IKKu+thoaRBbj8Pm7lPQgG1J6XYWMFWr7xIQ0Sp
        Uio8kwq0Py/FxQTD4kocwieqIwy5h/2EObz887hEKVr+XjipECiYS5hfiboDgWpdpjdui0O5GCX
        Pw4/mFI506JaZS5vCMOsjbvyokLSbw1NEWFe5J8zOtI7/LL9sdHwxFA==
X-Google-Smtp-Source: APXvYqwxrsqT+uaSNcPmaraYNWvGfCpocgxUJQl48CbEiZ5igF00qe+GqiJqMOp3ddioFMzmLdRWJ40=
X-Received: by 2002:ab0:5641:: with SMTP id z1mr8324423uaa.68.1570204579705;
 Fri, 04 Oct 2019 08:56:19 -0700 (PDT)
Date:   Fri,  4 Oct 2019 08:56:14 -0700
In-Reply-To: <20191004155615.95469-1-sdf@google.com>
Message-Id: <20191004155615.95469-2-sdf@google.com>
Mime-Version: 1.0
References: <20191004155615.95469-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH bpf-next v2 1/2] bpf/flow_dissector: add mode to enforce
 global BPF flow dissector
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
new ones (-EEXIST).

Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/bpf/prog_flow_dissector.rst |  3 ++
 net/core/flow_dissector.c                 | 42 ++++++++++++++++++++---
 2 files changed, 41 insertions(+), 4 deletions(-)

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
index 7c09d87d3269..9821e730fc70 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -114,19 +114,50 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
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
+			if (net == &init_net)
+				continue;
+
+			if (rcu_access_pointer(ns->flow_dissector_prog)) {
+				ret = -EEXIST;
+				goto out;
+			}
+		}
+	} else {
+		/* Make sure root flow dissector is not attached
+		 * when attaching to the non-root namespace.
+		 */
+
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
@@ -910,7 +941,10 @@ bool __skb_flow_dissect(const struct net *net,
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

