Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E05046AA6A
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352662AbhLFVai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:30:38 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:52544 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236938AbhLFVag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:30:36 -0500
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2021 16:30:35 EST
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id A035D200DFBE;
        Mon,  6 Dec 2021 22:18:15 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be A035D200DFBE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1638825495;
        bh=rceATES+hMWzzH/m+Y09OeBkLR1NHaKyBcBmdhxje+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJv15rtxXxNeiA0A5Xc7LIJ0wXhQ+IKAfWfRVROSzTNijUokVb44zmmU1hKuHzI5x
         urW5GoI0YBuC0p42vKhxZ609dH05meDltIBLw72v3ALWttqMFIiW64s8s8gO21XkQ6
         We3NgQ/bi53xyAyCusJwpj2n8QkY8D7bkmb3kQSgGhsrk2VJne182n/qm13JVzNTtS
         rz4Iciyjf00unKw2zVDSMHmeV7l3xrgEisSt6uQokkaYA29eP0p6Lg2gHx9Ppod0Kl
         EGIDWa/90kfJ3N2WGtt8LN2iPwc+EzP7yA5YPQg8XAnYZQT5EzLAU8/489FFk4Wix0
         M5Ncj9usnSFUQ==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, vbabka@suse.cz, justin.iurman@uliege.be
Subject: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy data field
Date:   Mon,  6 Dec 2021 22:17:58 +0100
Message-Id: <20211206211758.19057-3-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206211758.19057-1-justin.iurman@uliege.be>
References: <20211206211758.19057-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is an attempt to support the buffer occupancy in IOAM trace
data fields. Any feedback is appreciated, or any other idea if this one
is not correct.

The draft [1] says the following:

   The "buffer occupancy" field is a 4-octet unsigned integer field.
   This field indicates the current status of the occupancy of the
   common buffer pool used by a set of queues.  The units of this field
   are implementation specific.  Hence, the units are interpreted within
   the context of an IOAM-Namespace and/or node-id if used.  The authors
   acknowledge that in some operational cases there is a need for the
   units to be consistent across a packet path through the network,
   hence it is recommended for implementations to use standard units
   such as Bytes.

An existing function (i.e., get_slabinfo) is used to retrieve info about
skbuff_head_cache. For that, both the prototype of get_slabinfo and
struct definition of slabinfo were moved from mm/slab.h to
include/linux/slab.h. Any objection on this?

The function kmem_cache_size is used to retrieve the size of a slab
object. Note that it returns the "object_size" field, not the "size"
field. If needed, a new function (e.g., kmem_cache_full_size) could be
added to return the "size" field. To match the definition from the
draft, the number of bytes is computed as follows:

slabinfo.active_objs * size

Thoughts?

  [1] https://datatracker.ietf.org/doc/html/draft-ietf-ippm-ioam-data#section-5.4.2.12

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/linux/slab.h | 15 +++++++++++++++
 mm/slab.h            | 14 --------------
 net/ipv6/ioam6.c     | 13 ++++++++++++-
 3 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 181045148b06..745790dbcbcb 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -19,6 +19,21 @@
 #include <linux/percpu-refcount.h>
 
 
+struct slabinfo {
+	unsigned long active_objs;
+	unsigned long num_objs;
+	unsigned long active_slabs;
+	unsigned long num_slabs;
+	unsigned long shared_avail;
+	unsigned int limit;
+	unsigned int batchcount;
+	unsigned int shared;
+	unsigned int objects_per_slab;
+	unsigned int cache_order;
+};
+
+void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo);
+
 /*
  * Flags to pass to kmem_cache_create().
  * The ones marked DEBUG are only valid if CONFIG_DEBUG_SLAB is set.
diff --git a/mm/slab.h b/mm/slab.h
index 56ad7eea3ddf..cd6a8a2768e3 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -175,20 +175,6 @@ void slab_kmem_cache_release(struct kmem_cache *);
 struct seq_file;
 struct file;
 
-struct slabinfo {
-	unsigned long active_objs;
-	unsigned long num_objs;
-	unsigned long active_slabs;
-	unsigned long num_slabs;
-	unsigned long shared_avail;
-	unsigned int limit;
-	unsigned int batchcount;
-	unsigned int shared;
-	unsigned int objects_per_slab;
-	unsigned int cache_order;
-};
-
-void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo);
 void slabinfo_show_stats(struct seq_file *m, struct kmem_cache *s);
 ssize_t slabinfo_write(struct file *file, const char __user *buffer,
 		       size_t count, loff_t *ppos);
diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 088eb2f877bc..f0a44dc2a0df 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -14,6 +14,8 @@
 #include <linux/ioam6_genl.h>
 #include <linux/rhashtable.h>
 #include <linux/netdevice.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
 
 #include <net/addrconf.h>
 #include <net/genetlink.h>
@@ -778,7 +780,16 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 
 	/* buffer occupancy */
 	if (trace->type.bit11) {
-		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		struct slabinfo sinfo;
+		u32 size, bytes;
+
+		sinfo.active_objs = 0;
+		get_slabinfo(skbuff_head_cache, &sinfo);
+		size = kmem_cache_size(skbuff_head_cache);
+
+		bytes = min(sinfo.active_objs * size, (unsigned long)(U32_MAX-1));
+
+		*(__be32 *)data = cpu_to_be32(bytes);
 		data += sizeof(__be32);
 	}
 
-- 
2.25.1

