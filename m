Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A49147F0D8
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 21:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239476AbhLXUBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 15:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353493AbhLXUBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 15:01:31 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B50EC061401;
        Fri, 24 Dec 2021 12:01:30 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so12113344otu.10;
        Fri, 24 Dec 2021 12:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A1PLZjYhhpl1dQVNS3B0M2gvABuBWKpfWr4yKx3TtVc=;
        b=hGed056Ol8zdMEAn/VOFPYNJ88v0jpofLeTogZe7Y1vcahlnE40p+o2hq8fNGUgi0b
         OP8tSl+W8ERcBMfEgA/IYfG0NYrkREgYMPY64NWvZ4cifPhYjl8bNFkgMs3C2xnTqPhO
         7PUyMQk53nVzmCOj6y7QMBcqr6y3Hw/FYkG8iPu14q2LlXNnQfLrM1kcrxkvrpJ6mPFF
         pjIe+0bBCr+asWcf4lWyIuciFLAqbr2mzpXpKsWoY98l6STk/FzKdZrYHzY+FRjsPbJE
         pCGysv0xHAk7DqJuLkOj4KkVegh1gbZM0nOzmhdnmruGueu2WkgrCLuXwbLPeNVjEMbM
         K4pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A1PLZjYhhpl1dQVNS3B0M2gvABuBWKpfWr4yKx3TtVc=;
        b=EKTI3W6U0AqcFRPD2wYkmW0sS+j93p3kk14p0C0ZKpu+NEyQdb8YMDRa5YXkUaHNWH
         /ppYFqLzM0G8fPiwe00Op98g53QrBAOXlTP9nlZEPF6anbmF16sb9sGdaYoBF0QBuwIl
         tYyOeizB9+rLCpl3lFcKa1ZvLqHc7T5q4SegdRkCVXAdzDfIWU+z/saB/X6bTR/3M4b+
         O7UD2kgGCKS6rc8Soj1szT1GaNt7C2LDbYnfaMk5PwQ4yTS98v0ULo2mFlokXeJWIApe
         w8cZ94Lv282HvcgcGlQ8E+NX05eeOdwek+Q2BDm3nOmuawJ/BAHX7p4cMxdzEAsvIpKO
         3R0Q==
X-Gm-Message-State: AOAM532dRFFuggqbd57QMwZRaZFfWPC67CSbrE6ervDvNK/A4Y1bF6o3
        va5AOSiFmZxs25kTu7PrHh7vOofTWEQ=
X-Google-Smtp-Source: ABdhPJwnSo9lOcUH4iyKqkEsVcqg+/ZhxlUko0G9AbO3I8fznkcYYbqz0wRYYhIjqW+a33kknTdR7A==
X-Received: by 2002:a05:6830:1c71:: with SMTP id s17mr5529424otg.297.1640376089737;
        Fri, 24 Dec 2021 12:01:29 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:b326:fb0b:9894:47a6])
        by smtp.gmail.com with ESMTPSA id o2sm1865506oik.11.2021.12.24.12.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Dec 2021 12:01:29 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>
Subject: [RFC Patch v3 1/3] introduce priority queue
Date:   Fri, 24 Dec 2021 12:00:57 -0800
Message-Id: <20211224200059.161979-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211224200059.161979-1-xiyou.wangcong@gmail.com>
References: <20211224200059.161979-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/linux/priority_queue.h | 90 ++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)
 create mode 100644 include/linux/priority_queue.h

diff --git a/include/linux/priority_queue.h b/include/linux/priority_queue.h
new file mode 100644
index 000000000000..08177517977f
--- /dev/null
+++ b/include/linux/priority_queue.h
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  A priority queue implementation based on rbtree
+ *
+ *   Copyright (C) 2021, Bytedance, Cong Wang <cong.wang@bytedance.com>
+ */
+
+#ifndef	_LINUX_PRIORITY_QUEUE_H
+#define	_LINUX_PRIORITY_QUEUE_H
+
+#include <linux/rbtree.h>
+
+struct pq_node {
+	struct rb_node rb_node;
+};
+
+struct pq_root {
+	struct rb_root_cached rb_root;
+	bool (*cmp)(struct pq_node *l, struct pq_node *r);
+};
+
+static inline void pq_root_init(struct pq_root *root,
+				bool (*cmp)(struct pq_node *l, struct pq_node *r))
+{
+	root->rb_root = RB_ROOT_CACHED;
+	root->cmp = cmp;
+}
+
+static inline void pq_push(struct pq_root *root, struct pq_node *node)
+{
+	struct rb_node **link = &root->rb_root.rb_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct pq_node *entry;
+	bool leftmost = true;
+
+	/*
+	 * Find the right place in the rbtree:
+	 */
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct pq_node, rb_node);
+		/*
+		 * We dont care about collisions. Nodes with
+		 * the same key stay together.
+		 */
+		if (root->cmp(entry, node)) {
+			link = &parent->rb_left;
+		} else {
+			link = &parent->rb_right;
+			leftmost = false;
+		}
+	}
+
+	rb_link_node(&node->rb_node, parent, link);
+	rb_insert_color_cached(&node->rb_node, &root->rb_root, leftmost);
+}
+
+static inline struct pq_node *pq_top(struct pq_root *root)
+{
+	struct rb_node *left = rb_first_cached(&root->rb_root);
+
+	if (!left)
+		return NULL;
+	return rb_entry(left, struct pq_node, rb_node);
+}
+
+static inline struct pq_node *pq_pop(struct pq_root *root)
+{
+	struct pq_node *t = pq_top(root);
+
+	if (t)
+		rb_erase_cached(&t->rb_node, &root->rb_root);
+	return t;
+}
+
+static inline void pq_flush(struct pq_root *root, void (*destroy)(struct pq_node *))
+{
+	struct rb_node *node, *next;
+
+	for (node = rb_first(&root->rb_root.rb_root);
+	     next = node ? rb_next(node) : NULL, node != NULL;
+	     node = next) {
+		struct pq_node *pqe;
+
+		pqe = rb_entry(node, struct pq_node, rb_node);
+		if (destroy)
+			destroy(pqe);
+	}
+}
+#endif	/* _LINUX_PRIORITY_QUEUE_H */
-- 
2.32.0

