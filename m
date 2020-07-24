Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EA222BB23
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgGXAuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:50:37 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37630 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbgGXAug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 20:50:36 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jyluo-0001bl-IO; Fri, 24 Jul 2020 10:50:23 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Jul 2020 10:50:22 +1000
Date:   Fri, 24 Jul 2020 10:50:22 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     wenxu <wenxu@ucloud.cn>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] flow_offload: Move rhashtable inclusion to the source file
Message-ID: <20200724005022.GA29161@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I noticed that touching linux/rhashtable.h causes lib/vsprintf.c to
be rebuilt.  This dependency came through a bogus inclusion in the
file net/flow_offload.h.  This patch moves it to the right place.

This patch also removes a lingering rhashtable inclusion in cls_api
created by the same commit.

Fixes: 4e481908c51b ("flow_offload: move tc indirect block to...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index f2c8311a0433..1075369d21d3 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -5,7 +5,6 @@
 #include <linux/list.h>
 #include <linux/netlink.h>
 #include <net/flow_dissector.h>
-#include <linux/rhashtable.h>
 
 struct flow_match {
 	struct flow_dissector	*dissector;
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 0cfc35e6be28..e88320c17665 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -4,6 +4,7 @@
 #include <net/flow_offload.h>
 #include <linux/rtnetlink.h>
 #include <linux/mutex.h>
+#include <linux/rhashtable.h>
 
 struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 {
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a00a203b2ef5..caa254ece49f 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -20,7 +20,6 @@
 #include <linux/kmod.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
-#include <linux/rhashtable.h>
 #include <linux/jhash.h>
 #include <linux/rculist.h>
 #include <net/net_namespace.h>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
