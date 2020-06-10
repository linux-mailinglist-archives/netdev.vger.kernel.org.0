Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AF11F5090
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 10:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgFJItu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 04:49:50 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55038 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgFJItt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 04:49:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591778989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uzLvNrggJaRirO+WLYK4fkDQH7nTtGJL89/rrpcDbYU=;
        b=ibU1I3swTNAsgaRoUes6o6QuHLN3/9nzi7xecQVqu4VvObFyB0Geu2A0ZWfhGyRdTZeA34
        iIx1SYNrzmpoZQTIwbi373F4XHl/hY36OwnYsLOVGvz+aGp6nMQQK7HhXQCUsvAmOTqL5U
        iZKM8GGC8a6dPzMddYwmG8zzSaLy3Oo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-x6tuKzh4PvSz18VtxzP8AA-1; Wed, 10 Jun 2020 04:49:47 -0400
X-MC-Unique: x6tuKzh4PvSz18VtxzP8AA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57529193F561;
        Wed, 10 Jun 2020 08:49:45 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-163.ams2.redhat.com [10.36.114.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 020C161169;
        Wed, 10 Jun 2020 08:49:43 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net] mptcp: don't leak msk in token container
Date:   Wed, 10 Jun 2020 10:49:00 +0200
Message-Id: <f52cfae0ddacd91b37a804f19a6ffa2f79efe56f.1591778889.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a listening MPTCP socket has unaccepted sockets at close
time, the related msks are freed via mptcp_sock_destruct(),
which in turn does not invoke the proto->destroy() method
nor the mptcp_token_destroy() function.

Due to the above, the child msk socket is not removed from
the token container, leading to later UaF.

Address the issue explicitly removing the token even in the
above error path.

Fixes: 79c0949e9a09 ("mptcp: Add key generation and token tree")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 493b98a0825c..bf132575040d 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -393,6 +393,7 @@ static void mptcp_sock_destruct(struct sock *sk)
 		sock_orphan(sk);
 	}
 
+	mptcp_token_destroy(mptcp_sk(sk)->token);
 	inet_sock_destruct(sk);
 }
 
-- 
2.21.3

