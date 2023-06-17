Return-Path: <netdev+bounces-11735-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92A7173412A
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 15:21:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36677281758
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 13:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1767B9448;
	Sat, 17 Jun 2023 13:21:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69451117;
	Sat, 17 Jun 2023 13:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EB6C433C8;
	Sat, 17 Jun 2023 13:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687008073;
	bh=Q+/MaNb9NjJqu/qD/8ir2QEc9bYxenlvnj0Sb209bl4=;
	h=From:To:Cc:Subject:Date:From;
	b=WWZmgbFcqSGe4RdMt/6EoAjh2pX4SGmd++uTNfeaTGx706C8fUSYGVoN2z5CJE75Y
	 rOrQ93UEclzD2XhbrIyir1wJGZOw2CgqdvJs01kQWHfc8grm/HH6tVD88VbZxceTwc
	 +Y1zP3J71PdC1fhntjjht14XWdX4zDxbuHb2DCRKjn75kYFm+U+E/AAyxHO6gUy1q5
	 oSfHSqEhgUXJlxHPsppaC6RVSzs+NYTvZcnkcmDdJy6s5gJPGdcuc9gJVBsWzsnPPx
	 Kid2Ir1eY2g45ubZokrA62W5GONdihNRgq2fBdb+LeG7meuPgqN7R+FMye2pS/4cQq
	 K5QIJtbSubKIw==
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
Subject: [PATCH net-next v2 0/2] net: stmmac: fix & improve driver statistics
Date: Sat, 17 Jun 2023 21:09:41 +0800
Message-Id: <20230617130943.2776-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

improve the stmmac driver statistics:

1. don't clear network driver statistics in .ndo_close() and
.ndo_open() cycle
2. avoid some network driver statistics overflow on 32 bit platforms
3. use pcpu statistics where necessary to remove frequent cacheline
ping pongs.

Since v1:
  - rebase on net-next
  - fold two original patches into one patch
  - fix issues found by lkp
  - update commit msg

Jisheng Zhang (2):
  net: stmmac: don't clear network statistics in .ndo_open()
  net: stmmac: use pcpu 64 bit statistics where necessary

 drivers/net/ethernet/stmicro/stmmac/common.h  |  54 +++--
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  15 +-
 .../ethernet/stmicro/stmmac/dwmac100_dma.c    |   7 +-
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  13 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  15 +-
 .../net/ethernet/stmicro/stmmac/dwmac_lib.c   |  10 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_descs.c  |   6 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |  13 +-
 .../net/ethernet/stmicro/stmmac/enh_desc.c    |  20 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  12 +-
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |  15 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 101 +++++++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 190 +++++++++++++-----
 13 files changed, 305 insertions(+), 166 deletions(-)

-- 
2.40.1


