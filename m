Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC1E1BF8BB
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgD3NCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:02:24 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28450 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726692AbgD3NCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:02:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588251742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d/vP2Jo5EDTLBChoi/MijCaKnAqlxa7Eg4QalR+s8uE=;
        b=Bbjiyo9U1oQPf5ZSK1vIVzNN9R1vzpDBLapBH0Pqour+07uWpXTM4w8MZgF4PWKn+FX1+o
        DvoJwXXRl5u1YycKFyKZLtJAZo5yHjZPuqkf4rH7cq3PPrYjnYj6eNoeuIu1L1BoJWifhd
        QZgDjkzQcq9xsH2LsmvZDROyErVj8yg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-7JVgngFqPT-nrBPOQHIF9g-1; Thu, 30 Apr 2020 09:02:19 -0400
X-MC-Unique: 7JVgngFqPT-nrBPOQHIF9g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B877E1895A39;
        Thu, 30 Apr 2020 13:02:17 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6B456606F;
        Thu, 30 Apr 2020 13:02:15 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: [PATCH net v2 3/5] mptcp: avoid a WARN on bad input.
Date:   Thu, 30 Apr 2020 15:01:53 +0200
Message-Id: <44726bfb7c1f4d3f8e90f61b6a70d055b8333064.1588243786.git.pabeni@redhat.com>
In-Reply-To: <cover.1588243786.git.pabeni@redhat.com>
References: <cover.1588243786.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

