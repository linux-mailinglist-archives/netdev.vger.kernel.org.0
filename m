Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E95478708
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 10:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbhLQJ0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 04:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhLQJ0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 04:26:40 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D78C061574;
        Fri, 17 Dec 2021 01:26:40 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639733197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=B7CcEKz1Bb1SpLsV9WHI5Sn4q4D3I2gK1U2uhyOlGyM=;
        b=VUsleyxaeFiBXQ7O7pWQExVqwzOmqkEnFQ5Qka971rv9iyLdMDxKnjGeDBNR9QvLf2mR/9
        W1sWEDark3KL10/qevAuLEkcBooY0JeOElALAMyFgoesJkv/UyxapbVYZx6OB1+WRzElSG
        i0gMdo7xpFOsi/iPIvMBTlYLAIHB4/Y=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] xdp: move the if dev statements to the first
Date:   Fri, 17 Dec 2021 17:25:45 +0800
Message-Id: <20211217092545.30204-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xdp_rxq_info_unreg() called by xdp_rxq_info_reg() is meaningless when
dev is NULL, so move the if dev statements to the first.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/xdp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 5ddc29f29bad..7fe1df85f505 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -159,6 +159,11 @@ static void xdp_rxq_info_init(struct xdp_rxq_info *xdp_rxq)
 int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
 		     struct net_device *dev, u32 queue_index, unsigned int napi_id)
 {
+	if (!dev) {
+		WARN(1, "Missing net_device from driver");
+		return -ENODEV;
+	}
+
 	if (xdp_rxq->reg_state == REG_STATE_UNUSED) {
 		WARN(1, "Driver promised not to register this");
 		return -EINVAL;
@@ -169,11 +174,6 @@ int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
 		xdp_rxq_info_unreg(xdp_rxq);
 	}
 
-	if (!dev) {
-		WARN(1, "Missing net_device from driver");
-		return -ENODEV;
-	}
-
 	/* State either UNREGISTERED or NEW */
 	xdp_rxq_info_init(xdp_rxq);
 	xdp_rxq->dev = dev;
-- 
2.32.0

