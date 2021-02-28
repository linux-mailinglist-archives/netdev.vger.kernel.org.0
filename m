Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBB73271FA
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 11:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhB1Ky7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 05:54:59 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:58298 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231159AbhB1Kyy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 05:54:54 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id GJTalhz13lChfGJTjlvZTR; Sun, 28 Feb 2021 11:39:12 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614508752; bh=j7GRCoTejXM7B9fJVl1bTmRrEzrTT3KamKBLcuWoSdk=;
        h=From;
        b=S++09HtKOd7NsyUEvUogB7sfUX1HJKvL8E/LrFK+pX2BoNxUMwqxFzdo3U+4Fa9fz
         KhrB3p9/Ee6hd4jetSeVKQh1MlPiu3Rx4SnhlWmTt6Qb0x+CtkHLtYMZRWYaYP3CgY
         /Ryn/paSS2kUR7MVmSWuJjgVAZXK2+orTjU46ZyWEx8U3TVVcTf3G3FNsWs2EzRHeH
         rvpxv7tFY8qK6fIfTQgtO8oWWHyBco3kExz84LE08r1X6GvR0OClTgNcEaPutd8l7y
         8lDalVh7PsZQxuJ8i1D7HXy9OafiKEG/vWIenOY22VmcyKZkH8VSzKM/bI2anu77zj
         Bp1hCA89BuK5A==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603b72d0 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=6WxvSi62EpDuW4hn7DoA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 3/6] can: c_can: fix control interface used by c_can_do_tx
Date:   Sun, 28 Feb 2021 11:38:52 +0100
Message-Id: <20210228103856.4089-4-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210228103856.4089-1-dariobin@libero.it>
References: <20210228103856.4089-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfKf6mdjx4+1dDh8aTbBL1Or40zLaH6Q46OnNiVZTRbX6vXk7HMwz9iRKkagOahmfqD+nJPwMTuoYU5gTk9FCTvVLSY1FUSTThguPSDWHUH8hfVZxRwzG
 VOLn1uB0LZaq5Y0qMy1U8MRFbWOG/fSuKXK+aT07TSNXaAsID1qxdPOhWhs+hCqZAv9CWGcgSCQO8WrKc65LJaz1akGvQdU1i/mVP3R0RzydIKeLoFHp9L3J
 aCnAWYNZ9eZdmvgj7p319ROtPIU58y3VBFHPS3Mv1UVhoxoCg5gyUDNSluA6bIkCPgP31dk25AZdMUusL8cfrObWM/hFlkbZSPvH7mIdeFXT7eXhcFshz1MS
 xZOOi5tqCAJBpCj0Xz1VKtS9gr6XLSenbJdWyD/9XMyFmoxUb1tayptymlYLZt97VDQO+QcFk21uwvSjPv99Apykb2LJwntoKoIDMbL/Te/GQunPNhml9qYU
 EKzsMAHdPeDlaOq8YcNPUdNln0uGpzn01sxDh1DINR0iWV5TXOvBERRUmJ3eT14NT1dk7JHi4yD7ZPEFmSC9XEXiYZfG8E0F2GKRnjAhP3Zuf4qSGJ4UkY1q
 4EqLiO4pcc2vx8hke6w+PSXxd2Wray6kr/0GgLJLZ57bB4xuK8RTEmRO/qeVATQN7vJiuUGHv7/qOUGHVPrznaB9yCK5QC9q/7wNcYA97gLR9Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to commit 640916db2bf7 ("can: c_can: Make it SMP safe") let RX use
IF1 (i.e. IF_RX) and TX use IF2 (i.e. IF_TX).

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

(no changes since v1)

 drivers/net/can/c_can/c_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index dbcc1c1c92d6..69526c3a671c 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -732,7 +732,7 @@ static void c_can_do_tx(struct net_device *dev)
 		idx--;
 		pend &= ~(1 << idx);
 		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
-		c_can_inval_tx_object(dev, IF_RX, obj);
+		c_can_inval_tx_object(dev, IF_TX, obj);
 		can_get_echo_skb(dev, idx, NULL);
 		bytes += priv->dlc[idx];
 		pkts++;
-- 
2.17.1

