Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F167E27F3E8
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730721AbgI3VH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730649AbgI3VH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 17:07:26 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24F70C0613D0
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 14:07:25 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id F2A9D96D70;
        Wed, 30 Sep 2020 22:07:24 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1601500045; bh=Rn5yOXFMVzgvhPNX/NI+5CJa37P/ee4dJ8DBbhJQv+M=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=204/6]=20l2tp:=20add=
         20netlink=20attributes=20for=20ac_ppp=20session=20creation|Date:=2
         0Wed,=2030=20Sep=202020=2022:07:05=20+0100|Message-Id:=20<20200930
         210707.10717-5-tparkin@katalix.com>|In-Reply-To:=20<20200930210707
         .10717-1-tparkin@katalix.com>|References:=20<20200930210707.10717-
         1-tparkin@katalix.com>;
        b=2vzMBA6dz6jVsIXO1ZGHgJt2wABJBzUKQ7OiJD222/W7Q/5lAupsntpXolveQTfIP
         QMdVgjb0eG8BNiOXFsMyq2U00gWqu2HB/E8QSEZrP54NfcN0iiGk2VUBa2ZzqUNsMf
         f3TxGs6unq6q0f4ZRsYDmkIDDwxg9vJYVK/XWlFWVfvP9w9/CrflgIJaV8/DZyJUmH
         5WL5Tq/BWPr3XBOEEWaefUBc8mYvMyp6Yck1NTq49auTKBP2nFmN/v7X555BMCwmJu
         lfnRY+HfAgZ1oOrJ+L2NfWYyiYYz0CXSZw5d/Cdx22isS36yfMOOTpVL5kAuNJuRY8
         zTpQVKlIwkVuw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 4/6] l2tp: add netlink attributes for ac_ppp session creation
Date:   Wed, 30 Sep 2020 22:07:05 +0100
Message-Id: <20200930210707.10717-5-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930210707.10717-1-tparkin@katalix.com>
References: <20200930210707.10717-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AC PPPoE driver will require userspace to pass in both the PPPoE
session ID and the PPPoE peer's MAC address.

Add netlink attributes to allow this to be conveyed in the session
create command.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 include/uapi/linux/l2tp.h | 2 ++
 net/l2tp/l2tp_netlink.c   | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/l2tp.h b/include/uapi/linux/l2tp.h
index 30c80d5ba4bf..04e23b34669e 100644
--- a/include/uapi/linux/l2tp.h
+++ b/include/uapi/linux/l2tp.h
@@ -127,6 +127,8 @@ enum {
 	L2TP_ATTR_UDP_ZERO_CSUM6_TX,	/* flag */
 	L2TP_ATTR_UDP_ZERO_CSUM6_RX,	/* flag */
 	L2TP_ATTR_PAD,
+	L2TP_ATTR_PPPOE_SESSION_ID,	/* u16 */
+	L2TP_ATTR_PPPOE_PEER_MAC_ADDR,  /* 6 bytes */
 	__L2TP_ATTR_MAX,
 };
 
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 2abfea82203d..7050e8e5886e 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -920,6 +920,8 @@ static const struct nla_policy l2tp_nl_policy[L2TP_ATTR_MAX + 1] = {
 		.type = NLA_BINARY,
 		.len = 8,
 	},
+	[L2TP_ATTR_PPPOE_SESSION_ID]	= { .type = NLA_U16, },
+	[L2TP_ATTR_PPPOE_PEER_MAC_ADDR] = NLA_POLICY_ETH_ADDR,
 };
 
 static const struct genl_ops l2tp_nl_ops[] = {
-- 
2.17.1

