Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA69714307
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 01:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbfEEXd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 19:33:28 -0400
Received: from mail.us.es ([193.147.175.20]:34116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbfEEXdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 19:33:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5B22D11ED8E
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 488BCDA70B
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3E211DA708; Mon,  6 May 2019 01:33:18 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12316DA701;
        Mon,  6 May 2019 01:33:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 01:33:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D4D004265A31;
        Mon,  6 May 2019 01:33:15 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/12] netfilter: nf_nat: register NAT helpers.
Date:   Mon,  6 May 2019 01:33:00 +0200
Message-Id: <20190505233305.13650-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505233305.13650-1-pablo@netfilter.org>
References: <20190505233305.13650-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Flavio Leitner <fbl@redhat.com>

Register amanda, ftp, irc, sip and tftp NAT helpers.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_amanda.c | 9 ++++++++-
 net/netfilter/nf_nat_ftp.c    | 9 ++++++++-
 net/netfilter/nf_nat_irc.c    | 9 ++++++++-
 net/netfilter/nf_nat_sip.c    | 9 +++++++--
 net/netfilter/nf_nat_tftp.c   | 9 ++++++++-
 5 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index 6b729a897c5f..4e59416ea709 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -19,10 +19,15 @@
 #include <net/netfilter/nf_nat_helper.h>
 #include <linux/netfilter/nf_conntrack_amanda.h>
 
+#define NAT_HELPER_NAME "amanda"
+
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_NF_NAT_HELPER("amanda");
+MODULE_ALIAS_NF_NAT_HELPER(NAT_HELPER_NAME);
+
+static struct nf_conntrack_nat_helper nat_helper_amanda =
+	NF_CT_NAT_HELPER_INIT(NAT_HELPER_NAME);
 
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
@@ -74,6 +79,7 @@ static unsigned int help(struct sk_buff *skb,
 
 static void __exit nf_nat_amanda_fini(void)
 {
+	nf_nat_helper_unregister(&nat_helper_amanda);
 	RCU_INIT_POINTER(nf_nat_amanda_hook, NULL);
 	synchronize_rcu();
 }
@@ -81,6 +87,7 @@ static void __exit nf_nat_amanda_fini(void)
 static int __init nf_nat_amanda_init(void)
 {
 	BUG_ON(nf_nat_amanda_hook != NULL);
+	nf_nat_helper_register(&nat_helper_amanda);
 	RCU_INIT_POINTER(nf_nat_amanda_hook, help);
 	return 0;
 }
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index 0e93b1f19432..0ea6b1bc52de 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -21,13 +21,18 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <linux/netfilter/nf_conntrack_ftp.h>
 
+#define NAT_HELPER_NAME "ftp"
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp NAT helper");
-MODULE_ALIAS_NF_NAT_HELPER("ftp");
+MODULE_ALIAS_NF_NAT_HELPER(NAT_HELPER_NAME);
 
 /* FIXME: Time out? --RR */
 
+static struct nf_conntrack_nat_helper nat_helper_ftp =
+	NF_CT_NAT_HELPER_INIT(NAT_HELPER_NAME);
+
 static int nf_nat_ftp_fmt_cmd(struct nf_conn *ct, enum nf_ct_ftp_type type,
 			      char *buffer, size_t buflen,
 			      union nf_inet_addr *addr, u16 port)
@@ -124,6 +129,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 
 static void __exit nf_nat_ftp_fini(void)
 {
+	nf_nat_helper_unregister(&nat_helper_ftp);
 	RCU_INIT_POINTER(nf_nat_ftp_hook, NULL);
 	synchronize_rcu();
 }
@@ -131,6 +137,7 @@ static void __exit nf_nat_ftp_fini(void)
 static int __init nf_nat_ftp_init(void)
 {
 	BUG_ON(nf_nat_ftp_hook != NULL);
+	nf_nat_helper_register(&nat_helper_ftp);
 	RCU_INIT_POINTER(nf_nat_ftp_hook, nf_nat_ftp);
 	return 0;
 }
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 6c06e997395f..d87cbe5e03ec 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -23,10 +23,15 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <linux/netfilter/nf_conntrack_irc.h>
 
+#define NAT_HELPER_NAME "irc"
+
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("IRC (DCC) NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_NF_NAT_HELPER("irc");
+MODULE_ALIAS_NF_NAT_HELPER(NAT_HELPER_NAME);
+
+static struct nf_conntrack_nat_helper nat_helper_irc =
+	NF_CT_NAT_HELPER_INIT(NAT_HELPER_NAME);
 
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
@@ -96,6 +101,7 @@ static unsigned int help(struct sk_buff *skb,
 
 static void __exit nf_nat_irc_fini(void)
 {
+	nf_nat_helper_unregister(&nat_helper_irc);
 	RCU_INIT_POINTER(nf_nat_irc_hook, NULL);
 	synchronize_rcu();
 }
@@ -103,6 +109,7 @@ static void __exit nf_nat_irc_fini(void)
 static int __init nf_nat_irc_init(void)
 {
 	BUG_ON(nf_nat_irc_hook != NULL);
+	nf_nat_helper_register(&nat_helper_irc);
 	RCU_INIT_POINTER(nf_nat_irc_hook, help);
 	return 0;
 }
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index f1f007d9484c..464387b3600f 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -24,11 +24,15 @@
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <linux/netfilter/nf_conntrack_sip.h>
 
+#define NAT_HELPER_NAME "sip"
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
 MODULE_DESCRIPTION("SIP NAT helper");
-MODULE_ALIAS_NF_NAT_HELPER("sip");
+MODULE_ALIAS_NF_NAT_HELPER(NAT_HELPER_NAME);
 
+static struct nf_conntrack_nat_helper nat_helper_sip =
+	NF_CT_NAT_HELPER_INIT(NAT_HELPER_NAME);
 
 static unsigned int mangle_packet(struct sk_buff *skb, unsigned int protoff,
 				  unsigned int dataoff,
@@ -656,8 +660,8 @@ static struct nf_ct_helper_expectfn sip_nat = {
 
 static void __exit nf_nat_sip_fini(void)
 {
+	nf_nat_helper_unregister(&nat_helper_sip);
 	RCU_INIT_POINTER(nf_nat_sip_hooks, NULL);
-
 	nf_ct_helper_expectfn_unregister(&sip_nat);
 	synchronize_rcu();
 }
@@ -675,6 +679,7 @@ static const struct nf_nat_sip_hooks sip_hooks = {
 static int __init nf_nat_sip_init(void)
 {
 	BUG_ON(nf_nat_sip_hooks != NULL);
+	nf_nat_helper_register(&nat_helper_sip);
 	RCU_INIT_POINTER(nf_nat_sip_hooks, &sip_hooks);
 	nf_ct_helper_expectfn_register(&sip_nat);
 	return 0;
diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index dd3a835c111d..e633b3863e33 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -13,10 +13,15 @@
 #include <net/netfilter/nf_nat_helper.h>
 #include <linux/netfilter/nf_conntrack_tftp.h>
 
+#define NAT_HELPER_NAME "tftp"
+
 MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
 MODULE_DESCRIPTION("TFTP NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_NF_NAT_HELPER("tftp");
+MODULE_ALIAS_NF_NAT_HELPER(NAT_HELPER_NAME);
+
+static struct nf_conntrack_nat_helper nat_helper_tftp =
+	NF_CT_NAT_HELPER_INIT(NAT_HELPER_NAME);
 
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
@@ -37,6 +42,7 @@ static unsigned int help(struct sk_buff *skb,
 
 static void __exit nf_nat_tftp_fini(void)
 {
+	nf_nat_helper_unregister(&nat_helper_tftp);
 	RCU_INIT_POINTER(nf_nat_tftp_hook, NULL);
 	synchronize_rcu();
 }
@@ -44,6 +50,7 @@ static void __exit nf_nat_tftp_fini(void)
 static int __init nf_nat_tftp_init(void)
 {
 	BUG_ON(nf_nat_tftp_hook != NULL);
+	nf_nat_helper_register(&nat_helper_tftp);
 	RCU_INIT_POINTER(nf_nat_tftp_hook, help);
 	return 0;
 }
-- 
2.11.0

