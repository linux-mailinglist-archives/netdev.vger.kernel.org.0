Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D64CE17C521
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 19:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCFSPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 13:15:21 -0500
Received: from correo.us.es ([193.147.175.20]:40740 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgCFSPU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 13:15:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7997B15AEA2
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6836EDA3A0
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:02 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 60E9BDA38F; Fri,  6 Mar 2020 19:15:02 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3EDFCDA3A0;
        Fri,  6 Mar 2020 19:15:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Mar 2020 19:15:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 126B04301DE0;
        Fri,  6 Mar 2020 19:15:00 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/11] netfilter: nf_conntrack: ct_cpu_seq_next should increase position index
Date:   Fri,  6 Mar 2020 19:15:03 +0100
Message-Id: <20200306181513.656594-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200306181513.656594-1-pablo@netfilter.org>
References: <20200306181513.656594-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

If .next function does not change position index,
following .show function will repeat output related
to current position index.

Cc: stable@vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 410809c669e1..4912069627b6 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -411,7 +411,7 @@ static void *ct_cpu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		*pos = cpu + 1;
 		return per_cpu_ptr(net->ct.stat, cpu);
 	}
-
+	(*pos)++;
 	return NULL;
 }
 
-- 
2.11.0

