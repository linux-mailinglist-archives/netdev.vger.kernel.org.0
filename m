Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4612DBFBF
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 12:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgLPLu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 06:50:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49426 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbgLPLu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 06:50:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608119340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ANHThWdmFFxL8/YxR3ZIed/xwyinScbXYPrqp44Ii0c=;
        b=ZhS0xHM7AJd1dVmGmSxo9IUna5FbRzoMTb/GNTvZvEjxL6GuVviaJ6+0GDRov8RUFRSs5z
        YfdhCVg/+Ry9rnHpVDs5x2CRKOIohMKIz1xidm8szeeDn4ivWROhvlvNOOSlKaACiWeJc0
        duHHzYUkKJ3vj68z/+XRUlbmvIGSmmE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-1WnE-JDvO-Kl0-pA87_C2Q-1; Wed, 16 Dec 2020 06:48:58 -0500
X-MC-Unique: 1WnE-JDvO-Kl0-pA87_C2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2CEF800479;
        Wed, 16 Dec 2020 11:48:51 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-143.ams2.redhat.com [10.36.112.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A619B77F12;
        Wed, 16 Dec 2020 11:48:50 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net 2/4] mptcp: properly annotate nested lock
Date:   Wed, 16 Dec 2020 12:48:33 +0100
Message-Id: <0cbf6359084bee1187ba382a015d8809e2ce2416.1608114076.git.pabeni@redhat.com>
In-Reply-To: <cover.1608114076.git.pabeni@redhat.com>
References: <cover.1608114076.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MPTCP closes the subflows while holding the msk-level lock.
While acquiring the subflow socket lock we need to use the
correct nested annotation, or we can hit a lockdep splat
at runtime.

Reported-and-tested-by: Geliang Tang <geliangtang@gmail.com>
Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d24243a28fce..64c0c54c80e8 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2119,7 +2119,7 @@ void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 
 	list_del(&subflow->node);
 
-	lock_sock(ssk);
+	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
 
 	/* if we are invoked by the msk cleanup code, the subflow is
 	 * already orphaned
-- 
2.26.2

