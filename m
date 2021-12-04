Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A754686B2
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 18:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhLDRoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 12:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhLDRoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 12:44:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB2FC061751;
        Sat,  4 Dec 2021 09:40:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F6C9B80CC3;
        Sat,  4 Dec 2021 17:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BA6C341C0;
        Sat,  4 Dec 2021 17:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638639639;
        bh=Ejrhs8NC1d6wHHlfvszRxuznWip0SH1aBTOhWTu2GA0=;
        h=From:To:Cc:Subject:Date:From;
        b=UfCpjjtG/7JU3dC56E7ApVUAe4pW8ay4KqjpjAyiT4QbXPY96IYZZnf9KMFNcIwU5
         hPBIlmKqrmj6jonIzDPHJybhyNBxTS828WiKVdnSLp8bZVh8MEgGM8CssR6dOwVYYB
         40fLej/Y4246aHiC+MB0ZB9xHLds6vqsN4qDzdwAJ8TuOxQhDlc1UImqIKS7b7vy6e
         p0FM7+t1OZTJ6GWZ59GZHkjT7srdrwz5PfOjCu3YL4kvE3g6WRqvpI2poQETxCzAQD
         Pn2/WBvyYJMbZMr0jher2EsoDnKBi+wooejGVd3rBHUmfX8Ydh7HQyTxoD2QuR4Agd
         vdGmdIk8Of2mg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Stephan Gerhold <stephan@gerhold.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wwan: iosm: select CONFIG_RELAY
Date:   Sat,  4 Dec 2021 18:40:25 +0100
Message-Id: <20211204174033.950528-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The iosm driver started using relayfs, but is missing the Kconfig
logic to ensure it's built into the kernel:

x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_create_buf_file_handler':
iosm_ipc_trace.c:(.text+0x16): undefined reference to `relay_file_operations'
x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_subbuf_start_handler':
iosm_ipc_trace.c:(.text+0x31): undefined reference to `relay_buf_full'
x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_ctrl_file_write':
iosm_ipc_trace.c:(.text+0xd5): undefined reference to `relay_flush'
x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_port_rx':

Fixes: 00ef32565b9b ("net: wwan: iosm: device trace collection using relayfs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wwan/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index bdb2b0e46c12..9f5111a77da9 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -85,6 +85,7 @@ config IOSM
 	tristate "IOSM Driver for Intel M.2 WWAN Device"
 	depends on INTEL_IOMMU
 	select NET_DEVLINK
+	select RELAY
 	help
 	  This driver enables Intel M.2 WWAN Device communication.
 
-- 
2.29.2

