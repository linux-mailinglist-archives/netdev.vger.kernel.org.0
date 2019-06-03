Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1784033B01
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfFCWR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:17:58 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40762 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfFCWR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:17:57 -0400
Received: by mail-qk1-f195.google.com with SMTP id c70so1540471qkg.7
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YUza4PMIs0ohaHfaCK38GWx4cPv8iHbswqEsvRco1eA=;
        b=MuSivQyW61xpdzDOZraR6ieBDvK6uFs3qh9sLaaKiDGBEEgVc9qscktjwKYH1DUOF3
         Mz0Mnu5acPcSG1sokx8Y93R/7Y91WyXiDT59mxZ9smQNFDKw/04+QoZNqrwqDNGBFfqE
         O7DWlkMg84/yqrXu4qh5Rb2Q/90zdMHNrUoBAuwgOvIA+5zKNAHPs4h9AlFn6EytJ8aq
         OQQ2Np0K4O+TG+myTTskt2kx919u6Cj1Ew93Jh0kleYS6BJBtBBbUXLdiXXFM+9hEQtC
         ivJYiIgdqKeyuzutVZ1NpR+nMR9D4jp9OBEG+qGydW0uvq/FNJKW7/xga+eWydOwR6uX
         6t/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YUza4PMIs0ohaHfaCK38GWx4cPv8iHbswqEsvRco1eA=;
        b=YTXaQb/0FwMP+XzyvgBoAonKTzmzU3Vi51zgOHHBrQurivtuepcJl+Z5dDQI/iSIDf
         brqc5toQga50EPrVL0ThRh7sO6jvEBrygNwA+9tvg0WdWnNoUeRQGrB3V4D7oIIjKO/T
         xfQCmuxNM4dluFJUigGE74py6iQkisbe7/jXNeFK4u7PVH1g98hiENDSuEaah6ASPC6E
         X1jjZvM+xy1fcS6DW/IGDs0nq7Gjg6f9nBYc/gSjmvcVbE4JMoQm5/V6RrPCBP5rynrH
         7tH2BONkt2dUTX3F43hbwl+Bke023/IJrED15eb2LORsagm+F/T4NwIRFt+xnMbEXuIR
         6sLA==
X-Gm-Message-State: APjAAAWw9Bv3qImkoZu/t+xZLn+rjPmZl+y+jzQFHly7JdIIDTG4D79/
        Yb3cdDgPgqbM17mEBgRfn6O1cA==
X-Google-Smtp-Source: APXvYqwp1akDzsdV5tGQkN1ti1eKpSUPg+ufxdJ9DtKsmeXtCI7VhHFQp+nNOTmXP8N5e+MaWG5cTg==
X-Received: by 2002:a37:b1c5:: with SMTP id a188mr23745359qkf.51.1559600276438;
        Mon, 03 Jun 2019 15:17:56 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m4sm4332391qka.70.2019.06.03.15.17.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 15:17:55 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 1/8] net/tls: fully initialize the msg wrapper skb
Date:   Mon,  3 Jun 2019 15:16:58 -0700
Message-Id: <20190603221705.12602-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603221705.12602-1-jakub.kicinski@netronome.com>
References: <20190603221705.12602-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If strparser gets cornered into starting a new message from
an sk_buff which already has frags, it will allocate a new
skb to become the "wrapper" around the fragments of the
message.

This new skb does not inherit any metadata fields.  In case
of TLS offload this may lead to unnecessarily re-encrypting
the message, as skb->decrypted is not set for the wrapper skb.

Try to be conservative and copy all fields of old skb
strparser's user may reasonably need.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 include/linux/skbuff.h    |  1 +
 net/core/skbuff.c         | 25 +++++++++++++++++++++++++
 net/strparser/strparser.c |  8 ++------
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2ee5e63195c0..98ff5ac98caa 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1063,6 +1063,7 @@ struct sk_buff *alloc_skb_with_frags(unsigned long header_len,
 				     int max_page_order,
 				     int *errcode,
 				     gfp_t gfp_mask);
+struct sk_buff *alloc_skb_for_msg(struct sk_buff *first);
 
 /* Layout of fast clones : [skb1][skb2][fclone_ref] */
 struct sk_buff_fclones {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4a712a00243a..b50a5e3ac4e4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -913,6 +913,31 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 #undef C
 }
 
+/**
+ * alloc_skb_for_msg() - allocate sk_buff to wrap frag list forming a msg
+ * @first: first sk_buff of the msg
+ */
+struct sk_buff *alloc_skb_for_msg(struct sk_buff *first)
+{
+	struct sk_buff *n;
+
+	n = alloc_skb(0, GFP_ATOMIC);
+	if (!n)
+		return NULL;
+
+	n->len = first->len;
+	n->data_len = first->len;
+	n->truesize = first->truesize;
+
+	skb_shinfo(n)->frag_list = first;
+
+	__copy_skb_header(n, first);
+	n->destructor = NULL;
+
+	return n;
+}
+EXPORT_SYMBOL_GPL(alloc_skb_for_msg);
+
 /**
  *	skb_morph	-	morph one skb into another
  *	@dst: the skb to receive the contents
diff --git a/net/strparser/strparser.c b/net/strparser/strparser.c
index e137698e8aef..3fe541b746b0 100644
--- a/net/strparser/strparser.c
+++ b/net/strparser/strparser.c
@@ -160,18 +160,14 @@ static int __strp_recv(read_descriptor_t *desc, struct sk_buff *orig_skb,
 					return 0;
 				}
 
-				skb = alloc_skb(0, GFP_ATOMIC);
+				skb = alloc_skb_for_msg(head);
 				if (!skb) {
 					STRP_STATS_INCR(strp->stats.mem_fail);
 					desc->error = -ENOMEM;
 					return 0;
 				}
-				skb->len = head->len;
-				skb->data_len = head->len;
-				skb->truesize = head->truesize;
-				*_strp_msg(skb) = *_strp_msg(head);
+
 				strp->skb_nextp = &head->next;
-				skb_shinfo(skb)->frag_list = head;
 				strp->skb_head = skb;
 				head = skb;
 			} else {
-- 
2.21.0

