Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD6A177D57
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 18:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgCCRYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:24:07 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54658 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729391AbgCCRYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 12:24:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583256246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=S6shh/oqQNCddZY8IeF5QnYe2NCeO8oFo9W1ZVPEXps=;
        b=GhesgsiC0Ghj/xs3Sty4AXNiPsEUL1srl+vvYGn1CyxlMNgHfkk2H1v8dDac6A2W2v2iZi
        xnXPdPqviSlzz+sDNZyva4kJwXqSuj8nGRTVUmYDHuRC+9KeD2h52OFTkYfMK0Ovgy8A+r
        dskmCP3mMYf9BREAQHJfBsvOmSuzLPA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-4vKrL0NIPrybOAT7ntdmuA-1; Tue, 03 Mar 2020 12:24:00 -0500
X-MC-Unique: 4vKrL0NIPrybOAT7ntdmuA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B976107ACC7;
        Tue,  3 Mar 2020 17:23:59 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-38.ams2.redhat.com [10.36.117.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB73910013A1;
        Tue,  3 Mar 2020 17:23:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net] mptcp: always include dack if possible.
Date:   Tue,  3 Mar 2020 18:22:59 +0100
Message-Id: <8f78569a035c045fd1ad295dd8bf17dcfeca9c41.1583256003.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

Fixes: d22f4988ffec ("mptcp: process MP_CAPABLE data option")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 45acd877bef3..9eb84115dc35 100644
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
@@ -360,9 +362,20 @@ static bool mptcp_established_options_dss(struct soc=
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
+	if (likely(msk && READ_ONCE(msk->can_ack)))
+		ack_seq =3D msk->ack_seq;
+	else if (subflow->can_ack)
+		mptcp_crypto_key_sha(subflow->remote_key, NULL, &ack_seq);
+	else
+		can_ack =3D false;
+
+	if (unlikely(!can_ack)) {
 		*size =3D ALIGN(dss_size, 4);
 		return ret;
 	}
@@ -375,7 +388,7 @@ static bool mptcp_established_options_dss(struct sock=
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

