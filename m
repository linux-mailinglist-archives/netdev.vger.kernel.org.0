Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8851D3BE9E
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390080AbfFJV0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:26:16 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46457 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389983AbfFJV0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:26:15 -0400
Received: by mail-ed1-f65.google.com with SMTP id h10so16481691edi.13
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8yEk4v/sNd8UDHobW3FZby6r9HfSzOfXYPDl4YnUOxU=;
        b=FVJe+yAqxqZe3zCZdzhCs6cEQRqIDPyFRp7m8E9Cb8KraVoEFxI9HcpruX74hyASmO
         WUL5S92+jmSlyiSaak9AweCqDp3LQ2iDKm421/V7BCugeVSiKYDUkT/o0rPw2wIb2+A9
         AAMfeDZcc3JZfbuHZJDuVNmnnTt9rhy/zpIy+VFvEMQwsNjLmxOnklUEYRAZ2CtQF8VE
         t+72lVFbzsIA7rauyrtqTIKANHVLQqGRFOzUiGIMDFL8jaNTcFyehKDDxeQgvPpvKqZf
         EPCZllEDkXo968J42i2gKYCkh1lgbpEFrncld5ShPQJF/kr6uFSfddkzD28KAVmMebIP
         KiZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8yEk4v/sNd8UDHobW3FZby6r9HfSzOfXYPDl4YnUOxU=;
        b=eGKviPAkbd6jKd6jsM4NBLmimjXEY5Kg5ddbS94yYY9/Af8RILv2NOzDL12Wp0RZOw
         jqbatfgLGshHJ1hgJfTSw/VPjsxzm3bSLW9aS1i5OYYx4MCjSRd+/KVI1uETvwyIRvyw
         2uvBX79bmtIYMtSwHh1jgiYYy5Ytncd3lTIm9U7smjWBwPrR7avGSRmPpQybfrEQzqvc
         v+u7LdE6ff7cOW+8MeYe1CdMVMykjlbqyxreDiCKsekhBFqsmdA8alXA+P77OkDPMNsE
         LN0iypsUdmfJLZ6lsWaAlgkyE5WKEO8ghh0A6VJaae2z69siAioTmpTrPepJJqgoPcta
         IDYg==
X-Gm-Message-State: APjAAAVg5b6TDlKth64eTbZisgY/xO47IRXexc6VwsQAGkBe5EjvhHn1
        92nUgnsdPIpruZbKSKIN3qe8vQ==
X-Google-Smtp-Source: APXvYqxGC8u/8T56Y4L5MiJBJyHGEpbO8D6kz+Xq/eFPDHYYrwxV80yWGhkw/oz41DF44LKKFMIZww==
X-Received: by 2002:a50:e1c9:: with SMTP id m9mr58228716edl.71.1560201973185;
        Mon, 10 Jun 2019 14:26:13 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8109:9cc0:6dac:cd8f:f6e9:1b84:bbb1])
        by smtp.gmail.com with ESMTPSA id d28sm1092256edn.31.2019.06.10.14.26.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 14:26:12 -0700 (PDT)
From:   Christian Brauner <christian@brauner.io>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org
Cc:     tyhicks@canonical.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, linux-kernel@vger.kernel.org,
        richardrose@google.com, vapier@chromium.org, bhthompson@google.com,
        smbarber@chromium.org, joelhockey@chromium.org,
        ueberall@themenzentrisch.de,
        Christian Brauner <christian@brauner.io>
Subject: [PATCH net-next v2 2/2] br_netfilter: namespace bridge netfilter sysctls
Date:   Mon, 10 Jun 2019 23:26:06 +0200
Message-Id: <20190610212606.29743-3-christian@brauner.io>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190610212606.29743-1-christian@brauner.io>
References: <20190610212606.29743-1-christian@brauner.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the /proc/sys/net/bridge folder is only created in the initial
network namespace. This patch ensures that the /proc/sys/net/bridge folder
is available in each network namespace if the module is loaded and
disappears from all network namespaces when the module is unloaded.

In doing so the patch makes the sysctls:

bridge-nf-call-arptables
bridge-nf-call-ip6tables
bridge-nf-call-iptables
bridge-nf-filter-pppoe-tagged
bridge-nf-filter-vlan-tagged
bridge-nf-pass-vlan-input-dev

apply per network namespace. This unblocks some use-cases where users would
like to e.g. not do bridge filtering for bridges in a specific network
namespace while doing so for bridges located in another network namespace.

The netfilter rules are afaict already per network namespace so it should
be safe for users to specify whether bridge devices inside a network
namespace are supposed to go through iptables et al. or not. Also, this can
already be done per-bridge by setting an option for each individual bridge
via Netlink. It should also be possible to do this for all bridges in a
network namespace via sysctls.

Cc: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 net/bridge/br_netfilter_hooks.c | 117 ++++++++++++++++++++------------
 1 file changed, 72 insertions(+), 45 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 4595c0d64e6a..fd9e991c1189 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -45,13 +45,13 @@
 
 static unsigned int brnf_net_id __read_mostly;
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table_header *brnf_sysctl_header;
-#endif
-
 struct brnf_net {
 	bool enabled;
 
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header *ctl_hdr;
+#endif
+
 	/* default value is 1 */
 	int call_iptables;
 	int call_ip6tables;
@@ -976,23 +976,6 @@ static int brnf_device_event(struct notifier_block *unused, unsigned long event,
 	return NOTIFY_OK;
 }
 
-static void __net_exit brnf_exit_net(struct net *net)
-{
-	struct brnf_net *brnet = net_generic(net, brnf_net_id);
-
-	if (!brnet->enabled)
-		return;
-
-	nf_unregister_net_hooks(net, br_nf_ops, ARRAY_SIZE(br_nf_ops));
-	brnet->enabled = false;
-}
-
-static struct pernet_operations brnf_net_ops __read_mostly = {
-	.exit = brnf_exit_net,
-	.id   = &brnf_net_id,
-	.size = sizeof(struct brnf_net),
-};
-
 static struct notifier_block brnf_notifier __read_mostly = {
 	.notifier_call = brnf_device_event,
 };
@@ -1098,12 +1081,79 @@ static inline void br_netfilter_sysctl_default(struct brnf_net *brnf)
 	brnf->pass_vlan_indev = 0;
 }
 
+static int br_netfilter_sysctl_init_net(struct net *net)
+{
+	struct ctl_table *table = brnf_table;
+	struct brnf_net *brnet;
+
+	if (!net_eq(net, &init_net)) {
+		table = kmemdup(table, sizeof(brnf_table), GFP_KERNEL);
+		if (!table)
+			return -ENOMEM;
+	}
+
+	brnet = net_generic(net, brnf_net_id);
+	table[0].data = &brnet->call_arptables;
+	table[1].data = &brnet->call_iptables;
+	table[2].data = &brnet->call_ip6tables;
+	table[3].data = &brnet->filter_vlan_tagged;
+	table[4].data = &brnet->filter_pppoe_tagged;
+	table[5].data = &brnet->pass_vlan_indev;
+
+	br_netfilter_sysctl_default(brnet);
+
+	brnet->ctl_hdr = register_net_sysctl(net, "net/bridge", table);
+	if (!brnet->ctl_hdr) {
+		if (!net_eq(net, &init_net))
+			kfree(table);
+
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void br_netfilter_sysctl_exit_net(struct net *net,
+					 struct brnf_net *brnet)
+{
+	unregister_net_sysctl_table(brnet->ctl_hdr);
+	if (!net_eq(net, &init_net))
+		kfree(brnet->ctl_hdr->ctl_table_arg);
+}
+
+static int __net_init brnf_init_net(struct net *net)
+{
+	return br_netfilter_sysctl_init_net(net);
+}
+#endif
+
+static void __net_exit brnf_exit_net(struct net *net)
+{
+	struct brnf_net *brnet;
+
+	brnet = net_generic(net, brnf_net_id);
+	if (brnet->enabled) {
+		nf_unregister_net_hooks(net, br_nf_ops, ARRAY_SIZE(br_nf_ops));
+		brnet->enabled = false;
+	}
+
+#ifdef CONFIG_SYSCTL
+	br_netfilter_sysctl_exit_net(net, brnet);
 #endif
+}
+
+static struct pernet_operations brnf_net_ops __read_mostly = {
+#ifdef CONFIG_SYSCTL
+	.init = brnf_init_net,
+#endif
+	.exit = brnf_exit_net,
+	.id   = &brnf_net_id,
+	.size = sizeof(struct brnf_net),
+};
 
 static int __init br_netfilter_init(void)
 {
 	int ret;
-	struct brnf_net *brnet;
 
 	ret = register_pernet_subsys(&brnf_net_ops);
 	if (ret < 0)
@@ -1115,26 +1165,6 @@ static int __init br_netfilter_init(void)
 		return ret;
 	}
 
-#ifdef CONFIG_SYSCTL
-	brnet = net_generic(&init_net, brnf_net_id);
-	brnf_table[0].data = &brnet->call_arptables;
-	brnf_table[1].data = &brnet->call_iptables;
-	brnf_table[2].data = &brnet->call_ip6tables;
-	brnf_table[3].data = &brnet->filter_vlan_tagged;
-	brnf_table[4].data = &brnet->filter_pppoe_tagged;
-	brnf_table[5].data = &brnet->pass_vlan_indev;
-
-	br_netfilter_sysctl_default(brnet);
-
-	brnf_sysctl_header = register_net_sysctl(&init_net, "net/bridge", brnf_table);
-	if (brnf_sysctl_header == NULL) {
-		printk(KERN_WARNING
-		       "br_netfilter: can't register to sysctl.\n");
-		unregister_netdevice_notifier(&brnf_notifier);
-		unregister_pernet_subsys(&brnf_net_ops);
-		return -ENOMEM;
-	}
-#endif
 	RCU_INIT_POINTER(nf_br_ops, &br_ops);
 	printk(KERN_NOTICE "Bridge firewalling registered\n");
 	return 0;
@@ -1145,9 +1175,6 @@ static void __exit br_netfilter_fini(void)
 	RCU_INIT_POINTER(nf_br_ops, NULL);
 	unregister_netdevice_notifier(&brnf_notifier);
 	unregister_pernet_subsys(&brnf_net_ops);
-#ifdef CONFIG_SYSCTL
-	unregister_net_sysctl_table(brnf_sysctl_header);
-#endif
 }
 
 module_init(br_netfilter_init);
-- 
2.21.0

