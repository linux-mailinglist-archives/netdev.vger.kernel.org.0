Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442F712859C
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 00:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfLTXjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 18:39:40 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41121 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfLTXjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 18:39:39 -0500
Received: by mail-pf1-f195.google.com with SMTP id w62so6050936pfw.8
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 15:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RPse04hfQW1AZuc7Y63A7daYLzZOS0dopSNOKrbS55I=;
        b=1qfF0TJ9eQNAKsy6X6u1aDZpwXm4xmTy6wlHbJUwfJ5+k1V1ONI7HeDLiOvwA9gxZY
         eyOSljD+oiK8Ldq3U+bqADtxtSij/m+Y3deF76wHwjvrO7wu76llzkrIJg2pFnyte7Kh
         3QHtaIIwVIEJ85JLjrWKv1CfUhPhQgTfer0XCQb2Nf6lgBKMIHrJ8MhTr4giZZBvBl/W
         ZcDmnLCy/juPXlNGN2yAF7g5DkXOv5uD+fwDnrsV/KlDZ9MLmGxQHy5lywkVzi9R9ZzC
         vigp9UYwIPm8I816O+KqBvWpJyp7jdlG2468SLAao5SJOFUp3sokrt/5rIsGebA4WmBd
         xf2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RPse04hfQW1AZuc7Y63A7daYLzZOS0dopSNOKrbS55I=;
        b=Y+gnqf8hm1hJKYgn3R4GHFVGYD7TIeDeog0OrtBYD0Wj9xBIfNEZ+KJBnItsw5Hl2i
         hk2Ku91K350EE5Pli0s/jfcnWbHabcIRihkjpbS4Y80nWePTnw3jGLYIPLUeyPDiLvzI
         0bEYx6ELywAOiHYy89YCFDSYUqcs3tc77IIw0/lugKadlv2hYMl6ny8yjnKOuY2PPRA2
         P4iomYIGX0TpfZIRnJSPaxBcdRIvDp/BAdBMpYD7B2ps1fhH4AeST238mWAEovncPg7G
         xa/IYFQJUnbfLbi86SlVffThNtCJZilcPfKeaV4RkMuLIKusK8HwAWYBro3psYZk23JL
         P/AA==
X-Gm-Message-State: APjAAAWMKWYDi/0pvsj/rZfG8Bobb3Woz5YuoAg4/FwpxFEUM1QrEPrx
        8C2BpWLymBw+fH/HBTusnmshhA==
X-Google-Smtp-Source: APXvYqxQ7EgmkcfLFIdc9isXX6fyuO7Dv1zJJiYUOD2rGQqiZnR6vO4Y37eUsOuFC22U05z2an33sw==
X-Received: by 2002:a63:a508:: with SMTP id n8mr17106342pgf.278.1576885178484;
        Fri, 20 Dec 2019 15:39:38 -0800 (PST)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id 207sm14833555pfu.88.2019.12.20.15.39.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 15:39:37 -0800 (PST)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        simon.horman@netronome.com
Cc:     Tom Herbert <tom@quantonium.net>, Tom Herbert <tom@herbertland.com>
Subject: [PATCH v6 net-next 7/9] ip6tlvs: Add TX parameters
Date:   Fri, 20 Dec 2019 15:38:42 -0800
Message-Id: <1576885124-14576-8-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576885124-14576-1-git-send-email-tom@herbertland.com>
References: <1576885124-14576-1-git-send-email-tom@herbertland.com>
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
index fc7d543..6f46e2c 100644
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
index c72adb7..414f375a 100644
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

