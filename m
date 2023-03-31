Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734EC6D1750
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjCaGVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCaGVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:21:48 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1200198B
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 23:21:43 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 36CD02070D;
        Fri, 31 Mar 2023 08:21:42 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DCDOqJgKncLQ; Fri, 31 Mar 2023 08:21:41 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B6CE720590;
        Fri, 31 Mar 2023 08:21:41 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id AEF0A80004A;
        Fri, 31 Mar 2023 08:21:41 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 31 Mar 2023 08:21:41 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 31 Mar
 2023 08:21:41 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B44E03182578; Fri, 31 Mar 2023 08:21:40 +0200 (CEST)
Date:   Fri, 31 Mar 2023 08:21:40 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>, <devel@linux-ipsec.org>
CC:     Hyunwoo Kim <v4bel@theori.io>,
        Tudor Ambarus <tudordana@google.com>,
        "Eric Dumazet" <edumazet@google.com>
Subject: [PATCH ipsec] xfrm: Don't allow optional intermediate templates that
 changes the address family
Message-ID: <ZCZ79IlUW53XxaVr@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an optional intermediate template changes the address family,
it is unclear which family the next template should have. This can
lead to misinterpretations of IPv4/IPv6 addresses. So reject
optional intermediate templates on insertion time.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hyunwoo Kim <v4bel@theori.io>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 103af2b3e986..df4e840b630e 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1770,6 +1770,7 @@ static void copy_templates(struct xfrm_policy *xp, struct xfrm_user_tmpl *ut,
 static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family,
 			 struct netlink_ext_ack *extack)
 {
+	bool opt_family_change;
 	u16 prev_family;
 	int i;
 
@@ -1778,6 +1779,7 @@ static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family,
 		return -EINVAL;
 	}
 
+	opt_family_change = false;
 	prev_family = family;
 
 	for (i = 0; i < nr; i++) {
@@ -1791,9 +1793,16 @@ static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family,
 		if (!ut[i].family)
 			ut[i].family = family;
 
+		if (opt_family_change) {
+			NL_SET_ERR_MSG(extack, "Optional intermediate templates don't support family changes");
+			return -EINVAL;
+		}
+
 		switch (ut[i].mode) {
 		case XFRM_MODE_TUNNEL:
 		case XFRM_MODE_BEET:
+			if (ut[i].optional && ut[i].family != prev_family)
+				opt_family_change = true;
 			break;
 		default:
 			if (ut[i].family != prev_family) {
-- 
2.34.1

