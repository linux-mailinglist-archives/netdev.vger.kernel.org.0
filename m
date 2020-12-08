Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE162D3482
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgLHUrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:47:55 -0500
Received: from correo.us.es ([193.147.175.20]:60022 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgLHUry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:47:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7F418DED24
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 21:47:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72002DA722
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 21:47:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6780EDA78C; Tue,  8 Dec 2020 21:47:04 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3FE28DA789;
        Tue,  8 Dec 2020 21:47:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Dec 2020 21:47:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 15EA64265A5A;
        Tue,  8 Dec 2020 21:47:02 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net] net: sched: incorrect Kconfig dependencies on Netfilter modules
Date:   Tue,  8 Dec 2020 21:47:07 +0100
Message-Id: <20201208204707.11268-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- NET_ACT_CONNMARK and NET_ACT_CTINFO only require conntrack support.
- NET_ACT_IPT only requires NETFILTER_XTABLES symbols, not
  IP_NF_IPTABLES. After this patch, NET_ACT_IPT becomes consistent
  with NET_EMATCH_IPT. NET_ACT_IPT dependency on IP_NF_IPTABLES predates
  Linux-2.6.12-rc2 (initial git repository build).

Fixes: 22a5dc0e5e3e ("net: sched: Introduce connmark action")
Fixes: 24ec483cec98 ("net: sched: Introduce act_ctinfo action")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/sched/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d88800e..d762e89ab74f 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -813,7 +813,7 @@ config NET_ACT_SAMPLE
 
 config NET_ACT_IPT
 	tristate "IPtables targets"
-	depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
+	depends on NET_CLS_ACT && NETFILTER && NETFILTER_XTABLES
 	help
 	  Say Y here to be able to invoke iptables targets after successful
 	  classification.
@@ -912,7 +912,7 @@ config NET_ACT_BPF
 
 config NET_ACT_CONNMARK
 	tristate "Netfilter Connection Mark Retriever"
-	depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
+	depends on NET_CLS_ACT && NETFILTER
 	depends on NF_CONNTRACK && NF_CONNTRACK_MARK
 	help
 	  Say Y here to allow retrieving of conn mark
@@ -924,7 +924,7 @@ config NET_ACT_CONNMARK
 
 config NET_ACT_CTINFO
 	tristate "Netfilter Connection Mark Actions"
-	depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
+	depends on NET_CLS_ACT && NETFILTER
 	depends on NF_CONNTRACK && NF_CONNTRACK_MARK
 	help
 	  Say Y here to allow transfer of a connmark stored information.
-- 
2.20.1

