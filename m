Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1721D40490B
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhIILQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbhIILQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 07:16:38 -0400
X-Greylist: delayed 72 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Sep 2021 04:15:29 PDT
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7262AC061575
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 04:15:29 -0700 (PDT)
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 9272F2E0954
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 14:14:14 +0300 (MSK)
Received: from sas1-db2fca0e44c8.qloud-c.yandex.net (sas1-db2fca0e44c8.qloud-c.yandex.net [2a02:6b8:c14:6696:0:640:db2f:ca0e])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id IFQDQ7Thnc-EEti56BE;
        Thu, 09 Sep 2021 14:14:14 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1631186054; bh=tDh7itUeuauH/cuowx/B1dvLSD67Lci4VwWjcEU54+Y=;
        h=Cc:Message-Id:Date:Subject:To:From;
        b=mzrsdNvJUeYxuERP11s+YDzLzS+y9QDRpR7eWmuzXdZyFTktBWdDEd13Ydohyvg8P
         w8/0/FM7VUgniOy3U5WD4SXDtMuprfo14d0DArsb+cs55PIllbo7BOluyZK8lbbiQE
         sKMitkoGyNNsA/Z23/FoRNGRKym2ztWF2RraE9sM=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:28ca:2366:8c70:23dc])
        by sas1-db2fca0e44c8.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id wrNBnRK2rx-EE0SLRMK;
        Thu, 09 Sep 2021 14:14:14 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Alexander Kuznetsov <wwfq@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     zeil@yandex-team.ru
Subject: [PATCH] ipv6: enable net.ipv6.route sysctls in network namespace
Date:   Thu,  9 Sep 2021 14:14:09 +0300
Message-Id: <20210909111409.14425-1-wwfq@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to increase route cache size in network namespace
created with user namespace. Currently ipv6 route settings
are disabled for non-initial network namespaces.
Since routes are per network namespace it is safe
to enable these sysctls.

Signed-off-by: Alexander Kuznetsov <wwfq@yandex-team.ru>
Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 net/ipv6/route.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index b6ddf23..de85e3b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6415,10 +6415,6 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
 		table[8].data = &net->ipv6.sysctl.ip6_rt_min_advmss;
 		table[9].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
 		table[10].data = &net->ipv6.sysctl.skip_notify_on_dev_down;
-
-		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
-			table[0].procname = NULL;
 	}
 
 	return table;
-- 
2.7.4

