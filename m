Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAD057C08A
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiGTXIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiGTXID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:08:03 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 591C81B795;
        Wed, 20 Jul 2022 16:08:02 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nf-next 05/18] netfilter: nf_conntrack: add missing __rcu annotations
Date:   Thu, 21 Jul 2022 01:07:41 +0200
Message-Id: <20220720230754.209053-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220720230754.209053-1-pablo@netfilter.org>
References: <20220720230754.209053-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Access to the hook pointers use correct helpers but the pointers lack
the needed __rcu annotation.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_sip.h   | 2 +-
 include/net/netfilter/nf_conntrack_timeout.h | 2 +-
 net/netfilter/nf_conntrack_pptp.c            | 2 +-
 net/netfilter/nf_conntrack_sip.c             | 2 +-
 net/netfilter/nf_conntrack_timeout.c         | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index c620521c42bc..dbc614dfe0d5 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -164,7 +164,7 @@ struct nf_nat_sip_hooks {
 				  unsigned int medialen,
 				  union nf_inet_addr *rtp_addr);
 };
-extern const struct nf_nat_sip_hooks *nf_nat_sip_hooks;
+extern const struct nf_nat_sip_hooks __rcu *nf_nat_sip_hooks;
 
 int ct_sip_parse_request(const struct nf_conn *ct, const char *dptr,
 			 unsigned int datalen, unsigned int *matchoff,
diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index fea258983d23..9fdaba911de6 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -105,7 +105,7 @@ struct nf_ct_timeout_hooks {
 	void (*timeout_put)(struct nf_ct_timeout *timeout);
 };
 
-extern const struct nf_ct_timeout_hooks *nf_ct_timeout_hook;
+extern const struct nf_ct_timeout_hooks __rcu *nf_ct_timeout_hook;
 #endif
 
 #endif /* _NF_CONNTRACK_TIMEOUT_H */
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index f3fa367b455f..4c679638df06 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -45,7 +45,7 @@ MODULE_ALIAS_NFCT_HELPER("pptp");
 
 static DEFINE_SPINLOCK(nf_pptp_lock);
 
-const struct nf_nat_pptp_hook *nf_nat_pptp_hook;
+const struct nf_nat_pptp_hook __rcu *nf_nat_pptp_hook;
 EXPORT_SYMBOL_GPL(nf_nat_pptp_hook);
 
 #if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index b83dc9bf0a5d..a88b43624b27 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -60,7 +60,7 @@ module_param(sip_external_media, int, 0600);
 MODULE_PARM_DESC(sip_external_media, "Expect Media streams between external "
 				     "endpoints (default 0)");
 
-const struct nf_nat_sip_hooks *nf_nat_sip_hooks;
+const struct nf_nat_sip_hooks __rcu *nf_nat_sip_hooks;
 EXPORT_SYMBOL_GPL(nf_nat_sip_hooks);
 
 static int string_len(const struct nf_conn *ct, const char *dptr,
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index 0f828d05ea60..821365ed5b2c 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -22,7 +22,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 
-const struct nf_ct_timeout_hooks *nf_ct_timeout_hook __read_mostly;
+const struct nf_ct_timeout_hooks __rcu *nf_ct_timeout_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_timeout_hook);
 
 static int untimeout(struct nf_conn *ct, void *timeout)
-- 
2.30.2

