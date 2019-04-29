Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69996ED25
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 01:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbfD2XEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 19:04:52 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41715 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729603AbfD2XEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 19:04:50 -0400
Received: by mail-io1-f68.google.com with SMTP id r10so10520226ioc.8
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 16:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3ehiZ3qC4g9CrzHxpvZLq9Y09Ky2/tSRw0ikjA0r6WQ=;
        b=aUdiw84gOXkbAI6+HzqQthaDrbJxs6DPL+0v5+pYYR/SgaO1ZSZkauXnOIlwgoEnAp
         VYXWb2YWviUhbmTLQQXHSuCVL0qV/RuYH60+/Z2eO0LBG0TnVuoYDV5eoRKbLacd44Dl
         YX0nhsRoLjnhLuQDqnL0EflmGfcLHjXvRWi5gstEhlUKulW8OLBfCf/cNBYaBbY9JDZs
         rj5nVNfLbX+2PnsHuutRHPn/sawZ3t+49AzWdhhDWIhNjB2syZRTbTSB5mq+/Sp2AjsI
         cSRRKSpr6/IA9gzoFP7LRL0b1DEJENeetrqyakqMbmpNNGRhUpwENITegkTg/dRExwyH
         g5fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3ehiZ3qC4g9CrzHxpvZLq9Y09Ky2/tSRw0ikjA0r6WQ=;
        b=oVwUybnwHtuDbffW0udRnJf0CjSYcwPAge3g3/SCyinQOyaCoXFDMPPy9WJiBMh0oX
         cLL5bK7elJLj7H58Fp3KDDwcCU0A9WTdZaOjaXrbMc75IpV4B45befENZU3FV7akZIu/
         o+lQ+fFJC+9glyANE8imwz9AXSuKmGYtmbNku3CVtVdli2KOd204BBAlxunC92ELhM+8
         X+0m5e9954evqXGrf/zfP/5MnuPaojVqinfxj+UM2P6hpmG9NP18oKIhg8dqeBHJ1JZm
         aJN4MnqqGk/HFb5EthZVrC2hfoSBQ5Cq2VO3JejGgOP2hQWOHON1PNr4kJtlCaPq5HwW
         o0eA==
X-Gm-Message-State: APjAAAVuaGKsLXKaUbyramN/RjQP0vdFPYAb174EAx7pOTWtPsYIWM1Q
        +Clono5d1a490P7KvJVLjkdveg==
X-Google-Smtp-Source: APXvYqzgJVssrDVAQjVfY6ugONt2RWg+qYai+LznLM2o1fRe/l9EahDRRMr/TcB/hh17whqhaxRiuQ==
X-Received: by 2002:a5d:84cc:: with SMTP id z12mr44588281ior.305.1556579089604;
        Mon, 29 Apr 2019 16:04:49 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id y62sm340626itg.13.2019.04.29.16.04.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 16:04:49 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v8 net-next 2/8] exthdrs: Registration of TLV handlers and parameters
Date:   Mon, 29 Apr 2019 16:04:17 -0700
Message-Id: <1556579063-1367-3-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556579063-1367-1-git-send-email-tom@quantonium.net>
References: <1556579063-1367-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/net/ipv6.h         |  60 +++++++++-
 include/uapi/linux/in6.h   |  10 ++
 net/ipv6/exthdrs.c         |  52 +++++----
 net/ipv6/exthdrs_common.c  | 278 +++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/exthdrs_options.c |  62 ++++++----
 5 files changed, 415 insertions(+), 47 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index e36c2c1..bb667ed 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -386,13 +386,63 @@ struct ipv6_txoptions *ipv6_fixup_options(struct ipv6_txoptions *opt_space,
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
+struct tlv_params {
+	unsigned char rx_class : 3;
+};
+
+struct tlv_proc {
+	struct tlv_ops ops;
+	struct tlv_params params;
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
+	struct tlv_proc procs[0];
+};
+
+struct tlv_param_table {
+	struct tlv_param_table_data __rcu *data;
+};
+
+extern struct tlv_param_table ipv6_tlv_param_table;
+
+int tlv_set_proc(struct tlv_param_table *tlv_param_table,
+		 unsigned char type, const struct tlv_proc *proc);
+int tlv_unset_proc(struct tlv_param_table *tlv_param_table, unsigned char type);
+int tlv_set_params(struct tlv_param_table *tlv_param_table,
+		   unsigned char type, const struct tlv_params *params);
+int tlv_unset_params(struct tlv_param_table *tlv_param_table,
+		     unsigned char type);
+
+int exthdrs_init(struct tlv_param_table *tlv_param_table,
+		 const struct tlv_proc_init *init_params,
+		 int num_init_params);
+void exthdrs_fini(struct tlv_param_table *tlv_param_table);
+
+int ipv6_exthdrs_options_init(void);
+void ipv6_exthdrs_options_exit(void);
+
+/* tlv_get_proc assumes rcu_read_lock is held */
+static inline struct tlv_proc *tlv_get_proc(
+		struct tlv_param_table *tlv_param_table,
+		unsigned int type)
+{
+	struct tlv_param_table_data *tpt =
+				rcu_dereference(tlv_param_table->data);
+
+	return &tpt->procs[tpt->entries[type]];
+}
 
 bool ipv6_opt_accepted(const struct sock *sk, const struct sk_buff *skb,
 		       const struct inet6_skb_parm *opt);
diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
index 9f2273a..8b9ac7f 100644
--- a/include/uapi/linux/in6.h
+++ b/include/uapi/linux/in6.h
@@ -297,4 +297,14 @@ struct in6_flowlabel_req {
  * ...
  * MRT6_MAX
  */
+
+/* Flags for EH type that can use a TLV option */
+#define IPV6_TLV_CLASS_FLAG_HOPOPT	BIT(0)
+#define IPV6_TLV_CLASS_FLAG_RTRDSTOPT	BIT(1)
+#define IPV6_TLV_CLASS_FLAG_DSTOPT	BIT(2)
+#define IPV6_TLV_CLASS_MAX		((1 << 3) - 1)
+
+#define IPV6_TLV_CLASS_ANY_DSTOPT      (IPV6_TLV_CLASS_FLAG_RTRDSTOPT | \
+					IPV6_TLV_CLASS_FLAG_DSTOPT)
+
 #endif /* _UAPI_LINUX_IN6_H */
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 6dbacf1..71a12a7 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -100,15 +100,14 @@ static bool ip6_tlvopt_unknown(struct sk_buff *skb, int optoff,
 
 /* Parse tlv encoded option header (hop-by-hop or destination) */
 
-static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
-			  struct sk_buff *skb,
+static bool ip6_parse_tlv(unsigned int class, struct sk_buff *skb,
 			  int max_count)
 {
 	int len = (skb_transport_header(skb)[1] + 1) << 3;
 	const unsigned char *nh = skb_network_header(skb);
 	int off = skb_network_header_len(skb);
-	const struct tlvtype_proc *curr;
 	bool disallow_unknowns = false;
+	const struct tlv_proc *curr;
 	int tlv_count = 0;
 	int padlen = 0;
 
@@ -117,12 +116,16 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 		max_count = -max_count;
 	}
 
-	if (skb_transport_offset(skb) + len > skb_headlen(skb))
-		goto bad;
+	if (skb_transport_offset(skb) + len > skb_headlen(skb)) {
+		kfree_skb(skb);
+		return false;
+	}
 
 	off += 2;
 	len -= 2;
 
+	rcu_read_lock();
+
 	while (len > 0) {
 		int optlen = nh[off + 1] + 2;
 		int i;
@@ -162,19 +165,18 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 			if (tlv_count > max_count)
 				goto bad;
 
-			for (curr = procs; curr->type >= 0; curr++) {
-				if (curr->type == nh[off]) {
-					/* type specific length/alignment
-					   checks will be performed in the
-					   func(). */
-					if (curr->func(skb, off) == false)
-						return false;
-					break;
-				}
+			curr = tlv_get_proc(&ipv6_tlv_param_table, nh[off]);
+			if ((curr->params.rx_class & class) && curr->ops.func) {
+				/* Handler will apply additional checks to
+				 * the TLV
+				 */
+				if (!curr->ops.func(class, skb, off))
+					goto bad_nofree;
+			} else if (!ip6_tlvopt_unknown(skb, off,
+						       disallow_unknowns)) {
+				/* No appropriate handler, TLV is unknown */
+				goto bad_nofree;
 			}
-			if (curr->type < 0 &&
-			    !ip6_tlvopt_unknown(skb, off, disallow_unknowns))
-				return false;
 
 			padlen = 0;
 			break;
@@ -183,10 +185,14 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 		len -= optlen;
 	}
 
-	if (len == 0)
+	if (len == 0) {
+		rcu_read_unlock();
 		return true;
+	}
 bad:
 	kfree_skb(skb);
+bad_nofree:
+	rcu_read_unlock();
 	return false;
 }
 
@@ -220,7 +226,7 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 	dstbuf = opt->dst1;
 #endif
 
-	if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
+	if (ip6_parse_tlv(IPV6_TLV_CLASS_FLAG_DSTOPT, skb,
 			  init_net.ipv6.sysctl.max_dst_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
@@ -602,8 +608,13 @@ int __init ipv6_exthdrs_init(void)
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
@@ -613,6 +624,7 @@ int __init ipv6_exthdrs_init(void)
 
 void ipv6_exthdrs_exit(void)
 {
+	ipv6_exthdrs_options_exit();
 	inet6_del_protocol(&nodata_protocol, IPPROTO_NONE);
 	inet6_del_protocol(&destopt_protocol, IPPROTO_DSTOPTS);
 	inet6_del_protocol(&rthdr_protocol, IPPROTO_ROUTING);
@@ -643,7 +655,7 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
 		goto fail_and_free;
 
 	opt->flags |= IP6SKB_HOPBYHOP;
-	if (ip6_parse_tlv(tlvprochopopt_lst, skb,
+	if (ip6_parse_tlv(IPV6_TLV_CLASS_FLAG_HOPOPT, skb,
 			  init_net.ipv6.sysctl.max_hbh_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
index 179861c..0c0e32d 100644
--- a/net/ipv6/exthdrs_common.c
+++ b/net/ipv6/exthdrs_common.c
@@ -142,3 +142,281 @@ struct ipv6_txoptions *ipv6_fixup_options(struct ipv6_txoptions *opt_space,
 	return opt;
 }
 EXPORT_SYMBOL_GPL(ipv6_fixup_options);
+
+/* TLV parameter table functions and structures */
+
+static void tlv_param_table_release(struct rcu_head *rcu)
+{
+	struct tlv_param_table_data *tpt =
+	    container_of(rcu, struct tlv_param_table_data, rcu);
+
+	kvfree(tpt);
+}
+
+/* Default (unset) values for TLV parameters */
+static const struct tlv_proc tlv_default_proc = {
+};
+
+static size_t tlv_param_table_size(unsigned char count)
+{
+	return sizeof(struct tlv_param_table_data) +
+	    (count * sizeof(struct tlv_proc));
+}
+
+static DEFINE_MUTEX(tlv_mutex);
+
+/* mutex held */
+static int __tlv_set_proc(struct tlv_param_table *tlv_param_table,
+			  unsigned char type, const struct tlv_ops *ops,
+			  const struct tlv_params *params)
+{
+	struct tlv_param_table_data *tpt, *old;
+	struct tlv_proc *tproc;
+	unsigned char count, pos;
+
+	old = rcu_dereference_protected(tlv_param_table->data,
+					lockdep_is_held(&tlv_mutex));
+
+	if (old->entries[type]) {
+		/* Type is already set, modifying entry */
+		pos = old->entries[type];
+		count = old->count;
+
+		/* If ops is not provided, take them from existing proc */
+		if (!ops)
+			ops = &old->procs[pos].ops;
+	} else {
+		/* Type entry unset, need to create new entry */
+		pos = old->count;
+		count = pos + 1;
+	}
+
+	tpt = kvmalloc(tlv_param_table_size(count), GFP_KERNEL);
+	if (!tpt)
+		return -ENOMEM;
+
+	memcpy(tpt, old, tlv_param_table_size(old->count));
+
+	tproc = &tpt->procs[pos];
+	tproc->params = *params;
+	tproc->ops = ops ? *ops : tlv_default_proc.ops;
+
+	tpt->entries[type] = pos;
+	tpt->count = count;
+
+	rcu_assign_pointer(tlv_param_table->data, tpt);
+
+	call_rcu(&old->rcu, tlv_param_table_release);
+
+	return 0;
+}
+
+/* mutex held */
+static int __tlv_unset_proc(struct tlv_param_table *tlv_param_table,
+			    unsigned char type)
+{
+	struct tlv_param_table_data *tpt, *old;
+	unsigned char pos;
+	int i;
+
+	old = rcu_dereference_protected(tlv_param_table->data,
+					lockdep_is_held(&tlv_mutex));
+
+	if (!old->entries[type]) {
+		/* Type entry already unset, nothing to do */
+		return 0;
+	}
+
+	tpt = kvmalloc(tlv_param_table_size(old->count - 1), GFP_KERNEL);
+	if (!tpt)
+		return -ENOMEM;
+
+	pos = old->entries[type];
+
+	memcpy(tpt->procs, old->procs, pos * sizeof(struct tlv_proc));
+	memcpy(&tpt->procs[pos], &old->procs[pos + 1],
+	       (old->count - pos - 1) * sizeof(struct tlv_proc));
+
+	for (i = 0; i < 256; i++) {
+		if (old->entries[i] > pos)
+			tpt->entries[i] = old->entries[i] - 1;
+		else
+			tpt->entries[i] = old->entries[i];
+	}
+
+	/* Clear entry for type being unset (point to default params) */
+	tpt->entries[type] = 0;
+
+	tpt->count = old->count - 1;
+
+	rcu_assign_pointer(tlv_param_table->data, tpt);
+
+	call_rcu(&old->rcu, tlv_param_table_release);
+
+	return 0;
+}
+
+static void __tlv_destroy_param_table(struct tlv_param_table *tlv_param_table)
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
+int tlv_set_proc(struct tlv_param_table *tlv_param_table, unsigned char type,
+		 const struct tlv_proc *proc)
+{
+	int ret;
+
+	if (type < 2)
+		return -EINVAL;
+
+	mutex_lock(&tlv_mutex);
+	ret = __tlv_set_proc(tlv_param_table, type, &proc->ops,
+			     &proc->params);
+	mutex_unlock(&tlv_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(tlv_set_proc);
+
+int tlv_unset_proc(struct tlv_param_table *tlv_param_table,
+		   unsigned char type)
+{
+	int ret;
+
+	if (type < 2)
+		return -EINVAL;
+
+	mutex_lock(&tlv_mutex);
+	ret = __tlv_unset_proc(tlv_param_table, type);
+	mutex_unlock(&tlv_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(tlv_unset_proc);
+
+int tlv_set_params(struct tlv_param_table *tlv_param_table,
+		   unsigned char type, const struct tlv_params *params)
+{
+	int ret;
+
+	if (type < 2)
+		return -EINVAL;
+
+	mutex_lock(&tlv_mutex);
+	ret = __tlv_set_proc(tlv_param_table, type, NULL, params);
+	mutex_unlock(&tlv_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(tlv_set_params);
+
+/* tlv_internal_proc_type is used to check it the TLV proc was set
+ * internally. This is deduced by checking if any operations are
+ * defined.
+ */
+static bool tlv_internal_proc_type(struct tlv_proc *proc)
+{
+	return !!proc->ops.func;
+}
+
+int tlv_unset_params(struct tlv_param_table *tlv_param_table,
+		     unsigned char type)
+{
+	struct tlv_param_table_data *tpt;
+	struct tlv_proc *proc;
+	int entry, ret = 0;
+
+	mutex_lock(&tlv_mutex);
+
+	tpt = rcu_dereference_protected(tlv_param_table->data,
+					lockdep_is_held(&tlv_mutex));
+	if (!tpt)
+		goto out;
+
+	entry = tpt->entries[type];
+	if (!entry) {
+		/* Entry is already unset */
+		goto out;
+	}
+
+	proc = &tpt->procs[entry];
+
+	if (tlv_internal_proc_type(proc)) {
+		/* TLV was set by internal source, so maintain
+		 * the non-parameter fields (i.e. the operations).
+		 */
+		ret = __tlv_set_proc(tlv_param_table, type, &proc->ops,
+				     &tlv_default_proc.params);
+	} else {
+		ret = __tlv_unset_proc(tlv_param_table, type);
+	}
+
+out:
+	mutex_unlock(&tlv_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(tlv_unset_params);
+
+int exthdrs_init(struct tlv_param_table *tlv_param_table,
+		 const struct tlv_proc_init *tlv_init_params,
+		 int num_init_params)
+{
+	struct tlv_param_table_data *tpt;
+	size_t tsize;
+	int i;
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
+	tpt->procs[0] = tlv_default_proc;
+
+	for (i = 0; i < num_init_params; i++) {
+		const struct tlv_proc_init *tpi = &tlv_init_params[i];
+		struct tlv_proc *tp = &tpt->procs[i + 1];
+
+		if (WARN_ON(tpi->type < 2)) {
+			 /* Padding TLV initialized? */
+			kvfree(tpt);
+			return -EINVAL;
+		}
+		if (WARN_ON(tpt->entries[tpi->type])) {
+			/* TLV type already set */
+			kvfree(tpt);
+			return -EINVAL;
+		}
+
+		*tp = tpi->proc;
+		tpt->entries[tpi->type] = i + 1;
+	}
+
+	tpt->count = num_init_params + 1;
+
+	RCU_INIT_POINTER(tlv_param_table->data, tpt);
+
+	return 0;
+}
+EXPORT_SYMBOL(exthdrs_init);
+
+void exthdrs_fini(struct tlv_param_table *tlv_param_table)
+{
+	__tlv_destroy_param_table(tlv_param_table);
+}
+EXPORT_SYMBOL(exthdrs_fini);
diff --git a/net/ipv6/exthdrs_options.c b/net/ipv6/exthdrs_options.c
index 032e072..eb3ae2a 100644
--- a/net/ipv6/exthdrs_options.c
+++ b/net/ipv6/exthdrs_options.c
@@ -15,7 +15,7 @@
 /* Destination options header */
 
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
-static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
+static bool ipv6_dest_hao(unsigned int class, struct sk_buff *skb, int optoff)
 {
 	struct ipv6_destopt_hao *hao;
 	struct inet6_skb_parm *opt = IP6CB(skb);
@@ -74,16 +74,6 @@ static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
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
@@ -102,7 +92,7 @@ static inline struct net *ipv6_skb_net(struct sk_buff *skb)
 
 /* Router Alert as of RFC 2711 */
 
-static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
+static bool ipv6_hop_ra(unsigned int class, struct sk_buff *skb, int optoff)
 {
 	const unsigned char *nh = skb_network_header(skb);
 
@@ -120,7 +110,7 @@ static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
 
 /* Jumbo payload */
 
-static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
+static bool ipv6_hop_jumbo(unsigned int class, struct sk_buff *skb, int optoff)
 {
 	const unsigned char *nh = skb_network_header(skb);
 	struct inet6_dev *idev = __in6_dev_get_safely(skb->dev);
@@ -164,7 +154,8 @@ static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
 
 /* CALIPSO RFC 5570 */
 
-static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
+static bool ipv6_hop_calipso(unsigned int class, struct sk_buff *skb,
+			     int optoff)
 {
 	const unsigned char *nh = skb_network_header(skb);
 
@@ -184,18 +175,45 @@ static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
 	return false;
 }
 
-const struct tlvtype_proc tlvprochopopt_lst[] = {
+static const struct tlv_proc_init tlv_init_params[] __initconst = {
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
 	{
-		.type	= IPV6_TLV_ROUTERALERT,
-		.func	= ipv6_hop_ra,
+		.type = IPV6_TLV_HAO,
+
+		.proc.ops.func = ipv6_dest_hao,
+		.proc.params.rx_class = IPV6_TLV_CLASS_FLAG_DSTOPT,
 	},
+#endif
 	{
-		.type	= IPV6_TLV_JUMBO,
-		.func	= ipv6_hop_jumbo,
+		.type = IPV6_TLV_ROUTERALERT,
+
+		.proc.ops.func = ipv6_hop_ra,
+		.proc.params.rx_class = IPV6_TLV_CLASS_FLAG_HOPOPT,
 	},
 	{
-		.type	= IPV6_TLV_CALIPSO,
-		.func	= ipv6_hop_calipso,
+		.type = IPV6_TLV_JUMBO,
+
+		.proc.ops.func	= ipv6_hop_jumbo,
+		.proc.params.rx_class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+	},
+	{
+		.type = IPV6_TLV_CALIPSO,
+
+		.proc.ops.func = ipv6_hop_calipso,
+		.proc.params.rx_class = IPV6_TLV_CLASS_FLAG_HOPOPT,
 	},
-	{ -1, }
 };
+
+struct tlv_param_table __rcu ipv6_tlv_param_table;
+EXPORT_SYMBOL(ipv6_tlv_param_table);
+
+int __init ipv6_exthdrs_options_init(void)
+{
+	return exthdrs_init(&ipv6_tlv_param_table, tlv_init_params,
+			    ARRAY_SIZE(tlv_init_params));
+}
+
+void ipv6_exthdrs_options_exit(void)
+{
+	exthdrs_fini(&ipv6_tlv_param_table);
+}
-- 
2.7.4

