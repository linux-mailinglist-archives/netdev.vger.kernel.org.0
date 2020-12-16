Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588C52DBFC6
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 12:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgLPLuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 06:50:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725806AbgLPLuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 06:50:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608119337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJotpa5UrA2ZqCRh7mc8/o/xpESWufExRhTpzsjWsRE=;
        b=aEiKcYJUgkrsoA24oeOA5eohShJ2nrnH/F0VuKWyUO3OQpb2sluwEpnxw187VRpHYE68g2
        A6x1OelY6VlXOFi1Y/v+9EIQow0zs+hgrCXypuiKr7tdQDuR3GQB/MGQoYonhfifTFhq2F
        RDyLxUxJjnJEG9KxMjkC3LhyEepCieU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-RQqi7QP1PSeX4dlz87-RIw-1; Wed, 16 Dec 2020 06:48:55 -0500
X-MC-Unique: RQqi7QP1PSeX4dlz87-RIw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFBAF9CDBA;
        Wed, 16 Dec 2020 11:48:50 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-143.ams2.redhat.com [10.36.112.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 051A077F3F;
        Wed, 16 Dec 2020 11:48:48 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net 1/4] mptcp: fix security context on server socket
Date:   Wed, 16 Dec 2020 12:48:32 +0100
Message-Id: <1bf3ee9b0c79a1e619fe4749d926aab71f0a7bcc.1608114076.git.pabeni@redhat.com>
In-Reply-To: <cover.1608114076.git.pabeni@redhat.com>
References: <cover.1608114076.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently MPTCP is not propagating the security context
from the ingress request socket to newly created msk
at clone time.

Address the issue invoking the missing security helper.

Fixes: cf7da0d66cc1 ("mptcp: Create SUBFLOW socket for incoming connections")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b812aaae8044..d24243a28fce 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2699,6 +2699,8 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	sock_reset_flag(nsk, SOCK_RCU_FREE);
 	/* will be fully established after successful MPC subflow creation */
 	inet_sk_state_store(nsk, TCP_SYN_RECV);
+
+	security_inet_csk_clone(nsk, req);
 	bh_unlock_sock(nsk);
 
 	/* keep a single reference */
-- 
2.26.2

