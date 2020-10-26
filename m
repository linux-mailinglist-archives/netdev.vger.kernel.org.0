Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E86A2998E3
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 22:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389421AbgJZVd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 17:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387677AbgJZVd5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 17:33:57 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8687207C4;
        Mon, 26 Oct 2020 21:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603748036;
        bh=w8ZLzd4kKpLW6ezVVkkijju1OhfgRyCDIckcDfFDoQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7lUOX1UZJ8gPL5gL76lDFAc5yeT2Uwhj670BvzUZt4nfhBB+cCTxdRj+uAwaYGzB
         BnunQzEQ0IOFK/vB2NqpCd8T6sX1G7G918VzhhJuBgL40MggizRj1BFGncfOIBXBmH
         P5qh+cEHLhrVPkq6H6dNBV4KRIt1718WyA9MaClk=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Raja Mani <rmani@qca.qualcomm.com>,
        Suraj Sumangala <surajs@qca.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Vivek Natarajan <nataraja@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 09/11] ath6kl: fix enum-conversion warning
Date:   Mon, 26 Oct 2020 22:29:56 +0100
Message-Id: <20201026213040.3889546-9-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201026213040.3889546-1-arnd@kernel.org>
References: <20201026213040.3889546-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc -Wextra points out a type mismatch

drivers/net/wireless/ath/ath6kl/wmi.c: In function 'ath6kl_wmi_cmd_send':
drivers/net/wireless/ath/ath6kl/wmi.c:1825:19: warning: implicit conversion from 'enum <anonymous>' to 'enum wmi_data_hdr_data_type' [-Wenum-conversion]
 1825 |            false, false, 0, NULL, if_idx);
      |                   ^~~~~

As far as I can tell, the numeric value is current here,
so just use the correct enum literal instead of 'false'.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index dbc47702a268..b137e7f34397 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1821,8 +1821,8 @@ int ath6kl_wmi_cmd_send(struct wmi *wmi, u8 if_idx, struct sk_buff *skb,
 
 	/* Only for OPT_TX_CMD, use BE endpoint. */
 	if (cmd_id == WMI_OPT_TX_FRAME_CMDID) {
-		ret = ath6kl_wmi_data_hdr_add(wmi, skb, OPT_MSGTYPE,
-					      false, false, 0, NULL, if_idx);
+		ret = ath6kl_wmi_data_hdr_add(wmi, skb, OPT_MSGTYPE, false,
+				WMI_DATA_HDR_DATA_TYPE_802_3, 0, NULL, if_idx);
 		if (ret) {
 			dev_kfree_skb(skb);
 			return ret;
-- 
2.27.0

