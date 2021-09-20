Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CF941126B
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbhITKAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 06:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235913AbhITJ7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 05:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D290760F6C;
        Mon, 20 Sep 2021 09:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632131892;
        bh=QinVQ60cc1yJSPedEM/wv5BKNwu87gDCFtvzp/+sRjU=;
        h=From:To:Cc:Subject:Date:From;
        b=TXVx74+RamQAmLn5AdgCXmW0vzuTxyoYKiE4IKWnDGV3D9bzLu39y4YVvGbXqeQwi
         S0nF7bI/jqEkJ7mID680iYXsJKTBCNy2fVE8kh2bKkSJeiGVdtjlGxexz/7bZDzEcL
         ZWktaFdQIESB/m4rJKb3wTK9b/mdZvMRoKbrQCQuYItRrWzxwyPeuc2yPg4cVCWvWd
         KdPZCiGQFjwflq1FkK77FwJek4HQFIrcS21AMbqPRvsUsYBs9LcmT+jvv7frLDqg+1
         AAfmy971a1O08VjXEZqrm5xYyU83Crx+thfkpAQhWoQBSXYHzfHFTPRnAenIMnVBxk
         vGVlYZCR1WWLA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ptp: ocp: add COMMON_CLK dependency
Date:   Mon, 20 Sep 2021 11:57:49 +0200
Message-Id: <20210920095807.1237902-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Without CONFIG_COMMON_CLK, this fails to link:

arm-linux-gnueabi-ld: drivers/ptp/ptp_ocp.o: in function `ptp_ocp_register_i2c':
ptp_ocp.c:(.text+0xcc0): undefined reference to `__clk_hw_register_fixed_rate'
arm-linux-gnueabi-ld: ptp_ocp.c:(.text+0xcf4): undefined reference to `devm_clk_hw_register_clkdev'
arm-linux-gnueabi-ld: drivers/ptp/ptp_ocp.o: in function `ptp_ocp_detach':
ptp_ocp.c:(.text+0x1c24): undefined reference to `clk_hw_unregister_fixed_rate'

Fixes: a7e1abad13f3 ("ptp: Add clock driver for the OpenCompute TimeCard.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/ptp/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index f02bedf41264..458218f88c5e 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -174,6 +174,7 @@ config PTP_1588_CLOCK_OCP
 	depends on I2C && MTD
 	depends on SERIAL_8250
 	depends on !S390
+	depends on COMMON_CLK
 	select NET_DEVLINK
 	help
 	  This driver adds support for an OpenCompute time card.
-- 
2.29.2

