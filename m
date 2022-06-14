Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDACA54AA0B
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 09:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238689AbiFNHII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 03:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352962AbiFNHIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 03:08:01 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326B52F388;
        Tue, 14 Jun 2022 00:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655190480; x=1686726480;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fidju0wTS+1QmlVVjMFvWw+XSYdPQvDSGcv+svNoSvs=;
  b=daBrODs1cDxA8w552rrnT42taphwo6TcxxJspCAM7gbVhPmenkt9n5ro
   0ez2TXkAFu3rAxxupKeif17Kw1evPLFaZfRCC2f/y9QDvFc1lsT+L3Ks+
   Esk/2zed8AVJetWRsniSz3tl+f7vgYAPg9A/wFBSJhVgNzKxR5Wz6XdxP
   GbcTdBohufIfITfuiHHHaTHwKaseEyEghVdlPxWSbcxVgKb58CgjHIa+e
   bedZDh7Lr7F9VTFsL2mRIWmRnvgkfDWBZyUX3S6Q5cB9DgZEShujt7qmx
   zK7lH0d+HrDibo5q563WsbP+h1hEAQ4O854CaK1apc8B2D+T6RgQxwpt5
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="258981200"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="258981200"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 00:07:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="651872188"
Received: from silpixa00401086.ir.intel.com (HELO localhost.localdomain) ([10.55.128.121])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jun 2022 00:07:55 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf] xsk: fix generic transmit when completion queue reservation fails
Date:   Tue, 14 Jun 2022 07:07:46 +0000
Message-Id: <20220614070746.8871-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two points of potential failure in the generic transmit function are:
1. completion queue (cq) reservation failure.
2. skb allocation failure

Originally the cq reservation was performed first, followed by the skb
allocation. Commit 675716400da6 ("xdp: fix possible cq entry leak")
reversed the order because at the time there was no mechanism available to
undo the cq reservation which could have led to possible cq entry leaks in
the event of skb allocation failure. However if the skb allocation is
performed first and the cq reservation then fails, the xsk skb destructor
is called which blindly adds the skb address to the already full cq leading
to undefined behavior.

This commit restores the original order (cq reservation followed by skb
allocation) and uses the xskq_prod_cancel helper to undo the cq reserve in
event of skb allocation failure.

Fixes: 675716400da6 ("xdp: fix possible cq entry leak")
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 net/xdp/xsk.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 19ac872a6624..09002387987e 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -538,12 +538,6 @@ static int xsk_generic_xmit(struct sock *sk)
 			goto out;
 		}
 
-		skb = xsk_build_skb(xs, &desc);
-		if (IS_ERR(skb)) {
-			err = PTR_ERR(skb);
-			goto out;
-		}
-
 		/* This is the backpressure mechanism for the Tx path.
 		 * Reserve space in the completion queue and only proceed
 		 * if there is space in it. This avoids having to implement
@@ -552,11 +546,19 @@ static int xsk_generic_xmit(struct sock *sk)
 		spin_lock_irqsave(&xs->pool->cq_lock, flags);
 		if (xskq_prod_reserve(xs->pool->cq)) {
 			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
-			kfree_skb(skb);
 			goto out;
 		}
 		spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 
+		skb = xsk_build_skb(xs, &desc);
+		if (IS_ERR(skb)) {
+			err = PTR_ERR(skb);
+			spin_lock_irqsave(&xs->pool->cq_lock, flags);
+			xskq_prod_cancel(xs->pool->cq);
+			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
+			goto out;
+		}
+
 		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
-- 
2.25.1

