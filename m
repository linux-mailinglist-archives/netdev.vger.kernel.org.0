Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AAD458C26
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 11:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbhKVKUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 05:20:40 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:47825 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236312AbhKVKUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 05:20:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637576254; x=1669112254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xhIfsChPD1IOCTAZFSfJBHCC68AV/NjVa9GNIKQo51k=;
  b=B54wiY2GypSoJWAsA9HRtzdPZK8A9/uSxcZ6/JyUaZipOpD6YCVo/9gn
   BUXOEIy3fxAsd9ShfErMesQljdv5dhEtQTNZwAmOoU5n0/QM3CAn6l9+9
   4Wkto8m+sdbJSnaZR9SjP+T15fuixFNKjYV0m2lG9l6WuW9wRoyIBOQtL
   o=;
X-IronPort-AV: E=Sophos;i="5.87,254,1631577600"; 
   d="scan'208";a="973377692"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-0168675e.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 22 Nov 2021 10:17:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-0168675e.us-east-1.amazon.com (Postfix) with ESMTPS id 1C8DBA0CE4;
        Mon, 22 Nov 2021 10:17:30 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 10:17:25 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.66) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 10:17:21 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yafang Shao <laoar.shao@gmail.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <dccp@vger.kernel.org>
Subject: [PATCH net-next 2/2] dccp: Inline dccp_listen_start().
Date:   Mon, 22 Nov 2021 19:16:22 +0900
Message-ID: <20211122101622.50572-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122101622.50572-1-kuniyu@amazon.co.jp>
References: <20211122101622.50572-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D05UWB004.ant.amazon.com (10.43.161.208) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch inlines dccp_listen_start() and removes a stale comment in
inet_dccp_listen() so that it looks like inet_listen().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/dccp/proto.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 55b8f958cdd2..a976b4d29892 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -238,17 +238,6 @@ void dccp_destroy_sock(struct sock *sk)
 
 EXPORT_SYMBOL_GPL(dccp_destroy_sock);
 
-static inline int dccp_listen_start(struct sock *sk)
-{
-	struct dccp_sock *dp = dccp_sk(sk);
-
-	dp->dccps_role = DCCP_ROLE_LISTEN;
-	/* do not start to listen if feature negotiation setup fails */
-	if (dccp_feat_finalise_settings(dp))
-		return -EPROTO;
-	return inet_csk_listen_start(sk);
-}
-
 static inline int dccp_need_reset(int state)
 {
 	return state != DCCP_CLOSED && state != DCCP_LISTEN &&
@@ -931,11 +920,17 @@ int inet_dccp_listen(struct socket *sock, int backlog)
 	 * we can only allow the backlog to be adjusted.
 	 */
 	if (old_state != DCCP_LISTEN) {
-		/*
-		 * FIXME: here it probably should be sk->sk_prot->listen_start
-		 * see tcp_listen_start
-		 */
-		err = dccp_listen_start(sk);
+		struct dccp_sock *dp = dccp_sk(sk);
+
+		dp->dccps_role = DCCP_ROLE_LISTEN;
+
+		/* do not start to listen if feature negotiation setup fails */
+		if (dccp_feat_finalise_settings(dp)) {
+			err = -EPROTO;
+			goto out;
+		}
+
+		err = inet_csk_listen_start(sk);
 		if (err)
 			goto out;
 	}
-- 
2.30.2

