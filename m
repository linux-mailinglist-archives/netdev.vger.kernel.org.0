Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714B324C02C
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgHTOJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731191AbgHTN6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 09:58:35 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1643DC06134C
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:58:13 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x5so1698140wmi.2
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=URx+7eRaFu2BCzYkCrhfeFAqxHIKs6nde8gNQqbdE3g=;
        b=DzZTIKAz7QyK0hyrUegGuG1ur6KTZIK0eK8b7NAiPdibIYgqMtRp4f7fsImPWT4+PH
         xikjzZ4BhwgQd/tqv0L/npJwJk1086HUwoVr7lbbX2RNoNN9mK0/3W8hROmoi+AW0FvL
         PGU8wVfOPEvlaFtLdUBY7HIMj6lgyUfWDuO88=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=URx+7eRaFu2BCzYkCrhfeFAqxHIKs6nde8gNQqbdE3g=;
        b=awAVtCZZI+bSGgiydULAQAShTSZ2kr08gGWrgUZLH7hybQbAl+nWRGq5HCB83fxHCz
         FVu9SUICn5+x894MGCmufqlD0nPD9NotsHtMv34VFzCC2W07ZdWqtcvhVkDhOPl8kLU8
         7gDDdxBHJaGaNsZLvH47UNTgKUE6Bqsceyo2QkqyPIORiOmd6IegGoREgimVWbRO76lz
         RPcqwwB6sHdpTByzbv+pBpwn6WIRCAWF5MTdbiUME+lSCQ8iL2IHiYGIEFdIT8EUfWk1
         WYK14gcpcfXjFatypEL1EUfQ9mYw68H8RPdXSEvZtY72/WTro3UIQI7mtXPHt3DKZN+M
         +XNQ==
X-Gm-Message-State: AOAM533yYvZy+XaKK/GqRmf1nvQelHsqxJe6gIZ2rzYFTpRy6v7cHl30
        TGSgS/FL6YY9ez9495h4KP+6Iw==
X-Google-Smtp-Source: ABdhPJxZjlm1D4bifPvAhz7ZW7VcmhYirLJ2AsrUHTM1eLCKXKD7eiZ3k7ONZW3WuIpWF97Ch70WOQ==
X-Received: by 2002:a1c:98c1:: with SMTP id a184mr3765618wme.116.1597931891705;
        Thu, 20 Aug 2020 06:58:11 -0700 (PDT)
Received: from antares.lan (d.0.f.e.b.c.7.2.d.c.3.8.4.8.d.9.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:9d84:83cd:27cb:ef0d])
        by smtp.gmail.com with ESMTPSA id l81sm4494215wmf.4.2020.08.20.06.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 06:58:11 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     jakub@cloudflare.com, john.fastabend@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 5/6] bpf: sockmap: allow update from BPF
Date:   Thu, 20 Aug 2020 14:57:28 +0100
Message-Id: <20200820135729.135783-6-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820135729.135783-1-lmb@cloudflare.com>
References: <20200820135729.135783-1-lmb@cloudflare.com>
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

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 kernel/bpf/verifier.c | 41 +++++++++++++++++++++++++++++++++++++++--
 net/core/sock_map.c   | 24 ++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 24feec515d3e..7779057f57dc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4180,6 +4180,41 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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
+	case BPF_PROG_TYPE_CGROUP_SKB:
+	case BPF_PROG_TYPE_SK_SKB:
+	case BPF_PROG_TYPE_SK_MSG:
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
@@ -4251,7 +4286,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    func_id != BPF_FUNC_map_delete_elem &&
 		    func_id != BPF_FUNC_msg_redirect_map &&
 		    func_id != BPF_FUNC_sk_select_reuseport &&
-		    func_id != BPF_FUNC_map_lookup_elem)
+		    func_id != BPF_FUNC_map_lookup_elem &&
+		    !may_update_sockmap(env, func_id))
 			goto error;
 		break;
 	case BPF_MAP_TYPE_SOCKHASH:
@@ -4260,7 +4296,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
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

