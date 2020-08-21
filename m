Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D907C24D25C
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 12:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgHUKaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 06:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728604AbgHUKaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 06:30:25 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0A9C06134C
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 03:30:17 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z18so1435727wrm.12
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 03:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2F1Qg3DDTI8jOhe00xCkyTH/u+Q7NPDPG++KYV5qHUs=;
        b=Jo7cOAUynAlWSIjOw7o21S7iQ1O1xKVWOXn+c4NmrwaXd6HfklJfBz3eEmPC3JLllW
         CSPnLd5vxwwqpRT+0iXhriDNVarpcbM05fHoOoH4sX/Z1XJgoTt8lkdL1Xla+7BBddiV
         hifXFffJ9zcUfTZ7dA9dDVbrrBM+PWXfzZdFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2F1Qg3DDTI8jOhe00xCkyTH/u+Q7NPDPG++KYV5qHUs=;
        b=mm1cfu7MwTU067q9qfVb2drbvsLe/DrQTCNQ9BgufVAO9R+dojcrYWqVR+HnhBNXFa
         aOaRNq4IBlPSpOfLJeEGb4XclbOhqikCDe7uCfWMnfC4CyKSsXOIa3NT/YYULew9xf2S
         L72QSx6c0BfDh1Tmu27IJHx2/HnjyrZoFCh2Hv4DofcVg7Z2mwmt5RKpOtas3eWAE1SL
         o+NBRENVM3RGAkVkl1uLwnVkM6f/KVW/MG1yJyLR7iCOe12H2IrUpcBOmzjoo03YbNw5
         jqakE7XmXGFlNk2alSLMTM8tLbeD8YsW80MJVM2ayTZl3qoVoZUACtVrCEqS1ASK7VER
         ZK9Q==
X-Gm-Message-State: AOAM530gRTaTiPuxpATS2w4BZDbc25dFNy+jqBsoY7a+mo6C1/A3f6DC
        09+ZObl7p9EaHepvRRdOea5OLQ==
X-Google-Smtp-Source: ABdhPJx4c2uMXC5TKsgo/eZ1RxAfT5VqETjUXVXGpGESOSDl/5Eey0Z6erYJeZFzmHEgUheiCisUXQ==
X-Received: by 2002:a5d:420b:: with SMTP id n11mr2089612wrq.11.1598005815995;
        Fri, 21 Aug 2020 03:30:15 -0700 (PDT)
Received: from antares.lan (2.2.9.a.d.9.4.f.6.1.8.9.f.9.8.5.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:589f:9816:f49d:a922])
        by smtp.gmail.com with ESMTPSA id o2sm3296885wrj.21.2020.08.21.03.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 03:30:15 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     jakub@cloudflare.com, john.fastabend@gmail.com, yhs@fb.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 5/6] bpf: sockmap: allow update from BPF
Date:   Fri, 21 Aug 2020 11:29:47 +0100
Message-Id: <20200821102948.21918-6-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821102948.21918-1-lmb@cloudflare.com>
References: <20200821102948.21918-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow calling bpf_map_update_elem on sockmap and sockhash from a BPF
context. The synchronization required for this is a bit fiddly: we
need to prevent the socket from changing its state while we add it
to the sockmap, since we rely on getting a callback via
sk_prot->unhash. However, we can't just lock_sock like in
sock_map_sk_acquire because that might sleep. So instead we disable
softirq processing and use bh_lock_sock to prevent further
modification.

Yet, this is still not enough. BPF can be called in contexts where
the current CPU might have locked a socket. If the BPF can get
a hold of such a socket, inserting it into a sockmap would lead to
a deadlock. One straight forward example are sock_ops programs that
have ctx->sk, but the same problem exists for kprobes, etc.
We deal with this by allowing sockmap updates only from known safe
contexts. Improper usage is rejected by the verifier.

I've audited the enabled contexts to make sure they can't run in
a locked context. It's possible that CGROUP_SKB and others are
safe as well, but the auditing here is much more difficult. In
any case, we can extend the safe contexts when the need arises.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 kernel/bpf/verifier.c | 38 ++++++++++++++++++++++++++++++++++++--
 net/core/sock_map.c   | 24 ++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7e15866c5184..7ba2f7bf81f4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4178,6 +4178,38 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 	return -EACCES;
 }
 
+static bool may_update_sockmap(struct bpf_verifier_env *env, int func_id)
+{
+	enum bpf_attach_type eatype = env->prog->expected_attach_type;
+	enum bpf_prog_type type = env->prog->type;
+
+	if (func_id != BPF_FUNC_map_update_elem)
+		return false;
+
+	/* It's not possible to get access to a locked struct sock in these
+	 * contexts, so updating is safe.
+	 */
+	switch (type) {
+	case BPF_PROG_TYPE_TRACING:
+		if (eatype == BPF_TRACE_ITER)
+			return true;
+		break;
+	case BPF_PROG_TYPE_SOCKET_FILTER:
+	case BPF_PROG_TYPE_SCHED_CLS:
+	case BPF_PROG_TYPE_SCHED_ACT:
+	case BPF_PROG_TYPE_XDP:
+	case BPF_PROG_TYPE_SK_REUSEPORT:
+	case BPF_PROG_TYPE_FLOW_DISSECTOR:
+	case BPF_PROG_TYPE_SK_LOOKUP:
+		return true;
+	default:
+		break;
+	}
+
+	verbose(env, "cannot update sockmap in this context\n");
+	return false;
+}
+
 static int check_map_func_compatibility(struct bpf_verifier_env *env,
 					struct bpf_map *map, int func_id)
 {
@@ -4249,7 +4281,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    func_id != BPF_FUNC_map_delete_elem &&
 		    func_id != BPF_FUNC_msg_redirect_map &&
 		    func_id != BPF_FUNC_sk_select_reuseport &&
-		    func_id != BPF_FUNC_map_lookup_elem)
+		    func_id != BPF_FUNC_map_lookup_elem &&
+		    !may_update_sockmap(env, func_id))
 			goto error;
 		break;
 	case BPF_MAP_TYPE_SOCKHASH:
@@ -4258,7 +4291,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    func_id != BPF_FUNC_map_delete_elem &&
 		    func_id != BPF_FUNC_msg_redirect_hash &&
 		    func_id != BPF_FUNC_sk_select_reuseport &&
-		    func_id != BPF_FUNC_map_lookup_elem)
+		    func_id != BPF_FUNC_map_lookup_elem &&
+		    !may_update_sockmap(env, func_id))
 			goto error;
 		break;
 	case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 48e83f93ee66..d6c6e1e312fc 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -603,6 +603,28 @@ int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value,
 	return ret;
 }
 
+static int sock_map_update_elem(struct bpf_map *map, void *key,
+				void *value, u64 flags)
+{
+	struct sock *sk = (struct sock *)value;
+	int ret;
+
+	if (!sock_map_sk_is_suitable(sk))
+		return -EOPNOTSUPP;
+
+	local_bh_disable();
+	bh_lock_sock(sk);
+	if (!sock_map_sk_state_allowed(sk))
+		ret = -EOPNOTSUPP;
+	else if (map->map_type == BPF_MAP_TYPE_SOCKMAP)
+		ret = sock_map_update_common(map, *(u32 *)key, sk, flags);
+	else
+		ret = sock_hash_update_common(map, key, sk, flags);
+	bh_unlock_sock(sk);
+	local_bh_enable();
+	return ret;
+}
+
 BPF_CALL_4(bpf_sock_map_update, struct bpf_sock_ops_kern *, sops,
 	   struct bpf_map *, map, void *, key, u64, flags)
 {
@@ -687,6 +709,7 @@ const struct bpf_map_ops sock_map_ops = {
 	.map_free		= sock_map_free,
 	.map_get_next_key	= sock_map_get_next_key,
 	.map_lookup_elem_sys_only = sock_map_lookup_sys,
+	.map_update_elem	= sock_map_update_elem,
 	.map_delete_elem	= sock_map_delete_elem,
 	.map_lookup_elem	= sock_map_lookup,
 	.map_release_uref	= sock_map_release_progs,
@@ -1180,6 +1203,7 @@ const struct bpf_map_ops sock_hash_ops = {
 	.map_alloc		= sock_hash_alloc,
 	.map_free		= sock_hash_free,
 	.map_get_next_key	= sock_hash_get_next_key,
+	.map_update_elem	= sock_map_update_elem,
 	.map_delete_elem	= sock_hash_delete_elem,
 	.map_lookup_elem	= sock_hash_lookup,
 	.map_lookup_elem_sys_only = sock_hash_lookup_sys,
-- 
2.25.1

