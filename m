Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6DD1BF8D5
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgD3NDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:03:52 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20747 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726520AbgD3NDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:03:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588251831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=liUgaQ0C1QA3guj50KZY4HAN6D0MtvZYh00hIznPhNA=;
        b=Xs+YO6ZS2sXy69A20WjG2OekMkZZVQ0WqAUGr3sZMVAaqmH+TSHJc8xbU0KhuKr+K3P7xu
        SZrl6JH3gFsFGaLPO2HS0k/eI9UC5Xr3Odmm/7S0V4YkQERbbmp3QN2zshCRViD1NJ5Dai
        kV5tm5xi5/AQIGPhtFgVjFw8id90PYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-FjBgro-YNr-6NWXZFx-b1Q-1; Thu, 30 Apr 2020 09:03:49 -0400
X-MC-Unique: FjBgro-YNr-6NWXZFx-b1Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DA5C1800D4A;
        Thu, 30 Apr 2020 13:03:48 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 675A2512E9;
        Thu, 30 Apr 2020 13:03:46 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net v2] mptcp: fix uninitialized value access
Date:   Thu, 30 Apr 2020 15:03:22 +0200
Message-Id: <a94e83fdb29c9c3cdd971e3f57c434efa757c750.1588243772.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_v{4,6}_syn_recv_sock() set 'own_req' only when returning
a not NULL 'child', let's check 'own_req' only if child is
available to avoid an - unharmful - UBSAN splat.

v1 -> v2:
 - reference the correct hash

Fixes: 4c8941de781c ("mptcp: avoid flipping mp_capable field in syn_recv_=
sock()")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index bad998529767..67a4e35d4838 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -523,7 +523,7 @@ static struct sock *subflow_syn_recv_sock(const struc=
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

