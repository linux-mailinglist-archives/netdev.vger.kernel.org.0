Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D4B27F3EC
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730671AbgI3VH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:07:28 -0400
Received: from mail.katalix.com ([3.9.82.81]:34402 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgI3VH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 17:07:27 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id CF33696D66;
        Wed, 30 Sep 2020 22:07:24 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1601500044; bh=1emQyYshhuLkvUnIL3MK13P5S2Hjw+FNAtJNuWACqNE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=203/6]=20l2tp:=20allo
         w=20v2=20netlink=20session=20create=20to=20pass=20ifname=20attribu
         te|Date:=20Wed,=2030=20Sep=202020=2022:07:04=20+0100|Message-Id:=2
         0<20200930210707.10717-4-tparkin@katalix.com>|In-Reply-To:=20<2020
         0930210707.10717-1-tparkin@katalix.com>|References:=20<20200930210
         707.10717-1-tparkin@katalix.com>;
        b=y4g85jB6zD0mawZPIuvhPWGLskxWOeca2eiTfb69PJvTkrwFN7k7lTF/i4fl585bQ
         mRVCQihfKWfQpkZ1QpmXN5SpTq2AWkz7xcVTSDaW5LbJrMO0tAqTemrWYadFrCeNSl
         xhwL1zYMo+Mx/NU1WzGV57HflCCDNamUABa24qQ7yUFTAZZpXPtAH/5CSPQcHLs7iF
         7EIZhTs5wMUiuzpuszsIhtHUJAxyUvJxrSlFGVknvOzOjD/ehzrE/CZIiYT4LFNk7C
         EUeYl0L2r8oDz3xiGcl7DbkKjDQsjWDeLjBblCklf91C6f6Js05ka1viBzguClaXRE
         PUKA/Iy8vaY/g==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 3/6] l2tp: allow v2 netlink session create to pass ifname attribute
Date:   Wed, 30 Sep 2020 22:07:04 +0100
Message-Id: <20200930210707.10717-4-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930210707.10717-1-tparkin@katalix.com>
References: <20200930210707.10717-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously L2TP_ATTR_IFNAME was only applicable to an L2TPv3 session,
since it was only used by l2tp_eth.

In order to implement an AC_PPP pseudowire in an L2TPv2 tunnel, it will
be necessary to allow userspace to send an interface name in the session
create message.

Allow the attribute to be handled by l2tp_netlink for L2TPv2 sessions.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_netlink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 8ef1a579a2b1..2abfea82203d 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -604,10 +604,11 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 			cfg.peer_cookie_len = len;
 			memcpy(&cfg.peer_cookie[0], nla_data(info->attrs[L2TP_ATTR_PEER_COOKIE]), len);
 		}
-		if (info->attrs[L2TP_ATTR_IFNAME])
-			cfg.ifname = nla_data(info->attrs[L2TP_ATTR_IFNAME]);
 	}
 
+	if (info->attrs[L2TP_ATTR_IFNAME])
+		cfg.ifname = nla_data(info->attrs[L2TP_ATTR_IFNAME]);
+
 	if (info->attrs[L2TP_ATTR_RECV_SEQ])
 		cfg.recv_seq = nla_get_u8(info->attrs[L2TP_ATTR_RECV_SEQ]);
 
-- 
2.17.1

