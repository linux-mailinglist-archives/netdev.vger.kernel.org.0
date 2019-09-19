Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38400B70F1
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 03:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388024AbfISB1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 21:27:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3547 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732041AbfISB1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 21:27:34 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C64FB308AA11;
        Thu, 19 Sep 2019 01:27:33 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4A2660F88;
        Thu, 19 Sep 2019 01:27:23 +0000 (UTC)
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
Subject: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid outside init_user_ns
Date:   Wed, 18 Sep 2019 21:22:37 -0400
Message-Id: <214163d11a75126f610bcedfad67a4d89575dc77.1568834525.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 19 Sep 2019 01:27:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a mechanism similar to CAP_AUDIT_CONTROL to explicitly give a
process in a non-init user namespace the capability to set audit
container identifiers.

Use audit netlink message types AUDIT_GET_CAPCONTID 1027 and
AUDIT_SET_CAPCONTID 1028.  The message format includes the data
structure:
struct audit_capcontid_status {
        pid_t   pid;
        u32     enable;
};

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h      | 14 +++++++
 include/uapi/linux/audit.h |  2 +
 kernel/audit.c             | 98 +++++++++++++++++++++++++++++++++++++++++++++-
 kernel/audit.h             |  5 +++
 4 files changed, 117 insertions(+), 2 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 1ce27af686ea..dcc53e62e266 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -117,6 +117,7 @@ struct audit_task_info {
 	kuid_t			loginuid;
 	unsigned int		sessionid;
 	struct audit_cont	*cont;
+	u32			capcontid;
 #ifdef CONFIG_AUDITSYSCALL
 	struct audit_context	*ctx;
 #endif
@@ -224,6 +225,14 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
 	return tsk->audit->sessionid;
 }
 
+static inline u32 audit_get_capcontid(struct task_struct *tsk)
+{
+	if (!tsk->audit)
+		return 0;
+	return tsk->audit->capcontid;
+}
+
+extern int audit_set_capcontid(struct task_struct *tsk, u32 enable);
 extern int audit_set_contid(struct task_struct *tsk, u64 contid);
 
 static inline u64 audit_get_contid(struct task_struct *tsk)
@@ -309,6 +318,11 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
 	return AUDIT_SID_UNSET;
 }
 
+static inline u32 audit_get_capcontid(struct task_struct *tsk)
+{
+	return 0;
+}
+
 static inline u64 audit_get_contid(struct task_struct *tsk)
 {
 	return AUDIT_CID_UNSET;
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index eef42c8eea77..011b0a8ee9b2 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -78,6 +78,8 @@
 #define AUDIT_GET_LOGINUID	1024	/* Get loginuid of a task */
 #define AUDIT_SET_LOGINUID	1025	/* Set loginuid of a task */
 #define AUDIT_GET_SESSIONID	1026	/* Set sessionid of a task */
+#define AUDIT_GET_CAPCONTID	1027	/* Get cap_contid of a task */
+#define AUDIT_SET_CAPCONTID	1028	/* Set cap_contid of a task */
 
 #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly uninteresting to kernel */
 #define AUDIT_USER_AVC		1107	/* We filter this differently */
diff --git a/kernel/audit.c b/kernel/audit.c
index a70c9184e5d9..7160da464849 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1192,6 +1192,14 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	case AUDIT_GET_SESSIONID:
 		return 0;
 		break;
+	case AUDIT_GET_CAPCONTID:
+	case AUDIT_SET_CAPCONTID:
+	case AUDIT_GET_CONTID:
+	case AUDIT_SET_CONTID:
+		if (!netlink_capable(skb, CAP_AUDIT_CONTROL) && !audit_get_capcontid(current))
+			return -EPERM;
+		return 0;
+		break;
 	default:  /* do more checks below */
 		break;
 	}
@@ -1227,8 +1235,6 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	case AUDIT_TTY_SET:
 	case AUDIT_TRIM:
 	case AUDIT_MAKE_EQUIV:
-	case AUDIT_GET_CONTID:
-	case AUDIT_SET_CONTID:
 	case AUDIT_SET_LOGINUID:
 		/* Only support auditd and auditctl in initial pid namespace
 		 * for now. */
@@ -1304,6 +1310,23 @@ static int audit_get_contid_status(struct sk_buff *skb)
 	return 0;
 }
 
+static int audit_get_capcontid_status(struct sk_buff *skb)
+{
+	struct nlmsghdr *nlh = nlmsg_hdr(skb);
+	u32 seq = nlh->nlmsg_seq;
+	void *data = nlmsg_data(nlh);
+	struct audit_capcontid_status cs;
+
+	cs.pid = ((struct audit_capcontid_status *)data)->pid;
+	if (!cs.pid)
+		cs.pid = task_tgid_nr(current);
+	rcu_read_lock();
+	cs.enable = audit_get_capcontid(find_task_by_vpid(cs.pid));
+	rcu_read_unlock();
+	audit_send_reply(skb, seq, AUDIT_GET_CAPCONTID, 0, 0, &cs, sizeof(cs));
+	return 0;
+}
+
 struct audit_loginuid_status { uid_t loginuid; };
 
 static int audit_get_loginuid_status(struct sk_buff *skb)
@@ -1779,6 +1802,27 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (err)
 			return err;
 		break;
+	case AUDIT_SET_CAPCONTID: {
+		struct audit_capcontid_status *s = data;
+		struct task_struct *tsk;
+
+		/* check if new data is valid */
+		if (nlmsg_len(nlh) < sizeof(*s))
+			return -EINVAL;
+		tsk = find_get_task_by_vpid(s->pid);
+		if (!tsk)
+			return -EINVAL;
+
+		err = audit_set_capcontid(tsk, s->enable);
+		put_task_struct(tsk);
+		return err;
+		break;
+	}
+	case AUDIT_GET_CAPCONTID:
+		err = audit_get_capcontid_status(skb);
+		if (err)
+			return err;
+		break;
 	case AUDIT_SET_LOGINUID: {
 		uid_t *loginuid = data;
 		kuid_t kloginuid;
@@ -2711,6 +2755,56 @@ static struct task_struct *audit_cont_owner(struct task_struct *tsk)
 	return NULL;
 }
 
+int audit_set_capcontid(struct task_struct *task, u32 enable)
+{
+	u32 oldcapcontid;
+	int rc = 0;
+	struct audit_buffer *ab;
+	uid_t uid;
+	struct tty_struct *tty;
+	char comm[sizeof(current->comm)];
+
+	if (!task->audit)
+		return -ENOPROTOOPT;
+	oldcapcontid = audit_get_capcontid(task);
+	/* if task is not descendant, block */
+	if (task == current)
+		rc = -EBADSLT;
+	else if (!task_is_descendant(current, task))
+		rc = -EXDEV;
+	else if (current_user_ns() == &init_user_ns) {
+		if (!capable(CAP_AUDIT_CONTROL) && !audit_get_capcontid(current))
+			rc = -EPERM;
+	}
+	if (!rc)
+		task->audit->capcontid = enable;
+
+	if (!audit_enabled)
+		return rc;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_SET_CAPCONTID);
+	if (!ab)
+		return rc;
+
+	uid = from_kuid(&init_user_ns, task_uid(current));
+	tty = audit_get_tty();
+	audit_log_format(ab,
+			 "opid=%d capcontid=%u old-capcontid=%u pid=%d uid=%u auid=%u tty=%s ses=%u",
+			 task_tgid_nr(task), enable, oldcapcontid,
+			 task_tgid_nr(current), uid,
+			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
+			 tty ? tty_name(tty) : "(none)",
+			 audit_get_sessionid(current));
+	audit_put_tty(tty);
+	audit_log_task_context(ab);
+	audit_log_format(ab, " comm=");
+	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	audit_log_d_path_exe(ab, current->mm);
+	audit_log_format(ab, " res=%d", !rc);
+	audit_log_end(ab);
+	return rc;
+}
+
 /*
  * audit_set_contid - set current task's audit contid
  * @task: target task
diff --git a/kernel/audit.h b/kernel/audit.h
index cb25341c1a0f..ac4694e88485 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -231,6 +231,11 @@ struct audit_contid_status {
 	u64	id;
 };
 
+struct audit_capcontid_status {
+	pid_t	pid;
+	u32	enable;
+};
+
 #define AUDIT_CONTID_DEPTH	5
 
 /* Indicates that audit should log the full pathname. */
-- 
1.8.3.1

