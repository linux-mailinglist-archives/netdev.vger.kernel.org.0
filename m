Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E35410081
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 23:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244286AbhIQVHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 17:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbhIQVHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 17:07:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1658C061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 14:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=0uPgXmHipKX1bdjQ9izTgwUy2yErbpcTYEybPB/2h3Q=; b=layvusD1Q5mq38NJU0oGmoyPGI
        LBMk3s+yNTOdSgCsT4ga9Qa1FntTB1i8c9JuoWZT390uzbl85Fumo1EWoPoBhQQZ0SuSEndsajemh
        fYhueuOYrUaNn56p7LxFkgbWjE4qfAmEXNx0gRjtSkTkxLjy8A9w2dULSNmhQt/ekdQXU2Au7mGCh
        TQDHmbqcrlE3Wv0368qCEKKEPQwI39qNfUK3vdLHkf+qcBi9B9OrLf9G/LOd/VAuHf+jcLxDdUghJ
        v5PauYm0E1k4dJ/Tp/uWshkuOxIzG9AuuouRQh+d1O3GOI+z9cesUKM/dF7VX+XnBY54GRqdHE7tG
        ziniyd0g==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mRL3N-00F0v3-1S; Fri, 17 Sep 2021 21:05:49 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Ederson de Souza <ederson.desouza@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH -net] igc: fix build errors for PTP
Date:   Fri, 17 Sep 2021 14:05:47 -0700
Message-Id: <20210917210547.12578-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When IGC=y and PTP_1588_CLOCK=m, the ptp_*() interface family is
not available to the igc driver. Make this driver depend on
PTP_1588_CLOCK_OPTIONAL so that it will build without errors.

Various igc commits have used ptp_*() functions without checking
that PTP_1588_CLOCK is enabled. Fix all of these here.

Fixes these build errors:

ld: drivers/net/ethernet/intel/igc/igc_main.o: in function `igc_msix_other':
igc_main.c:(.text+0x6494): undefined reference to `ptp_clock_event'
ld: igc_main.c:(.text+0x64ef): undefined reference to `ptp_clock_event'
ld: igc_main.c:(.text+0x6559): undefined reference to `ptp_clock_event'
ld: drivers/net/ethernet/intel/igc/igc_ethtool.o: in function `igc_ethtool_get_ts_info':
igc_ethtool.c:(.text+0xc7a): undefined reference to `ptp_clock_index'
ld: drivers/net/ethernet/intel/igc/igc_ptp.o: in function `igc_ptp_feature_enable_i225':
igc_ptp.c:(.text+0x330): undefined reference to `ptp_find_pin'
ld: igc_ptp.c:(.text+0x36f): undefined reference to `ptp_find_pin'
ld: drivers/net/ethernet/intel/igc/igc_ptp.o: in function `igc_ptp_init':
igc_ptp.c:(.text+0x11cd): undefined reference to `ptp_clock_register'
ld: drivers/net/ethernet/intel/igc/igc_ptp.o: in function `igc_ptp_stop':
igc_ptp.c:(.text+0x12dd): undefined reference to `ptp_clock_unregister'
ld: drivers/platform/x86/dell/dell-wmi-privacy.o: in function `dell_privacy_wmi_probe':

Fixes: 64433e5bf40ab ("igc: Enable internal i225 PPS")
Fixes: 60dbede0c4f3d ("igc: Add support for ethtool GET_TS_INFO command")
Fixes: 87938851b6efb ("igc: enable auxiliary PHC functions for the i225")
Fixes: 5f2958052c582 ("igc: Add basic skeleton for PTP")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ederson de Souza <ederson.desouza@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
---
 drivers/net/ethernet/intel/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20210917.orig/drivers/net/ethernet/intel/Kconfig
+++ linux-next-20210917/drivers/net/ethernet/intel/Kconfig
@@ -335,6 +335,7 @@ config IGC
 	tristate "Intel(R) Ethernet Controller I225-LM/I225-V support"
 	default n
 	depends on PCI
+	depends on PTP_1588_CLOCK_OPTIONAL
 	help
 	  This driver supports Intel(R) Ethernet Controller I225-LM/I225-V
 	  family of adapters.
