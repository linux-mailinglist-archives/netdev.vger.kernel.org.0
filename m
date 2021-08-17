Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804E03EF654
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 01:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbhHQXwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 19:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236698AbhHQXwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 19:52:23 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E2BC061796
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 16:51:49 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id f10-20020a0ccc8a0000b02903521ac3b9d7so781067qvl.15
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 16:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1elKTcdW+FvNYbz11By/qdVfUowhJEzra5rUhhk1zhk=;
        b=P3S9cXL+qBnbdV2ynwMVH7DF7JmMk8NfHBFpWXgWCW7xfgpOckV7JoxvB1APGMwRoa
         0bplfkazkfghoF2VYEPx35YSFWVSPg3wEXJEMP/Qzch/m0vHBlAG2GeSSILqtBra1EvP
         zh82D5p0JI8iqYV2E3FAiTY6sE5yiP6owLQ2vZEuajc3gS6MSkQA0NjVzEXAC0BEx5XF
         B6KxRnEqbWh+NSb4JuIG/1tV8jh62VApiiRWjjF3Q26/4zC6hIy+HJz7rvw519iFfOxz
         79S4l+ioqqV1XXC4mZb75omf0F4i7wML/VFRQqRYXUS/nmKNpUwhUzxJwMIFt6xxEx4h
         wSgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1elKTcdW+FvNYbz11By/qdVfUowhJEzra5rUhhk1zhk=;
        b=dxnPr9Za9JQhjXxz6pYCouC3sHA+GguBdKfidiypUm5HRhh97E0k3UbcDiNJt4Cc/m
         lNCiXCnMmVWCJW98RF92pP39dLUXZVF0vvUN6kkp+kpzQVCU0kQ8fSA3eyr7B1fruVpQ
         /ahtq8acE1HwutojFLA/Z/PHHKY50yHzB5dwlLG4OUJVUdmno9MgQiGVS5lJePyLtJeU
         q6I9k37f6CUdalzMdeVjfaBpaHXeId8HYHx3i3g4l58DA2TzvBCjxHAlHdtPwjZmSeRc
         ia6mXSybGH48CsahDvDtMhsxuVcxi1HTclAw5wNif4TpyWdDEDq5r7sbUaocsa9bskun
         CqZg==
X-Gm-Message-State: AOAM532TvGRHIwHSwTobEG4vzN5GoAOuG8x4EbfhaZtuw0U3IcaIl8kC
        xy0/MpWr05vdJiBgQzTos/sLxnBMR1IIoUnEk0InkTJ16VJJ3v7LgmCRaepIqXAXVaswdtfXsvB
        ygk5sgdjVh/0lTXoAR7AIkRo5F5yxksaLfmP+B0OtterBH5wVVVunefzxMTuY4yzOQ25A7mEIib
        eP1Oap1Bo=
X-Google-Smtp-Source: ABdhPJxH76gAGLE97RMZ3CIwsI+hAJDRqD6thgql0QygnAKRv2Ju+C0uEQapyaFfFQR1NXrwnsZSwTuaGzO4g6NuS9ZKgw==
X-Received: from mustash.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:337b])
 (user=richardsonnick job=sendgmr) by 2002:a0c:e70f:: with SMTP id
 d15mr5994177qvn.47.1629244308522; Tue, 17 Aug 2021 16:51:48 -0700 (PDT)
Date:   Tue, 17 Aug 2021 23:51:36 +0000
In-Reply-To: <20210817235141.1136355-1-richardsonnick@google.com>
Message-Id: <20210817235141.1136355-2-richardsonnick@google.com>
Mime-Version: 1.0
References: <20210817235141.1136355-1-richardsonnick@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v3 1/3] pktgen: Parse internet mix (imix) input
From:   Nicholas Richardson <richardsonnick@google.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     nrrichar@ncsu.edu, promanov@google.com, arunkaly@google.com,
        Nick Richardson <richardsonnick@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Yejune Deng <yejune.deng@gmail.com>,
        Leesoo Ahn <dev@ooseel.net>, Ye Bin <yebin10@huawei.com>,
        Di Zhu <zhudi21@huawei.com>, linux-kernel@vger.kernel.org
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
2.33.0.rc1.237.g0d66db33f3-goog

