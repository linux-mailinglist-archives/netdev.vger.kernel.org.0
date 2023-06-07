Return-Path: <netdev+bounces-8860-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD747261C8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:57:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0611C1C20C7C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:57:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F3235B47;
	Wed,  7 Jun 2023 13:56:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91657139F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE65C433EF;
	Wed,  7 Jun 2023 13:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686146215;
	bh=r/dkeieRe+CBoWvVAbirfQe75r6oLh/K8kfqL8af9hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBhVEDK+bGfJNxNkcrFUiig1oWzsBWPMPtjov+xF+5agQV6NYtYaDfU7xTAQhH/XW
	 hTHp1n1g4wkwBygN4PCLDkJ0a4yY/eZiaTUHURRV/vnnjH38RAXjedh3la9SF1dO/f
	 OTKHTuhKrNavhhi+tRgkpaJ/WIlLocnI28wpcHnV1lScn2fUyf3D1I1MZlc29ofQiP
	 LPsDLGGbkQPSZPNEGFbUmqbGG9OLZaGVHnA+CyKbxWgUu7zN8VwSQijOq8sYjz/LVt
	 bs254+DnLjkTQpPyQx9CYn4LZfWqVmViL+Mr6JA4o38CJ2wt2Al8OmCXcWTPi5CH1m
	 Zl8I09ruBqFhQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Joyce Ooi <joyce.ooi@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Simon Horman <simon.horman@corigine.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: altera-tse: fix broken Kconfig dependency
Date: Wed,  7 Jun 2023 15:56:33 +0200
Message-Id: <20230607135638.1341101-2-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230607135638.1341101-1-arnd@kernel.org>
References: <20230607135638.1341101-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The CONFIG_PCS_ALTERA_TSE symbol is gone, so make sure the ethernet
driver selects the correct symbol for its replacement, avoiding:

x86_64-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_remove':
altera_tse_main.c:(.text+0xdf): undefined reference to `lynx_pcs_destroy'

Fixes: 196eec4062b00 ("net: pcs: Drop the TSE PCS driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/altera/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/altera/Kconfig b/drivers/net/ethernet/altera/Kconfig
index 93533ba034294..17985319088c1 100644
--- a/drivers/net/ethernet/altera/Kconfig
+++ b/drivers/net/ethernet/altera/Kconfig
@@ -4,7 +4,7 @@ config ALTERA_TSE
 	depends on HAS_DMA
 	select PHYLIB
 	select PHYLINK
-	select PCS_ALTERA_TSE
+	select PCS_LYNX
 	select MDIO_REGMAP
 	select REGMAP_MMIO
 	help
-- 
2.39.2


