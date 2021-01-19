Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3472FAE9A
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 03:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393728AbhASCHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 21:07:15 -0500
Received: from m12-18.163.com ([220.181.12.18]:60624 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387895AbhASCHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 21:07:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=vHix2
        +n2QGovG//SAmKczG/2f6L1TM+9VB0Ed1N3GGs=; b=QNSjB7oGulC5j4n2SKI2T
        dg6MelHn97ZuEtGJrWCoWrslsgYH8IVuAzIU6xkPtiMDrLBGgxmW1Yo3Lb86wp26
        ymO9wOsX7ivSkd/7Z7H6B3+am/f5Cpc5a3MfsmYMjB66AuY7N8GX2EkSEyizAMro
        xCg5FL2LbX5knJk5kt5Qrk=
Received: from yangjunlin.ccdomain.com (unknown [119.137.52.160])
        by smtp14 (Coremail) with SMTP id EsCowAAn7tYzPgZg4b59Pw--.4219S2;
        Tue, 19 Jan 2021 10:04:37 +0800 (CST)
From:   angkery <angkery@163.com>
To:     mkl@pengutronix.de, manivannan.sadhasivam@linaro.org,
        thomas.kopp@microchip.com, wg@grandegger.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junlin Yang <yangjunlin@yulong.com>
Subject: [PATCH] can: mcp251xfd: mcp251xfd_handle_ivmif(): fix wrong NULL pointer check
Date:   Tue, 19 Jan 2021 10:02:21 +0800
Message-Id: <20210119020221.3713-1-angkery@163.com>
X-Mailer: git-send-email 2.24.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowAAn7tYzPgZg4b59Pw--.4219S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF1ktr4rtr4DuFWxKFy3urg_yoW3Krb_Cw
        nxAw17Wr18Aw1vk34IkF1avryYv3ZrXFs5ur9Fvry3JFWayr17GFZavry3G34UWry8ZF9x
        Xay7Jwn2q34FqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUeEPfDUUUUU==
X-Originating-IP: [119.137.52.160]
X-CM-SenderInfo: 5dqjyvlu16il2tof0z/xtbCBg0fI13I0cYuQwAAsY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Junlin Yang <yangjunlin@yulong.com>

if alloc_can_err_skb() returns NULL, we should check skb instead of cf.

Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index f07e8b7..0af131c 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1755,7 +1755,7 @@ static int mcp251xfd_handle_ivmif(struct mcp251xfd_priv *priv)
 			cf->data[2] |= CAN_ERR_PROT_TX | CAN_ERR_PROT_BIT0;
 	}
 
-	if (!cf)
+	if (!skb)
 		return 0;
 
 	err = can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
-- 
1.9.1


