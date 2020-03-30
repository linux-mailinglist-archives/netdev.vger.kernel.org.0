Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 876AE197147
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 02:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgC3AhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 20:37:24 -0400
Received: from correo.us.es ([193.147.175.20]:57168 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgC3AhW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 97418EF426
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 88FFC100A44
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7D336100A4E; Mon, 30 Mar 2020 02:37:20 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F886100A45;
        Mon, 30 Mar 2020 02:37:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 70F8542EF42A;
        Mon, 30 Mar 2020 02:37:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/26] netfilter: conntrack: Add missing annotations for nf_conntrack_all_lock() and nf_conntrack_all_unlock()
Date:   Mon, 30 Mar 2020 02:36:50 +0200
Message-Id: <20200330003708.54017-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jules Irenge <jbi.octave@gmail.com>

Sparse reports warnings at nf_conntrack_all_lock()
	and nf_conntrack_all_unlock()

warning: context imbalance in nf_conntrack_all_lock()
	- wrong count at exit
warning: context imbalance in nf_conntrack_all_unlock()
	- unexpected unlock

Add the missing __acquires(&nf_conntrack_locks_all_lock)
Add missing __releases(&nf_conntrack_locks_all_lock)

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a18f8fe728e3..f82d4a802acc 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -143,6 +143,7 @@ static bool nf_conntrack_double_lock(struct net *net, unsigned int h1,
 }
 
 static void nf_conntrack_all_lock(void)
+	__acquires(&nf_conntrack_locks_all_lock)
 {
 	int i;
 
@@ -162,6 +163,7 @@ static void nf_conntrack_all_lock(void)
 }
 
 static void nf_conntrack_all_unlock(void)
+	__releases(&nf_conntrack_locks_all_lock)
 {
 	/* All prior stores must be complete before we clear
 	 * 'nf_conntrack_locks_all'. Otherwise nf_conntrack_lock()
-- 
2.11.0

