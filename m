Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B7A2C56EB
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 15:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390463AbgKZOSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 09:18:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390008AbgKZOSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 09:18:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606400296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Cyox3C73y/oKb3KzoV3DILK3feE+iYmEvrTe6S/5lyU=;
        b=Kt4jjiZo14vxVWuGSXyJXrottJH2ispknddCbTisRgoaTFnvb9kkl0aTqGo/JBHDpOjzrv
        06qD02ymqWPhrHSMy/NZNkUYNWuDh/BJ82EpOjbu08LwByUeSM33Hgg3feqt9Ayd5LTP4k
        BLStTQ/pGHEvWYiflJYFB1SdSIyempY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-JV4qdTjOOT-lRNioncd8JQ-1; Thu, 26 Nov 2020 09:18:14 -0500
X-MC-Unique: JV4qdTjOOT-lRNioncd8JQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B2EA514B;
        Thu, 26 Nov 2020 14:18:13 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-72.ams2.redhat.com [10.36.115.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77C0460855;
        Thu, 26 Nov 2020 14:18:12 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net] mptcp: fix NULL ptr dereference on bad MPJ
Date:   Thu, 26 Nov 2020 15:17:53 +0100
Message-Id: <03b2cfa3ac80d8fc18272edc6442a9ddf0b1e34e.1606400227.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an msk listener receives an MPJ carrying an invalid token, it
will zero the request socket msk entry. That should later
cause fallback and subflow reset - as per RFC - at
subflow_syn_recv_sock() time due to failing hmac validation.

Since commit 4cf8b7e48a09 ("subflow: introduce and use
mptcp_can_accept_new_subflow()"), we unconditionally dereference
- in mptcp_can_accept_new_subflow - the subflow request msk
before performing hmac validation. In the above scenario we
hit a NULL ptr dereference.

Address the issue doing the hmac validation earlier.

Fixes: 4cf8b7e48a09 ("subflow: introduce and use mptcp_can_accept_new_subflow()")
Tested-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index ac4a1fe3550b..953906e40742 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -543,9 +543,8 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			fallback = true;
 	} else if (subflow_req->mp_join) {
 		mptcp_get_options(skb, &mp_opt);
-		if (!mp_opt.mp_join ||
-		    !mptcp_can_accept_new_subflow(subflow_req->msk) ||
-		    !subflow_hmac_valid(req, &mp_opt)) {
+		if (!mp_opt.mp_join || !subflow_hmac_valid(req, &mp_opt) ||
+		    !mptcp_can_accept_new_subflow(subflow_req->msk)) {
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
 			fallback = true;
 		}
-- 
2.26.2

