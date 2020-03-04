Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC80A179417
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 16:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387566AbgCDPwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 10:52:09 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54637 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729554AbgCDPwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 10:52:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583337127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HSHdpGxl/KYJRivWoVfP++dye//1I1O6hWNsptmfAiA=;
        b=QpF2n4S2IYIyfK7TisH/4NHd1ZZMtEDmBgIxfiKaC9cX02I3N3JRNVF2TN6FbZe2YABXqR
        gqiw4jZ0qG9xhZR0pxjgnn3Xj7neB7YyqVijiPBnwTAQMtVz/ZUdj1nf6sZEGBBKFutkhk
        z2yV4ZrLIrt9HETJ1U6MBsktETDZN8Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-b2WDCe0GP4iLPQHzt_5FtQ-1; Wed, 04 Mar 2020 10:52:02 -0500
X-MC-Unique: b2WDCe0GP4iLPQHzt_5FtQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE9E2108442E;
        Wed,  4 Mar 2020 15:52:01 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.36.118.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54A558D55E;
        Wed,  4 Mar 2020 15:52:00 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net v2] mptcp: always include dack if possible.
Date:   Wed,  4 Mar 2020 16:51:07 +0100
Message-Id: <d4f2f87c56fa1662bbc39baaee74b26bc646e141.1583337038.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently passive MPTCP socket can skip including the DACK
option - if the peer sends data before accept() completes.

The above happens because the msk 'can_ack' flag is set
only after the accept() call.

Such missing DACK option may cause - as per RFC spec -
unwanted fallback to TCP.

This change addresses the issue using the key material
available in the current subflow, if any, to create a suitable
dack option when msk ack seq is not yet available.

v1 -> v2:
 - adavance the generated ack after the initial MPC packet

Fixes: d22f4988ffec ("mptcp: process MP_CAPABLE data option")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 45acd877bef3..fd2c3150e591 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -334,6 +334,8 @@ static bool mptcp_established_options_dss(struct sock=
 *sk, struct sk_buff *skb,
 	struct mptcp_sock *msk;
 	unsigned int ack_size;
 	bool ret =3D false;
+	bool can_ack;
+	u64 ack_seq;
 	u8 tcp_fin;
=20
 	if (skb) {
@@ -360,9 +362,22 @@ static bool mptcp_established_options_dss(struct soc=
k *sk, struct sk_buff *skb,
 		ret =3D true;
 	}
=20
+	/* passive sockets msk will set the 'can_ack' after accept(), even
+	 * if the first subflow may have the already the remote key handy
+	 */
+	can_ack =3D true;
 	opts->ext_copy.use_ack =3D 0;
 	msk =3D mptcp_sk(subflow->conn);
-	if (!msk || !READ_ONCE(msk->can_ack)) {
+	if (likely(msk && READ_ONCE(msk->can_ack))) {
+		ack_seq =3D msk->ack_seq;
+	} else if (subflow->can_ack) {
+		mptcp_crypto_key_sha(subflow->remote_key, NULL, &ack_seq);
+		ack_seq++;
+	} else {
+		can_ack =3D false;
+	}
+
+	if (unlikely(!can_ack)) {
 		*size =3D ALIGN(dss_size, 4);
 		return ret;
 	}
@@ -375,7 +390,7 @@ static bool mptcp_established_options_dss(struct sock=
 *sk, struct sk_buff *skb,
=20
 	dss_size +=3D ack_size;
=20
-	opts->ext_copy.data_ack =3D msk->ack_seq;
+	opts->ext_copy.data_ack =3D ack_seq;
 	opts->ext_copy.ack64 =3D 1;
 	opts->ext_copy.use_ack =3D 1;
=20
--=20
2.21.1

