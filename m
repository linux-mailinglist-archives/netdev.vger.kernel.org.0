Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082EF4C3DF9
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 06:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbiBYFkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 00:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237594AbiBYFkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 00:40:32 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160FA2C0305
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 21:40:00 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 4C25E202A2; Fri, 25 Feb 2022 13:39:59 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next 2/3] mctp i2c: Fix potential use-after-free
Date:   Fri, 25 Feb 2022 13:39:37 +0800
Message-Id: <20220225053938.643605-3-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220225053938.643605-1-matt@codeconstruct.com.au>
References: <20220225053938.643605-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb is handed off to netif_rx() which may free it.
Found by Smatch.

Reported-By: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 drivers/net/mctp/mctp-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 365c3dfd4034..470682c88d7e 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -338,7 +338,7 @@ static int mctp_i2c_recv(struct mctp_i2c_dev *midev)
 
 	if (status == NET_RX_SUCCESS) {
 		ndev->stats.rx_packets++;
-		ndev->stats.rx_bytes += skb->len;
+		ndev->stats.rx_bytes += recvlen;
 	} else {
 		ndev->stats.rx_dropped++;
 	}
-- 
2.32.0

