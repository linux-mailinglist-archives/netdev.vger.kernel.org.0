Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C92C22AE01
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgGWLna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbgGWLn3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:29 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE1CC2086A;
        Thu, 23 Jul 2020 11:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504608;
        bh=zUp+J1tb1gA4g2/vc5ptH/o4DieHNMsWS7pObkJYXX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSpAXr5dzKYNpx+7TkYHbCzbohm2EpWWz82q69+ZeJRBBmll1V1Er02zFeWRrQwxr
         qhKktPcVo0Gf7mvhJ5eoKnkWP5CbYtEgBRjtEFpYoZ4/21a/0ddSqBPMju74LGot4r
         jRePMLkaLEg+Kd3FYj5XhvIRxDrEJBYUv6Po+z6c=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 09/22] net: ti: initialize mb bit in xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:21 +0200
Message-Id: <720619dc2d14095943c98318eaa8b0a61f597351.1595503780.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1595503780.git.lorenzo@kernel.org>
References: <cover.1595503780.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize multi-buffer bit (mb) to 0 in xdp_buff data structure.
This is a preliminary patch to enable xdp multi-buffer support.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c     | 1 +
 drivers/net/ethernet/ti/cpsw_new.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 9b17bbbe102f..53a55c540adc 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -407,6 +407,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		xdp.data_hard_start = pa;
 		xdp.rxq = &priv->xdp_rxq[ch];
 		xdp.frame_sz = PAGE_SIZE;
+		xdp.mb = 0;
 
 		port = priv->emac_port + cpsw->data.dual_emac;
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, port);
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 1247d35d42ef..703d079fd479 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -349,6 +349,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		xdp.data_hard_start = pa;
 		xdp.rxq = &priv->xdp_rxq[ch];
 		xdp.frame_sz = PAGE_SIZE;
+		xdp.mb = 0;
 
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
 		if (ret != CPSW_XDP_PASS)
-- 
2.26.2

