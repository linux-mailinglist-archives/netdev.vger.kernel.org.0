Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5030186E3C
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 16:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbgCPPG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 11:06:28 -0400
Received: from smtp2.ustc.edu.cn ([202.38.64.46]:41231 "EHLO ustc.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731672AbgCPPG2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 11:06:28 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 11:06:27 EDT
Received: from xhacker (unknown [101.86.20.80])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygDn74sFlG9eEGFPAA--.3001S2;
        Mon, 16 Mar 2020 22:58:13 +0800 (CST)
Date:   Mon, 16 Mar 2020 22:56:36 +0800
From:   Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: mvneta: Fix the case where the last poll did not
 process all rx
Message-ID: <20200316225636.78b08da4@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygDn74sFlG9eEGFPAA--.3001S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xryktw1rtFy7tF1xCw4Durg_yoWkWrb_W3
        Z7ZF9Iqw40gF10kw4kZr4rAryFyF1qqFs5AFs2qrWSqayxGF13Xrn5CFZYv3yDC3yayFyD
        GwsI9ay2y3WaqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbF8YjsxI4VWkKwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z2
        80aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
        zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx
        8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCa
        FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
        Wlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j
        6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr
        1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8
        JrUvcSsGvfC2KfnxnUUI43ZEXa7IU5PpnJUUUUU==
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

For the case where the last mvneta_poll did not process all
RX packets, we need to xor the pp->cause_rx_tx or port->cause_rx_tx
before claculating the rx_queue.

Fixes: 2dcf75e2793c ("net: mvneta: Associate RX queues with each CPU")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 98017e7d5dd0..11babc79dc6c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3036,11 +3036,10 @@ static int mvneta_poll(struct napi_struct *napi, int budget)
 	/* For the case where the last mvneta_poll did not process all
 	 * RX packets
 	 */
-	rx_queue = fls(((cause_rx_tx >> 8) & 0xff));
-
 	cause_rx_tx |= pp->neta_armada3700 ? pp->cause_rx_tx :
 		port->cause_rx_tx;
 
+	rx_queue = fls(((cause_rx_tx >> 8) & 0xff));
 	if (rx_queue) {
 		rx_queue = rx_queue - 1;
 		if (pp->bm_priv)
-- 
2.24.0


