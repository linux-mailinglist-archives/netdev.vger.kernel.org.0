Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9073271F6
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 11:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhB1Kxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 05:53:34 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:52480 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231149AbhB1KxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 05:53:11 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id GJTalhz13lChfGJTklvZU0; Sun, 28 Feb 2021 11:39:12 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614508752; bh=BCMzyFPGjvLZKNUS2sizrsXN5C/G8I7qiN9C3GvALOQ=;
        h=From;
        b=pPaATL6SaqBU+PARPe8/2w2axAMxjc7srRVKrIWhp1Lr1DeJj1i4DPLj0zZXJDzvX
         gLQxcun5BkKHoOqWa14kRjs1UKbgc+jWubl7I/hlTg8eSlFX06qduvN3lToJJ+7h6d
         s9DOL2GJunzpwLWN3oGGATKMEyDCcxhrvPL7C69YoCvBcLtCfntTFZ6XO30gTZnjjD
         8FK0EhbEPFJqsjNVNtxPiDHXyI9NaitVnoEMHN2IuoxUbh5wU9fQB6KheMbA39EWuL
         X+P37kjuWC/K6b1waA2GapoOGDl5LC0QPDa+mByTuGxJGOHPvhHrCZqRXppRrDdK4+
         0N3OOwrWRNJ9g==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603b72d0 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=YyHhdtpqV3cun0yf7GkA:9
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
Subject: [PATCH v3 4/6] can: c_can: use 32-bit write to set arbitration register
Date:   Sun, 28 Feb 2021 11:38:53 +0100
Message-Id: <20210228103856.4089-5-dariobin@libero.it>
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

The arbitration register is already set up with 32-bit writes in the
other parts of the code except for this point.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

(no changes since v1)

 drivers/net/can/c_can/c_can.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 69526c3a671c..7081cfaf62e2 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -297,8 +297,7 @@ static void c_can_inval_msg_object(struct net_device *dev, int iface, int obj)
 {
 	struct c_can_priv *priv = netdev_priv(dev);
 
-	priv->write_reg(priv, C_CAN_IFACE(ARB1_REG, iface), 0);
-	priv->write_reg(priv, C_CAN_IFACE(ARB2_REG, iface), 0);
+	priv->write_reg32(priv, C_CAN_IFACE(ARB1_REG, iface), 0);
 	c_can_inval_tx_object(dev, iface, obj);
 }
 
-- 
2.17.1

