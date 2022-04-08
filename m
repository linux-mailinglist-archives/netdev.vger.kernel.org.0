Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D712B4F903F
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiDHIDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 04:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiDHIDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 04:03:07 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB8A10663F
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 01:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=C7ZjX1Ay6A/plBz2rUUu8D4qiQF
        xw0oR7oGq/pKxKlk=; b=ogqZkcL+bbHbO7CIyhql+OroIyHhLelivbaaveHiJrM
        0TqEqV+Z8yyjphNMQTQoC6rubhkjUmvyu6siOoWt6IsGl58UxSu8pEajUJ/yPzx2
        4B+I7r/Y7vesIl8/YqcJcSf9KAYRS4uw9RfTnn/e6PWrZhbWxltQU1NDMXA0ia2o
        =
Received: (qmail 3517144 invoked from network); 8 Apr 2022 10:00:48 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 8 Apr 2022 10:00:48 +0200
X-UD-Smtp-Session: l3s3148p1@v+kX/h/cTKQgAQnoAEvdAHNhR6IfKwZI
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-mmc@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        ath10k@lists.infradead.org, bcm-kernel-feedback-list@broadcom.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH 0/3] mmc: improve API to make clear {h|s}w_reset is for cards
Date:   Fri,  8 Apr 2022 10:00:41 +0200
Message-Id: <20220408080045.6497-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed in 2020 [1], Ulf and I agreed that it would be easier to
understand the {h|s}w_reset mechanisms if it was clear that they are for
cards. This series implements that by changing the parameter to mmc_card
where apropriate. Also, the callback into host drivers has been renamed
to 'card_hw_reset' to make it obvious what exactly the driver is
expected to reset.

I tested it with my Renesas boards, so far no regressions. Buildbots are
currently checking the series.

This series is based on mmc/next as of yesterday. A branch is here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git renesas/mmc/reset-api-v2

Looking forward to comments. Happy hacking,

   Wolfram

[1] https://lore.kernel.org/all/20200916090121.2350-1-wsa+renesas@sang-engineering.com/

Wolfram Sang (3):
  mmc: core: improve API to make clear mmc_hw_reset is for cards
  mmc: core: improve API to make clear that mmc_sw_reset is for cards
  mmc: improve API to make clear hw_reset callback is for cards

 drivers/mmc/core/block.c                             |  2 +-
 drivers/mmc/core/core.c                              | 12 +++++++-----
 drivers/mmc/core/mmc.c                               |  4 ++--
 drivers/mmc/core/mmc_test.c                          |  3 +--
 drivers/mmc/host/bcm2835.c                           |  2 +-
 drivers/mmc/host/dw_mmc.c                            |  2 +-
 drivers/mmc/host/meson-mx-sdhc-mmc.c                 |  2 +-
 drivers/mmc/host/mtk-sd.c                            |  2 +-
 drivers/mmc/host/sdhci.c                             |  2 +-
 drivers/mmc/host/sunxi-mmc.c                         |  2 +-
 drivers/mmc/host/uniphier-sd.c                       |  2 +-
 drivers/net/wireless/ath/ath10k/sdio.c               |  2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c  |  2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c          |  2 +-
 drivers/net/wireless/ti/wlcore/sdio.c                |  2 +-
 include/linux/mmc/core.h                             |  4 ++--
 include/linux/mmc/host.h                             |  2 +-
 17 files changed, 25 insertions(+), 24 deletions(-)

-- 
2.30.2

