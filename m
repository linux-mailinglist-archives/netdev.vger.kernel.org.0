Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74DC812DB5F
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 20:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfLaTu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 14:50:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54937 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727131AbfLaTu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 14:50:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577821827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=dYLFebO7Nz/+L/j7pFidpPYSEMoE0mW9HUxNFhbJkxM=;
        b=diStnZEzFxsH4OKprCgxtJkCUliRzgjZmzLggRJDBqFi8lwAPmszEdfAabXIn7mj1qrEhX
        TCmB0BbVRMNYJzTFFWBQlfixXB3O2WyWEZ/krhsQuuT6XwqwX4W+zAr04VZbiklo3L25lv
        VN5DSGsH/rzJS7Vzr5iRuk/vzqW78SI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-6svUkfjhObCFr0X2n-EPDA-1; Tue, 31 Dec 2019 14:50:26 -0500
X-MC-Unique: 6svUkfjhObCFr0X2n-EPDA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B66AF800EB8;
        Tue, 31 Dec 2019 19:50:23 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-15.phx2.redhat.com [10.3.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D82F82093;
        Tue, 31 Dec 2019 19:50:12 +0000 (UTC)
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
Subject: [PATCH ghak90 V8 05/16] audit: log drop of contid on exit of last task
Date:   Tue, 31 Dec 2019 14:48:18 -0500
Message-Id: <b3725abab452beaba740ac58f76144e6c3bda2fa.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 kernel/audit.c   | 17 +++++++++++++++++
 kernel/audit.h   |  2 ++
 kernel/auditsc.c |  2 ++
 3 files changed, 21 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 4bab20f5f781..fa8f1aa3a605 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2502,6 +2502,23 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 	return rc;
 }
 
+void audit_log_container_drop(void)
+{
+	struct audit_buffer *ab;
+
+	if (!current->audit || !current->audit->cont ||
+	    refcount_read(&current->audit->cont->refcount) > 1)
+		return;
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
+	if (!ab)
+		return;
+
+	audit_log_format(ab, "op=drop opid=%d contid=%llu old-contid=%llu",
+			 task_tgid_nr(current), audit_get_contid(current),
+			 audit_get_contid(current));
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

