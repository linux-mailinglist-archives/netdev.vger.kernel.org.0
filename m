Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C26FED2B
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 01:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbfD2XFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 19:05:03 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:53108 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729684AbfD2XE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 19:04:58 -0400
Received: by mail-it1-f193.google.com with SMTP id x132so1772015itf.2
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 16:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PtIyc21qvQR4VYJ1pXh389yIvJE9WGpco5jIFGYZ3ZI=;
        b=EUaLA/oLjQaMx5MOaNJsVofK07DiZNKlg/AmlL3ZjrehAeG9Do34uWb2FueZAklgE2
         RCpu05TOCJRQ3CIumNK+Z7Zi0QmutrXd2IhDuIvdS059b5vMezqLyYTQgZ5R7WR12gEt
         5SnLn12W3hU96K6QZIWFK9nspk5cSKB1e30yyJcEAFAQW1rhMplNGHDIl3QVbBGd9Dn+
         UZ51LOfSUcj4mkSW0diNLO8FsNugWMfscZZF2DMys7MtY75hIh/2nJAzqi+RyHm2z+44
         63UwxdlZZuV38VljyHqAy1dGNfJgE+eK3lYoNQwALpyywTraXHqE/sQdttIRWAmb/lv2
         vsQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PtIyc21qvQR4VYJ1pXh389yIvJE9WGpco5jIFGYZ3ZI=;
        b=i1/owNjvD0yNIPn3cMHt98iNpXN3x21x3KOeVwtm3olZtbgLxwd0beEJLX9ojCtWWI
         2c0mOC7jm7PvAFv+3WvW2LSSTwQLCOh+tX7kW3MM0Sd4Rulgm4q2L+QZ6rIX8OMeDe0J
         I3vvd8LK763Ijn6SUKNvabpintrN48AjWa4xxmRBaGdQyoLHA9TOAh8ZgnaNwLIi8yRM
         oXm9MFlAv7s/b8lbQmlGUpZlrWH0n8OxRuXOXuLJU41ETOLViXFmTq9MZm4WY82IHR9e
         gn+dR2eLHrxbrtgn+yBLLejK2HvJXkI87CzCZUEq08bimzffl7bTJEGhIH4dFC12FAJZ
         R9Fw==
X-Gm-Message-State: APjAAAVAMjpE2fAGU7O4PF2w+L8X8e5X8ICGVtrcpcHLjmi2qtesKWjG
        XrEUf0xOf7ef1Mx0skp9GAF9fA==
X-Google-Smtp-Source: APXvYqw20FLgSDE5/bOlYRLxgtZJi++4Y7TnrYVCQegVBHGan6Ibc+4+USwrPA3UCdX3rn4JTM5ggw==
X-Received: by 2002:a05:660c:248:: with SMTP id t8mr1426009itk.162.1556579097642;
        Mon, 29 Apr 2019 16:04:57 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id y62sm340626itg.13.2019.04.29.16.04.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 16:04:57 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v8 net-next 7/8] ipv6tlvs: Infrastructure for manipulating individual TLVs
Date:   Mon, 29 Apr 2019 16:04:22 -0700
Message-Id: <1556579063-1367-8-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556579063-1367-1-git-send-email-tom@quantonium.net>
References: <1556579063-1367-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add utility functions in exthdrs_common.c to manipulate individual
TVLs in Hop-by-Hop or Destination Options. This includes functions
to find, insert, and delete in singleton TLV from on IPv6 options
header.

This code is based in part on the TLV option handling in calipso.c.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/net/ipv6.h        |  13 ++
 net/ipv6/exthdrs_common.c | 519 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 532 insertions(+)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index a8c1e6c..bf6e593f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -491,6 +491,19 @@ int ipv6_opt_check_perm(struct net *net,
 			struct tlv_param_table *tlv_param_table,
 			struct ipv6_txoptions *txopt, int optname, bool admin);
 
+int ipv6_opt_tlv_find(struct tlv_param_table *tlv_param_table,
+		      struct ipv6_opt_hdr *opt, unsigned char *targ_tlv,
+		      unsigned int *start, unsigned int *end);
+struct ipv6_opt_hdr *ipv6_opt_tlv_insert(struct net *net,
+				struct tlv_param_table *tlv_param_table,
+				struct ipv6_opt_hdr *opt,
+				int optname, unsigned char *tlv,
+				bool admin);
+struct ipv6_opt_hdr *ipv6_opt_tlv_delete(struct net *net,
+				struct tlv_param_table *tlv_param_table,
+				struct ipv6_opt_hdr *opt,
+				unsigned char *tlv, bool admin);
+
 /* tlv_get_proc assumes rcu_read_lock is held */
 static inline struct tlv_proc *tlv_get_proc(
 		struct tlv_param_table *tlv_param_table,
diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
index 12925004..8acff49 100644
--- a/net/ipv6/exthdrs_common.c
+++ b/net/ipv6/exthdrs_common.c
@@ -449,6 +449,525 @@ int ipv6_opt_check_perm(struct net *net,
 }
 EXPORT_SYMBOL(ipv6_opt_check_perm);
 
+/* Functions to manage individual TLVs */
+
+/**
+ * __ipv6_opt_tlv_find - Finds a particular TLV in an IPv6 options header
+ * (destinaton or hop-by-hop options). If TLV is not present, then the
+ * preferred insertion point is determined.
+ * @opt: the options header (an EH header followed by data)
+ * @targ_tlv: Prototype of TLV to find
+ * @start: on return holds the offset of any leading padding if option
+ *       is present, or offset at which option is inserted.
+ * @end: on return holds the offset of the first non-pad TLV after option
+ *       if the option was found, else points to the first TLV after
+ *       padding at intsertion point.
+ *
+ * Description:
+ * Finds the space occupied by particular option (including any leading and
+ * trailing padding), or the perferred position for insertion if the
+ * TLV is not present.
+ *
+ * If the option is found then @start and @end are set to the offsets within
+ * @opt of the start of padding before the first found option and the end of
+ * padding after the first found option. In this case the function returns
+ * the offset in @opt of the found option (a value >= 2 since the TLV
+ * must be after the option header).
+ *
+ * In the absence of the searched option, @start is set to offset in @opt at
+ * which the option may be inserted per the ordering and alignment rules
+ * in the TLV parameter table, and @end is set to the end + 1 of any
+ * padding at the @start offset. When the option is not found -ENOENT is
+ * returned.
+ *
+ * rcu_read_lock assumed held.
+ */
+static int __ipv6_opt_tlv_find(struct tlv_param_table *tlv_param_table,
+			       struct ipv6_opt_hdr *opt,
+			       unsigned char *targ_tlv,
+			       unsigned int *start, unsigned int *end)
+{
+	unsigned int offset_s = 0, offset_e = 0, last_s = 0;
+	unsigned char *tlv = (unsigned char *)opt;
+	unsigned int pad_e = sizeof(*opt);
+	int ret_val = -ENOENT, tlv_len;
+	unsigned int opt_len, offset;
+	struct tlv_tx_params *tptx;
+	unsigned int targ_order;
+	bool found_cand = false;
+	struct tlv_proc *tproc;
+
+	opt_len = ipv6_optlen(opt);
+	offset = sizeof(*opt);
+
+	tproc = tlv_get_proc(tlv_param_table, targ_tlv[0]);
+	tptx = &tproc->params.t;
+
+	targ_order = tptx->preferred_order;
+
+	while (offset < opt_len) {
+		switch (tlv[offset]) {
+		case IPV6_TLV_PAD1:
+			if (offset_e)
+				offset_e = offset;
+			tlv_len = 1;
+			break;
+		case IPV6_TLV_PADN:
+			if (offset_e)
+				offset_e = offset;
+			tlv_len = tlv[offset + 1] + 2;
+			break;
+		default:
+			if (ret_val >= 0)
+				goto out;
+
+			/* Not found yet */
+
+			if (tlv[offset] == targ_tlv[0]) {
+				/* Found it */
+
+				ret_val = offset;
+				offset_e = offset;
+				offset_s = last_s;
+				found_cand = true;
+			} else {
+				struct tlv_tx_params *tptx1;
+
+				tproc = tlv_get_proc(tlv_param_table,
+						     tlv[offset]);
+				tptx1 = &tproc->params.t;
+
+				if (targ_order < tptx1->preferred_order &&
+				    !found_cand) {
+					/* Found candidate for insert location
+					 */
+
+					pad_e = offset;
+					offset_s = last_s;
+					found_cand = true;
+				}
+			}
+
+			last_s = offset;
+			tlv_len = tlv[offset + 1] + 2;
+			break;
+		}
+
+		offset += tlv_len;
+	}
+
+	if (!found_cand) {
+		/* Not found and insert point is after all options */
+		offset_s = last_s;
+		pad_e = opt_len;
+	}
+
+out:
+	if (offset_s)
+		*start = offset_s +
+		    (tlv[offset_s] ? tlv[offset_s + 1] + 2 : 1);
+	else
+		*start = sizeof(*opt);
+
+	if (ret_val >= 0)
+		*end = offset_e +
+		    (tlv[offset_e] ? tlv[offset_e + 1] + 2 : 1);
+	else
+		*end = pad_e;
+
+	return ret_val;
+}
+
+int ipv6_opt_tlv_find(struct tlv_param_table *tlv_param_table,
+		      struct ipv6_opt_hdr *opt, unsigned char *targ_tlv,
+		      unsigned int *start, unsigned int *end)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = __ipv6_opt_tlv_find(tlv_param_table, opt, targ_tlv, start, end);
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL(ipv6_opt_tlv_find);
+
+/**
+ * ipv6_opt_tlv_pad_write - Writes pad bytes in TLV format
+ * @buf: the buffer
+ * @offset: offset from start of buffer to write padding
+ * @count: number of pad bytes to write
+ *
+ * Description:
+ * Write @count bytes of TLV padding into @buffer starting at offset @offset.
+ * @count should be less than 8 - see RFC 4942.
+ *
+ */
+static int ipv6_opt_tlv_pad_write(unsigned char *buf, unsigned int offset,
+				  unsigned int count)
+{
+	if (WARN_ON_ONCE(count >= 8))
+		return -EINVAL;
+
+	switch (count) {
+	case 0:
+		break;
+	case 1:
+		buf[offset] = IPV6_TLV_PAD1;
+		break;
+	default:
+		buf[offset] = IPV6_TLV_PADN;
+		buf[offset + 1] = count - 2;
+		if (count > 2)
+			memset(buf + offset + 2, 0, count - 2);
+		break;
+	}
+	return 0;
+}
+
+static unsigned int compute_padding(unsigned int offset, unsigned int mult,
+				    unsigned int moff)
+{
+	return (mult - ((offset - moff) % mult)) % mult;
+}
+
+static int tlv_find_next(unsigned char *tlv, unsigned int offset,
+			 unsigned int optlen)
+{
+	while (offset < optlen) {
+		switch (tlv[offset]) {
+		case IPV6_TLV_PAD1:
+			offset++;
+			break;
+		case IPV6_TLV_PADN:
+			offset += tlv[offset + 1] + 2;
+			break;
+		default:
+			return offset;
+		}
+	}
+
+	return (optlen);
+}
+
+/* __tlv_sum_alignment assumes ruc_read_lock is held */
+static size_t __tlv_sum_alignment(struct tlv_param_table *tlv_param_table,
+				  unsigned char *tlv, unsigned int offset,
+				  unsigned int optlen)
+{
+	int sum = 0;
+
+	offset = tlv_find_next(tlv, offset, optlen);
+
+	while (offset < optlen) {
+		struct tlv_tx_params *tptx;
+		struct tlv_proc *tproc;
+
+		tproc = tlv_get_proc(tlv_param_table, tlv[offset]);
+		tptx = &tproc->params.t;
+		sum += tptx->align_mult;
+		offset += tlv[offset + 1] + 2;
+		offset = tlv_find_next(tlv, offset, optlen);
+	}
+
+	return sum;
+}
+
+/* __copy_and_align_tlvs assumes rcu_read_lock is held */
+static int __copy_and_align_tlvs(struct tlv_param_table *tlv_param_table,
+				 unsigned int src_off, unsigned char *src,
+				 unsigned int dst_off, unsigned char *dst,
+				 unsigned int optlen)
+{
+	struct tlv_tx_params *tptx;
+	unsigned int padding, len;
+	struct tlv_proc *tproc;
+
+	if (!src)
+		return dst_off;
+
+	src_off = tlv_find_next(src, src_off, optlen);
+
+	while (src_off < optlen) {
+		tproc = tlv_get_proc(tlv_param_table, src[src_off]);
+		tptx = &tproc->params.t;
+
+		padding = compute_padding(dst_off, tptx->align_mult + 1,
+					  tptx->align_off);
+		ipv6_opt_tlv_pad_write(dst, dst_off, padding);
+		dst_off += padding;
+
+		len = src[src_off + 1] + 2;
+		memcpy(&dst[dst_off], &src[src_off], len);
+
+		src_off += len;
+		dst_off += len;
+		src_off = tlv_find_next(src, src_off, optlen);
+	}
+
+	return dst_off;
+}
+
+static int count_tlvs(struct ipv6_opt_hdr *opt)
+{
+	unsigned char *tlv = (unsigned char *)opt;
+	unsigned int opt_len, tlv_len, offset, cnt = 0;
+
+	opt_len = ipv6_optlen(opt);
+	offset = sizeof(*opt);
+
+	while (offset < opt_len) {
+		switch (tlv[offset]) {
+		case IPV6_TLV_PAD1:
+			tlv_len = 1;
+			break;
+		case IPV6_TLV_PADN:
+			tlv_len = tlv[offset + 1] + 2;
+			break;
+		default:
+			cnt++;
+			tlv_len = tlv[offset + 1] + 2;
+			break;
+		}
+		offset += tlv_len;
+	}
+
+	return cnt;
+}
+
+#define IPV6_OPT_MAX_END_PAD 7
+
+/**
+ * ipv6_opt_tlv_insert - Inserts a TLV into an IPv6 destination options
+ * or Hop-by-Hop options extension header.
+ *
+ * @net: Current net
+ * @opt: the original options extensions header
+ * @optname: IPV6_HOPOPTS, IPV6_RTHDRDSTOPTS, or IPV6_DSTOPTS
+ * @tlv: the new TLV being inserted
+ * @admin: Set for privileged user
+ *
+ * Description:
+ * Creates a new options header based on @opt with the specified option
+ * in @tlv option added to it.  If @opt already contains the same type
+ * of TLV, then the TLV is overwritten, otherwise the new TLV is appended
+ * after any existing TLVs.  If @opt is NULL then the new header
+ * will contain just the new option and any needed padding.
+ *
+ * Assumes option has been validated.
+ */
+struct ipv6_opt_hdr *ipv6_opt_tlv_insert(struct net *net,
+					 struct tlv_param_table
+							*tlv_param_table,
+					 struct ipv6_opt_hdr *opt, int optname,
+					 unsigned char *tlv, bool admin)
+{
+	unsigned int start = 0, end = 0, buf_len, pad, optlen,  max_align;
+	size_t tlv_len = tlv[1] + 2;
+	struct tlv_tx_params *tptx;
+	struct ipv6_opt_hdr *new;
+	struct tlv_proc *tproc;
+	int ret_val;
+	u8 perm;
+
+	rcu_read_lock();
+
+	if (opt) {
+		optlen = ipv6_optlen(opt);
+		ret_val = __ipv6_opt_tlv_find(tlv_param_table, opt,
+					      tlv, &start, &end);
+		if (ret_val < 0) {
+			if (ret_val != -ENOENT) {
+				rcu_read_unlock();
+				return ERR_PTR(ret_val);
+			}
+		} else if (((unsigned char *)opt)[ret_val + 1] == tlv[1]) {
+			unsigned int roff = ret_val + tlv[1] + 2;
+
+			if (!memcmp(&((unsigned char *)opt)[ret_val + 2],
+				    &tlv[2], tlv[1])) {
+				/* New TLV is identical to old one, just
+				 * return -EALREADY (not an error).
+				 */
+
+				rcu_read_unlock();
+				return ERR_PTR(-EALREADY);
+			}
+
+			/* Replace existing TLV with one of the same length,
+			 * we can fast path this.
+			 */
+
+			rcu_read_unlock();
+
+			new = kmalloc(optlen, GFP_ATOMIC);
+			if (!new)
+				return ERR_PTR(-ENOMEM);
+
+			memcpy((unsigned char *)new,
+			       (unsigned char *)opt, ret_val);
+			memcpy((unsigned char *)new + ret_val, tlv, tlv[1] + 2);
+			memcpy((unsigned char *)new + roff,
+			       (unsigned char *)opt + roff, optlen - roff);
+
+			return new;
+		}
+	} else {
+		optlen = 0;
+		start = sizeof(*opt);
+		end = 0;
+	}
+
+	tproc = tlv_get_proc(tlv_param_table, tlv[0]);
+	tptx = &tproc->params.t;
+
+	/* Maximum buffer size we'll need including possible padding */
+	max_align = __tlv_sum_alignment(tlv_param_table, (unsigned char *)opt,
+					end, optlen);
+	max_align += tptx->align_mult + IPV6_OPT_MAX_END_PAD;
+
+	buf_len = optlen + start - end + tlv_len + max_align;
+	new = kmalloc(buf_len, GFP_ATOMIC);
+	if (!new) {
+		rcu_read_unlock();
+		return ERR_PTR(-ENOMEM);
+	}
+
+	buf_len = start;
+
+	if (start > sizeof(*opt))
+		memcpy(new, opt, start);
+
+	pad = compute_padding(start, tptx->align_mult + 1, tptx->align_off);
+	ipv6_opt_tlv_pad_write((__u8 *)new, start, pad);
+	buf_len += pad;
+
+	memcpy((__u8 *)new + buf_len, tlv, tlv_len);
+	buf_len += tlv_len;
+
+	buf_len = __copy_and_align_tlvs(tlv_param_table, end, (__u8 *)opt,
+					buf_len, (__u8 *)new, optlen);
+
+	perm = admin ? tptx->admin_perm : tptx->user_perm;
+
+	rcu_read_unlock();
+
+	/* Trailer pad to 8 byte alignment */
+	pad = (8 - (buf_len & 7)) & 7;
+	ipv6_opt_tlv_pad_write((__u8 *)new, buf_len, pad);
+	buf_len += pad;
+
+	/* Set header */
+	new->nexthdr = 0;
+	new->hdrlen = buf_len / 8 - 1;
+
+	if (perm != IPV6_TLV_PERM_NO_CHECK) {
+		switch (optname) {
+		case IPV6_HOPOPTS:
+			if (buf_len > net->ipv6.sysctl.max_hbh_opts_len)
+				return ERR_PTR(-EMSGSIZE);
+			if (count_tlvs(new) > net->ipv6.sysctl.max_hbh_opts_cnt)
+				return ERR_PTR(-E2BIG);
+			break;
+		case IPV6_RTHDRDSTOPTS:
+		case IPV6_DSTOPTS:
+			if (buf_len > net->ipv6.sysctl.max_dst_opts_len)
+				return ERR_PTR(-EMSGSIZE);
+			if (count_tlvs(new) > net->ipv6.sysctl.max_dst_opts_cnt)
+				return ERR_PTR(-E2BIG);
+			break;
+		}
+	}
+
+	return new;
+}
+EXPORT_SYMBOL(ipv6_opt_tlv_insert);
+
+/* rcu_read_lock assume held */
+struct ipv6_opt_hdr *__ipv6_opt_tlv_delete(struct tlv_param_table
+						*tlv_param_table,
+					   struct ipv6_opt_hdr *opt,
+					   unsigned int start,
+					   unsigned int end)
+{
+	unsigned int pad, optlen, buf_len;
+	struct ipv6_opt_hdr *new;
+	size_t max_align;
+
+	optlen = ipv6_optlen(opt);
+	if (start == sizeof(*opt) && end == optlen) {
+		/* There's no other option in the header so return NULL */
+		return NULL;
+	}
+
+	max_align = __tlv_sum_alignment(tlv_param_table,
+					(unsigned char *)opt, end, optlen) +
+				IPV6_OPT_MAX_END_PAD;
+
+	new = kmalloc(optlen - (end - start) + max_align, GFP_ATOMIC);
+	if (!new)
+		return ERR_PTR(-ENOMEM); /* DIFF */
+
+	memcpy(new, opt, start);
+
+	buf_len = __copy_and_align_tlvs(tlv_param_table, end, (__u8 *)opt,
+					start, (__u8 *)new, optlen);
+
+	/* Now set trailer padding, buf_len is at the end of the last TLV at
+	 * this point
+	 */
+	pad = (8 - (buf_len & 7)) & 7;
+	ipv6_opt_tlv_pad_write((__u8 *)new, buf_len, pad);
+	buf_len += pad;
+
+	/* Set new header length */
+	new->hdrlen = buf_len / 8 - 1;
+
+	return new;
+}
+
+/**
+ * ipv6_opt_tlv_delete - Removes the specified option from the destination
+ * or Hop-by-Hop extension header.
+ * @net: Current net
+ * @opt: The original header
+ * @tlv: Prototype of TLV being removed
+ * @admin: Set for privileged user
+ *
+ * Description:
+ * Creates a new header based on @opt without the specified option in
+ * @tlv. A new options header is returned without the option. If @opt
+ * doesn't contain the specified option ERR_PTR(-ENOENT) is returned.
+ * If @opt contains no other non-padding options, NULL is returned.
+ * Otherwise, a new header is created and returned without the option
+ * (and removing as much padding as possible).
+ */
+struct ipv6_opt_hdr *ipv6_opt_tlv_delete(struct net *net,
+					 struct tlv_param_table
+						*tlv_param_table,
+					 struct ipv6_opt_hdr *opt,
+					 unsigned char *tlv, bool admin)
+{
+	struct ipv6_opt_hdr *retopt;
+	unsigned int start, end;
+	int ret_val;
+
+	rcu_read_lock();
+
+	ret_val = __ipv6_opt_tlv_find(tlv_param_table, opt, tlv, &start, &end);
+	if (ret_val < 0) {
+		rcu_read_unlock();
+		return ERR_PTR(ret_val);
+	}
+
+	retopt = __ipv6_opt_tlv_delete(tlv_param_table, opt, start, end);
+
+	rcu_read_unlock();
+
+	return retopt;
+}
+EXPORT_SYMBOL(ipv6_opt_tlv_delete);
+
 /* TLV parameter table functions and structures */
 
 static void tlv_param_table_release(struct rcu_head *rcu)
-- 
2.7.4

