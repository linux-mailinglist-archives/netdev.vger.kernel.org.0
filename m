Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3C420B6F4
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgFZR1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:27:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25763 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725833AbgFZR1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:27:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593192432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iWYuP09XL9VKlZ0yFTQH9Gd93urAoYAH5xWp/K1DFHA=;
        b=TUPBOKSarmNoFWjFtJ79HrgMSxHAMMEKgvRcrjReSbfQCr6KNab77ekOsRVaoXot9v+jgM
        wM3VMsstChWzZu2W/+PQTZjSMS4SWh51DBhmUXYSa77xFkxniDxdaLyqAXgpyppIEG5aW9
        /bjk1vH1B6yptUiGw2T+JumA4yKwWdU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-XURN88GTPv6xJbHk25ivlw-1; Fri, 26 Jun 2020 13:27:10 -0400
X-MC-Unique: XURN88GTPv6xJbHk25ivlw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAEB0107ACF2;
        Fri, 26 Jun 2020 17:27:09 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-115-78.rdu2.redhat.com [10.10.115.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D17081C8;
        Fri, 26 Jun 2020 17:27:08 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, teigland@redhat.com, ccaulfie@redhat.com,
        cluster-devel@redhat.com, netdev@vger.kernel.org,
        Alexander Aring <aahringo@redhat.com>
Subject: [PATCHv2 dlm-next 3/3] fs: dlm: set skb mark per peer socket
Date:   Fri, 26 Jun 2020 13:26:50 -0400
Message-Id: <20200626172650.115224-4-aahringo@redhat.com>
In-Reply-To: <20200626172650.115224-1-aahringo@redhat.com>
References: <20200626172650.115224-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support to set the skb mark value for the DLM tcp and
sctp socket per peer. The mark value will be offered as per comm value
of configfs. At creation time of the peer socket it will be set as
socket option.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/config.c   | 38 ++++++++++++++++++++++++++++++++++++++
 fs/dlm/config.h   |  1 +
 fs/dlm/lowcomms.c | 16 ++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 6dce6ec58d74f..eac241ed9003e 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -204,6 +204,7 @@ enum {
 	COMM_ATTR_LOCAL,
 	COMM_ATTR_ADDR,
 	COMM_ATTR_ADDR_LIST,
+	COMM_ATTR_MARK,
 };
 
 enum {
@@ -236,6 +237,7 @@ struct dlm_comm {
 	int nodeid;
 	int local;
 	int addr_count;
+	unsigned int mark;
 	struct sockaddr_storage *addr[DLM_MAX_ADDR_COUNT];
 };
 
@@ -473,6 +475,7 @@ static struct config_item *make_comm(struct config_group *g, const char *name)
 	cm->nodeid = -1;
 	cm->local = 0;
 	cm->addr_count = 0;
+	cm->mark = 0;
 	return &cm->item;
 }
 
@@ -668,8 +671,28 @@ static ssize_t comm_addr_list_show(struct config_item *item, char *buf)
 	return 4096 - allowance;
 }
 
+static ssize_t comm_mark_show(struct config_item *item, char *buf)
+{
+	return sprintf(buf, "%u\n", config_item_to_comm(item)->mark);
+}
+
+static ssize_t comm_mark_store(struct config_item *item, const char *buf,
+			       size_t len)
+{
+	unsigned int mark;
+	int rc;
+
+	rc = kstrtouint(buf, 0, &mark);
+	if (rc)
+		return rc;
+
+	config_item_to_comm(item)->mark = mark;
+	return len;
+}
+
 CONFIGFS_ATTR(comm_, nodeid);
 CONFIGFS_ATTR(comm_, local);
+CONFIGFS_ATTR(comm_, mark);
 CONFIGFS_ATTR_WO(comm_, addr);
 CONFIGFS_ATTR_RO(comm_, addr_list);
 
@@ -678,6 +701,7 @@ static struct configfs_attribute *comm_attrs[] = {
 	[COMM_ATTR_LOCAL] = &comm_attr_local,
 	[COMM_ATTR_ADDR] = &comm_attr_addr,
 	[COMM_ATTR_ADDR_LIST] = &comm_attr_addr_list,
+	[COMM_ATTR_MARK] = &comm_attr_mark,
 	NULL,
 };
 
@@ -837,6 +861,20 @@ int dlm_comm_seq(int nodeid, uint32_t *seq)
 	return 0;
 }
 
+int dlm_comm_mark(int nodeid, unsigned int *mark)
+{
+	struct dlm_comm *cm;
+
+	cm = get_comm(nodeid);
+	if (!cm)
+		return -ENOENT;
+
+	*mark = cm->mark;
+	put_comm(cm);
+
+	return 0;
+}
+
 int dlm_our_nodeid(void)
 {
 	return local_comm ? local_comm->nodeid : 0;
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index bc94123ac305a..48b4055fd07ff 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -47,6 +47,7 @@ void dlm_config_exit(void);
 int dlm_config_nodes(char *lsname, struct dlm_config_node **nodes_out,
 		     int *count_out);
 int dlm_comm_seq(int nodeid, uint32_t *seq);
+int dlm_comm_mark(int nodeid, unsigned int *mark);
 int dlm_our_nodeid(void);
 int dlm_our_addr(struct sockaddr_storage *addr, int num);
 
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index eaedad7d069a8..3fa1b93dbbc7e 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -914,6 +914,7 @@ static void sctp_connect_to_sock(struct connection *con)
 	int result;
 	int addr_len;
 	struct socket *sock;
+	unsigned int mark;
 
 	if (con->nodeid == 0) {
 		log_print("attempt to connect sock 0 foiled");
@@ -944,6 +945,13 @@ static void sctp_connect_to_sock(struct connection *con)
 	if (result < 0)
 		goto socket_err;
 
+	/* set skb mark */
+	result = dlm_comm_mark(con->nodeid, &mark);
+	if (result < 0)
+		goto bind_err;
+
+	sock_set_mark(sock->sk, mark);
+
 	con->rx_action = receive_from_sock;
 	con->connect_action = sctp_connect_to_sock;
 	add_sock(sock, con);
@@ -1006,6 +1014,7 @@ static void tcp_connect_to_sock(struct connection *con)
 	struct sockaddr_storage saddr, src_addr;
 	int addr_len;
 	struct socket *sock = NULL;
+	unsigned int mark;
 	int result;
 
 	if (con->nodeid == 0) {
@@ -1027,6 +1036,13 @@ static void tcp_connect_to_sock(struct connection *con)
 	if (result < 0)
 		goto out_err;
 
+	/* set skb mark */
+	result = dlm_comm_mark(con->nodeid, &mark);
+	if (result < 0)
+		goto out_err;
+
+	sock_set_mark(sock->sk, mark);
+
 	memset(&saddr, 0, sizeof(saddr));
 	result = nodeid_to_addr(con->nodeid, &saddr, NULL, false);
 	if (result < 0) {
-- 
2.26.2

