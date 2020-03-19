Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53AE218B0E9
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 11:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgCSKHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 06:07:21 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:53669 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbgCSKHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 06:07:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584612439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nWEk+0kj8FksCoj7KClb84pskllv3CGFPyiC3mzU2go=;
        b=ighL+TI7oq2di4zoP/W5dtaoYgT8Wemv4LOUfX8gW2FG/DOEqBwXUCcSpD4zzcdfj2Cw14
        zccHTMiYQ+wN+sN1M46hp+gMmRwXG2x8fGr1w1ehwUE00Ik+JNZSWOxLRa8fTNIXwYSOh3
        wJd/hrDKSVVKbR3Rvzc5prBL7DdUR90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-2BrI8os1OeKFJVmJ3XqIkQ-1; Thu, 19 Mar 2020 06:07:18 -0400
X-MC-Unique: 2BrI8os1OeKFJVmJ3XqIkQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CEF2107ACC4;
        Thu, 19 Mar 2020 10:07:17 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-148.ams2.redhat.com [10.36.114.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6FCC9CA3;
        Thu, 19 Mar 2020 10:07:15 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next] mptcp: rename fourth ack field
Date:   Thu, 19 Mar 2020 11:06:30 +0100
Message-Id: <3c7d0601bc04139108479bf06a8d299b14496300.1584612221.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The name is misleading, it actually tracks the 'fully established'
status.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c  | 18 +++++++++---------
 net/mptcp/protocol.h |  2 +-
 net/mptcp/subflow.c  |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 63c8ee49cef2..55f3ce7638a0 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -259,11 +259,11 @@ static bool mptcp_established_options_mp(struct soc=
k *sk, struct sk_buff *skb,
 	struct mptcp_ext *mpext;
 	unsigned int data_len;
=20
-	pr_debug("subflow=3D%p fourth_ack=3D%d seq=3D%x:%x remaining=3D%d", sub=
flow,
-		 subflow->fourth_ack, subflow->snd_isn,
+	pr_debug("subflow=3D%p fully established=3D%d seq=3D%x:%x remaining=3D%=
d",
+		 subflow, subflow->fully_established, subflow->snd_isn,
 		 skb ? TCP_SKB_CB(skb)->seq : 0, remaining);
=20
-	if (subflow->mp_capable && !subflow->fourth_ack && skb &&
+	if (subflow->mp_capable && !subflow->fully_established && skb &&
 	    subflow->snd_isn =3D=3D TCP_SKB_CB(skb)->seq) {
 		/* When skb is not available, we better over-estimate the
 		 * emitted options len. A full DSS option is longer than
@@ -429,19 +429,19 @@ bool mptcp_synack_options(const struct request_sock=
 *req, unsigned int *size,
 	return false;
 }
=20
-static bool check_fourth_ack(struct mptcp_subflow_context *subflow,
-			     struct sk_buff *skb,
-			     struct mptcp_options_received *mp_opt)
+static bool check_fully_established(struct mptcp_subflow_context *subflo=
w,
+				    struct sk_buff *skb,
+				    struct mptcp_options_received *mp_opt)
 {
 	/* here we can process OoO, in-window pkts, only in-sequence 4th ack
 	 * are relevant
 	 */
-	if (likely(subflow->fourth_ack ||
+	if (likely(subflow->fully_established ||
 		   TCP_SKB_CB(skb)->seq !=3D subflow->ssn_offset + 1))
 		return true;
=20
 	if (mp_opt->use_ack)
-		subflow->fourth_ack =3D 1;
+		subflow->fully_established =3D 1;
=20
 	if (subflow->can_ack)
 		return true;
@@ -467,7 +467,7 @@ void mptcp_incoming_options(struct sock *sk, struct s=
k_buff *skb,
 	struct mptcp_ext *mpext;
=20
 	mp_opt =3D &opt_rx->mptcp;
-	if (!check_fourth_ack(subflow, skb, mp_opt))
+	if (!check_fully_established(subflow, skb, mp_opt))
 		return;
=20
 	if (!mp_opt->dss)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 9baf6fcba914..eb3f65264a40 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -119,7 +119,7 @@ struct mptcp_subflow_context {
 	u32	map_data_len;
 	u32	request_mptcp : 1,  /* send MP_CAPABLE */
 		mp_capable : 1,	    /* remote is MPTCP capable */
-		fourth_ack : 1,	    /* send initial DSS */
+		fully_established : 1,	    /* path validated */
 		conn_finished : 1,
 		map_valid : 1,
 		mpc_map : 1,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 052d72a1d3a2..e1faa88855bf 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -802,7 +802,7 @@ static void subflow_ulp_clone(const struct request_so=
ck *req,
 	new_ctx->tcp_sock =3D newsk;
=20
 	new_ctx->mp_capable =3D 1;
-	new_ctx->fourth_ack =3D subflow_req->remote_key_valid;
+	new_ctx->fully_established =3D subflow_req->remote_key_valid;
 	new_ctx->can_ack =3D subflow_req->remote_key_valid;
 	new_ctx->remote_key =3D subflow_req->remote_key;
 	new_ctx->local_key =3D subflow_req->local_key;
--=20
2.21.1

