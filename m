Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2A320644
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfEPLtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbfEPLjm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:39:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAF4A2089E;
        Thu, 16 May 2019 11:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006781;
        bh=Y/d90KxI5yg16CDsboELRhVC+mwoMNNnrNRWxrVu71I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FEYQTekzErjMpJSn6cH1KuITJw3BSq27i/O3c3jBB4r3lPZGpoBgYtgGcZmSOpXlz
         EpzMIMnimTz4B1oVgEjsD0zKmpBu5n8Y3Q7W21r3xBEsGoS8RnUTqqEcKaSOzJqc8I
         oAGAODMPz8Etx7hX1KBc2jTOT334CYKTTbqvGiJQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Willi <martin@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 07/34] xfrm: Honor original L3 slave device in xfrmi policy lookup
Date:   Thu, 16 May 2019 07:39:04 -0400
Message-Id: <20190516113932.8348-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516113932.8348-1-sashal@kernel.org>
References: <20190516113932.8348-1-sashal@kernel.org>
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
index 902437dfbce77..c9b0b2b5d672f 100644
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
index dbb3c1945b5c9..85fec98676d34 100644
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
index 8d1a898d0ba56..a6b58df7a70f6 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3313,7 +3313,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 	ifcb = xfrm_if_get_cb();
 
 	if (ifcb) {
-		xi = ifcb->decode_session(skb);
+		xi = ifcb->decode_session(skb, family);
 		if (xi) {
 			if_id = xi->p.if_id;
 			net = xi->net;
-- 
2.20.1

