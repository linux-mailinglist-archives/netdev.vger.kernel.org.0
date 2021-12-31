Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4411D482104
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 01:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242389AbhLaAgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 19:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhLaAgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 19:36:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0701AC06173E
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 16:36:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B52961767
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 00:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E4CC36AEB;
        Fri, 31 Dec 2021 00:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640911004;
        bh=Bgnu5dlqLnOvVfWBqEybGWtgNNr1hYyoPme7431h2xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HrrjUiuc6aFpsVyvUNbc0vSaCYhif1tO0iaPvUfkiVmZ/7uTipz0FX5aT3zzWVW8a
         BBHvYipuIbwo0Fo3/sLjVAkNBGHp+cMN4iUjwMJogTfBMmGMF8XjtyvPBwjtp9R4jC
         Y9+sIPwepFeM5x91fFLbVobTj84J4j6Xpqg/1MsMR7PgLmJHWBgdOeYtjbCKgfT0/5
         89hdzmtkupc0zCcA9tNCPmbygQ23Z80RUtaU/897mgT7q5G+VjBqB8BwEz25pw8AE0
         2ptNNB7j4Jtq1zNs2wzNRukaVTgMG2MSv/1drO8QYH38W+xL/uLPWBvgaDCT4VqziE
         f7l5RufildhgQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH net 5/5] lwtunnel: Validate RTA_ENCAP_TYPE attribute length
Date:   Thu, 30 Dec 2021 17:36:35 -0700
Message-Id: <20211231003635.91219-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20211231003635.91219-1-dsahern@kernel.org>
References: <20211231003635.91219-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lwtunnel_valid_encap_type_attr is used to validate encap attributes
within a multipath route. Add length validation checking to the type.

lwtunnel_valid_encap_type_attr is called converting attributes to
fib{6,}_config struct which means it is used before fib_get_nhs,
ip6_route_multipath_add, and ip6_route_multipath_del - other
locations that use rtnh_ok and then nla_get_u16 on RTA_ENCAP_TYPE
attribute.

Fixes: 9ed59592e3e3 ("lwtunnel: fix autoload of lwt modules")

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/core/lwtunnel.c      | 4 ++++
 net/ipv4/fib_semantics.c | 3 +++
 net/ipv6/route.c         | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 2820aca2173a..9ccd64e8a666 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -197,6 +197,10 @@ int lwtunnel_valid_encap_type_attr(struct nlattr *attr, int remaining,
 			nla_entype = nla_find(attrs, attrlen, RTA_ENCAP_TYPE);
 
 			if (nla_entype) {
+				if (nla_len(nla_entype) < sizeof(u16)) {
+					NL_SET_ERR_MSG(extack, "Invalid RTA_ENCAP_TYPE");
+					return -EINVAL;
+				}
 				encap_type = nla_get_u16(nla_entype);
 
 				if (lwtunnel_valid_encap_type(encap_type,
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 36bc429f1635..92c29ab3d042 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -740,6 +740,9 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 			}
 
 			fib_cfg.fc_encap = nla_find(attrs, attrlen, RTA_ENCAP);
+			/* RTA_ENCAP_TYPE length checked in
+			 * lwtunnel_valid_encap_type_attr
+			 */
 			nla = nla_find(attrs, attrlen, RTA_ENCAP_TYPE);
 			if (nla)
 				fib_cfg.fc_encap_type = nla_get_u16(nla);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index b311c0bc9983..d2ff8a7e1709 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5287,6 +5287,10 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 				r_cfg.fc_flags |= RTF_GATEWAY;
 			}
 			r_cfg.fc_encap = nla_find(attrs, attrlen, RTA_ENCAP);
+
+			/* RTA_ENCAP_TYPE length checked in
+			 * lwtunnel_valid_encap_type_attr
+			 */
 			nla = nla_find(attrs, attrlen, RTA_ENCAP_TYPE);
 			if (nla)
 				r_cfg.fc_encap_type = nla_get_u16(nla);
-- 
2.24.3 (Apple Git-128)

