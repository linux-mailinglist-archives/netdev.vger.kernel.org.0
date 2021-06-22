Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC9E3AFB89
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 05:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFVD62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 23:58:28 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:41303 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhFVD60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 23:58:26 -0400
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 15M3tmr4007723;
        Mon, 21 Jun 2021 20:55:49 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     jarod@redhat.com, steffen.klassert@secunet.com,
        davem@davemloft.net, kuba@kernel.org, secdev@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net] xfrm: Fix xfrm offload fallback fail case
Date:   Tue, 22 Jun 2021 09:25:31 +0530
Message-Id: <20210622035531.3780-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of xfrm offload, if xdo_dev_state_add() of driver returns
-EOPNOTSUPP, xfrm offload fallback is failed.
In xfrm state_add() both xso->dev and xso->real_dev are initialized to
dev and when err(-EOPNOTSUPP) is returned only xso->dev is set to null.

So in this scenario the condition in func validate_xmit_xfrm(),
if ((x->xso.dev != dev) && (x->xso.real_dev == dev))
                return skb;
returns true, due to which skb is returned without calling esp_xmit()
below which has fallback code. Hence the CRYPTO_FALLBACK is failing.

So fixing this with by keeping x->xso.real_dev as NULL when err is
returned in func xfrm_dev_state_add().

Fixes: bdfd2d1fa79a ("bonding/xfrm: use real_dev instead of slave_dev")
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 net/xfrm/xfrm_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 6d6917b68856..e843b0d9e2a6 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -268,6 +268,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		xso->num_exthdrs = 0;
 		xso->flags = 0;
 		xso->dev = NULL;
+		xso->real_dev = NULL;
 		dev_put(dev);
 
 		if (err != -EOPNOTSUPP)
-- 
2.28.0.rc1.6.gae46588

