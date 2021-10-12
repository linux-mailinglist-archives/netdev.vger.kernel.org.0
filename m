Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB68429ECD
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 09:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhJLHnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 03:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhJLHnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 03:43:49 -0400
X-Greylist: delayed 130 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Oct 2021 00:41:47 PDT
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86253C061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 00:41:47 -0700 (PDT)
Received: from iva8-c5ee4261001e.qloud-c.yandex.net (iva8-c5ee4261001e.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a8a6:0:640:c5ee:4261])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id BCDC32E0986;
        Tue, 12 Oct 2021 10:39:32 +0300 (MSK)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (2a02:6b8:c0c:152e:0:640:f06c:35e6 [2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by iva8-c5ee4261001e.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id nDNbVPpabE-dWuKJncJ;
        Tue, 12 Oct 2021 10:39:32 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1634024372; bh=qpxf1JxwoJOM0nag9EjkmAykmlfjHkC8zB7R7PsxzX4=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=iEhCcX+i+sUbl20ZjqS6ddRIzPdl3q7bx6pFASgcVtaHpl/DGeLYrRncPGQDLy1CE
         QxcYq+QZ3aGgkbOfIfraOty5BCw+pNavwvineMk8hRO6ivmVsaXNcDo9sE4ul0NMvP
         wio/iNiY9JUehYqz0BhTb7WZ2HI/9EEj7g1weNUQ=
Authentication-Results: iva8-c5ee4261001e.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from wwfq-osx.yandex.net (2a02:6b8:0:40c:fc88:1a0a:6f39:24a2 [2a02:6b8:0:40c:fc88:1a0a:6f39:24a2])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id QzS1i0fzXG-dW14m5OM;
        Tue, 12 Oct 2021 10:39:32 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Alexander Kuznetsov <wwfq@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     zeil@yandex-team.ru, davem@davemloft.net, ebiederm@xmission.com,
        dmtrmonakhov@yandex-team.ru
Subject: [PATCH] ipv6: enable net.ipv6.route.max_size sysctl in network namespace
Date:   Tue, 12 Oct 2021 10:39:14 +0300
Message-Id: <20211012073914.27775-1-wwfq@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to increase route cache size in network namespace
created with user namespace. Currently ipv6 route settings
are disabled for non-initial network namespaces.

We want to allow to write this sysctl only for users
from host(initial) user ns.

Signed-off-by: Alexander Kuznetsov <wwfq@yandex-team.ru>
Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
Acked-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
---
 net/ipv6/route.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index dbc2240..2d96c9f 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6303,13 +6303,21 @@ static int ipv6_sysctl_rtcache_flush(struct ctl_table *ctl, int write,
 	return 0;
 }
 
+static int ipv6_sysctl_route_max_size(struct ctl_table *ctl, int write,
+				       void *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (write && current_user_ns() != &init_user_ns)
+		return -EPERM;
+
+	return proc_dointvec(ctl, write, buffer, lenp, ppos);
+}
 static struct ctl_table ipv6_route_table_template[] = {
 	{
-		.procname	=	"flush",
-		.data		=	&init_net.ipv6.sysctl.flush_delay,
+		.procname	=	"max_size",
+		.data		=	&init_net.ipv6.sysctl.ip6_rt_max_size,
 		.maxlen		=	sizeof(int),
-		.mode		=	0200,
-		.proc_handler	=	ipv6_sysctl_rtcache_flush
+		.mode		=	0644,
+		.proc_handler	=	ipv6_sysctl_route_max_size,
 	},
 	{
 		.procname	=	"gc_thresh",
@@ -6319,11 +6327,11 @@ static struct ctl_table ipv6_route_table_template[] = {
 		.proc_handler	=	proc_dointvec,
 	},
 	{
-		.procname	=	"max_size",
-		.data		=	&init_net.ipv6.sysctl.ip6_rt_max_size,
+		.procname	=	"flush",
+		.data		=	&init_net.ipv6.sysctl.flush_delay,
 		.maxlen		=	sizeof(int),
-		.mode		=	0644,
-		.proc_handler	=	proc_dointvec,
+		.mode		=	0200,
+		.proc_handler	=	ipv6_sysctl_rtcache_flush
 	},
 	{
 		.procname	=	"gc_min_interval",
@@ -6395,10 +6403,10 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
 			GFP_KERNEL);
 
 	if (table) {
-		table[0].data = &net->ipv6.sysctl.flush_delay;
-		table[0].extra1 = net;
+		table[0].data = &net->ipv6.sysctl.ip6_rt_max_size;
 		table[1].data = &net->ipv6.ip6_dst_ops.gc_thresh;
-		table[2].data = &net->ipv6.sysctl.ip6_rt_max_size;
+		table[2].data = &net->ipv6.sysctl.flush_delay;
+		table[2].extra1 = net;
 		table[3].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
 		table[4].data = &net->ipv6.sysctl.ip6_rt_gc_timeout;
 		table[5].data = &net->ipv6.sysctl.ip6_rt_gc_interval;
@@ -6410,7 +6418,7 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
 
 		/* Don't export sysctls to unprivileged users */
 		if (net->user_ns != &init_user_ns)
-			table[0].procname = NULL;
+			table[1].procname = NULL;
 	}
 
 	return table;
-- 
2.7.4

