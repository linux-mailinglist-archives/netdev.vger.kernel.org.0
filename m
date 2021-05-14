Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAB33813BF
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhENWZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231377AbhENWZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:25:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48A7661454;
        Fri, 14 May 2021 22:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621031044;
        bh=uNMa+1OI8IXpj1+ERkBNeSAgC/vykI6Y6ibUkk0EV9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrdQnsf7RikhL565PgeulUPowY/IPCF4z0t6LVmzzu09eObhvFA9Mwvr+PSS0nipq
         eYmgf8p59pxUzqeMNid1o36pbHMN4SsMhGm+6KHN59lgcg+z9teem9Wz8GKt/RZ1JG
         hEfEzt6n9Kua4HoDiw1yJNHId/rIG6iq/jUuABo/cGJJ5aannKCWlL6082F0kXWANW
         zOgXWVWlZ1izb28c7tHfklpHMrWll1aLM40eQUZqLWLwKluoYYTvwgQ/K2h1jwJxZe
         PPUgnl85HDQgWWBMu0m9Lg9vrJcgYeabOKNBJSR4JJ8RMgBphcc5odp9e08nvcIKKr
         MwSFvTbsVJ/9w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, tglx@linutronix.de
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        simon.horman@netronome.com, oss-drivers@netronome.com,
        bigeasy@linutronix.de, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/2] nfp: use napi_schedule_irq()
Date:   Fri, 14 May 2021 15:24:02 -0700
Message-Id: <20210514222402.295157-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514222402.295157-1-kuba@kernel.org>
References: <20210514222402.295157-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NFP uses MSI-X and has the most trivial IRQ handler possible.
Perfect candidate for napi_schedule_irq().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index eeb30680b4dc..12222a6bb08a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -474,7 +474,7 @@ static irqreturn_t nfp_net_irq_rxtx(int irq, void *data)
 {
 	struct nfp_net_r_vector *r_vec = data;
 
-	napi_schedule_irqoff(&r_vec->napi);
+	napi_schedule_irq(&r_vec->napi);
 
 	/* The FW auto-masks any interrupt, either via the MASK bit in
 	 * the MSI-X table or via the per entry ICR field.  So there
@@ -2631,8 +2631,8 @@ nfp_net_prepare_vector(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 
 	snprintf(r_vec->name, sizeof(r_vec->name),
 		 "%s-rxtx-%d", nfp_net_name(nn), idx);
-	err = request_irq(r_vec->irq_vector, r_vec->handler, 0, r_vec->name,
-			  r_vec);
+	err = request_irq(r_vec->irq_vector, r_vec->handler, IRQF_NO_THREAD,
+			  r_vec->name, r_vec);
 	if (err) {
 		if (nn->dp.netdev)
 			netif_napi_del(&r_vec->napi);
-- 
2.31.1

