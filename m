Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F15324740
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbhBXXAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:00:10 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:40201 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235969AbhBXXAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 18:00:00 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id F32VlxCf1lChfF32blf7Ww; Wed, 24 Feb 2021 23:53:57 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614207237; bh=zrbOPNMigb21aFjhKEOuvQtWkpXK2Y1j2BXvj+PWIS8=;
        h=From;
        b=XEfg4qc01rtLuJ0Ua205sP6KUGopVoe5MhCOC2TLcLReWTkgrsfTWHK3BZbObHq2F
         J2AiKeB/Y12Bg4w1/lpiwlcbDVWOgv+1+mMjh67IdkDzeVbgml285H5p884MUlg3Jl
         seTkC01+VB4g2NxXD+hBB3jewCN1c/pdyt3GxjJh+x9J5wvVK8dQTNqWuptiVOlDYa
         IZdXkCw3LXpyEGZMYDj12Pu0SEcKTmMaHgdhAC9c/ClFMF4VTKN5wdCHzx15Sd+CVU
         vAUJhhskiLQ+a1jSLYFqzTqdJMV7bmpZhdcvs0ADc0X2RL47MFDiVP0sE6sRlp99Hj
         zdvYRHGgxk1tw==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=6036d905 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=6WxvSi62EpDuW4hn7DoA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/6] can: c_can: fix control interface used by c_can_do_tx
Date:   Wed, 24 Feb 2021 23:52:43 +0100
Message-Id: <20210224225246.11346-4-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210224225246.11346-1-dariobin@libero.it>
References: <20210224225246.11346-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfJkuawPBeIAI7RvLQt2PqRPk8oryQV6eJXSBCTbyPJNMKZ5EydhRp9g3DZXGMF1HSBWwV4zzACoFYMCty3ptPV7UMmluayJhF940XCkOjbucwpIKmNGn
 Jz6vyFim9ORgc1NHfEK0rPUbZ5BzSqMd+KRA6yCYCqpYymkntrqekdKlbOR1Oqzb2+wRXyv8hLOLNIu6ht3N0yiT1GoaxnN4q92wevNtJTKgnPZep19Uk5Q8
 CmOHFHzPxR5cgis75WP/k3R91/eV+cPbuWj4rx6b7rhAtelhX35PmCk9mBe6NY+ZJDsOGGkOV2Q9a+N/URJHrsup2+w/74kqYwo4vBjNFPD+X4rk3g8eXp2F
 j+/dN4lW+YXFYsSXQt7ueY6Xl07vbsszPhunCWYg8igatipAvnGkfdnOiX+DfO+3b4+iOLm+J+9bddtiyOPl/RiYFSzHC9WbQd181tAl/rl5wNhI/nx3Vkpd
 g6VVg+2mTUI2eMTOoKkh1I75rAGabjXkm/kwbPHHnItx/2rSebPZwZRklpiNY+F0OS+jNu9wALZczKXhInrDJgKWVCEb6NrigBhMjmu3SzoUMLUDC/gWrxPK
 x/yAFo3hC1S8HehAPnqZE+nd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to commit 640916db2bf7 ("can: c_can: Make it SMP safe") let RX use
IF1 (i.e. IF_RX) and TX use IF2 (i.e. IF_TX).

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

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

