Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996671BE5ED
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgD2SMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727095AbgD2SL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:11:59 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D920C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:11:58 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id k12so3084477wmj.3
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/OqI3tfiQHbq5ZjJVT/G3HCfAtVVdEqARPip6umRLpQ=;
        b=nrquNApse30RsMBl/6kdj9GHAxCjnF9VkUFDVTTzlurh90w2KArK2+PnN0/J47cBue
         Z16t6Oee9nYNtfzuMeSjgd33NDc6w4JocOR9UM6De65BsbJLqH3Wqhwu/HhRLeW6ZGh0
         76T3jgwPwqyVUfIIa8DZKREYGkH7YiXgk0/LI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/OqI3tfiQHbq5ZjJVT/G3HCfAtVVdEqARPip6umRLpQ=;
        b=OLu76pLMqv1DcPDsmlx2fvPiT0+0Pqo1MjyJnWi3FV47SEy1Yv6vFC1MQknzrRKQR1
         XABlsID6Dvyq6xJP1ar1F01MMwLjKJKUe7ZDzOi9OSlXwgZu/acoCffG97uPf+ZVwitV
         kljMg+lsuidqe4vyrcJnBKhCtXj9PPckw/ad6IcL//AGFW06QdU9GFqSHK/Dz0pdoVFV
         OTQPCgEYt8sxv+67RDZnVqY1uws5FFzD1+f4H9Kg2/0eYcjTBgDkBxrVWyP2fgkpEqEe
         mihDqHhJHAd91toqaVq5GMQf2mOkkYzDN1YHMMKcusvCRoTI2TGfmJ8MSGjIaa+WBX+k
         27cg==
X-Gm-Message-State: AGi0PuZVffx9KBr2TuF90n18v1vo+ezWAWo3Ph1/vhBXERVF99umKJKC
        WE0KKyexcfAf4srN4Q+nCGrDxA==
X-Google-Smtp-Source: APiQypKPbDoPH5s+NHBR0tL3x1CD+ho96UktXLb66KEse6MrjitEkba6vZgDk0fRhxP6DEt7d3c9Qw==
X-Received: by 2002:a7b:c759:: with SMTP id w25mr5029404wmk.68.1588183917293;
        Wed, 29 Apr 2020 11:11:57 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id j10sm9161935wmi.18.2020.04.29.11.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 11:11:56 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joe Stringer <joe@wand.net.nz>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next 1/3] bpf: Allow bpf_map_lookup_elem for SOCKMAP and SOCKHASH
Date:   Wed, 29 Apr 2020 20:11:52 +0200
Message-Id: <20200429181154.479310-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200429181154.479310-1-jakub@cloudflare.com>
References: <20200429181154.479310-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

White-list map lookup for SOCKMAP/SOCKHASH from BPF. Lookup returns a
pointer to a full socket and acquires a reference if necessary.

To support it we need to extend the verifier to know that:

 (1) register storing the lookup result holds a pointer to socket, if
     lookup was done on SOCKMAP/SOCKHASH, and that

 (2) map lookup on SOCKMAP/SOCKHASH is a reference acquiring operation,
     which needs a corresponding reference release with bpf_sk_release.

On sock_map side, lookup handlers exposed via bpf_map_ops now bump
sk_refcnt if socket is reference counted. In turn, bpf_sk_select_reuseport,
the only in-kernel user of SOCKMAP/SOCKHASH ops->map_lookup_elem, was
updated to release the reference.

Sockets fetched from a map can be used in the same way as ones returned by
BPF socket lookup helpers, such as bpf_sk_lookup_tcp. In particular, they
can be used with bpf_sk_assign to direct packets toward a socket on TC
ingress path.

Suggested-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 kernel/bpf/verifier.c | 45 +++++++++++++++++++++++++++++++++----------
 net/core/filter.c     |  4 ++++
 net/core/sock_map.c   | 18 +++++++++++++++--
 3 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2b337e32aa94..70ad009577f8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -429,11 +429,30 @@ static bool is_release_function(enum bpf_func_id func_id)
 	return func_id == BPF_FUNC_sk_release;
 }
 
-static bool is_acquire_function(enum bpf_func_id func_id)
+static bool may_be_acquire_function(enum bpf_func_id func_id)
 {
 	return func_id == BPF_FUNC_sk_lookup_tcp ||
 		func_id == BPF_FUNC_sk_lookup_udp ||
-		func_id == BPF_FUNC_skc_lookup_tcp;
+		func_id == BPF_FUNC_skc_lookup_tcp ||
+		func_id == BPF_FUNC_map_lookup_elem;
+}
+
+static bool is_acquire_function(enum bpf_func_id func_id,
+				const struct bpf_map *map)
+{
+	enum bpf_map_type map_type = map ? map->map_type : BPF_MAP_TYPE_UNSPEC;
+
+	if (func_id == BPF_FUNC_sk_lookup_tcp ||
+	    func_id == BPF_FUNC_sk_lookup_udp ||
+	    func_id == BPF_FUNC_skc_lookup_tcp)
+		return true;
+
+	if (func_id == BPF_FUNC_map_lookup_elem &&
+	    (map_type == BPF_MAP_TYPE_SOCKMAP ||
+	     map_type == BPF_MAP_TYPE_SOCKHASH))
+		return true;
+
+	return false;
 }
 
 static bool is_ptr_cast_function(enum bpf_func_id func_id)
@@ -3934,7 +3953,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    func_id != BPF_FUNC_sock_map_update &&
 		    func_id != BPF_FUNC_map_delete_elem &&
 		    func_id != BPF_FUNC_msg_redirect_map &&
-		    func_id != BPF_FUNC_sk_select_reuseport)
+		    func_id != BPF_FUNC_sk_select_reuseport &&
+		    func_id != BPF_FUNC_map_lookup_elem)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_SOCKHASH:
@@ -3942,7 +3962,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    func_id != BPF_FUNC_sock_hash_update &&
 		    func_id != BPF_FUNC_map_delete_elem &&
 		    func_id != BPF_FUNC_msg_redirect_hash &&
-		    func_id != BPF_FUNC_sk_select_reuseport)
+		    func_id != BPF_FUNC_sk_select_reuseport &&
+		    func_id != BPF_FUNC_map_lookup_elem)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
@@ -4112,7 +4133,7 @@ static bool check_refcount_ok(const struct bpf_func_proto *fn, int func_id)
 	/* A reference acquiring function cannot acquire
 	 * another refcounted ptr.
 	 */
-	if (is_acquire_function(func_id) && count)
+	if (may_be_acquire_function(func_id) && count)
 		return false;
 
 	/* We only support one arg being unreferenced at the moment,
@@ -4623,7 +4644,7 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 	if (is_ptr_cast_function(func_id)) {
 		/* For release_reference() */
 		regs[BPF_REG_0].ref_obj_id = meta.ref_obj_id;
-	} else if (is_acquire_function(func_id)) {
+	} else if (is_acquire_function(func_id, meta.map_ptr)) {
 		int id = acquire_reference_state(env, insn_idx);
 
 		if (id < 0)
@@ -6532,12 +6553,16 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 		if (is_null) {
 			reg->type = SCALAR_VALUE;
 		} else if (reg->type == PTR_TO_MAP_VALUE_OR_NULL) {
-			if (reg->map_ptr->inner_map_meta) {
+			const struct bpf_map *map = reg->map_ptr;
+
+			if (map->inner_map_meta) {
 				reg->type = CONST_PTR_TO_MAP;
-				reg->map_ptr = reg->map_ptr->inner_map_meta;
-			} else if (reg->map_ptr->map_type ==
-				   BPF_MAP_TYPE_XSKMAP) {
+				reg->map_ptr = map->inner_map_meta;
+			} else if (map->map_type == BPF_MAP_TYPE_XSKMAP) {
 				reg->type = PTR_TO_XDP_SOCK;
+			} else if (map->map_type == BPF_MAP_TYPE_SOCKMAP ||
+				   map->map_type == BPF_MAP_TYPE_SOCKHASH) {
+				reg->type = PTR_TO_SOCKET;
 			} else {
 				reg->type = PTR_TO_MAP_VALUE;
 			}
diff --git a/net/core/filter.c b/net/core/filter.c
index da3b7a72c37c..70b32723e6be 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8712,6 +8712,10 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 
 	reuse = rcu_dereference(selected_sk->sk_reuseport_cb);
 	if (!reuse) {
+		/* Lookup in sock_map can return TCP ESTABLISHED sockets. */
+		if (sk_is_refcounted(selected_sk))
+			sock_put(selected_sk);
+
 		/* reuseport_array has only sk with non NULL sk_reuseport_cb.
 		 * The only (!reuse) case here is - the sk has already been
 		 * unhashed (e.g. by close()), so treat it as -ENOENT.
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index b08dfae10f88..00a26cf2cfe9 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -343,7 +343,14 @@ static struct sock *__sock_map_lookup_elem(struct bpf_map *map, u32 key)
 
 static void *sock_map_lookup(struct bpf_map *map, void *key)
 {
-	return __sock_map_lookup_elem(map, *(u32 *)key);
+	struct sock *sk;
+
+	sk = __sock_map_lookup_elem(map, *(u32 *)key);
+	if (!sk || !sk_fullsock(sk))
+		return NULL;
+	if (sk_is_refcounted(sk) && !refcount_inc_not_zero(&sk->sk_refcnt))
+		return NULL;
+	return sk;
 }
 
 static void *sock_map_lookup_sys(struct bpf_map *map, void *key)
@@ -1051,7 +1058,14 @@ static void *sock_hash_lookup_sys(struct bpf_map *map, void *key)
 
 static void *sock_hash_lookup(struct bpf_map *map, void *key)
 {
-	return __sock_hash_lookup_elem(map, key);
+	struct sock *sk;
+
+	sk = __sock_hash_lookup_elem(map, key);
+	if (!sk || !sk_fullsock(sk))
+		return NULL;
+	if (sk_is_refcounted(sk) && !refcount_inc_not_zero(&sk->sk_refcnt))
+		return NULL;
+	return sk;
 }
 
 static void sock_hash_release_progs(struct bpf_map *map)
-- 
2.25.3

