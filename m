Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A42412E8D
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 08:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhIUGX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 02:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhIUGX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 02:23:58 -0400
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAA9C061574
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 23:22:29 -0700 (PDT)
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 23BD32E0AD5
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 09:22:26 +0300 (MSK)
Received: from myt6-76f0a6db1a7e.qloud-c.yandex.net (myt6-76f0a6db1a7e.qloud-c.yandex.net [2a02:6b8:c12:422d:0:640:76f0:a6db])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 7QvbdJF8NT-MPtqS5Gl;
        Tue, 21 Sep 2021 09:22:26 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1632205346; bh=tDh7itUeuauH/cuowx/B1dvLSD67Lci4VwWjcEU54+Y=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=kMwO6UpmnW5CuE7syhvhyrxv5t9UZnMOR0+P8b0bYf+0g5IgOCbXyizpC3OeiuaM2
         NpaJMUEnpF7akVaoubpQqltUU3oByI0aJ6LOxtUj8JLTlpj4G+o3N5QttmMHmWUUNl
         5vmbs6mq5GOvEEt4F9GvTGiSrZmB+JjfTCsmKmNU=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:6508::1:e])
        by myt6-76f0a6db1a7e.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id RWbKCyglHP-MP0qxJMB;
        Tue, 21 Sep 2021 09:22:25 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Alexander Kuznetsov <wwfq@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     zeil@yandex-team.ru
Subject: [PATCH] ipv6: enable net.ipv6.route sysctls in network namespace
Date:   Tue, 21 Sep 2021 09:22:04 +0300
Message-Id: <20210921062204.16571-1-wwfq@yandex-team.ru>
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

