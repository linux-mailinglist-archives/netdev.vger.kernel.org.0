Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0736D13C7FC
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgAOPge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:36:34 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60450 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726474AbgAOPgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 10:36:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579102592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XTzpmXKsI8vbK6lJ/xODMRUILM7vu+rB2h1CtKsvyvs=;
        b=MV8r6nMIVupWCxmJ7cOqQqPJFbBIL+/4PmxZ0xVCih5mm9jkx4TfEQWHIBRaqz8Lpply4o
        WjZEtk5glUFNhN18S0RGCluExeDqdlKWiSHCG7BPRO6i1u7dzR4uQoV4T92xsK5b0W4crQ
        7ZvEb7k0kAridSbRsGpaFGovI7gctD0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-gUAG5F8uMNycqlitrB3eYA-1; Wed, 15 Jan 2020 10:36:31 -0500
X-MC-Unique: gUAG5F8uMNycqlitrB3eYA-1
Received: by mail-wr1-f69.google.com with SMTP id z14so8212075wrs.4
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 07:36:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XTzpmXKsI8vbK6lJ/xODMRUILM7vu+rB2h1CtKsvyvs=;
        b=AVUMAMiwWMmJTjaV/TRvdCIKJBISm0P7zu8c3oOChL68D/STWWvWfBCw4YOyq5DKHT
         eY9hiCgxC6s+2W0Aa7bVDR1rQigIajagQyawB9GGIZhqSCesEfv6yxZJ54zqM3NBkHSG
         9FlTB4uRkhE9m4HHCtv1n0ueRmEn9vCglie32KogH8rBZkA6gLovLB3mU9xgtAzYuX18
         Kz5Fx5K4VQge/pYIVRk+TYDSQODLCEXcTCo6Nuc9gPngAY8FRrYE9rI2AeaKk21D+5Ty
         0VOmugUZVh9dQ6vOPQJMHF+XSfkkfwjig9A62xjELp+Ovl/smAT62lseygNin2dEKaxS
         rX+w==
X-Gm-Message-State: APjAAAWbC5W6thmzhRXfoTGxZgqICq4nCUtkUEEPqm09S11qanVrIMva
        0lv90U8SqZLS8T651UDZycnx52YeqblHbQ0H7+WzqwTYHGGxZlKk7RYXXDTTeGxGSRnoT2Wm3/u
        oQlXVqQMvmdFIrRRs
X-Received: by 2002:a1c:9c4c:: with SMTP id f73mr358209wme.125.1579102590018;
        Wed, 15 Jan 2020 07:36:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqx2oNnS49ZW+I5NBE9z3xwIvItJ57RxfGoDtxq5ukRcztatw+13PbyECfZXXQVYqx5Gsilmlg==
X-Received: by 2002:a1c:9c4c:: with SMTP id f73mr358186wme.125.1579102589802;
        Wed, 15 Jan 2020 07:36:29 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id x11sm25682978wre.68.2020.01.15.07.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 07:36:29 -0800 (PST)
Date:   Wed, 15 Jan 2020 16:36:27 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next v2 1/2] netns: Parse *_PID and *_FD netlink
 attributes as signed integers
Message-ID: <9a4228356eaa5c8db653c43467526a0dbd00ce30.1579102319.git.gnault@redhat.com>
References: <cover.1579102319.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1579102319.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These attributes represent signed values (file descriptors and PIDs).
Make that clear in nla_policy.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/core/net_namespace.c | 12 ++++++------
 net/core/rtnetlink.c     |  8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 6412c1fbfcb5..85c565571c1c 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -706,8 +706,8 @@ static struct pernet_operations __net_initdata net_ns_ops = {
 static const struct nla_policy rtnl_net_policy[NETNSA_MAX + 1] = {
 	[NETNSA_NONE]		= { .type = NLA_UNSPEC },
 	[NETNSA_NSID]		= { .type = NLA_S32 },
-	[NETNSA_PID]		= { .type = NLA_U32 },
-	[NETNSA_FD]		= { .type = NLA_U32 },
+	[NETNSA_PID]		= { .type = NLA_S32 },
+	[NETNSA_FD]		= { .type = NLA_S32 },
 	[NETNSA_TARGET_NSID]	= { .type = NLA_S32 },
 };
 
@@ -731,10 +731,10 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	nsid = nla_get_s32(tb[NETNSA_NSID]);
 
 	if (tb[NETNSA_PID]) {
-		peer = get_net_ns_by_pid(nla_get_u32(tb[NETNSA_PID]));
+		peer = get_net_ns_by_pid(nla_get_s32(tb[NETNSA_PID]));
 		nla = tb[NETNSA_PID];
 	} else if (tb[NETNSA_FD]) {
-		peer = get_net_ns_by_fd(nla_get_u32(tb[NETNSA_FD]));
+		peer = get_net_ns_by_fd(nla_get_s32(tb[NETNSA_FD]));
 		nla = tb[NETNSA_FD];
 	} else {
 		NL_SET_ERR_MSG(extack, "Peer netns reference is missing");
@@ -874,10 +874,10 @@ static int rtnl_net_getid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 	if (tb[NETNSA_PID]) {
-		peer = get_net_ns_by_pid(nla_get_u32(tb[NETNSA_PID]));
+		peer = get_net_ns_by_pid(nla_get_s32(tb[NETNSA_PID]));
 		nla = tb[NETNSA_PID];
 	} else if (tb[NETNSA_FD]) {
-		peer = get_net_ns_by_fd(nla_get_u32(tb[NETNSA_FD]));
+		peer = get_net_ns_by_fd(nla_get_s32(tb[NETNSA_FD]));
 		nla = tb[NETNSA_FD];
 	} else if (tb[NETNSA_NSID]) {
 		peer = get_net_ns_by_id(net, nla_get_s32(tb[NETNSA_NSID]));
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 20bc406f3871..9b5419a7bd74 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1794,8 +1794,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_OPERSTATE]	= { .type = NLA_U8 },
 	[IFLA_LINKMODE]		= { .type = NLA_U8 },
 	[IFLA_LINKINFO]		= { .type = NLA_NESTED },
-	[IFLA_NET_NS_PID]	= { .type = NLA_U32 },
-	[IFLA_NET_NS_FD]	= { .type = NLA_U32 },
+	[IFLA_NET_NS_PID]	= { .type = NLA_S32 },
+	[IFLA_NET_NS_FD]	= { .type = NLA_S32 },
 	/* IFLA_IFALIAS is a string, but policy is set to NLA_BINARY to
 	 * allow 0-length string (needed to remove an alias).
 	 */
@@ -2118,9 +2118,9 @@ struct net *rtnl_link_get_net(struct net *src_net, struct nlattr *tb[])
 	 * network namespace we are talking about.
 	 */
 	if (tb[IFLA_NET_NS_PID])
-		net = get_net_ns_by_pid(nla_get_u32(tb[IFLA_NET_NS_PID]));
+		net = get_net_ns_by_pid(nla_get_s32(tb[IFLA_NET_NS_PID]));
 	else if (tb[IFLA_NET_NS_FD])
-		net = get_net_ns_by_fd(nla_get_u32(tb[IFLA_NET_NS_FD]));
+		net = get_net_ns_by_fd(nla_get_s32(tb[IFLA_NET_NS_FD]));
 	else
 		net = get_net(src_net);
 	return net;
-- 
2.21.1

