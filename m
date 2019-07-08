Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA8861EC1
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730961AbfGHMtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:49:06 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:35141 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729110AbfGHMtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:49:05 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MrhHm-1iGSIj2jCe-00nh6M; Mon, 08 Jul 2019 14:48:45 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Yash Shah <yash.shah@sifive.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH] [net-next] macb: fix build warning for !CONFIG_OF
Date:   Mon,  8 Jul 2019 14:48:23 +0200
Message-Id: <20190708124840.3616530-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:X+taGt58qrgWMOLWMf4Bvf333mJptyDHQK7HA/HpVPPyZF7xrMQ
 tjuy5Qx2f3YuT6ZgYHZJn8eFFjPfNQxAnOzZsHk4xaUaqhWqqHwItVDRjyDGRp7qiQFmkyi
 sgP3yzk7u0HzZ6I4I2LDVxXSbZnM7plMQR/LNRJ5djXPcQc0D7G++x/PlOagPjcPDVJW6HL
 +7Ksk5XLkP5+Xco33sUIQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0186pYpNvdU=:TDOWwKRi0pGg6Giz7TyYjK
 oqGpJyjCwnbUFBXq/8lJW9MEOOzaskgFqY4pT8U7iWfGCER4waEjiVORkYV1ajdA8U6pN2ZFl
 1qtZD+TOweWKTKCb4B9rttD3Y4aRx51uE32Vl8EsRHdBR9mcAUu8xo+Hs8BV0NGsfqmyBN0uD
 TjtoLDmatHiZqgW78tZBjebWmOFCIpZtOJngEExmInL7Oe+sLi6dHwO+d3pHB4TEIZxyMo+jn
 27EJld3BGiJzm39XYRjKT6kMtLrS6zg2KYAEj30J/uKNvvnvNeZ/H7oVJArvVSiUaAsvih4mr
 YWbN9+3rFqf+jgv4ikHAybdMI4bNYNVddWiID+9k14A0Fvg4o/XMuLQBIT5YjtQH6ayWDtsVN
 NOAFfAB0zL4DwgM19+3L6o3s6vGf1058VwQOtP+anwDrrCzgcHUrzUhhJokh41ETsFOwW5DGw
 SaFn6nJ0conYI/jHon06vYrByVVvgBD8M6nNqJxlmUjK1/VIrkA1YvPEJtxCNTY178Jvy6uZj
 5pUkQ86dj7xH1tYTtvUsxikUC/pnq2ymCMcZm4wB34fJ6fp0TWWmFsZAkbzMMfhX/s5BeD313
 GgoJ8+1MJSQzRwxn6R2JHypu9snUDib01QBrsrHUp6BnhkTaoun6KexWptJsmZRhChJ8pprgK
 ySiUz3Iwpbg5zVGn4loe3oKUiwo5SmA5Po8RLaXQ3VQb7adhpoOOGdrAISWzYVNAEmETlu0xG
 kfDOKtx023fLuH2GyHsJewYgoWvGZBL87jB9Vw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_OF is disabled, we get a harmless warning about the
newly added variable:

drivers/net/ethernet/cadence/macb_main.c:48:39: error: 'mgmt' defined but not used [-Werror=unused-variable]
 static struct sifive_fu540_macb_mgmt *mgmt;

Move the variable closer to its use inside of the #ifdef.

Fixes: c218ad559020 ("macb: Add support for SiFive FU540-C000")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a27d32f69de9..5ca17e62dc3e 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -45,8 +45,6 @@ struct sifive_fu540_macb_mgmt {
 	struct clk_hw hw;
 };
 
-static struct sifive_fu540_macb_mgmt *mgmt;
-
 #define MACB_RX_BUFFER_SIZE	128
 #define RX_BUFFER_MULTIPLE	64  /* bytes */
 
@@ -3628,6 +3626,8 @@ static int macb_init(struct platform_device *pdev)
 /* max number of receive buffers */
 #define AT91ETHER_MAX_RX_DESCR	9
 
+static struct sifive_fu540_macb_mgmt *mgmt;
+
 /* Initialize and start the Receiver and Transmit subsystems */
 static int at91ether_start(struct net_device *dev)
 {
-- 
2.20.0

