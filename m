Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E87184BC0
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 16:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgCMPxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 11:53:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40621 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726442AbgCMPxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 11:53:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584114790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=prP8G06Z8lWjAnIztTLuEEPiR8PxmQUL5o3aVg67oxg=;
        b=Ga7k0eMgX+fLgkSm4mXBs/x3BRu+P2X2wHIXpgcqut9ULf0u897MbYEBaGhl3fG6k+mqFq
        IcyNJfOe9soz/RUM48dsnFo64JrPx4CXfMvU3XdnBNApCSGp6Mq9mDkh8G7o4sHCUW0tHn
        AzWLc+rMEi8Gc7Ao9JcjizY2R9J3nSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-41a3_wwQOJa2ap-toJtaAA-1; Fri, 13 Mar 2020 11:53:07 -0400
X-MC-Unique: 41a3_wwQOJa2ap-toJtaAA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBC3313EA;
        Fri, 13 Mar 2020 15:53:05 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAC4160C63;
        Fri, 13 Mar 2020 15:53:04 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 2/2] mptcp: drop unneeded checks
Date:   Fri, 13 Mar 2020 16:52:42 +0100
Message-Id: <cd82fc7a869af40debec550fb1270ff8a159296e.1584114674.git.pabeni@redhat.com>
In-Reply-To: <cover.1584114674.git.pabeni@redhat.com>
References: <cover.1584114674.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the previous patch subflow->conn is always !=3D NULL and
is never changed. We can drop a bunch of now unneeded checks.

v1 -> v2:
 - rebased on top of commit 2398e3991bda ("mptcp: always
   include dack if possible.")

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c | 14 ++------------
 net/mptcp/subflow.c | 18 +++++++-----------
 2 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 9c71f427e6e3..63c8ee49cef2 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -336,7 +336,6 @@ static bool mptcp_established_options_dss(struct sock=
 *sk, struct sk_buff *skb,
 	unsigned int ack_size;
 	bool ret =3D false;
 	bool can_ack;
-	u64 ack_seq;
 	u8 tcp_fin;
=20
 	if (skb) {
@@ -368,16 +367,7 @@ static bool mptcp_established_options_dss(struct soc=
k *sk, struct sk_buff *skb,
 	can_ack =3D true;
 	opts->ext_copy.use_ack =3D 0;
 	msk =3D mptcp_sk(subflow->conn);
-	if (likely(msk && READ_ONCE(msk->can_ack))) {
-		ack_seq =3D msk->ack_seq;
-	} else if (subflow->can_ack) {
-		mptcp_crypto_key_sha(subflow->remote_key, NULL, &ack_seq);
-		ack_seq++;
-	} else {
-		can_ack =3D false;
-	}
-
-	if (unlikely(!can_ack)) {
+	if (!READ_ONCE(msk->can_ack)) {
 		*size =3D ALIGN(dss_size, 4);
 		return ret;
 	}
@@ -390,7 +380,7 @@ static bool mptcp_established_options_dss(struct sock=
 *sk, struct sk_buff *skb,
=20
 	dss_size +=3D ack_size;
=20
-	opts->ext_copy.data_ack =3D ack_seq;
+	opts->ext_copy.data_ack =3D msk->ack_seq;
 	opts->ext_copy.ack64 =3D 1;
 	opts->ext_copy.use_ack =3D 1;
=20
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 047b088e4617..8434c7f5f712 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -112,7 +112,7 @@ static void subflow_finish_connect(struct sock *sk, c=
onst struct sk_buff *skb)
=20
 	subflow->icsk_af_ops->sk_rx_dst_set(sk, skb);
=20
-	if (subflow->conn && !subflow->conn_finished) {
+	if (!subflow->conn_finished) {
 		pr_debug("subflow=3D%p, remote_key=3D%llu", mptcp_subflow_ctx(sk),
 			 subflow->remote_key);
 		mptcp_finish_connect(sk);
@@ -439,9 +439,6 @@ static bool subflow_check_data_avail(struct sock *ssk=
)
 	if (subflow->data_avail)
 		return true;
=20
-	if (!subflow->conn)
-		return false;
-
 	msk =3D mptcp_sk(subflow->conn);
 	for (;;) {
 		u32 map_remaining;
@@ -561,11 +558,10 @@ static void subflow_data_ready(struct sock *sk)
 	struct mptcp_subflow_context *subflow =3D mptcp_subflow_ctx(sk);
 	struct sock *parent =3D subflow->conn;
=20
-	if (!parent || !subflow->mp_capable) {
+	if (!subflow->mp_capable) {
 		subflow->tcp_data_ready(sk);
=20
-		if (parent)
-			parent->sk_data_ready(parent);
+		parent->sk_data_ready(parent);
 		return;
 	}
=20
@@ -579,7 +575,7 @@ static void subflow_write_space(struct sock *sk)
 	struct sock *parent =3D subflow->conn;
=20
 	sk_stream_write_space(sk);
-	if (parent && sk_stream_is_writeable(sk)) {
+	if (sk_stream_is_writeable(sk)) {
 		set_bit(MPTCP_SEND_SPACE, &mptcp_sk(parent)->flags);
 		smp_mb__after_atomic();
 		/* set SEND_SPACE before sk_stream_write_space clears NOSPACE */
@@ -694,7 +690,7 @@ static bool subflow_is_done(const struct sock *sk)
 static void subflow_state_change(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow =3D mptcp_subflow_ctx(sk);
-	struct sock *parent =3D READ_ONCE(subflow->conn);
+	struct sock *parent =3D subflow->conn;
=20
 	__subflow_state_change(sk);
=20
@@ -702,10 +698,10 @@ static void subflow_state_change(struct sock *sk)
 	 * a fin packet carrying a DSS can be unnoticed if we don't trigger
 	 * the data available machinery here.
 	 */
-	if (parent && subflow->mp_capable && mptcp_subflow_data_available(sk))
+	if (subflow->mp_capable && mptcp_subflow_data_available(sk))
 		mptcp_data_ready(parent, sk);
=20
-	if (parent && !(parent->sk_shutdown & RCV_SHUTDOWN) &&
+	if (!(parent->sk_shutdown & RCV_SHUTDOWN) &&
 	    !subflow->rx_eof && subflow_is_done(sk)) {
 		subflow->rx_eof =3D 1;
 		parent->sk_shutdown |=3D RCV_SHUTDOWN;
--=20
2.21.1

