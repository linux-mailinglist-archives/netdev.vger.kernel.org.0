Return-Path: <netdev+bounces-5936-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 677117136FF
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 00:28:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CB2A280F72
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 22:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34FB918C22;
	Sat, 27 May 2023 22:28:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221C5D52C
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 22:28:47 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A8EAD;
	Sat, 27 May 2023 15:28:45 -0700 (PDT)
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 245E884673;
	Sun, 28 May 2023 00:28:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685226523;
	bh=bcKQnIzsbSZhdBuEWfnx3ch1Jsf9OWtNztHG9Wber3U=;
	h=From:To:Cc:Subject:Date:From;
	b=WAXvxCBnd28nPI9gsfwFiLmBIzyGKxJQO+N/CSTp561Go7XwO+UArZnIvg1JGNT5Y
	 0R3JfeNNFjs5hhluOQ66f9jHYeWm5fQb6/M8y3QzPD2uEMyGhGq+z3VFJqqb76grrU
	 ZKk3Msp8zzrbl28wIZqkndb7k20eiebyGmvsa2L84hWXIUr4l/vOkjlPJyn/etlSzr
	 /dMWwCV7TJAyj5/lYracKBN22Zg4i96LoKWH/tLQqBD5k4VsfJtXAI/fBULeM4smCB
	 Xj+oDBMQ9uvsq/tkqy4MlnFEpw3gXjIlsL1Vcsz0iVJYYhPShE3jqgG/dI2ICtfsYI
	 3lLFJ4m+cd37Q==
From: Marek Vasut <marex@denx.de>
To: linux-wireless@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jilin Yuan <yuanjilin@cdjrlc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH] wifi: rsi: Do not configure WoWlan in shutdown hook if not enabled
Date: Sun, 28 May 2023 00:28:33 +0200
Message-Id: <20230527222833.273741-1-marex@denx.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In case WoWlan was never configured during the operation of the system,
the hw->wiphy->wowlan_config will be NULL. rsi_config_wowlan() checks
whether wowlan_config is non-NULL and if it is not, then WARNs about it.
The warning is valid, as during normal operation the rsi_config_wowlan()
should only ever be called with non-NULL wowlan_config. In shutdown this
rsi_config_wowlan() should only ever be called if WoWlan was configured
before by the user.

Add checks for non-NULL wowlan_config into the shutdown hook. While at it,
check whether the wiphy is also non-NULL before accessing wowlan_config .
Drop the single-use wowlan_config variable, just inline it into function
call.

Fixes: 16bbc3eb8372 ("rsi: fix null pointer dereference during rsi_shutdown()")
Signed-off-by: Marek Vasut <marex@denx.de>
---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jilin Yuan <yuanjilin@cdjrlc.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Marek Vasut <marex@denx.de>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index d09998796ac08..6e33a2563fdbd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1463,10 +1463,8 @@ static void rsi_shutdown(struct device *dev)
 
 	rsi_dbg(ERR_ZONE, "SDIO Bus shutdown =====>\n");
 
-	if (hw) {
-		struct cfg80211_wowlan *wowlan = hw->wiphy->wowlan_config;
-
-		if (rsi_config_wowlan(adapter, wowlan))
+	if (hw && hw->wiphy && hw->wiphy->wowlan_config) {
+		if (rsi_config_wowlan(adapter, hw->wiphy->wowlan_config))
 			rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
 	}
 
-- 
2.39.2


