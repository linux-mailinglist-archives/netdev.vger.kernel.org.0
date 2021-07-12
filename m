Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2EA3C4480
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 08:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbhGLGTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 02:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233866AbhGLGTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 02:19:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 894B5610A6;
        Mon, 12 Jul 2021 06:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070588;
        bh=VxsMsNEiiHntLXbNFK2z5oizrRdubsB1rGTW5mKr68U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=reTxpHpLee6X09XlLuLSGiBcrJsdt6lIC65TE1PFB090UL6tLn4lHnmUKoWMSDV6s
         O/mofUtq6kzp426EXeMQEc2DQ2ZBjVlp5/IU+Rgz+MKuZN2a4FEeS1hJHVmBMOhHmZ
         3iBwsYF8KG0TYsGS2+WMEnl/ZuA5uOsO+gg6Ue8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Karun Eagalapati <karun256@gmail.com>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 5.4 053/348] rsi: Assign beacon rate settings to the correct rate_info descriptor field
Date:   Mon, 12 Jul 2021 08:07:17 +0200
Message-Id: <20210712060708.712035417@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit b1c3a24897bd528f2f4fda9fea7da08a84ae25b6 upstream.

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
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210507213105.140138-1-marex@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rsi/rsi_91x_hal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -470,9 +470,9 @@ int rsi_prepare_beacon(struct rsi_common
 	}
 
 	if (common->band == NL80211_BAND_2GHZ)
-		bcn_frm->bbp_info |= cpu_to_le16(RSI_RATE_1);
+		bcn_frm->rate_info |= cpu_to_le16(RSI_RATE_1);
 	else
-		bcn_frm->bbp_info |= cpu_to_le16(RSI_RATE_6);
+		bcn_frm->rate_info |= cpu_to_le16(RSI_RATE_6);
 
 	if (mac_bcn->data[tim_offset + 2] == 0)
 		bcn_frm->frame_info |= cpu_to_le16(RSI_DATA_DESC_DTIM_BEACON);


