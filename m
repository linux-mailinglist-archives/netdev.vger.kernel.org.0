Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA51512DB67
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 20:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfLaTuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 14:50:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53719 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727309AbfLaTui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 14:50:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577821837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=M+53FKUSFJZuD1Vu9mqRZyQW9gwqP3mwr3iym43AjaI=;
        b=Lo80zyd1t8I7/UH4+wenPZRSHfZ65vhAflczf0S1shF5fPJCZ+jp/eT70f/liRVFr3bU8E
        mXMLTsuc0i6UVzBekpybNwPtasitV/qIBb494YODKBcMf6VRADq+TQ7VoWYyKPiJiG/HP0
        h7i128BzwNUOG8Yy4xuofXAZCpqDaTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-NM1O-prOM3K1k4mqD-ng1Q-1; Tue, 31 Dec 2019 14:50:35 -0500
X-MC-Unique: NM1O-prOM3K1k4mqD-ng1Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE6BD107ACC4;
        Tue, 31 Dec 2019 19:50:33 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-15.phx2.redhat.com [10.3.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A50067673;
        Tue, 31 Dec 2019 19:50:28 +0000 (UTC)
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
Subject: [PATCH ghak90 V8 07/16] audit: add contid support for signalling the audit daemon
Date:   Tue, 31 Dec 2019 14:48:20 -0500
Message-Id: <7d7933d742fdf4a94c84b791906a450b16f2e81f.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
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
 include/linux/audit.h       |  7 +++++++
 include/uapi/linux/audit.h  |  1 +
 kernel/audit.c              | 35 +++++++++++++++++++++++++++++++++++
 kernel/audit.h              |  1 +
 security/selinux/nlmsgtab.c |  1 +
 5 files changed, 45 insertions(+)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 2636b0ad0011..6929a02080f7 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -22,6 +22,13 @@ struct audit_sig_info {
 	char		ctx[0];
 };
 
+struct audit_sig_info2 {
+	uid_t		uid;
+	pid_t		pid;
+	u64		cid;
+	char		ctx[0];
+};
+
 struct audit_buffer;
 struct audit_context;
 struct inode;
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 93417a8af9d0..4f87b06f0acd 100644
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
index 0871c3e5d6df..51159c94041c 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -126,6 +126,14 @@ struct auditd_connection {
 kuid_t		audit_sig_uid = INVALID_UID;
 pid_t		audit_sig_pid = -1;
 u32		audit_sig_sid = 0;
+/* Since the signal information is stored in the record buffer at the
+ * time of the signal, but not retrieved until later, there is a chance
+ * that the last process in the container could terminate before the
+ * signal record is delivered.  In this circumstance, there is a chance
+ * the orchestrator could reuse the audit container identifier, causing
+ * an overlap of audit records that refer to the same audit container
+ * identifier, but a different container instance.  */
+u64		audit_sig_cid = AUDIT_CID_UNSET;
 
 /* Records can be lost in several ways:
    0) [suppressed in audit_alloc]
@@ -1123,6 +1131,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	case AUDIT_ADD_RULE:
 	case AUDIT_DEL_RULE:
 	case AUDIT_SIGNAL_INFO:
+	case AUDIT_SIGNAL_INFO2:
 	case AUDIT_TTY_GET:
 	case AUDIT_TTY_SET:
 	case AUDIT_TRIM:
@@ -1286,6 +1295,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct audit_buffer	*ab;
 	u16			msg_type = nlh->nlmsg_type;
 	struct audit_sig_info   *sig_data;
+	struct audit_sig_info2  *sig_data2;
 	char			*ctx = NULL;
 	u32			len;
 
@@ -1545,6 +1555,30 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				 sig_data, sizeof(*sig_data) + len);
 		kfree(sig_data);
 		break;
+	case AUDIT_SIGNAL_INFO2:
+		len = 0;
+		if (audit_sig_sid) {
+			err = security_secid_to_secctx(audit_sig_sid, &ctx, &len);
+			if (err)
+				return err;
+		}
+		sig_data2 = kmalloc(sizeof(*sig_data2) + len, GFP_KERNEL);
+		if (!sig_data2) {
+			if (audit_sig_sid)
+				security_release_secctx(ctx, len);
+			return -ENOMEM;
+		}
+		sig_data2->uid = from_kuid(&init_user_ns, audit_sig_uid);
+		sig_data2->pid = audit_sig_pid;
+		if (audit_sig_sid) {
+			memcpy(sig_data2->ctx, ctx, len);
+			security_release_secctx(ctx, len);
+		}
+		sig_data2->cid = audit_sig_cid;
+		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO2, 0, 0,
+				 sig_data2, sizeof(*sig_data2) + len);
+		kfree(sig_data2);
+		break;
 	case AUDIT_TTY_GET: {
 		struct audit_tty_status s;
 		unsigned int t;
@@ -2414,6 +2448,7 @@ int audit_signal_info(int sig, struct task_struct *t)
 		else
 			audit_sig_uid = uid;
 		security_task_getsecid(current, &audit_sig_sid);
+		audit_sig_cid = audit_get_contid(current);
 	}
 
 	return audit_signal_info_syscall(t);
diff --git a/kernel/audit.h b/kernel/audit.h
index 162de8366b32..de358ac61587 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -346,6 +346,7 @@ static inline int audit_signal_info_syscall(struct task_struct *t)
 extern pid_t audit_sig_pid;
 extern kuid_t audit_sig_uid;
 extern u32 audit_sig_sid;
+extern u64 audit_sig_cid;
 
 extern int audit_filter(int msgtype, unsigned int listtype);
 
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index c97fdae8f71b..f006d8b70b65 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -134,6 +134,7 @@ struct nlmsg_perm {
 	{ AUDIT_DEL_RULE,	NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
 	{ AUDIT_USER,		NETLINK_AUDIT_SOCKET__NLMSG_RELAY    },
 	{ AUDIT_SIGNAL_INFO,	NETLINK_AUDIT_SOCKET__NLMSG_READ     },
+	{ AUDIT_SIGNAL_INFO2,	NETLINK_AUDIT_SOCKET__NLMSG_READ     },
 	{ AUDIT_TRIM,		NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
 	{ AUDIT_MAKE_EQUIV,	NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
 	{ AUDIT_TTY_GET,	NETLINK_AUDIT_SOCKET__NLMSG_READ     },
-- 
1.8.3.1

