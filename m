Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E77CCB19D
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387490AbfJCV6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:58:49 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46854 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfJCV6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:58:49 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so2509852pgm.13
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 14:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/thsByp6mTBTVSdNYFnEyXZbSPtwdw2AwHm8AOIT4w0=;
        b=2OxPbIoRg7LalRcp1lf059i3mGvW3Eikrh7hFsfic+ykM2JW06d+kxfF3CSEwBqguZ
         OEQD7prGYTzEjzrmOogYZGKvxrqvC+J9nZwi2v3m/zClKjlg5QfYEZT3sHJIDCqoy2Qw
         1D0xfPqPCm7ILIA84m/KzLsALG3tbt0dsCMD5HVkExfUZC06g9CdvE4WO8sArK4o94zL
         +3i5EMeryvh6oV55EGgDW/OhU83tp1obHNEDvUl47/LpGT8k/J9czW2G7Zo8XXL8vD8N
         zahHBlpiyIy4EU/xLRVAiprgiaqijZEWf2KhSQ3Djc0TkfpBJaStxGBSxYjvdP+DziAC
         3bJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/thsByp6mTBTVSdNYFnEyXZbSPtwdw2AwHm8AOIT4w0=;
        b=dZdPl4hNFk7y08eSy6jaifrgECcMDSGihO4dud/Stou0x45JWC4gCn86p9DYldcA5D
         WHRs2QpCUVuLiejHlGc2iM8tgLbyLztJuLjalBif4N3XPMSNXkA7YdcEKpGpQ+Cnwxk2
         RXUS/DpBLGcUdZoASMQ6Atgk62tI5gl1pWeDKqInvGV+Eh7NthwLlzLgJuS9Szgashnw
         S6r8LViIChcx+bza6bEvZP3Drq+A5OrWtsl8j9Qnpp7bwwQ/VF2GVuvoS5czs6NdGIVB
         QoSf6/zDaI3CG/dJl1bFkOj560mKyZ89FPRRBpUwjFI7dVRwuLB7T+qYsSGqlMTJPzSh
         oOYw==
X-Gm-Message-State: APjAAAX3JSTIASL9QQrJHKF9XM4O3ibNkyfVeoxLxD5BwDuomo6mSQ9c
        +9Oes/BJuaiMdUuiKn/ZCYCg9Q==
X-Google-Smtp-Source: APXvYqzVOReZA1P/6atuX8vwwQY6lVHyqs0oQGfclLi3LiQ7pgXjl4u/nY4JlVCfgAaV/mdfwSOCmg==
X-Received: by 2002:a17:90a:94ca:: with SMTP id j10mr12775027pjw.24.1570139927729;
        Thu, 03 Oct 2019 14:58:47 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id r18sm3889905pfc.3.2019.10.03.14.58.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 03 Oct 2019 14:58:47 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>, Tom Herbert <tom@herbertland.com>
Subject: [PATCH v5 net-next 7/7] ip6tlvs: Validation of TX Destination and Hop-by-Hop options
Date:   Thu,  3 Oct 2019 14:58:04 -0700
Message-Id: <1570139884-20183-8-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570139884-20183-1-git-send-email-tom@herbertland.com>
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@quantonium.net>

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

Signed-off-by: Tom Herbert <tom@herbertland.com>
---
 include/net/ipeh.h        |  22 +++
 net/ipv6/datagram.c       |  51 +++++--
 net/ipv6/exthdrs_common.c | 382 ++++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/ipv6_sockglue.c  |  39 ++---
 4 files changed, 455 insertions(+), 39 deletions(-)

diff --git a/include/net/ipeh.h b/include/net/ipeh.h
index 8474a43..e58a0f4 100644
--- a/include/net/ipeh.h
+++ b/include/net/ipeh.h
@@ -157,6 +157,28 @@ struct ipv6_txoptions *ipeh_renew_options(struct sock *sk,
 struct ipv6_txoptions *ipeh_fixup_options(struct ipv6_txoptions *opt_space,
 					  struct ipv6_txoptions *opt);
 
+int ipeh_opt_validate_tlvs(struct net *net,
+			   struct tlv_param_table *tlv_param_table,
+			   struct ipv6_opt_hdr *opt,
+			   unsigned int optname, bool admin,
+			   unsigned int max_len, unsigned int max_cnt);
+int ipeh_opt_validate_single_tlv(struct net *net,
+				 struct tlv_param_table *tlv_param_table,
+				 unsigned int optname, const __u8 *tlv,
+				 size_t len, bool deleting, bool admin);
+int ipeh_opt_check_perm(struct net *net,
+			struct tlv_param_table *tlv_param_table,
+			struct ipv6_txoptions *txopt, int optname, bool admin);
+
+struct ipv6_txoptions *ipeh_txopt_from_opt(struct sock *sk,
+					   struct tlv_param_table
+						*tlv_param_table,
+					   struct ipv6_txoptions *opt,
+					   int optname, char __user *optval,
+					   unsigned int optlen,
+					   unsigned int max_len,
+					   unsigned int max_cnt);
+
 /* Generic extension header TLV parser */
 
 enum ipeh_parse_errors {
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 96f9392..f9856a7 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -839,7 +839,10 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
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
@@ -851,15 +854,24 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				err = -EINVAL;
 				goto exit_f;
 			}
-			if (!ns_capable(net->user_ns, CAP_NET_RAW)) {
-				err = -EPERM;
+
+			err = ipeh_opt_validate_tlvs(net, &ipv6_tlv_param_table,
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
@@ -871,10 +883,14 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				err = -EINVAL;
 				goto exit_f;
 			}
-			if (!ns_capable(net->user_ns, CAP_NET_RAW)) {
-				err = -EPERM;
+			err = ipeh_opt_validate_tlvs(net, &ipv6_tlv_param_table,
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
@@ -882,9 +898,13 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
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
@@ -896,10 +916,15 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				err = -EINVAL;
 				goto exit_f;
 			}
-			if (!ns_capable(net->user_ns, CAP_NET_RAW)) {
-				err = -EPERM;
+
+			err = ipeh_opt_validate_tlvs(net, &ipv6_tlv_param_table,
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
@@ -908,7 +933,7 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				opt->dst0opt = hdr;
 			}
 			break;
-
+		}
 		case IPV6_2292RTHDR:
 		case IPV6_RTHDR:
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(struct ipv6_rt_hdr))) {
diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
index e3c1f33..c3047df 100644
--- a/net/ipv6/exthdrs_common.c
+++ b/net/ipv6/exthdrs_common.c
@@ -262,6 +262,318 @@ bool ipeh_parse_tlv(unsigned int class,
 }
 EXPORT_SYMBOL(ipeh_parse_tlv);
 
+/* TLV validation functions */
+
+/* Validate a single non-padding TLV */
+static int __ipeh_opt_validate_single_tlv(struct net *net, const __u8 *tlv,
+					  struct tlv_proc *tproc,
+					  unsigned int class, bool *deep_check,
+					  bool deleting, bool admin)
+{
+	struct tlv_tx_params *tptx = &tproc->params.t;
+
+	if (tlv[0] < 2) /* Must be non-padding */
+		return -EINVAL;
+
+	/* Check permissions */
+	switch (admin ? tptx->admin_perm : tptx->user_perm) {
+	case IPEH_TLV_PERM_NO_CHECK:
+		/* Allowed with no deep checks */
+		*deep_check = false;
+		return 0;
+	case IPEH_TLV_PERM_WITH_CHECK:
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
+		return IPEH_TLV_CLASS_FLAG_HOPOPT;
+	case IPV6_RTHDRDSTOPTS:
+		return IPEH_TLV_CLASS_FLAG_RTRDSTOPT;
+	case IPV6_DSTOPTS:
+		return IPEH_TLV_CLASS_FLAG_DSTOPT;
+	default:
+		return -1U;
+	}
+}
+
+static int __ipeh_opt_validate_tlvs(struct net *net,
+				    struct tlv_param_table *tlv_param_table,
+				    struct ipv6_opt_hdr *opt,
+				    unsigned int optname, bool deleting,
+				    bool admin, unsigned int max_len,
+				    unsigned int max_cnt)
+{
+	bool deep_check = !admin, did_deep_check = false;
+	unsigned int opt_len, tlv_len, offset;
+	unsigned int padding = 0, numpad = 0;
+	unsigned short prev_tlv_order = 0;
+	unsigned int class, cnt = 0;
+	struct tlv_tx_params *tptx;
+	int retc, ret = -EINVAL;
+	__u8 *tlv = (__u8 *)opt;
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
+			tproc = ipeh_tlv_get_proc(tlv_param_table,
+						  &tlv[offset]);
+			tptx = &tproc->params.t;
+
+			retc = __ipeh_opt_validate_single_tlv(net, &tlv[offset],
+							      tproc, class,
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
+	/* Check trailing padding. Note this covers the case option list
+	 * only contains padding.
+	 */
+	if (deep_check && (numpad > 1 || padding > 7))
+		goto out;
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
+ * ipeh_opt_validate_tlvs - Validate TLVs.
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
+int ipeh_opt_validate_tlvs(struct net *net,
+			   struct tlv_param_table *tlv_param_table,
+			   struct ipv6_opt_hdr *opt, unsigned int optname,
+			   bool admin, unsigned int max_len,
+			   unsigned int max_cnt)
+{
+	return __ipeh_opt_validate_tlvs(net, tlv_param_table, opt, optname,
+					false, admin, max_len, max_cnt);
+}
+EXPORT_SYMBOL(ipeh_opt_validate_tlvs);
+
+/**
+ * ipeh_opt_validate_single_tlv - Check that a single TLV is valid.
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
+int ipeh_opt_validate_single_tlv(struct net *net,
+				 struct tlv_param_table *tlv_param_table,
+				 unsigned int optname, const __u8 *tlv,
+				 size_t len, bool deleting, bool admin)
+{
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
+	tproc = ipeh_tlv_get_proc(tlv_param_table, tlv);
+
+	ret = __ipeh_opt_validate_single_tlv(net, tlv, tproc, class,
+					     &deep_check, deleting, admin);
+
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL(ipeh_opt_validate_single_tlv);
+
+/**
+ * ipeh_opt_check_perm - Check that current capabilities allows modifying
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
+int ipeh_opt_check_perm(struct net *net,
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
+	retv = __ipeh_opt_validate_tlvs(net, tlv_param_table, opt, optname,
+					true, admin, -1U, -1U);
+
+out:
+	return retv;
+}
+EXPORT_SYMBOL(ipeh_opt_check_perm);
+
 /* TLV parameter table functions and structures */
 
 /* Default (unset) values for TLV parameters */
@@ -454,6 +766,76 @@ int __ipeh_tlv_unset(struct tlv_param_table *tlv_param_table,
 }
 EXPORT_SYMBOL(__ipeh_tlv_unset);
 
+/* Utility function tp create TX options from a setsockopt that is setting
+ * options on a socket.
+ */
+struct ipv6_txoptions *ipeh_txopt_from_opt(struct sock *sk,
+					   struct tlv_param_table
+							*tlv_param_table,
+					   struct ipv6_txoptions *opt,
+					   int optname, char __user *optval,
+					   unsigned int optlen,
+					   unsigned int max_len,
+					   unsigned int max_cnt)
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
+		retv = ipeh_opt_check_perm(net, tlv_param_table,
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
+			retv = ipeh_opt_validate_tlvs(net, tlv_param_table,
+						      new, optname, cap,
+						      max_len, max_cnt);
+			if (retv < 0) {
+				kfree(new);
+				return ERR_PTR(retv);
+			}
+		}
+	}
+
+	opt = ipeh_renew_options(sk, opt, optname, new);
+	kfree(new);
+
+	return opt;
+}
+EXPORT_SYMBOL(ipeh_txopt_from_opt);
+
 const struct nla_policy ipeh_tlv_nl_policy[IPEH_TLV_ATTR_MAX + 1] = {
 	[IPEH_TLV_ATTR_TYPE] =		{ .type = NLA_U8, },
 	[IPEH_TLV_ATTR_ORDER] =		{ .type = NLA_U16, },
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 8755ecc..b8e007ca 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -395,40 +395,27 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 	case IPV6_RTHDR:
 	case IPV6_DSTOPTS:
 	{
+		unsigned int max_len = -1U, max_cnt = -1U;
 		struct ipv6_txoptions *opt;
-		struct ipv6_opt_hdr *new = NULL;
 
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
-		opt = ipeh_renew_options(sk, opt, optname, new);
-		kfree(new);
+		opt = ipeh_txopt_from_opt(sk, &ipv6_tlv_param_table, opt,
+					  optname, optval, optlen, max_len,
+					  max_cnt);
+
 		if (IS_ERR(opt)) {
 			retv = PTR_ERR(opt);
 			break;
-- 
2.7.4

