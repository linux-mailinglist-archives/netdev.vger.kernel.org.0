Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0CE6ED2A
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 01:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfD2XFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 19:05:02 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:50528 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbfD2XFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 19:05:00 -0400
Received: by mail-it1-f196.google.com with SMTP id q14so1799554itk.0
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 16:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YSIgnIty7ccXskGJtT8LdJlxc5XCeQS4PGqykBNvmSs=;
        b=gMTJ68sb9kbqJo1T25EvPsjjsMAkOOFtSXJm78uhdfDz2gRMnP1PdktaoR/GWJik9d
         eJB7qY8RjXTVh0KyGbPWjm3iMTYJFz133TSjs66A2095/Bf5gNR46XTn8hafq6UNp0Bn
         fzGBWJakM3WRWtbhTQMICLljk5urQCCwdEmvr6nE36EwTlBYWqT9dtIdNcivZPbW2zxV
         M3ceW64Ow1KwCqxdoaxNaqC1kEhotFKz7XSS3L0Rgwxy1Fza1E8XzPBGSeMMglrzJvPo
         5nkp/5fHAcGVxTcI1cfnAtaxBjVPl2oaGz7P4OEerEwaiaJ+feYPHfQOzZ80IV3u8HJy
         PD2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YSIgnIty7ccXskGJtT8LdJlxc5XCeQS4PGqykBNvmSs=;
        b=VIOJotwm9r/05sdX3tZO9JOf1+qeHnyfb57TsW2tvpFb0kPgtXW2JgyHA7YLZB0I64
         /TzElaVQHdVfc9RTjWoV01vjL/b2lc4m9CdSkHtBR5MN/dNo/bGKg7K9oHarSw30o23i
         cgXUTxqRRS10fDgPn1m4xjUbOWfAP5WKzTXBOmd0a8K7I2HRolnKwEQg9trvEQq9eRXa
         4T058DXkzuvwF6Np5OcSmGe0Jz7iolKe3MWKjmqnjAyUGwoLA1nLycDq68rDdt0Zaif9
         OkiLHkmot0fEOWs0l3X0T8st3b0rqPV+JXMJXc2AydbatnApkYfZpk0bmmD+3S+aZ+bm
         tKmw==
X-Gm-Message-State: APjAAAXQe0dthbbOFi7WwYIjPdTvJJDFTzjlMuHrclGQhUz26a39BuQa
        4CmPs3w2k0jIr24giMX/elegzapVB1M=
X-Google-Smtp-Source: APXvYqzzpxae/yjGC5fuCB+M3CspFT/PrshEd/YPdvwTkNlxCJCJ1rkElsSSF8+oPPMKs/Cxe8N/tA==
X-Received: by 2002:a24:ad5f:: with SMTP id a31mr1414530itj.55.1556579099190;
        Mon, 29 Apr 2019 16:04:59 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id y62sm340626itg.13.2019.04.29.16.04.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 16:04:58 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v8 net-next 8/8] ipv6tlvs: API for manipuateling TLVs on a connect socket
Date:   Mon, 29 Apr 2019 16:04:23 -0700
Message-Id: <1556579063-1367-9-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556579063-1367-1-git-send-email-tom@quantonium.net>
References: <1556579063-1367-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides an interface for adding a deleting
individual Hop-by-Hop or Destination Options on a socket.

The following IPv6 socket options are created:
	IPV6_HOPOPTS_TLV
	IPV6_RTHDRDSTOPTS_TLV
	IPV6_DSTOPTS_TLV
	IPV6_HOPOPTS_DEL_TLV
	IPV6_RTHDRDSTOPTS_DEL_TLV
	IPV6_DSTOPTS_DEL_TLV

The function txoptions_from_tlv_opt does the heavy lifting to
copy an options from userspace, validate the option, and call
insert of delete TLV function.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/net/ipv6.h        |  7 +++++
 include/uapi/linux/in6.h  |  9 ++++++
 net/ipv6/exthdrs_common.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/ipv6_sockglue.c  | 27 ++++++++++++++++++
 4 files changed, 113 insertions(+)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index bf6e593f..6aa4d8f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -529,6 +529,13 @@ struct ipv6_txoptions *txoptions_from_opt(struct sock *sk,
 					  unsigned int max_len,
 					  unsigned int max_cnt);
 
+struct ipv6_opt_hdr *txoptions_from_tlv_opt(struct sock *sk,
+					    struct tlv_param_table
+						*tlv_param_table,
+					    struct ipv6_txoptions *opt,
+					    int optname, char __user *optval,
+					    unsigned int optlen, int *which);
+
 static inline bool ipv6_accept_ra(struct inet6_dev *idev)
 {
 	/* If forwarding is enabled, RA are not accepted unless the special
diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
index 1c79361..018fc6f 100644
--- a/include/uapi/linux/in6.h
+++ b/include/uapi/linux/in6.h
@@ -289,6 +289,15 @@ struct in6_flowlabel_req {
 #define IPV6_RECVFRAGSIZE	77
 #define IPV6_FREEBIND		78
 
+/* API to set single Destination or Hop-by-Hop options */
+
+#define IPV6_HOPOPTS_TLV               79
+#define IPV6_RTHDRDSTOPTS_TLV          80
+#define IPV6_DSTOPTS_TLV               81
+#define IPV6_HOPOPTS_DEL_TLV           82
+#define IPV6_RTHDRDSTOPTS_DEL_TLV      83
+#define IPV6_DSTOPTS_DEL_TLV           84
+
 /*
  * Multicast Routing:
  * see include/uapi/linux/mroute6.h.
diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
index 8acff49..9e9ad85 100644
--- a/net/ipv6/exthdrs_common.c
+++ b/net/ipv6/exthdrs_common.c
@@ -1272,6 +1272,76 @@ struct ipv6_txoptions *txoptions_from_opt(struct sock *sk,
 }
 EXPORT_SYMBOL(txoptions_from_opt);
 
+struct ipv6_opt_hdr *txoptions_from_tlv_opt(struct sock *sk,
+					    struct tlv_param_table
+							*tlv_param_table,
+					     struct ipv6_txoptions *opt,
+					     int optname, char __user *optval,
+					     unsigned int optlen, int *whichp)
+{
+	struct ipv6_opt_hdr *old = NULL, *new = NULL;
+	struct net *net = sock_net(sk);
+	bool deleting = false;
+	void *new_opt = NULL;
+	int which = -1, retv;
+	bool admin;
+
+	new_opt = memdup_user(optval, optlen);
+	if (IS_ERR(new_opt))
+		return new_opt;
+
+	switch (optname) {
+	case IPV6_HOPOPTS_DEL_TLV:
+		deleting = true;
+		/* Fallthrough */
+	case IPV6_HOPOPTS_TLV:
+		if (opt)
+			old = opt->hopopt;
+		which = IPV6_HOPOPTS;
+		break;
+	case IPV6_RTHDRDSTOPTS_DEL_TLV:
+		deleting = true;
+		/* Fallthrough */
+	case IPV6_RTHDRDSTOPTS_TLV:
+		if (opt)
+			old = opt->dst0opt;
+		which = IPV6_RTHDRDSTOPTS;
+		break;
+	case IPV6_DSTOPTS_DEL_TLV:
+		deleting = true;
+		/* Fallthrough */
+	case IPV6_DSTOPTS_TLV:
+		if (opt)
+			old = opt->dst1opt;
+		which = IPV6_DSTOPTS;
+		break;
+	}
+
+	*whichp = which;
+
+	admin = ns_capable(net->user_ns, CAP_NET_RAW);
+
+	retv = ipv6_opt_validate_single_tlv(net, tlv_param_table, which,
+					    new_opt, optlen, deleting, admin);
+	if (retv < 0)
+		return ERR_PTR(retv);
+
+	if (deleting) {
+		if (!old)
+			return NULL;
+		new = ipv6_opt_tlv_delete(net, tlv_param_table, old, new_opt,
+					  admin);
+	} else {
+		new = ipv6_opt_tlv_insert(net, tlv_param_table, old, which,
+					  new_opt, admin);
+	}
+
+	kfree(new_opt);
+
+	return new;
+}
+EXPORT_SYMBOL(txoptions_from_tlv_opt);
+
 const struct nla_policy tlv_nl_policy[IPV6_TLV_ATTR_MAX + 1] = {
 	[IPV6_TLV_ATTR_TYPE] =		{ .type = NLA_U8, },
 	[IPV6_TLV_ATTR_ORDER] =		{ .type = NLA_U8, },
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index b8ef0ea..3e4c0eb 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -476,6 +476,33 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		break;
 	}
 
+	case IPV6_HOPOPTS_TLV:
+	case IPV6_RTHDRDSTOPTS_TLV:
+	case IPV6_DSTOPTS_TLV:
+	case IPV6_HOPOPTS_DEL_TLV:
+	case IPV6_RTHDRDSTOPTS_DEL_TLV:
+	case IPV6_DSTOPTS_DEL_TLV:
+	{
+		struct ipv6_txoptions *opt;
+		struct ipv6_opt_hdr *new;
+		int which;
+
+		opt = rcu_dereference_protected(np->opt,
+						lockdep_sock_is_held(sk));
+		new = txoptions_from_tlv_opt(sk, &ipv6_tlv_param_table, opt,
+					     optname, optval, optlen, &which);
+		if (IS_ERR(new)) {
+			retv = PTR_ERR(new);
+			break;
+		}
+
+		retv = ipv6_opt_update(sk, opt, which, new);
+
+		kfree(new);
+
+		break;
+	}
+
 	case IPV6_PKTINFO:
 	{
 		struct in6_pktinfo pkt;
-- 
2.7.4

