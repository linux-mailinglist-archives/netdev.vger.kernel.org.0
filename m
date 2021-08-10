Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F8A3E835E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 21:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhHJTCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 15:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbhHJTCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 15:02:30 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAA5C0613C1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:02:07 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id s16-20020a05620a0810b02903d250dfc6a7so3202730qks.5
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V7Sgs3nsJ0DQkLJAMtKl+NYqeYDf7l5EnJnzYaV3WwY=;
        b=vgYfHmzOprCr6/Y8iMnO2sGQiUIB50TbLbQ5Hof3hkoJkQC+O0jy5vhlnDBdILATJM
         JcwAWDEM4Rh7bC5pwjhIJDKs8yx8duhSjU8M36TIiY1OInrpm2toMm4FopXl5/W4ts9E
         6R7QMYM3Bc95hwDcZSZ10jH5/oNYGXMCphK3emg89pyDnn4yrflnG9uZQo+YTB6lFPPH
         47ImCOMLi8cbZ5mkcljyXJIt5q44PaxdpV5R1+NeaOE8urCKaHvkigS5eTkvg2WTzCmq
         HBYsOneES1q/AWpqzu7tn2aa03ACtdKghJWFoeKcRle4PYkksCA4PnSSPSYxBXG9TtT2
         TVIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V7Sgs3nsJ0DQkLJAMtKl+NYqeYDf7l5EnJnzYaV3WwY=;
        b=CamHjix/VkyD9eyi0DvpeZLhpBk7lLal1SQAKfuoPDq5S3rnuL9Y5fLi6hN4HqO1mr
         tIjgqtLW0tPMVV4+U3wR+0Uiy++CyLe8aWBNgQraTovKcCYqDht0TCI+sp/Y6Q/+dadh
         kLRB1pAWpW5/OH9mOxpwHAmKCJh16K/bhO+vHspsfCindSinfHI26hLVnsoc7+heXwE4
         +iapbE6iBuhgoU7Zg7r3O9WcDt6zBNUkCG57BaAEP98/Kad4VYe/QFk1iMoReRdcba0u
         F4DE8IvDojXhsOxIytauA+eHMmEOX2zw8m7C95AUQVnPj617f1lhqPIJ4yEIL+5GzUAm
         5b/g==
X-Gm-Message-State: AOAM531XJqaz/4nqeEEL7+kFi1LwCWTYOlaBkc4YvILG1JugHTFePjB9
        zqiJISYgkEXrxodHYdB5aICkiZIxPtkqVZZ8D5NCFw==
X-Google-Smtp-Source: ABdhPJxvw7MG98Kz//EoDUdSzcc6b/D5vC/cEBw/t27aqaXIfQ9RmL8/XVJNF4P+GbeKyZxqfAHuxcjjjRAADsLoc4mbgQ==
X-Received: from mustash.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:337b])
 (user=richardsonnick job=sendgmr) by 2002:a05:6214:29cb:: with SMTP id
 gh11mr29980502qvb.55.1628622127104; Tue, 10 Aug 2021 12:02:07 -0700 (PDT)
Date:   Tue, 10 Aug 2021 19:01:53 +0000
In-Reply-To: <20210810190159.4103778-1-richardsonnick@google.com>
Message-Id: <20210810190159.4103778-2-richardsonnick@google.com>
Mime-Version: 1.0
References: <20210810190159.4103778-1-richardsonnick@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v2 1/3] pktgen: Parse internet mix (imix) input
From:   Nicholas Richardson <richardsonnick@google.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     nrrichar@ncsu.edu, promanov@google.com, arunkaly@google.com,
        Nick Richardson <richardsonnick@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Leesoo Ahn <dev@ooseel.net>, Ye Bin <yebin10@huawei.com>,
        Di Zhu <zhudi21@huawei.com>,
        Yejune Deng <yejune.deng@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Richardson <richardsonnick@google.com>

Adds "imix_weights" command for specifying internet mix distribution.

The command is in this format:
"imix_weights size_1,weight_1 size_2,weight_2 ... size_n,weight_n"
where the probability that packet size_i is picked is:
weight_i / (weight_1 + weight_2 + .. + weight_n)

The user may provide up to 100 imix entries (size_i,weight_i) in this
command.

The user specified imix entries will be displayed in the "Params"
section of the interface output.

Values for clone_skb > 0 is not supported in IMIX mode.

Summary of changes:
Add flag for enabling internet mix mode.
Add command (imix_weights) for internet mix input.
Return -ENOTSUPP when clone_skb > 0 in IMIX mode.
Display imix_weights in Params.
Create data structures to store imix entries and distribution.

Signed-off-by: Nick Richardson <richardsonnick@google.com>
---
 net/core/pktgen.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 7e258d255e90..a7e45eaccef7 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -175,6 +175,8 @@
 #define IP_NAME_SZ 32
 #define MAX_MPLS_LABELS 16 /* This is the max label stack depth */
 #define MPLS_STACK_BOTTOM htonl(0x00000100)
+/* Max number of internet mix entries that can be specified in imix_weights. */
+#define MAX_IMIX_ENTRIES 20
 
 #define func_enter() pr_debug("entering %s\n", __func__);
 
@@ -242,6 +244,12 @@ static char *pkt_flag_names[] = {
 #define VLAN_TAG_SIZE(x) ((x)->vlan_id == 0xffff ? 0 : 4)
 #define SVLAN_TAG_SIZE(x) ((x)->svlan_id == 0xffff ? 0 : 4)
 
+struct imix_pkt {
+	u64 size;
+	u64 weight;
+	u64 count_so_far;
+};
+
 struct flow_state {
 	__be32 cur_daddr;
 	int count;
@@ -343,6 +351,10 @@ struct pktgen_dev {
 	__u8 traffic_class;  /* ditto for the (former) Traffic Class in IPv6
 				(see RFC 3260, sec. 4) */
 
+	/* IMIX */
+	unsigned int n_imix_entries;
+	struct imix_pkt imix_entries[MAX_IMIX_ENTRIES];
+
 	/* MPLS */
 	unsigned int nr_labels;	/* Depth of stack, 0 = no MPLS */
 	__be32 labels[MAX_MPLS_LABELS];
@@ -552,6 +564,16 @@ static int pktgen_if_show(struct seq_file *seq, void *v)
 		   (unsigned long long)pkt_dev->count, pkt_dev->min_pkt_size,
 		   pkt_dev->max_pkt_size);
 
+	if (pkt_dev->n_imix_entries > 0) {
+		seq_puts(seq, "     imix_weights: ");
+		for (i = 0; i < pkt_dev->n_imix_entries; i++) {
+			seq_printf(seq, "%llu,%llu ",
+				   pkt_dev->imix_entries[i].size,
+				   pkt_dev->imix_entries[i].weight);
+		}
+		seq_puts(seq, "\n");
+	}
+
 	seq_printf(seq,
 		   "     frags: %d  delay: %llu  clone_skb: %d  ifname: %s\n",
 		   pkt_dev->nfrags, (unsigned long long) pkt_dev->delay,
@@ -792,6 +814,62 @@ static int strn_len(const char __user * user_buffer, unsigned int maxlen)
 	return i;
 }
 
+/* Parses imix entries from user buffer.
+ * The user buffer should consist of imix entries separated by spaces
+ * where each entry consists of size and weight delimited by commas.
+ * "size1,weight_1 size2,weight_2 ... size_n,weight_n" for example.
+ */
+static ssize_t get_imix_entries(const char __user *buffer,
+				struct pktgen_dev *pkt_dev)
+{
+	const int max_digits = 10;
+	int i = 0;
+	long len;
+	char c;
+
+	pkt_dev->n_imix_entries = 0;
+
+	do {
+		unsigned long weight;
+		unsigned long size;
+
+		len = num_arg(&buffer[i], max_digits, &size);
+		if (len < 0)
+			return len;
+		i += len;
+		if (get_user(c, &buffer[i]))
+			return -EFAULT;
+		/* Check for comma between size_i and weight_i */
+		if (c != ',')
+			return -EINVAL;
+		i++;
+
+		if (size < 14 + 20 + 8)
+			size = 14 + 20 + 8;
+
+		len = num_arg(&buffer[i], max_digits, &weight);
+		if (len < 0)
+			return len;
+		if (weight <= 0)
+			return -EINVAL;
+
+		pkt_dev->imix_entries[pkt_dev->n_imix_entries].size = size;
+		pkt_dev->imix_entries[pkt_dev->n_imix_entries].weight = weight;
+
+		i += len;
+		if (get_user(c, &buffer[i]))
+			return -EFAULT;
+
+		i++;
+		pkt_dev->n_imix_entries++;
+
+		if (pkt_dev->n_imix_entries > MAX_IMIX_ENTRIES)
+			return -E2BIG;
+	} while (c == ' ');
+
+	return i;
+}
+
 static ssize_t get_labels(const char __user *buffer, struct pktgen_dev *pkt_dev)
 {
 	unsigned int n = 0;
@@ -960,6 +1038,18 @@ static ssize_t pktgen_if_write(struct file *file,
 		return count;
 	}
 
+	if (!strcmp(name, "imix_weights")) {
+		if (pkt_dev->clone_skb > 0)
+			return -EINVAL;
+
+		len = get_imix_entries(&user_buffer[i], pkt_dev);
+		if (len < 0)
+			return len;
+
+		i += len;
+		return count;
+	}
+
 	if (!strcmp(name, "debug")) {
 		len = num_arg(&user_buffer[i], 10, &value);
 		if (len < 0)
@@ -1082,10 +1172,16 @@ static ssize_t pktgen_if_write(struct file *file,
 		len = num_arg(&user_buffer[i], 10, &value);
 		if (len < 0)
 			return len;
+		/* clone_skb is not supported for netif_receive xmit_mode and
+		 * IMIX mode.
+		 */
 		if ((value > 0) &&
 		    ((pkt_dev->xmit_mode == M_NETIF_RECEIVE) ||
 		     !(pkt_dev->odev->priv_flags & IFF_TX_SKB_SHARING)))
 			return -ENOTSUPP;
+		if (value > 0 && pkt_dev->n_imix_entries > 0)
+			return -EINVAL;
+
 		i += len;
 		pkt_dev->clone_skb = value;
 
-- 
2.32.0.605.g8dce9f2422-goog

