Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924DE2686BE
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgINIDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:03:19 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46795 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726186AbgINIB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 04:01:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600070516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iMXJ4inuILmAgMGNwtGTEyzqkuZohSJ6pfsz6vlJn30=;
        b=QHbERFfq8ge9rzimQlMdC1p5kxh0/gaRe1qHzzy7DOnQfKIpVTkxkgfklMRKPHwK1KuA6r
        0gElu2g5YM5Uqn2GuCibpRld8DPmMv8MHH0dGYbdhMg6Ca81DXHdXOHQ3Rm/uh64hZxHUu
        49/fsD3GHSiySD+qtxCsHnxjh+h6wZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-kwIU6Bu2N-O8lwHQiY02Nw-1; Mon, 14 Sep 2020 04:01:54 -0400
X-MC-Unique: kwIU6Bu2N-O8lwHQiY02Nw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F4B8801FCC;
        Mon, 14 Sep 2020 08:01:53 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-112-96.ams2.redhat.com [10.36.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 274A419C66;
        Mon, 14 Sep 2020 08:01:51 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next v2 10/13] mptcp: allow creating non-backup subflows
Date:   Mon, 14 Sep 2020 10:01:16 +0200
Message-Id: <263d1338783f1995a46f13fbae804568ee18cb0d.1599854632.git.pabeni@redhat.com>
In-Reply-To: <cover.1599854632.git.pabeni@redhat.com>
References: <cover.1599854632.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
index ae3eeb9bb191..8be401349d9f 100644
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

