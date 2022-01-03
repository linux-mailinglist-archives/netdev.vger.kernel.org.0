Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBAF48354D
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbiACRGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:06:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49026 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbiACRGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:06:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D726261179
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 17:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6973C36AED;
        Mon,  3 Jan 2022 17:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641229562;
        bh=Ar+qCJNhSTQexYkv58YaEI+KTc4Q6KDhFh4i6FFsA0k=;
        h=From:To:Cc:Subject:Date:From;
        b=UNbjAuS3ia6I0+O2q6lc0rfEzA4NVe0d3JjFxediAu4t91ie0uu34eyHcUksmovqs
         yzFjFNy1ByyVHDCx9s0mz+676Pun8uYBNr4D+5po4Max3//7mnIjsy5mAf2ju7ebAh
         6Gzxl8gKQWWp8Bs9NZOpCRVG6vDcDTqbMeYEiTD7FopvrGpkBB3bI65VjJYzcSymil
         2X6G6fJaIcVNyvJv43ape9TsB79QjCxYB1zBnnsVOy2sEa9vHcoWrglEAcYHjczT8k
         +u7Ph7+brQSmAudkPQx0cqIxpkO8q8A/BaSTInj6czIlpC0dA/CaTywE8wkycoFqgd
         UgTPirW+Ud0NQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net] ipv6: Do cleanup if attribute validation fails in multipath route
Date:   Mon,  3 Jan 2022 10:05:55 -0700
Message-Id: <20220103170555.94638-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Nicolas noted, if gateway validation fails walking the multipath
attribute the code should jump to the cleanup to free previously
allocated memory.

Fixes: 23fb261977fd ("ipv6: Check attribute length for RTA_GATEWAY in multipath route")
Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/ipv6/route.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index d2ff8a7e1709..3f36f9603f00 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5277,12 +5277,10 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
 			if (nla) {
-				int ret;
-
-				ret = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
+				err = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
 							extack);
-				if (ret)
-					return ret;
+				if (err)
+					goto cleanup;
 
 				r_cfg.fc_flags |= RTF_GATEWAY;
 			}
-- 
2.24.3 (Apple Git-128)

