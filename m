Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D5A4CE483
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 12:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiCELW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 06:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCELWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 06:22:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E0F4C786
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 03:22:03 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646479322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WuOENprYDnP+19P9ik900a+QHoS+q8+h0KL/c7di0fQ=;
        b=UUmwWLsiORnbb2oK97OX7BxEiNhvkMaa+LygOAPM+gGj30AQaxRRprSHO+hrwdB5v+lEQT
        sUl0kLDELMuByKZ1vuusofcsy6xuV1VtUYXdJXM/sn7OHdV0COBukTYJ9R7yYmRr2Ih8Tj
        EOJyTHgXth+K5/2sZ1DO92tjlTu8+LF683Dkc1Vsg05j9YYK2RtQe9q4YjdfkCRhs+J/gq
        4rilyS1Elq0NaNyDPx8tIZnaAJQfiu2uE1eKq7nb6tbMzRNm9ETuxm+IE5b1am3t7LxAxc
        11kK7JFe3BjNYVDoMRrf0bmnEIiPIlEmIIVS5bNf9gX1gnliahLJmbLjElbu5g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646479322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WuOENprYDnP+19P9ik900a+QHoS+q8+h0KL/c7di0fQ=;
        b=FG7vDjbQdqAZbT8TShczqp7mLRvmeDDc3o0NiDhygbH4kJ+crjt89/WziuNEBQ8lpYogzF
        r2KTnfE8qomO3WAA==
To:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 2/3] dp83640: Use generic ptp_msg_is_sync() function
Date:   Sat,  5 Mar 2022 12:21:26 +0100
Message-Id: <20220305112127.68529-3-kurt@linutronix.de>
In-Reply-To: <20220305112127.68529-1-kurt@linutronix.de>
References: <20220305112127.68529-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use generic ptp_msg_is_sync() function to avoid code duplication.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/phy/dp83640.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index c2d1a85ec559..ecfd34882d96 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -970,17 +970,6 @@ static void decode_status_frame(struct dp83640_private *dp83640,
 	}
 }
 
-static int is_sync(struct sk_buff *skb, int type)
-{
-	struct ptp_header *hdr;
-
-	hdr = ptp_parse_header(skb, type);
-	if (!hdr)
-		return 0;
-
-	return ptp_get_msgtype(hdr, type) == PTP_MSGTYPE_SYNC;
-}
-
 static void dp83640_free_clocks(void)
 {
 	struct dp83640_clock *clock;
@@ -1396,7 +1385,7 @@ static void dp83640_txtstamp(struct mii_timestamper *mii_ts,
 	switch (dp83640->hwts_tx_en) {
 
 	case HWTSTAMP_TX_ONESTEP_SYNC:
-		if (is_sync(skb, type)) {
+		if (ptp_msg_is_sync(skb, type)) {
 			kfree_skb(skb);
 			return;
 		}
-- 
2.30.2

