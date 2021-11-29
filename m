Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6979A46166D
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbhK2NdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbhK2NbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:31:13 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605DBC09B10B
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 04:09:31 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id w1so70993489edc.6
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 04:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BHBm4dlUjDO+IyiWCBrHx5fmJuVjlzdp9IeBGG3UHPc=;
        b=3EdccLqokOVqIfsbyq1nAN5KDuoLIYJ5fnU8PhSTURphoeSLmFSmRuo3jsvmeo3EXN
         QLNzMUG/nhNvE9E5n40XtNrD1RZDULoDaPpf3FTqjHMbMo4WY3BtwRDiExRt5BzBGo6y
         k45KQzmvKKYbJnsJa8q0dnP+CLXPa/UD/pkPeKvJgkXnLSyTx/EyxPjO7cWnjkTWs0s2
         Du6TRQcRoH0sw3CD+MCA7TyMZbQOQMJt6tysyjBa9KSyJxu46s5HtcmjwIbKG4f4c4IP
         s9EfIkBm/wFx+M8WLvj/edUZDzGoLH+U2O18qYYZ50NJXI52sjbStyjEURTce3IiZWuF
         E8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BHBm4dlUjDO+IyiWCBrHx5fmJuVjlzdp9IeBGG3UHPc=;
        b=e9aorqQ4CQfZCXqWEXq+r54duwNvsJd43e4JbAawTtJBtW62PMcXCOyyP1kgBeOo6B
         43blNjEk+1rtvXDT6nKWWTxJ2I4VASxJcZuo+PJ8Xqwi6TKLQPUVSPOk6tYdSq0NNern
         dJCjWEg3u9Tv6vZ94o/jT+PtoAwTSWajDT0SrguggW8t1M95wpmzfUzu066ONl59tBxE
         RvSjlLoGOrgiD8c3T94zMQkB/3uQWoMlVvJO+YG9FArF0edYTJMS6lDcmfn9093vWUiF
         FR09R55lmpQ2qcbn5LLLSBGaNJ2odHVSOtjBej1TNppzbEI5PtgSFmwBam486Z8dIbT/
         YOMw==
X-Gm-Message-State: AOAM5317NGLY3mjCtlNaDTfn11LRMX9U4vE0dGPTihJiC+NMMUElYDIS
        6cOmy35Bd2mPijpf4hY7yNcUDLTpJ3hsp1Kk
X-Google-Smtp-Source: ABdhPJy4kOeN9Iws4CetkAFP+rEfr2bY4GUd5hLeYRX1FJLMlV+W2rd3PUcaWQzr6qnbVDz0rM4BDQ==
X-Received: by 2002:a17:906:5f94:: with SMTP id a20mr49181948eju.256.1638187769512;
        Mon, 29 Nov 2021 04:09:29 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id cs12sm7299639ejc.15.2021.11.29.04.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 04:09:28 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: [PATCH net-next] net: nexthop: reduce rcu synchronizations when replacing resilient groups
Date:   Mon, 29 Nov 2021 14:09:24 +0200
Message-Id: <20211129120924.461545-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We can optimize resilient nexthop group replaces by reducing the number of
synchronize_net calls. After commit 1005f19b9357 ("net: nexthop: release
IPv6 per-cpu dsts when replacing a nexthop group") we always do a
synchronize_net because we must ensure no new dsts can be created for the
replaced group's removed nexthops, but we already did that when replacing
resilient groups, so if we always call synchronize_net after any group
type replacement we'll take care of both cases and reduce synchronize_net
calls for resilient groups.

Suggested-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/ipv4/nexthop.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5dbd4b5505eb..1319d093cdda 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1918,9 +1918,6 @@ static void nh_rt_cache_flush(struct net *net, struct nexthop *nh,
 	if (!replaced_nh->is_group)
 		return;
 
-	/* new dsts must use only the new nexthop group */
-	synchronize_net();
-
 	nhg = rtnl_dereference(replaced_nh->nh_grp);
 	for (i = 0; i < nhg->num_nh; i++) {
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
@@ -2002,9 +1999,10 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
 
 	rcu_assign_pointer(old->nh_grp, newg);
 
+	/* Make sure concurrent readers are not using 'oldg' anymore. */
+	synchronize_net();
+
 	if (newg->resilient) {
-		/* Make sure concurrent readers are not using 'oldg' anymore. */
-		synchronize_net();
 		rcu_assign_pointer(oldg->res_table, tmp_table);
 		rcu_assign_pointer(oldg->spare->res_table, tmp_table);
 	}
-- 
2.31.1

