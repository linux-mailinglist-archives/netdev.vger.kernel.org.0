Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AA12F33D1
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404029AbhALPMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:12:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403901AbhALPMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:12:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610464276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=eLxohIAroViULxx7/3TYcwTyBtNxALiR7rsXmeEuzKw=;
        b=jNATru5ncTpmFJA3D9gTsoxuoWxLNXNyYeRVylKU/ewOonDbJImIWUABGo7Y0IoBJEjcq8
        A9ju02Q98wX5MPKjWoTT30jNEtojzoYgrihJnDpt+dJfx3kJnkdbBOVcPTOZ3ZxvQrpbuy
        x8B8m2+4iGt7li5vUjJAVSv7rjZgU7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-X8MXGvJjO6a3yrGoWzoMkQ-1; Tue, 12 Jan 2021 10:11:13 -0500
X-MC-Unique: X8MXGvJjO6a3yrGoWzoMkQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE179802B40;
        Tue, 12 Jan 2021 15:11:10 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56E735D9CD;
        Tue, 12 Jan 2021 15:10:55 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux Containers List <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Linux FSdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
        Netfilter Devel List <netfilter-devel@vger.kernel.org>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Simo Sorce <simo@redhat.com>,
        Eric Paris <eparis@parisplace.org>, mpatel@redhat.com,
        Serge Hallyn <serge@hallyn.com>,
        Kees Cook <keescook@chromium.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 v11 04/11] audit: add contid support for signalling the audit daemon
Date:   Tue, 12 Jan 2021 10:09:32 -0500
Message-Id: <bab494fec9b550d99f2930416478385b1a824ea5.1610399347.git.rgb@redhat.com>
In-Reply-To: <cover.1610399347.git.rgb@redhat.com>
References: <cover.1610399347.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add audit container identifier support to the action of signalling the
audit daemon.

Since this would need to add an element to the audit_sig_info struct,
a new record type AUDIT_SIGNAL_INFO2 was created with a new
audit_sig_info2 struct.  Corresponding support is required in the
userspace code to reflect the new record request and reply type.
An older userspace won't break since it won't know to request this
record type.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
Acks from nhorman/omosnace should have been added in v6.
Acks dropped due to restructure audit_sig_info2 for nesting, sigcount, reap adtsk
---
 include/linux/audit.h       |   7 +++
 include/uapi/linux/audit.h  |   1 +
 kernel/audit.c              | 118 +++++++++++++++++++++++++++++++++---
 security/selinux/nlmsgtab.c |   1 +
 4 files changed, 119 insertions(+), 8 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 30c55e6b6a3c..7c1928e75cfe 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -23,6 +23,13 @@ struct audit_sig_info {
 	char		ctx[];
 };
 
+struct audit_sig_info2 {
+	uid_t		uid;
+	pid_t		pid;
+	u32		cid_len;
+	char		data[];
+};
+
 struct audit_buffer;
 struct audit_context;
 struct inode;
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index c56335e828dc..94dcf3085658 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -72,6 +72,7 @@
 #define AUDIT_SET_FEATURE	1018	/* Turn an audit feature on or off */
 #define AUDIT_GET_FEATURE	1019	/* Get which features are enabled */
 #define AUDIT_CONTAINER_OP	1020	/* Define the container id and info */
+#define AUDIT_SIGNAL_INFO2	1021	/* Get info auditd signal sender */
 
 #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly uninteresting to kernel */
 #define AUDIT_USER_AVC		1107	/* We filter this differently */
diff --git a/kernel/audit.c b/kernel/audit.c
index 5495b69bc505..314af418bf67 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -123,9 +123,11 @@ static u32	audit_backlog_limit = 64;
 static u32	audit_backlog_wait_time = AUDIT_BACKLOG_WAIT_TIME;
 
 /* The identity of the user shutting down the audit system. */
-static kuid_t		audit_sig_uid = INVALID_UID;
-static pid_t		audit_sig_pid = -1;
-static u32		audit_sig_sid;
+static kuid_t			audit_sig_uid = INVALID_UID;
+static pid_t			audit_sig_pid = -1;
+static u32			audit_sig_sid;
+static struct audit_contobj	*audit_sig_cid;
+static struct task_struct	*audit_sig_adtsk;
 
 /* Records can be lost in several ways:
    0) [suppressed in audit_alloc]
@@ -222,6 +224,7 @@ struct audit_contobj {
 	u64			id;
 	struct task_struct	*owner;
 	refcount_t		refcount;
+	refcount_t		sigcount;
 	struct rcu_head         rcu;
 };
 
@@ -330,9 +333,39 @@ static void _audit_contobj_put(struct audit_contobj *cont)
 	if (!cont)
 		return;
 	if (refcount_dec_and_test(&cont->refcount)) {
-		put_task_struct(cont->owner);
-		list_del_rcu(&cont->list);
-		kfree_rcu(cont, rcu);
+		if (!refcount_read(&cont->sigcount)) {
+			put_task_struct(cont->owner);
+			list_del_rcu(&cont->list);
+			kfree_rcu(cont, rcu);
+		}
+	}
+}
+
+/* rcu_read_lock must be held by caller unless new */
+static struct audit_contobj *_audit_contobj_get_sig_bytask(struct task_struct *tsk)
+{
+	struct audit_contobj *cont;
+	struct audit_task_info *info = tsk->audit;
+
+	if (!info)
+		return NULL;
+	cont = info->cont;
+	if (cont)
+		refcount_inc(&cont->sigcount);
+	return cont;
+}
+
+/* rcu_read_lock must be held by caller */
+static void _audit_contobj_put_sig(struct audit_contobj *cont)
+{
+	if (!cont)
+		return;
+	if (refcount_dec_and_test(&cont->sigcount)) {
+		if (!refcount_read(&cont->refcount)) {
+			put_task_struct(cont->owner);
+			list_del_rcu(&cont->list);
+			kfree_rcu(cont, rcu);
+		}
 	}
 }
 
@@ -430,6 +463,15 @@ void audit_free(struct task_struct *tsk)
 	 */
 	tsk->audit = NULL;
 	kmem_cache_free(audit_task_cache, info);
+	rcu_read_lock();
+	if (audit_sig_adtsk == tsk) {
+		spin_lock(&_audit_contobj_list_lock);
+		_audit_contobj_put_sig(audit_sig_cid);
+		spin_unlock(&_audit_contobj_list_lock);
+		audit_sig_cid = NULL;
+		audit_sig_adtsk = NULL;
+	}
+	rcu_read_unlock();
 }
 
 /**
@@ -1252,6 +1294,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	case AUDIT_ADD_RULE:
 	case AUDIT_DEL_RULE:
 	case AUDIT_SIGNAL_INFO:
+	case AUDIT_SIGNAL_INFO2:
 	case AUDIT_TTY_GET:
 	case AUDIT_TTY_SET:
 	case AUDIT_TRIM:
@@ -1414,6 +1457,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct audit_buffer	*ab;
 	u16			msg_type = nlh->nlmsg_type;
 	struct audit_sig_info   *sig_data;
+	struct audit_sig_info2  *sig_data2;
 	char			*ctx = NULL;
 	u32			len;
 
@@ -1685,7 +1729,58 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
 				 sig_data, sizeof(*sig_data) + len);
 		kfree(sig_data);
+		spin_lock(&_audit_contobj_list_lock);
+		_audit_contobj_put_sig(audit_sig_cid);
+		spin_unlock(&_audit_contobj_list_lock);
+		audit_sig_cid = NULL;
 		break;
+	case AUDIT_SIGNAL_INFO2: {
+		char *contidstr = NULL;
+		unsigned int contidstrlen = 0;
+
+		len = 0;
+		if (audit_sig_sid) {
+			err = security_secid_to_secctx(audit_sig_sid, &ctx,
+						       &len);
+			if (err)
+				return err;
+		}
+		if (audit_sig_cid) {
+			contidstr = kmalloc(21, GFP_KERNEL);
+			if (!contidstr) {
+				if (audit_sig_sid)
+					security_release_secctx(ctx, len);
+				return -ENOMEM;
+			}
+			contidstrlen = scnprintf(contidstr, 20, "%llu", audit_sig_cid->id);
+		}
+		sig_data2 = kmalloc(sizeof(*sig_data2) + contidstrlen + len, GFP_KERNEL);
+		if (!sig_data2) {
+			if (audit_sig_sid)
+				security_release_secctx(ctx, len);
+			kfree(contidstr);
+			return -ENOMEM;
+		}
+		sig_data2->uid = from_kuid(&init_user_ns, audit_sig_uid);
+		sig_data2->pid = audit_sig_pid;
+		if (audit_sig_cid) {
+			memcpy(sig_data2->data, contidstr, contidstrlen);
+			sig_data2->cid_len = contidstrlen;
+			kfree(contidstr);
+		}
+		if (audit_sig_sid) {
+			memcpy(sig_data2->data + contidstrlen, ctx, len);
+			security_release_secctx(ctx, len);
+		}
+		spin_lock(&_audit_contobj_list_lock);
+		_audit_contobj_put_sig(audit_sig_cid);
+		spin_unlock(&_audit_contobj_list_lock);
+		audit_sig_cid = NULL;
+		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO2, 0, 0,
+				 sig_data2, sizeof(*sig_data2) + contidstrlen + len);
+		kfree(sig_data2);
+		break;
+	}
 	case AUDIT_TTY_GET: {
 		struct audit_tty_status s;
 		unsigned int t;
@@ -2630,11 +2725,11 @@ int audit_set_loginuid(kuid_t loginuid)
  */
 int audit_signal_info(int sig, struct task_struct *t)
 {
-	kuid_t uid = current_uid(), auid;
-
 	if (auditd_test_task(t) &&
 	    (sig == SIGTERM || sig == SIGHUP ||
 	     sig == SIGUSR1 || sig == SIGUSR2)) {
+		kuid_t uid = current_uid(), auid;
+
 		audit_sig_pid = task_tgid_nr(current);
 		auid = audit_get_loginuid(current);
 		if (uid_valid(auid))
@@ -2642,6 +2737,13 @@ int audit_signal_info(int sig, struct task_struct *t)
 		else
 			audit_sig_uid = uid;
 		security_task_getsecid(current, &audit_sig_sid);
+		spin_lock(&_audit_contobj_list_lock);
+		_audit_contobj_put_sig(audit_sig_cid);
+		spin_unlock(&_audit_contobj_list_lock);
+		rcu_read_lock();
+		audit_sig_cid = _audit_contobj_get_sig_bytask(current);
+		rcu_read_unlock();
+		audit_sig_adtsk = t;
 	}
 
 	return audit_signal_info_syscall(t);
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index b69231918686..8303bb7a63d0 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -137,6 +137,7 @@ static const struct nlmsg_perm nlmsg_audit_perms[] =
 	{ AUDIT_DEL_RULE,	NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
 	{ AUDIT_USER,		NETLINK_AUDIT_SOCKET__NLMSG_RELAY    },
 	{ AUDIT_SIGNAL_INFO,	NETLINK_AUDIT_SOCKET__NLMSG_READ     },
+	{ AUDIT_SIGNAL_INFO2,	NETLINK_AUDIT_SOCKET__NLMSG_READ     },
 	{ AUDIT_TRIM,		NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
 	{ AUDIT_MAKE_EQUIV,	NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
 	{ AUDIT_TTY_GET,	NETLINK_AUDIT_SOCKET__NLMSG_READ     },
-- 
2.18.4

