Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A88B69812
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730849AbfGONrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730652AbfGONrQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:47:16 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4746A2067C;
        Mon, 15 Jul 2019 13:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198435;
        bh=lGV2uMNimGPV9nxzkGcnvRJAD5cl8EMe+T+ATROi8Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9AaHgZ9m51F1w9g/YRawUZcPZHLAzx0JveChXhQ13ACij/hkkcri9cIHC9WN95ih
         xppa2C0KBUpzp3hKPPdlZpLCxOO0fTSN60aj6D54hsbaQLPyPPnfIw33ok+qQO14Kg
         1tRQhKsFcoN1+xSbrPfbTxxYDiGKx+XYs9k7pad8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 005/249] wil6210: fix potential out-of-bounds read
Date:   Mon, 15 Jul 2019 09:42:50 -0400
Message-Id: <20190715134655.4076-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit bfabdd6997323adbedccb13a3fed1967fb8cf8f5 ]

Notice that *rc* can evaluate to up to 5, include/linux/netdevice.h:

enum gro_result {
        GRO_MERGED,
        GRO_MERGED_FREE,
        GRO_HELD,
        GRO_NORMAL,
        GRO_DROP,
        GRO_CONSUMED,
};
typedef enum gro_result gro_result_t;

In case *rc* evaluates to 5, we end up having an out-of-bounds read
at drivers/net/wireless/ath/wil6210/txrx.c:821:

	wil_dbg_txrx(wil, "Rx complete %d bytes => %s\n",
		     len, gro_res_str[rc]);

Fix this by adding element "GRO_CONSUMED" to array gro_res_str.

Addresses-Coverity-ID: 1444666 ("Out-of-bounds read")
Fixes: 194b482b5055 ("wil6210: Debug print GRO Rx result")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 4ccfd1404458..d74837cce67f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -750,6 +750,7 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 		[GRO_HELD]		= "GRO_HELD",
 		[GRO_NORMAL]		= "GRO_NORMAL",
 		[GRO_DROP]		= "GRO_DROP",
+		[GRO_CONSUMED]		= "GRO_CONSUMED",
 	};
 
 	wil->txrx_ops.get_netif_rx_params(skb, &cid, &security);
-- 
2.20.1

