Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAF03E363C
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhHGQBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 12:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230332AbhHGQBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 12:01:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2124460E93;
        Sat,  7 Aug 2021 16:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628352078;
        bh=917vbVCJXDxDQWlScnrHlQPR9z35WOCIibIa/BrFdXk=;
        h=From:To:Cc:Subject:Date:From;
        b=ENfiSdB0YnZ3mKmzaURt6FQTJzF4idehwLIvZD0ltEofw2tR+D+xZCivfD3XUiuRs
         8lZXzO7NxwG08K+nuVweDSgU7yiKqsjZ6rzsEX6NKJ/7j0j0EutapKsqP3TJPgb1J6
         yMb8OvASumdOSSCkcn8kmpAlNJAaOFbzUs6T2IWGmJLJQKJHcnjjLk1B5xDiZdUC9V
         QGLZ602rpG9HoHA8ZnGXGz7ZWW35Vo7OgQg3RCb6U/vlkv/WEEThU1piOaDPjfdZDx
         yz1JEG0J4XQzQJSy0Ci3FrQn7CkMLX6uhpGYUcZszhkCTAG565Vf1Q6XnN52pEihMC
         lkF9D8SO3/baQ==
Received: by pali.im (Postfix)
        id C9230A52; Sat,  7 Aug 2021 18:01:15 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <g.nault@alphalink.fr>
Cc:     linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ppp: Fix generating ppp unit id when ifname is not specified
Date:   Sat,  7 Aug 2021 18:00:50 +0200
Message-Id: <20210807160050.17687-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When registering new ppp interface via PPPIOCNEWUNIT ioctl then kernel has
to choose interface name as this ioctl API does not support specifying it.

Kernel in this case register new interface with name "ppp<id>" where <id>
is the ppp unit id, which can be obtained via PPPIOCGUNIT ioctl. This
applies also in the case when registering new ppp interface via rtnl
without supplying IFLA_IFNAME.

PPPIOCNEWUNIT ioctl allows to specify own ppp unit id which will kernel
assign to ppp interface, in case this ppp id is not already used by other
ppp interface.

In case user does not specify ppp unit id then kernel choose the first free
ppp unit id. This applies also for case when creating ppp interface via
rtnl method as it does not provide a way for specifying own ppp unit id.

If some network interface (does not have to be ppp) has name "ppp<id>"
with this first free ppp id then PPPIOCNEWUNIT ioctl or rtnl call fails.

And registering new ppp interface is not possible anymore, until interface
which holds conflicting name is renamed. Or when using rtnl method with
custom interface name in IFLA_IFNAME.

As list of allocated / used ppp unit ids is not possible to retrieve from
kernel to userspace, userspace has no idea what happens nor which interface
is doing this conflict.

So change the algorithm how ppp unit id is generated. And choose the first
number which is not neither used as ppp unit id nor in some network
interface with pattern "ppp<id>".

This issue can be simply reproduced by following pppd call when there is no
ppp interface registered and also no interface with name pattern "ppp<id>":

    pppd ifname ppp1 +ipv6 noip noauth nolock local nodetach pty "pppd +ipv6 noip noauth nolock local nodetach notty"

Or by creating the one ppp interface (which gets assigned ppp unit id 0),
renaming it to "ppp1" and then trying to create a new ppp interface (which
will always fails as next free ppp unit id is 1, but network interface with
name "ppp1" exists).

This patch fixes above described issue by generating new and new ppp unit
id until some non-conflicting id with network interfaces is generated.

Signed-off-by: Pali Rohár <pali@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/net/ppp/ppp_generic.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 1c6ba5a5e081..9506abd8d7e1 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -284,7 +284,7 @@ static struct channel *ppp_find_channel(struct ppp_net *pn, int unit);
 static int ppp_connect_channel(struct channel *pch, int unit);
 static int ppp_disconnect_channel(struct channel *pch);
 static void ppp_destroy_channel(struct channel *pch);
-static int unit_get(struct idr *p, void *ptr);
+static int unit_get(struct idr *p, void *ptr, int min);
 static int unit_set(struct idr *p, void *ptr, int n);
 static void unit_put(struct idr *p, int n);
 static void *unit_find(struct idr *p, int n);
@@ -1155,9 +1155,20 @@ static int ppp_unit_register(struct ppp *ppp, int unit, bool ifname_is_set)
 	mutex_lock(&pn->all_ppp_mutex);
 
 	if (unit < 0) {
-		ret = unit_get(&pn->units_idr, ppp);
+		ret = unit_get(&pn->units_idr, ppp, 0);
 		if (ret < 0)
 			goto err;
+		if (!ifname_is_set) {
+			while (1) {
+				snprintf(ppp->dev->name, IFNAMSIZ, "ppp%i", ret);
+				if (!__dev_get_by_name(ppp->ppp_net, ppp->dev->name))
+					break;
+				unit_put(&pn->units_idr, ret);
+				ret = unit_get(&pn->units_idr, ppp, ret + 1);
+				if (ret < 0)
+					goto err;
+			}
+		}
 	} else {
 		/* Caller asked for a specific unit number. Fail with -EEXIST
 		 * if unavailable. For backward compatibility, return -EEXIST
@@ -3530,9 +3541,9 @@ static int unit_set(struct idr *p, void *ptr, int n)
 }
 
 /* get new free unit number and associate pointer with it */
-static int unit_get(struct idr *p, void *ptr)
+static int unit_get(struct idr *p, void *ptr, int min)
 {
-	return idr_alloc(p, ptr, 0, 0, GFP_KERNEL);
+	return idr_alloc(p, ptr, min, 0, GFP_KERNEL);
 }
 
 /* put unit number back to a pool */
-- 
2.20.1

