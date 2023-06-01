Return-Path: <netdev+bounces-7245-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BBD3D71F4B6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:31:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 546001C210F9
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 21:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0675C24127;
	Thu,  1 Jun 2023 21:31:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8278C33DF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 21:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD57C433D2;
	Thu,  1 Jun 2023 21:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685655078;
	bh=Rq/YPhUrxxmon4lsDaGRDkAmNIYRrnC5b1pXLnZ3MbA=;
	h=From:To:Cc:Subject:Date:From;
	b=VDx29Is+heLSHZendXg04+AgJJOfhzDRchuOF/qJ5fqzXQshWgSpyhA8H50/huNLd
	 pINbTUfx8y2pP0q+Eq7t1xM2QbJzMb8sxEw+NNdEolt4WXQV4GkxatzEq0TOphHQLa
	 jKwieLVkqsEVui4bdtJQkm0vunj/GtbUkKhRMeqJqhwejXt0ukzlRLgG901gefA9YP
	 CAEIYvrlzF6Rlt09Q4Re1gsNsgnQhlpXMvZ61u1Zk4xTSRr8pO5hsMELLKh0JqRFMc
	 D7gFui3Uwamc6waP115/MJzbVl0PBzIGsbZExrTFPSvVJAk04PEU+g3h42Df9t6PrE
	 eUpfOTnW2D2OA==
From: Arnd Bergmann <arnd@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Christian Marangi <ansuelsmth@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: qca8k: add CONFIG_LEDS_TRIGGERS dependency
Date: Thu,  1 Jun 2023 23:31:04 +0200
Message-Id: <20230601213111.3182893-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Without LED triggers, the driver now fails to build:

drivers/net/dsa/qca/qca8k-leds.c: In function 'qca8k_parse_port_leds':
drivers/net/dsa/qca/qca8k-leds.c:403:31: error: 'struct led_classdev' has no member named 'hw_control_is_supported'
  403 |                 port_led->cdev.hw_control_is_supported = qca8k_cled_hw_control_is_supported;
      |                               ^

There is a mix of 'depends on' and 'select' for LEDS_TRIGGERS, so it's
not clear what we should use here, but in general using 'depends on'
causes fewer problems, so use that.

Fixes: e0256648c831a ("net: dsa: qca8k: implement hw_control ops")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/dsa/qca/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/qca/Kconfig b/drivers/net/dsa/qca/Kconfig
index 4347b42c50fd2..de9da469908bc 100644
--- a/drivers/net/dsa/qca/Kconfig
+++ b/drivers/net/dsa/qca/Kconfig
@@ -20,6 +20,7 @@ config NET_DSA_QCA8K_LEDS_SUPPORT
 	bool "Qualcomm Atheros QCA8K Ethernet switch family LEDs support"
 	depends on NET_DSA_QCA8K
 	depends on LEDS_CLASS=y || LEDS_CLASS=NET_DSA_QCA8K
+	depends on LEDS_TRIGGERS
 	help
 	  This enabled support for LEDs present on the Qualcomm Atheros
 	  QCA8K Ethernet switch chips.
-- 
2.39.2


