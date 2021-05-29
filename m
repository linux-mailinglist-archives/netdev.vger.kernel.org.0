Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D12394CA6
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 17:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhE2PPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 11:15:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhE2PPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 11:15:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622301249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SgzrF+zBfvSEywg2ZYJcXcfBJSFli4SD7rD2v1yqnV4=;
        b=Dor/DlekHBkfaNWmcXK7wiRIseOxSi0sZW6piAU1OpFTAVcwSXquSqaCIeoILemqa8tO5x
        cH3jaLbErm931mN0yVENPnf9fxPDnQTUm8WB34bD6mSkBRhuLCG7Pc7cAGl/8tD7iM0cP3
        2Zp9kg2CO+Phf7/Z/JhjjBzU6FgV3OU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-Grrgmxe7NcK7KIBZPc7qGw-1; Sat, 29 May 2021 11:14:07 -0400
X-MC-Unique: Grrgmxe7NcK7KIBZPc7qGw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6FB8180FD67;
        Sat, 29 May 2021 15:14:05 +0000 (UTC)
Received: from ymir.virt.lab.eng.bos.redhat.com (virtlab420.virt.lab.eng.bos.redhat.com [10.19.152.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AF591A881;
        Sat, 29 May 2021 15:14:04 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 2/3] tipc: refactor function tipc_sk_anc_data_recv()
Date:   Sat, 29 May 2021 11:13:59 -0400
Message-Id: <20210529151400.781539-3-jmaloy@redhat.com>
In-Reply-To: <20210529151400.781539-1-jmaloy@redhat.com>
References: <20210529151400.781539-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We refactor tipc_sk_anc_data_recv() to make it slightly more
comprehensible, but also to facilitate application of some additions
to the code in a future commit.

Reviewed-by: Xin Long <lucien.xin@gmail.com>
Tested-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/socket.c | 85 +++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 47 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index cb2d9fffbc5d..c635fd27fb38 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1733,67 +1733,58 @@ static void tipc_sk_set_orig_addr(struct msghdr *m, struct sk_buff *skb)
 static int tipc_sk_anc_data_recv(struct msghdr *m, struct sk_buff *skb,
 				 struct tipc_sock *tsk)
 {
-	struct tipc_msg *msg;
-	u32 anc_data[3];
-	u32 err;
-	u32 dest_type;
-	int has_name;
-	int res;
+	struct tipc_msg *hdr;
+	u32 data[3] = {0,};
+	bool has_addr;
+	int dlen, rc;
 
 	if (likely(m->msg_controllen == 0))
 		return 0;
-	msg = buf_msg(skb);
 
-	/* Optionally capture errored message object(s) */
-	err = msg ? msg_errcode(msg) : 0;
-	if (unlikely(err)) {
-		anc_data[0] = err;
-		anc_data[1] = msg_data_sz(msg);
-		res = put_cmsg(m, SOL_TIPC, TIPC_ERRINFO, 8, anc_data);
-		if (res)
-			return res;
-		if (anc_data[1]) {
-			if (skb_linearize(skb))
-				return -ENOMEM;
-			msg = buf_msg(skb);
-			res = put_cmsg(m, SOL_TIPC, TIPC_RETDATA, anc_data[1],
-				       msg_data(msg));
-			if (res)
-				return res;
-		}
+	hdr = buf_msg(skb);
+	dlen = msg_data_sz(hdr);
+
+	/* Capture errored message object, if any */
+	if (msg_errcode(hdr)) {
+		if (skb_linearize(skb))
+			return -ENOMEM;
+		hdr = buf_msg(skb);
+		data[0] = msg_errcode(hdr);
+		data[1] = dlen;
+		rc = put_cmsg(m, SOL_TIPC, TIPC_ERRINFO, 8, data);
+		if (rc || !dlen)
+			return rc;
+		rc = put_cmsg(m, SOL_TIPC, TIPC_RETDATA, dlen, msg_data(hdr));
+		if (rc)
+			return rc;
 	}
 
-	/* Optionally capture message destination object */
-	dest_type = msg ? msg_type(msg) : TIPC_DIRECT_MSG;
-	switch (dest_type) {
+	/* Capture TIPC_SERVICE_ADDR/RANGE destination address, if any */
+	switch (msg_type(hdr)) {
 	case TIPC_NAMED_MSG:
-		has_name = 1;
-		anc_data[0] = msg_nametype(msg);
-		anc_data[1] = msg_namelower(msg);
-		anc_data[2] = msg_namelower(msg);
+		has_addr = true;
+		data[0] = msg_nametype(hdr);
+		data[1] = msg_namelower(hdr);
+		data[2] = data[1];
 		break;
 	case TIPC_MCAST_MSG:
-		has_name = 1;
-		anc_data[0] = msg_nametype(msg);
-		anc_data[1] = msg_namelower(msg);
-		anc_data[2] = msg_nameupper(msg);
+		has_addr = true;
+		data[0] = msg_nametype(hdr);
+		data[1] = msg_namelower(hdr);
+		data[2] = msg_nameupper(hdr);
 		break;
 	case TIPC_CONN_MSG:
-		has_name = !!tsk->conn_addrtype;
-		anc_data[0] = msg_nametype(&tsk->phdr);
-		anc_data[1] = msg_nameinst(&tsk->phdr);
-		anc_data[2] = anc_data[1];
+		has_addr = !!tsk->conn_addrtype;
+		data[0] = msg_nametype(&tsk->phdr);
+		data[1] = msg_nameinst(&tsk->phdr);
+		data[2] = data[1];
 		break;
 	default:
-		has_name = 0;
-	}
-	if (has_name) {
-		res = put_cmsg(m, SOL_TIPC, TIPC_DESTNAME, 12, anc_data);
-		if (res)
-			return res;
+		has_addr = false;
 	}
-
-	return 0;
+	if (!has_addr)
+		return 0;
+	return put_cmsg(m, SOL_TIPC, TIPC_DESTNAME, 12, data);
 }
 
 static struct sk_buff *tipc_sk_build_ack(struct tipc_sock *tsk)
-- 
2.31.1

