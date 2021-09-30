Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0522A41D0CE
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 03:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347564AbhI3BFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 21:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236932AbhI3BFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 21:05:22 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45009C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 18:03:41 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x4so2785167pln.5
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 18:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7nEP9G45spq5xv8tXXluO1vEopMiEfhTEHqUciYsJoQ=;
        b=XeiGtRSNN7kLqmXoTCGBCgAuTrNsFwY+2iwPfjpXPP3JiCGzQ8zoIKtOIvYFmgXiCD
         UXHP4Y8bAQayRKLDwhhjcSizc6G9HF5Kuvv1eWHO98r97t+B1toMikTVSlpUq7QoSIP5
         WPpvav4HEvesY2vZMkqcVVWjseash35medEQyatfRkNEk1AhCplffOCXXd64qwq2Gv55
         mmiBe6R1qpgxdrkerzg+Uzq8ceRdaPXLDAc10RDXEaHSn7mbKkVJX3CwIiVafIPmBn47
         cAlYlCShxFIxOMhcigdI9Fe3GWEK7TmHXR9JbqNIf7Eb7AosMUVQgaMVHExa6/WJU4yr
         GuDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7nEP9G45spq5xv8tXXluO1vEopMiEfhTEHqUciYsJoQ=;
        b=QVJAfHOb66xFlQkRNuSrQVXrgycuZsvBYPTIKgiTesGKDB5X+eNuA7cpVDwfdZe3At
         Y3IB5fykgCyVUDUoaW6CGiE7bJBmR/bxzbyHzTMConVa7hkVDMy518IBQxTXk2/cjVGj
         JZ/Oc8qA7EnkE4riioDGuer9L/41DRCtQiBzqNTlThQa30iNPHgLfoHF/J6PxQmw3HKZ
         gEYUuGZwdsKjc5qxHnDFRzEjIiNnA5Vneh80AvgVfKw+DQ/7Xhd+hXly5FarnyUD2UdW
         S4/XiheZc+j23qPvD1BZ75Qh5WbDbc0IHVJ/z6bHTdF9kaZDFKWuB8F6cmlP/uNT5L4a
         jPHg==
X-Gm-Message-State: AOAM530EH9lg6/nJs7xaJmqbsFCMPjxBIOg4GmSo2mFccUW1MZrMViB0
        UrotAi5Wpqa4LM/nnaa3sBQ=
X-Google-Smtp-Source: ABdhPJwz8ds5UtCZn+EHoPCBJNtaemK/BakF9eqioXRv8qPbQb7PFpOwbRxkdCpC9l8bKtRD9sG5mg==
X-Received: by 2002:a17:90b:911:: with SMTP id bo17mr7744343pjb.232.1632963820852;
        Wed, 29 Sep 2021 18:03:40 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8858:a0b7:dcc9:9a3b])
        by smtp.gmail.com with ESMTPSA id p17sm711695pju.34.2021.09.29.18.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 18:03:40 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next 2/2] mptcp: use batch snmp operations in mptcp_seq_show()
Date:   Wed, 29 Sep 2021 18:03:33 -0700
Message-Id: <20210930010333.2625706-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
In-Reply-To: <20210930010333.2625706-1-eric.dumazet@gmail.com>
References: <20210930010333.2625706-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Using snmp_get_cpu_field_batch() allows for better cpu cache
utilization, especially on hosts with large number of cpus.

Also remove special handling when mptcp mibs where not yet
allocated.

I chose to use temporary storage on the stack to keep this patch simple.
We might in the future use the storage allocated in netstat_seq_show().

Combined with prior patch (inlining snmp_get_cpu_field)
time to fetch and output mptcp counters on a 256 cpu host [1]
goes from 75 usec to 16 usec.

[1] L1 cache size is 32KB, it is not big enough to hold all dataset.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/mptcp/mib.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index b21ff9be04c61772c8a7648d9540b48907de9115..3240b72271a7f3724577907bc99bdfe41a97f9de 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -72,6 +72,7 @@ bool mptcp_mib_alloc(struct net *net)
 
 void mptcp_seq_show(struct seq_file *seq)
 {
+	unsigned long sum[ARRAY_SIZE(mptcp_snmp_list) - 1];
 	struct net *net = seq->private;
 	int i;
 
@@ -81,17 +82,13 @@ void mptcp_seq_show(struct seq_file *seq)
 
 	seq_puts(seq, "\nMPTcpExt:");
 
-	if (!net->mib.mptcp_statistics) {
-		for (i = 0; mptcp_snmp_list[i].name; i++)
-			seq_puts(seq, " 0");
-
-		seq_putc(seq, '\n');
-		return;
-	}
+	memset(sum, 0, sizeof(sum));
+	if (net->mib.mptcp_statistics)
+		snmp_get_cpu_field_batch(sum, mptcp_snmp_list,
+					 net->mib.mptcp_statistics);
 
 	for (i = 0; mptcp_snmp_list[i].name; i++)
-		seq_printf(seq, " %lu",
-			   snmp_fold_field(net->mib.mptcp_statistics,
-					   mptcp_snmp_list[i].entry));
+		seq_printf(seq, " %lu", sum[i]);
+
 	seq_putc(seq, '\n');
 }
-- 
2.33.0.800.g4c38ced690-goog

