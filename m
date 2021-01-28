Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE85307A9C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 17:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhA1QWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 11:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhA1QWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 11:22:33 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDB9C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 08:21:52 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id u4so4600070pjn.4
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 08:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+nxsSzios4I+oPIFkvhWEajlhJmnuXBsPeg2HazMxs4=;
        b=skL3+ZcL+7RJollywvy3MLLsejkCnp+uI8lFJx8I3WVjG+0D1sVHhZNo2axZgqbp6A
         8R39XIytXTlM4tAZOqsgb/8TtphV+azxTLbpfI3X2BZ5DW/+U2k2KrA1Gmr7WjK1zBDk
         8Vf3QrJF7mC9/Ldw2lVw1t0nDGV7w0OZJWfywKJhHFriC86O5A43WjN9nTu4qJFuUbYG
         GmIIA1Y3U06lW0jo5QSMJcgfF+oDMgau/RVYL+Yr47ry4Nc92Uc+3I3SI9gum+WBtRlo
         30JPuLCdn7fg487QQ8f2JFsbh0FYVVUqAHXhlc1u2rzbTC+sMOOhQ2IIdvAh4whZocLx
         +aRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+nxsSzios4I+oPIFkvhWEajlhJmnuXBsPeg2HazMxs4=;
        b=IbBiXa0V/a9fwDXl24rd5Ups2P6hRy6Xa7USlynFB/Xdph3HAyz2iduPNYj4OndWmn
         wNDoZt6KP5yjAiGhB3SldHnDIX8HrPfE+FAD+/LWE15Vae2eEFi7qVltjd9ElZV3RqH/
         iMU2lPMw4Qca+uzNu3jXc7pPpOk9PFcky2lbMdyN/cxrAcoea0xUQcVTM3TEZ8lD8swR
         VGtRD+TUc0Ho22GEGY2p17+dohZr645sfTlq3FliSaG5eLcODf9XeQXJ9wEIwel44Sti
         w57uywBZ6plPgAT+INqMVvHu2S6yGZhYTu1PdwgZK3EVWQh/f9TxlhaLKdf1J7Nr8PRE
         8rAg==
X-Gm-Message-State: AOAM531sUu4rYG5dvfF07ZbCmY814hhaUVs8BVnvYxrAuVkSvENCIdTS
        v3WwYAry2pkT5gwuzyNPIiM=
X-Google-Smtp-Source: ABdhPJz12aGRze9krC0TDlo5os1LjbajeByTiZIJ64G6EmMR/7AboO++wqsvXkDQ6JPUgJTfqF1CqQ==
X-Received: by 2002:a17:90a:5911:: with SMTP id k17mr155094pji.152.1611850912493;
        Thu, 28 Jan 2021 08:21:52 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b957:52cf:4cb2:3a3e])
        by smtp.gmail.com with ESMTPSA id x81sm6481609pfc.46.2021.01.28.08.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 08:21:51 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: proc: speedup /proc/net/netstat
Date:   Thu, 28 Jan 2021 08:21:45 -0800
Message-Id: <20210128162145.1703601-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Use cache friendly helpers to better use cpu caches
while reading /proc/net/netstat

Tested on a platform with 256 threads (AMD Rome)

Before: 305 usec spent in netstat_seq_show()
After: 130 usec spent in netstat_seq_show()

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/proc.c | 48 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 63cd370ea29dbd21bc8d82f726af3e3f76c7f807..6d46297a99f8d94abc27c737a02dea4d64b6c1d6 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -464,30 +464,52 @@ static int snmp_seq_show(struct seq_file *seq, void *v)
  */
 static int netstat_seq_show(struct seq_file *seq, void *v)
 {
-	int i;
+	const int ip_cnt = ARRAY_SIZE(snmp4_ipextstats_list) - 1;
+	const int tcp_cnt = ARRAY_SIZE(snmp4_net_list) - 1;
 	struct net *net = seq->private;
+	unsigned long *buff;
+	int i;
 
 	seq_puts(seq, "TcpExt:");
-	for (i = 0; snmp4_net_list[i].name; i++)
+	for (i = 0; i < tcp_cnt; i++)
 		seq_printf(seq, " %s", snmp4_net_list[i].name);
 
 	seq_puts(seq, "\nTcpExt:");
-	for (i = 0; snmp4_net_list[i].name; i++)
-		seq_printf(seq, " %lu",
-			   snmp_fold_field(net->mib.net_statistics,
-					   snmp4_net_list[i].entry));
-
+	buff = kzalloc(max(tcp_cnt * sizeof(long), ip_cnt * sizeof(u64)),
+		       GFP_KERNEL);
+	if (buff) {
+		snmp_get_cpu_field_batch(buff, snmp4_net_list,
+					 net->mib.net_statistics);
+		for (i = 0; i < tcp_cnt; i++)
+			seq_printf(seq, " %lu", buff[i]);
+	} else {
+		for (i = 0; i < tcp_cnt; i++)
+			seq_printf(seq, " %lu",
+				   snmp_fold_field(net->mib.net_statistics,
+						   snmp4_net_list[i].entry));
+	}
 	seq_puts(seq, "\nIpExt:");
-	for (i = 0; snmp4_ipextstats_list[i].name; i++)
+	for (i = 0; i < ip_cnt; i++)
 		seq_printf(seq, " %s", snmp4_ipextstats_list[i].name);
 
 	seq_puts(seq, "\nIpExt:");
-	for (i = 0; snmp4_ipextstats_list[i].name; i++)
-		seq_printf(seq, " %llu",
-			   snmp_fold_field64(net->mib.ip_statistics,
-					     snmp4_ipextstats_list[i].entry,
-					     offsetof(struct ipstats_mib, syncp)));
+	if (buff) {
+		u64 *buff64 = (u64 *)buff;
 
+		memset(buff64, 0, ip_cnt * sizeof(u64));
+		snmp_get_cpu_field64_batch(buff64, snmp4_ipextstats_list,
+					   net->mib.ip_statistics,
+					   offsetof(struct ipstats_mib, syncp));
+		for (i = 0; i < ip_cnt; i++)
+			seq_printf(seq, " %llu", buff64[i]);
+	} else {
+		for (i = 0; i < ip_cnt; i++)
+			seq_printf(seq, " %llu",
+				   snmp_fold_field64(net->mib.ip_statistics,
+						     snmp4_ipextstats_list[i].entry,
+						     offsetof(struct ipstats_mib, syncp)));
+	}
+	kfree(buff);
 	seq_putc(seq, '\n');
 	mptcp_seq_show(seq);
 	return 0;
-- 
2.30.0.280.ga3ce27912f-goog

