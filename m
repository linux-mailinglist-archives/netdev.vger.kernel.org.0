Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FFB6B8466
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjCMWBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjCMWBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:01:43 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5232928E5F;
        Mon, 13 Mar 2023 15:01:19 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r11so2935701edd.5;
        Mon, 13 Mar 2023 15:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678744870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Snuz7L/SPQOqkHO5iS6yRIqkcA3uKtikSk3qXURmy/s=;
        b=qARHr0pHEWd/D8VXl1UlK8tvFsJkwGtzIHUs99GzrnZjjURpZH5tyKQyQIG6br+tXf
         j2SFX8AdCJfZzLv+ep42ZIjRhk0nB6a2P1X8ZAfduJp96g/4JvXLqGxaCa3vy6WNxs+R
         GsmcugJ6/T0QKmNRALKNDgeFJgkVsPJGu3Tf85Lghcc0ZPmJdre6HQW+MsXoxcqgC6Pl
         UfkXYLZYTBc4gPJGkHuES8DYMIttgNLa+6pTnGhaO36EBVYbv3WSaXXByv7pqSHss4bS
         9xTOtGNZO6YrwW8uBefaW1wtjih1wrk2DKqTE4rGX9yH1W2tFhZKa3tLB9YFRDZfMktb
         d98Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678744870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Snuz7L/SPQOqkHO5iS6yRIqkcA3uKtikSk3qXURmy/s=;
        b=uOLjJarifQlk5Lxy/7x9T9EpbJYiWX/8d7ZeDGDmPShGEaLXMjaQXDsBNJ0RK/HMWM
         u9urN7g0csoLnWUzfam2rrT3om1blRlcqGmzTlzIscGuiGjqjH2+uxRcuGgfQcU4knMH
         EqoMahTJV7rzkZq93JnXz10d24FrfpfX1msgi6qMPCSN39y6U6wVtUojBFT/Qfb0Nl1T
         72gSUW0v3wefI30jgB6wxWn76QFLlQQbLNU9l38SdnFNagL6JHm6Dzr4zKO/QoTLavYw
         Y+BpdSbh23sNWRFf6xwMWS2Q9C6eO/F37F4wSZW2kB/jfW86HhcJG02qHMdm6qCj7B45
         n2Tw==
X-Gm-Message-State: AO0yUKWmcsaWdb/FTmIKCVjS0gBskmCySoOVIszBqRf0OqxIJasHV56u
        RLJ2j4bcHfH/52yAvg2oUDs=
X-Google-Smtp-Source: AK7set/kwJQ9s/J9GUVwdHgCzRQApL3FIPXVq584ztRTXDylNuT8xyEoIJwSbtHwn05xNr7u06lmog==
X-Received: by 2002:a17:906:371a:b0:8b1:319c:c29e with SMTP id d26-20020a170906371a00b008b1319cc29emr12360ejc.74.1678744870317;
        Mon, 13 Mar 2023 15:01:10 -0700 (PDT)
Received: from localhost.localdomain (077222238142.warszawa.vectranet.pl. [77.222.238.142])
        by smtp.googlemail.com with ESMTPSA id u17-20020a17090626d100b008c405ebc32esm286392ejc.28.2023.03.13.15.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 15:01:09 -0700 (PDT)
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
To:     steve.glendinning@shawell.net, davem@davemloft.net,
        edumazet@google.com
Cc:     kuba@kernel.org, pabeni@redhat.com, szymon.heidrich@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: smsc75xx: Limit packet length to skb->len
Date:   Mon, 13 Mar 2023 23:00:45 +0100
Message-Id: <20230313220045.52394-1-szymon.heidrich@gmail.com>
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
the actual socket buffer length (up to 9026 bytes). In such
case the cloned skb passed up the network stack will leak
kernel memory contents.

Fixes: d0cad871703b ("smsc75xx: SMSC LAN75xx USB gigabit ethernet adapter driver")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
---
 drivers/net/usb/smsc75xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 95de452ff..db34f8d1d 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -2212,7 +2212,8 @@ static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 				dev->net->stats.rx_frame_errors++;
 		} else {
 			/* MAX_SINGLE_PACKET_SIZE + 4(CRC) + 2(COE) + 4(Vlan) */
-			if (unlikely(size > (MAX_SINGLE_PACKET_SIZE + ETH_HLEN + 12))) {
+			if (unlikely(size > (MAX_SINGLE_PACKET_SIZE + ETH_HLEN + 12) ||
+				     size > skb->len)) {
 				netif_dbg(dev, rx_err, dev->net,
 					  "size err rx_cmd_a=0x%08x\n",
 					  rx_cmd_a);
-- 
2.39.2

