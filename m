Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1ADCB19B
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733162AbfJCV6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:58:43 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37662 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfJCV6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:58:42 -0400
Received: by mail-pg1-f195.google.com with SMTP id p1so769111pgi.4
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 14:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZXaHRK5tNfYJxJE5z6skP2lwJDvsVTrOUi+z4zSSC94=;
        b=ducWEbcPFxFNi90pDLuESPqHygZMEt3HXdRpwl5RelAhYSo+fNBRY+zPciFPlC3fNh
         iIpC+q0sdnPOYvhbfi9ddv65R3/eX9LcP7Vu5cKqvFv/JM5hXXtu+TXxq7sFsxxUuKfB
         xYhRzNrTxYQ4tXoH+Sja9xrpi4BUXuBp8h58Ytp2TbtB8e2KICzKWq57GKf/nBsQg/ip
         rUcgsSvNe1FRJ6CCA3PG0AKHNbi3vOsXjtr8idAMnu1RFxzZ9uEJJJxyI5SfkJeSxr2x
         S/7PuKLWLQiIdgciypPdakToR4VWUuSPmiGzkiOVhnGrot2Bh4ZCgzRoGNeGS89HeTg7
         QCug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZXaHRK5tNfYJxJE5z6skP2lwJDvsVTrOUi+z4zSSC94=;
        b=A+GRG4DKkqMHWz72pRD356nknmsnR0XAhZ2JUsDpTJiv9S9jRaOQ2ehsGPvu2+kYOZ
         mD0eco4vvGMAJ0b7d9u31pYKjLcGGHBA3XYF0XvafFqj+Tadeem3viKYqGB5Cg7lx74H
         tql+ob2geMF+Bx8h41wA9P/b5P0azusqv89qxdlgskUI5H0Txc9NHZgqcE2P0mqHRfxw
         lDWL1qbKv5NCL3f8NC5Qtf2ZeX/s00X9sMVhystFlAzY6j2Zn1jJD9xewCGY2umCDV7R
         0JdCWxJf2ZpaxtNZYJSXOMUZVa10Jz80PJqMjHrDbiaMxuS1gT7QLt9bp8E+rgNMRM6l
         N+Ng==
X-Gm-Message-State: APjAAAWKm5BcuSidPqoCdRxk4FpRFF8quzQIEgpUnCFfx9ZiePH7EL09
        Ilyy/Lq8g+qZfesb2xugBFXtnIK+reJdZA==
X-Google-Smtp-Source: APXvYqzaO6szK6kGGGnPSL+eWIr9Zexg7h45TXr7gWBfMCn+HDrd4dgloPYOWCi5z+Nv0tBO8SugiA==
X-Received: by 2002:aa7:96ab:: with SMTP id g11mr13644196pfk.61.1570139922050;
        Thu, 03 Oct 2019 14:58:42 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id r18sm3889905pfc.3.2019.10.03.14.58.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 03 Oct 2019 14:58:41 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>, Tom Herbert <tom@herbertland.com>
Subject: [PATCH v5 net-next 5/7] ip6tlvs: Add TX parameters
Date:   Thu,  3 Oct 2019 14:58:02 -0700
Message-Id: <1570139884-20183-6-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570139884-20183-1-git-send-email-tom@herbertland.com>
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@quantonium.net>

Define a number of transmit parameters for TLV Parameter table
definitions. These will be used for validating TLVs that are set
on a socket.

Signed-off-by: Tom Herbert <tom@herbertland.com>
---
 include/net/ipeh.h         | 18 ++++++++++++++++
 include/uapi/linux/ipeh.h  |  8 +++++++
 net/ipv6/exthdrs_common.c  | 53 +++++++++++++++++++++++++++++++++++++++++++++-
 net/ipv6/exthdrs_options.c | 45 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/include/net/ipeh.h b/include/net/ipeh.h
index aaa2910..de6d9d0 100644
--- a/include/net/ipeh.h
+++ b/include/net/ipeh.h
@@ -20,6 +20,17 @@ struct tlv_rx_params {
 };
 
 struct tlv_tx_params {
+	unsigned char admin_perm : 2;
+	unsigned char user_perm : 2;
+	unsigned char class : 3;
+	unsigned char rsvd : 1;
+	unsigned char align_mult : 4;
+	unsigned char align_off : 4;
+	unsigned char data_len_mult : 4;
+	unsigned char data_len_off : 4;
+	unsigned char min_data_len;
+	unsigned char max_data_len;
+	unsigned short preferred_order;
 };
 
 struct tlv_params {
@@ -54,6 +65,13 @@ struct tlv_param_table {
 
 extern struct tlv_param_table ipv6_tlv_param_table;
 
+/* Preferred TLV ordering for HBH and Dest options (placed by increasing order)
+ */
+#define IPEH_TLV_PREF_ORDER_HAO			10
+#define IPEH_TLV_PREF_ORDER_ROUTERALERT		20
+#define IPEH_TLV_PREF_ORDER_JUMBO		30
+#define IPEH_TLV_PREF_ORDER_CALIPSO		40
+
 int __ipeh_tlv_set(struct tlv_param_table *tlv_param_table,
 		   unsigned char type, const struct tlv_params *params,
 		   const struct tlv_ops *ops);
diff --git a/include/uapi/linux/ipeh.h b/include/uapi/linux/ipeh.h
index c4302b7..dbf0728 100644
--- a/include/uapi/linux/ipeh.h
+++ b/include/uapi/linux/ipeh.h
@@ -13,4 +13,12 @@
 				  IPEH_TLV_CLASS_FLAG_RTRDSTOPT |	\
 				  IPEH_TLV_CLASS_FLAG_DSTOPT)
 
+/* TLV permissions values */
+enum {
+	IPEH_TLV_PERM_NONE,
+	IPEH_TLV_PERM_WITH_CHECK,
+	IPEH_TLV_PERM_NO_CHECK,
+	IPEH_TLV_PERM_MAX = IPEH_TLV_PERM_NO_CHECK
+};
+
 #endif /* _UAPI_LINUX_IPEH_H */
diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
index 43737fc..feaa4a6 100644
--- a/net/ipv6/exthdrs_common.c
+++ b/net/ipv6/exthdrs_common.c
@@ -3,6 +3,7 @@
 /* Extension header and TLV library code that is not specific to IPv6. */
 #include <linux/export.h>
 #include <net/ipv6.h>
+#include <uapi/linux/ipeh.h>
 
 struct ipv6_txoptions *
 ipeh_dup_options(struct sock *sk, struct ipv6_txoptions *opt)
@@ -265,6 +266,13 @@ EXPORT_SYMBOL(ipeh_parse_tlv);
 
 /* Default (unset) values for TLV parameters */
 static const struct tlv_proc tlv_default_proc = {
+	.params.t = {
+		.admin_perm = IPEH_TLV_PERM_NO_CHECK,
+		.user_perm = IPEH_TLV_PERM_NONE,
+		.align_mult = (4 - 1), /* Default alignment: 4n + 2 */
+		.align_off = 2,
+		.max_data_len = 255,
+	},
 };
 
 static DEFINE_MUTEX(tlv_mutex);
@@ -284,16 +292,45 @@ static void tlv_param_table_release(struct rcu_head *rcu)
 }
 
 /* mutex held */
+static int check_order(struct tlv_param_table_data *tpt, unsigned char type,
+		       unsigned short order)
+{
+	int i;
+
+	if (!order)
+		return -EINVAL;
+
+	for (i = 2; i < 256; i++) {
+		struct tlv_type *ttype = &tpt->types[tpt->entries[i]];
+
+		if (!tpt->entries[i])
+			continue;
+
+		if (order == ttype->proc.params.t.preferred_order &&
+		    i != type)
+			return -EALREADY;
+	}
+
+	return 0;
+}
+
+/* mutex held */
 static int __tlv_set_one(struct tlv_param_table *tlv_param_table,
 			 unsigned char type, const struct tlv_params *params,
 			 const struct tlv_ops *ops)
 {
 	struct tlv_param_table_data *tpt, *told;
 	struct tlv_type *ttype;
+	int retv;
 
 	told = rcu_dereference_protected(tlv_param_table->data,
 					 lockdep_is_held(&tlv_mutex));
 
+	/* Check preferred order */
+	retv = check_order(told, type, params->t.preferred_order);
+	if (retv)
+		return retv;
+
 	/* Create new TLV table. If there is no exsiting entry then we are
 	 * adding a new one to the table, else we're modifying an entry.
 	 */
@@ -422,7 +459,7 @@ int ipeh_exthdrs_init(struct tlv_param_table *tlv_param_table,
 		      int num_init_params)
 {
 	struct tlv_param_table_data *tpt;
-	int pos = 0, i;
+	int pos = 0, i, j;
 	size_t tsize;
 
 	tsize = tlv_param_table_size(num_init_params + 1);
@@ -448,6 +485,20 @@ int ipeh_exthdrs_init(struct tlv_param_table *tlv_param_table,
 			goto err_inval;
 		}
 
+		if (WARN_ON(!tpi->proc.params.t.preferred_order)) {
+			/* Preferred order must be non-zero */
+			goto err_inval;
+		}
+
+		for (j = 0; j < i; j++) {
+			const struct tlv_proc_init *tpix = &tlv_init_params[j];
+
+			if (WARN_ON(tpi->proc.params.t.preferred_order ==
+				    tpix->proc.params.t.preferred_order)) {
+				/* Preferred order must be unique */
+				goto err_inval;
+			}
+		}
 		tpt->types[pos].proc = tpi->proc;
 		tpt->entries[tpi->type] = pos;
 	}
diff --git a/net/ipv6/exthdrs_options.c b/net/ipv6/exthdrs_options.c
index d4b373e..3b50b58 100644
--- a/net/ipv6/exthdrs_options.c
+++ b/net/ipv6/exthdrs_options.c
@@ -183,6 +183,17 @@ static const struct tlv_proc_init tlv_ipv6_init_params[] __initconst = {
 
 		.proc.ops.func = ipv6_dest_hao,
 		.proc.params.r.class = IPEH_TLV_CLASS_FLAG_DSTOPT,
+
+		.proc.params.t = {
+			.preferred_order = IPEH_TLV_PREF_ORDER_HAO,
+			.admin_perm = IPEH_TLV_PERM_NO_CHECK,
+			.user_perm = IPEH_TLV_PERM_NONE,
+			.class = IPEH_TLV_CLASS_FLAG_DSTOPT,
+			.align_mult = (8 - 1), /* Align to 8n + 6 */
+			.align_off = 6,
+			.min_data_len = 16,
+			.max_data_len = 16,
+		},
 	},
 #endif
 	{
@@ -190,18 +201,52 @@ static const struct tlv_proc_init tlv_ipv6_init_params[] __initconst = {
 
 		.proc.ops.func = ipv6_hop_ra,
 		.proc.params.r.class = IPEH_TLV_CLASS_FLAG_HOPOPT,
+
+		.proc.params.t = {
+			.preferred_order = IPEH_TLV_PREF_ORDER_ROUTERALERT,
+			.admin_perm = IPEH_TLV_PERM_NO_CHECK,
+			.user_perm = IPEH_TLV_PERM_NONE,
+			.class = IPEH_TLV_CLASS_FLAG_HOPOPT,
+			.align_mult = (2 - 1), /* Align to 2n */
+			.min_data_len = 2,
+			.max_data_len = 2,
+		},
 	},
 	{
 		.type = IPV6_TLV_JUMBO,
 
 		.proc.ops.func	= ipv6_hop_jumbo,
 		.proc.params.r.class = IPEH_TLV_CLASS_FLAG_HOPOPT,
+
+		.proc.params.t = {
+			.preferred_order = IPEH_TLV_PREF_ORDER_JUMBO,
+			.admin_perm = IPEH_TLV_PERM_NO_CHECK,
+			.user_perm = IPEH_TLV_PERM_NONE,
+			.class = IPEH_TLV_CLASS_FLAG_HOPOPT,
+			.align_mult = (4 - 1), /* Align to 4n + 2 */
+			.align_off = 2,
+			.min_data_len = 4,
+			.max_data_len = 4,
+		},
 	},
 	{
 		.type = IPV6_TLV_CALIPSO,
 
 		.proc.ops.func = ipv6_hop_calipso,
 		.proc.params.r.class = IPEH_TLV_CLASS_FLAG_HOPOPT,
+
+		.proc.params.t = {
+			.preferred_order = IPEH_TLV_PREF_ORDER_CALIPSO,
+			.admin_perm = IPEH_TLV_PERM_NO_CHECK,
+			.user_perm = IPEH_TLV_PERM_NONE,
+			.class = IPEH_TLV_CLASS_FLAG_HOPOPT,
+			.align_mult = (4 - 1), /* Align to 4n + 2 */
+			.align_off = 2,
+			.min_data_len = 8,
+			.max_data_len = 252,
+			.data_len_mult = (4 - 1),
+					/* Length is multiple of 4 */
+		},
 	},
 };
 
-- 
2.7.4

