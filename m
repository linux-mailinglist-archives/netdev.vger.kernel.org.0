Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5E03553A2
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343997AbhDFMWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:22:14 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34432 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343963AbhDFMWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:01 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 621CC63E5C;
        Tue,  6 Apr 2021 14:21:28 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 07/28] netfilter: nf_log: add module softdeps
Date:   Tue,  6 Apr 2021 14:21:12 +0200
Message-Id: <20210406122133.1644-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

xt_LOG has no direct dependency on the syslog-based logger, it relies
on the nf_log core to probe the requested backend.

Now that all syslog-based loggers reside in the same module, we can
just add a soft dependency on nf_log_syslog and let modprobe take
care of it.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_LOG.c   | 1 +
 net/netfilter/xt_NFLOG.c | 1 +
 net/netfilter/xt_TRACE.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index a1e79b517c01..2ff75f7637b0 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -108,3 +108,4 @@ MODULE_AUTHOR("Jan Rekorajski <baggins@pld.org.pl>");
 MODULE_DESCRIPTION("Xtables: IPv4/IPv6 packet logging");
 MODULE_ALIAS("ipt_LOG");
 MODULE_ALIAS("ip6t_LOG");
+MODULE_SOFTDEP("pre: nf_log_syslog");
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 6e83ce3000db..fb5793208059 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -79,3 +79,4 @@ static void __exit nflog_tg_exit(void)
 
 module_init(nflog_tg_init);
 module_exit(nflog_tg_exit);
+MODULE_SOFTDEP("pre: nfnetlink_log");
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index 349ab5609b1b..5582dce98cae 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -52,3 +52,4 @@ static void __exit trace_tg_exit(void)
 
 module_init(trace_tg_init);
 module_exit(trace_tg_exit);
+MODULE_SOFTDEP("pre: nf_log_syslog");
-- 
2.30.2

