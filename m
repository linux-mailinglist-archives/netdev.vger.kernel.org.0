Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432BA3DCC46
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 17:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhHAPWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 11:22:25 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:57044
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231940AbhHAPWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 11:22:24 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 5D2693F070;
        Sun,  1 Aug 2021 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627831335;
        bh=w+wGUm1NI/CIm3eVzRJyzEgQ0VdS9CAG+ZtRdqquIQo=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=JOkVQxFYQSpxpfrVUkdH7muU3m4A3mfIlCo5olfFPQKSu+HimSI/ce29TnadKGH43
         rvOavqDKh6ozCAyhbPdG6Rb3oChuhj5E4SNPNvy5SiVs6JB+rq3+ngzWVVB6/4g3LO
         TOW2Z9uTQhesWJ86Vj1Z5efqgZPZcWUsMkZ9mWn1sGwa706OscboQVC9HB5OgAPRTc
         n+ie77fGyDOhBsSJszwpI3FHOj6GTVy7cEW7H1tmuPs5LEKFQTRHkYxH0rW8UW6zWf
         FSydWUIIX0+9TH1i55oJAcbOAkXSTth0oVyLG8zAn35+oMHwT/X5b8gb8bRPfs7vOk
         qaAUHW4oSdY3g==
From:   Colin King <colin.king@canonical.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dpaa2-eth: make the array faf_bits static const, makes object smaller
Date:   Sun,  1 Aug 2021 16:22:09 +0100
Message-Id: <20210801152209.146359-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array faf_bits on the stack but instead it
static const. Makes the object code smaller by 175 bytes.

Before:
   text  data   bss     dec   hex filename
   9645  4552     0   14197  3775 ../freescale/dpaa2/dpaa2-eth-devlink.o

After:
   text  data   bss     dec   hex filename
   9406  4616     0   14022  36c6 ../freescale/dpaa2/dpaa2-eth-devlink.o

(gcc version 10.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
index 833696245565..8e09f65ea295 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
@@ -68,7 +68,7 @@ dpaa2_eth_dl_trap_item_lookup(struct dpaa2_eth_priv *priv, u16 trap_id)
 struct dpaa2_eth_trap_item *dpaa2_eth_dl_get_trap(struct dpaa2_eth_priv *priv,
 						  struct dpaa2_fapr *fapr)
 {
-	struct dpaa2_faf_error_bit {
+	static const struct dpaa2_faf_error_bit {
 		int position;
 		enum devlink_trap_generic_id trap_id;
 	} faf_bits[] = {
-- 
2.31.1

