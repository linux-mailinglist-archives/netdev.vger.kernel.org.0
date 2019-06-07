Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E781638C50
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 16:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfFGOLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 10:11:17 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41242 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729465AbfFGOLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 10:11:16 -0400
Received: by mail-ed1-f66.google.com with SMTP id p15so3221637eds.8
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 07:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=11EhXksDgdLmWhW501RogfILPsFHkHJiIn4iFOtsvjs=;
        b=hYmpl/RJIdtBL+tsRx46QDZM7ntWEZeAb9P3BhBKmYfHgIuLyh9vvmb9zYXwPIVTat
         dKl6Ldm0GyqhJeZkADC8h+04FfW+VTO+LTu9Ns56Dr11icJr10317+FdshImeHEJaDn3
         jOxE9gYyRaoqV8HHHUAEaWJQqrScNxcW7TZMM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=11EhXksDgdLmWhW501RogfILPsFHkHJiIn4iFOtsvjs=;
        b=pvMxupynpz35V7B18E16Pae/S/NRQllt5/SxTh86/IcutrEuE5FK/QEjUyIxWPV7/3
         ++FqCtAmbzyhAxisD/rn8+30ZvuWGLhE/mjE0UdfYEGlaNzeRoEgSk05syfiMCyElo2w
         TVGH4kfB/uDppDsdT/gacrmGiXw0hZB87qBAVpLRjllM8+oVqgBgekfLpq0vmJUnLRU7
         rDNdy+Ani1o2vay8yPLwXLiCPvcoNYjJGzcMjLmQjwNxivsAR2os6ho58mPnT55Grxa4
         bl5iLEBwqQ125pJ8PgpH7FZZYmackbamRGBXvAqbhSyr+Vbhld7RPS9yc9zU1Y7P77nH
         sz+A==
X-Gm-Message-State: APjAAAUkLAO+jY6wqOpoPQ7cMZJRAmZ3C02CEXBbM4V4nfZdHOAunnnw
        hzYSUsw7o2AABSKsBSkYUpwEMw==
X-Google-Smtp-Source: APXvYqz2740/Zq7SORSpBbmq18iS12DgOvm5oFAPmO/N4K7hGYYvdn+cIQ/hX/Zj7omaxLUCzzTvrQ==
X-Received: by 2002:a17:906:4cc3:: with SMTP id q3mr22467661ejt.27.1559916674717;
        Fri, 07 Jun 2019 07:11:14 -0700 (PDT)
Received: from locke-xps13.fritz.box (dslb-002-205-069-198.002.205.pools.vodafone-ip.de. [2.205.69.198])
        by smtp.gmail.com with ESMTPSA id a40sm546116edd.1.2019.06.07.07.11.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 07:11:14 -0700 (PDT)
From:   =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>
To:     john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net
Cc:     alban@kinvolk.io, krzesimir@kinvolk.io, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v5 3/4] selftests: bpf: read netns_ino from struct bpf_sock_ops
Date:   Fri,  7 Jun 2019 16:11:05 +0200
Message-Id: <20190607141106.32148-4-iago@kinvolk.io>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607141106.32148-1-iago@kinvolk.io>
References: <20190607141106.32148-1-iago@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alban Crequy <alban@kinvolk.io>

This shows how a sockops program could be restricted to a specific
network namespace. The sockops program looks at the current netns via
(struct bpf_sock_ops)->netns_ino and checks if the value matches the
configuration in the new BPF map "sock_netns".

The test program ./test_sockmap accepts a new parameter "--netns"; the
default value is the current netns found by stat() on /proc/self/ns/net,
so the previous tests still pass:

sudo ./test_sockmap
...
Summary: 412 PASSED 0 FAILED
...
Summary: 824 PASSED 0 FAILED

I run my additional test in the following way:

NETNS=$(readlink /proc/self/ns/net | sed 's/^net:\[\(.*\)\]$/\1/')
CGR=/sys/fs/cgroup/unified/user.slice/user-1000.slice/session-5.scope/
sudo ./test_sockmap --cgroup $CGR --netns $NETNS &

cat /sys/kernel/debug/tracing/trace_pipe

echo foo | nc -l 127.0.0.1 8080 &
echo bar | nc 127.0.0.1 8080

=> the connection goes through the sockmap

When testing with a wrong $NETNS, I get the trace_pipe log:
> not binding connection on netns 4026531992

Signed-off-by: Alban Crequy <alban@kinvolk.io>

---

Changes since v1:
- tools/include/uapi/linux/bpf.h: update with netns_dev
- tools/testing/selftests/bpf/test_sockmap_kern.h: print debugs with
  both netns_dev and netns_ino

Changes since v2:
- update commitmsg to refer to netns_ino
---
 tools/testing/selftests/bpf/test_sockmap.c    | 38 +++++++++++++++++--
 .../testing/selftests/bpf/test_sockmap_kern.h | 22 +++++++++++
 2 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 3845144e2c91..5a1b9c96fca1 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2017-2018 Covalent IO, Inc. http://covalent.io
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdint.h>
 #include <sys/socket.h>
 #include <sys/ioctl.h>
 #include <sys/select.h>
@@ -21,6 +22,7 @@
 #include <sys/resource.h>
 #include <sys/types.h>
 #include <sys/sendfile.h>
+#include <sys/stat.h>
 
 #include <linux/netlink.h>
 #include <linux/socket.h>
@@ -63,8 +65,8 @@ int s1, s2, c1, c2, p1, p2;
 int test_cnt;
 int passed;
 int failed;
-int map_fd[8];
-struct bpf_map *maps[8];
+int map_fd[9];
+struct bpf_map *maps[9];
 int prog_fd[11];
 
 int txmsg_pass;
@@ -84,6 +86,7 @@ int txmsg_ingress;
 int txmsg_skb;
 int ktls;
 int peek_flag;
+uint64_t netns_opt;
 
 static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
@@ -111,6 +114,7 @@ static const struct option long_options[] = {
 	{"txmsg_skb", no_argument,		&txmsg_skb, 1 },
 	{"ktls", no_argument,			&ktls, 1 },
 	{"peek", no_argument,			&peek_flag, 1 },
+	{"netns",	required_argument,	NULL, 'n'},
 	{0, 0, NULL, 0 }
 };
 
@@ -1585,6 +1589,7 @@ char *map_names[] = {
 	"sock_bytes",
 	"sock_redir_flags",
 	"sock_skb_opts",
+	"sock_netns",
 };
 
 int prog_attach_type[] = {
@@ -1619,6 +1624,8 @@ static int populate_progs(char *bpf_file)
 	struct bpf_object *obj;
 	int i = 0;
 	long err;
+	struct stat netns_sb;
+	uint64_t netns_ino;
 
 	obj = bpf_object__open(bpf_file);
 	err = libbpf_get_error(obj);
@@ -1655,6 +1662,28 @@ static int populate_progs(char *bpf_file)
 		}
 	}
 
+	if (netns_opt == 0) {
+		err = stat("/proc/self/ns/net", &netns_sb);
+		if (err) {
+			fprintf(stderr,
+				"ERROR: cannot stat network namespace: %ld (%s)\n",
+				err, strerror(errno));
+			return -1;
+		}
+		netns_ino = netns_sb.st_ino;
+	} else {
+		netns_ino = netns_opt;
+	}
+	i = 1;
+	err = bpf_map_update_elem(map_fd[8], &netns_ino, &i, BPF_ANY);
+	if (err) {
+		fprintf(stderr,
+			"ERROR: bpf_map_update_elem (netns):  %ld (%s)\n",
+			err, strerror(errno));
+		return -1;
+	}
+
+
 	return 0;
 }
 
@@ -1738,7 +1767,7 @@ int main(int argc, char **argv)
 	if (argc < 2)
 		return test_suite(-1);
 
-	while ((opt = getopt_long(argc, argv, ":dhvc:r:i:l:t:p:q:",
+	while ((opt = getopt_long(argc, argv, ":dhvc:r:i:l:t:p:q:n:",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 's':
@@ -1805,6 +1834,9 @@ int main(int argc, char **argv)
 				return -1;
 			}
 			break;
+		case 'n':
+			netns_opt = strtoull(optarg, NULL, 10);
+			break;
 		case 0:
 			break;
 		case 'h':
diff --git a/tools/testing/selftests/bpf/test_sockmap_kern.h b/tools/testing/selftests/bpf/test_sockmap_kern.h
index e7639f66a941..317406dad6cf 100644
--- a/tools/testing/selftests/bpf/test_sockmap_kern.h
+++ b/tools/testing/selftests/bpf/test_sockmap_kern.h
@@ -91,6 +91,13 @@ struct bpf_map_def SEC("maps") sock_skb_opts = {
 	.max_entries = 1
 };
 
+struct bpf_map_def SEC("maps") sock_netns = {
+	.type = BPF_MAP_TYPE_HASH,
+	.key_size = sizeof(__u64),
+	.value_size = sizeof(int),
+	.max_entries = 16
+};
+
 SEC("sk_skb1")
 int bpf_prog1(struct __sk_buff *skb)
 {
@@ -132,9 +139,24 @@ int bpf_sockmap(struct bpf_sock_ops *skops)
 {
 	__u32 lport, rport;
 	int op, err = 0, index, key, ret;
+	int i = 0;
+	__u64 netns_dev, netns_ino;
+	int *allowed;
 
 
 	op = (int) skops->op;
+	netns_dev = skops->netns_dev;
+	netns_ino = skops->netns_ino;
+	bpf_printk("bpf_sockmap: netns_dev = %lu netns_ino = %lu\n",
+		   netns_dev, netns_ino);
+
+	// Only allow sockmap connection on the configured network namespace
+	allowed = bpf_map_lookup_elem(&sock_netns, &netns_ino);
+	if (allowed == NULL || *allowed == 0) {
+		bpf_printk("not binding connection on netns_ino %lu\n",
+			   netns_ino);
+		return 0;
+	}
 
 	switch (op) {
 	case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
-- 
2.21.0

