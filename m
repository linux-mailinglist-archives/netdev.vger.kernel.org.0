Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3037B407D3E
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 14:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhILMYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 08:24:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229635AbhILMYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 08:24:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631449368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=1/mMQELQZiMz9Q+GRXiU0TewWb3BVRJlK3Wk36Ex13w=;
        b=iFdEQ9IyrTtInwYN98G6AIgZnVsUr1jjJ4UJe87a/DsiaVAiojn3kcCanUZyQ2ac3BUjo8
        /K2weq1W0p0KhyXga3gv6eiJsJKUaSRPuX4Zk47h1kZdH85yxzD823jl7w9gnd3ZD5Yg5W
        9/s0dj0T6XQtOzqpCpzvNCMQHc5eKfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-4_Gw31TEPTCz6B7C99489Q-1; Sun, 12 Sep 2021 08:22:46 -0400
X-MC-Unique: 4_Gw31TEPTCz6B7C99489Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C997410059CF;
        Sun, 12 Sep 2021 12:22:43 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E2FD5C25A;
        Sun, 12 Sep 2021 12:22:36 +0000 (UTC)
Date:   Sun, 12 Sep 2021 14:22:34 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antony Antony <antony.antony@secunet.com>,
        Christian Langrock <christian.langrock@secunet.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Dmitry V. Levin" <ldv@strace.io>,
        linux-api@vger.kernel.org
Subject: [PATCH v2] include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI
 breakage
Message-ID: <20210912122234.GA22469@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2d151d39073a ("xfrm: Add possibility to set the default to block
if we have no policy") broke ABI by changing the value of the XFRM_MSG_MAPPING
enum item, thus also evading the build-time check
in security/selinux/nlmsgtab.c:selinux_nlmsg_lookup for presence of proper
security permission checks in nlmsg_xfrm_perms.  Fix it by placing
XFRM_MSG_SETDEFAULT/XFRM_MSG_GETDEFAULT to the end of the enum, right before
__XFRM_MSG_MAX, and updating the nlmsg_xfrm_perms accordingly.

Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
References: https://lore.kernel.org/netdev/20210901151402.GA2557@altlinux.org/
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
v2:
 - Updated SELinux nlmsg_xfrm_perms permissions table and selinux_nlmsg_lookup
   build-time check accordingly.

v1: https://lore.kernel.org/lkml/20210901153407.GA20446@asgard.redhat.com/
---
 include/uapi/linux/xfrm.h   | 6 +++---
 security/selinux/nlmsgtab.c | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index b96c1ea..26f456b1 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -213,13 +213,13 @@ enum {
 	XFRM_MSG_GETSPDINFO,
 #define XFRM_MSG_GETSPDINFO XFRM_MSG_GETSPDINFO
 
+	XFRM_MSG_MAPPING,
+#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
+
 	XFRM_MSG_SETDEFAULT,
 #define XFRM_MSG_SETDEFAULT XFRM_MSG_SETDEFAULT
 	XFRM_MSG_GETDEFAULT,
 #define XFRM_MSG_GETDEFAULT XFRM_MSG_GETDEFAULT
-
-	XFRM_MSG_MAPPING,
-#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
 	__XFRM_MSG_MAX
 };
 #define XFRM_MSG_MAX (__XFRM_MSG_MAX - 1)
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index d59276f..94ea2a8 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -126,6 +126,8 @@ static const struct nlmsg_perm nlmsg_xfrm_perms[] =
 	{ XFRM_MSG_NEWSPDINFO,	NETLINK_XFRM_SOCKET__NLMSG_WRITE },
 	{ XFRM_MSG_GETSPDINFO,	NETLINK_XFRM_SOCKET__NLMSG_READ  },
 	{ XFRM_MSG_MAPPING,	NETLINK_XFRM_SOCKET__NLMSG_READ  },
+	{ XFRM_MSG_SETDEFAULT,	NETLINK_XFRM_SOCKET__NLMSG_WRITE },
+	{ XFRM_MSG_GETDEFAULT,	NETLINK_XFRM_SOCKET__NLMSG_READ  },
 };
 
 static const struct nlmsg_perm nlmsg_audit_perms[] =
@@ -189,7 +191,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
 		 * structures at the top of this file with the new mappings
 		 * before updating the BUILD_BUG_ON() macro!
 		 */
-		BUILD_BUG_ON(XFRM_MSG_MAX != XFRM_MSG_MAPPING);
+		BUILD_BUG_ON(XFRM_MSG_MAX != XFRM_MSG_GETDEFAULT);
 		err = nlmsg_perm(nlmsg_type, perm, nlmsg_xfrm_perms,
 				 sizeof(nlmsg_xfrm_perms));
 		break;
-- 
2.1.4

