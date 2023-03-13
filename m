Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A3F6B8471
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjCMWCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjCMWCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:02:46 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055AA8E3CE;
        Mon, 13 Mar 2023 15:02:09 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id fd5so20685870edb.7;
        Mon, 13 Mar 2023 15:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678744927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mw1oEi8x/spO3700iwhP/jHnat9etEwB+9anearFVJA=;
        b=fj6u1aQxH9kGPaKnJutlfly8rY6Tc8nh4BcbFxBESqOMta+tzIkiA5zoCXjdXgjgrh
         RhjB8Zbz0MIKzFYb3UcWnBzLY9jnAQRfQ/iIIrjXUBw95GbuDE8LUe6vc+aMMb1dwMrT
         kVgRGTMxzSKVE7KkrImNiO4BoRkxC2o3n+CB1ewOwUyZKGlB3t1S06M4J7zblQD3GG3n
         +7lweClsM+xNdXyg7+EvaK/bP2EXFYBBXnyKR119TuWkdu3VZQLwbG/xHWj8ZmjNHYXB
         duSPTTPMu1EWShnpnuKMEqGakpHY+tOHrFZH62nxjYuGwqNTA/2GHrCT+GnWoyzkFb35
         LwwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678744927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mw1oEi8x/spO3700iwhP/jHnat9etEwB+9anearFVJA=;
        b=rzEpM6OjeCTwvSyUEhn6g5RHNXR4roH8GuQPhgHt8oyet4yMYd/2cXs6ro0kmAQJ8t
         X2Yz8lfTUbNzlT1I3iDULGcHTjpa3EAPeTCy5WFZ+bHhGFdEpNtX33hxsanWgXPtGkbq
         dYwV8iSw3CMjCoh6R2K6KwnY1kgY6ilXhwNIdAbvs9uDR1pU2+2Z3EsAXirKMDxv3vW6
         59oEMr5Lbcc3LD3hWct7qy+TrG80jqsTLO5SI7mHv3A2TtkbqHPruCiSylogN5oq9MEm
         GbtIaIYtHJ1JsL9o4IV1KZbftTSGRQTdK2tbnksakVfq6pBFWVXYW4uOa/Fq43fOPMI2
         j7Vw==
X-Gm-Message-State: AO0yUKXtU3LGx4EDFi/mjr3QvOyzXRfnXyvjkco4/Golcoc6pdN9ttqe
        J1YPzKlz6BAnU1KBQ3zwgGM=
X-Google-Smtp-Source: AK7set9x1DX7dDQFEd4i4rUbnBF0FHxshk+8AZoqwn1xBH6Tcg/UJhbAVYe8kIgUcX7lZc5W+uhfcA==
X-Received: by 2002:a05:6402:188:b0:4a3:43c1:8430 with SMTP id r8-20020a056402018800b004a343c18430mr13073923edv.4.1678744927024;
        Mon, 13 Mar 2023 15:02:07 -0700 (PDT)
Received: from localhost.localdomain (077222238142.warszawa.vectranet.pl. [77.222.238.142])
        by smtp.googlemail.com with ESMTPSA id r9-20020a50c009000000b004c13fe8fabfsm246146edb.84.2023.03.13.15.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 15:02:06 -0700 (PDT)
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
To:     steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com
Cc:     kuba@kernel.org, pabeni@redhat.com, szymon.heidrich@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: smsc95xx: Limit packet length to skb->len
Date:   Mon, 13 Mar 2023 23:01:24 +0100
Message-Id: <20230313220124.52437-1-szymon.heidrich@gmail.com>
X-Mailer: git-send-email 2.39.2
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

Packet length retrieved from skb data may be larger than
the actual socket buffer length (up to 1526 bytes). In such
case the cloned skb passed up the network stack will leak
kernel memory contents.

Fixes: 2f7ca802bdae ("net: Add SMSC LAN9500 USB2.0 10/100 ethernet adapter driver")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
---
 drivers/net/usb/smsc95xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 32d2c60d3..ba766bdb2 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1851,7 +1851,8 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			}
 		} else {
 			/* ETH_FRAME_LEN + 4(CRC) + 2(COE) + 4(Vlan) */
-			if (unlikely(size > (ETH_FRAME_LEN + 12))) {
+			if (unlikely(size > (ETH_FRAME_LEN + 12) ||
+				     size > skb->len)) {
 				netif_dbg(dev, rx_err, dev->net,
 					  "size err header=0x%08x\n", header);
 				return 0;
-- 
2.39.2

