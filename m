Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 630BB12B802
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbfL0RnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbfL0Rm7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5C4021582;
        Fri, 27 Dec 2019 17:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468578;
        bh=W5diUPELY4oLSpPA8kPJzjkkXH+jQSwlO+k3E2557j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9+YyvGcExY1Bb4Dw5QvBu1ES+bM5iZabCaexxKTQmmNjLoJidH1YTEaKKgu7UQlw
         tqAIKIiBNZD/nE2sck+XP3bbvmW9tYGqfqMIEGvidTn4ibWP7mmOqpH4BhpPOi2eKT
         Smx9hXjxX52WHGDq9neizuTaT34ktFayklA4OamE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangbin Liu <liuhangbin@gmail.com>, Jianlin Shi <jishi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 102/187] ipv6/addrconf: only check invalid header values when NETLINK_F_STRICT_CHK is set
Date:   Fri, 27 Dec 2019 12:39:30 -0500
Message-Id: <20191227174055.4923-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 2beb6d2901a3f73106485d560c49981144aeacb1 ]

In commit 4b1373de73a3 ("net: ipv6: addr: perform strict checks also for
doit handlers") we add strict check for inet6_rtm_getaddr(). But we did
the invalid header values check before checking if NETLINK_F_STRICT_CHK
is set. This may break backwards compatibility if user already set the
ifm->ifa_prefixlen, ifm->ifa_flags, ifm->ifa_scope in their netlink code.

I didn't move the nlmsg_len check because I thought it's a valid check.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 4b1373de73a3 ("net: ipv6: addr: perform strict checks also for doit handlers")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 34ccef18b40e..f9b5690e94fd 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5231,16 +5231,16 @@ static int inet6_rtm_valid_getaddr_req(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
+	if (!netlink_strict_get_check(skb))
+		return nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
+					      ifa_ipv6_policy, extack);
+
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifa_prefixlen || ifm->ifa_flags || ifm->ifa_scope) {
 		NL_SET_ERR_MSG_MOD(extack, "Invalid values in header for get address request");
 		return -EINVAL;
 	}
 
-	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
-					      ifa_ipv6_policy, extack);
-
 	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*ifm), tb, IFA_MAX,
 					    ifa_ipv6_policy, extack);
 	if (err)
-- 
2.20.1

