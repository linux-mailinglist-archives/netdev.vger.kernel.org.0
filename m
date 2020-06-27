Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A6F20C17D
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 15:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgF0NWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 09:22:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51840 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726732AbgF0NWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 09:22:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593264140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=5daVVav2vz0gUbxpNuM5DjXpFZAkaJD7gM4Gto+ga3s=;
        b=BVyBXNhcnP35zDXKprkkUTGNqfXwucm4JcBx2AUFVIMk9VgQmIRpu107qV6pAr1cX36Xs5
        58CIlI5BSLdScEG0in928cvqcP4W5OmLkQEpCaOtMF34pGUGLIveMwOmMiGA7V+Hit1492
        Aqfk7iJ0OHiYnrSxqmfA2OrsxpQep7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-8o6uA2f7NH-45B6dJFcCKA-1; Sat, 27 Jun 2020 09:22:14 -0400
X-MC-Unique: 8o6uA2f7NH-45B6dJFcCKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F10D8015FD;
        Sat, 27 Jun 2020 13:22:13 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7FAC57932A;
        Sat, 27 Jun 2020 13:22:08 +0000 (UTC)
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
Subject: [PATCH ghak90 V9 04/13] audit: log drop of contid on exit of last task
Date:   Sat, 27 Jun 2020 09:20:37 -0400
Message-Id: <e9310d6d9d909f4ac7ef1b688fbb0263711f9a24.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 kernel/audit.c   | 20 ++++++++++++++++++++
 kernel/audit.h   |  2 ++
 kernel/auditsc.c |  2 ++
 3 files changed, 24 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 6d387793f702..9e0b38ce1ead 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2558,6 +2558,26 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 	return rc;
 }
 
+void audit_log_container_drop(void)
+{
+	struct audit_buffer *ab;
+	struct audit_contobj *cont;
+
+	rcu_read_lock();
+	cont = _audit_contobj_get(current);
+	_audit_contobj_put(cont);
+	if (!cont || refcount_read(&cont->refcount) > 1)
+		goto out;
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
+	if (!ab)
+		goto out;
+	audit_log_format(ab, "op=drop opid=%d contid=%llu old-contid=%llu",
+			 task_tgid_nr(current), cont->id, cont->id);
+	audit_log_end(ab);
+out:
+	rcu_read_unlock();
+}
+
 /**
  * audit_log_end - end one audit record
  * @ab: the audit_buffer
diff --git a/kernel/audit.h b/kernel/audit.h
index 182fc76ea276..d07093903008 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -254,6 +254,8 @@ extern void audit_log_d_path_exe(struct audit_buffer *ab,
 extern struct tty_struct *audit_get_tty(void);
 extern void audit_put_tty(struct tty_struct *tty);
 
+extern void audit_log_container_drop(void);
+
 /* audit watch/mark/tree functions */
 #ifdef CONFIG_AUDITSYSCALL
 extern unsigned int audit_serial(void);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f00c1da587ea..f03d3eb0752c 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1575,6 +1575,8 @@ static void audit_log_exit(void)
 
 	audit_log_proctitle();
 
+	audit_log_container_drop();
+
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
 	if (ab)
-- 
1.8.3.1

