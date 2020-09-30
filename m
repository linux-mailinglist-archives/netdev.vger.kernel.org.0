Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDCB27F3EB
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbgI3VH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730646AbgI3VH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 17:07:26 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FF3EC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 14:07:25 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id AD15996D50;
        Wed, 30 Sep 2020 22:07:24 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1601500044; bh=aaiQdAHnkH7TISTywwUBYFxIWXL1JfZnCQEZiP3KluM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=202/6]=20l2tp:=20twea
         k=20netlink=20session=20create=20to=20allow=20L2TPv2=20ac_pppoe|Da
         te:=20Wed,=2030=20Sep=202020=2022:07:03=20+0100|Message-Id:=20<202
         00930210707.10717-3-tparkin@katalix.com>|In-Reply-To:=20<202009302
         10707.10717-1-tparkin@katalix.com>|References:=20<20200930210707.1
         0717-1-tparkin@katalix.com>;
        b=DNX4zcsvRV37eArfVjUPtCnuRf67X7s9gRrgvIxSlJIXNqbEf/B/pB4i2FV5ROzlc
         DlR3ODkUwWOsmFHC3fJMmFMhaujrsV0K9as61cUJ8Uf0mCatzbdJSW7ERN5Pvm0sf4
         OXg+eVBw7eh5aIbhht9rE2Jjxc17tHpHBFkgvGafv72jNmUaZXg7JjPjwXL8qzny6A
         /8xK5NxLYcMjFfi/MOXel8Rgpyq5piCw4zh9l/Q1CoyUHhr3u02wCjPv4k/xkSeNNV
         FN+OXboDZnQCMrna/hxHe6zYH9HIMA4rHNeVAyygnogWaqSdFaXHl9Z9DkanCv7ehs
         98lgrwU19GtIg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 2/6] l2tp: tweak netlink session create to allow L2TPv2 ac_pppoe
Date:   Wed, 30 Sep 2020 22:07:03 +0100
Message-Id: <20200930210707.10717-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930210707.10717-1-tparkin@katalix.com>
References: <20200930210707.10717-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating a session in an L2TPv2 tunnel, l2tp_netlink performs
some sanity checking of pseudowire type to prevent L2TPv3 pseudowires
from being instantiated in L2TPv2 tunnels.

To support PPPoE access concentrator functionality the L2TP subsystem
should allow PPP_AC pseudowires to be created in L2TPv2 tunnels.

Extend the l2tp_netlink sanity check to support PPP_AC.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_netlink.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 7045eb105e6a..8ef1a579a2b1 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -560,8 +560,14 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 		goto out_tunnel;
 	}
 
-	/* L2TPv2 only accepts PPP pseudo-wires */
-	if (tunnel->version == 2 && cfg.pw_type != L2TP_PWTYPE_PPP) {
+	/* L2TPv2 only accepts PPP pseudowires, which may be identified as
+	 * either L2TP_PWTYPE_PPP for locally-terminating PPP sessions, or
+	 * L2TP_PWTYPE_PPP_AC for the Access Concentrator case where the PPP
+	 * session is passed through the tunnel for remote termination.
+	 */
+	if (tunnel->version == 2 &&
+	    cfg.pw_type != L2TP_PWTYPE_PPP &&
+	    cfg.pw_type != L2TP_PWTYPE_PPP_AC) {
 		ret = -EPROTONOSUPPORT;
 		goto out_tunnel;
 	}
-- 
2.17.1

