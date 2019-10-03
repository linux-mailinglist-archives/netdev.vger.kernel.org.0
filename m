Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E29CB19A
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733075AbfJCV6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:58:41 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35939 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfJCV6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:58:40 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so2605641pfr.3
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 14:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Tq9AauF2LOPybyzaNFtTFk0EFI1sy3r+evVGRCFCNI4=;
        b=C/8QZWbQ6HxlyTjRPuFZV2kHr7kqLVPlqoF8m0lw5Sq9W7neyn6f3txPwUuXjdaWWf
         nwVXOdN/J0NHOMLTAtqID2UaqrdQrZ2w1SO2WsKiSwKzV8xqZMO2x85Jo8DZJGUB9py3
         uR+F3RshsjzwKY0wH+HU9LztDNod+/TSnvqnLs4NUso1scoDdfjvBTQvvbi4ki0sjdX9
         k+9Ll2azAF/iMj3vePJN86S/QcF4kvuQgBbpxd0SGjhJz9dI9PBEnz2h4Zm0lVZbhQLH
         Wb1v+nDkNA4cjUhLcXI/Qs3PE7cxgk1yibvM1jJd3jHVNk8SDkEH42Kf9Z55Xq0lXgn4
         OlRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Tq9AauF2LOPybyzaNFtTFk0EFI1sy3r+evVGRCFCNI4=;
        b=sWrvc7WV/BYOshkxUJeQEEcoPL9np8SLlD5tMqd6P3dqJpSlfdWln9iVY/38C1S33H
         SnGSslaqfhFR3jLPhV4JoUzrdQDxYUT9zy7MY4osCF7W5QrOfYhj7KcyO9oWKtkhhm/t
         L/SjTcPoUxEdsIuzEmydUYeC/7kyTYv3lotV8yVVLKQ3YVEwtFsa9fgnf4YPpDeKEYZG
         CA1O4wp0hDc/OcyzW0U86yzNVwVGC9LQlmIHSWwB4HPqeBbiCx9UNtCSRWB2DT6l3QUj
         VRFF7aqRyMnYdaZGphKM+EecRP15rhBsBm4RSq1gR4qEvVqlzHO4LoPcWdTcYOQr/1CQ
         JUcQ==
X-Gm-Message-State: APjAAAXU3UH6kYrgFhIfZL0cljj4v7wfAGREcdvUOu/tewChaIa4qQU0
        PVacOsN9Kts/GabIbUKaG5gDDA==
X-Google-Smtp-Source: APXvYqzKShh9zjKFFk/DV/7Z/xeWy50jFPnlWUHTtydPerorU0ILvNBLKEsW5U3U2rSK7DKt89eEUA==
X-Received: by 2002:aa7:9a92:: with SMTP id w18mr13849989pfi.244.1570139919860;
        Thu, 03 Oct 2019 14:58:39 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id r18sm3889905pfc.3.2019.10.03.14.58.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 03 Oct 2019 14:58:39 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>, Tom Herbert <tom@herbertland.com>
Subject: [PATCH v5 net-next 4/7] ip6tlvs: Registration of TLV handlers and parameters
Date:   Thu,  3 Oct 2019 14:58:01 -0700
Message-Id: <1570139884-20183-5-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570139884-20183-1-git-send-email-tom@herbertland.com>
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@quantonium.net>

Create a single TLV parameter table that holds meta information for IPv6
Hop-by-Hop and Destination TLVs. The data structure is composed of a 256
element array of u8's (one entry for each TLV type to allow O(1)
lookup). Each entry provides an offset into an array of TLV proc data
structures which follows the array of u8s. The TLV proc data structure
contains parameters and handler functions for receiving and transmitting
TLVs. The zeroth element in the TLV proc array provides default
parameters for TLVs.

A class attribute indicates the type of extension header in which the
TLV may be used (e.g. Hop-by-Hop options, Destination options, or
Destination options before the routing header).

Functions are defined to manipulate entries in the TLV parameter table.

* tlv_{set|unset}_proc set a TLV proc entry (ops and parameters)
* tlv_{set|unset}_params set parameters only

Receive TLV lookup and processing is modified to be a lookup in the TLV
parameter table. An init table containing parameters for TLVs supported
by the kernel is used to initialize the TLV table.

Signed-off-by: Tom Herbert <tom@herbertland.com>
---
 include/net/ipeh.h         | 107 ++++++++++++++++--
 include/net/ipv6.h         |   3 +
 include/uapi/linux/ipeh.h  |  16 +++
 net/ipv6/exthdrs.c         |  14 ++-
 net/ipv6/exthdrs_common.c  | 271 +++++++++++++++++++++++++++++++++++++++++----
 net/ipv6/exthdrs_options.c |  63 +++++++----
 6 files changed, 421 insertions(+), 53 deletions(-)
 create mode 100644 include/uapi/linux/ipeh.h

diff --git a/include/net/ipeh.h b/include/net/ipeh.h
index c1aa7b6..aaa2910 100644
--- a/include/net/ipeh.h
+++ b/include/net/ipeh.h
@@ -11,13 +11,105 @@
  *     and false, if it failed.
  *     It MUST NOT touch skb->h.
  */
-struct tlvtype_proc {
-	int	type;
-	bool	(*func)(struct sk_buff *skb, int offset);
+struct tlv_ops {
+	bool	(*func)(unsigned int class, struct sk_buff *skb, int offset);
 };
 
-extern const struct tlvtype_proc tlvprocdestopt_lst[];
-extern const struct tlvtype_proc tlvprochopopt_lst[];
+struct tlv_rx_params {
+	unsigned char class : 4;
+};
+
+struct tlv_tx_params {
+};
+
+struct tlv_params {
+	struct tlv_rx_params r;
+	struct tlv_tx_params t;
+};
+
+struct tlv_proc {
+	struct tlv_ops ops;
+	struct tlv_params params;
+};
+
+struct tlv_type {
+	struct tlv_proc proc;
+};
+
+struct tlv_proc_init {
+	int type;
+	struct tlv_proc proc;
+};
+
+struct tlv_param_table_data {
+	unsigned char entries[256];
+	unsigned char count;
+	struct rcu_head rcu;
+	struct tlv_type types[0];
+};
+
+struct tlv_param_table {
+	struct tlv_param_table_data __rcu *data;
+};
+
+extern struct tlv_param_table ipv6_tlv_param_table;
+
+int __ipeh_tlv_set(struct tlv_param_table *tlv_param_table,
+		   unsigned char type, const struct tlv_params *params,
+		   const struct tlv_ops *ops);
+
+static inline int ipeh_tlv_set_params(struct tlv_param_table *tlv_param_table,
+				      unsigned char type,
+				      const struct tlv_params *params)
+{
+	return __ipeh_tlv_set(tlv_param_table, type, params, NULL);
+}
+
+static inline int ipeh_tlv_set_proc(struct tlv_param_table *tlv_param_table,
+			       unsigned char type,
+			       const struct tlv_proc *proc)
+{
+	return __ipeh_tlv_set(tlv_param_table, type,
+			      &proc->params, &proc->ops);
+}
+
+int __ipeh_tlv_unset(struct tlv_param_table *tlv_param_table,
+		     unsigned char type, bool params_only);
+
+static inline int ipeh_tlv_unset_params(struct tlv_param_table *tlv_param_table,
+					unsigned char type)
+{
+	return __ipeh_tlv_unset(tlv_param_table, type, true);
+}
+
+static inline int ipeh_tlv_unset_proc(struct tlv_param_table *tlv_param_table,
+				      unsigned char type)
+{
+	return __ipeh_tlv_unset(tlv_param_table, type, false);
+}
+
+/* ipeh_tlv_get_proc_by_type assumes rcu_read_lock is held */
+static inline struct tlv_proc *ipeh_tlv_get_proc_by_type(
+		struct tlv_param_table *tlv_param_table, unsigned char type)
+{
+	struct tlv_param_table_data *tpt =
+				rcu_dereference(tlv_param_table->data);
+
+	return &tpt->types[tpt->entries[type]].proc;
+}
+
+/* ipeh_tlv_get_proc assumes rcu_read_lock is held */
+static inline struct tlv_proc *ipeh_tlv_get_proc(
+		struct tlv_param_table *tlv_param_table,
+		const __u8 *tlv)
+{
+	return ipeh_tlv_get_proc_by_type(tlv_param_table, tlv[0]);
+}
+
+int ipeh_exthdrs_init(struct tlv_param_table *tlv_param_table,
+		      const struct tlv_proc_init *init_params,
+		      int num_init_params);
+void ipeh_exthdrs_fini(struct tlv_param_table *tlv_param_table);
 
 struct ipv6_txoptions;
 struct ipv6_opt_hdr;
@@ -51,8 +143,9 @@ enum ipeh_parse_errors {
 #define IPEH_TLV_PAD1	0
 #define IPEH_TLV_PADN	1
 
-bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
-		    int max_count, int off, int len,
+bool ipeh_parse_tlv(unsigned int class,
+		    struct tlv_param_table *tlv_param_table,
+		    struct sk_buff *skb, int max_count, int off, int len,
 		    bool (*parse_error)(struct sk_buff *skb,
 					int off, enum ipeh_parse_errors error));
 
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index d34c36c..7cefdf8 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -429,6 +429,9 @@ int ip6_ra_control(struct sock *sk, int sel);
 
 int ipv6_parse_hopopts(struct sk_buff *skb);
 
+int ipv6_exthdrs_options_init(void);
+void ipv6_exthdrs_options_exit(void);
+
 bool ipv6_opt_accepted(const struct sock *sk, const struct sk_buff *skb,
 		       const struct inet6_skb_parm *opt);
 struct ipv6_txoptions *ipv6_update_options(struct sock *sk,
diff --git a/include/uapi/linux/ipeh.h b/include/uapi/linux/ipeh.h
new file mode 100644
index 0000000..c4302b7
--- /dev/null
+++ b/include/uapi/linux/ipeh.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* ipeh.h - IP extension header TLV management */
+
+#ifndef _UAPI_LINUX_IPEH_H
+#define _UAPI_LINUX_IPEH_H
+
+/* Flags for EH type that can use a TLV option */
+#define IPEH_TLV_CLASS_FLAG_HOPOPT	BIT(0)
+#define IPEH_TLV_CLASS_FLAG_RTRDSTOPT	BIT(1)
+#define IPEH_TLV_CLASS_FLAG_DSTOPT	BIT(2)
+
+#define IPEH_TLV_CLASS_FLAG_MASK (IPEH_TLV_CLASS_FLAG_HOPOPT |		\
+				  IPEH_TLV_CLASS_FLAG_RTRDSTOPT |	\
+				  IPEH_TLV_CLASS_FLAG_DSTOPT)
+
+#endif /* _UAPI_LINUX_IPEH_H */
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 939d27c..0847d49 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -47,6 +47,7 @@
 #ifdef CONFIG_IPV6_SEG6_HMAC
 #include <net/seg6_hmac.h>
 #endif
+#include <uapi/linux/ipeh.h>
 
 #include <linux/uaccess.h>
 
@@ -131,7 +132,8 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 	dstbuf = opt->dst1;
 #endif
 
-	if (ipeh_parse_tlv(tlvprocdestopt_lst, skb,
+	if (ipeh_parse_tlv(IPEH_TLV_CLASS_FLAG_DSTOPT,
+			   &ipv6_tlv_param_table, skb,
 			   init_net.ipv6.sysctl.max_dst_opts_cnt,
 			   2, extlen - 2, ipv6_parse_error)) {
 		skb->transport_header += extlen;
@@ -514,8 +516,13 @@ int __init ipv6_exthdrs_init(void)
 	if (ret)
 		goto out_destopt;
 
+	ret = ipv6_exthdrs_options_init();
+	if (ret)
+		goto out_nodata;
 out:
 	return ret;
+out_nodata:
+	inet6_del_protocol(&nodata_protocol, IPPROTO_NONE);
 out_destopt:
 	inet6_del_protocol(&destopt_protocol, IPPROTO_DSTOPTS);
 out_rthdr:
@@ -525,6 +532,7 @@ int __init ipv6_exthdrs_init(void)
 
 void ipv6_exthdrs_exit(void)
 {
+	ipv6_exthdrs_options_exit();
 	inet6_del_protocol(&nodata_protocol, IPPROTO_NONE);
 	inet6_del_protocol(&destopt_protocol, IPPROTO_DSTOPTS);
 	inet6_del_protocol(&rthdr_protocol, IPPROTO_ROUTING);
@@ -555,8 +563,8 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
 		goto fail_and_free;
 
 	opt->flags |= IP6SKB_HOPBYHOP;
-	if (ipeh_parse_tlv(tlvprochopopt_lst, skb,
-			   init_net.ipv6.sysctl.max_hbh_opts_cnt,
+	if (ipeh_parse_tlv(IPEH_TLV_CLASS_FLAG_HOPOPT, &ipv6_tlv_param_table,
+			   skb, init_net.ipv6.sysctl.max_hbh_opts_cnt,
 			   2, extlen - 2, ipv6_parse_error)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
index 99a0911..43737fc 100644
--- a/net/ipv6/exthdrs_common.c
+++ b/net/ipv6/exthdrs_common.c
@@ -150,14 +150,15 @@ EXPORT_SYMBOL_GPL(ipeh_fixup_options);
  *   - off is offset from skb_transport_header where first TLV is
  *   - len is length of TLV block
  */
-bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
-		    int max_count, int off, int len,
+bool ipeh_parse_tlv(unsigned int class,
+		    struct tlv_param_table *tlv_param_table,
+		    struct sk_buff *skb, int max_count, int off, int len,
 		    bool (*parse_error)(struct sk_buff *skb,
 					int off, enum ipeh_parse_errors error))
 {
 	const unsigned char *nh = skb_network_header(skb);
-	const struct tlvtype_proc *curr;
 	bool disallow_unknowns = false;
+	const struct tlv_proc *curr;
 	int tlv_count = 0;
 	int padlen = 0;
 
@@ -168,8 +169,10 @@ bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
 
 	if (skb_transport_offset(skb) + off + len > skb_headlen(skb)) {
 		if (!parse_error(skb, skb_transport_offset(skb),
-				 IPEH_PARSE_ERR_EH_TOOBIG))
-			goto bad;
+				 IPEH_PARSE_ERR_EH_TOOBIG)) {
+			kfree_skb(skb);
+			return false;
+		}
 
 		len = skb_headlen(skb) - skb_transport_offset(skb) - off;
 	}
@@ -177,6 +180,8 @@ bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
 	/* ops function based offset on network header */
 	off += skb_network_header_len(skb);
 
+	rcu_read_lock();
+
 	while (len > 0) {
 		int optlen = nh[off + 1] + 2;
 		int i;
@@ -221,26 +226,22 @@ bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
 
 			tlv_count++;
 			if (tlv_count > max_count &&
-			    parse_error(skb, off, IPEH_PARSE_ERR_OPT_TOOMANY))
+			    !parse_error(skb, off, IPEH_PARSE_ERR_OPT_TOOMANY))
 				goto bad;
 
-			for (curr = procs; curr->type >= 0; curr++) {
-				if (curr->type == nh[off]) {
-					/* type specific length/alignment
-					 * checks will be performed in the
-					 * func().
-					 */
-					if (curr->func(skb, off) == false)
-						return false;
-					break;
-				}
-			}
-			if (curr->type < 0 &&
-			    !parse_error(skb, off,
+			curr = ipeh_tlv_get_proc(tlv_param_table, &nh[off]);
+			if ((curr->params.r.class & class) && curr->ops.func) {
+				/* Handler will apply additional checks to
+				 * the TLV
+				 */
+				if (!curr->ops.func(class, skb, off))
+					return false;
+			} else if (!parse_error(skb, off,
 					 disallow_unknowns ?
 						IPEH_PARSE_ERR_OPT_UNK_DISALW :
-						IPEH_PARSE_ERR_OPT_UNK))
+						IPEH_PARSE_ERR_OPT_UNK)) {
 				goto bad;
+			}
 
 			padlen = 0;
 			break;
@@ -249,10 +250,238 @@ bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
 		len -= optlen;
 	}
 
-	if (len == 0)
+	if (len == 0) {
+		rcu_read_unlock();
 		return true;
+	}
 bad:
+	rcu_read_unlock();
 	kfree_skb(skb);
 	return false;
 }
 EXPORT_SYMBOL(ipeh_parse_tlv);
+
+/* TLV parameter table functions and structures */
+
+/* Default (unset) values for TLV parameters */
+static const struct tlv_proc tlv_default_proc = {
+};
+
+static DEFINE_MUTEX(tlv_mutex);
+
+static size_t tlv_param_table_size(unsigned char count)
+{
+	return sizeof(struct tlv_param_table_data) +
+	    (count * sizeof(struct tlv_type));
+}
+
+static void tlv_param_table_release(struct rcu_head *rcu)
+{
+	struct tlv_param_table_data *tpt =
+	    container_of(rcu, struct tlv_param_table_data, rcu);
+
+	kvfree(tpt);
+}
+
+/* mutex held */
+static int __tlv_set_one(struct tlv_param_table *tlv_param_table,
+			 unsigned char type, const struct tlv_params *params,
+			 const struct tlv_ops *ops)
+{
+	struct tlv_param_table_data *tpt, *told;
+	struct tlv_type *ttype;
+
+	told = rcu_dereference_protected(tlv_param_table->data,
+					 lockdep_is_held(&tlv_mutex));
+
+	/* Create new TLV table. If there is no exsiting entry then we are
+	 * adding a new one to the table, else we're modifying an entry.
+	 */
+	tpt = kvmalloc(tlv_param_table_size(told->count + !told->entries[type]),
+		       GFP_KERNEL);
+	if (!tpt)
+		return -ENOMEM;
+
+	memcpy(tpt, told, tlv_param_table_size(told->count));
+
+	if (!told->entries[type]) {
+		memset(&tpt->types[told->count], 0, sizeof(struct tlv_type));
+		tpt->entries[type] = told->count;
+		tpt->count = told->count + 1;
+	}
+
+	ttype = &tpt->types[tpt->entries[type]];
+
+	ttype->proc.params = *params;
+	ttype->proc.ops = ops ? *ops : tlv_default_proc.ops;
+
+	rcu_assign_pointer(tlv_param_table->data, tpt);
+	call_rcu(&told->rcu, tlv_param_table_release);
+
+	return 0;
+}
+
+int __ipeh_tlv_set(struct tlv_param_table *tlv_param_table, unsigned char type,
+		   const struct tlv_params *params, const struct tlv_ops *ops)
+{
+	int retv;
+
+	if (type < 2)
+		return -EINVAL;
+
+	mutex_lock(&tlv_mutex);
+	retv = __tlv_set_one(tlv_param_table, type, params, ops);
+	mutex_unlock(&tlv_mutex);
+
+	return retv;
+}
+EXPORT_SYMBOL(__ipeh_tlv_set);
+
+/* mutex held */
+static int __tlv_unset_one(struct tlv_param_table *tlv_param_table,
+			   unsigned char type)
+{
+	struct tlv_param_table_data *tpt, *told;
+	unsigned int i, pos;
+
+	told = rcu_dereference_protected(tlv_param_table->data,
+					 lockdep_is_held(&tlv_mutex));
+
+	if (!told->entries[type])
+		return 0;
+
+	tpt = kvmalloc(tlv_param_table_size(told->count - 1),
+		       GFP_KERNEL);
+	if (!tpt)
+		return -ENOMEM;
+
+	pos = told->entries[type];
+
+	memcpy(tpt->types, told->types, pos * sizeof(struct tlv_type));
+	memcpy(&tpt->types[pos], &told->types[pos + 1],
+	       (told->count - pos - 1) * sizeof(struct tlv_type));
+
+	for (i = 0; i < 256; i++) {
+		if (told->entries[i] > pos)
+			tpt->entries[i] = told->entries[i] - 1;
+		else
+			tpt->entries[i] = told->entries[i];
+	}
+
+	/* Clear entry for type being unset (point to default params) */
+	tpt->entries[type] = 0;
+
+	tpt->count = told->count - 1;
+
+	rcu_assign_pointer(tlv_param_table->data, tpt);
+	call_rcu(&told->rcu, tlv_param_table_release);
+
+	return 0;
+}
+
+/* tlv_internal_proc_type is used to check it the TLV proc was set
+ * internally. This is deduced by checking if any operations are defined.
+ */
+static bool tlv_internal_proc_type(struct tlv_proc *proc)
+{
+	return !!proc->ops.func;
+}
+
+int __ipeh_tlv_unset(struct tlv_param_table *tlv_param_table,
+		     unsigned char type, bool params_only)
+{
+	struct tlv_proc *tproc;
+	int retv;
+
+	if (type < 2)
+		return -EINVAL;
+
+	mutex_lock(&tlv_mutex);
+
+	tproc = ipeh_tlv_get_proc_by_type(tlv_param_table, type);
+
+	if (params_only && tlv_internal_proc_type(tproc)) {
+		/* TLV was set by internal source, so maintain the
+		 * non-parameter fields (i.e. the operations).
+		 */
+		retv = __tlv_set_one(tlv_param_table, type,
+				     &tlv_default_proc.params,
+				     &tproc->ops);
+	} else {
+		retv = __tlv_unset_one(tlv_param_table, type);
+	}
+
+	mutex_unlock(&tlv_mutex);
+
+	return retv;
+}
+EXPORT_SYMBOL(__ipeh_tlv_unset);
+
+int ipeh_exthdrs_init(struct tlv_param_table *tlv_param_table,
+		      const struct tlv_proc_init *tlv_init_params,
+		      int num_init_params)
+{
+	struct tlv_param_table_data *tpt;
+	int pos = 0, i;
+	size_t tsize;
+
+	tsize = tlv_param_table_size(num_init_params + 1);
+
+	tpt = kvmalloc(tsize, GFP_KERNEL);
+	if (!tpt)
+		return -ENOMEM;
+
+	memset(tpt, 0, tsize);
+
+	/* Zeroth TLV proc entry is default */
+	tpt->types[pos++].proc = tlv_default_proc;
+
+	for (i = 0; i < num_init_params; i++, pos++) {
+		const struct tlv_proc_init *tpi = &tlv_init_params[i];
+
+		if (WARN_ON(tpi->type < 2)) {
+			 /* Padding TLV initialized? */
+			goto err_inval;
+		}
+		if (WARN_ON(tpt->entries[tpi->type])) {
+			/* TLV type already set */
+			goto err_inval;
+		}
+
+		tpt->types[pos].proc = tpi->proc;
+		tpt->entries[tpi->type] = pos;
+	}
+
+	tpt->count = pos;
+
+	RCU_INIT_POINTER(tlv_param_table->data, tpt);
+
+	return 0;
+
+err_inval:
+	kvfree(tpt);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(ipeh_exthdrs_init);
+
+static void tlv_destroy_param_table(struct tlv_param_table *tlv_param_table)
+{
+	struct tlv_param_table_data *tpt;
+
+	mutex_lock(&tlv_mutex);
+
+	tpt = rcu_dereference_protected(tlv_param_table->data,
+					lockdep_is_held(&tlv_mutex));
+	if (tpt) {
+		rcu_assign_pointer(tlv_param_table->data, NULL);
+		call_rcu(&tpt->rcu, tlv_param_table_release);
+	}
+
+	mutex_unlock(&tlv_mutex);
+}
+
+void ipeh_exthdrs_fini(struct tlv_param_table *tlv_param_table)
+{
+	tlv_destroy_param_table(tlv_param_table);
+}
+EXPORT_SYMBOL(ipeh_exthdrs_fini);
diff --git a/net/ipv6/exthdrs_options.c b/net/ipv6/exthdrs_options.c
index 032e072..d4b373e 100644
--- a/net/ipv6/exthdrs_options.c
+++ b/net/ipv6/exthdrs_options.c
@@ -11,11 +11,12 @@
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
 #include <net/xfrm.h>
 #endif
+#include <uapi/linux/ipeh.h>
 
 /* Destination options header */
 
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
-static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
+static bool ipv6_dest_hao(unsigned int class, struct sk_buff *skb, int optoff)
 {
 	struct ipv6_destopt_hao *hao;
 	struct inet6_skb_parm *opt = IP6CB(skb);
@@ -74,16 +75,6 @@ static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
 }
 #endif
 
-const struct tlvtype_proc tlvprocdestopt_lst[] = {
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-	{
-		.type	= IPV6_TLV_HAO,
-		.func	= ipv6_dest_hao,
-	},
-#endif
-	{-1,			NULL}
-};
-
 /* Hop-by-hop options */
 
 /* Note: we cannot rely on skb_dst(skb) before we assign it in
@@ -102,7 +93,7 @@ static inline struct net *ipv6_skb_net(struct sk_buff *skb)
 
 /* Router Alert as of RFC 2711 */
 
-static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
+static bool ipv6_hop_ra(unsigned int class, struct sk_buff *skb, int optoff)
 {
 	const unsigned char *nh = skb_network_header(skb);
 
@@ -120,7 +111,7 @@ static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
 
 /* Jumbo payload */
 
-static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
+static bool ipv6_hop_jumbo(unsigned int class, struct sk_buff *skb, int optoff)
 {
 	const unsigned char *nh = skb_network_header(skb);
 	struct inet6_dev *idev = __in6_dev_get_safely(skb->dev);
@@ -164,7 +155,8 @@ static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
 
 /* CALIPSO RFC 5570 */
 
-static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
+static bool ipv6_hop_calipso(unsigned int class, struct sk_buff *skb,
+			     int optoff)
 {
 	const unsigned char *nh = skb_network_header(skb);
 
@@ -184,18 +176,45 @@ static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
 	return false;
 }
 
-const struct tlvtype_proc tlvprochopopt_lst[] = {
+static const struct tlv_proc_init tlv_ipv6_init_params[] __initconst = {
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
 	{
-		.type	= IPV6_TLV_ROUTERALERT,
-		.func	= ipv6_hop_ra,
+		.type = IPV6_TLV_HAO,
+
+		.proc.ops.func = ipv6_dest_hao,
+		.proc.params.r.class = IPEH_TLV_CLASS_FLAG_DSTOPT,
 	},
+#endif
 	{
-		.type	= IPV6_TLV_JUMBO,
-		.func	= ipv6_hop_jumbo,
+		.type = IPV6_TLV_ROUTERALERT,
+
+		.proc.ops.func = ipv6_hop_ra,
+		.proc.params.r.class = IPEH_TLV_CLASS_FLAG_HOPOPT,
 	},
 	{
-		.type	= IPV6_TLV_CALIPSO,
-		.func	= ipv6_hop_calipso,
+		.type = IPV6_TLV_JUMBO,
+
+		.proc.ops.func	= ipv6_hop_jumbo,
+		.proc.params.r.class = IPEH_TLV_CLASS_FLAG_HOPOPT,
+	},
+	{
+		.type = IPV6_TLV_CALIPSO,
+
+		.proc.ops.func = ipv6_hop_calipso,
+		.proc.params.r.class = IPEH_TLV_CLASS_FLAG_HOPOPT,
 	},
-	{ -1, }
 };
+
+struct tlv_param_table __rcu ipv6_tlv_param_table;
+EXPORT_SYMBOL(ipv6_tlv_param_table);
+
+int __init ipv6_exthdrs_options_init(void)
+{
+	return ipeh_exthdrs_init(&ipv6_tlv_param_table, tlv_ipv6_init_params,
+				 ARRAY_SIZE(tlv_ipv6_init_params));
+}
+
+void ipv6_exthdrs_options_exit(void)
+{
+	ipeh_exthdrs_fini(&ipv6_tlv_param_table);
+}
-- 
2.7.4

