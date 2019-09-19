Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C328B7087
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 03:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731885AbfISBYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 21:24:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbfISBYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 21:24:24 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 744B03082131;
        Thu, 19 Sep 2019 01:24:18 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEE7560C44;
        Thu, 19 Sep 2019 01:24:05 +0000 (UTC)
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
Subject: [PATCH ghak90 V7 05/21] audit: log drop of contid on exit of last task
Date:   Wed, 18 Sep 2019 21:22:22 -0400
Message-Id: <71b75f54342f32f176c2b6d94584f2a666964e68.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 19 Sep 2019 01:24:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we are tracking the life of each audit container indentifier, we
can match the creation event with the destruction event.  Log the
destruction of the audit container identifier when the last process in
that container exits.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c   | 32 ++++++++++++++++++++++++++++++++
 kernel/audit.h   |  2 ++
 kernel/auditsc.c |  2 ++
 3 files changed, 36 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index ea0899130cc1..53d13d638c63 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2503,6 +2503,38 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 	return rc;
 }
 
+void audit_log_container_drop(void)
+{
+	struct audit_buffer *ab;
+	uid_t uid;
+	struct tty_struct *tty;
+	char comm[sizeof(current->comm)];
+
+	if (!current->audit || !current->audit->cont ||
+	    refcount_read(&current->audit->cont->refcount) > 1)
+		return;
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
+	if (!ab)
+		return;
+
+	uid = from_kuid(&init_user_ns, task_uid(current));
+	tty = audit_get_tty();
+	audit_log_format(ab,
+			 "op=drop opid=%d contid=%llu old-contid=%llu pid=%d uid=%u auid=%u tty=%s ses=%u",
+			 task_tgid_nr(current), audit_get_contid(current),
+			 audit_get_contid(current), task_tgid_nr(current), uid,
+			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
+			 tty ? tty_name(tty) : "(none)",
+       			 audit_get_sessionid(current));
+	audit_put_tty(tty);
+	audit_log_task_context(ab);
+	audit_log_format(ab, " comm=");
+	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	audit_log_d_path_exe(ab, current->mm);
+	audit_log_format(ab, " res=1");
+	audit_log_end(ab);
+}
+
 /**
  * audit_log_end - end one audit record
  * @ab: the audit_buffer
diff --git a/kernel/audit.h b/kernel/audit.h
index e4a31aa92dfe..162de8366b32 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -255,6 +255,8 @@ extern void audit_log_d_path_exe(struct audit_buffer *ab,
 extern struct tty_struct *audit_get_tty(void);
 extern void audit_put_tty(struct tty_struct *tty);
 
+extern void audit_log_container_drop(void);
+
 /* audit watch/mark/tree functions */
 #ifdef CONFIG_AUDITSYSCALL
 extern unsigned int audit_serial(void);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 0e2d50533959..bd855794ad26 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1568,6 +1568,8 @@ static void audit_log_exit(void)
 
 	audit_log_proctitle();
 
+	audit_log_container_drop();
+
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
 	if (ab)
-- 
1.8.3.1

