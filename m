Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD60483575
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiACRTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:19:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55470 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiACRTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:19:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E89A361174
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 17:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FACC36AED;
        Mon,  3 Jan 2022 17:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641230354;
        bh=I7TYeYOssM5BUT7EChy8NelmVCNQ0M+rZpEMNllNJj0=;
        h=From:To:Cc:Subject:Date:From;
        b=Ja+UCLk8us/n/EnboajQ5edb8w8d1WnpWc5vKorAqy02GwxE81mCRIaFdF1JPXeKj
         EwymVI81O53QWkQFYejxiGM+Qe0aj2XnpcWaJTtHN1snNW8CYzfr6eeOO4OUn+c0fw
         eg7QVDqlnOdfFeuXGkIiWl9AVDiMXswVFg/ujiaG8dlXZHInrJ+M2b2NnQUzbVehnX
         HfKOzJdfnmuY/vcK0irQfN5MkJMaId7kNWf2lcHTzYAzqVxRhjVGLBuGrYy9GGEVIi
         YeXRwe18NmXcDeATklf2STr6WH7WQG9HCpofgJgm3xDFLuQuI2Ar2/NkL2EoAsrAGU
         u2mC7LkkoTrQQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net] ipv6: Continue processing multipath route even if gateway attribute is invalid
Date:   Mon,  3 Jan 2022 10:19:11 -0700
Message-Id: <20220103171911.94739-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip6_route_multipath_del loop continues processing the multipath
attribute even if delete of a nexthop path fails. For consistency,
do the same if the gateway attribute is invalid.

Fixes: d5297ac885b5 ("ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route")
Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/ipv6/route.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 3f36f9603f00..1deb6297aab6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5457,8 +5457,10 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
 			if (nla) {
 				err = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
 							extack);
-				if (err)
-					return err;
+				if (err) {
+					last_err = err;
+					goto next_rtnh;
+				}
 
 				r_cfg.fc_flags |= RTF_GATEWAY;
 			}
@@ -5467,6 +5469,7 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
 		if (err)
 			last_err = err;
 
+next_rtnh:
 		rtnh = rtnh_next(rtnh, &remaining);
 	}
 
-- 
2.24.3 (Apple Git-128)

