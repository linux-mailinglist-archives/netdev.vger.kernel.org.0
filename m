Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CEC2DFE89
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 18:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgLUQ7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 11:59:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbgLUQ7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 11:59:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608569876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=hvlv5dn5W5SHQ5VeRXP8I3ccn9VUl3gDfEC5nRjfzuM=;
        b=RmRae/mP17HZmZZXMyqZRsLe4qw8L9ryXcSAZoxlhz08Cfg7rPZAwMEsC3jAxZSCVL1oWS
        seRHKsveDISq/u+v0Fp6WI6/Qui/UYnR4RihaCMEYkTrPUcXFUO4v6h+IYIZTsftHlcJHE
        rmwj4+EAsqhssyn58i61yuL55bKVftc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-Luizp1ukMQG4mR2xKEOiww-1; Mon, 21 Dec 2020 11:57:51 -0500
X-MC-Unique: Luizp1ukMQG4mR2xKEOiww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B43D5801817;
        Mon, 21 Dec 2020 16:57:49 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CCAC60C0F;
        Mon, 21 Dec 2020 16:57:28 +0000 (UTC)
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
Subject: [PATCH ghak90 v10 07/11] audit: add containerid filtering
Date:   Mon, 21 Dec 2020 11:55:41 -0500
Message-Id: <8e4ca60dbe485749f9d6ddecb12d498ee54718eb.1608225886.git.rgb@redhat.com>
In-Reply-To: <cover.1608225886.git.rgb@redhat.com>
References: <cover.1608225886.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement audit container identifier filtering using the AUDIT_CONTID
field name to send an 8-character string representing a u64 since the
value field is only u32.

Sending it as two u32 was considered, but gathering and comparing two
fields was more complex.

The feature indicator is AUDIT_FEATURE_BITMAP_CONTAINERID.

Please see the github audit kernel issue for the contid filter feature:
  https://github.com/linux-audit/audit-kernel/issues/91
Please see the github audit userspace issue for filter additions:
  https://github.com/linux-audit/audit-userspace/issues/40
Please see the github audit testsuiite issue for the test case:
  https://github.com/linux-audit/audit-testsuite/issues/64
Please see the github audit wiki for the feature overview:
  https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 include/linux/audit.h      |  1 +
 include/uapi/linux/audit.h |  5 ++++-
 kernel/audit.c             |  5 +++++
 kernel/audit.h             |  3 +++
 kernel/auditfilter.c       | 46 ++++++++++++++++++++++++++++++++++++++
 kernel/auditsc.c           |  3 +++
 6 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 9f0238f7960f..056a7c9a12a2 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -69,6 +69,7 @@ struct audit_field {
 	u32				type;
 	union {
 		u32			val;
+		u64			val64;
 		kuid_t			uid;
 		kgid_t			gid;
 		struct {
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 94dcf3085658..66350e572e41 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -271,6 +271,7 @@
 #define AUDIT_LOGINUID_SET	24
 #define AUDIT_SESSIONID	25	/* Session ID */
 #define AUDIT_FSTYPE	26	/* FileSystem Type */
+#define AUDIT_CONTID	27	/* Container ID */
 
 				/* These are ONLY useful when checking
 				 * at syscall exit time (AUDIT_AT_EXIT). */
@@ -353,6 +354,7 @@ enum {
 #define AUDIT_FEATURE_BITMAP_SESSIONID_FILTER	0x00000010
 #define AUDIT_FEATURE_BITMAP_LOST_RESET		0x00000020
 #define AUDIT_FEATURE_BITMAP_FILTER_FS		0x00000040
+#define AUDIT_FEATURE_BITMAP_CONTAINERID	0x00000080
 
 #define AUDIT_FEATURE_BITMAP_ALL (AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT | \
 				  AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME | \
@@ -360,7 +362,8 @@ enum {
 				  AUDIT_FEATURE_BITMAP_EXCLUDE_EXTEND | \
 				  AUDIT_FEATURE_BITMAP_SESSIONID_FILTER | \
 				  AUDIT_FEATURE_BITMAP_LOST_RESET | \
-				  AUDIT_FEATURE_BITMAP_FILTER_FS)
+				  AUDIT_FEATURE_BITMAP_FILTER_FS | \
+				  AUDIT_FEATURE_BITMAP_CONTAINERID)
 
 /* deprecated: AUDIT_VERSION_* */
 #define AUDIT_VERSION_LATEST 		AUDIT_FEATURE_BITMAP_ALL
diff --git a/kernel/audit.c b/kernel/audit.c
index b23f004f4000..300daf2bcb16 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2488,6 +2488,11 @@ int audit_log_container_id_ctx(struct audit_context *context)
 	return record;
 }
 
+int audit_contid_comparator(struct task_struct *tsk, u32 op, u64 right)
+{
+	return audit_comparator64(audit_get_contid(tsk), op, right);
+}
+
 void audit_log_key(struct audit_buffer *ab, char *key)
 {
 	audit_log_format(ab, " key=");
diff --git a/kernel/audit.h b/kernel/audit.h
index 40e609787a0c..48c429c2d544 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -218,12 +218,15 @@ extern void *audit_contobj_get_bytask(struct task_struct *tsk);
 extern void audit_contobj_put(void **cont, int count);
 extern int audit_log_container_id(struct audit_context *context, void *cont);
 extern int audit_log_container_id_ctx(struct audit_context *context);
+extern int audit_contid_comparator(struct task_struct *tsk, const u32 op,
+				   const u64 right);
 
 /* Indicates that audit should log the full pathname. */
 #define AUDIT_NAME_FULL -1
 
 extern int audit_match_class(int class, unsigned syscall);
 extern int audit_comparator(const u32 left, const u32 op, const u32 right);
+extern int audit_comparator64(const u64 left, const u32 op, const u64 right);
 extern int audit_uid_comparator(kuid_t left, u32 op, kuid_t right);
 extern int audit_gid_comparator(kgid_t left, u32 op, kgid_t right);
 extern int parent_len(const char *path);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 333b3bcfc545..9362ee9cc414 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -399,6 +399,7 @@ static int audit_field_valid(struct audit_entry *entry, struct audit_field *f)
 	case AUDIT_FILETYPE:
 	case AUDIT_FIELD_COMPARE:
 	case AUDIT_EXE:
+	case AUDIT_CONTID:
 		/* only equal and not equal valid ops */
 		if (f->op != Audit_not_equal && f->op != Audit_equal)
 			return -EINVAL;
@@ -590,6 +591,14 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 			entry->rule.buflen += f_val;
 			entry->rule.exe = audit_mark;
 			break;
+		case AUDIT_CONTID:
+			if (f_val != sizeof(u64))
+				goto exit_free;
+			str = audit_unpack_string(&bufp, &remain, f_val);
+			if (IS_ERR(str))
+				goto exit_free;
+			f->val64 = ((u64 *)str)[0];
+			break;
 		default:
 			f->val = f_val;
 			break;
@@ -675,6 +684,11 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
 			data->buflen += data->values[i] =
 				audit_pack_string(&bufp, audit_mark_path(krule->exe));
 			break;
+		case AUDIT_CONTID:
+			data->buflen += data->values[i] = sizeof(u64);
+			memcpy(bufp, &f->val64, sizeof(u64));
+			bufp += sizeof(u64);
+			break;
 		case AUDIT_LOGINUID_SET:
 			if (krule->pflags & AUDIT_LOGINUID_LEGACY && !f->val) {
 				data->fields[i] = AUDIT_LOGINUID;
@@ -761,6 +775,10 @@ static int audit_compare_rule(struct audit_krule *a, struct audit_krule *b)
 			if (!gid_eq(a->fields[i].gid, b->fields[i].gid))
 				return 1;
 			break;
+		case AUDIT_CONTID:
+			if (a->fields[i].val64 != b->fields[i].val64)
+				return 1;
+			break;
 		default:
 			if (a->fields[i].val != b->fields[i].val)
 				return 1;
@@ -1216,6 +1234,30 @@ int audit_comparator(u32 left, u32 op, u32 right)
 	}
 }
 
+int audit_comparator64(u64 left, u32 op, u64 right)
+{
+	switch (op) {
+	case Audit_equal:
+		return (left == right);
+	case Audit_not_equal:
+		return (left != right);
+	case Audit_lt:
+		return (left < right);
+	case Audit_le:
+		return (left <= right);
+	case Audit_gt:
+		return (left > right);
+	case Audit_ge:
+		return (left >= right);
+	case Audit_bitmask:
+		return (left & right);
+	case Audit_bittest:
+		return ((left & right) == right);
+	default:
+		return 0;
+	}
+}
+
 int audit_uid_comparator(kuid_t left, u32 op, kuid_t right)
 {
 	switch (op) {
@@ -1350,6 +1392,10 @@ int audit_filter(int msgtype, unsigned int listtype)
 				result = audit_comparator(audit_loginuid_set(current),
 							  f->op, f->val);
 				break;
+			case AUDIT_CONTID:
+				result = audit_contid_comparator(current, f->op,
+								 f->val64);
+				break;
 			case AUDIT_MSGTYPE:
 				result = audit_comparator(msgtype, f->op, f->val);
 				break;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index df26d0aa5e6d..7ef5502e8ef3 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -656,6 +656,9 @@ static int audit_filter_rules(struct task_struct *tsk,
 				result = audit_comparator(ctx->sockaddr->ss_family,
 							  f->op, f->val);
 			break;
+		case AUDIT_CONTID:
+			result = audit_contid_comparator(tsk, f->op, f->val64);
+			break;
 		case AUDIT_SUBJ_USER:
 		case AUDIT_SUBJ_ROLE:
 		case AUDIT_SUBJ_TYPE:
-- 
2.18.4

