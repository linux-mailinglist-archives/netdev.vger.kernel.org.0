Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0DD12DB95
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 20:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfLaTvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 14:51:41 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43260 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727508AbfLaTvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 14:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577821894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=RktF0EDk9xYqKlUsZg+wc8XpAwVp+TJpdSDbv8eupNU=;
        b=UON9VxTlpf66vFESzHAYGwCACE+havXmeCv0B1A35udFo1OiceabrEyd53gVTW2009zLF+
        AuSvAAj9z2zdK5HoWdJ5yZ/QwogL7oPUMJjBAjjmDJ1JSnGs3dgkvCTTygOWzDKEgWJ3Xx
        YLf+LolgqXK4xIQU5rMf1OJ2z1cgM2c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-IQeDQMnMPBKF1hv1JQVuGg-1; Tue, 31 Dec 2019 14:51:32 -0500
X-MC-Unique: IQeDQMnMPBKF1hv1JQVuGg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5669310054E3;
        Tue, 31 Dec 2019 19:51:30 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-15.phx2.redhat.com [10.3.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7FA967673;
        Tue, 31 Dec 2019 19:51:18 +0000 (UTC)
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
Subject: [PATCH ghak90 V8 14/16] audit: check contid depth and add limit config param
Date:   Tue, 31 Dec 2019 14:48:27 -0500
Message-Id: <28cf3e16f8440bcb852767d3ae13e1a56c19569c.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clamp the depth of audit container identifier nesting to limit the
netlink and disk bandwidth used and to prevent losing information from
record text size overflow in the contid field.

Add a configuration parameter AUDIT_STATUS_CONTID_DEPTH_LIMIT (0x80) to
set the audit container identifier depth limit.  This can be used to
prevent overflow of the contid field in CONTAINER_OP and CONTAINER_ID
messages, losing information, and to limit bandwidth used by these
messages.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/uapi/linux/audit.h |  2 ++
 kernel/audit.c             | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/audit.h             |  2 ++
 3 files changed, 50 insertions(+)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index ea6638bb914b..dcb076b0d2e1 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -343,6 +343,7 @@ enum {
 #define AUDIT_STATUS_BACKLOG_LIMIT	0x0010
 #define AUDIT_STATUS_BACKLOG_WAIT_TIME	0x0020
 #define AUDIT_STATUS_LOST		0x0040
+#define AUDIT_STATUS_CONTID_DEPTH_LIMIT	0x0080
 
 #define AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT	0x00000001
 #define AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME	0x00000002
@@ -471,6 +472,7 @@ struct audit_status {
 		__u32	feature_bitmap;	/* bitmap of kernel audit features */
 	};
 	__u32		backlog_wait_time;/* message queue wait timeout */
+	__u32		contid_depth_limit;/* container depth limit */
 };
 
 struct audit_features {
diff --git a/kernel/audit.c b/kernel/audit.c
index 68be59d1a89b..e5e39aedaf86 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -157,6 +157,7 @@ struct auditd_connection {
  * of container objects to tasks and refcount changes.  There should be
  * no need for interaction with tasklist_lock */
 static DEFINE_SPINLOCK(audit_contobj_list_lock);
+static u32 audit_contid_depth_limit = AUDIT_CONTID_DEPTH_LIMIT;
 
 static struct kmem_cache *audit_buffer_cache;
 
@@ -678,6 +679,20 @@ static int audit_set_backlog_wait_time(u32 timeout)
 				      &audit_backlog_wait_time, timeout);
 }
 
+static int audit_set_contid_depth_limit(u32 limit)
+{
+	int rc = 0;
+
+	if (limit > 20 * AUDIT_CONTID_DEPTH_LIMIT) {
+		rc = -ENOSPC;
+		audit_log_config_change("audit_contid_depth_limit",
+					limit, audit_contid_depth_limit, 0);
+		return rc;
+	}
+	return audit_do_config_change("audit_contid_depth_limit",
+				      &audit_contid_depth_limit, limit);
+}
+
 static int audit_set_enabled(u32 state)
 {
 	int rc;
@@ -1439,6 +1454,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		s.backlog		= skb_queue_len(&audit_queue);
 		s.feature_bitmap	= AUDIT_FEATURE_BITMAP_ALL;
 		s.backlog_wait_time	= audit_backlog_wait_time;
+		s.contid_depth_limit	= audit_contid_depth_limit;
 		audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &s, sizeof(s));
 		break;
 	}
@@ -1542,6 +1558,13 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			audit_log_config_change("lost", 0, lost, 1);
 			return lost;
 		}
+		if (s.mask & AUDIT_STATUS_CONTID_DEPTH_LIMIT) {
+			if (sizeof(s) > (size_t)nlh->nlmsg_len)
+				return -EINVAL;
+			err = audit_set_contid_depth_limit(s.contid_depth_limit);
+			if (err < 0)
+				return err;
+		}
 		break;
 	}
 	case AUDIT_GET_FEATURE:
@@ -2608,6 +2631,22 @@ int audit_signal_info(int sig, struct task_struct *t)
 	return audit_signal_info_syscall(t);
 }
 
+static int audit_contid_depth(struct audit_contobj *cont)
+{
+	struct audit_contobj *parent;
+	int depth = 1;
+
+	if (!cont)
+		return 0;
+
+	parent = cont->parent;
+	while (parent) {
+		depth++;
+		parent = parent->parent;
+	}
+	return depth;
+}
+
 static bool audit_contid_isowner(struct task_struct *tsk)
 {
 	if (tsk->audit && tsk->audit->cont)
@@ -2701,6 +2740,13 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 				}
 				break;
 			}
+		/* Clamp max container id depth */
+		if (audit_contid_depth_limit != 0 &&
+		    audit_contid_depth(_audit_contobj(rcu_dereference(current->real_parent)))
+		    >= audit_contid_depth_limit) {
+			rc = -EMLINK;
+			goto conterror;
+		}
 		if (!newcont) {
 			newcont = kmalloc(sizeof(*newcont), GFP_ATOMIC);
 			if (newcont) {
diff --git a/kernel/audit.h b/kernel/audit.h
index de814fcbb38c..fbca07a49c03 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -220,6 +220,8 @@ static inline int audit_hash_contid(u64 contid)
 	return (contid & (AUDIT_CONTID_BUCKETS-1));
 }
 
+#define AUDIT_CONTID_DEPTH_LIMIT	4
+
 /* Indicates that audit should log the full pathname. */
 #define AUDIT_NAME_FULL -1
 
-- 
1.8.3.1

