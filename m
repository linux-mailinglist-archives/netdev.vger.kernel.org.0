Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 700537C07B
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 13:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfGaLwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 07:52:09 -0400
Received: from correo.us.es ([193.147.175.20]:59300 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727461AbfGaLwH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 07:52:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DCC9180770
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 13:52:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CCA261150DE
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 13:52:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C17BD1150CC; Wed, 31 Jul 2019 13:52:05 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86405DA4D1;
        Wed, 31 Jul 2019 13:52:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 31 Jul 2019 13:52:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.83])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 170044265A32;
        Wed, 31 Jul 2019 13:52:02 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/8] netfilter: ebtables: fix a memory leak bug in compat
Date:   Wed, 31 Jul 2019 13:51:50 +0200
Message-Id: <20190731115157.27020-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190731115157.27020-1-pablo@netfilter.org>
References: <20190731115157.27020-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

In compat_do_replace(), a temporary buffer is allocated through vmalloc()
to hold entries copied from the user space. The buffer address is firstly
saved to 'newinfo->entries', and later on assigned to 'entries_tmp'. Then
the entries in this temporary buffer is copied to the internal kernel
structure through compat_copy_entries(). If this copy process fails,
compat_do_replace() should be terminated. However, the allocated temporary
buffer is not freed on this path, leading to a memory leak.

To fix the bug, free the buffer before returning from compat_do_replace().

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 963dfdc14827..fd84b48e48b5 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2261,8 +2261,10 @@ static int compat_do_replace(struct net *net, void __user *user,
 	state.buf_kern_len = size64;
 
 	ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
-	if (WARN_ON(ret < 0))
+	if (WARN_ON(ret < 0)) {
+		vfree(entries_tmp);
 		goto out_unlock;
+	}
 
 	vfree(entries_tmp);
 	tmp.entries_size = size64;
-- 
2.11.0

