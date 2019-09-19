Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAEFB70DC
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 03:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387928AbfISB06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 21:26:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730815AbfISB05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 21:26:57 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5ADC28553F;
        Thu, 19 Sep 2019 01:26:56 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C40460C80;
        Thu, 19 Sep 2019 01:26:42 +0000 (UTC)
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
Subject: [PATCH ghak90 V7 16/21] audit: add support for contid set/get by netlink
Date:   Wed, 18 Sep 2019 21:22:33 -0400
Message-Id: <ea4e8352fd1671f91d1b015a15abee785ea17136.1568834525.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 19 Sep 2019 01:26:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ability to get and set the audit container identifier using an
audit netlink message using message types AUDIT_SET_CONTID 1023 and
AUDIT_GET_CONTID 1022 in addition to using the proc filesystem.  The
message format includes the data structure:

struct audit_contid_status {
       pid_t   pid;
       u64     id;
};

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/uapi/linux/audit.h |  2 ++
 kernel/audit.c             | 40 ++++++++++++++++++++++++++++++++++++++++
 kernel/audit.h             |  5 +++++
 3 files changed, 47 insertions(+)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index f34108759e8f..e26729fc9943 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -73,6 +73,8 @@
 #define AUDIT_GET_FEATURE	1019	/* Get which features are enabled */
 #define AUDIT_CONTAINER_OP	1020	/* Define the container id and info */
 #define AUDIT_SIGNAL_INFO2	1021	/* Get info auditd signal sender */
+#define AUDIT_GET_CONTID	1022	/* Get contid of a task */
+#define AUDIT_SET_CONTID	1023	/* Set contid of a task */
 
 #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly uninteresting to kernel */
 #define AUDIT_USER_AVC		1107	/* We filter this differently */
diff --git a/kernel/audit.c b/kernel/audit.c
index 4fe7678304dd..df92de20ed73 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1216,6 +1216,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	case AUDIT_TTY_SET:
 	case AUDIT_TRIM:
 	case AUDIT_MAKE_EQUIV:
+	case AUDIT_GET_CONTID:
+	case AUDIT_SET_CONTID:
 		/* Only support auditd and auditctl in initial pid namespace
 		 * for now. */
 		if (task_active_pid_ns(current) != &init_pid_ns)
@@ -1273,6 +1275,23 @@ static int audit_get_feature(struct sk_buff *skb)
 	return 0;
 }
 
+static int audit_get_contid_status(struct sk_buff *skb)
+{
+	struct nlmsghdr *nlh = nlmsg_hdr(skb);
+	u32 seq = nlh->nlmsg_seq;
+	void *data = nlmsg_data(nlh);
+	struct audit_contid_status cs;
+
+	cs.pid = ((struct audit_contid_status *)data)->pid;
+	if (!cs.pid)
+		cs.pid = task_tgid_nr(current);
+	rcu_read_lock();
+	cs.id = audit_get_contid(find_task_by_vpid(cs.pid));
+	rcu_read_unlock();
+	audit_send_reply(skb, seq, AUDIT_GET_CONTID, 0, 0, &cs, sizeof(cs));
+	return 0;
+}
+
 static void audit_log_feature_change(int which, u32 old_feature, u32 new_feature,
 				     u32 old_lock, u32 new_lock, int res)
 {
@@ -1700,6 +1719,27 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		audit_log_end(ab);
 		break;
 	}
+	case AUDIT_SET_CONTID: {
+		struct audit_contid_status *s = data;
+		struct task_struct *tsk;
+
+		/* check if new data is valid */
+		if (nlmsg_len(nlh) < sizeof(*s))
+			return -EINVAL;
+		tsk = find_get_task_by_vpid(s->pid);
+		if (!tsk)
+			return -EINVAL;
+
+		err = audit_set_contid(tsk, s->id);
+		put_task_struct(tsk);
+		return err;
+		break;
+	}
+	case AUDIT_GET_CONTID:
+		err = audit_get_contid_status(skb);
+		if (err)
+			return err;
+		break;
 	default:
 		err = -EINVAL;
 		break;
diff --git a/kernel/audit.h b/kernel/audit.h
index c9b73abfd6a0..25732fbc47a4 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -224,6 +224,11 @@ static inline int audit_hash_contid(u64 contid)
 
 #define AUDIT_CONTID_COUNT	1 << 16
 
+struct audit_contid_status {
+	pid_t	pid;
+	u64	id;
+};
+
 /* Indicates that audit should log the full pathname. */
 #define AUDIT_NAME_FULL -1
 
-- 
1.8.3.1

