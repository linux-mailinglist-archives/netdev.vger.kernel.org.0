Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5D83E4AB7
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhHIRXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbhHIRXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 13:23:10 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44195C061796
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 10:22:50 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id bo13-20020a05621414adb029035561c68664so1554763qvb.1
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 10:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QwrfZsIk88oMsovuf2STnfHeCrOpCXzBnuvpUniP9TM=;
        b=PkfHMzJBwtBjchRZGKOSU/nApQzOUrWrOfcKhVrGk1p5Iur7Abzpxr3uUdGQo9+U4O
         FbHyeP5RWRLU9i4ovkJgRIVnTT1Y8VqcvhtfPglC8vl02gY9gdcajB0IjfngApwJAxph
         V8h2cU4xmE0bFEWUftWz1raA9S8DWp5toc3dPeRH1v0bUYd6fG1Kh9XpoJ64/yHwKQnn
         C73Cedv65jJOMmlHnV4HcJlI4D9uyAfcBwMgmWfKpKYq47lDBR1t8fhhDKm200p+RHdq
         jYTnlFOc+fpitY2lRbRTO8x0I5gRBpaV33KHouXfa4slD78l5AWc51wgKxyQy6BrIlXH
         XyrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QwrfZsIk88oMsovuf2STnfHeCrOpCXzBnuvpUniP9TM=;
        b=ZXXYqO0bosyt2p3uzrWjlaRAbej3P9xYwO8Emu1d1GyQPlPK0IYeGWVDsy9TenMLXA
         V+3q6r88CcvKSeG1sBvX3eo2p9GLhhS8F6yPibKQrhuMQxQUejwGxC/eyO1+wyDNbSU8
         3zVQl0h/rLGKx6CYydEk4XUlWhKIPUuRqUzXDZMxlrqcIwOeSNhwwNN0/LZrvavywiUU
         UQszCGeJ8ujI9B+Qpyf7nY5jU7ZzzGWk2UV5AIjyfFu1VpEb8Ir6e85r14hbTEm+JNSA
         OqrJc1VgB9FiE9bcoqeAjs/Nw0BEOe143qd9k9mjrpWhi1p7u3L+kSegn/ynC4HcLjBP
         S7RA==
X-Gm-Message-State: AOAM531XYGDFYCciSXR/Jg9l8iVTPpO8nYxWcupzjvstX2dQ95Jewvj2
        OuOw6tPMAtLcXNzBJF3L0eE1fr0MFoEQoRyWuMFRFA==
X-Google-Smtp-Source: ABdhPJyqBiB+Xe0U35ea5UVQ8j0Tl5Vzuc/Mc17NrvKHfEs2m0+b7JJHvTxfB1WYB8S1rIATC1aO3utVD4hO3bcRZuuXsg==
X-Received: from mustash.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:337b])
 (user=richardsonnick job=sendgmr) by 2002:a0c:d990:: with SMTP id
 y16mr7048149qvj.29.1628529769412; Mon, 09 Aug 2021 10:22:49 -0700 (PDT)
Date:   Mon,  9 Aug 2021 17:22:02 +0000
In-Reply-To: <20210809172207.3890697-1-richardsonnick@google.com>
Message-Id: <20210809172207.3890697-2-richardsonnick@google.com>
Mime-Version: 1.0
References: <20210809172207.3890697-1-richardsonnick@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH 1/3] pktgen: Parse internet mix (imix) input
From:   Nicholas Richardson <richardsonnick@google.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     nrrichar@ncsu.edu, arunkaly@google.com,
        Nick Richardson <richardsonnick@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Yejune Deng <yejune.deng@gmail.com>,
        Di Zhu <zhudi21@huawei.com>, Ye Bin <yebin10@huawei.com>,
        Leesoo Ahn <dev@ooseel.net>, netdev@vger.kernel.org,
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

The user may provide up to 20 imix entries (size_i,weight_i) in this
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
 net/core/pktgen.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 7e258d255e90..83c83e1b5f28 100644
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
+	__u64 size;
+	__u64 weight;
+	__u64 count_so_far;
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
+		seq_printf(seq, "     imix_weights: ");
+		for (i = 0; i < pkt_dev->n_imix_entries; i++) {
+			seq_printf(seq, "%llu,%llu ",
+				   pkt_dev->imix_entries[i].size,
+				   pkt_dev->imix_entries[i].weight);
+		}
+		seq_printf(seq, "\n");
+	}
+
 	seq_printf(seq,
 		   "     frags: %d  delay: %llu  clone_skb: %d  ifname: %s\n",
 		   pkt_dev->nfrags, (unsigned long long) pkt_dev->delay,
@@ -792,6 +814,61 @@ static int strn_len(const char __user * user_buffer, unsigned int maxlen)
 	return i;
 }
 
+static ssize_t get_imix_entries(const char __user *buffer,
+				struct pktgen_dev *pkt_dev)
+{
+	/* Parses imix entries from user buffer.
+	 * The user buffer should consist of imix entries separated by spaces
+	 * where each entry consists of size and weight delimited by commas.
+	 * "size1,weight_1 size2,weight_2 ... size_n,weight_n" for example.
+	 */
+	long len;
+	char c;
+	int i = 0;
+	const int max_digits = 10;
+
+	pkt_dev->n_imix_entries = 0;
+
+	do {
+		unsigned long size;
+		unsigned long weight;
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
+	return i;
+}
+
 static ssize_t get_labels(const char __user *buffer, struct pktgen_dev *pkt_dev)
 {
 	unsigned int n = 0;
@@ -960,6 +1037,18 @@ static ssize_t pktgen_if_write(struct file *file,
 		return count;
 	}
 
+	if (!strcmp(name, "imix_weights")) {
+		if (pkt_dev->clone_skb > 0)
+			return -ENOTSUPP;
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
@@ -1082,10 +1171,16 @@ static ssize_t pktgen_if_write(struct file *file,
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
+			return -ENOTSUPP;
+
 		i += len;
 		pkt_dev->clone_skb = value;
 
-- 
2.32.0.605.g8dce9f2422-goog

