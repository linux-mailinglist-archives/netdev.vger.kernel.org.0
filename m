Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40955BE082
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 16:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407600AbfIYOto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 10:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405664AbfIYOto (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 10:49:44 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA40921D7C;
        Wed, 25 Sep 2019 14:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569422983;
        bh=ykX/7+gfBHlCMayR/n2RdjILSqk1WHcSmLySayDT1kA=;
        h=From:To:Cc:Subject:Date:From;
        b=OTqtK4GNQTffjZTniJv650XBJZ/StWH/yyPqifXOd2RQLZ3hyv1y0PWqzy07vbh3G
         4oxP7cmpqvFzH//RUCEiX3hnA9u1DYm7GrtHUrtq5iKWKUl+SEBIaJv3dlyyLOf7f2
         TZfSVer35rC7F0HXF5O4ryTbqQBUp0xNW6BEhlgE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Patrick Ruddy <pruddy@vyatta.att-mail.com>
Subject: [PATCH net] vrf: Do not attempt to create IPv6 mcast rule if IPv6 is disabled
Date:   Wed, 25 Sep 2019 07:53:19 -0700
Message-Id: <20190925145319.26801-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

A user reported that vrf create fails when IPv6 is disabled at boot using
'ipv6.disable=1':
   https://bugzilla.kernel.org/show_bug.cgi?id=204903

The failure is adding fib rules at create time. Add RTNL_FAMILY_IP6MR to
the check in vrf_fib_rule if ipv6_mod_enabled is disabled.

Fixes: e4a38c0c4b27 ("ipv6: add vrf table handling code for ipv6 mcast")
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Patrick Ruddy <pruddy@vyatta.att-mail.com>
---
 drivers/net/vrf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 6e84328bdd40..a4b38a980c3c 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1154,7 +1154,8 @@ static int vrf_fib_rule(const struct net_device *dev, __u8 family, bool add_it)
 	struct sk_buff *skb;
 	int err;
 
-	if (family == AF_INET6 && !ipv6_mod_enabled())
+	if ((family == AF_INET6 || family == RTNL_FAMILY_IP6MR) &&
+	    !ipv6_mod_enabled())
 		return 0;
 
 	skb = nlmsg_new(vrf_fib_rule_nl_size(), GFP_KERNEL);
-- 
2.11.0

