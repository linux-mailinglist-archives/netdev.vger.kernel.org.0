Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7363A2E8DE6
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 20:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbhACTaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 14:30:10 -0500
Received: from correo.us.es ([193.147.175.20]:40762 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727294AbhACTaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 14:30:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7A42CDA709
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 20:28:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6AF43DA722
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 20:28:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 60733DA704; Sun,  3 Jan 2021 20:28:52 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41CE6DA72F;
        Sun,  3 Jan 2021 20:28:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 03 Jan 2021 20:28:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 0EE56426CC85;
        Sun,  3 Jan 2021 20:28:50 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/3] netfilter: xt_RATEEST: reject non-null terminated string from userspace
Date:   Sun,  3 Jan 2021 20:29:18 +0100
Message-Id: <20210103192920.18639-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210103192920.18639-1-pablo@netfilter.org>
References: <20210103192920.18639-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

syzbot reports:
detected buffer overflow in strlen
[..]
Call Trace:
 strlen include/linux/string.h:325 [inline]
 strlcpy include/linux/string.h:348 [inline]
 xt_rateest_tg_checkentry+0x2a5/0x6b0 net/netfilter/xt_RATEEST.c:143

strlcpy assumes src is a c-string. Check info->name before its used.

Reported-by: syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com
Fixes: 5859034d7eb8793 ("[NETFILTER]: x_tables: add RATEEST target")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_RATEEST.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 37253d399c6b..0d5c422f8745 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -115,6 +115,9 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 	} cfg;
 	int ret;
 
+	if (strnlen(info->name, sizeof(est->name)) >= sizeof(est->name))
+		return -ENAMETOOLONG;
+
 	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
 
 	mutex_lock(&xn->hash_lock);
-- 
2.20.1

