Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EFA3E8362
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 21:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhHJTCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 15:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbhHJTCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 15:02:37 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659D9C061799
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:02:12 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id h18-20020ac856920000b029025eb726dd9bso11861672qta.8
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3WhNVW0iwZVd2Z4X+Hg7lfHQQ1wnAClgNxINJFmfwYY=;
        b=q9NQWIDXrw0r2Tu2ffRMjn6Eu6YX9+dQcjx7fCZ3E1Jj/QRcfySWx+oYbiBgCb93HT
         McCk621SLVz1LfEpuktWjhD7keo7Wtm+kwLV9pLKiK05SXUfu9tHU7ojm9HQ1NkEqm78
         X6/rFQCFD1Yo7P3dzgroeHJoTT1NQ7Zk3QztJetz/T7RRWmhb++92TVumuwxatKHGl90
         qd/hotcvSkt9uCIt+mqo4ZJ/4HJYOKcf3DmnCyaG5/v33cVAtH4yenuPIR94NzYsZgyg
         DTcb+nRmZdi/Tj8FrKFXqHGe0Yc8FQnlqYwJKImAd8ZWH6AIzl46WEZ8B22h1HE5Mrz7
         OgnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3WhNVW0iwZVd2Z4X+Hg7lfHQQ1wnAClgNxINJFmfwYY=;
        b=E8FgyHjFfHG/DDwD/7p4QPVxsNWyjgoCvq1Kq5Rp7rMeUqOlsHLLK6tg9/OqD7UD2U
         Wac0Hxnha/q/JxEurIXsKJWq6sfv7jpwS+HwrmXNweAMT1r8+ZN6QwdL/Si0lZTrbefh
         t2jw4vn3VN+PM8xcdVCp2SvVcOnwJXnOUmgoGLBdBR/uOia4jeEH/LBjA0Pj8Kn4mZ/x
         rTPhbHujFpBtd2gXmpDPnsQ3EV8+U5cROUQg69KfubUiu2LIQVXb4Y1Pk+PTqIcArGrO
         T1Xh/Ja5I8PiioBEfVqCsq0THM94Ph/wnxc7FSpKMeO+ullnFNqjOsugfQeY9sXejc7S
         uHIA==
X-Gm-Message-State: AOAM532uwWNapBljE+v0t+sHX2H7fSe8mj3UuOoLMB3QLQgK8gfQEibH
        6lPv75c46N08hAp/4Ofsli7o/76sheCADlJeAMD3Iw==
X-Google-Smtp-Source: ABdhPJwBzPubvtI6oGWElQt8AmsN8YgKWwKjXarusYvLvM0sJDHPeGFswmHpG+5Enwo4qfgT1xanyr7KwWTTtsM27a6JzQ==
X-Received: from mustash.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:337b])
 (user=richardsonnick job=sendgmr) by 2002:a05:6214:301d:: with SMTP id
 ke29mr19620409qvb.30.1628622131645; Tue, 10 Aug 2021 12:02:11 -0700 (PDT)
Date:   Tue, 10 Aug 2021 19:01:54 +0000
In-Reply-To: <20210810190159.4103778-1-richardsonnick@google.com>
Message-Id: <20210810190159.4103778-3-richardsonnick@google.com>
Mime-Version: 1.0
References: <20210810190159.4103778-1-richardsonnick@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v2 2/3] pktgen: Add imix distribution bins
From:   Nicholas Richardson <richardsonnick@google.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     nrrichar@ncsu.edu, promanov@google.com, arunkaly@google.com,
        Nick Richardson <richardsonnick@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Di Zhu <zhudi21@huawei.com>, Leesoo Ahn <dev@ooseel.net>,
        Ye Bin <yebin10@huawei.com>,
        Yejune Deng <yejune.deng@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Richardson <richardsonnick@google.com>

In order to represent the distribution of imix packet sizes, a
pre-computed data structure is used. It features 100 (IMIX_PRECISION)
"bins". Contiguous ranges of these bins represent the respective
packet size of each imix entry. This is done to avoid the overhead of
selecting the correct imix packet size based on the corresponding weights.

Example:
imix_weights 40,7 576,4 1500,1
total_weight = 7 + 4 + 1 = 12

pkt_size 40 occurs 7/total_weight = 58% of the time
pkt_size 576 occurs 4/total_weight = 33% of the time
pkt_size 1500 occurs 1/total_weight = 9% of the time

We generate a random number between 0-100 and select the corresponding
packet size based on the specified weights.
Eg. random number = 358723895 % 100 = 65
Selects the packet size corresponding to index:65 in the pre-computed
imix_distribution array.
An example of the  pre-computed array is below:

The imix_distribution will look like the following:
0        ->  0 (index of imix_entry.size == 40)
1        ->  0 (index of imix_entry.size == 40)
2        ->  0 (index of imix_entry.size == 40)
[...]    ->  0 (index of imix_entry.size == 40)
57       ->  0 (index of imix_entry.size == 40)
58       ->  1 (index of imix_entry.size == 576)
[...]    ->  1 (index of imix_entry.size == 576)
90       ->  1 (index of imix_entry.size == 576)
91       ->  2 (index of imix_entry.size == 1500)
[...]    ->  2 (index of imix_entry.size == 1500)
99       ->  2 (index of imix_entry.size == 1500)

Create and use "bin" representation of the imix distribution.

Signed-off-by: Nick Richardson <richardsonnick@google.com>
---
 net/core/pktgen.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index a7e45eaccef7..ac1de15000e2 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -177,6 +177,7 @@
 #define MPLS_STACK_BOTTOM htonl(0x00000100)
 /* Max number of internet mix entries that can be specified in imix_weights. */
 #define MAX_IMIX_ENTRIES 20
+#define IMIX_PRECISION 100 /* Precision of IMIX distribution */
 
 #define func_enter() pr_debug("entering %s\n", __func__);
 
@@ -354,6 +355,8 @@ struct pktgen_dev {
 	/* IMIX */
 	unsigned int n_imix_entries;
 	struct imix_pkt imix_entries[MAX_IMIX_ENTRIES];
+	/* Maps 0-IMIX_PRECISION range to imix_entry based on probability*/
+	__u8 imix_distribution[IMIX_PRECISION];
 
 	/* MPLS */
 	unsigned int nr_labels;	/* Depth of stack, 0 = no MPLS */
@@ -483,6 +486,7 @@ static void pktgen_stop_all_threads(struct pktgen_net *pn);
 
 static void pktgen_stop(struct pktgen_thread *t);
 static void pktgen_clear_counters(struct pktgen_dev *pkt_dev);
+static void fill_imix_distribution(struct pktgen_dev *pkt_dev);
 
 /* Module parameters, defaults. */
 static int pg_count_d __read_mostly = 1000;
@@ -1046,6 +1050,8 @@ static ssize_t pktgen_if_write(struct file *file,
 		if (len < 0)
 			return len;
 
+		fill_imix_distribution(pkt_dev);
+
 		i += len;
 		return count;
 	}
@@ -2573,6 +2579,14 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 				t = pkt_dev->min_pkt_size;
 		}
 		pkt_dev->cur_pkt_size = t;
+	} else if (pkt_dev->n_imix_entries > 0) {
+		struct imix_pkt *entry;
+		__u32 t = prandom_u32() % IMIX_PRECISION;
+		__u8 entry_index = pkt_dev->imix_distribution[t];
+
+		entry = &pkt_dev->imix_entries[entry_index];
+		entry->count_so_far++;
+		pkt_dev->cur_pkt_size = entry->size;
 	}
 
 	set_cur_queue_map(pkt_dev);
@@ -2641,6 +2655,33 @@ static void free_SAs(struct pktgen_dev *pkt_dev)
 	}
 }
 
+static void fill_imix_distribution(struct pktgen_dev *pkt_dev)
+{
+	int cumulative_probabilites[MAX_IMIX_ENTRIES];
+	int j = 0;
+	__u64 cumulative_prob = 0;
+	__u64 total_weight = 0;
+	int i = 0;
+
+	for (i = 0; i < pkt_dev->n_imix_entries; i++)
+		total_weight += pkt_dev->imix_entries[i].weight;
+
+	/* Fill cumulative_probabilites with sum of normalized probabilities */
+	for (i = 0; i < pkt_dev->n_imix_entries - 1; i++) {
+		cumulative_prob += div64_u64(pkt_dev->imix_entries[i].weight *
+						     IMIX_PRECISION,
+					     total_weight);
+		cumulative_probabilites[i] = cumulative_prob;
+	}
+	cumulative_probabilites[pkt_dev->n_imix_entries - 1] = 100;
+
+	for (i = 0; i < IMIX_PRECISION; i++) {
+		if (i == cumulative_probabilites[j])
+			j++;
+		pkt_dev->imix_distribution[i] = j;
+	}
+}
+
 static int process_ipsec(struct pktgen_dev *pkt_dev,
 			      struct sk_buff *skb, __be16 protocol)
 {
-- 
2.32.0.605.g8dce9f2422-goog

