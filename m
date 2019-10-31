Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D119EB71F
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbfJaShN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:37:13 -0400
Received: from smtprelay0104.hostedemail.com ([216.40.44.104]:43004 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729027AbfJaShN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 14:37:13 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 79B23180F68D6;
        Thu, 31 Oct 2019 18:37:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:4184:4321:5007:6119:7901:7903:8603:10004:10400:11026:11232:11658:11914:12296:12297:12438:12555:12740:12760:12895:13149:13161:13229:13230:13439:14096:14097:14180:14659:14721:21060:21080:21324:21433:21451:21627:21972:30054:30070:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: paper43_4680f56fc043
X-Filterd-Recvd-Size: 3282
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Thu, 31 Oct 2019 18:37:10 +0000 (UTC)
Message-ID: <8e21b79c1adf5c3c4fb94c11fbe30371c4e96943.camel@perches.com>
Subject: Re: [PATCH net-next 0/7] net: bridge: convert fdbs to use bitops
From:   Joe Perches <joe@perches.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Date:   Thu, 31 Oct 2019 11:37:01 -0700
In-Reply-To: <20191029114559.28653-1-nikolay@cumulusnetworks.com>
References: <20191029114559.28653-1-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-10-29 at 13:45 +0200, Nikolay Aleksandrov wrote:
> Hi,
> We'd like to have a well-defined behaviour when changing fdb flags. The
> problem is that we've added new fields which are changed from all
> contexts without any locking. We are aware of the bit test/change races
> and these are fine (we can remove them later), but it is considered
> undefined behaviour to change bitfields from multiple threads and also
> on some architectures that can result in unexpected results,
> specifically when all fields between the changed ones are also
> bitfields. The conversion to bitops shows the intent clearly and
> makes them use functions with well-defined behaviour in such cases.
> There is no overhead for the fast-path, the bit changing functions are
> used only in special cases when learning and in the slow path.
> In addition this conversion allows us to simplify fdb flag handling and
> avoid bugs for future bits (e.g. a forgetting to clear the new bit when
> allocating a new fdb). All bridge selftests passed, also tried all of the
> converted bits manually in a VM.
> 
> Thanks,
>  Nik
> 
> Nikolay Aleksandrov (7):
>   net: bridge: fdb: convert is_local to bitops
>   net: bridge: fdb: convert is_static to bitops
>   net: bridge: fdb: convert is_sticky to bitops
>   net: bridge: fdb: convert added_by_user to bitops
>   net: bridge: fdb: convert added_by_external_learn to use bitops
>   net: bridge: fdb: convert offloaded to use bitops
>   net: bridge: fdb: set flags directly in fdb_create

Wouldn't it be simpler to change all these bitfields to bool?

The next member is ____cachline_aligned_in_smp so it's not
like the struct size matters or likely even changes.

---
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index ce2ab1..46d2f10 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -183,12 +183,12 @@ struct net_bridge_fdb_entry {
 
 	struct net_bridge_fdb_key	key;
 	struct hlist_node		fdb_node;
-	unsigned char			is_local:1,
-					is_static:1,
-					is_sticky:1,
-					added_by_user:1,
-					added_by_external_learn:1,
-					offloaded:1;
+	bool				is_local;
+	bool				is_static;
+	bool				is_sticky;
+	bool				added_by_user;
+	bool				added_by_external_learn;
+	bool				offloaded;
 
 	/* write-heavy members should not affect lookups */
 	unsigned long			updated ____cacheline_aligned_in_smp;


