Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E4B2664F7
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgIKQtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:49:11 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46946 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgIKPGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:06:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599836799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZKF4MuMJRJnl3W8pCnFsdzq1VYiRt3b1ir1fAlXZi6Q=;
        b=hoCdIdCusKVIt7JiyqyW/6ENtlxBxXkPM2IsjzFVIEVg7How+c2uXVnux9PJQuuBaPg0YW
        MbYLGCHrjx32WyHSPRzAC4/riAF1B9IwBL5VgvsuNlN39mb7Bc4QSfdJNQAs2TgbVxdMi3
        V+vw504Ij533LSCaxTGUMs+bVyX0scE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-qcsuMo-WPfGqVHpjenSySQ-1; Fri, 11 Sep 2020 09:52:43 -0400
X-MC-Unique: qcsuMo-WPfGqVHpjenSySQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEAAF18C5205;
        Fri, 11 Sep 2020 13:52:42 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-214.ams2.redhat.com [10.36.114.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9834A5C22A;
        Fri, 11 Sep 2020 13:52:41 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 10/13] mptcp: allow creating non-backup subflows
Date:   Fri, 11 Sep 2020 15:52:05 +0200
Message-Id: <c85687bfad852a7d23ba52b96cbb1b7dc85c3b2a.1599832097.git.pabeni@redhat.com>
In-Reply-To: <cover.1599832097.git.pabeni@redhat.com>
References: <cover.1599832097.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the 'backup' attribute of local endpoint
is ignored. Let's use it for the MP_JOIN handshake

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 9edcce21715b..58f2349930a5 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -20,6 +20,7 @@
 #include <net/ip6_route.h>
 #endif
 #include <net/mptcp.h>
+#include <uapi/linux/mptcp.h>
 #include "protocol.h"
 #include "mib.h"
 
@@ -1090,7 +1091,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	subflow->remote_token = remote_token;
 	subflow->local_id = local_id;
 	subflow->request_join = 1;
-	subflow->request_bkup = 1;
+	subflow->request_bkup = !!(loc->flags & MPTCP_PM_ADDR_FLAG_BACKUP);
 	mptcp_info2sockaddr(remote, &addr);
 
 	err = kernel_connect(sf, (struct sockaddr *)&addr, addrlen, O_NONBLOCK);
-- 
2.26.2

