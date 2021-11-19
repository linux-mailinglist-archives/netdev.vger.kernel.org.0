Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53556457305
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236466AbhKSQfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbhKSQfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:35:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E961C061574;
        Fri, 19 Nov 2021 08:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=cBertyEcw9Qh4PbO98F5Goltq0TK8xmE08I6jDbC4l8=; b=YPnRXRUymYzNsKxBZ2d4egZJlm
        TAl0m02YFB9j987DTad/I7g+Jo40QtbO4Hjzx0aRzo/1JKusL6R6r2nFALkjh1/r9Vy1AetY0GJGS
        z4+24Pevd9O621tFklL0izdwMERnmXHu0gp5AukRzcUkXfyOmeGAM5iBGLq/mZhOizti1XH3KQ0Kl
        /eexjVh8Fn5B+KxtU1/2CBnmS7noPOUUHb07ICO53ngcRrrMO6l1azuBIC8VUIjIUj7pDOq9amdC4
        6NqC2UGvJGz5t+HA8j5AKV6i/76sZ/6/L/O6alR0FlaAcPINP55L/UsjNT2m84MCcb7rfzrd28YXO
        Wq2bBKvg==;
Received: from [2001:4bb8:180:22b2:ffb8:fd25:b81f:ac15] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mo6oI-009gDA-Uw; Fri, 19 Nov 2021 16:32:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 4/5] bpf, docs: move handling of maps to Documentation/bpf/maps.rst
Date:   Fri, 19 Nov 2021 17:32:14 +0100
Message-Id: <20211119163215.971383-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211119163215.971383-1-hch@lst.de>
References: <20211119163215.971383-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the general maps documentation into the maps.rst file from the
overall networking filter documentation and add a link instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/maps.rst          | 43 ++++++++++++++++++++++++++
 Documentation/networking/filter.rst | 47 ++---------------------------
 2 files changed, 46 insertions(+), 44 deletions(-)

diff --git a/Documentation/bpf/maps.rst b/Documentation/bpf/maps.rst
index 2084b0e7cde88..f41619e312ace 100644
--- a/Documentation/bpf/maps.rst
+++ b/Documentation/bpf/maps.rst
@@ -1,4 +1,47 @@
+
+=========
+eBPF maps
 =========
+
+'maps' is a generic storage of different types for sharing data between kernel
+and userspace.
+
+The maps are accessed from user space via BPF syscall, which has commands:
+
+- create a map with given type and attributes
+  ``map_fd = bpf(BPF_MAP_CREATE, union bpf_attr *attr, u32 size)``
+  using attr->map_type, attr->key_size, attr->value_size, attr->max_entries
+  returns process-local file descriptor or negative error
+
+- lookup key in a given map
+  ``err = bpf(BPF_MAP_LOOKUP_ELEM, union bpf_attr *attr, u32 size)``
+  using attr->map_fd, attr->key, attr->value
+  returns zero and stores found elem into value or negative error
+
+- create or update key/value pair in a given map
+  ``err = bpf(BPF_MAP_UPDATE_ELEM, union bpf_attr *attr, u32 size)``
+  using attr->map_fd, attr->key, attr->value
+  returns zero or negative error
+
+- find and delete element by key in a given map
+  ``err = bpf(BPF_MAP_DELETE_ELEM, union bpf_attr *attr, u32 size)``
+  using attr->map_fd, attr->key
+
+- to delete map: close(fd)
+  Exiting process will delete maps automatically
+
+userspace programs use this syscall to create/access maps that eBPF programs
+are concurrently updating.
+
+maps can have different types: hash, array, bloom filter, radix-tree, etc.
+
+The map is defined by:
+
+  - type
+  - max number of elements
+  - key size in bytes
+  - value size in bytes
+
 Map Types
 =========
 
diff --git a/Documentation/networking/filter.rst b/Documentation/networking/filter.rst
index 83ffcaa5b91aa..43ef05b91f986 100644
--- a/Documentation/networking/filter.rst
+++ b/Documentation/networking/filter.rst
@@ -1232,9 +1232,9 @@ pointer type.  The types of pointers describe their base, as follows:
 			Pointer to the value stored in a map element.
     PTR_TO_MAP_VALUE_OR_NULL
 			Either a pointer to a map value, or NULL; map accesses
-			(see section 'eBPF maps', below) return this type,
-			which becomes a PTR_TO_MAP_VALUE when checked != NULL.
-			Arithmetic on these pointers is forbidden.
+			(see maps.rst) return this type, which becomes a
+			a PTR_TO_MAP_VALUE when checked != NULL. Arithmetic on
+			these pointers is forbidden.
     PTR_TO_STACK
 			Frame pointer.
     PTR_TO_PACKET
@@ -1402,47 +1402,6 @@ using normal C code as::
 which makes such programs easier to write comparing to LD_ABS insn
 and significantly faster.
 
-eBPF maps
----------
-'maps' is a generic storage of different types for sharing data between kernel
-and userspace.
-
-The maps are accessed from user space via BPF syscall, which has commands:
-
-- create a map with given type and attributes
-  ``map_fd = bpf(BPF_MAP_CREATE, union bpf_attr *attr, u32 size)``
-  using attr->map_type, attr->key_size, attr->value_size, attr->max_entries
-  returns process-local file descriptor or negative error
-
-- lookup key in a given map
-  ``err = bpf(BPF_MAP_LOOKUP_ELEM, union bpf_attr *attr, u32 size)``
-  using attr->map_fd, attr->key, attr->value
-  returns zero and stores found elem into value or negative error
-
-- create or update key/value pair in a given map
-  ``err = bpf(BPF_MAP_UPDATE_ELEM, union bpf_attr *attr, u32 size)``
-  using attr->map_fd, attr->key, attr->value
-  returns zero or negative error
-
-- find and delete element by key in a given map
-  ``err = bpf(BPF_MAP_DELETE_ELEM, union bpf_attr *attr, u32 size)``
-  using attr->map_fd, attr->key
-
-- to delete map: close(fd)
-  Exiting process will delete maps automatically
-
-userspace programs use this syscall to create/access maps that eBPF programs
-are concurrently updating.
-
-maps can have different types: hash, array, bloom filter, radix-tree, etc.
-
-The map is defined by:
-
-  - type
-  - max number of elements
-  - key size in bytes
-  - value size in bytes
-
 Pruning
 -------
 The verifier does not actually walk all possible paths through the program.  For
-- 
2.30.2

