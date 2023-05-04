Return-Path: <netdev+bounces-347-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 612BE6F738C
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:44:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 898511C2138A
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84748F4E5;
	Thu,  4 May 2023 19:42:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3567F4E8
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60135C4339C;
	Thu,  4 May 2023 19:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229339;
	bh=X7FKrMlibVA+cIy6xm4u67ib08PyLcz/1lFg2G+n3PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwUyA9MRdLAWoXbWDNlknvPYZz5nQeFpIlcg5rMBFmfAGNHdo0M5zHOdxokCm7xX1
	 Omv0Eqx1yyamr1F+1KckMO0rTUuFtD0HuhIkJgdF3cGTIJR1N53mntOaQ8uykqP/DY
	 awZFmBsMS88hE67TK5fcamBjVaL+Z5S73O4qb1Wi2sxho9mTpIdeWs71lwOAye0Aj0
	 X3lmUJAKqdjuAbvzBGjoH7GgSMePjzEmUlEbnYqZZxZuYh6G/YCMhVLFOGagvqo/Y3
	 0ctGA5AXx9iC/0OJXr3XE8GOrvYt1ymOsHEN9fDhkIy42GtRyefaHMMkGJ5Sl367fn
	 TNLU76IE5oHRQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Dongliang Mu <dzm91@hust.edu.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tony0620emma@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 12/59] wifi: rtw88: fix memory leak in rtw_usb_probe()
Date: Thu,  4 May 2023 15:40:55 -0400
Message-Id: <20230504194142.3805425-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194142.3805425-1-sashal@kernel.org>
References: <20230504194142.3805425-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dongliang Mu <dzm91@hust.edu.cn>

[ Upstream commit 48181d285623198c33bb9698992502687b258efa ]

drivers/net/wireless/realtek/rtw88/usb.c:876 rtw_usb_probe()
warn: 'hw' from ieee80211_alloc_hw() not released on lines: 811

Fix this by modifying return to a goto statement.

Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230309021636.528601-1-dzm91@hust.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 2a8336b1847a5..68e1b782d1992 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -808,7 +808,7 @@ int rtw_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	ret = rtw_usb_alloc_rx_bufs(rtwusb);
 	if (ret)
-		return ret;
+		goto err_release_hw;
 
 	ret = rtw_core_init(rtwdev);
 	if (ret)
-- 
2.39.2


