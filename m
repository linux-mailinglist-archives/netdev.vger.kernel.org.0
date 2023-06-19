Return-Path: <netdev+bounces-12044-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF28735CBB
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:04:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E4631C20A1C
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A07A913AD4;
	Mon, 19 Jun 2023 17:03:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6068214265;
	Mon, 19 Jun 2023 17:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E0CC433CA;
	Mon, 19 Jun 2023 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687194229;
	bh=kJMjOEWBubOW9yDcj4y+c7DM6eBhC1GM5K1t94VIlM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZgVSa7DmSzA23REOyCumO6xcP5Egtb2oN4i51WmfDWg9jMil2nIDr5BY4xjc0cqF
	 ltXokjrS+yaCpDXsilDiUn2W1wZa+qq0Q8n3N6NQXSZEs3y7mpd46R1NqA9gtVYd6T
	 e1Zd32k3Qytg5DMVli31N7CFgtVsde+O4ZXNTncboXht36eei1wXPV9h1Wxd4110W/
	 dc974OJsoxUmJYVbDZdkh7JD5nKw8SsB7PN0VNfPA3pCEyZ4BF0qeD7wyspbd6+1k7
	 Iz1myfVJRHLqaxtpSoC8u6FThqazRsB0IGQ5gAHRBzPq9uAfdlg+HXlEwdgW9vpEyg
	 9da33KtsSLZqw==
From: Jisheng Zhang <jszhang@kernel.org>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>
Cc: netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v3 1/2] net: stmmac: don't clear network statistics in .ndo_open()
Date: Tue, 20 Jun 2023 00:52:19 +0800
Message-Id: <20230619165220.2501-2-jszhang@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230619165220.2501-1-jszhang@kernel.org>
References: <20230619165220.2501-1-jszhang@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FWICT, the common style in other network drivers: the network
statistics are not cleared since initialization, follow the common
style for stmmac.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5c645b6d5660..eb83396d6971 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3827,10 +3827,6 @@ static int __stmmac_open(struct net_device *dev,
 		}
 	}
 
-	/* Extra statistics */
-	memset(&priv->xstats, 0, sizeof(struct stmmac_extra_stats));
-	priv->xstats.threshold = tc;
-
 	priv->rx_copybreak = STMMAC_RX_COPYBREAK;
 
 	buf_sz = dma_conf->dma_buf_sz;
@@ -7315,6 +7311,8 @@ int stmmac_dvr_probe(struct device *device,
 #endif
 	priv->msg_enable = netif_msg_init(debug, default_msg_level);
 
+	priv->xstats.threshold = tc;
+
 	/* Initialize RSS */
 	rxq = priv->plat->rx_queues_to_use;
 	netdev_rss_key_fill(priv->rss.key, sizeof(priv->rss.key));
-- 
2.40.1


