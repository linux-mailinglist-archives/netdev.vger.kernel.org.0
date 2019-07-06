Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B76EE61247
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 18:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfGFQz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 12:55:27 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:54688 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfGFQz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 12:55:27 -0400
Received: by mail-wm1-f48.google.com with SMTP id p74so8883987wme.4;
        Sat, 06 Jul 2019 09:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=CHvEJVpnUTpEucTZAESaqgprel+L7cKgKdvDS7CIeuo=;
        b=aok8kHj1nJmFCVDYgUfeuFSO3ANNqq47dUqVU6JR4U6XgL5mlLyhoalRMYWlynQ0DM
         wzPSlV8AlzuSROicmK9+/uk5xeAHkf+YQcX467jECsz4EtQmKClrSsPZdz+27AkZsjnn
         7a/7SaRxpoDfsZexztuy0Gp0w+iMDJC54cJBvMoBaCCsWeZTNfv4GZWJkCP3q2NhpiRH
         KResuQ+eAkx65CZnf4By+tWWQjMJF6/FlKXitHLWjRVqcky9TyM5vaPR8MegRTIKfyev
         rWEy8HdQq/aYL/SHZRzVnzo/Ma8cxB6kRsJ9w+vj3WqOMBWYyztWpTYUEZ1eVBeFthAx
         wblg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=CHvEJVpnUTpEucTZAESaqgprel+L7cKgKdvDS7CIeuo=;
        b=MaCTKJaLcFFuA/yEwFDfwjfFw+l8WzOatU3WJ1SKM3rU/18+x6+183lLCw+ePx9yjw
         YukQccIeVc3nEz5WlUwVOBIwyks1Rd1WZ5Vdm/hMEzavneNMbH15XKY8pyXJxpNlgEKy
         7ZO+KOsG3AvQ1MYhRKW6jhADdsDVG933g80zCgt9xD2/sk1DRF//xDIlMir0E3pGHH37
         vhweJgqSLqk8z1XA5OMCJRIgRIwmY8yiZmZJSl+PrihtDxJK7zL7x5w5Pfmi8FYdu7EV
         fzB+/6aYvM9DhlG0h/GbCfH36LdB/O5iH63t2BMN7aw9j+Qf2CH0qiMJu6ofIuWxvTr9
         +xrA==
X-Gm-Message-State: APjAAAXb8rzaWMtkPMB7riCqL4cz6vwNg8CocLsJ9wIBwE8nZTB4xIU7
        cwKc+6LKEoNPK/HZVzP1iDE0igY=
X-Google-Smtp-Source: APXvYqxCUZ/ISGFTqEpRp+iWpA3L82Jo4pRIeTjvtvvkFTNDf0Wed0Dh1/DA8Pq/TSGusBRQ9w74Kg==
X-Received: by 2002:a1c:a1c5:: with SMTP id k188mr8636557wme.102.1562432123781;
        Sat, 06 Jul 2019 09:55:23 -0700 (PDT)
Received: from avx2 ([46.53.252.147])
        by smtp.gmail.com with ESMTPSA id p26sm18099800wrp.58.2019.07.06.09.55.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 09:55:23 -0700 (PDT)
Date:   Sat, 6 Jul 2019 19:55:21 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, bfields@fieldses.org, chuck.lever@oracle.com
Subject: [PATCH 2/2] net: apply proc_net_mkdir() harder
Message-ID: <20190706165521.GB10550@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Hallsmark, Per" <Per.Hallsmark@windriver.com>

proc_net_mkdir() should be used to create stuff under /proc/net,
so that dentry revalidation kicks in.

See

	commit 1fde6f21d90f8ba5da3cb9c54ca991ed72696c43
	proc: fix /proc/net/* after setns(2)

	[added more chunks --adobriyan]

Signed-off-by: "Hallsmark, Per" <Per.Hallsmark@windriver.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/net/bonding/bond_procfs.c  |    2 +-
 net/core/pktgen.c                  |    2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    2 +-
 net/ipv6/proc.c                    |    2 +-
 net/netfilter/xt_hashlimit.c       |    4 ++--
 net/netfilter/xt_recent.c          |    2 +-
 net/sunrpc/stats.c                 |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -293,7 +293,7 @@ void bond_remove_proc_entry(struct bonding *bond)
 void __net_init bond_create_proc_dir(struct bond_net *bn)
 {
 	if (!bn->proc_dir) {
-		bn->proc_dir = proc_mkdir(DRV_NAME, bn->net->proc_net);
+		bn->proc_dir = proc_net_mkdir(bn->net, DRV_NAME, bn->net->proc_net);
 		if (!bn->proc_dir)
 			pr_warn("Warning: Cannot create /proc/net/%s\n",
 				DRV_NAME);
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3791,7 +3791,7 @@ static int __net_init pg_net_init(struct net *net)
 	pn->net = net;
 	INIT_LIST_HEAD(&pn->pktgen_threads);
 	pn->pktgen_exiting = false;
-	pn->proc_dir = proc_mkdir(PG_PROC_DIR, pn->net->proc_net);
+	pn->proc_dir = proc_net_mkdir(pn->net, PG_PROC_DIR, pn->net->proc_net);
 	if (!pn->proc_dir) {
 		pr_warn("cannot create /proc/net/%s\n", PG_PROC_DIR);
 		return -ENODEV;
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -828,7 +828,7 @@ static int clusterip_net_init(struct net *net)
 		return ret;
 
 #ifdef CONFIG_PROC_FS
-	cn->procdir = proc_mkdir("ipt_CLUSTERIP", net->proc_net);
+	cn->procdir = proc_net_mkdir(net, "ipt_CLUSTERIP", net->proc_net);
 	if (!cn->procdir) {
 		nf_unregister_net_hook(net, &cip_arp_ops);
 		pr_err("Unable to proc dir entry\n");
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -282,7 +282,7 @@ static int __net_init ipv6_proc_init_net(struct net *net)
 			snmp6_seq_show, NULL))
 		goto proc_snmp6_fail;
 
-	net->mib.proc_net_devsnmp6 = proc_mkdir("dev_snmp6", net->proc_net);
+	net->mib.proc_net_devsnmp6 = proc_net_mkdir(net, "dev_snmp6", net->proc_net);
 	if (!net->mib.proc_net_devsnmp6)
 		goto proc_dev_snmp6_fail;
 	return 0;
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -1237,11 +1237,11 @@ static int __net_init hashlimit_proc_net_init(struct net *net)
 {
 	struct hashlimit_net *hashlimit_net = hashlimit_pernet(net);
 
-	hashlimit_net->ipt_hashlimit = proc_mkdir("ipt_hashlimit", net->proc_net);
+	hashlimit_net->ipt_hashlimit = proc_net_mkdir(net, "ipt_hashlimit", net->proc_net);
 	if (!hashlimit_net->ipt_hashlimit)
 		return -ENOMEM;
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-	hashlimit_net->ip6t_hashlimit = proc_mkdir("ip6t_hashlimit", net->proc_net);
+	hashlimit_net->ip6t_hashlimit = proc_net_mkdir(net, "ip6t_hashlimit", net->proc_net);
 	if (!hashlimit_net->ip6t_hashlimit) {
 		remove_proc_entry("ipt_hashlimit", net->proc_net);
 		return -ENOMEM;
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -629,7 +629,7 @@ static int __net_init recent_proc_net_init(struct net *net)
 {
 	struct recent_net *recent_net = recent_pernet(net);
 
-	recent_net->xt_recent = proc_mkdir("xt_recent", net->proc_net);
+	recent_net->xt_recent = proc_net_mkdir(net, "xt_recent", net->proc_net);
 	if (!recent_net->xt_recent)
 		return -ENOMEM;
 	return 0;
--- a/net/sunrpc/stats.c
+++ b/net/sunrpc/stats.c
@@ -323,7 +323,7 @@ int rpc_proc_init(struct net *net)
 
 	dprintk("RPC:       registering /proc/net/rpc\n");
 	sn = net_generic(net, sunrpc_net_id);
-	sn->proc_net_rpc = proc_mkdir("rpc", net->proc_net);
+	sn->proc_net_rpc = proc_net_mkdir(net, "rpc", net->proc_net);
 	if (sn->proc_net_rpc == NULL)
 		return -ENOMEM;
 
