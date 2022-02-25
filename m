Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B075C4C3DF8
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 06:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbiBYFkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 00:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237597AbiBYFke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 00:40:34 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9052C0322
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 21:40:01 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 5A0732029D; Fri, 25 Feb 2022 13:40:00 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next 3/3] mctp i2c: Fix hard head TX bounds length check
Date:   Fri, 25 Feb 2022 13:39:38 +0800
Message-Id: <20220225053938.643605-4-matt@codeconstruct.com.au>
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

We should be testing the length before fitting into the u8 byte_count.
This is just a sanity check, the MCTP stack should have limited to MTU
which is checked, and we check consistency later in mctp_i2c_xmit().

Found by Smatch
mctp_i2c_header_create() warn: impossible condition
    '(hdr->byte_count > 255) => (0-255 > 255)'

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 drivers/net/mctp/mctp-i2c.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 470682c88d7e..baf7afac7857 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -537,6 +537,9 @@ static int mctp_i2c_header_create(struct sk_buff *skb, struct net_device *dev,
 	struct mctp_hdr *mhdr;
 	u8 lldst, llsrc;
 
+	if (len > MCTP_I2C_MAXMTU)
+		return -EMSGSIZE;
+
 	lldst = *((u8 *)daddr);
 	llsrc = *((u8 *)saddr);
 
@@ -547,8 +550,6 @@ static int mctp_i2c_header_create(struct sk_buff *skb, struct net_device *dev,
 	hdr->dest_slave = (lldst << 1) & 0xff;
 	hdr->command = MCTP_I2C_COMMANDCODE;
 	hdr->byte_count = len + 1;
-	if (hdr->byte_count > MCTP_I2C_MAXBLOCK)
-		return -EMSGSIZE;
 	hdr->source_slave = ((llsrc << 1) & 0xff) | 0x01;
 	mhdr->ver = 0x01;
 
-- 
2.32.0

