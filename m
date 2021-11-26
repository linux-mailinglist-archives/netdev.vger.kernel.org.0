Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E268A45EF5C
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 14:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377623AbhKZNsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 08:48:35 -0500
Received: from relay.sw.ru ([185.231.240.75]:38014 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353601AbhKZNqe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 08:46:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=y6Rc0CL1DIZN5nJz/dbeY/5C3ACRkascP4EYJdw5XwA=; b=DHgl/FKDM8+w
        jA7iEWuEeIaJYRekC/jSIEQrPxzG11CDE0LczTwSN/9pv1wqmnq3NIp8v5mLdB5YptqpSCRUMhkcr
        hkUkNiVfH8jgKqB3/E7WMdkBfr8NGUs8kyFUgV0+87E7emQLfOGjVyIq9F0SYmbr68/BO85J3uGaR
        a1k5E=;
Received: from [10.94.6.52] (helo=dhcp-172-16-24-175.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1mqbVW-001WWy-KH; Fri, 26 Nov 2021 16:43:18 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: [PATCH net-next] rtnetlink: add RTNH_REJECT_MASK
Date:   Fri, 26 Nov 2021 16:43:11 +0300
Message-Id: <20211126134311.920808-2-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20211126134311.920808-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce RTNH_REJECT_MASK mask which contains
all rtnh_flags which can't be set by the userspace
directly.

This mask will be used in the iproute utility
to exclude rtnh_flags which can't be restored
from "ip route save" image.

This patch doesn't change kernel behavior at all.

Please, take a look on
[PATCH iproute2] ip route: save: exclude rtnh_flags which can't be set

Cc: David Miller <davem@davemloft.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
---
 include/uapi/linux/rtnetlink.h | 3 +++
 net/ipv4/fib_semantics.c       | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 5888492a5257..9c065e2fdef9 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -417,6 +417,9 @@ struct rtnexthop {
 #define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | \
 				 RTNH_F_OFFLOAD | RTNH_F_TRAP)
 
+/* these flags can't be set by the userspace */
+#define RTNH_REJECT_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN)
+
 /* Macros to handle hexthops */
 
 #define RTNH_ALIGNTO	4
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 4c0c33e4710d..805f5e05b56d 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -685,7 +685,7 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 			return -EINVAL;
 		}
 
-		if (rtnh->rtnh_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)) {
+		if (rtnh->rtnh_flags & RTNH_REJECT_MASK) {
 			NL_SET_ERR_MSG(extack,
 				       "Invalid flags for nexthop - can not contain DEAD or LINKDOWN");
 			return -EINVAL;
@@ -1363,7 +1363,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		goto err_inval;
 	}
 
-	if (cfg->fc_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)) {
+	if (cfg->fc_flags & RTNH_REJECT_MASK) {
 		NL_SET_ERR_MSG(extack,
 			       "Invalid rtm_flags - can not contain DEAD or LINKDOWN");
 		goto err_inval;
-- 
2.31.1

