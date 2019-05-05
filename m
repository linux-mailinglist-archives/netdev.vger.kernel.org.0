Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6375814310
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 01:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbfEEXdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 19:33:21 -0400
Received: from mail.us.es ([193.147.175.20]:34086 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727947AbfEEXdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 19:33:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0357F11ED84
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DFE3ADA70B
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D554BDA709; Mon,  6 May 2019 01:33:17 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78DA5DA704;
        Mon,  6 May 2019 01:33:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 01:33:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 501764265A31;
        Mon,  6 May 2019 01:33:15 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/12] netfilter: add API to manage NAT helpers.
Date:   Mon,  6 May 2019 01:32:59 +0200
Message-Id: <20190505233305.13650-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505233305.13650-1-pablo@netfilter.org>
References: <20190505233305.13650-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Flavio Leitner <fbl@redhat.com>

The API allows a conntrack helper to indicate its corresponding
NAT helper which then can be loaded and reference counted.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_helper.h | 22 +++++++-
 net/netfilter/nf_conntrack_amanda.c         |  8 ++-
 net/netfilter/nf_conntrack_ftp.c            | 18 +++---
 net/netfilter/nf_conntrack_helper.c         | 86 +++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_irc.c            |  6 +-
 net/netfilter/nf_conntrack_sane.c           | 12 ++--
 net/netfilter/nf_conntrack_sip.c            | 28 +++++-----
 net/netfilter/nf_conntrack_tftp.c           | 18 +++---
 8 files changed, 161 insertions(+), 37 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 28bd4569aa64..44b5a00a9c64 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -15,7 +15,8 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 
-#define NF_NAT_HELPER_NAME(name)	"ip_nat_" name
+#define NF_NAT_HELPER_PREFIX		"ip_nat_"
+#define NF_NAT_HELPER_NAME(name)	NF_NAT_HELPER_PREFIX name
 #define MODULE_ALIAS_NF_NAT_HELPER(name) \
 	MODULE_ALIAS(NF_NAT_HELPER_NAME(name))
 
@@ -58,6 +59,8 @@ struct nf_conntrack_helper {
 	unsigned int queue_num;
 	/* length of userspace private data stored in nf_conn_help->data */
 	u16 data_len;
+	/* name of NAT helper module */
+	char nat_mod_name[NF_CT_HELPER_NAME_LEN];
 };
 
 /* Must be kept in sync with the classes defined by helpers */
@@ -157,4 +160,21 @@ nf_ct_helper_expectfn_find_by_symbol(const void *symbol);
 extern struct hlist_head *nf_ct_helper_hash;
 extern unsigned int nf_ct_helper_hsize;
 
+struct nf_conntrack_nat_helper {
+	struct list_head list;
+	char mod_name[NF_CT_HELPER_NAME_LEN];	/* module name */
+	struct module *module;			/* pointer to self */
+};
+
+#define NF_CT_NAT_HELPER_INIT(name) \
+	{ \
+	.mod_name = NF_NAT_HELPER_NAME(name), \
+	.module = THIS_MODULE \
+	}
+
+void nf_nat_helper_register(struct nf_conntrack_nat_helper *nat);
+void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat);
+int nf_nat_helper_try_module_get(const char *name, u16 l3num,
+				 u8 protonum);
+void nf_nat_helper_put(struct nf_conntrack_helper *helper);
 #endif /*_NF_CONNTRACK_HELPER_H*/
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index f2681ec5b5f6..dbec6fca0d9e 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -28,11 +28,13 @@
 static unsigned int master_timeout __read_mostly = 300;
 static char *ts_algo = "kmp";
 
+#define HELPER_NAME "amanda"
+
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda connection tracking module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_amanda");
-MODULE_ALIAS_NFCT_HELPER("amanda");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 module_param(master_timeout, uint, 0600);
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
@@ -179,13 +181,14 @@ static const struct nf_conntrack_expect_policy amanda_exp_policy = {
 
 static struct nf_conntrack_helper amanda_helper[2] __read_mostly = {
 	{
-		.name			= "amanda",
+		.name			= HELPER_NAME,
 		.me			= THIS_MODULE,
 		.help			= amanda_help,
 		.tuple.src.l3num	= AF_INET,
 		.tuple.src.u.udp.port	= cpu_to_be16(10080),
 		.tuple.dst.protonum	= IPPROTO_UDP,
 		.expect_policy		= &amanda_exp_policy,
+		.nat_mod_name		= NF_NAT_HELPER_NAME(HELPER_NAME),
 	},
 	{
 		.name			= "amanda",
@@ -195,6 +198,7 @@ static struct nf_conntrack_helper amanda_helper[2] __read_mostly = {
 		.tuple.src.u.udp.port	= cpu_to_be16(10080),
 		.tuple.dst.protonum	= IPPROTO_UDP,
 		.expect_policy		= &amanda_exp_policy,
+		.nat_mod_name		= NF_NAT_HELPER_NAME(HELPER_NAME),
 	},
 };
 
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index a11c304fb771..32aeac1c4760 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -29,11 +29,13 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <linux/netfilter/nf_conntrack_ftp.h>
 
+#define HELPER_NAME "ftp"
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp connection tracking helper");
 MODULE_ALIAS("ip_conntrack_ftp");
-MODULE_ALIAS_NFCT_HELPER("ftp");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 /* This is slow, but it's simple. --RR */
 static char *ftp_buffer;
@@ -588,12 +590,14 @@ static int __init nf_conntrack_ftp_init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 FTP connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&ftp[2 * i], AF_INET, IPPROTO_TCP, "ftp",
-				  FTP_PORT, ports[i], ports[i], &ftp_exp_policy,
-				  0, help, nf_ct_ftp_from_nlattr, THIS_MODULE);
-		nf_ct_helper_init(&ftp[2 * i + 1], AF_INET6, IPPROTO_TCP, "ftp",
-				  FTP_PORT, ports[i], ports[i], &ftp_exp_policy,
-				  0, help, nf_ct_ftp_from_nlattr, THIS_MODULE);
+		nf_ct_helper_init(&ftp[2 * i], AF_INET, IPPROTO_TCP,
+				  HELPER_NAME, FTP_PORT, ports[i], ports[i],
+				  &ftp_exp_policy, 0, help,
+				  nf_ct_ftp_from_nlattr, THIS_MODULE);
+		nf_ct_helper_init(&ftp[2 * i + 1], AF_INET6, IPPROTO_TCP,
+				  HELPER_NAME, FTP_PORT, ports[i], ports[i],
+				  &ftp_exp_policy, 0, help,
+				  nf_ct_ftp_from_nlattr, THIS_MODULE);
 	}
 
 	ret = nf_conntrack_helpers_register(ftp, ports_c * 2);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 274baf1dab87..918df7f71c8f 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -42,6 +42,9 @@ module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper, bool, 0644);
 MODULE_PARM_DESC(nf_conntrack_helper,
 		 "Enable automatic conntrack helper assignment (default 0)");
 
+static DEFINE_MUTEX(nf_ct_nat_helpers_mutex);
+static struct list_head nf_ct_nat_helpers __read_mostly;
+
 /* Stupid hash, but collision free for the default registrations of the
  * helpers currently in the kernel. */
 static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
@@ -130,6 +133,70 @@ void nf_conntrack_helper_put(struct nf_conntrack_helper *helper)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_put);
 
+static struct nf_conntrack_nat_helper *
+nf_conntrack_nat_helper_find(const char *mod_name)
+{
+	struct nf_conntrack_nat_helper *cur;
+	bool found = false;
+
+	list_for_each_entry_rcu(cur, &nf_ct_nat_helpers, list) {
+		if (!strcmp(cur->mod_name, mod_name)) {
+			found = true;
+			break;
+		}
+	}
+	return found ? cur : NULL;
+}
+
+int
+nf_nat_helper_try_module_get(const char *name, u16 l3num, u8 protonum)
+{
+	struct nf_conntrack_helper *h;
+	struct nf_conntrack_nat_helper *nat;
+	char mod_name[NF_CT_HELPER_NAME_LEN];
+	int ret = 0;
+
+	rcu_read_lock();
+	h = __nf_conntrack_helper_find(name, l3num, protonum);
+	if (!h) {
+		rcu_read_unlock();
+		return -ENOENT;
+	}
+
+	nat = nf_conntrack_nat_helper_find(h->nat_mod_name);
+	if (!nat) {
+		snprintf(mod_name, sizeof(mod_name), "%s", h->nat_mod_name);
+		rcu_read_unlock();
+		request_module(mod_name);
+
+		rcu_read_lock();
+		nat = nf_conntrack_nat_helper_find(mod_name);
+		if (!nat) {
+			rcu_read_unlock();
+			return -ENOENT;
+		}
+	}
+
+	if (!try_module_get(nat->module))
+		ret = -ENOENT;
+
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_nat_helper_try_module_get);
+
+void nf_nat_helper_put(struct nf_conntrack_helper *helper)
+{
+	struct nf_conntrack_nat_helper *nat;
+
+	nat = nf_conntrack_nat_helper_find(helper->nat_mod_name);
+	if (WARN_ON_ONCE(!nat))
+		return;
+
+	module_put(nat->module);
+}
+EXPORT_SYMBOL_GPL(nf_nat_helper_put);
+
 struct nf_conn_help *
 nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
 {
@@ -430,6 +497,8 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 	helper->help = help;
 	helper->from_nlattr = from_nlattr;
 	helper->me = module;
+	snprintf(helper->nat_mod_name, sizeof(helper->nat_mod_name),
+		 NF_NAT_HELPER_PREFIX "%s", name);
 
 	if (spec_port == default_port)
 		snprintf(helper->name, sizeof(helper->name), "%s", name);
@@ -466,6 +535,22 @@ void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *helper,
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helpers_unregister);
 
+void nf_nat_helper_register(struct nf_conntrack_nat_helper *nat)
+{
+	mutex_lock(&nf_ct_nat_helpers_mutex);
+	list_add_rcu(&nat->list, &nf_ct_nat_helpers);
+	mutex_unlock(&nf_ct_nat_helpers_mutex);
+}
+EXPORT_SYMBOL_GPL(nf_nat_helper_register);
+
+void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
+{
+	mutex_lock(&nf_ct_nat_helpers_mutex);
+	list_del_rcu(&nat->list);
+	mutex_unlock(&nf_ct_nat_helpers_mutex);
+}
+EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
+
 static const struct nf_ct_ext_type helper_extend = {
 	.len	= sizeof(struct nf_conn_help),
 	.align	= __alignof__(struct nf_conn_help),
@@ -493,6 +578,7 @@ int nf_conntrack_helper_init(void)
 		goto out_extend;
 	}
 
+	INIT_LIST_HEAD(&nf_ct_nat_helpers);
 	return 0;
 out_extend:
 	kvfree(nf_ct_helper_hash);
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 4099f4d79bae..79e5014b3b0d 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -42,11 +42,13 @@ unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
 				struct nf_conntrack_expect *exp) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_irc_hook);
 
+#define HELPER_NAME "irc"
+
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_irc");
-MODULE_ALIAS_NFCT_HELPER("irc");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 module_param_array(ports, ushort, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
@@ -259,7 +261,7 @@ static int __init nf_conntrack_irc_init(void)
 		ports[ports_c++] = IRC_PORT;
 
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&irc[i], AF_INET, IPPROTO_TCP, "irc",
+		nf_ct_helper_init(&irc[i], AF_INET, IPPROTO_TCP, HELPER_NAME,
 				  IRC_PORT, ports[i], i, &irc_exp_policy,
 				  0, help, NULL, THIS_MODULE);
 	}
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 5072ff96ab33..83306648dd0f 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -30,10 +30,12 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <linux/netfilter/nf_conntrack_sane.h>
 
+#define HELPER_NAME "sane"
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Schmidt <mschmidt@redhat.com>");
 MODULE_DESCRIPTION("SANE connection tracking helper");
-MODULE_ALIAS_NFCT_HELPER("sane");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 static char *sane_buffer;
 
@@ -195,12 +197,12 @@ static int __init nf_conntrack_sane_init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&sane[2 * i], AF_INET, IPPROTO_TCP, "sane",
-				  SANE_PORT, ports[i], ports[i],
+		nf_ct_helper_init(&sane[2 * i], AF_INET, IPPROTO_TCP,
+				  HELPER_NAME, SANE_PORT, ports[i], ports[i],
 				  &sane_exp_policy, 0, help, NULL,
 				  THIS_MODULE);
-		nf_ct_helper_init(&sane[2 * i + 1], AF_INET6, IPPROTO_TCP, "sane",
-				  SANE_PORT, ports[i], ports[i],
+		nf_ct_helper_init(&sane[2 * i + 1], AF_INET6, IPPROTO_TCP,
+				  HELPER_NAME, SANE_PORT, ports[i], ports[i],
 				  &sane_exp_policy, 0, help, NULL,
 				  THIS_MODULE);
 	}
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index d5454d1031a3..c30c883c370b 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -30,11 +30,13 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <linux/netfilter/nf_conntrack_sip.h>
 
+#define HELPER_NAME "sip"
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
 MODULE_DESCRIPTION("SIP connection tracking helper");
 MODULE_ALIAS("ip_conntrack_sip");
-MODULE_ALIAS_NFCT_HELPER("sip");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 #define MAX_PORTS	8
 static unsigned short ports[MAX_PORTS];
@@ -1669,21 +1671,21 @@ static int __init nf_conntrack_sip_init(void)
 		ports[ports_c++] = SIP_PORT;
 
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&sip[4 * i], AF_INET, IPPROTO_UDP, "sip",
-				  SIP_PORT, ports[i], i, sip_exp_policy,
-				  SIP_EXPECT_MAX, sip_help_udp,
+		nf_ct_helper_init(&sip[4 * i], AF_INET, IPPROTO_UDP,
+				  HELPER_NAME, SIP_PORT, ports[i], i,
+				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_udp,
 				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 1], AF_INET, IPPROTO_TCP, "sip",
-				  SIP_PORT, ports[i], i, sip_exp_policy,
-				  SIP_EXPECT_MAX, sip_help_tcp,
+		nf_ct_helper_init(&sip[4 * i + 1], AF_INET, IPPROTO_TCP,
+				  HELPER_NAME, SIP_PORT, ports[i], i,
+				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_tcp,
 				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 2], AF_INET6, IPPROTO_UDP, "sip",
-				  SIP_PORT, ports[i], i, sip_exp_policy,
-				  SIP_EXPECT_MAX, sip_help_udp,
+		nf_ct_helper_init(&sip[4 * i + 2], AF_INET6, IPPROTO_UDP,
+				  HELPER_NAME, SIP_PORT, ports[i], i,
+				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_udp,
 				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 3], AF_INET6, IPPROTO_TCP, "sip",
-				  SIP_PORT, ports[i], i, sip_exp_policy,
-				  SIP_EXPECT_MAX, sip_help_tcp,
+		nf_ct_helper_init(&sip[4 * i + 3], AF_INET6, IPPROTO_TCP,
+				  HELPER_NAME, SIP_PORT, ports[i], i,
+				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_tcp,
 				  NULL, THIS_MODULE);
 	}
 
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 548b673b3625..6977cb91ae9a 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -20,11 +20,13 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <linux/netfilter/nf_conntrack_tftp.h>
 
+#define HELPER_NAME "tftp"
+
 MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
 MODULE_DESCRIPTION("TFTP connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_tftp");
-MODULE_ALIAS_NFCT_HELPER("tftp");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 #define MAX_PORTS 8
 static unsigned short ports[MAX_PORTS];
@@ -119,12 +121,14 @@ static int __init nf_conntrack_tftp_init(void)
 		ports[ports_c++] = TFTP_PORT;
 
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&tftp[2 * i], AF_INET, IPPROTO_UDP, "tftp",
-				  TFTP_PORT, ports[i], i, &tftp_exp_policy,
-				  0, tftp_help, NULL, THIS_MODULE);
-		nf_ct_helper_init(&tftp[2 * i + 1], AF_INET6, IPPROTO_UDP, "tftp",
-				  TFTP_PORT, ports[i], i, &tftp_exp_policy,
-				  0, tftp_help, NULL, THIS_MODULE);
+		nf_ct_helper_init(&tftp[2 * i], AF_INET, IPPROTO_UDP,
+				  HELPER_NAME, TFTP_PORT, ports[i], i,
+				  &tftp_exp_policy, 0, tftp_help, NULL,
+				  THIS_MODULE);
+		nf_ct_helper_init(&tftp[2 * i + 1], AF_INET6, IPPROTO_UDP,
+				  HELPER_NAME, TFTP_PORT, ports[i], i,
+				  &tftp_exp_policy, 0, tftp_help, NULL,
+				  THIS_MODULE);
 	}
 
 	ret = nf_conntrack_helpers_register(tftp, ports_c * 2);
-- 
2.11.0

