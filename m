Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B80F1BFC7
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 01:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfEMXTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 19:19:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:57880 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfEMXTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 19:19:22 -0400
Received: from [178.199.41.31] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hQKE4-0001ro-8Q; Tue, 14 May 2019 01:19:20 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 1/3] bpf: add map_lookup_elem_sys_only for lookups from syscall side
Date:   Tue, 14 May 2019 01:18:55 +0200
Message-Id: <505e5dfeea6ab7dd3719bb9863fc50e7595e06ed.1557789256.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <cover.1557789256.git.daniel@iogearbox.net>
References: <cover.1557789256.git.daniel@iogearbox.net>
In-Reply-To: <cover.1557789256.git.daniel@iogearbox.net>
References: <cover.1557789256.git.daniel@iogearbox.net>
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25448/Mon May 13 09:57:34 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a callback map_lookup_elem_sys_only() that map implementations
could use over map_lookup_elem() from system call side in case the
map implementation needs to handle the latter differently than from
the BPF data path. If map_lookup_elem_sys_only() is set, this will
be preferred pick for map lookups out of user space. This hook is
used in a follow-up fix for LRU map, but once development window
opens, we can convert other map types from map_lookup_elem() (here,
the one called upon BPF_MAP_LOOKUP_ELEM cmd is meant) over to use
the callback to simplify and clean up the latter.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h  | 1 +
 kernel/bpf/syscall.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 59631dd..4fb3aa2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -36,6 +36,7 @@ struct bpf_map_ops {
 	void (*map_free)(struct bpf_map *map);
 	int (*map_get_next_key)(struct bpf_map *map, void *key, void *next_key);
 	void (*map_release_uref)(struct bpf_map *map);
+	void *(*map_lookup_elem_sys_only)(struct bpf_map *map, void *key);
 
 	/* funcs callable from userspace and from eBPF programs */
 	void *(*map_lookup_elem)(struct bpf_map *map, void *key);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ad3ccf8..cb5440b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -808,7 +808,10 @@ static int map_lookup_elem(union bpf_attr *attr)
 		err = map->ops->map_peek_elem(map, value);
 	} else {
 		rcu_read_lock();
-		ptr = map->ops->map_lookup_elem(map, key);
+		if (map->ops->map_lookup_elem_sys_only)
+			ptr = map->ops->map_lookup_elem_sys_only(map, key);
+		else
+			ptr = map->ops->map_lookup_elem(map, key);
 		if (IS_ERR(ptr)) {
 			err = PTR_ERR(ptr);
 		} else if (!ptr) {
-- 
2.9.5

