Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB6114C085
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 20:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgA1TD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 14:03:58 -0500
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:51522 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726234AbgA1TD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 14:03:58 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 9CFE5247F;
        Tue, 28 Jan 2020 19:03:56 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:4385:5007:10004:10400:10848:11026:11658:11914:12043:12297:12438:12555:12760:13069:13311:13357:13439:14096:14097:14181:14394:14659:14721:21080:21433:21611:21627:21990,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: fish97_224a391ab8e4c
X-Filterd-Recvd-Size: 1907
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Tue, 28 Jan 2020 19:03:55 +0000 (UTC)
Message-ID: <2dd59a9ea0ed9029caf1b91fb6758ecc7f1dd695.camel@perches.com>
Subject: [PATCH] net: drop_monitor: Use kstrdup
From:   Joe Perches <joe@perches.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Tue, 28 Jan 2020 11:02:50 -0800
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the equivalent but rather odd uses of kmemdup with
__GFP_ZERO to the more common kstrdup and avoid unnecessary
zeroing of copied over memory.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/core/drop_monitor.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 536e032..ea46fc 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -802,16 +802,12 @@ net_dm_hw_metadata_clone(const struct net_dm_hw_metadata *hw_metadata)
 	if (!n_hw_metadata)
 		return NULL;
 
-	trap_group_name = kmemdup(hw_metadata->trap_group_name,
-				  strlen(hw_metadata->trap_group_name) + 1,
-				  GFP_ATOMIC | __GFP_ZERO);
+	trap_group_name = kstrdup(hw_metadata->trap_group_name, GFP_ATOMIC);
 	if (!trap_group_name)
 		goto free_hw_metadata;
 	n_hw_metadata->trap_group_name = trap_group_name;
 
-	trap_name = kmemdup(hw_metadata->trap_name,
-			    strlen(hw_metadata->trap_name) + 1,
-			    GFP_ATOMIC | __GFP_ZERO);
+	trap_name = kstrdup(hw_metadata->trap_name, GFP_ATOMIC);
 	if (!trap_name)
 		goto free_trap_group;
 	n_hw_metadata->trap_name = trap_name;


