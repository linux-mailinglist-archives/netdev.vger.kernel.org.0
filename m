Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E29129BBD
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390511AbfEXQEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:04:07 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:48446 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389962AbfEXQEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:04:06 -0400
Received: by mail-yb1-f201.google.com with SMTP id h83so8605293ybh.15
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lBzrKH6TQn8GCg3NqK9vXCk9gsyTcW+ZfPriUFHCUvM=;
        b=t6m7k+F6vO1DcAuteDc0qrcfgD5NXyzvHhi+dz5ClxUYBsPJxZx58dEAg0gvbIGS23
         gLxG5aDDmmblL6cTwk8r1Er5O89Vu8DzJYvFHxC+6ELAzpliaFkqH/UVhLTyubzRvUVO
         wCHmhOiUMRtQumzmB/lr7blponlcWS7J+R2gyjlMY3STwzTn0Y5PqB442vY+Fzm3Ua5U
         ML6x460CZ2FfsQbDTcWIRimiJ2mBNaDnoaX31+Nnkaq8bvyLJA0nZJq8lnRGMdKtKBbc
         xxhD1ubsjgyAyvmYwopvnWocuFtZVJN6HmRKYo+kCg1h78rVN5XeFEjggr3FdJtjgYeU
         CJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lBzrKH6TQn8GCg3NqK9vXCk9gsyTcW+ZfPriUFHCUvM=;
        b=UPkriBFHlI7tDgSNoR95XieudVhurlVHl1tGoU6Qc3MwJwT5CZIo8/g/q728P2GdT2
         wcRBHyRaAEmrnkIQZOPbE3FKKWM58ar0rOIUsq5+UumnKG928Ta3i2w5FbIePnXglIk1
         pzX1bUfohwF3CU7hGvu/AtYaqa+wev5rSfU88Px9AJHBs6SwgAnwbCqAKrGVptSOm7j2
         dXYr5BVcrUlRiXvjWqKq5XuFwAggEXE/+e271u1fUbhKnCL3wVWsWpSD5vuzBRLS+M0z
         CAJgEkfICUNuCCiw5bQX1xBe7s9fntL3SyAb85UTlxalXJQjJgaIsD9KTv5XxFgKykQX
         Hwng==
X-Gm-Message-State: APjAAAWgRRwipLIWSZYKhRw0giBMFPvJOWje3itQtpv76oB89oUYW6OI
        Jpttq+CJrIIXKeV1W5fZJGIuXLHVl8nIbw==
X-Google-Smtp-Source: APXvYqxJ980a4crhkVUjJjmFS5BCnL274idxIryUfKLQ9fUqTTAMbZqA3gjSXp0KCT2e888sgPlejtbhK1qZbA==
X-Received: by 2002:a0d:dd8c:: with SMTP id g134mr46813125ywe.84.1558713845461;
 Fri, 24 May 2019 09:04:05 -0700 (PDT)
Date:   Fri, 24 May 2019 09:03:36 -0700
In-Reply-To: <20190524160340.169521-1-edumazet@google.com>
Message-Id: <20190524160340.169521-8-edumazet@google.com>
Mime-Version: 1.0
References: <20190524160340.169521-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 07/11] ieee820154: 6lowpan: no longer reference
 init_net in lowpan_frags_ns_ctl_table
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(struct net *)->ieee802154_lowpan.fqdir will soon be a pointer, so make
sure lowpan_frags_ns_ctl_table[] does not reference init_net.

lowpan_frags_ns_sysctl_register() can perform the needed initialization
for all netns.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ieee802154/6lowpan/reassembly.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index 955047fe797a10995845bca51cb9770e3356a351..4bbd6999c58fc04ad660928a10f89a7ff0ed4cf2 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -326,23 +326,18 @@ int lowpan_frag_rcv(struct sk_buff *skb, u8 frag_type)
 static struct ctl_table lowpan_frags_ns_ctl_table[] = {
 	{
 		.procname	= "6lowpanfrag_high_thresh",
-		.data		= &init_net.ieee802154_lowpan.fqdir.high_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= &init_net.ieee802154_lowpan.fqdir.low_thresh
 	},
 	{
 		.procname	= "6lowpanfrag_low_thresh",
-		.data		= &init_net.ieee802154_lowpan.fqdir.low_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra2		= &init_net.ieee802154_lowpan.fqdir.high_thresh
 	},
 	{
 		.procname	= "6lowpanfrag_time",
-		.data		= &init_net.ieee802154_lowpan.fqdir.timeout,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -377,17 +372,17 @@ static int __net_init lowpan_frags_ns_sysctl_register(struct net *net)
 		if (table == NULL)
 			goto err_alloc;
 
-		table[0].data = &ieee802154_lowpan->fqdir.high_thresh;
-		table[0].extra1 = &ieee802154_lowpan->fqdir.low_thresh;
-		table[1].data = &ieee802154_lowpan->fqdir.low_thresh;
-		table[1].extra2 = &ieee802154_lowpan->fqdir.high_thresh;
-		table[2].data = &ieee802154_lowpan->fqdir.timeout;
-
 		/* Don't export sysctls to unprivileged users */
 		if (net->user_ns != &init_user_ns)
 			table[0].procname = NULL;
 	}
 
+	table[0].data	= &ieee802154_lowpan->fqdir.high_thresh;
+	table[0].extra1	= &ieee802154_lowpan->fqdir.low_thresh;
+	table[1].data	= &ieee802154_lowpan->fqdir.low_thresh;
+	table[1].extra2	= &ieee802154_lowpan->fqdir.high_thresh;
+	table[2].data	= &ieee802154_lowpan->fqdir.timeout;
+
 	hdr = register_net_sysctl(net, "net/ieee802154/6lowpan", table);
 	if (hdr == NULL)
 		goto err_reg;
-- 
2.22.0.rc1.257.g3120a18244-goog

