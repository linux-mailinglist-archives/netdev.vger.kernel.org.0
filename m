Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E942C20C195
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 15:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgF0NXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 09:23:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33475 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726865AbgF0NXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 09:23:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593264182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=tPpITunFHHYrcdgkS8NMc5qG45e+XjOoU0/iyAqJAFs=;
        b=A/iMNmMKMSjzMFeay2pD1zBjr3L7Afd7tqnjpUBf7Kg/W4o+JdMKGFhVL0VnkSsls3VNir
        vWdrhKBPg8xtmK2NvA90vwFDnUIbn7wBcDA6LKNu2musQt6d+HlaDtAYWDClPi5KJSkg/3
        FRrXVWtTKiryhH//eqjIfr+vDhQ7f9s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-qHRZtAcSO1e6JqqbOV4o6Q-1; Sat, 27 Jun 2020 09:22:58 -0400
X-MC-Unique: qHRZtAcSO1e6JqqbOV4o6Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 985B680058A;
        Sat, 27 Jun 2020 13:22:56 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5413C71662;
        Sat, 27 Jun 2020 13:22:45 +0000 (UTC)
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
Subject: [PATCH ghak90 V9 08/13] audit: add containerid support for user records
Date:   Sat, 27 Jun 2020 09:20:41 -0400
Message-Id: <4a5019ed3cfab416aeb6549b791ac6d8cc9fb8b7.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add audit container identifier auxiliary record to user event standalone
records.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 kernel/audit.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 54dd2cb69402..997c34178ee8 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1212,12 +1212,6 @@ static void audit_log_common_recv_msg(struct audit_context *context,
 	audit_log_task_context(*ab);
 }
 
-static inline void audit_log_user_recv_msg(struct audit_buffer **ab,
-					   u16 msg_type)
-{
-	audit_log_common_recv_msg(NULL, ab, msg_type);
-}
-
 int is_audit_feature_set(int i)
 {
 	return af.features & AUDIT_FEATURE_TO_MASK(i);
@@ -1486,6 +1480,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		err = audit_filter(msg_type, AUDIT_FILTER_USER);
 		if (err == 1) { /* match or error */
 			char *str = data;
+			struct audit_context *context;
+			struct audit_contobj *cont;
 
 			err = 0;
 			if (msg_type == AUDIT_USER_TTY) {
@@ -1493,7 +1489,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				if (err)
 					break;
 			}
-			audit_log_user_recv_msg(&ab, msg_type);
+			context = audit_alloc_local(GFP_KERNEL);
+			audit_log_common_recv_msg(context, &ab, msg_type);
 			if (msg_type != AUDIT_USER_TTY) {
 				/* ensure NULL termination */
 				str[data_len - 1] = '\0';
@@ -1507,6 +1504,14 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				audit_log_n_untrustedstring(ab, str, data_len);
 			}
 			audit_log_end(ab);
+			rcu_read_lock();
+			cont = _audit_contobj_get(current);
+			rcu_read_unlock();
+			audit_log_container_id(context, cont);
+			rcu_read_lock();
+			_audit_contobj_put(cont);
+			rcu_read_unlock();
+			audit_free_context(context);
 		}
 		break;
 	case AUDIT_ADD_RULE:
-- 
1.8.3.1

