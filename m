Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37E42D02B7
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 11:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgLFKXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 05:23:51 -0500
Received: from mail-m972.mail.163.com ([123.126.97.2]:51136 "EHLO
        mail-m972.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgLFKXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 05:23:51 -0500
X-Greylist: delayed 5651 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Dec 2020 05:23:50 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=WHTCy5l5+fYdUerrjp
        3tMcqmoP1IK9GclDAiIt73lIc=; b=gWjDUGTW9iFpikukNRiWvcwOFE5mmhmBlA
        T3lh4vQlvBb4wNJcDNquytTyh7NNZglggAtzQR62O2/C3MtxyZfrFivx9BWwEvgM
        AI7If9haV8rNEYqiyrBP3qYHMpRLiJ73bOJQpmQmtgnnBwc16PNnRvmtAnGRUCpN
        w4mFF3LYo=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp2 (Coremail) with SMTP id GtxpCgCHA8nMmsxfJf2DEA--.20874S4;
        Sun, 06 Dec 2020 16:48:13 +0800 (CST)
From:   Xiaohui Zhang <ruc_zhangxiaohui@163.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start
Date:   Sun,  6 Dec 2020 16:48:01 +0800
Message-Id: <20201206084801.26479-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: GtxpCgCHA8nMmsxfJf2DEA--.20874S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF4xZF4rAw4fXF4xJry7ZFb_yoWkZFX_W3
        4Iva15JrZrtw1IyrsYyw42v3sYkr1rXrWxGa17trWrGFW2vFZrtrnY9rs5Xr12kw1qvr9x
        Wrs8A3y5ta4FvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjU3vUUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/1tbipQ3yMFUMa-PfKwAAsf
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>

mwifiex_cmd_802_11_ad_hoc_start() calls memcpy() without checking
the destination size may trigger a buffer overflower,
which a local user could use to cause denial of service
or the execution of arbitrary code.
Fix it by putting the length check before calling memcpy().

Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
---
 drivers/net/wireless/marvell/mwifiex/join.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
index 5934f7147..173ccf79c 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -877,6 +877,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	memset(adhoc_start->ssid, 0, IEEE80211_MAX_SSID_LEN);
 
+	if (req_ssid->ssid_len > IEEE80211_MAX_SSID_LEN)
+		req_ssid->ssid_len = IEEE80211_MAX_SSID_LEN;
 	memcpy(adhoc_start->ssid, req_ssid->ssid, req_ssid->ssid_len);
 
 	mwifiex_dbg(adapter, INFO, "info: ADHOC_S_CMD: SSID = %s\n",
-- 
2.17.1

