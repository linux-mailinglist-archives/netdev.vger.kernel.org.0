Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DADBEA6E
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfD2Sqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:46:54 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33923 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729221AbfD2Sqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 14:46:52 -0400
Received: by mail-io1-f65.google.com with SMTP id h26so9939988ioj.1
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 11:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AHgc08vGj5gO19wOJMhXZiLVcnca1zQanVd/UWUqI+Y=;
        b=iRVO9NbegkkY4hZMgY/s2jEWjpOQx/UE8XQlZpCXyDYJABQFoA9gQIdxvidW0bJVyy
         mFdZeOMk4u7aOcu6rLSK4PaWvXMHgGVp1oZEip/FW+/ItwzBvZhIPedtbMfSTVIfGAMx
         jBWqmh200J8ht6LONPTu/rOepSmkwRwS6E6sTG0wlDrF7k2gjsyx40pdNy6aWRPMGzMZ
         DZ0UmP+tG6JyEzolaz1wHAxqgkc5BOuZFQKymPVFX1fBN6mx5G1OQpOHmN2eL1l+rS1T
         LuTpgnR+eml9u30Uz6eE67OZKcYCbmdSXrbqTHz0KR93FAVaXRCKnufIP/Sjn43ytD/i
         jVgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AHgc08vGj5gO19wOJMhXZiLVcnca1zQanVd/UWUqI+Y=;
        b=mD5bdWR9vTm3/HK4P+xHqIKs+g74OfRc27y9by+jMDtL2o2m5H0l6iGTxbPl5cScQ7
         xefuyKJDTRDI1dSqszahLoI/ERxHHcEZ+FVGqlQEG9tYo5qrbD3vQIIIhG5+VD/8nbEJ
         csjcxpClS+zuWCGhItC73S50UoIQ2gmPbltgSvfseh3Z0yREZVjnlfk3wuVAxcNK676k
         Wb00ks72mV2N9v6AaoIJV3gqf2pG2eRusMaChY7oWRmigqGxWkpL6qEaiaRZqfe7LsFH
         6Ls2LSstjRmw5qzYE3qyoY0HdLLM3bwDpRJXXKHainUx7upzAlms7a4mBotSiRsJhSpo
         gylA==
X-Gm-Message-State: APjAAAUI8NIF2BJwrQ50aMF1CoLSBEPR1VCqBdTXptsMCfRFBtxpMBGa
        NuM5WKdepsDMRXXDSnl8JpB5mQ==
X-Google-Smtp-Source: APXvYqzU406aGfBq3suFwA+whTMv4+FQ3EUIb6kO87KLLihGu3hXKpM5jE4+ufgLOgtBIMRL6/ahCg==
X-Received: by 2002:a5e:d506:: with SMTP id e6mr10569663iom.7.1556563609933;
        Mon, 29 Apr 2019 11:46:49 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id f129sm181645itf.4.2019.04.29.11.46.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 11:46:49 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v7 net-next 6/6] ip6tlvs: Validation of TX Destination and Hop-by-Hop options
Date:   Mon, 29 Apr 2019 11:46:16 -0700
Message-Id: <1556563576-31157-7-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556563576-31157-1-git-send-email-tom@quantonium.net>
References: <1556563576-31157-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Validate Destination and Hop-by-Hop options. This uses the information
in the TLV parameters table to validate various aspects of both
individual TLVs as well as a list of TLVs in an extension header.

There are two levels of validation that can be performed: simple checks
and deep checks. Simple checks validate only the most basic properties
such as that the TLV list fits into the EH. Deep checks do a fine
grained validation that includes perferred ordering, length limits,
and length alignment.

With proper permissions set in the TLV parameter table, this patch
allows non-privileged users to send TLVs. Given that TLVs are open
ended and potentially a source of DOS attack, deep checks are
performed to limit the format that a non-privileged user can send.
If deep checks are enabled, a canonical format for sending TLVs is
enforced (in adherence with the robustness principle). A TLV must
be well ordered with respect to the preferred order for the TLV.
Each TLV must be aligned as described in the parameter table. Minimal
padding (one padding TLV) is used to align TLVs. The length of the
extension header as well as the count of non-padding TLVs is checked
against max_*_opts_len and max_*_opts_cnt. For individual TLVs, length
limits and length alignment is checked.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/net/ipv6.h        |  23 +++
 net/ipv6/datagram.c       |  51 +++++--
 net/ipv6/exthdrs_common.c | 376 ++++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/ipv6_sockglue.c  |  39 ++---
 4 files changed, 450 insertions(+), 39 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index edf718f..8c19c6f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -475,6 +475,20 @@ void exthdrs_fini(struct tlv_param_table *tlv_param_table);
 int ipv6_exthdrs_options_init(void);
 void ipv6_exthdrs_options_exit(void);
 
+int ipv6_opt_validate_tlvs(struct net *net,
+			   struct tlv_param_table *tlv_param_table,
+			   struct ipv6_opt_hdr *opt,
+			   unsigned int optname, bool admin,
+			   unsigned int max_len, unsigned int max_cnt);
+int ipv6_opt_validate_single_tlv(struct net *net,
+				 struct tlv_param_table *tlv_param_table,
+				 unsigned int optname,
+				 unsigned char *tlv, size_t len,
+				 bool deleting, bool admin);
+int ipv6_opt_check_perm(struct net *net,
+			struct tlv_param_table *tlv_param_table,
+			struct ipv6_txoptions *txopt, int optname, bool admin);
+
 /* tlv_get_proc assumes rcu_read_lock is held */
 static inline struct tlv_proc *tlv_get_proc(
 		struct tlv_param_table *tlv_param_table,
@@ -491,6 +505,15 @@ bool ipv6_opt_accepted(const struct sock *sk, const struct sk_buff *skb,
 struct ipv6_txoptions *ipv6_update_options(struct sock *sk,
 					   struct ipv6_txoptions *opt);
 
+struct ipv6_txoptions *txoptions_from_opt(struct sock *sk,
+					  struct tlv_param_table
+						*tlv_param_table,
+					  struct ipv6_txoptions *opt,
+					  int optname, char __user *optval,
+					  unsigned int optlen,
+					  unsigned int max_len,
+					  unsigned int max_cnt);
+
 static inline bool ipv6_accept_ra(struct inet6_dev *idev)
 {
 	/* If forwarding is enabled, RA are not accepted unless the special
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index ee4a4e5..1e154ec 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -841,7 +841,10 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 			break;
 
 		case IPV6_2292HOPOPTS:
-		case IPV6_HOPOPTS:
+		case IPV6_HOPOPTS: {
+			int max_len = net->ipv6.sysctl.max_hbh_opts_len;
+			int max_cnt = net->ipv6.sysctl.max_hbh_opts_cnt;
+
 			if (opt->hopopt || cmsg->cmsg_len < CMSG_LEN(sizeof(struct ipv6_opt_hdr))) {
 				err = -EINVAL;
 				goto exit_f;
@@ -853,15 +856,24 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				err = -EINVAL;
 				goto exit_f;
 			}
-			if (!ns_capable(net->user_ns, CAP_NET_RAW)) {
-				err = -EPERM;
+
+			err = ipv6_opt_validate_tlvs(net, &ipv6_tlv_param_table,
+						     hdr, IPV6_HOPOPTS,
+						     ns_capable(net->user_ns,
+								CAP_NET_RAW),
+						     max_len, max_cnt);
+			if (err < 0)
 				goto exit_f;
-			}
+
 			opt->opt_nflen += len;
 			opt->hopopt = hdr;
 			break;
+		}
+
+		case IPV6_2292DSTOPTS: {
+			int max_len = net->ipv6.sysctl.max_dst_opts_len;
+			int max_cnt = net->ipv6.sysctl.max_dst_opts_cnt;
 
-		case IPV6_2292DSTOPTS:
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(struct ipv6_opt_hdr))) {
 				err = -EINVAL;
 				goto exit_f;
@@ -873,10 +885,14 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				err = -EINVAL;
 				goto exit_f;
 			}
-			if (!ns_capable(net->user_ns, CAP_NET_RAW)) {
-				err = -EPERM;
+			err = ipv6_opt_validate_tlvs(net, &ipv6_tlv_param_table,
+						     hdr, IPV6_DSTOPTS,
+						     ns_capable(net->user_ns,
+								CAP_NET_RAW),
+						     max_len, max_cnt);
+			if (err < 0)
 				goto exit_f;
-			}
+
 			if (opt->dst1opt) {
 				err = -EINVAL;
 				goto exit_f;
@@ -884,9 +900,13 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 			opt->opt_flen += len;
 			opt->dst1opt = hdr;
 			break;
+		}
 
 		case IPV6_DSTOPTS:
-		case IPV6_RTHDRDSTOPTS:
+		case IPV6_RTHDRDSTOPTS: {
+			int max_len = net->ipv6.sysctl.max_dst_opts_len;
+			int max_cnt = net->ipv6.sysctl.max_dst_opts_cnt;
+
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(struct ipv6_opt_hdr))) {
 				err = -EINVAL;
 				goto exit_f;
@@ -898,10 +918,15 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				err = -EINVAL;
 				goto exit_f;
 			}
-			if (!ns_capable(net->user_ns, CAP_NET_RAW)) {
-				err = -EPERM;
+
+			err = ipv6_opt_validate_tlvs(net, &ipv6_tlv_param_table,
+						     hdr, IPV6_DSTOPTS,
+						     ns_capable(net->user_ns,
+								CAP_NET_RAW),
+						     max_len, max_cnt);
+			if (err < 0)
 				goto exit_f;
-			}
+
 			if (cmsg->cmsg_type == IPV6_DSTOPTS) {
 				opt->opt_flen += len;
 				opt->dst1opt = hdr;
@@ -910,7 +935,7 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				opt->dst0opt = hdr;
 			}
 			break;
-
+		}
 		case IPV6_2292RTHDR:
 		case IPV6_RTHDR:
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(struct ipv6_rt_hdr))) {
diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
index b24846d..cb6fedf 100644
--- a/net/ipv6/exthdrs_common.c
+++ b/net/ipv6/exthdrs_common.c
@@ -143,6 +143,312 @@ struct ipv6_txoptions *ipv6_fixup_options(struct ipv6_txoptions *opt_space,
 }
 EXPORT_SYMBOL_GPL(ipv6_fixup_options);
 
+/* TLV validation functions */
+
+/* Validate a single non-padding TLV */
+static int __ipv6_opt_validate_single_tlv(struct net *net, unsigned char *tlv,
+					  struct tlv_tx_params *tptx,
+					  unsigned int class, bool *deep_check,
+					  bool deleting, bool admin)
+{
+	if (tlv[0] < 2) /* Must be non-padding */
+		return -EINVAL;
+
+	/* Check permissions */
+	switch (admin ? tptx->admin_perm : tptx->user_perm) {
+	case IPV6_TLV_PERM_NO_CHECK:
+		/* Allowed with no deep checks */
+		*deep_check = false;
+		return 0;
+	case IPV6_TLV_PERM_WITH_CHECK:
+		/* Allowed with deep checks */
+		*deep_check = true;
+		break;
+	default:
+		/* No permission */
+		return -EPERM;
+	}
+
+	/* Perform deep checks on the TLV */
+
+	/* Check class */
+	if ((tptx->class & class) != class)
+		return -EINVAL;
+
+	/* Don't bother checking lengths when deleting, the TLV is only
+	 * needed here for lookup
+	 */
+	if (deleting) {
+		/* Don't bother with deep checks when deleting */
+		*deep_check = false;
+	} else {
+		/* Check length */
+		if (tlv[1] < tptx->min_data_len || tlv[1] > tptx->max_data_len)
+			return -EINVAL;
+
+		/* Check length alignment */
+		if ((tlv[1] % (tptx->data_len_mult + 1)) != tptx->data_len_off)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static unsigned int optname_to_tlv_class(int optname)
+{
+	switch (optname) {
+	case IPV6_HOPOPTS:
+		return IPV6_TLV_CLASS_FLAG_HOPOPT;
+	case IPV6_RTHDRDSTOPTS:
+		return IPV6_TLV_CLASS_FLAG_RTRDSTOPT;
+	case IPV6_DSTOPTS:
+		return IPV6_TLV_CLASS_FLAG_DSTOPT;
+	default:
+		return -1U;
+	}
+}
+
+static int __ipv6_opt_validate_tlvs(struct net *net,
+				    struct tlv_param_table *tlv_param_table,
+				    struct ipv6_opt_hdr *opt,
+				    unsigned int optname, bool deleting,
+				    bool admin, unsigned int max_len,
+				    unsigned int max_cnt)
+{
+	unsigned char *tlv = (unsigned char *)opt;
+	bool deep_check, did_deep_check = false;
+	unsigned int opt_len, tlv_len, offset;
+	unsigned int padding = 0, numpad = 0;
+	unsigned char prev_tlv_order = 0;
+	unsigned int class, cnt = 0;
+	struct tlv_tx_params *tptx;
+	int retc, ret = -EINVAL;
+	struct tlv_proc *tproc;
+
+	opt_len = ipv6_optlen(opt);
+	offset = sizeof(*opt);
+
+	class = optname_to_tlv_class(optname);
+
+	rcu_read_lock();
+
+	while (offset < opt_len) {
+		switch (tlv[offset]) {
+		case IPV6_TLV_PAD1:
+			tlv_len = 1;
+			padding++;
+			numpad++;
+			break;
+		case IPV6_TLV_PADN:
+			if (offset + 1 >= opt_len)
+				goto out;
+
+			tlv_len = tlv[offset + 1] + 2;
+
+			if (offset + tlv_len > opt_len)
+				goto out;
+
+			padding += tlv_len;
+			numpad++;
+			break;
+		default:
+			if (offset + 1 >= opt_len)
+				goto out;
+
+			tlv_len = tlv[offset + 1] + 2;
+
+			if (offset + tlv_len > opt_len)
+				goto out;
+
+			tproc = tlv_get_proc(tlv_param_table, tlv[offset]);
+			tptx = &tproc->params.t;
+
+			retc = __ipv6_opt_validate_single_tlv(net, &tlv[offset],
+							      tptx, class,
+							      &deep_check,
+							      deleting, admin);
+			if (retc < 0) {
+				ret = retc;
+				goto out;
+			}
+
+			if (deep_check) {
+				/* Check for too many options */
+				if (++cnt > max_cnt) {
+					ret = -E2BIG;
+					goto out;
+				}
+
+				/* Check order */
+				if (tptx->preferred_order < prev_tlv_order)
+					goto out;
+
+				/* Check alignment */
+				if ((offset % (tptx->align_mult + 1)) !=
+				    tptx->align_off)
+					goto out;
+
+				/* Check for right amount of padding */
+				if (numpad > 1 || padding > tptx->align_mult)
+					goto out;
+
+				prev_tlv_order = tptx->preferred_order;
+
+				did_deep_check = true;
+			}
+			padding = 0;
+			numpad = 0;
+		}
+		offset += tlv_len;
+	}
+
+	/* If we did at least one deep check apply length limit */
+	if (did_deep_check && opt_len > max_len) {
+		ret = -EMSGSIZE;
+		goto out;
+	}
+
+	/* All good */
+	ret = 0;
+out:
+	rcu_read_unlock();
+
+	return ret;
+}
+
+/**
+ * ipv6_opt_validate_tlvs - Validate TLVs.
+ * @net: Current net
+ * @tlv_param_table: TLV parameter table
+ * @opt: The option header
+ * @optname: IPV6_HOPOPTS, IPV6_RTHDRDSTOPTS, or IPV6_DSTOPTS
+ * @admin: Set for privileged user
+ * @max_len: Maximum length for TLV
+ * @max_cnt: Maximum number of non-padding TLVs
+ *
+ * Description:
+ * Walks the TLVs in a list to verify that the TLV lengths and other
+ * parameters are in bounds for a Destination or Hop-by-Hop option.
+ * Return -EINVAL is there is a problem, zero otherwise.
+ */
+int ipv6_opt_validate_tlvs(struct net *net,
+			   struct tlv_param_table *tlv_param_table,
+			   struct ipv6_opt_hdr *opt, unsigned int optname,
+			   bool admin, unsigned int max_len,
+			   unsigned int max_cnt)
+{
+	return __ipv6_opt_validate_tlvs(net, tlv_param_table, opt, optname,
+					false, admin, max_len, max_cnt);
+}
+EXPORT_SYMBOL(ipv6_opt_validate_tlvs);
+
+/**
+ * ipv6_opt_validate_single_tlv - Check that a single TLV is valid.
+ * @net: Current net
+ * @tlv_param_table: TLV parameter table
+ * @optname: IPV6_HOPOPTS, IPV6_RTHDRDSTOPTS, or IPV6_DSTOPTS
+ * @tlv: The TLV as array of bytes
+ * @len: Length of buffer holding TLV
+ * @deleting: TLV is being deleted
+ * @admin: Set for privileged user
+ *
+ * Description:
+ * Validates a single TLV. The TLV must be non-padding type. The length
+ * of the TLV (as determined by the second byte that gives length of the
+ * option data) must match @len.
+ */
+int ipv6_opt_validate_single_tlv(struct net *net,
+				 struct tlv_param_table *tlv_param_table,
+				 unsigned int optname,
+				 unsigned char *tlv, size_t len,
+				 bool deleting, bool admin)
+{
+	struct tlv_tx_params *tptx;
+	struct tlv_proc *tproc;
+	unsigned int class;
+	bool deep_check;
+	int ret = 0;
+
+	class = optname_to_tlv_class(optname);
+
+	if (tlv[0] < 2)
+		return -EINVAL;
+
+	if (len < 2)
+		return -EINVAL;
+
+	if (tlv[1] + 2 != len)
+		return -EINVAL;
+
+	rcu_read_lock();
+
+	tproc = tlv_get_proc(tlv_param_table, tlv[0]);
+	tptx = &tproc->params.t;
+
+	ret = __ipv6_opt_validate_single_tlv(net, tlv, tptx, class,
+					     &deep_check, deleting, admin);
+
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL(ipv6_opt_validate_single_tlv);
+
+/**
+ * ipv6_opt_check_perm - Check that current capabilities allows modifying
+ * txopts.
+ * @net: Current net
+ * @tlv_param_table: TLV parameter table
+ * @txopts: TX options from the socket
+ * @optname: IPV6_HOPOPTS, IPV6_RTHDRDSTOPTS, or IPV6_DSTOPTS
+ * @admin: Set for privileged user
+ *
+ * Description:
+ *
+ * Checks whether the permissions of TLV that are set on a socket permit
+ * modificationr.
+ *
+ */
+int ipv6_opt_check_perm(struct net *net,
+			struct tlv_param_table *tlv_param_table,
+			struct ipv6_txoptions *txopt, int optname, bool admin)
+{
+	struct ipv6_opt_hdr *opt;
+	int retv = -EPERM;
+
+	if (!txopt)
+		return 0;
+
+	switch (optname) {
+	case IPV6_HOPOPTS:
+		opt = txopt->hopopt;
+		break;
+	case IPV6_RTHDRDSTOPTS:
+		opt = txopt->dst0opt;
+		break;
+	case IPV6_DSTOPTS:
+		opt = txopt->dst1opt;
+		break;
+	default:
+		goto out;
+	}
+
+	if (!opt) {
+		retv = 0;
+		goto out;
+	}
+
+	/* Just call the validate function on the options as being
+	 * deleted.
+	 */
+	retv = __ipv6_opt_validate_tlvs(net, tlv_param_table, opt, optname,
+					true, admin, -1U, -1U);
+
+out:
+	return retv;
+}
+EXPORT_SYMBOL(ipv6_opt_check_perm);
+
 /* TLV parameter table functions and structures */
 
 static void tlv_param_table_release(struct rcu_head *rcu)
@@ -381,6 +687,76 @@ int tlv_unset_params(struct tlv_param_table *tlv_param_table,
 }
 EXPORT_SYMBOL(tlv_unset_params);
 
+/* Utility function tp create TX options from a setsockopt that is setting
+ * options on a socket.
+ */
+struct ipv6_txoptions *txoptions_from_opt(struct sock *sk,
+					  struct tlv_param_table
+							*tlv_param_table,
+					  struct ipv6_txoptions *opt,
+					  int optname, char __user *optval,
+					  unsigned int optlen,
+					  unsigned int max_len,
+					  unsigned int max_cnt)
+{
+	struct ipv6_opt_hdr *new = NULL;
+	struct net *net = sock_net(sk);
+	int retv;
+
+	/* remove any sticky options header with a zero option
+	 * length, per RFC3542.
+	 */
+	if (optlen == 0) {
+		optval = NULL;
+	} else if (!optval) {
+		return ERR_PTR(-EINVAL);
+	} else if (optlen < sizeof(struct ipv6_opt_hdr) ||
+		 optlen & 0x7 || optlen > 8 * 255) {
+		return ERR_PTR(-EINVAL);
+	} else {
+		new = memdup_user(optval, optlen);
+		if (IS_ERR(new))
+			return (struct ipv6_txoptions *)new;
+		if (unlikely(ipv6_optlen(new) > optlen)) {
+			kfree(new);
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	if (optname != IPV6_RTHDR) {
+		bool cap = ns_capable(net->user_ns, CAP_NET_RAW);
+
+		/* First check if we have permission to delete
+		 * the existing options on the socket.
+		 */
+		retv = ipv6_opt_check_perm(net, tlv_param_table,
+					   opt, optname, cap);
+		if (retv < 0) {
+			kfree(new);
+			return ERR_PTR(retv);
+		}
+
+		/* Check permissions and other validations on new
+		 * TLVs
+		 */
+		if (new) {
+			retv = ipv6_opt_validate_tlvs(net, tlv_param_table,
+						      new, optname, cap,
+						      max_len, max_cnt);
+			if (retv < 0) {
+				kfree(new);
+				return ERR_PTR(retv);
+			}
+		}
+	}
+
+	opt = ipv6_renew_options(sk, opt, optname, new);
+	kfree(new);
+
+	return opt;
+}
+EXPORT_SYMBOL(txoptions_from_opt);
+
 const struct nla_policy tlv_nl_policy[IPV6_TLV_ATTR_MAX + 1] = {
 	[IPV6_TLV_ATTR_TYPE] =		{ .type = NLA_U8, },
 	[IPV6_TLV_ATTR_ORDER] =		{ .type = NLA_U8, },
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 40f21fe..5045818 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -398,39 +398,26 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 	case IPV6_DSTOPTS:
 	{
 		struct ipv6_txoptions *opt;
-		struct ipv6_opt_hdr *new = NULL;
+		unsigned int max_len = -1U, max_cnt = -1U;
 
-		/* hop-by-hop / destination options are privileged option */
-		retv = -EPERM;
-		if (optname != IPV6_RTHDR && !ns_capable(net->user_ns, CAP_NET_RAW))
+		switch (optname) {
+		case IPV6_HOPOPTS:
+			max_len = net->ipv6.sysctl.max_hbh_opts_len;
+			max_cnt = net->ipv6.sysctl.max_hbh_opts_cnt;
 			break;
-
-		/* remove any sticky options header with a zero option
-		 * length, per RFC3542.
-		 */
-		if (optlen == 0)
-			optval = NULL;
-		else if (!optval)
-			goto e_inval;
-		else if (optlen < sizeof(struct ipv6_opt_hdr) ||
-			 optlen & 0x7 || optlen > 8 * 255)
-			goto e_inval;
-		else {
-			new = memdup_user(optval, optlen);
-			if (IS_ERR(new)) {
-				retv = PTR_ERR(new);
+		case IPV6_RTHDRDSTOPTS:
+		case IPV6_DSTOPTS:
+			max_len = net->ipv6.sysctl.max_dst_opts_len;
+			max_cnt = net->ipv6.sysctl.max_dst_opts_cnt;
 				break;
-			}
-			if (unlikely(ipv6_optlen(new) > optlen)) {
-				kfree(new);
-				goto e_inval;
-			}
 		}
 
 		opt = rcu_dereference_protected(np->opt,
 						lockdep_sock_is_held(sk));
-		opt = ipv6_renew_options(sk, opt, optname, new);
-		kfree(new);
+		opt = txoptions_from_opt(sk, &ipv6_tlv_param_table, opt,
+					 optname, optval, optlen, max_len,
+					 max_cnt);
+
 		if (IS_ERR(opt)) {
 			retv = PTR_ERR(opt);
 			break;
-- 
2.7.4

