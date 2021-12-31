Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9204820FF
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 01:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242379AbhLaAgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 19:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242375AbhLaAgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 19:36:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216BBC06173E
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 16:36:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E12FC6176C
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 00:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3410C36AEA;
        Fri, 31 Dec 2021 00:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640911002;
        bh=bDBXM+NHGraNqtKnX/tgY3lhc10v0kGbQBjowg0ItGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuYfqjENEZ6P+hF15ocid3IXInkRI2BdjAJOuMBfMGjRGz06h68LmJ6gSnbuFW6/7
         qbl3VOf4KwYcuCkgIEaJSqDi7TDV+2USYhdYJLBeAvGs18XOjb1YQ++YGmJs13Tt9K
         Z2999ILPjGS7wZoG9hp2IqsAolvCOm4cXGa3XAqlWV9g1A7doWRWFnPfb+pd2tGKS9
         xz4+SvYZj4nU2lzg4zaDNpNqMtTPgO/3CEvJDVwvnRyCgqGK2Eiefhlrsfjbts/MpA
         ujffruJ9BCbYBS8YjJPuuDlIEeKQ+bM8jr/PCBUeHSSRliBJcbKEXZaRRw3iRpjK+S
         27cRrheokPQzA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, David Ahern <dsahern@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net 3/5] ipv6: Check attribute length for RTA_GATEWAY in multipath route
Date:   Thu, 30 Dec 2021 17:36:33 -0700
Message-Id: <20211231003635.91219-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20211231003635.91219-1-dsahern@kernel.org>
References: <20211231003635.91219-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit referenced in the Fixes tag used nla_memcpy for RTA_GATEWAY as
does the current nla_get_in6_addr. nla_memcpy protects against accessing
memory greater than what is in the attribute, but there is no check
requiring the attribute to have an IPv6 address. Add it.

Fixes: 51ebd3181572 ("ipv6: add support of equal cost multipath (ECMP)")
Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/ipv6/route.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 42d60c76d30a..d16599c225b8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5224,6 +5224,19 @@ static bool ip6_route_mpath_should_notify(const struct fib6_info *rt)
 	return should_notify;
 }
 
+static int fib6_gw_from_attr(struct in6_addr *gw, struct nlattr *nla,
+			     struct netlink_ext_ack *extack)
+{
+	if (nla_len(nla) < sizeof(*gw)) {
+		NL_SET_ERR_MSG(extack, "Invalid IPv6 address in RTA_GATEWAY");
+		return -EINVAL;
+	}
+
+	*gw = nla_get_in6_addr(nla);
+
+	return 0;
+}
+
 static int ip6_route_multipath_add(struct fib6_config *cfg,
 				   struct netlink_ext_ack *extack)
 {
@@ -5264,7 +5277,13 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
 			if (nla) {
-				r_cfg.fc_gateway = nla_get_in6_addr(nla);
+				int ret;
+
+				ret = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
+							extack);
+				if (ret)
+					return ret;
+
 				r_cfg.fc_flags |= RTF_GATEWAY;
 			}
 			r_cfg.fc_encap = nla_find(attrs, attrlen, RTA_ENCAP);
-- 
2.24.3 (Apple Git-128)

