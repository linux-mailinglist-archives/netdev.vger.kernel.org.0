Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB87026FEF
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbfEVTXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730694AbfEVTXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:23:00 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69D1B217D7;
        Wed, 22 May 2019 19:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552980;
        bh=bhYOpl2XhpHUCnwhwNtWLrHBHt936mFKINToYf84/hE=;
        h=From:To:Cc:Subject:Date:From;
        b=JBhl1B11vbkxMDvXirFS4nJ5zT+3PVAWxssQp/MUR05QRgo/7uwDW8fjS8VN+/bd0
         oero/nHOWlJz79ELthWEPfHpRUHh9BniKFZ9LFlbUF1v6MlMGsE7rCT1RYtXgsXAu3
         3cXkhJGUCkbpPrLBpxkv5+Cb9MV+DTg8ydr9A+/0=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] neighbor: Add tracepoint to __neigh_create
Date:   Wed, 22 May 2019 12:22:21 -0700
Message-Id: <20190522192221.24825-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add tracepoint to __neigh_create to enable debugging of new entries.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/trace/events/neigh.h | 49 ++++++++++++++++++++++++++++++++++++++++++++
 net/core/neighbour.c         |  2 ++
 2 files changed, 51 insertions(+)

diff --git a/include/trace/events/neigh.h b/include/trace/events/neigh.h
index 0bdb08557763..62bb17516713 100644
--- a/include/trace/events/neigh.h
+++ b/include/trace/events/neigh.h
@@ -20,6 +20,55 @@
 		{ NUD_NOARP, "noarp" },			\
 		{ NUD_PERMANENT, "permanent"})
 
+TRACE_EVENT(neigh_create,
+
+	TP_PROTO(struct neigh_table *tbl, struct net_device *dev,
+		 const void *pkey, const struct neighbour *n,
+		 bool exempt_from_gc),
+
+	TP_ARGS(tbl, dev, pkey, n, exempt_from_gc),
+
+	TP_STRUCT__entry(
+		__field(u32, family)
+		__dynamic_array(char,  dev,   IFNAMSIZ )
+		__field(int, entries)
+		__field(u8, created)
+		__field(u8, gc_exempt)
+		__array(u8, primary_key4, 4)
+		__array(u8, primary_key6, 16)
+	),
+
+	TP_fast_assign(
+		struct in6_addr *pin6;
+		__be32 *p32;
+
+		__entry->family = tbl->family;
+		__assign_str(dev, (dev ? dev->name : "NULL"));
+		__entry->entries = atomic_read(&tbl->gc_entries);
+		__entry->created = n != NULL;
+		__entry->gc_exempt = exempt_from_gc;
+		pin6 = (struct in6_addr *)__entry->primary_key6;
+		p32 = (__be32 *)__entry->primary_key4;
+
+		if (tbl->family == AF_INET)
+			*p32 = *(__be32 *)pkey;
+		else
+			*p32 = 0;
+
+#if IS_ENABLED(CONFIG_IPV6)
+		if (tbl->family == AF_INET6) {
+			pin6 = (struct in6_addr *)__entry->primary_key6;
+			*pin6 = *(struct in6_addr *)pkey;
+		}
+#endif
+	),
+
+	TP_printk("family %d dev %s entries %d primary_key4 %pI4 primary_key6 %pI6c created %d gc_exempt %d",
+		  __entry->family, __get_str(dev), __entry->entries,
+		  __entry->primary_key4, __entry->primary_key6,
+		  __entry->created, __entry->gc_exempt)
+);
+
 TRACE_EVENT(neigh_update,
 
 	TP_PROTO(struct neighbour *n, const u8 *lladdr, u8 new,
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index dfa871061f14..a5556e4d3f96 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -587,6 +587,8 @@ static struct neighbour *___neigh_create(struct neigh_table *tbl,
 	int error;
 	struct neigh_hash_table *nht;
 
+	trace_neigh_create(tbl, dev, pkey, n, exempt_from_gc);
+
 	if (!n) {
 		rc = ERR_PTR(-ENOBUFS);
 		goto out;
-- 
2.11.0

