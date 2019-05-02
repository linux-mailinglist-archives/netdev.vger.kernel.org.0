Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1150712488
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 00:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfEBWWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 18:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfEBWWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 18:22:16 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BD642080C;
        Thu,  2 May 2019 22:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556835735;
        bh=tw1AuDEKNb9P1LnskOVZiES9PUTV02ca/sWqDJzi55Q=;
        h=From:To:Cc:Subject:Date:From;
        b=fqLeitzLuB3KoMwsX4jxXt2UJEpndfmFsK9vx4gqt1oBcbYZ70jFLSrVcjjDdSWa1
         DsRX/1gwWU1Zv4RvAw9NEst8665WPRTDFyjBUyAsz+lj0mg/j9sETTY/ywYLhjiY73
         onrkiNq0XN778ntSLeGhWae/pseJ9O5FGewH328g=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     nikolay@cumulusnetworks.com, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] ipmr: Do not define MAXVIFS twice
Date:   Thu,  2 May 2019 15:23:26 -0700
Message-Id: <20190502222326.2298-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

b70432f7319eb refactored mroute code to make it common between ipv4
and ipv6. In the process, MAXVIFS got defined a second time: the
first is in the uapi file linux/mroute.h. A second one was created
presumably for IPv6 but it is not needed. Remove it and have
mroute_base.h include the uapi file directly since it is shared.

include/linux/mroute.h can not be included in mroute_base.h because
it contains a reference to mr_mfc which is defined in mroute_base.h.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/linux/mroute_base.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
index 34de06b426ef..c5a389f81e91 100644
--- a/include/linux/mroute_base.h
+++ b/include/linux/mroute_base.h
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/rhashtable-types.h>
 #include <linux/spinlock.h>
+#include <uapi/linux/mroute.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <net/fib_notifier.h>
@@ -90,13 +91,6 @@ static inline int mr_call_vif_notifiers(struct net *net,
 	return call_fib_notifiers(net, event_type, &info.info);
 }
 
-#ifndef MAXVIFS
-/* This one is nasty; value is defined in uapi using different symbols for
- * mroute and morute6 but both map into same 32.
- */
-#define MAXVIFS	32
-#endif
-
 #define VIF_EXISTS(_mrt, _idx) (!!((_mrt)->vif_table[_idx].dev))
 
 /* mfc_flags:
-- 
2.11.0

