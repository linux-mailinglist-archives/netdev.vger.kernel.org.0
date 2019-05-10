Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1163819A9A
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 11:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfEJJ1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 05:27:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbfEJJ1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 05:27:43 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0A93E307D914;
        Fri, 10 May 2019 09:27:43 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D272B1001E78;
        Fri, 10 May 2019 09:27:41 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        David Miller <davem@davemloft.net>
Subject: [PATCH net] Revert "selinux: do not report error on connect(AF_UNSPEC)"
Date:   Fri, 10 May 2019 11:27:22 +0200
Message-Id: <7b313602784e5cbbdc7bb8028a3e746c88795060.1557478063.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 10 May 2019 09:27:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 7301017039d68c920cb9120c035a1a0df3e6b30d.

It was agreed a slightly different fix via the selinux tree.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
Note: this is targeting the 'net' tree
---
 security/selinux/hooks.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d82b87c16b0a..c61787b15f27 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4649,7 +4649,7 @@ static int selinux_socket_connect_helper(struct socket *sock,
 		struct lsm_network_audit net = {0,};
 		struct sockaddr_in *addr4 = NULL;
 		struct sockaddr_in6 *addr6 = NULL;
-		unsigned short snum = 0;
+		unsigned short snum;
 		u32 sid, perm;
 
 		/* sctp_connectx(3) calls via selinux_sctp_bind_connect()
@@ -4674,12 +4674,12 @@ static int selinux_socket_connect_helper(struct socket *sock,
 			break;
 		default:
 			/* Note that SCTP services expect -EINVAL, whereas
-			 * others must handle this at the protocol level:
-			 * connect(AF_UNSPEC) on a connected socket is
-			 * a documented way disconnect the socket.
+			 * others expect -EAFNOSUPPORT.
 			 */
 			if (sksec->sclass == SECCLASS_SCTP_SOCKET)
 				return -EINVAL;
+			else
+				return -EAFNOSUPPORT;
 		}
 
 		err = sel_netport_sid(sk->sk_protocol, snum, &sid);
-- 
2.20.1

