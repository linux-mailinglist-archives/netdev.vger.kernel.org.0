Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F32CB27732
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbfEWHhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:37:31 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:46670 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbfEWHh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:37:29 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8141AC0073;
        Thu, 23 May 2019 07:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558597035; bh=rTO3jYQQfgYc76eeKdZOIoPwkE+L6QFDgaMJpWlGQbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=DzySAIwpzuyxiPQxdCGusvr6DwI6NFPJHVbbAJGsQQT7vChj/K0z6bE4CePr1LMzs
         Pvzlf9iTlUHpX22rvSDF3ZfbY8c9WXVe6K9IEGPQE90b0NguHIXpaMrX6OrxrSJK4x
         ZrbP1+Z3em8VvDd4WPhAXZefQW91wX3kqfA3HB9//p6asv55kAXI1TqXbxz8+9bCWB
         OQw19f454u0slemm+N2gNYM00U7jgH96QJJ4r6k3TH98VYrbh5nCH5AKVYsBORL00R
         B5NsrvKtpnfSSX60nh0/CFl4urlko7+DLkTt5uyRvQahZMOMHKztdXYpexX8/EAQpd
         21GjCDtT8tcsQ==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id D082BA009D;
        Thu, 23 May 2019 07:37:28 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id E18C83D930;
        Thu, 23 May 2019 09:37:27 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH net-next 01/18] net: stmmac: Add MAC loopback callback to HWIF
Date:   Thu, 23 May 2019 09:36:51 +0200
Message-Id: <f6baa7ef7c5a1e68284a60f77c7c95016b7c02f6.1558596600.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
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
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
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

