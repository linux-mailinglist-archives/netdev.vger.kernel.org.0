Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50B8482100
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 01:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242381AbhLaAgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 19:36:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58348 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhLaAgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 19:36:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CED3F61772
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 00:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C72C36AEC;
        Fri, 31 Dec 2021 00:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640911003;
        bh=deIr3FoAlbA96ie3jUkKI8/XCel534VYawwRtJPtuHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uE93gRhL/bwJzCcv4Y5lYjPP/Se+piX5iR8eWVxkocD5zOKaoZhmUYwW8zaRn1yjS
         9lvMiEwFgo28ZySNBVZD5P4GkyV4bawO+2NqbT6KczWW+dPleSW1OY/1vox2UyLeKm
         5Nnkrss1XEl5o0SzV+MIikArOT5tUhC6QJLomvIOoCslhl3KUdU63ug5ez7T9UQAkW
         B0I8QARdDLjLjp5JIXLLAVjAXwI2wlereKzIjMmrZvSZVtGECWbJe06ReCfd/bQlHM
         KPbkVbAXGSlyHNNm8gpqR8+XgFk2Y1Weeirq+K9jKd/b7fUbK9LJtX+9OhLfG9MeJS
         3N7CzPiNOIZuw==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: [PATCH net 4/5] ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route
Date:   Thu, 30 Dec 2021 17:36:34 -0700
Message-Id: <20211231003635.91219-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20211231003635.91219-1-dsahern@kernel.org>
References: <20211231003635.91219-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure RTA_GATEWAY for IPv6 multipath route has enough bytes to hold
an IPv6 address.

Fixes: 6b9ea5a64ed5 ("ipv6: fix multipath route replace error recovery")
Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Roopa Prabhu <roopa@nvidia.com>
---
 net/ipv6/route.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index d16599c225b8..b311c0bc9983 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5453,7 +5453,11 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
 			if (nla) {
-				nla_memcpy(&r_cfg.fc_gateway, nla, 16);
+				err = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
+							extack);
+				if (err)
+					return err;
+
 				r_cfg.fc_flags |= RTF_GATEWAY;
 			}
 		}
-- 
2.24.3 (Apple Git-128)

