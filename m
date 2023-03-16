Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647376BCD85
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjCPLGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjCPLGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:06:44 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC207433F;
        Thu, 16 Mar 2023 04:06:43 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r11so5995961edd.5;
        Thu, 16 Mar 2023 04:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678964802;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F5WQ0N/rs4oBEGQ7yiGxX/2aN2b2BoPIAwHy6SM8UXY=;
        b=DFYsXSD3coR6J61MZuSVLezPtMwuasrb/iflfxAMk6h6DzM7jBx2mXS4yixqZ3hn2n
         ek4dddFVEL3y+h7TB2jkL9wpDkMucxn1zq3s5qr0LqEHpPugrZ0+exbCbvtnUMhGN8D6
         getzIOav6pjdKLeG+7LayEQPX985weQL0mijD9lp6Jr3thPFcCzxnAXZuWRKmCkzAyEL
         bQ0PsltuojsgTy9crE4knOS+BzdHJRJ3bVUSRT5vd1W8b63HbfVJZhXRclrIPwIhbbYC
         FTaguef77Oo4fvVi0VIKeWcQJwf8/ciOq3dRjC6Vmx2jjy3KUGL1yUE5ne0vkwUVeb6L
         uN1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678964802;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F5WQ0N/rs4oBEGQ7yiGxX/2aN2b2BoPIAwHy6SM8UXY=;
        b=bZVIvG0J0jYsM14C27aKXXcDaiwFiZbU9DN6zo2MHUqBtQcPRohD1cCs6B3Gsv7kXy
         O6aDLRBxJgR8oST3iwJn9nR25oZuSgEKGw3vGp40vDtINOkNvRV3KJp9y6t23BxPG5px
         sixURTaDGu8yt3QUYONglLmi7Asyfhxx5F1WAw79c5C8ibbRQivyujy/SMc0VhnSf+69
         EW27Hi+nGmZckxn3JsCp5AlI2VD52wnWBqvOUtuVBXtxj163St2J/artjnVGITWQ3tHz
         w/oWNiZsNkCzSEFb4N0ZkI9c4HLIas+GvZK1sM/y3WaJwPs3tG2q8EqFd6QzKPVnmFi5
         8kXw==
X-Gm-Message-State: AO0yUKV5cpNtA8tvC1x3mPRiF8rO0hH8yEIGAy4xpaZzutq+Aw1jHDLi
        wxK0asJ89jnnRX7uB1yRj7U=
X-Google-Smtp-Source: AK7set8iNomNL2Mg+DCLClm39BS/+KTOfDMkzGJsZ2ib5srITdZCLhxr+x1EsXfYbchHZHwpLEXIcA==
X-Received: by 2002:a17:907:7daa:b0:930:8714:6739 with SMTP id oz42-20020a1709077daa00b0093087146739mr1878694ejc.30.1678964801798;
        Thu, 16 Mar 2023 04:06:41 -0700 (PDT)
Received: from localhost.localdomain (077222238142.warszawa.vectranet.pl. [77.222.238.142])
        by smtp.googlemail.com with ESMTPSA id i14-20020a170906264e00b00924f157dff8sm3709097ejc.50.2023.03.16.04.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 04:06:40 -0700 (PDT)
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
To:     kuba@kernel.org, steve.glendinning@shawell.net,
        davem@davemloft.net, edumazet@google.com
Cc:     pabeni@redhat.com, szymon.heidrich@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: smsc75xx: Move packet length check to prevent kernel panic in skb_pull
Date:   Thu, 16 Mar 2023 12:05:40 +0100
Message-Id: <20230316110540.77531-1-szymon.heidrich@gmail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packet length check needs to be located after size and align_count
calculation to prevent kernel panic in skb_pull() in case 
rx_cmd_a & RX_CMD_A_RED evaluates to true.

Fixes: d8b228318935 ("net: usb: smsc75xx: Limit packet length to skb->len")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
---
 drivers/net/usb/smsc75xx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index db34f8d1d..5d6454fed 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -2200,6 +2200,13 @@ static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		size = (rx_cmd_a & RX_CMD_A_LEN) - RXW_PADDING;
 		align_count = (4 - ((size + RXW_PADDING) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err rx_cmd_a=0x%08x\n",
+				  rx_cmd_a);
+			return 0;
+		}
+
 		if (unlikely(rx_cmd_a & RX_CMD_A_RED)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error rx_cmd_a=0x%08x\n", rx_cmd_a);
@@ -2212,8 +2219,7 @@ static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 				dev->net->stats.rx_frame_errors++;
 		} else {
 			/* MAX_SINGLE_PACKET_SIZE + 4(CRC) + 2(COE) + 4(Vlan) */
-			if (unlikely(size > (MAX_SINGLE_PACKET_SIZE + ETH_HLEN + 12) ||
-				     size > skb->len)) {
+			if (unlikely(size > (MAX_SINGLE_PACKET_SIZE + ETH_HLEN + 12))) {
 				netif_dbg(dev, rx_err, dev->net,
 					  "size err rx_cmd_a=0x%08x\n",
 					  rx_cmd_a);
-- 
2.40.0

