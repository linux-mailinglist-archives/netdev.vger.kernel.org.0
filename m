Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC80B1FD4CD
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgFQSr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727015AbgFQSr5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 14:47:57 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB3DC206DB;
        Wed, 17 Jun 2020 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592419677;
        bh=d7ylVfQ7C8f2oiLX16FaR4UvGdVUfh/XyCv910N2yMQ=;
        h=Date:From:To:Cc:Subject:From;
        b=Oe3lqD5tc7ICJ0ZaE02Nynb15FVm8s2kKNBfgWHYI4crwrnNU5QtTFNXiQtTRro1L
         48d81RfPM9qt5MLMGAkP+DgIWYaEI6CendR2lnGRBP+b071ivNt8pZszGY+J4Lxg4R
         C4YNp14OmGBjB+7yNFngyvJxeZD3+k5LmUwrVFbo=
Date:   Wed, 17 Jun 2020 13:53:17 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] enetc: Use struct_size() helper in kzalloc()
Message-ID: <20200617185317.GA623@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 298c55786fd9..61dbf19075fb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1687,7 +1687,7 @@ int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 {
 	struct pci_dev *pdev = priv->si->pdev;
-	int size, v_tx_rings;
+	int v_tx_rings;
 	int i, n, err, nvec;
 
 	nvec = ENETC_BDR_INT_BASE_IDX + priv->bdr_int_num;
@@ -1702,15 +1702,13 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 
 	/* # of tx rings per int vector */
 	v_tx_rings = priv->num_tx_rings / priv->bdr_int_num;
-	size = sizeof(struct enetc_int_vector) +
-	       sizeof(struct enetc_bdr) * v_tx_rings;
 
 	for (i = 0; i < priv->bdr_int_num; i++) {
 		struct enetc_int_vector *v;
 		struct enetc_bdr *bdr;
 		int j;
 
-		v = kzalloc(size, GFP_KERNEL);
+		v = kzalloc(struct_size(v, tx_ring, v_tx_rings), GFP_KERNEL);
 		if (!v) {
 			err = -ENOMEM;
 			goto fail;
-- 
2.27.0

