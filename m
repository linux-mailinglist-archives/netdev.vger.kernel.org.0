Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7165C183433
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 16:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgCLPNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 11:13:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50873 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727467AbgCLPNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 11:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584026029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9bf9/oDQVPqmwti/EVtlX9Cs3BUPSCVo8ukwwv+UhFU=;
        b=aJtSBHL/lr4DSR73o4IP2Kqst1qoxTzW9GXztSE3OI1fSuajmzQyMR20F0kJc2PISHQUM/
        Pf5KfO8n4Qt4Ho8w9nDDr1dNwrfhHln35OzKRgU64M37/QMtPPVxjifjZMArEFpGsjE8Jm
        3iho6BUABHh1gzZnhGM7Rv92beiHeyQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-ZwxSKMbkNzOtspnbv4707w-1; Thu, 12 Mar 2020 11:13:46 -0400
X-MC-Unique: ZwxSKMbkNzOtspnbv4707w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45A488010F7;
        Thu, 12 Mar 2020 15:13:45 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-153.ams2.redhat.com [10.36.117.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50A1019C6A;
        Thu, 12 Mar 2020 15:13:44 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/2] mptcp: drop unneeded checks
Date:   Thu, 12 Mar 2020 16:13:22 +0100
Message-Id: <aeb6df3bf3b2b8f15184311309193ffb031d3f34.1584006115.git.pabeni@redhat.com>
In-Reply-To: <cover.1584006115.git.pabeni@redhat.com>
References: <cover.1584006115.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the previous patch subflow->conn is always !=3D NULL and
is never changed. We can drop a bunch of now unneeded checks

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c |  2 +-
 net/mptcp/subflow.c | 18 +++++++-----------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index b9a8305bd934..eb6cd0accf99 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -362,7 +362,7 @@ static bool mptcp_established_options_dss(struct sock=
 *sk, struct sk_buff *skb,
=20
 	opts->ext_copy.use_ack =3D 0;
 	msk =3D mptcp_sk(subflow->conn);
-	if (!msk || !READ_ONCE(msk->can_ack)) {
+	if (!READ_ONCE(msk->can_ack)) {
 		*size =3D ALIGN(dss_size, 4);
 		return ret;
 	}
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

