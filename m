Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB392461E3
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgHQJGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgHQJGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:06:53 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E9DC061389;
        Mon, 17 Aug 2020 02:06:53 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id f9so7382914pju.4;
        Mon, 17 Aug 2020 02:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7buGr9s4vDdmfFcp7FJ5w1tfBpkGyLuFUjEaq7LnnV4=;
        b=CFJYUdzB1vTMuMr8jhPfQP2EbWAy+0RyLmFaWOuBaoK9QKMwsrYMssPDjKKzOWh44n
         KLdWJ/TecAlHdtwj0QFwg3nqB0tmAbFG26qZ3/juw4DXiNn0OHunqNuUE/DcWv//4oj6
         5qZIOGgNv4LSQ+8VFOwPkVyHZA2spsYEa7ywgXj36ZnUhm0HnNvaD/Gui8y5ymv4UFSy
         CCdQBTk5SxP2D5ApXMQGQqXbtpHhF/qdFzPMLbWQn48gth6F61adipkYZEhdtOsbpZ2G
         DVwqTdAx28AfYyHIIWgAeobfjM6+g9pd6Sk/KE03Rf1WlMWxW1wQYgVhpT7XNXhuhe0R
         sfiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7buGr9s4vDdmfFcp7FJ5w1tfBpkGyLuFUjEaq7LnnV4=;
        b=A88PSU0ovPi7W07Rypu4DZSFZvkht0zdhiBjibRUFvPAYTGjFVh2zO8L8kirWoPxk+
         qGDjD2Kblu7yD8PBQzAu/x8FvN2gWA4nkLMBZF+4TFcfMAM7Lt121KenX48ZKm2RGZWJ
         Rbi+xU3a34O0hUqSNUS0CTGjifDihl370vQ7AitMxiFU/jTmNy2nI8Srz+GTUHrZIaAu
         7L+JPtxZVfh02JOQL+C0lzFCSFquzFRd1UCvx1QGtIYbZ8jrxJZ4rCwtWmBUx3dq8whP
         wsKdOgQ6L6vE3N7hmqY6oLcQLPsFoZq+uzUzk+2SJqMhXQkID9rFNvq4KEgz8UAKmaSr
         nUhA==
X-Gm-Message-State: AOAM532763aUl4nT3dR6cKv4SGCrZoQR+sMKHCUYlFFdg7tQDfDqoICk
        o9+bRKeFfaPbhm2W6ymUk1Q=
X-Google-Smtp-Source: ABdhPJzPTllLoNsNkQj/rOOihnUlYVgUwWEy805+NW3tdPuvPPeVtj6Eu3pzBeMFZM2prSeXG7az2Q==
X-Received: by 2002:a17:902:b602:: with SMTP id b2mr7335682pls.280.1597655212581;
        Mon, 17 Aug 2020 02:06:52 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:06:52 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     kvalo@codeaurora.org, kuba@kernel.org, jirislaby@kernel.org,
        mickflemm@gmail.com, mcgrof@kernel.org, chunkeey@googlemail.com,
        Larry.Finger@lwfinger.net, stas.yakovlev@gmail.com,
        helmut.schaa@googlemail.com, pkshih@realtek.com,
        yhchuang@realtek.com, dsd@gentoo.org, kune@deine-taler.de
Cc:     keescook@chromium.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 00/16] wirless: convert tasklets to use new tasklet_setup()
Date:   Mon, 17 Aug 2020 14:36:21 +0530
Message-Id: <20200817090637.26887-1-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts 
all the wireless drivers to use the new tasklet_setup() API

Allen Pais (16):
  wireless: ath5k: convert tasklets to use new tasklet_setup() API
  wireless: ath9k: convert tasklets to use new tasklet_setup() API
  wireless: ath: convert tasklets to use new tasklet_setup() API
  wireless: ath11k: convert tasklets to use new tasklet_setup() API
  wireless: atmel: convert tasklets to use new tasklet_setup() API
  wireless: b43legacy: convert tasklets to use new tasklet_setup() API
  wireless: brcm80211: convert tasklets to use new tasklet_setup() API
  wireless: ipw2x00: convert tasklets to use new tasklet_setup() API
  wireless: iwlegacy: convert tasklets to use new tasklet_setup() API
  wireless: intersil: convert tasklets to use new tasklet_setup() API
  wireless: marvell: convert tasklets to use new tasklet_setup() API
  wireless: mediatek: convert tasklets to use new tasklet_setup() API
  wireless: quantenna: convert tasklets to use new tasklet_setup() API
  wireless: ralink: convert tasklets to use new tasklet_setup() API
  wireless: realtek: convert tasklets to use new tasklet_setup() API
  wireless: zydas: convert tasklets to use new tasklet_setup() API

 drivers/net/wireless/ath/ath11k/ahb.c         |  7 +++---
 drivers/net/wireless/ath/ath5k/base.c         | 24 +++++++++----------
 drivers/net/wireless/ath/ath5k/rfkill.c       |  7 +++---
 drivers/net/wireless/ath/ath9k/ath9k.h        |  4 ++--
 drivers/net/wireless/ath/ath9k/beacon.c       |  4 ++--
 drivers/net/wireless/ath/ath9k/htc.h          |  4 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  6 ++---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  8 +++----
 drivers/net/wireless/ath/ath9k/init.c         |  5 ++--
 drivers/net/wireless/ath/ath9k/main.c         |  4 ++--
 drivers/net/wireless/ath/ath9k/wmi.c          |  7 +++---
 drivers/net/wireless/ath/ath9k/wmi.h          |  2 +-
 drivers/net/wireless/ath/carl9170/usb.c       |  7 +++---
 drivers/net/wireless/atmel/at76c50x-usb.c     |  9 ++++---
 .../net/wireless/broadcom/b43legacy/main.c    |  8 +++----
 drivers/net/wireless/broadcom/b43legacy/pio.c |  7 +++---
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c |  6 ++---
 .../broadcom/brcm80211/brcmsmac/mac80211_if.h |  2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c  |  9 ++++---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |  7 +++---
 .../net/wireless/intel/iwlegacy/3945-mac.c    |  8 +++----
 .../net/wireless/intel/iwlegacy/4965-mac.c    |  8 +++----
 .../net/wireless/intersil/hostap/hostap_hw.c  | 18 +++++++-------
 drivers/net/wireless/intersil/orinoco/main.c  |  7 +++---
 drivers/net/wireless/intersil/p54/p54pci.c    |  8 +++----
 drivers/net/wireless/marvell/mwl8k.c          | 16 ++++++-------
 drivers/net/wireless/mediatek/mt76/mac80211.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 +-
 .../wireless/mediatek/mt76/mt7603/beacon.c    |  4 ++--
 .../net/wireless/mediatek/mt76/mt7603/init.c  |  3 +--
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  2 +-
 .../net/wireless/mediatek/mt76/mt7615/mmio.c  |  6 ++---
 .../net/wireless/mediatek/mt76/mt76x02_dfs.c  | 10 ++++----
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 14 +++++------
 drivers/net/wireless/mediatek/mt76/tx.c       |  4 ++--
 drivers/net/wireless/mediatek/mt76/usb.c      | 12 +++++-----
 drivers/net/wireless/mediatek/mt7601u/dma.c   | 12 +++++-----
 .../quantenna/qtnfmac/pcie/pearl_pcie.c       |  7 +++---
 .../quantenna/qtnfmac/pcie/topaz_pcie.c       |  7 +++---
 .../net/wireless/ralink/rt2x00/rt2400pci.c    | 14 ++++++-----
 .../net/wireless/ralink/rt2x00/rt2500pci.c    | 14 ++++++-----
 .../net/wireless/ralink/rt2x00/rt2800mmio.c   | 24 +++++++++++--------
 .../net/wireless/ralink/rt2x00/rt2800mmio.h   | 10 ++++----
 drivers/net/wireless/ralink/rt2x00/rt2x00.h   | 10 ++++----
 .../net/wireless/ralink/rt2x00/rt2x00dev.c    |  5 ++--
 drivers/net/wireless/ralink/rt2x00/rt61pci.c  | 20 +++++++++-------
 drivers/net/wireless/realtek/rtlwifi/pci.c    | 21 ++++++++--------
 drivers/net/wireless/realtek/rtlwifi/usb.c    |  9 ++++---
 drivers/net/wireless/realtek/rtw88/main.c     |  3 +--
 drivers/net/wireless/realtek/rtw88/tx.c       |  4 ++--
 drivers/net/wireless/realtek/rtw88/tx.h       |  2 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c  |  8 +++----
 52 files changed, 208 insertions(+), 223 deletions(-)

-- 
2.17.1

