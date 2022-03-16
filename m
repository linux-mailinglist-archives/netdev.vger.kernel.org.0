Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933DB4DB83A
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351348AbiCPSyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347174AbiCPSya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:54:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 02B6017ABF
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 11:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647456795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X6zGMC3nbwZW3aXejynoj44csXVgO7AoCYMrADM6mcs=;
        b=cgf7ysBpD6wMHMKrW6yfy5cFWYT7r9lFWO84o8d+ZzsUKykRpSWshqGwioxhyY/oACUPKJ
        Cte0k3UIl34MWQwe4HB3WQ1zEbFVZ+9b8iO4BtxUFcXGeq3i9cG7OlLcnPsD8MU8CdWv3+
        3j2AtojCNkl3PBAPg5PXVs8uxRxkpfo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-vHM-tj4ZPGG6nBRXUsy5hA-1; Wed, 16 Mar 2022 14:53:11 -0400
X-MC-Unique: vHM-tj4ZPGG6nBRXUsy5hA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A2BE82A682;
        Wed, 16 Mar 2022 18:53:11 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.195.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87392434823;
        Wed, 16 Mar 2022 18:53:10 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2-next 2/2] ss: remove an implicit dependency on rpcinfo
Date:   Wed, 16 Mar 2022 19:52:14 +0100
Message-Id: <0255344054d5251c29cdcb6d3bfa404c3c39609b.1647455133.git.aclaudi@redhat.com>
In-Reply-To: <cover.1647455133.git.aclaudi@redhat.com>
References: <cover.1647455133.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ss uses rpcinfo to get info about rpc services socket. This makes it
dependent on a tool not included in iproute2, and makes it impossible to
get info on rpc sockets if rpcinfo is not installed.

This reworks init_service_resolver() to use libtirpc, thus avoiding the
implicity dependency on rpcinfo. Moreover, this also makes it possible
to display info about ipv6 rpc socket that are not included in the
rpcinfo -p output.

For example, before this patch:
$ ss -rtap
LISTEN          0               5                                                        localhost:ipp                                        [::]:*                     users:(("cupsd",pid=1600,fd=9))
LISTEN          0               64                                                            [::]:34265                                      [::]:*
LISTEN          0               64                                                            [::]:rpc.nfs_acl                                [::]:*
LISTEN          0               128                                                           [::]:42253                                      [::]:*                     users:(("rpc.statd",pid=146164,fd=12))

After this patch:
$ ss -rtap
LISTEN          0               5                                                        localhost:ipp                                        [::]:*                     users:(("cupsd",pid=1600,fd=9))
LISTEN          0               64                                                            [::]:rpc.nlockmgr                               [::]:*
LISTEN          0               64                                                            [::]:rpc.nfs_acl                                [::]:*
LISTEN          0               128                                                           [::]:rpc.status                                 [::]:*                     users:(("rpc.statd",pid=146164,fd=12))

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 misc/ss.c | 93 +++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 73 insertions(+), 20 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index 5e7e84ee..4b3ca9c4 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -55,6 +55,11 @@
 #include <linux/tls.h>
 #include <linux/mptcp.h>
 
+#if HAVE_RPC
+#include <rpc/rpc.h>
+#include <rpc/xdr.h>
+#endif
+
 /* AF_VSOCK/PF_VSOCK is only provided since glibc 2.18 */
 #ifndef PF_VSOCK
 #define PF_VSOCK 40
@@ -192,8 +197,12 @@ static struct {
 } buffer;
 
 static const char *TCP_PROTO = "tcp";
-static const char *SCTP_PROTO = "sctp";
 static const char *UDP_PROTO = "udp";
+#ifdef HAVE_RPC
+static const char *TCP6_PROTO = "tcp6";
+static const char *UDP6_PROTO = "udp6";
+static const char *SCTP_PROTO = "sctp";
+#endif
 static const char *RAW_PROTO = "raw";
 static const char *dg_proto;
 
@@ -1479,45 +1488,87 @@ struct scache {
 
 static struct scache *rlist;
 
+#ifdef HAVE_RPC
+static CLIENT *rpc_client_create(rpcprog_t prog, rpcvers_t vers)
+{
+	struct netbuf nbuf;
+	struct sockaddr_un saddr;
+	int sock;
+
+	memset(&saddr, 0, sizeof(saddr));
+	sock = socket(AF_LOCAL, SOCK_STREAM, 0);
+	if (sock < 0)
+		return NULL;
+
+	saddr.sun_family = AF_LOCAL;
+	strcpy(saddr.sun_path, _PATH_RPCBINDSOCK);
+	nbuf.len = SUN_LEN(&saddr);
+	nbuf.maxlen = sizeof(struct sockaddr_un);
+	nbuf.buf = &saddr;
+
+	return clnt_vc_create(sock, &nbuf, prog, vers, 0, 0);
+}
+
 static void init_service_resolver(void)
 {
-	char buf[128];
-	FILE *fp = popen("/usr/sbin/rpcinfo -p 2>/dev/null", "r");
+	struct rpcblist *rhead = NULL;
+	struct timeval timeout;
+	struct rpcent *rpc;
+	enum clnt_stat res;
+	CLIENT *client;
 
-	if (!fp)
+	timeout.tv_sec = 5;
+	timeout.tv_usec = 0;
+
+	client = rpc_client_create(PMAPPROG, RPCBVERS4);
+	if (!client)
 		return;
 
-	if (!fgets(buf, sizeof(buf), fp)) {
-		pclose(fp);
+	res = clnt_call(client, RPCBPROC_DUMP, (xdrproc_t)xdr_void, NULL,
+			(xdrproc_t)xdr_rpcblist_ptr, (char *)&rhead,
+			timeout);
+	if (res != RPC_SUCCESS)
 		return;
-	}
-	while (fgets(buf, sizeof(buf), fp) != NULL) {
-		unsigned int progn, port;
-		char proto[128], prog[128] = "rpc.";
+
+	for (; rhead; rhead = rhead->rpcb_next) {
+		char prog[128] = "rpc.";
 		struct scache *c;
+		int hport, lport, ok;
 
-		if (sscanf(buf, "%u %*d %s %u %s",
-			   &progn, proto, &port, prog+4) != 4)
+		c = malloc(sizeof(*c));
+		if (!c)
 			continue;
 
-		if (!(c = malloc(sizeof(*c))))
+		ok = sscanf(rhead->rpcb_map.r_addr, "::.%d.%d", &hport, &lport);
+		if (!ok)
+			ok = sscanf(rhead->rpcb_map.r_addr, "0.0.0.0.%d.%d",
+				    &hport, &lport);
+		if (!ok)
 			continue;
+		c->port = hport << 8 | lport;
 
-		c->port = port;
-		c->name = strdup(prog);
-		if (strcmp(proto, TCP_PROTO) == 0)
+		if (strcmp(rhead->rpcb_map.r_netid, TCP_PROTO) == 0 ||
+		    strcmp(rhead->rpcb_map.r_netid, TCP6_PROTO) == 0)
 			c->proto = TCP_PROTO;
-		else if (strcmp(proto, UDP_PROTO) == 0)
+		else if (strcmp(rhead->rpcb_map.r_netid, UDP_PROTO) == 0 ||
+			 strcmp(rhead->rpcb_map.r_netid, UDP6_PROTO) == 0)
 			c->proto = UDP_PROTO;
-		else if (strcmp(proto, SCTP_PROTO) == 0)
+		else if (strcmp(rhead->rpcb_map.r_netid, SCTP_PROTO) == 0)
 			c->proto = SCTP_PROTO;
 		else
-			c->proto = NULL;
+			continue;
+
+		rpc = getrpcbynumber(rhead->rpcb_map.r_prog);
+		if (rpc) {
+			strncat(prog, rpc->r_name, 128 - strlen(prog));
+			c->name = strdup(prog);
+		}
+
 		c->next = rlist;
 		rlist = c;
 	}
-	pclose(fp);
 }
+#endif
 
 /* Even do not try default linux ephemeral port ranges:
  * default /etc/services contains so much of useless crap
@@ -5668,9 +5719,11 @@ int main(int argc, char *argv[])
 	filter_states_set(&current_filter, state_filter);
 	filter_merge_defaults(&current_filter);
 
+#ifdef HAVE_RPC
 	if (!numeric && resolve_hosts &&
 	    (current_filter.dbs & (UNIX_DBM|INET_L4_DBM)))
 		init_service_resolver();
+#endif
 
 	if (current_filter.dbs == 0) {
 		fprintf(stderr, "ss: no socket tables to show with such filter.\n");
-- 
2.35.1

