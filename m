Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51473C89B3
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 15:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfJBNae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 09:30:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbfJBNad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 09:30:33 -0400
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EA40281127
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 13:30:32 +0000 (UTC)
Received: by mail-lj1-f197.google.com with SMTP id b90so4859758ljf.11
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 06:30:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1Wsj/lXR0FWl5TJU2feRxQ1sy5OmHjYGRJ/DyODED4I=;
        b=EF8MWAF5vpEOPYtqxDgGLFMnklmZL/HawVUPY5aAumgb/AzLIfsCD2DqoOHI25tro4
         OBNYVD+x/LVQMXldcalSySrAoORehv+4CyeHaEc56fDI75AGySMPoYhhA64IrZkS4s8D
         vAA1y4oe5t/+encT2UNbrN3LL2dhsQubVAv0aNjUCGRCym3J7ugPbmZqj63eJWCFkhTE
         ZCH9uESiYIjS4Fc7Q2nPtLSfdYA7rzS4K3SIIb0ZKlPWntPwUsMeryH/vB2RgJP8JO9H
         uhHsVXwPoUpadBFve4t/h6R53RzXpx2M4HTqui9DU++XAA39WepLTont/U052tbI2wiQ
         NeHQ==
X-Gm-Message-State: APjAAAWOoVdsAFUl2PX6xxRoF7ccN+n313JVb8DJPM3QcJXUFXBmUFnZ
        41NDsERLJDfnfu4XSR150InXf0OMDNZsE6TYNXE39NQzz5yAcxk62W2B6NwCthcP8ZDen8JlJSt
        uCMtDB4c8BG2nZSYZ
X-Received: by 2002:a2e:b009:: with SMTP id y9mr2473334ljk.185.1570023031346;
        Wed, 02 Oct 2019 06:30:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzxpvV1HU+8j/DE1KIvlQwjx6aFy5Y3VD//w5fRCydHkdEsxNoSEY/t/ptTvvccOhDhuMZ+sQ==
X-Received: by 2002:a2e:b009:: with SMTP id y9mr2473304ljk.185.1570023031046;
        Wed, 02 Oct 2019 06:30:31 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id l3sm4668906lfc.31.2019.10.02.06.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 06:30:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CE0CD18063D; Wed,  2 Oct 2019 15:30:26 +0200 (CEST)
Subject: [PATCH bpf-next 2/9] xdp: Add new xdp_chain_map type for specifying
 XDP call sequences
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 02 Oct 2019 15:30:26 +0200
Message-ID: <157002302672.1302756.10579143571088111093.stgit@alrua-x1>
In-Reply-To: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

To specify call sequences for XDP programs, we need to do a lookup after an
XDP program runs to get the next program to run. Introduce a new map type
for this use which allows specifying one action per return code of the
original program.

The new map type is derived from the hashmap type, and uses the program ID
as the lookup key. The value is a struct of program pointers specifying the
next program in the call sequence for each return code of the previous
program. A special wildcard pointer can also be specified which will match
on all program return codes if no more specific entry is included in the
structure (i.e., LPM-style matching).

Userspace fills in a struct of program fds and passes that as the value,
and the map converts the fds to pointers before inserting the structure
into the map. Using the map type directly from an eBPF program is
disallowed; instead, a subsequent commit will add lookup code to the XDP
dispatch function, and the ability for userspace to set the current chain
call map when attaching an XDP program to an interface.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h       |    9 +++
 include/linux/bpf_types.h |    1 
 include/uapi/linux/bpf.h  |   12 ++++
 kernel/bpf/hashtab.c      |  153 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c      |   11 +++
 5 files changed, 186 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index be3e9e9109c7..e72702c4cb12 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -689,6 +689,15 @@ int bpf_fd_htab_map_update_elem(struct bpf_map *map, struct file *map_file,
 				void *key, void *value, u64 map_flags);
 int bpf_fd_htab_map_lookup_elem(struct bpf_map *map, void *key, u32 *value);
 
+int bpf_xdp_chain_map_update_elem(struct bpf_map *map, void *key, void *value,
+				  u64 map_flags);
+int bpf_xdp_chain_map_lookup_elem(struct bpf_map *map, void *key, void *value);
+struct bpf_prog *bpf_xdp_chain_map_get_prog(struct bpf_map *map,
+					    u32 prev_id,
+					    enum xdp_action action);
+
+
+
 int bpf_get_file_flag(int flags);
 int bpf_check_uarg_tail_zero(void __user *uaddr, size_t expected_size,
 			     size_t actual_size);
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 36a9c2325176..95650ed86a12 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -63,6 +63,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_HASH_OF_MAPS, htab_of_maps_map_ops)
 #ifdef CONFIG_NET
 BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_XDP_CHAIN, xdp_chain_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops)
 #if defined(CONFIG_BPF_STREAM_PARSER)
 BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKMAP, sock_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 77c6be96d676..8b336fb68880 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -136,6 +136,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
 	BPF_MAP_TYPE_DEVMAP_HASH,
+	BPF_MAP_TYPE_XDP_CHAIN,
 };
 
 /* Note that tracing related programs such as
@@ -3153,6 +3154,17 @@ enum xdp_action {
 	XDP_PASS,
 	XDP_TX,
 	XDP_REDIRECT,
+
+	__XDP_ACT_MAX /* leave at end */
+};
+#define XDP_ACT_MAX	(__XDP_ACT_MAX - 1)
+
+struct xdp_chain_acts {
+	__u32 wildcard_act;
+	__u32 drop_act;
+	__u32 pass_act;
+	__u32 tx_act;
+	__u32 redirect_act;
 };
 
 /* user accessible metadata for XDP packet hook
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 113e1286e184..ab855095c830 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1510,3 +1510,156 @@ const struct bpf_map_ops htab_of_maps_map_ops = {
 	.map_gen_lookup = htab_of_map_gen_lookup,
 	.map_check_btf = map_check_no_btf,
 };
+
+struct xdp_chain_table {
+	struct bpf_prog *wildcard_act;
+	struct bpf_prog *act[XDP_ACT_MAX];
+};
+
+static int xdp_chain_map_alloc_check(union bpf_attr *attr)
+{
+	BUILD_BUG_ON(sizeof(struct xdp_chain_table) / sizeof(void *) !=
+		     sizeof(struct xdp_chain_acts) / sizeof(u32));
+
+	if (attr->key_size != sizeof(u32) ||
+	    attr->value_size != sizeof(struct xdp_chain_acts))
+		return -EINVAL;
+
+	attr->value_size = sizeof(struct xdp_chain_table);
+	return htab_map_alloc_check(attr);
+}
+
+struct bpf_prog *bpf_xdp_chain_map_get_prog(struct bpf_map *map,
+					    u32 prev_id,
+					    enum xdp_action action)
+{
+	struct xdp_chain_table *tab;
+	void *ptr;
+
+	ptr = htab_map_lookup_elem(map, &prev_id);
+
+	if (!ptr)
+		return NULL;
+
+	tab = READ_ONCE(ptr);
+	return tab->act[action - 1] ?: tab->wildcard_act;
+}
+EXPORT_SYMBOL_GPL(bpf_xdp_chain_map_get_prog);
+
+/* only called from syscall */
+int bpf_xdp_chain_map_lookup_elem(struct bpf_map *map, void *key, void *value)
+{
+	struct xdp_chain_acts *act = value;
+	struct xdp_chain_table *tab;
+	void *ptr;
+	u32 *cur;
+	int i;
+
+	ptr = htab_map_lookup_elem(map, key);
+	if (!ptr)
+		return -ENOENT;
+
+	tab = READ_ONCE(ptr);
+
+	if (tab->wildcard_act)
+		act->wildcard_act = tab->wildcard_act->aux->id;
+
+	cur = &act->drop_act;
+	for (i = 0; i < XDP_ACT_MAX; i++, cur++)
+		if(tab->act[i])
+			*cur = tab->act[i]->aux->id;
+
+	return 0;
+}
+
+static void *xdp_chain_map_get_ptr(int fd)
+{
+	struct bpf_prog *prog = bpf_prog_get(fd);
+
+	if (IS_ERR(prog))
+		return prog;
+
+	if (prog->type != BPF_PROG_TYPE_XDP ||
+	    bpf_prog_is_dev_bound(prog->aux)) {
+		bpf_prog_put(prog);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return prog;
+}
+
+static void xdp_chain_map_put_ptrs(void *value)
+{
+	struct xdp_chain_table *tab = value;
+	int i;
+
+	for (i = 0; i < XDP_ACT_MAX; i++)
+		if (tab->act[i])
+			bpf_prog_put(tab->act[i]);
+
+	if (tab->wildcard_act)
+		bpf_prog_put(tab->wildcard_act);
+}
+
+/* only called from syscall */
+int bpf_xdp_chain_map_update_elem(struct bpf_map *map, void *key, void *value,
+				  u64 map_flags)
+{
+	struct xdp_chain_acts *act = value;
+	struct xdp_chain_table tab = {};
+	u32 lookup_key = *((u32*)key);
+	u32 *cur = &act->drop_act;
+	bool found_val = false;
+	int ret, i;
+	void *ptr;
+
+	if (!lookup_key)
+		return -EINVAL;
+
+	if (act->wildcard_act) {
+		ptr = xdp_chain_map_get_ptr(act->wildcard_act);
+		if (IS_ERR(ptr))
+			return PTR_ERR(ptr);
+		tab.wildcard_act = ptr;
+		found_val = true;
+	}
+
+	for (i = 0; i < XDP_ACT_MAX; i++, cur++) {
+		if (*cur) {
+			ptr = xdp_chain_map_get_ptr(*cur);
+			if (IS_ERR(ptr)) {
+				ret = PTR_ERR(ptr);
+				goto out_err;
+			}
+			tab.act[i] = ptr;
+			found_val = true;
+		}
+	}
+
+	if (!found_val) {
+		ret = -EINVAL;
+		goto out_err;
+	}
+
+	ret = htab_map_update_elem(map, key, &tab, map_flags);
+	if (ret)
+		goto out_err;
+
+	return ret;
+
+out_err:
+	xdp_chain_map_put_ptrs(&tab);
+
+	return ret;
+}
+
+
+const struct bpf_map_ops xdp_chain_map_ops = {
+	.map_alloc_check = xdp_chain_map_alloc_check,
+	.map_alloc = htab_map_alloc,
+	.map_free = fd_htab_map_free,
+	.map_get_next_key = htab_map_get_next_key,
+	.map_delete_elem = htab_map_delete_elem,
+	.map_fd_put_value = xdp_chain_map_put_ptrs,
+	.map_check_btf = map_check_no_btf,
+};
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 82eabd4e38ad..c9afaace048d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -778,6 +778,8 @@ static int map_lookup_elem(union bpf_attr *attr)
 		value_size = round_up(map->value_size, 8) * num_possible_cpus();
 	else if (IS_FD_MAP(map))
 		value_size = sizeof(u32);
+	else if (map->map_type == BPF_MAP_TYPE_XDP_CHAIN)
+		value_size = sizeof(struct xdp_chain_acts);
 	else
 		value_size = map->value_size;
 
@@ -806,6 +808,8 @@ static int map_lookup_elem(union bpf_attr *attr)
 		err = bpf_fd_array_map_lookup_elem(map, key, value);
 	} else if (IS_FD_HASH(map)) {
 		err = bpf_fd_htab_map_lookup_elem(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_XDP_CHAIN) {
+		err = bpf_xdp_chain_map_lookup_elem(map, key, value);
 	} else if (map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
 		err = bpf_fd_reuseport_array_lookup_elem(map, key, value);
 	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
@@ -908,6 +912,8 @@ static int map_update_elem(union bpf_attr *attr)
 	    map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY ||
 	    map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
 		value_size = round_up(map->value_size, 8) * num_possible_cpus();
+	else if (map->map_type == BPF_MAP_TYPE_XDP_CHAIN)
+		value_size = sizeof(struct xdp_chain_acts);
 	else
 		value_size = map->value_size;
 
@@ -954,6 +960,11 @@ static int map_update_elem(union bpf_attr *attr)
 		err = bpf_fd_htab_map_update_elem(map, f.file, key, value,
 						  attr->flags);
 		rcu_read_unlock();
+	} else if (map->map_type == BPF_MAP_TYPE_XDP_CHAIN) {
+		rcu_read_lock();
+		err = bpf_xdp_chain_map_update_elem(map, key, value,
+						    attr->flags);
+		rcu_read_unlock();
 	} else if (map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
 		/* rcu_read_lock() is not needed */
 		err = bpf_fd_reuseport_array_update_elem(map, key, value,

