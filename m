Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27ED120612
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfEPLqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727797AbfEPLki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:40:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C95D20833;
        Thu, 16 May 2019 11:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006837;
        bh=tbOjMBMj6sA81jPJRxjoqNZV/rUdTrG1WpStJ306LTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=On1jKOREpnGL7hakuAW9OPVWR9PWM0Hv8Gzjol+eMIzdsjvA0FypNVyhJafoxzwzS
         kX6I3vx7ufPDA1iLgqOIyx1Om2V8mN13wZkqrAIQ9q3ZqxPZU6dpt8hsIE7C0LeR/Q
         eipgX3lc72N3cFwi/I+mj5R5Y/jUHp5Td3xGyk5I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Willi <martin@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/25] xfrm: Honor original L3 slave device in xfrmi policy lookup
Date:   Thu, 16 May 2019 07:40:09 -0400
Message-Id: <20190516114029.8682-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114029.8682-1-sashal@kernel.org>
References: <20190516114029.8682-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Willi <martin@strongswan.org>

[ Upstream commit 025c65e119bf58b610549ca359c9ecc5dee6a8d2 ]

If an xfrmi is associated to a vrf layer 3 master device,
xfrm_policy_check() fails after traffic decapsulation. The input
interface is replaced by the layer 3 master device, and hence
xfrmi_decode_session() can't match the xfrmi anymore to satisfy
policy checking.

Extend ingress xfrmi lookup to honor the original layer 3 slave
device, allowing xfrm interfaces to operate within a vrf domain.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Martin Willi <martin@strongswan.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h        |  3 ++-
 net/xfrm/xfrm_interface.c | 17 ++++++++++++++---
 net/xfrm/xfrm_policy.c    |  2 +-
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 3e966c632f3b2..4ddd2b13ac8d6 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -295,7 +295,8 @@ struct xfrm_replay {
 };
 
 struct xfrm_if_cb {
-	struct xfrm_if	*(*decode_session)(struct sk_buff *skb);
+	struct xfrm_if	*(*decode_session)(struct sk_buff *skb,
+					   unsigned short family);
 };
 
 void xfrm_if_register_cb(const struct xfrm_if_cb *ifcb);
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 82723ef44db3e..555ee2aca6c01 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -70,17 +70,28 @@ static struct xfrm_if *xfrmi_lookup(struct net *net, struct xfrm_state *x)
 	return NULL;
 }
 
-static struct xfrm_if *xfrmi_decode_session(struct sk_buff *skb)
+static struct xfrm_if *xfrmi_decode_session(struct sk_buff *skb,
+					    unsigned short family)
 {
 	struct xfrmi_net *xfrmn;
-	int ifindex;
 	struct xfrm_if *xi;
+	int ifindex = 0;
 
 	if (!secpath_exists(skb) || !skb->dev)
 		return NULL;
 
+	switch (family) {
+	case AF_INET6:
+		ifindex = inet6_sdif(skb);
+		break;
+	case AF_INET:
+		ifindex = inet_sdif(skb);
+		break;
+	}
+	if (!ifindex)
+		ifindex = skb->dev->ifindex;
+
 	xfrmn = net_generic(xs_net(xfrm_input_state(skb)), xfrmi_net_id);
-	ifindex = skb->dev->ifindex;
 
 	for_each_xfrmi_rcu(xfrmn->xfrmi[0], xi) {
 		if (ifindex == xi->dev->ifindex &&
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index bf5d59270f79d..ce1b262ce9646 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2339,7 +2339,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 	ifcb = xfrm_if_get_cb();
 
 	if (ifcb) {
-		xi = ifcb->decode_session(skb);
+		xi = ifcb->decode_session(skb, family);
 		if (xi) {
 			if_id = xi->p.if_id;
 			net = xi->net;
-- 
2.20.1

