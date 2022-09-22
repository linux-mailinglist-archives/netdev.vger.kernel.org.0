Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF18E5E6A2E
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbiIVR67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbiIVR6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:58:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBFD106538
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lqAWsxfXxdpX4gKv//U+Esm+JzwJ01Tg0WcoaWgfcqQ=; b=2y66qXn49RerR7lGgnN6Mn4MF0
        k0NX3O/lPiwxVSndMFdFdnLPUBrOi7RLHtifRU3w4nGL1O8nlDY37d7Q5GdD1XHGHZHO+aUyUejQW
        sxnmX/tvJhW3P3UMAq82s0yfzYcxsriKP8+mu+jMsmF4xZZAD0ITEmqQasf4tUPHjE7w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obQTA-00HYct-Ez; Thu, 22 Sep 2022 19:58:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     mattias.forsblad@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v2 05/10] net: dsa: qca8k: Drop replies with wrong sequence numbers
Date:   Thu, 22 Sep 2022 19:58:16 +0200
Message-Id: <20220922175821.4184622-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220922175821.4184622-1-andrew@lunn.ch>
References: <20220922175821.4184622-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A response with the wrong sequence number is likely to be a late
arriving responses, which the driver has already given up waiting for.
Drop it rather than signalling the complete. If the complete was
signalled, this late response could take the place of the genuine
reply which is soon to follow.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 2f92cabe21af..fdf27306d169 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -145,9 +145,9 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, mgmt_ethhdr->command);
 	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
 
-	/* Make sure the seq match the requested packet */
+	/* Make sure the seq match the requested packet. If not, drop. */
 	if (mgmt_ethhdr->seq == mgmt_eth_data->seq)
-		mgmt_eth_data->ack = true;
+		return;
 
 	if (cmd == MDIO_READ) {
 		mgmt_eth_data->data[0] = mgmt_ethhdr->mdio_data;
-- 
2.37.2

