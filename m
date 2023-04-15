Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018EA6E3204
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 17:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjDOPFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 11:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDOPFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 11:05:48 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A12B3C3B;
        Sat, 15 Apr 2023 08:05:47 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id eo6-20020a05600c82c600b003ee5157346cso13294318wmb.1;
        Sat, 15 Apr 2023 08:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681571146; x=1684163146;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zwxTHaEdDM59TU3KApuuMuKC7LO7W9mKFqhs96b3+4Y=;
        b=pAdy9OpNyRv1mrYm5Uf6HqbxZo6eUc4IkyHQXp3rLLZ3mtYZ5JGjiuiqFbMHKKQsW8
         f2jqPCpanpxfDRP5XdNa29FJKHCbor4KcQAYwoBbIMnih+wR7q2wou4w4yk+peU/1PHC
         JsA0uSgFlVerM0k+ZsZKPPKU9iEA8+1YgEoWuueDc7H5pYr17mcMmZVYSeA/5/WITs0I
         JDw5zqEG4TsECjYXYY3WvgBZmeWsrug2CelY+2KAJrem3AVMGTWzkt/kVG+kiJtyd49M
         phxJnQwMVnilskM8QkwUq9FA8YbO/gSeh9HgB8La2vqmdPn6eCFNJYhRxhqtXZ2/oMmf
         YEZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681571146; x=1684163146;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zwxTHaEdDM59TU3KApuuMuKC7LO7W9mKFqhs96b3+4Y=;
        b=hbLdzNVhW4HcMY4syGshv5V/s/rXmzIJ+U2PwZ/B7S4CcPzniXt+1dHfzdt2DUkzR6
         zvXrY+FpwBgrWgvIgQYurjUXFSRkHLqPXbtYx4lFZkVzVLnGIcI6MY6+lV+ji3qPbyit
         BjW8mTtYOtllraVLksnk6AwhcwqXaHOo5LK/wIoUH+OPRvoJ3hKKIjh0qxj7CWc/hHke
         A/rq8sCYYCFFpNYpFh6/lSCIWqKgbnsy+kyTIZ6CucAKZCMWsQgxW98mP3mcBLZOu3U3
         GA4mFcl/6y3GZ2TW08OiYuHfgf/WLoAr7iCIie+gswtw9PEs0h2KiB4s27PGsoCHQkXJ
         JA4A==
X-Gm-Message-State: AAQBX9e6SwVunlgTKkcX4zvINcqy/xDvbJi+TZQYVXcW9X4hgCoKdpJH
        U8l7arlU3ZctpzCnpYDzFXg=
X-Google-Smtp-Source: AKy350b4HGFEsNoz0CzqZsYFmqDwpZlqQr3G3X5b8lUqEm4pjyGBYq759ma7727uzhP6VWiEf58OxA==
X-Received: by 2002:a7b:c309:0:b0:3f0:967e:2cfb with SMTP id k9-20020a7bc309000000b003f0967e2cfbmr7122512wmj.36.1681571145574;
        Sat, 15 Apr 2023 08:05:45 -0700 (PDT)
Received: from skynet.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id i8-20020a5d5228000000b002efb4dc5a5fsm5990556wra.7.2023.04.15.08.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 08:05:45 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        chunkeey@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH] ath9k: fix calibration data endianness
Date:   Sat, 15 Apr 2023 17:05:42 +0200
Message-Id: <20230415150542.2368179-1-noltari@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

BCM63xx (Big Endian MIPS) devices store the calibration data in MTD
partitions but it needs to be swapped in order to work, otherwise it fails:
ath9k 0000:00:01.0: enabling device (0000 -> 0002)
ath: phy0: Ignoring endianness difference in EEPROM magic bytes.
ath: phy0: Bad EEPROM VER 0x0001 or REV 0x00e0
ath: phy0: Unable to initialize hardware; initialization status: -22
ath9k 0000:00:01.0: Failed to initialize device
ath9k: probe of 0000:00:01.0 failed with error -22

Fixes: eb3a97a69be8 ("ath9k: fetch calibration data via nvmem subsystem")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 4f00400c7ffb..1314fbc55c0b 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -615,7 +615,6 @@ static int ath9k_nvmem_request_eeprom(struct ath_softc *sc)
 
 	ah->nvmem_blob_len = len;
 	ah->ah_flags &= ~AH_USE_EEPROM;
-	ah->ah_flags |= AH_NO_EEP_SWAP;
 
 	return 0;
 }
-- 
2.39.2

