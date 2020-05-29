Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A225F1E82B9
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgE2QAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:00:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51810 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728003AbgE2P74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:59:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590767995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7gAuqJvINa/LZDs+yAfBCsvSnvSCdDrwY41LQ0Y4m8c=;
        b=cyVLRx7QATbXIKrnB1kDYaIOxsE+T3L4lxfgBcf1A1zKLsETR6kX27a1zBgjTR2s3ONYU+
        GzJjq8Jk2UeJ3GRxzUUdJXjFP3MzzbnHxsytBJtxRj24ThZUyEFyQsxSVqWqXrdXhE5h6h
        tkJV+UG3wWFiCmvwTvxGR9kt4SYtFbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-y6Vnw6N4NsqrRfqpPAQsMg-1; Fri, 29 May 2020 11:59:53 -0400
X-MC-Unique: y6Vnw6N4NsqrRfqpPAQsMg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3284518A823C;
        Fri, 29 May 2020 15:59:52 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDA4262932;
        Fri, 29 May 2020 15:59:51 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id C3408300003E9;
        Fri, 29 May 2020 17:59:50 +0200 (CEST)
Subject: [PATCH bpf-next RFC 3/3] samples/bpf: change xdp_fwd to use new BTF
 config interface
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 29 May 2020 17:59:50 +0200
Message-ID: <159076799073.1387573.15478442988219832285.stgit@firesoul>
In-Reply-To: <159076794319.1387573.8722376887638960093.stgit@firesoul>
References: <159076794319.1387573.8722376887638960093.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enable BTF for samples/bpf/xdp_fwd program, and demonstrates
how the BPF-developer can defined their own version of bpf_devmap_val.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 samples/bpf/xdp_fwd.h      |   24 ++++++++++++++++++++++++
 samples/bpf/xdp_fwd_kern.c |    5 +++--
 samples/bpf/xdp_fwd_user.c |    9 ++++++++-
 3 files changed, 35 insertions(+), 3 deletions(-)
 create mode 100644 samples/bpf/xdp_fwd.h

diff --git a/samples/bpf/xdp_fwd.h b/samples/bpf/xdp_fwd.h
new file mode 100644
index 000000000000..8abb2a417117
--- /dev/null
+++ b/samples/bpf/xdp_fwd.h
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef _SAMPLES_BPF_XDP_FWD_H
+#define _SAMPLES_BPF_XDP_FWD_H
+
+#define ENABLE_BPF_PROG 1
+
+/* Notice XDP prog can redefine this struct, which through BTF affect
+ * what kernel-side config options are available.
+ */
+struct bpf_devmap_val {
+	__u32 ifindex;   /* device index - mandatory */
+#ifdef ENABLE_BPF_PROG
+	union {
+		int   fd;  /* prog fd on map write */
+		__u32 id;  /* prog id on map read */
+	} bpf_prog;
+#endif
+	struct {
+		unsigned char data2[2];
+		__u16 vlan_hdr;
+	} storage;
+};
+
+#endif /* _SAMPLES_BPF_XDP_FWD_H */
diff --git a/samples/bpf/xdp_fwd_kern.c b/samples/bpf/xdp_fwd_kern.c
index 54c099cbd639..bb1ee44dcd60 100644
--- a/samples/bpf/xdp_fwd_kern.c
+++ b/samples/bpf/xdp_fwd_kern.c
@@ -20,13 +20,14 @@
 #include <linux/ipv6.h>
 
 #include <bpf/bpf_helpers.h>
+#include "xdp_fwd.h"
 
 #define IPV6_FLOWINFO_MASK              cpu_to_be32(0x0FFFFFFF)
 
 struct {
 	__uint(type, BPF_MAP_TYPE_DEVMAP);
-	__uint(key_size, sizeof(int));
-	__uint(value_size, sizeof(int));
+	__type(key, u32);
+	__type(value, struct bpf_devmap_val);
 	__uint(max_entries, 64);
 } xdp_tx_ports SEC(".maps");
 
diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
index 74a4583d0d86..4ddf70bcedde 100644
--- a/samples/bpf/xdp_fwd_user.c
+++ b/samples/bpf/xdp_fwd_user.c
@@ -26,13 +26,20 @@
 
 #include <bpf/libbpf.h>
 #include <bpf/bpf.h>
+#include "xdp_fwd.h"
 
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 
 static int do_attach(int idx, int prog_fd, int map_fd, const char *name)
 {
+	struct bpf_devmap_val val = { 0 };
 	int err;
 
+	val.ifindex = idx;
+#ifdef ENABLE_BPF_PROG
+	val.bpf_prog.fd = - 1;
+#endif
+
 	err = bpf_set_link_xdp_fd(idx, prog_fd, xdp_flags);
 	if (err < 0) {
 		printf("ERROR: failed to attach program to %s\n", name);
@@ -40,7 +47,7 @@ static int do_attach(int idx, int prog_fd, int map_fd, const char *name)
 	}
 
 	/* Adding ifindex as a possible egress TX port */
-	err = bpf_map_update_elem(map_fd, &idx, &idx, 0);
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
 	if (err)
 		printf("ERROR: failed using device %s as TX-port\n", name);
 


