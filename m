Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2C122AD2A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgGWLDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:03:09 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48392 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728396AbgGWLDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:03:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595502186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cs0G1nPHnOtTpkilsbe4t1ZzPgbmzKlrq+RVKoQAe5E=;
        b=bJt+YvXIz8onRQdGVKmLgt9Pb0F2bA8NHNqbN9zZmlywKYXBo50oFNbAEE5euGx6IILZ8b
        SRogev4OBWd4FyEFBROTk6r+C8PIzRsVbnVf5nMFK8ThgX6Akt7jGzKispt+2dFjiBBpXU
        +SKlvKWHQqjWeGRdP3izIP03hFh0tgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-Xu2HYyH7NjOmPfkrzR1YaQ-1; Thu, 23 Jul 2020 07:03:04 -0400
X-MC-Unique: Xu2HYyH7NjOmPfkrzR1YaQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D7BD10059A4;
        Thu, 23 Jul 2020 11:03:03 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-9.ams2.redhat.com [10.36.113.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C9B88BED5;
        Thu, 23 Jul 2020 11:03:01 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net-next 3/8] mptcp: mark as fallback even early ones
Date:   Thu, 23 Jul 2020 13:02:31 +0200
Message-Id: <1fa72209d016ee555828b18bc3675784d416d543.1595431326.git.pabeni@redhat.com>
In-Reply-To: <cover.1595431326.git.pabeni@redhat.com>
References: <cover.1595431326.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the unlikely event of a failure at connect time,
we currently clear the request_mptcp flag - so that
the MPC handshake is not started at all, but the msk
is not explicitly marked as fallback.

This would lead to later insertion of wrong DSS options
in the xmitted packets, in violation of RFC specs and
possibly fooling the peer.

Fixes: e1ff9e82e2ea ("net: mptcp: improve fallback to TCP")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 254e6ef2b4e0..2936413171be 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1944,6 +1944,13 @@ static int mptcp_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	return err;
 }
 
+static void mptcp_subflow_early_fallback(struct mptcp_sock *msk,
+					 struct mptcp_subflow_context *subflow)
+{
+	subflow->request_mptcp = 0;
+	__mptcp_do_fallback(msk);
+}
+
 static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 				int addr_len, int flags)
 {
@@ -1975,10 +1982,10 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	 * TCP option space.
 	 */
 	if (rcu_access_pointer(tcp_sk(ssock->sk)->md5sig_info))
-		subflow->request_mptcp = 0;
+		mptcp_subflow_early_fallback(msk, subflow);
 #endif
 	if (subflow->request_mptcp && mptcp_token_new_connect(ssock->sk))
-		subflow->request_mptcp = 0;
+		mptcp_subflow_early_fallback(msk, subflow);
 
 do_connect:
 	err = ssock->ops->connect(ssock, uaddr, addr_len, flags);
-- 
2.26.2

