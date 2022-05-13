Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E06526C8C
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 23:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384783AbiEMVoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 17:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384741AbiEMVnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 17:43:52 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 691D22EA1C;
        Fri, 13 May 2022 14:43:51 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net-next 14/17] netfilter: conntrack: add nf_conntrack_events autodetect mode
Date:   Fri, 13 May 2022 23:43:26 +0200
Message-Id: <20220513214329.1136459-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220513214329.1136459-1-pablo@netfilter.org>
References: <20220513214329.1136459-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This adds the new nf_conntrack_events=2 mode and makes it the
default.

This leverages the earlier flag in struct net to allow to avoid
the event extension as long as no event listener is active in
the namespace.

This avoids, for most cases, allocation of ct->ext area.
A followup patch will take further advantage of this by avoiding
calls down into the event framework if the extension isn't present.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../networking/nf_conntrack-sysctl.rst        |  5 +++-
 net/netfilter/nf_conntrack_core.c             |  3 ++-
 net/netfilter/nf_conntrack_ecache.c           | 27 ++++++++++++++-----
 net/netfilter/nf_conntrack_standalone.c       |  2 +-
 4 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 311128abb768..834945ebc4cd 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -34,10 +34,13 @@ nf_conntrack_count - INTEGER (read-only)
 
 nf_conntrack_events - BOOLEAN
 	- 0 - disabled
-	- not 0 - enabled (default)
+	- 1 - enabled
+	- 2 - auto (default)
 
 	If this option is enabled, the connection tracking code will
 	provide userspace with connection tracking events via ctnetlink.
+	The default allocates the extension if a userspace program is
+	listening to ctnetlink events.
 
 nf_conntrack_expect_max - INTEGER
 	Maximum size of expectation table.  Default value is
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7b078ec1f923..082a2fd8d85b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1736,7 +1736,8 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	ecache = tmpl ? nf_ct_ecache_find(tmpl) : NULL;
 
-	if (!nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
+	if ((ecache || net->ct.sysctl_events) &&
+	    !nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
 				  ecache ? ecache->expmask : 0,
 				  GFP_ATOMIC)) {
 		nf_conntrack_free(ct);
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 2f0b52fdcbfa..8698b3424646 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -302,12 +302,27 @@ bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp
 	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_ecache *e;
 
-	if (!ctmask && !expmask && net->ct.sysctl_events) {
-		ctmask = ~0;
-		expmask = ~0;
+	switch (net->ct.sysctl_events) {
+	case 0:
+		 /* assignment via template / ruleset? ignore sysctl. */
+		if (ctmask || expmask)
+			break;
+		return true;
+	case 2: /* autodetect: no event listener, don't allocate extension. */
+		if (!READ_ONCE(net->ct.ctnetlink_has_listener))
+			return true;
+		fallthrough;
+	case 1:
+		/* always allocate an extension. */
+		if (!ctmask && !expmask) {
+			ctmask = ~0;
+			expmask = ~0;
+		}
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return true;
 	}
-	if (!ctmask && !expmask)
-		return false;
 
 	e = nf_ct_ext_add(ct, NF_CT_EXT_ECACHE, gfp);
 	if (e) {
@@ -319,7 +334,7 @@ bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp
 }
 EXPORT_SYMBOL_GPL(nf_ct_ecache_ext_add);
 
-#define NF_CT_EVENTS_DEFAULT 1
+#define NF_CT_EVENTS_DEFAULT 2
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
 
 void nf_conntrack_ecache_pernet_init(struct net *net)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 3e1afd10a9b6..948884deaca5 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -693,7 +693,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
-		.extra2 	= SYSCTL_ONE,
+		.extra2		= SYSCTL_TWO,
 	},
 #endif
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
-- 
2.30.2

