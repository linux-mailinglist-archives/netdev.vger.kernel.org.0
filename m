Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92FD2D8A98
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408154AbgLLXKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:10:02 -0500
Received: from correo.us.es ([193.147.175.20]:46746 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408151AbgLLXGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 18:06:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2DDB0303D0E
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CCC2DA72F
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:11 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 11F92DA73F; Sun, 13 Dec 2020 00:05:11 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF2D1DA72F;
        Sun, 13 Dec 2020 00:05:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 13 Dec 2020 00:05:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 966264265A5A;
        Sun, 13 Dec 2020 00:05:08 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 02/10] ipvs: replace atomic_add_return()
Date:   Sun, 13 Dec 2020 00:05:05 +0100
Message-Id: <20201212230513.3465-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201212230513.3465-1-pablo@netfilter.org>
References: <20201212230513.3465-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yejune Deng <yejune.deng@gmail.com>

atomic_inc_return() looks better

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 2 +-
 net/netfilter/ipvs/ip_vs_sync.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index c0b8215ab3d4..54e086c65721 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2137,7 +2137,7 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 	if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
 		pkts = sysctl_sync_threshold(ipvs);
 	else
-		pkts = atomic_add_return(1, &cp->in_pkts);
+		pkts = atomic_inc_return(&cp->in_pkts);
 
 	if (ipvs->sync_state & IP_VS_STATE_MASTER)
 		ip_vs_sync_conn(ipvs, cp, pkts);
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 16b48064f715..9d43277b8b4f 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -615,7 +615,7 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 	cp = cp->control;
 	if (cp) {
 		if (cp->flags & IP_VS_CONN_F_TEMPLATE)
-			pkts = atomic_add_return(1, &cp->in_pkts);
+			pkts = atomic_inc_return(&cp->in_pkts);
 		else
 			pkts = sysctl_sync_threshold(ipvs);
 		ip_vs_sync_conn(ipvs, cp, pkts);
@@ -776,7 +776,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	if (!cp)
 		return;
 	if (cp->flags & IP_VS_CONN_F_TEMPLATE)
-		pkts = atomic_add_return(1, &cp->in_pkts);
+		pkts = atomic_inc_return(&cp->in_pkts);
 	else
 		pkts = sysctl_sync_threshold(ipvs);
 	goto sloop;
-- 
2.20.1

