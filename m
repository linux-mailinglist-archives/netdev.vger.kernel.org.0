Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7A6651FB4
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbfFYAMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:12:51 -0400
Received: from mail.us.es ([193.147.175.20]:38016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729343AbfFYAMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A482AC04B6
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97B79DA70B
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8D815DA708; Tue, 25 Jun 2019 02:12:48 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93069DA70A;
        Tue, 25 Jun 2019 02:12:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5E0804265A2F;
        Tue, 25 Jun 2019 02:12:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/26] netfilter: xt_owner: bail out with EINVAL in case of unsupported flags
Date:   Tue, 25 Jun 2019 02:12:18 +0200
Message-Id: <20190625001233.22057-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reject flags that are not supported with EINVAL.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/xt_owner.h | 5 +++++
 net/netfilter/xt_owner.c                | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_owner.h b/include/uapi/linux/netfilter/xt_owner.h
index 9e98c09eda32..5108df4d0313 100644
--- a/include/uapi/linux/netfilter/xt_owner.h
+++ b/include/uapi/linux/netfilter/xt_owner.h
@@ -11,6 +11,11 @@ enum {
 	XT_OWNER_SUPPL_GROUPS = 1 << 3,
 };
 
+#define XT_OWNER_MASK	(XT_OWNER_UID | 	\
+			 XT_OWNER_GID | 	\
+			 XT_OWNER_SOCKET |	\
+			 XT_OWNER_SUPPL_GROUPS)
+
 struct xt_owner_match_info {
 	__u32 uid_min, uid_max;
 	__u32 gid_min, gid_max;
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index a8784502aca6..ee597fdc5db7 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -25,6 +25,9 @@ static int owner_check(const struct xt_mtchk_param *par)
 	struct xt_owner_match_info *info = par->matchinfo;
 	struct net *net = par->net;
 
+	if (info->match & ~XT_OWNER_MASK)
+		return -EINVAL;
+
 	/* Only allow the common case where the userns of the writer
 	 * matches the userns of the network namespace.
 	 */
-- 
2.11.0

