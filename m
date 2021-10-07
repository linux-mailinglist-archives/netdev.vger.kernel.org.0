Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CED2424CEB
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 07:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240167AbhJGF5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 01:57:30 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37678 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231797AbhJGF5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 01:57:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9AC4F20571;
        Thu,  7 Oct 2021 07:55:28 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rVyKjnfQ2kqO; Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9043B2056D;
        Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 8167D80004A;
        Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 07:55:27 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Thu, 7 Oct
 2021 07:55:27 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A44B73183BF0; Thu,  7 Oct 2021 07:55:26 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/5] include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI breakage
Date:   Thu, 7 Oct 2021 07:55:21 +0200
Message-ID: <20211007055524.319785-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007055524.319785-1-steffen.klassert@secunet.com>
References: <20211007055524.319785-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eugene Syromiatnikov <esyr@redhat.com>

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
Acked-by: Antony Antony <antony.antony@secunet.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/uapi/linux/xfrm.h   | 6 +++---
 security/selinux/nlmsgtab.c | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index b96c1ea7166d..26f456b1f33e 100644
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
index d59276f48d4f..94ea2a8b2bb7 100644
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
2.25.1

