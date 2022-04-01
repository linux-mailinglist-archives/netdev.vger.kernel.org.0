Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2042F4EE65E
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 05:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244321AbiDADD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 23:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244302AbiDADDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 23:03:54 -0400
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385222571AD
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 20:02:05 -0700 (PDT)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id EB7D5213EE; Fri,  1 Apr 2022 11:02:01 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1648782121;
        bh=934JdFOuGIknVTR+JPGFw+JFSJU8kXydjGhH+6oLces=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=EpHYc4QQy6cwLJ4ascen7VKYW0x4Ad4uT3Iua9NW86fbvbYTQYvH8Bzyyi4GxvIcE
         RIVs8dhUP6X+6mCdnyzxAeQuQ++AkIWFGnE8rpmm096jiNHY++qXU7C77ByqV3/yjR
         VBTqj3sqcTAHpGwwL3vJZCwBrg/8pJ9D7DLO23p8DGTMOV51r+K6wPZ3VWNIiuB7U6
         e+4XqfG3EOurO50YtAzIRC3l0HAXlVRDJf4bWcV4ljEkRSwE5EcK8FnGipF4ez/5lc
         1fCl3Tq1O9J+2vGSCPWVe2iymowZM8zkeXzNTswbgPKjDr8D5Ss7AqjEAb9zw7Uq3H
         d+L4A4D/wAw5g==
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     mjrinal@g.clemson.edu, jk@codeconstruct.com.au,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net 2/3] mctp i2c: correct mctp_i2c_header_create result
Date:   Fri,  1 Apr 2022 10:48:43 +0800
Message-Id: <20220401024844.1578937-3-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220401024844.1578937-1-matt@codeconstruct.com.au>
References: <20220401024844.1578937-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

header_ops.create should return the length of the header,
instead mctp_i2c_head_create() returned 0.
This didn't cause any problem because the MCTP stack accepted
0 as success.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 drivers/net/mctp/mctp-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index baf7afac7857..53846c6b56ca 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -553,7 +553,7 @@ static int mctp_i2c_header_create(struct sk_buff *skb, struct net_device *dev,
 	hdr->source_slave = ((llsrc << 1) & 0xff) | 0x01;
 	mhdr->ver = 0x01;
 
-	return 0;
+	return sizeof(struct mctp_i2c_hdr);
 }
 
 static int mctp_i2c_tx_thread(void *data)
-- 
2.32.0

