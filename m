Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D996F35FE5
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbfFEPJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:09:46 -0400
Received: from gateway36.websitewelcome.com ([50.116.127.2]:11548 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728348AbfFEPJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 11:09:45 -0400
X-Greylist: delayed 1372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jun 2019 11:09:45 EDT
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 14720407EE637
        for <netdev@vger.kernel.org>; Wed,  5 Jun 2019 09:06:12 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id YXAFhDJaIYTGMYXAFhBSCV; Wed, 05 Jun 2019 09:45:19 -0500
X-Authority-Reason: nr=8
Received: from [189.250.127.120] (port=52510 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hYXAE-000ldx-M1; Wed, 05 Jun 2019 09:45:18 -0500
Date:   Wed, 5 Jun 2019 09:45:16 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] lib: objagg: Use struct_size() in kzalloc()
Message-ID: <20190605144516.GA3383@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.127.120
X-Source-L: No
X-Exim-ID: 1hYXAE-000ldx-M1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.127.120]:52510
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct objagg_stats {
	...
        struct objagg_obj_stats_info stats_info[];
};

size = sizeof(*objagg_stats) + sizeof(objagg_stats->stats_info[0]) * count;
instance = kzalloc(size, GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kzalloc(struct_size(instance, stats_info, count), GFP_KERNEL);

Notice that, in this case, variable alloc_size is not necessary, hence it
is removed.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 lib/objagg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/objagg.c b/lib/objagg.c
index 576be22e86de..55621fb82e0a 100644
--- a/lib/objagg.c
+++ b/lib/objagg.c
@@ -605,12 +605,10 @@ const struct objagg_stats *objagg_stats_get(struct objagg *objagg)
 {
 	struct objagg_stats *objagg_stats;
 	struct objagg_obj *objagg_obj;
-	size_t alloc_size;
 	int i;
 
-	alloc_size = sizeof(*objagg_stats) +
-		     sizeof(objagg_stats->stats_info[0]) * objagg->obj_count;
-	objagg_stats = kzalloc(alloc_size, GFP_KERNEL);
+	objagg_stats = kzalloc(struct_size(objagg_stats, stats_info,
+					   objagg->obj_count), GFP_KERNEL);
 	if (!objagg_stats)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.21.0

