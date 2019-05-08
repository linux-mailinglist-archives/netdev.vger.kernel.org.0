Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9D6172D9
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 09:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfEHHva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 03:51:30 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:53814 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725891AbfEHHv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 03:51:29 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A01F0C00ED;
        Wed,  8 May 2019 07:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557301882; bh=prKAWEnPyyeR0v+xq734c/U+WoA4t2u8hB/OyFOOnN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=g1v/DUJdCvedHQc3765VCY4T/4CvE4FeHY5/x8G2eSBuLHs8k9fc1nROT6M1yeAqu
         fuGELd9LnJ9p/ef+oj1HtPxDCQBfnwyG/GbfLVfAgfLbN43eFOLQpcRCK6kgNZuT4G
         iD8ivGWsaR9SIMJ9KtjuUgIIGHKHC2b8AclsdkSdgSNemGTwUPIY4VCgSzutbrJQ1E
         4gplkwMCjWx8VzlejJviF3BdjN91XXXLdJ6aCFSqDLqkLhCZVNj0CkYKX33WCQzlKt
         N0IfErhIdt1lZhvATe0XUFMLCTUQT4GTqH+BvPLH6EcEvQWTWY61VGAVkvXnBFawj9
         FIp29Bgv7ehKg==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 54DF8A02DA;
        Wed,  8 May 2019 07:51:28 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 546F63D516;
        Wed,  8 May 2019 09:51:27 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 01/11] net: stmmac: Add MAC loopback callback to HWIF
Date:   Wed,  8 May 2019 09:51:01 +0200
Message-Id: <d2546a346798daf4f6a1e01bb641307c2848c351.1557300602.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1557300602.git.joabreu@synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
In-Reply-To: <cover.1557300602.git.joabreu@synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for the addition of selftests support for stmmac we add a
new callback to HWIF that can be used to set the controller in loopback
mode.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/hwif.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 5bb00234d961..9a000dc31d9e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -324,6 +324,8 @@ struct stmmac_ops {
 	int (*flex_pps_config)(void __iomem *ioaddr, int index,
 			       struct stmmac_pps_cfg *cfg, bool enable,
 			       u32 sub_second_inc, u32 systime_flags);
+	/* Loopback for selftests */
+	void (*set_mac_loopback)(void __iomem *ioaddr, bool enable);
 };
 
 #define stmmac_core_init(__priv, __args...) \
@@ -392,6 +394,8 @@ struct stmmac_ops {
 	stmmac_do_callback(__priv, mac, rxp_config, __args)
 #define stmmac_flex_pps_config(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, flex_pps_config, __args)
+#define stmmac_set_mac_loopback(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mac, set_mac_loopback, __args)
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
-- 
2.7.4

