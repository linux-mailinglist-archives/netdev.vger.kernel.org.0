Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076B928E4CC
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 18:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbgJNQty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 12:49:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:49424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727440AbgJNQty (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 12:49:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1161FAAB2;
        Wed, 14 Oct 2020 16:49:53 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CC0C860731; Wed, 14 Oct 2020 18:49:52 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool] netlink: fix allocation failure handling in
 dump_features()
To:     netdev@vger.kernel.org
Cc:     ivecera@redhat.com
Message-Id: <20201014164952.CC0C860731@lion.mk-sys.cz>
Date:   Wed, 14 Oct 2020 18:49:52 +0200 (CEST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On allocation failure, dump_features() would set ret to -ENOMEM but then
return 0 anyway. As there is nothing to free in this case anyway, the
easiest fix is to simply return -ENOMEM rather than jumping to out_free
label - which can be dropped as well as this was its only use.

Fixes: f2c17e107900 ("netlink: add netlink handler for gfeatures (-k)")
Reported-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/features.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/netlink/features.c b/netlink/features.c
index 3f1240437350..2a0899e6eb04 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -117,11 +117,9 @@ int dump_features(const struct nlattr *const *tb,
 	ret = prepare_feature_results(tb, &results);
 	if (ret < 0)
 		return -EFAULT;
-
-	ret = -ENOMEM;
 	feature_flags = calloc(results.count, sizeof(feature_flags[0]));
 	if (!feature_flags)
-		goto out_free;
+		return -ENOMEM;
 
 	/* map netdev features to legacy flags */
 	for (i = 0; i < results.count; i++) {
@@ -182,7 +180,6 @@ int dump_features(const struct nlattr *const *tb,
 		dump_feature(&results, NULL, NULL, i, name, "");
 	}
 
-out_free:
 	free(feature_flags);
 	return 0;
 }
-- 
2.28.0

