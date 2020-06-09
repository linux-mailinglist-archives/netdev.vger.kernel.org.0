Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706261F3C9B
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 15:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgFINcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 09:32:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36322 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729000AbgFINcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 09:32:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591709522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PFvWo3CucggmGPriTROKDBuxeyYpTwvcGiM7IDwsL8o=;
        b=aPBSmaXqdndgA5Ik0oi8iiqivgLLNzUt++rQpIyi4GfrsF1GmI2hCPfTHEMngbwQJnUgTu
        D4xAKmVJDQn5VJRniAf88+OaZhOEJ8wAaUzmoUEED3e+CqaNAxCx74mND8QS3YpKCsQ/Gn
        Qnx5CZNDK4In4KJc42xJAj8hDOHtcZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-JamM1E_IMkWXJ1x5qGXcBA-1; Tue, 09 Jun 2020 09:31:52 -0400
X-MC-Unique: JamM1E_IMkWXJ1x5qGXcBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F235A81CBE1;
        Tue,  9 Jun 2020 13:31:50 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD5D910190A7;
        Tue,  9 Jun 2020 13:31:47 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E68F8300003EB;
        Tue,  9 Jun 2020 15:31:46 +0200 (CEST)
Subject: [PATCH bpf V2 1/2] bpf: devmap adjust uapi for attach bpf program
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Tue, 09 Jun 2020 15:31:46 +0200
Message-ID: <159170950687.2102545.7235914718298050113.stgit@firesoul>
In-Reply-To: <159170947966.2102545.14401752480810420709.stgit@firesoul>
References: <159170947966.2102545.14401752480810420709.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2:
- Defer changing BPF-syscall to start at file-descriptor 1
- Use {} to zero initialise struct.

The recent commit fbee97feed9b ("bpf: Add support to attach bpf program to a
devmap entry"), introduced ability to attach (and run) a separate XDP
bpf_prog for each devmap entry. A bpf_prog is added via a file-descriptor.
As zero were a valid FD, not using the feature requires using value minus-1.
The UAPI is extended via tail-extending struct bpf_devmap_val and using
map->value_size to determine the feature set.

This will break older userspace applications not using the bpf_prog feature.
Consider an old userspace app that is compiled against newer kernel
uapi/bpf.h, it will not know that it need to initialise the member
bpf_prog.fd to minus-1. Thus, users will be forced to update source code to
get program running on newer kernels.

This patch remove the minus-1 checks, and have zero mean feature isn't used.

Followup patches either for kernel or libbpf should handle and avoid
returning file-descriptor zero in the first place.

Fixes: fbee97feed9b ("bpf: Add support to attach bpf program to a devmap entry")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/uapi/linux/bpf.h |   13 +++++++++++++
 kernel/bpf/devmap.c      |   17 ++++-------------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c65b374a5090..19684813faae 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3761,6 +3761,19 @@ struct xdp_md {
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
 };
 
+/* DEVMAP map-value layout
+ *
+ * The struct data-layout of map-value is a configuration interface.
+ * New members can only be added to the end of this structure.
+ */
+struct bpf_devmap_val {
+	__u32 ifindex;   /* device index */
+	union {
+		int   fd;  /* prog fd on map write */
+		__u32 id;  /* prog id on map read */
+	} bpf_prog;
+};
+
 enum sk_action {
 	SK_DROP = 0,
 	SK_PASS,
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 854b09beb16b..899a30a67cc1 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -60,15 +60,6 @@ struct xdp_dev_bulk_queue {
 	unsigned int count;
 };
 
-/* DEVMAP values */
-struct bpf_devmap_val {
-	u32 ifindex;   /* device index */
-	union {
-		int fd;  /* prog fd on map write */
-		u32 id;  /* prog id on map read */
-	} bpf_prog;
-};
-
 struct bpf_dtab_netdev {
 	struct net_device *dev; /* must be first member, due to tracepoint */
 	struct hlist_node index_hlist;
@@ -618,7 +609,7 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 	if (!dev->dev)
 		goto err_out;
 
-	if (val->bpf_prog.fd >= 0) {
+	if (val->bpf_prog.fd > 0) {
 		prog = bpf_prog_get_type_dev(val->bpf_prog.fd,
 					     BPF_PROG_TYPE_XDP, false);
 		if (IS_ERR(prog))
@@ -652,8 +643,8 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 				 void *key, void *value, u64 map_flags)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	struct bpf_devmap_val val = { .bpf_prog.fd = -1 };
 	struct bpf_dtab_netdev *dev, *old_dev;
+	struct bpf_devmap_val val = {};
 	u32 i = *(u32 *)key;
 
 	if (unlikely(map_flags > BPF_EXIST))
@@ -669,7 +660,7 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 	if (!val.ifindex) {
 		dev = NULL;
 		/* can not specify fd if ifindex is 0 */
-		if (val.bpf_prog.fd != -1)
+		if (val.bpf_prog.fd > 0)
 			return -EINVAL;
 	} else {
 		dev = __dev_map_alloc_node(net, dtab, &val, i);
@@ -699,8 +690,8 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 				     void *key, void *value, u64 map_flags)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	struct bpf_devmap_val val = { .bpf_prog.fd = -1 };
 	struct bpf_dtab_netdev *dev, *old_dev;
+	struct bpf_devmap_val val = {};
 	u32 idx = *(u32 *)key;
 	unsigned long flags;
 	int err = -EEXIST;


