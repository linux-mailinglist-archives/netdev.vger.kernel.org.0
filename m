Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B511468B02
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 14:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhLENUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 08:20:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47682 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbhLENUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 08:20:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD20F60FDF;
        Sun,  5 Dec 2021 13:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF43C341C1;
        Sun,  5 Dec 2021 13:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638710203;
        bh=PsXEp90wwCTNqvEt2GEWqjAY2Pt14NKpPWYajel4o7g=;
        h=From:To:Cc:Subject:Date:From;
        b=PUHs6MADJaHbEOss9tl1tTe1tNQzGKxiKG/vZ8Bk4wY5Sm/IhxjFQCRQv3CSVzkfS
         sl79lXNxu3Yh8yV2GhPyPDEWUcpXnTxwoMbS0Eck7/fJzOMzBM27RDM30WDQbnw0zH
         HrZxicIBSxh/c7S1nvUNyj38vXaYlNhune2Z2jpadTaVjYyUnJKFKWDwM3pKpPgr6p
         hwoVf17+1swdCcwlAcYFCBnYPQMhoWl6KpqNK+z4JR2cipJWSb2gPOw4XIzVyMnFsp
         k2W2pNdQKCThoaUDWM+ACGtIuVahvppK1LaypD8mnJB/kAEYy8slouukjajPsWih2A
         thgecHHgR0KsA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Ayala Beker <ayala.beker@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: mei: allow tracing to be disabled
Date:   Sun,  5 Dec 2021 14:16:29 +0100
Message-Id: <20211205131637.3203040-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The Makefile conditionally leaves out the trace implementation,
but it gets called unconditionally:

ERROR: modpost: "__SCT__tp_func_iwlmei_me_msg" [drivers/net/wireless/intel/iwlwifi/mei/iwlmei.ko] undefined!
ERROR: modpost: "__tracepoint_iwlmei_me_msg" [drivers/net/wireless/intel/iwlwifi/mei/iwlmei.ko] undefined!
ERROR: modpost: "__SCT__tp_func_iwlmei_sap_cmd" [drivers/net/wireless/intel/iwlwifi/mei/iwlmei.ko] undefined!
ERROR: modpost: "__tracepoint_iwlmei_sap_cmd" [drivers/net/wireless/intel/iwlwifi/mei/iwlmei.ko] undefined!
ERROR: modpost: "__SCT__tp_func_iwlmei_sap_data" [drivers/net/wireless/intel/iwlwifi/mei/iwlmei.ko] undefined!
ERROR: modpost: "__tracepoint_iwlmei_sap_data" [drivers/net/wireless/intel/iwlwifi/mei/iwlmei.ko] undefined!

Use the same macro incantation that is used in the main iwlwifi driver
to leave out the tracing when CONFIG_IWLWIFI_DEVICE_TRACING is disabled.

Fixes: 2da4366f9e2c ("iwlwifi: mei: add the driver to allow cooperation with CSME")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlwifi/mei/trace.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/trace.h b/drivers/net/wireless/intel/iwlwifi/mei/trace.h
index 6f673f2817ad..2742c90fedab 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/trace.h
+++ b/drivers/net/wireless/intel/iwlwifi/mei/trace.h
@@ -8,6 +8,17 @@
 
 #include <linux/tracepoint.h>
 
+#if !defined(CONFIG_IWLWIFI_DEVICE_TRACING) || defined(__CHECKER__)
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(...)
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(evt_class, name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+#endif
+
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlmei_sap_cmd
 
-- 
2.29.2

