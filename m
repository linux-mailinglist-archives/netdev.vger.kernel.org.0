Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91E622AD2F
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgGWLDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:03:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30583 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728460AbgGWLDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:03:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595502193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PnoOa8/buTToM4i8wQuSvDxjgNJ51b4HZV65Yx/oJZE=;
        b=WsSTREEPIjyPvpeVojupAlKidCaVyXUvuotLZcBODQ/MsgmlobmB5Ri8aQFOE1t42dYDl/
        ZuC+V4vTpotp7m3S9KgX1wp7UZ5OFCWoZ37zUOn7yT5bS5FUnr4nF2OCNFgZ6j3bmdqZeM
        10S6Js2VudB7ZIeUbH9Z/UghHYOh6Rg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-4IMAkWEZMI2PSaPvMEK5LA-1; Thu, 23 Jul 2020 07:03:10 -0400
X-MC-Unique: 4IMAkWEZMI2PSaPvMEK5LA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3BB7800688;
        Thu, 23 Jul 2020 11:03:09 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-9.ams2.redhat.com [10.36.113.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF4968BED5;
        Thu, 23 Jul 2020 11:03:08 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net-next 8/8] subflow: introduce and use mptcp_can_accept_new_subflow()
Date:   Thu, 23 Jul 2020 13:02:36 +0200
Message-Id: <f917ce96fa7c3ff623378a01ae8fb52d4ac1884f.1595431326.git.pabeni@redhat.com>
In-Reply-To: <cover.1595431326.git.pabeni@redhat.com>
References: <cover.1595431326.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So that we can easily perform some basic PM-related
adimission checks before creating the child socket.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index ada04df6f99f..e645483d1200 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -53,6 +53,12 @@ static void subflow_generate_hmac(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
 	mptcp_crypto_hmac_sha(key1, key2, msg, 8, hmac);
 }
 
+static bool mptcp_can_accept_new_subflow(const struct mptcp_sock *msk)
+{
+	return mptcp_is_fully_established((void *)msk) &&
+	       READ_ONCE(msk->pm.accept_subflow);
+}
+
 /* validate received token and create truncated hmac and nonce for SYN-ACK */
 static struct mptcp_sock *subflow_token_join_request(struct request_sock *req,
 						     const struct sk_buff *skb)
@@ -443,6 +449,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	} else if (subflow_req->mp_join) {
 		mptcp_get_options(skb, &mp_opt);
 		if (!mp_opt.mp_join ||
+		    !mptcp_can_accept_new_subflow(subflow_req->msk) ||
 		    !subflow_hmac_valid(req, &mp_opt)) {
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
 			fallback = true;
-- 
2.26.2

