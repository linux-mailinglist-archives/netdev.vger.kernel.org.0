Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F6B1BDA1A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgD2Kvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:51:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51729 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726516AbgD2Kvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 06:51:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588157501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xfE/AAw617iPKTl7j9APnJefhmL0nSXFSdm5hBWKg4c=;
        b=e/qKvn8uTRMPoyDjVVTTV87jGGn1orpntIXaz4FP92LHR9zHexyaJ7nAGABc/naPAScdPs
        dSHIQ9tjZ+C9zMaXy6bUK/ce/j+DP55KXQFjbywXd5g7KAShUUbUj8J0yeKaCD9zPMahvK
        wXABDNJ4I1IWxhlxBUAp6ll5SP1vnKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-miQQCS3mPfOauskQWm6wKg-1; Wed, 29 Apr 2020 06:51:37 -0400
X-MC-Unique: miQQCS3mPfOauskQWm6wKg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83B7B464;
        Wed, 29 Apr 2020 10:51:34 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-45.ams2.redhat.com [10.36.114.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A53466842B;
        Wed, 29 Apr 2020 10:51:32 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net] mptcp: fix uninitialized value access
Date:   Wed, 29 Apr 2020 12:50:37 +0200
Message-Id: <c2b96b3751ccf64357d2c6f0e7d23908dda8a601.1588157274.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_v{4,6}_syn_recv_sock() set 'own_req' only when returning
a not NULL 'child', let's check 'own_req' only if child is
available to avoid an - unharmful - UBSAN splat.

Fixes: 20882e2cb904 ("mptcp: avoid flipping mp_capable field in syn_recv_=
sock()")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index f412e886aa9b..2fa319a36ea5 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -522,7 +522,7 @@ static struct sock *subflow_syn_recv_sock(const struc=
t sock *sk,
 	/* check for expected invariant - should never trigger, just help
 	 * catching eariler subtle bugs
 	 */
-	WARN_ON_ONCE(*own_req && child && tcp_sk(child)->is_mptcp &&
+	WARN_ON_ONCE(child && *own_req && tcp_sk(child)->is_mptcp &&
 		     (!mptcp_subflow_ctx(child) ||
 		      !mptcp_subflow_ctx(child)->conn));
 	return child;
--=20
2.21.1

