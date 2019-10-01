Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E10C3B09
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbfJAQlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730733AbfJAQlL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD44821872;
        Tue,  1 Oct 2019 16:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948070;
        bh=QNM6iEfyjMR2dBWC83OX9hT7NSrwY7XUPzrBgi4u/Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVGNnXfWxbpjFYCaxfWbJ1M7HRxS6VthgBkac++zi7LeoYYkBh8EjeGmXRrCsas33
         IR2EXTsS4o2o+XgV4wtHshOf6dA8de1bwtiRH8BfdKHEitE7jBGlCqvyDCMNbX2iFK
         vQF2Gc+3LqVf6gqfEsFDORibIR9+WiDei6bSSyII=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, oss-drivers@netronome.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 65/71] nfp: flower: prevent memory leak in nfp_flower_spawn_phy_reprs
Date:   Tue,  1 Oct 2019 12:39:15 -0400
Message-Id: <20191001163922.14735-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 8572cea1461a006bce1d06c0c4b0575869125fa4 ]

In nfp_flower_spawn_phy_reprs, in the for loop over eth_tbl if any of
intermediate allocations or initializations fail memory is leaked.
requiered releases are added.

Fixes: b94524529741 ("nfp: flower: add per repr private data for LAG offload")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/flower/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index 5331e01f373e0..acb02e1513f2e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -518,6 +518,7 @@ nfp_flower_spawn_phy_reprs(struct nfp_app *app, struct nfp_flower_priv *priv)
 		repr_priv = kzalloc(sizeof(*repr_priv), GFP_KERNEL);
 		if (!repr_priv) {
 			err = -ENOMEM;
+			nfp_repr_free(repr);
 			goto err_reprs_clean;
 		}
 
@@ -528,11 +529,13 @@ nfp_flower_spawn_phy_reprs(struct nfp_app *app, struct nfp_flower_priv *priv)
 		port = nfp_port_alloc(app, NFP_PORT_PHYS_PORT, repr);
 		if (IS_ERR(port)) {
 			err = PTR_ERR(port);
+			kfree(repr_priv);
 			nfp_repr_free(repr);
 			goto err_reprs_clean;
 		}
 		err = nfp_port_init_phy_port(app->pf, app, port, i);
 		if (err) {
+			kfree(repr_priv);
 			nfp_port_free(port);
 			nfp_repr_free(repr);
 			goto err_reprs_clean;
@@ -545,6 +548,7 @@ nfp_flower_spawn_phy_reprs(struct nfp_app *app, struct nfp_flower_priv *priv)
 		err = nfp_repr_init(app, repr,
 				    cmsg_port_id, port, priv->nn->dp.netdev);
 		if (err) {
+			kfree(repr_priv);
 			nfp_port_free(port);
 			nfp_repr_free(repr);
 			goto err_reprs_clean;
-- 
2.20.1

