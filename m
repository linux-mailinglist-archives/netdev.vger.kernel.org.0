Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 098F4189705
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbgCRI1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:27:25 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:38578 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbgCRI1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:27:13 -0400
Received: by mail-pj1-f68.google.com with SMTP id m15so874121pje.3
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gz7OMO0V/9gwDQsyrVVJj38Jk+MVAm8kgbfcul1v0lY=;
        b=etWxABcQQBRhpZIfQEpTNqzTqtzyDg8w+T9b824roKZQN/UqL6N/gCA17IOuTeE6J2
         qtmH6Zm7O7h3N9L9ZqZzSVwD+zpw1LHci1QRQAxiRzVjGlSvNKpu+ArsFW3O+KXblh04
         rzvvw4ca64rAPy7nBlQ0MOpURPhTaGar/uYS+DxoTtXyD/zDuEl3vEFkvVlHUE/UQ4/4
         W5jV64HSQ886VQJbZsd5GZ5mx2YI2P/4TjrGbK3fjBy5e4dchbOY3sVdKq1nITnzIRVP
         DPliOYOf1V6PfhUP2ujH86VpMOcoYwDJmXFfD8YYfzAVPEFYG6f5wAvMihIVTFR6cgM4
         YWkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gz7OMO0V/9gwDQsyrVVJj38Jk+MVAm8kgbfcul1v0lY=;
        b=lU/JPHmR90gQ8Nw9LtUBHcWhXXFWScZ6cft0upqFmCBt44DeEeZA4rAgLEkUIIo4kR
         c07XzvZDnycK3eksBfQYM6ysYhAo8ZeyuTyTeDrWfACQ4H1W2jxkafomtfAbhwwQjE1c
         hu4qhojjduCnhr5KjLq28o3wDd31gJuCvVPdfYj2USzc29xoZd5aGGCkTIzpvYFV29eM
         rd8fvrbOZqQzKywRYTfZIs0TlEgMbBs/gSp8BarexGDnlnfx2BhvzsucjIgQif+OtHGr
         CE6/z42eAI43v7og+JvSE5b0odfahDrBF1wxNsWhBgP8LjmTzMTlkGOeusOgTF437kTy
         xylQ==
X-Gm-Message-State: ANhLgQ369Z0BgPoQnIgIpLkN9KEMceC7V4ehmknxXJ/2t7wGVzE9kApG
        w39whBOw8UT9bM9eBtdo34oTDGyPD+8=
X-Google-Smtp-Source: ADFU+vtln86LHcgYuQ6icKMWjY8Hj+LSNv+iEJI7dLh4orE2kJf17XDSIkHPUhy1QcKRtyCZcwwo1A==
X-Received: by 2002:a17:90a:26ed:: with SMTP id m100mr3494583pje.130.1584520031740;
        Wed, 18 Mar 2020 01:27:11 -0700 (PDT)
Received: from localhost.localdomain (59-127-47-126.HINET-IP.hinet.net. [59.127.47.126])
        by smtp.gmail.com with ESMTPSA id 18sm5492148pfj.140.2020.03.18.01.27.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Mar 2020 01:27:11 -0700 (PDT)
From:   Chris Chiu <chiu@endlessm.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Subject: [PATCH 1/2] rtl8xxxu: add enumeration for channel bandwidth
Date:   Wed, 18 Mar 2020 16:26:59 +0800
Message-Id: <20200318082700.71875-2-chiu@endlessm.com>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200318082700.71875-1-chiu@endlessm.com>
References: <20200318082700.71875-1-chiu@endlessm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a data field in H2C and C2H commands which is used to
carry channel bandwidth information. Add enumeration to make it
more descriptive in code.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h      | 9 +++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 6598c8d786ea..86d1d50511a8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1133,6 +1133,15 @@ enum bt_mp_oper_opcode_8723b {
 	BT_MP_OP_ENABLE_CFO_TRACKING = 0x24,
 };
 
+enum rtl8xxxu_bw_mode {
+	RTL8XXXU_CHANNEL_WIDTH_20 = 0,
+	RTL8XXXU_CHANNEL_WIDTH_40 = 1,
+	RTL8XXXU_CHANNEL_WIDTH_80 = 2,
+	RTL8XXXU_CHANNEL_WIDTH_160 = 3,
+	RTL8XXXU_CHANNEL_WIDTH_80_80 = 4,
+	RTL8XXXU_CHANNEL_WIDTH_MAX = 5,
+};
+
 struct rtl8723bu_c2h {
 	u8 id;
 	u8 seq;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 54a1a4ea107b..511a3b4ed72a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4328,7 +4328,7 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
 				    u32 ramask, u8 rateid, int sgi)
 {
 	struct h2c_cmd h2c;
-	u8 bw = 0;
+	u8 bw = RTL8XXXU_CHANNEL_WIDTH_20;
 
 	memset(&h2c, 0, sizeof(struct h2c_cmd));
 
-- 
2.20.1

