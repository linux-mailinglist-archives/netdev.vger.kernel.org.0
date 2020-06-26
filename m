Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4466A20B6F5
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgFZR1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:27:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56783 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727849AbgFZR1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593192432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Z0IXRyEpwBuOk7MlE0KV2NeB6CYqPOaO4j/ojLi/Bg=;
        b=T7nXaGtDOJK2kGM6nPsi7oVsd7v4PH9kAcv6R9MSozoqHMW1Xe/KzANRQHhk0XVM/jXYpf
        gMfjPUHQRR7dEPEytEJS0YJK4bOxC3zhLTWjU/6nbXQwqLItaD5RbGqHdGuW+4UcysqeaA
        1lmv/FQvtErMH6vUWpS3oQfxWwKUGMk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-iR78Q-A7O4mvRgfsjXdCtg-1; Fri, 26 Jun 2020 13:27:09 -0400
X-MC-Unique: iR78Q-A7O4mvRgfsjXdCtg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E373800D5C;
        Fri, 26 Jun 2020 17:27:08 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-115-78.rdu2.redhat.com [10.10.115.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE9B18FF83;
        Fri, 26 Jun 2020 17:27:06 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, teigland@redhat.com, ccaulfie@redhat.com,
        cluster-devel@redhat.com, netdev@vger.kernel.org,
        Alexander Aring <aahringo@redhat.com>
Subject: [PATCHv2 dlm-next 2/3] fs: dlm: set skb mark for listen socket
Date:   Fri, 26 Jun 2020 13:26:49 -0400
Message-Id: <20200626172650.115224-3-aahringo@redhat.com>
In-Reply-To: <20200626172650.115224-1-aahringo@redhat.com>
References: <20200626172650.115224-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support to set the skb mark value for the DLM listen
tcp and sctp sockets. The mark value will be offered as cluster
configuration. At creation time of the listen socket it will be set as
socket option.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/config.c   | 6 ++++++
 fs/dlm/config.h   | 1 +
 fs/dlm/lowcomms.c | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index aee1be86adbdc..6dce6ec58d74f 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -73,6 +73,7 @@ struct dlm_cluster {
 	unsigned int cl_log_debug;
 	unsigned int cl_log_info;
 	unsigned int cl_protocol;
+	unsigned int cl_mark;
 	unsigned int cl_timewarn_cs;
 	unsigned int cl_waitwarn_us;
 	unsigned int cl_waitplock_recovery;
@@ -97,6 +98,7 @@ enum {
 	CLUSTER_ATTR_LOG_DEBUG,
 	CLUSTER_ATTR_LOG_INFO,
 	CLUSTER_ATTR_PROTOCOL,
+	CLUSTER_ATTR_MARK,
 	CLUSTER_ATTR_TIMEWARN_CS,
 	CLUSTER_ATTR_WAITWARN_US,
 	CLUSTER_ATTR_WAITPLOCK_RECOVERY,
@@ -170,6 +172,7 @@ CLUSTER_ATTR(scan_secs, 1);
 CLUSTER_ATTR(log_debug, 0);
 CLUSTER_ATTR(log_info, 0);
 CLUSTER_ATTR(protocol, 0);
+CLUSTER_ATTR(mark, 0);
 CLUSTER_ATTR(timewarn_cs, 1);
 CLUSTER_ATTR(waitwarn_us, 0);
 CLUSTER_ATTR(waitplock_recovery, 0);
@@ -186,6 +189,7 @@ static struct configfs_attribute *cluster_attrs[] = {
 	[CLUSTER_ATTR_LOG_DEBUG] = &cluster_attr_log_debug,
 	[CLUSTER_ATTR_LOG_INFO] = &cluster_attr_log_info,
 	[CLUSTER_ATTR_PROTOCOL] = &cluster_attr_protocol,
+	[CLUSTER_ATTR_MARK] = &cluster_attr_mark,
 	[CLUSTER_ATTR_TIMEWARN_CS] = &cluster_attr_timewarn_cs,
 	[CLUSTER_ATTR_WAITWARN_US] = &cluster_attr_waitwarn_us,
 	[CLUSTER_ATTR_WAITPLOCK_RECOVERY] = &cluster_attr_waitplock_recovery,
@@ -859,6 +863,7 @@ int dlm_our_addr(struct sockaddr_storage *addr, int num)
 #define DEFAULT_LOG_DEBUG          0
 #define DEFAULT_LOG_INFO           1
 #define DEFAULT_PROTOCOL           0
+#define DEFAULT_MARK               0
 #define DEFAULT_TIMEWARN_CS      500 /* 5 sec = 500 centiseconds */
 #define DEFAULT_WAITWARN_US	   0
 #define DEFAULT_WAITPLOCK_RECOVERY 0
@@ -876,6 +881,7 @@ struct dlm_config_info dlm_config = {
 	.ci_log_debug = DEFAULT_LOG_DEBUG,
 	.ci_log_info = DEFAULT_LOG_INFO,
 	.ci_protocol = DEFAULT_PROTOCOL,
+	.ci_mark = DEFAULT_MARK,
 	.ci_timewarn_cs = DEFAULT_TIMEWARN_CS,
 	.ci_waitwarn_us = DEFAULT_WAITWARN_US,
 	.ci_waitplock_recovery = DEFAULT_WAITPLOCK_RECOVERY,
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index 0cf824367668c..bc94123ac305a 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -31,6 +31,7 @@ struct dlm_config_info {
 	int ci_log_debug;
 	int ci_log_info;
 	int ci_protocol;
+	int ci_mark;
 	int ci_timewarn_cs;
 	int ci_waitwarn_us;
 	int ci_waitplock_recovery;
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 3543a8fec9075..eaedad7d069a8 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1111,6 +1111,8 @@ static struct socket *tcp_create_listen_sock(struct connection *con,
 		goto create_out;
 	}
 
+	sock_set_mark(sock->sk, dlm_config.ci_mark);
+
 	/* Turn off Nagle's algorithm */
 	tcp_sock_set_nodelay(sock->sk);
 
@@ -1185,6 +1187,7 @@ static int sctp_listen_for_all(void)
 	}
 
 	sock_set_rcvbuf(sock->sk, NEEDED_RMEM);
+	sock_set_mark(sock->sk, dlm_config.ci_mark);
 	sctp_sock_set_nodelay(sock->sk);
 
 	write_lock_bh(&sock->sk->sk_callback_lock);
-- 
2.26.2

