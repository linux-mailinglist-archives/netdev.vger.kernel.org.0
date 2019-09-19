Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827B4B7092
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 03:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387536AbfISBYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 21:24:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55385 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbfISBYk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 21:24:40 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 141B5C057F31;
        Thu, 19 Sep 2019 01:24:35 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1E7E60C18;
        Thu, 19 Sep 2019 01:24:18 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com,
        nhorman@tuxdriver.com, dwalsh@redhat.com, mpatel@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V7 06/21] audit: contid limit of 32k imposed to avoid DoS
Date:   Wed, 18 Sep 2019 21:22:23 -0400
Message-Id: <230e91cd3e50a3d8015daac135c24c4c58cf0a21.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 19 Sep 2019 01:24:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set an arbitrary limit on the number of audit container identifiers to
limit abuse.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c | 8 ++++++++
 kernel/audit.h | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 53d13d638c63..329916534dd2 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -139,6 +139,7 @@ struct audit_net {
 struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
 /* Hash for contid-based rules */
 struct list_head audit_contid_hash[AUDIT_CONTID_BUCKETS];
+int audit_contid_count = 0;
 
 static struct kmem_cache *audit_buffer_cache;
 
@@ -2384,6 +2385,7 @@ void audit_cont_put(struct audit_cont *cont)
 		put_task_struct(cont->owner);
 		list_del_rcu(&cont->list);
 		kfree_rcu(cont, rcu);
+		audit_contid_count--;
 	}
 }
 
@@ -2456,6 +2458,11 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 					goto conterror;
 				}
 			}
+		/* Set max contids */
+		if (audit_contid_count > AUDIT_CONTID_COUNT) {
+			rc = -ENOSPC;
+			goto conterror;
+		}
 		if (!newcont) {
 			newcont = kmalloc(sizeof(struct audit_cont), GFP_ATOMIC);
 			if (newcont) {
@@ -2465,6 +2472,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 				newcont->owner = current;
 				refcount_set(&newcont->refcount, 1);
 				list_add_rcu(&newcont->list, &audit_contid_hash[h]);
+				audit_contid_count++;
 			} else {
 				rc = -ENOMEM;
 				goto conterror;
diff --git a/kernel/audit.h b/kernel/audit.h
index 162de8366b32..543f1334ba47 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -219,6 +219,10 @@ static inline int audit_hash_contid(u64 contid)
 	return (contid & (AUDIT_CONTID_BUCKETS-1));
 }
 
+extern int audit_contid_count;
+
+#define AUDIT_CONTID_COUNT	1 << 16
+
 /* Indicates that audit should log the full pathname. */
 #define AUDIT_NAME_FULL -1
 
-- 
1.8.3.1

