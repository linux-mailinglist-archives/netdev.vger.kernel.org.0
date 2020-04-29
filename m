Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8561B1BD9E5
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgD2Kma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:42:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47678 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726754AbgD2Km3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 06:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588156948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d/vP2Jo5EDTLBChoi/MijCaKnAqlxa7Eg4QalR+s8uE=;
        b=eJqLZ0Q//YjyU+wl5gTWMS4yXSBr0xm111lpsLc1Ui1B7cmC3S5rBaKXGEQHNjoiKBrBa2
        Fw4fk5SylQImaKSSBZODe9VXTnOS08NK8V+yMIO9dybzYmTQeteLtSDME30w40yPdsXcri
        v5ZSnTF74lrTpNmwzADS/C+Bc5BCBuI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-CWHC_h2KOTOXror2ZK4pdQ-1; Wed, 29 Apr 2020 06:42:26 -0400
X-MC-Unique: CWHC_h2KOTOXror2ZK4pdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C57945F;
        Wed, 29 Apr 2020 10:42:25 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-45.ams2.redhat.com [10.36.114.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE08A99D6;
        Wed, 29 Apr 2020 10:42:22 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: [PATCH net 3/5] mptcp: avoid a WARN on bad input.
Date:   Wed, 29 Apr 2020 12:41:47 +0200
Message-Id: <388f5aba3a30dfd827f95efbe40ccb6d4ad42fe1.1588156257.git.pabeni@redhat.com>
In-Reply-To: <cover.1588156257.git.pabeni@redhat.com>
References: <cover.1588156257.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzcaller has found a way to trigger the WARN_ON_ONCE condition
in check_fully_established().

The root cause is a legit fallback to TCP scenario, so replace
the WARN with a plain message on a more strict condition.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index eadbd59586e4..ecf41d52d2fc 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -703,8 +703,6 @@ static bool check_fully_established(struct mptcp_sock=
 *msk, struct sock *sk,
 		goto fully_established;
 	}
=20
-	WARN_ON_ONCE(subflow->can_ack);
-
 	/* If the first established packet does not contain MP_CAPABLE + data
 	 * then fallback to TCP
 	 */
@@ -714,6 +712,8 @@ static bool check_fully_established(struct mptcp_sock=
 *msk, struct sock *sk,
 		return false;
 	}
=20
+	if (unlikely(!READ_ONCE(msk->pm.server_side)))
+		pr_warn_once("bogus mpc option on established client sk");
 	subflow->fully_established =3D 1;
 	subflow->remote_key =3D mp_opt->sndr_key;
 	subflow->can_ack =3D 1;
--=20
2.21.1

