Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868386619DA
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 22:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbjAHVQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 16:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236279AbjAHVNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 16:13:35 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC276561;
        Sun,  8 Jan 2023 13:13:34 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id u9so15699172ejo.0;
        Sun, 08 Jan 2023 13:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bLSs29m2k/lMHQ6XDcv3hBJ0yen+w+FGxdCOL8NhZtw=;
        b=NMcCks7IJSJQdfU5sY8Sa+bCHnDxpUbOQeW4aDTTI7IxT+WGUeICCWlWL4tIK4hRSR
         Hiu+pBw2L2pPl8bb6l+r50kRK91I8x4x40i+308xuq67GuDFa/M8RaWUKdfAMVEeRzXZ
         UdyCCM+KtPKA1V88j6pm8O3iSkivVstrm9G5ldcFT3YlBYS87bJ+g50Yj4SihwjMrttm
         DYE8qd9lU4XxerSyyHSOFtBhjawRRd/DF36hlypoWVraeQfKqm0YTWVyLbsgCv7atZz7
         GDg/lZQbDRHucNLqoHTjSv2XX9BIzcUZmQnvUmz+fZKbaxZCAd63yC668IhUXLVdJPmD
         SzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bLSs29m2k/lMHQ6XDcv3hBJ0yen+w+FGxdCOL8NhZtw=;
        b=DHC9E9rweyVqnd38JxUHNi6D/vZ5v7eJtQOxn0AnSKNcByuef7ETSkRa37dslUbxZ3
         s1ClNSqk+u/aH5GUW+yM+WdqbWUSMKYaTvpZgGfBO8//+S7po+5RkLZJhimEfiaJBV2S
         LUiLJgUQ0QrnNb9MSwQX1YQsARiMHvelqAhlEPjhDdzUo+z/8nfJqakdwtsQ+9Eq4Ppd
         2917L77Xjs03HZWWb0o/Gl1/VGz2wKZHlNlE92D+MfUy6VGeoV0n/v0epmCFN+w3t31N
         GSw8O2bumLX55wMFELMscsU+0nJvyj29XtrTrsjS3nsj8il5VC1vMcTcv34Ie4/BHutV
         sWlQ==
X-Gm-Message-State: AFqh2krmTVAgSg2hfYzoTTkXPylGAccX7z0TewOmGfuN7LMwTT8AH66H
        lCB43Y/3QBWM/SgDWHvZnpXPUZS2arM=
X-Google-Smtp-Source: AMrXdXvSrJQoChGgsLpb60y8kVWThgLnCaMn4bdheStc3ISiQCMyeU4MbuQWn1zgS/nJBKlazVBhnw==
X-Received: by 2002:a17:906:958:b0:7c0:be4d:46d6 with SMTP id j24-20020a170906095800b007c0be4d46d6mr48518624ejd.59.1673212412460;
        Sun, 08 Jan 2023 13:13:32 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c485-2500-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c485:2500::e63])
        by smtp.googlemail.com with ESMTPSA id x25-20020a170906b09900b0080345493023sm2847997ejy.167.2023.01.08.13.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 13:13:32 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 0/3] wifi: rtw88: Three locking fixes for existing code
Date:   Sun,  8 Jan 2023 22:13:21 +0100
Message-Id: <20230108211324.442823-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
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

This series consists of three patches which are fixing existing
behavior (meaning: it either affects PCIe or USB or both) in the rtw88
driver.
We previously had discussed patches for these locking issues while
working on SDIO support, but the problem never ocurred while testing
USB cards. It turns out that these are still needed and I think that
they also fix the same problems for USB users (it's not clear how often
it happens there though) - and possibly even PCIe card users.

The issue fixed by the second and third patches have been spotted by a
user who tested rtw88 SDIO support. Everything is working fine for him
but there are warnings [1] and [2] in the kernel log stating "Voluntary
context switch within RCU read-side critical section!".

The solution in the third and fourth patch was actually suggested by
Ping-Ke in [3]. Thanks again!

These fixes are indepdent of my other series adding SDIO support to the
rtw88 driver, meaning they can be added to the wireless driver tree on
top of Linux 6.2-rc1 or linux-next.


Changes since v1 at [4]:
- Keep the u8 bitfields in patch 1 but split the res2 field into res2_1
  and res2_2 as suggested by Ping-Ke
- Added Ping-Ke's reviewed-by to patches 2-4 - thank you!
- Added a paragraph in the cover-letter to avoid confusion whether
  these patches depend on the rtw88 SDIO support series

Changes since v2 at [5]:
- Added Ping-Ke's Reviewed-by and Sascha's Tested-by (thanks to both of
  you!)
- Dropped patch 1/4 "rtw88: Add packed attribute to the eFuse structs"
  This requires more discussion. I'll send a separate patch for this.
- Updated cover letter title so it's clear that this is independent of
  SDIO support code


[0] https://lore.kernel.org/linux-wireless/695c976e02ed44a2b2345a3ceb226fc4@realtek.com/
[1] https://github.com/LibreELEC/LibreELEC.tv/pull/7301#issuecomment-1366421445
[2] https://github.com/LibreELEC/LibreELEC.tv/pull/7301#issuecomment-1366610249
[3] https://lore.kernel.org/lkml/e0aa1ba4336ab130712e1fcb425e6fd0adca4145.camel@realtek.com/
[4] https://lore.kernel.org/linux-wireless/20221228133547.633797-1-martin.blumenstingl@googlemail.com/
[5] https://lore.kernel.org/linux-wireless/20221229124845.1155429-1-martin.blumenstingl@googlemail.com/


Martin Blumenstingl (3):
  wifi: rtw88: Move register access from rtw_bf_assoc() outside the RCU
  wifi: rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()
  wifi: rtw88: Use non-atomic sta iterator in rtw_ra_mask_info_update()

 drivers/net/wireless/realtek/rtw88/bf.c       | 13 +++++++------
 drivers/net/wireless/realtek/rtw88/mac80211.c |  4 +++-
 drivers/net/wireless/realtek/rtw88/main.c     |  6 ++++--
 3 files changed, 14 insertions(+), 9 deletions(-)

-- 
2.39.0

