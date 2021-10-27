Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2875343C48D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbhJ0IDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239125AbhJ0IDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:03:20 -0400
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2975C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 01:00:54 -0700 (PDT)
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 0E7092E0488;
        Wed, 27 Oct 2021 11:00:25 +0300 (MSK)
Received: from sas2-d40aa8807eff.qloud-c.yandex.net (2a02:6b8:c08:b921:0:640:d40a:a880 [2a02:6b8:c08:b921:0:640:d40a:a880])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 65MNUFsOMH-0Ku4bob7;
        Wed, 27 Oct 2021 11:00:24 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635321624; bh=SjKPiHTyr2bruXtZyCSIfgYu+166CG4ZyN0EBsZc0U0=;
        h=Cc:Date:Subject:To:From:Message-Id;
        b=wsW67dgprDffRe2J2nZQRTp8TGjURslr4SmkkrD3RO9suK4OwQfnUNufuXFi25eP6
         I3e+klkL+18LxE2N7hPFRX0KVFnVFkJ3Y4vkOO02W68cYvuYIHN727aH7sjUQ+ErEE
         yvtIdPcg6Jvx3/MgdeQdluoGmNxe2o+Sh4cSMF2Y=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from wwfq-osx.yandex.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:8003::1:9])
        by sas2-d40aa8807eff.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id nW4mSMv1C7-0KxetaOY;
        Wed, 27 Oct 2021 11:00:20 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Alexander Kuznetsov <wwfq@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     zeil@yandex-team.ru, davem@davemloft.net, ebiederm@xmission.com,
        dmtrmonakhov@yandex-team.ru
Subject: [PATCH v2] ipv6: enable net.ipv6.route.max_size sysctl in network namespace
Date:   Wed, 27 Oct 2021 11:00:08 +0300
Message-Id: <20211027080008.57044-1-wwfq@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to increase route cache size in network namespace
created with user namespace. Currently ipv6 route settings
are disabled for non-initial network namespaces.
We can allow this sysctl and it will be safe since
commit <6126891c6d4f> because route cache account to kmem,
that is why users from user namespace can not DOS system.

Signed-off-by: Alexander Kuznetsov <wwfq@yandex-team.ru>
Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
Acked-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
---
 net/ipv6/route.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index dbc2240..5f78325 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6305,11 +6305,11 @@ static int ipv6_sysctl_rtcache_flush(struct ctl_table *ctl, int write,
 
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
+		.proc_handler	=	proc_dointvec,
 	},
 	{
 		.procname	=	"gc_thresh",
@@ -6319,11 +6319,11 @@ static struct ctl_table ipv6_route_table_template[] = {
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
@@ -6395,10 +6395,10 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
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
@@ -6410,7 +6410,7 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
 
 		/* Don't export sysctls to unprivileged users */
 		if (net->user_ns != &init_user_ns)
-			table[0].procname = NULL;
+			table[1].procname = NULL;
 	}
 
 	return table;
-- 
2.7.4

