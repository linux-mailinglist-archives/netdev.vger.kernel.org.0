Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C86EDCACB
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394793AbfJRQRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:17:19 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34634 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbfJRQRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:17:18 -0400
Received: by mail-lj1-f196.google.com with SMTP id j19so6821596lja.1
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 09:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XSbBDqZhduJ7EB0VkTU0DMuAECcGJ030N/Hoi2y5sqc=;
        b=TWZDqptgNnbsmUYorxwNdQsXsatE/uN43NV+ZY7Beoe6DDyiPTgFvGxo+ras1WwINB
         RaCIgzkvmRtdhRqb1g8LcCQIlffXO2Mj3cDBWfNCeaRNqK/9hV6GmRrddiceHaupwpg3
         gGqj3B6k6q1RXjSUyoCjDNe4HGTAVeTrb9zyQ6nA7KHQ+UIiU724rTY/f2Q9bCVrSztP
         AGrfBzXtTZxx5vgSJxzpzJOoYdjwNwSQom30DGdjjpPYL8YWb5RzNwBfQvu4zHYpk5+8
         fRJMcUH8DcKNTc+RM7b2u0aRLMcfci3cB/Q82F1fFyBz3qmrYaZ6eMSKbf6AzdO+VJ+3
         c/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XSbBDqZhduJ7EB0VkTU0DMuAECcGJ030N/Hoi2y5sqc=;
        b=rdQrtWHfxJB73d+IR3XVZuMwddqd02yVhfrDmjlJQSGAMaMdUyfeZAOTGghdf0AIp9
         BGFjAR9p1fjTJL7ToyHBDnP06ZbIvbgFEhq8ggODFhGUAAnRjNYqzKX6tB4qpwJywFSg
         nUdUsKim+pvOao8QHan+PH37u8jfNXLZrQt1PeYsA8xcdL+LtbB/rNvOmWDq34xHXMAU
         EnOhTi+QlIwgJr5hPH78I6UFMCvL3AKwkiDSx/BW3FWByb9N25kOX8F5jX0eG1Zn/W0g
         R9SSQ1jwR1RTDAQc7m+z++sJwE89QFgGnAcQfoYLggEnRTcGWtRxh/Lo3znBD426nHNW
         kf+g==
X-Gm-Message-State: APjAAAVEAHBKzVCYmKwtQp86/Si81Z7DSyG2lDJLZ4xPBY0SeaZME+vc
        J3/MHEz3wAou50t3BHdKSEXb6Q==
X-Google-Smtp-Source: APXvYqyPK+PBbU87o+Ilf8XKkJvD67g3gz9WXBA3tMlgWAfcWn3e1NiVgDI51KrFEra09+DUdqnfZA==
X-Received: by 2002:a2e:9890:: with SMTP id b16mr6184822ljj.153.1571415436903;
        Fri, 18 Oct 2019 09:17:16 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r75sm1086365lff.93.2019.10.18.09.17.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 09:17:16 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        stephen@networkplumber.org, xiyou.wangcong@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net v2 1/2] net: netem: fix error path for corrupted GSO frames
Date:   Fri, 18 Oct 2019 09:16:57 -0700
Message-Id: <20191018161658.26481-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191018161658.26481-1-jakub.kicinski@netronome.com>
References: <20191018161658.26481-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To corrupt a GSO frame we first perform segmentation.  We then
proceed using the first segment instead of the full GSO skb and
requeue the rest of the segments as separate packets.

If there are any issues with processing the first segment we
still want to process the rest, therefore we jump to the
finish_segs label.

Commit 177b8007463c ("net: netem: fix backlog accounting for
corrupted GSO frames") started using the pointer to the first
segment in the "rest of segments processing", but as mentioned
above the first segment may had already been freed at this point.

Backlog corrections for parent qdiscs have to be adjusted.

Fixes: 177b8007463c ("net: netem: fix backlog accounting for corrupted GSO frames")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/sched/sch_netem.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 0e44039e729c..942eb17f413c 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -509,6 +509,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		if (skb->ip_summed == CHECKSUM_PARTIAL &&
 		    skb_checksum_help(skb)) {
 			qdisc_drop(skb, sch, to_free);
+			skb = NULL;
 			goto finish_segs;
 		}
 
@@ -593,9 +594,10 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 finish_segs:
 	if (segs) {
 		unsigned int len, last_len;
-		int nb = 0;
+		int nb;
 
-		len = skb->len;
+		len = skb ? skb->len : 0;
+		nb = skb ? 1 : 0;
 
 		while (segs) {
 			skb2 = segs->next;
@@ -612,7 +614,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			}
 			segs = skb2;
 		}
-		qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
+		/* Parent qdiscs accounted for 1 skb of size @prev_len */
+		qdisc_tree_reduce_backlog(sch, -(nb - 1), -(len - prev_len));
 	}
 	return NET_XMIT_SUCCESS;
 }
-- 
2.23.0

