Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289E243E0BC
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhJ1MXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhJ1MXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 08:23:07 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31F2C061570;
        Thu, 28 Oct 2021 05:20:40 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1635423639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HuLmrknqKnj+uCiF1w4Lwe6N+b32tTBwksurG4f0/zw=;
        b=XVCwugBDhR8XjESFAbqF6hw/6e0PR24MRPVDYfK/vsmUFCGwtmqdmRUCvOuDObqvz2voTu
        eaozg4OBZxpIRVB8GoiQgl6IoyAXxDrv3r67PdtPz6VPrhyQ0CnmcqV3N1wTNwDqyLiBgc
        CACoUtdAf/NztzSE28igDXJ97L5xyd4=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] neigh: use struct {arp, ndisc}_generic_ops for all case
Date:   Thu, 28 Oct 2021 20:20:22 +0800
Message-Id: <20211028122022.14879-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These struct {arp, ndisc}_generic_ops can cover all case, so those
struct {arp, ndisc}_hh_ops are no need, remove them.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/ipv4/arp.c   | 15 ++-------------
 net/ipv6/ndisc.c | 18 ++++--------------
 2 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 922dd73e5740..9ee59c2e419a 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -135,14 +135,6 @@ static const struct neigh_ops arp_generic_ops = {
 	.connected_output =	neigh_connected_output,
 };
 
-static const struct neigh_ops arp_hh_ops = {
-	.family =		AF_INET,
-	.solicit =		arp_solicit,
-	.error_report =		arp_error_report,
-	.output =		neigh_resolve_output,
-	.connected_output =	neigh_resolve_output,
-};
-
 static const struct neigh_ops arp_direct_ops = {
 	.family =		AF_INET,
 	.output =		neigh_direct_output,
@@ -277,12 +269,9 @@ static int arp_constructor(struct neighbour *neigh)
 			memcpy(neigh->ha, dev->broadcast, dev->addr_len);
 		}
 
-		if (dev->header_ops->cache)
-			neigh->ops = &arp_hh_ops;
-		else
-			neigh->ops = &arp_generic_ops;
+		neigh->ops = &arp_generic_ops;
 
-		if (neigh->nud_state & NUD_VALID)
+		if (!dev->header_ops->cache && (neigh->nud_state & NUD_VALID))
 			neigh->output = neigh->ops->connected_output;
 		else
 			neigh->output = neigh->ops->output;
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 184190b9ea25..a544bd7454c4 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -91,15 +91,6 @@ static const struct neigh_ops ndisc_generic_ops = {
 	.connected_output =	neigh_connected_output,
 };
 
-static const struct neigh_ops ndisc_hh_ops = {
-	.family =		AF_INET6,
-	.solicit =		ndisc_solicit,
-	.error_report =		ndisc_error_report,
-	.output =		neigh_resolve_output,
-	.connected_output =	neigh_resolve_output,
-};
-
-
 static const struct neigh_ops ndisc_direct_ops = {
 	.family =		AF_INET6,
 	.output =		neigh_direct_output,
@@ -357,11 +348,10 @@ static int ndisc_constructor(struct neighbour *neigh)
 			neigh->nud_state = NUD_NOARP;
 			memcpy(neigh->ha, dev->broadcast, dev->addr_len);
 		}
-		if (dev->header_ops->cache)
-			neigh->ops = &ndisc_hh_ops;
-		else
-			neigh->ops = &ndisc_generic_ops;
-		if (neigh->nud_state&NUD_VALID)
+
+		neigh->ops = &ndisc_generic_ops;
+
+		if (!dev->header_ops->cache && (neigh->nud_state & NUD_VALID))
 			neigh->output = neigh->ops->connected_output;
 		else
 			neigh->output = neigh->ops->output;
-- 
2.32.0

