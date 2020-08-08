Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68A023F6CC
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 09:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgHHHTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 03:19:01 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:34997 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgHHHTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 03:19:00 -0400
X-Originating-IP: 71.82.72.227
Received: from localhost.localdomain (071-082-072-227.res.spectrum.com [71.82.72.227])
        (Authenticated sender: phollinsky@holtechnik.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 2F251FF804;
        Sat,  8 Aug 2020 07:18:53 +0000 (UTC)
From:   Paul Hollinsky <phollinsky@holtechnik.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andriin@fb.com,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, songliubraving@fb.com, yhs@fb.com,
        Paul Hollinsky <phollinsky@holtechnik.com>
Subject: [PATCH] xdp: ensure initialization of txq in xdp_buff
Date:   Sat,  8 Aug 2020 03:16:01 -0400
Message-Id: <20200808071600.1999613-1-phollinsky@holtechnik.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp->txq was uninitialized and could be used from within a bpf program.

https://syzkaller.appspot.com/bug?id=a6e53f8e9044ea456ea1636be970518ae6ba7f62

Signed-off-by: Paul Hollinsky <phollinsky@holtechnik.com>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7df6c9617321..12be8fef8b7e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4649,6 +4649,8 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	rxqueue = netif_get_rxqueue(skb);
 	xdp->rxq = &rxqueue->xdp_rxq;
 
+	xdp->txq = NULL;
+
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	/* check if bpf_xdp_adjust_head was used */
-- 
2.25.1

