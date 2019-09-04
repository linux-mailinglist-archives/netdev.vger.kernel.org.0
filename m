Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C41DA8A5C
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731462AbfIDP7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:59:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731561AbfIDP7H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C32922CF5;
        Wed,  4 Sep 2019 15:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612746;
        bh=pR3CzoiP/l4u9WXOivvJeklVRs9Y9Mr9UyzMcf/eFN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPKjoXSAvfXrsJsZAqDs5H0fW+WnCJvWjbeMMQr1mMeFbBXMQoIiRrap1hIlWYcs0
         jMz2HeCiVxNScmp0hI+tvFlATJe/TiMpSUCXI/JYk0irhWMHpyBO/Ca40b/3Zz+UWg
         GcPuHHb0KDul4hbzhx1KHZMwgzgJ530jmtk5HSV8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 57/94] netfilter: conntrack: make sysctls per-namespace again
Date:   Wed,  4 Sep 2019 11:57:02 -0400
Message-Id: <20190904155739.2816-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 478553fd1b6f819390b64a2e13ac756c4d1a2836 ]

When I merged the extension sysctl tables with the main one I forgot to
reset them on netns creation.  They currently read/write init_net settings.

Fixes: d912dec12428 ("netfilter: conntrack: merge acct and helper sysctl table with main one")
Fixes: cb2833ed0044 ("netfilter: conntrack: merge ecache and timestamp sysctl tables with main one")
Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_standalone.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e0d392cb3075a..0006503d2da97 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1037,8 +1037,13 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_COUNT].data = &net->ct.count;
 	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
 	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
+	table[NF_SYSCTL_CT_ACCT].data = &net->ct.sysctl_acct;
+	table[NF_SYSCTL_CT_HELPER].data = &net->ct.sysctl_auto_assign_helper;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	table[NF_SYSCTL_CT_EVENTS].data = &net->ct.sysctl_events;
+#endif
+#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
+	table[NF_SYSCTL_CT_TIMESTAMP].data = &net->ct.sysctl_tstamp;
 #endif
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC].data = &nf_generic_pernet(net)->timeout;
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP].data = &nf_icmp_pernet(net)->timeout;
-- 
2.20.1

