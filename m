Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED057376BC6
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 23:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhEGVcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 17:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhEGVcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 17:32:31 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C82DC0613ED;
        Fri,  7 May 2021 14:31:31 -0700 (PDT)
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id F2F4182E47;
        Fri,  7 May 2021 23:31:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1620423084;
        bh=o4/gHmXu58eNBuIOxxGt66kzOFcAYTx++O+I5qwK17s=;
        h=From:To:Cc:Subject:Date:From;
        b=iBdNCaACtLdoOnLiCyqHIfxkaEt/A7E34W/t8RtkKklLoqicVA7kkIYOwx+4V7jAm
         hQu4btPU5xzzmQ4ZrW2lU7LheYFJpNNnC6f0UvurLPD2ZV5dzU00NZx3hvs/uvFcO/
         shEsE9TFV+AVnR735rCI/YoCS/85rIYvLzWHLaoJAzF2sJU5+q5XCqKGDopn/p6/BZ
         IdAO3Fya+4kJPR8Gmo98byWBtiP+MlD4/izqWXRPYViGcJ8uIR//JRBr55YSbNxlJc
         7/zaoTPg/KuPhfCvDUFgdN8kcJ3GRuKAryfnrFQueIMTnqLIloIDEpXSF/1sCdkGGd
         +ozUBr5BnwzIg==
From:   Marek Vasut <marex@denx.de>
To:     linux-wireless@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Karun Eagalapati <karun256@gmail.com>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] rsi: Assign beacon rate settings to the correct rate_info descriptor field
Date:   Fri,  7 May 2021 23:31:05 +0200
Message-Id: <20210507213105.140138-1-marex@denx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.102.4 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RSI_RATE_x bits must be assigned to struct rsi_data_desc rate_info
field. The rest of the driver does it correctly, except this one place,
so fix it. This is also aligned with the RSI downstream vendor driver.
Without this patch, an AP operating at 5 GHz does not transmit any
beacons at all, this patch fixes that.

Fixes: d26a9559403c ("rsi: add beacon changes for AP mode")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Cc: Angus Ainslie <angus@akkea.ca>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Karun Eagalapati <karun256@gmail.com>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index ce9892152f4d..ab837921d9a4 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -470,9 +470,9 @@ int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb)
 	}
 
 	if (common->band == NL80211_BAND_2GHZ)
-		bcn_frm->bbp_info |= cpu_to_le16(RSI_RATE_1);
+		bcn_frm->rate_info |= cpu_to_le16(RSI_RATE_1);
 	else
-		bcn_frm->bbp_info |= cpu_to_le16(RSI_RATE_6);
+		bcn_frm->rate_info |= cpu_to_le16(RSI_RATE_6);
 
 	if (mac_bcn->data[tim_offset + 2] == 0)
 		bcn_frm->frame_info |= cpu_to_le16(RSI_DATA_DESC_DTIM_BEACON);
-- 
2.30.2

