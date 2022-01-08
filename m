Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2AC48801E
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 01:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiAHAzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 19:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiAHAzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 19:55:51 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCE1C061574;
        Fri,  7 Jan 2022 16:55:50 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id x18-20020a7bc212000000b00347cc83ec07so1512601wmi.4;
        Fri, 07 Jan 2022 16:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dFR4sU5sRpt/4N13V2+Fteccg7CE/8N86O+LQZ2kMzM=;
        b=CL2ZWb8YaTjDkqC8Kdf5Fy7xjMnP6tFzUutAwiSdBTbbOB8EVczSUcoWXs8Xq4uD5P
         5oef6w9S8gOvZUkYnelmRDWGuFqIZGirRSm8Wg/H+SvPKaiaJqW5Q/gJSx/CRlRmS4G6
         iokzgfpPMqOhq1UWDuYDwzFH7sJ4wOZvXur6MZz0exE72lG4vRe0ybw56TwVV6reIcPP
         Gxb9ClJVOMDwrLbLfluTdwtcbIQb0OTjjaOwjw5SwOGF11Y6gBZl+azhEkhDXF2r2WrD
         lL92vDl5FKPR/tB799/gLwXnwPDIlNiqkiWZwliZMMc2JXaqTN4Ly+XQCKI0XRMnB86H
         zRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dFR4sU5sRpt/4N13V2+Fteccg7CE/8N86O+LQZ2kMzM=;
        b=iA6LaDiF+tMvrm1gXhW6Zst2XhBgFDfvDrXRdeabI6SgkXvyCORVgsmVnt1QSVr191
         3R4g/12ix7tRUq5kXsuwSzadWlT4uK4b4/kTgE2eBHQZEnxG7FWsGsQLcxQvqVQzBaK7
         JkSEopxAoDnaPD+7S9vdMjyDY9GgRUNmdMVr7d75wHAmjApAjKPD2BY+tAbcK942z7Dc
         jMtiZyggfD3vEyEwIUpPeBe4FNVZtzWqo/5Q4KNksuEcEoCKVDtW7j73Mh7Y4YOCOXIx
         bUmkq20+Gs0bSFYJ33w66EWZyYXPqobs+7DOnIA59UGPabHMLJuzh37ghLDc69daV639
         3zrA==
X-Gm-Message-State: AOAM5330evuWsF2R8gfnfuch97ECfpBCpbJsFrGXTu58nL+zA5fSmPOK
        SEX2pzhTy0yLGjHA125cYXkHJCg1E3U=
X-Google-Smtp-Source: ABdhPJwShcd2Hr9z42La6vX0jSssFiQJYLjqG1yo5FJQLMAmv7TXX+4mZojfKoRn5uz7zlSv12XKog==
X-Received: by 2002:a7b:cb98:: with SMTP id m24mr13205397wmi.188.1641603349194;
        Fri, 07 Jan 2022 16:55:49 -0800 (PST)
Received: from localhost.localdomain (dynamic-095-117-123-222.95.117.pool.telefonica.de. [95.117.123.222])
        by smtp.googlemail.com with ESMTPSA id z6sm77357wmp.9.2022.01.07.16.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 16:55:48 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>, Ed Swierk <eswierk@gh.st>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
Date:   Sat,  8 Jan 2022 01:55:25 +0100
Message-Id: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello rtw88 and mac80211 maintainers/contributors,

there is an ongoing effort where Jernej and I are working on adding
SDIO support to the rtw88 driver [0].
The hardware we use at the moment is RTL8822BS and RTL8822CS.
We are at a point where scanning, assoc etc. works. Performance is
better in the latest version:
- RX throughput is between 20Mbit/s and 25Mbit/s on RTL8822CS
- TX throughput varies a lot, typically it's between 25Mbit/s and
  50Mbit/s

This series contains some preparation work for adding SDIO support.
While testing our changes we found that there are some "scheduling
while atomic" errors in the kernel log. These are due to the fact
that the SDIO accessors (sdio_readb, sdio_writeb and friends) may
sleep internally.

Some background on why SDIO access (for example: sdio_writeb) cannot
be done with a spinlock held (this is a copy from my previous mail,
see [1]):
- when using for example sdio_writeb the MMC subsystem in Linux
  prepares a so-called MMC request
- this request is submitted to the MMC host controller hardware
- the host controller hardware forwards the MMC request to the card
- the card signals when it's done processing the request
- the MMC subsystem in Linux waits for the card to signal that it's
done processing the request in mmc_wait_for_req_done() -> this uses
wait_for_completion() internally, which might sleep (which is not
allowed while a spinlock is held)

Based on Ping-Ke's suggestion I came up with the code in this series.
The goal is to use non-atomic locking for all register access in the
rtw88 driver. One patch adds a new function to mac80211 which did not
have a "non-atomic" version of it's "atomic" counterpart yet.

As mentioned before I don't have any rtw88 PCIe device so I am unable
to test on that hardware.
I am sending this as an RFC series since I am new to the mac80211
subsystem as well as the rtw88 driver. So any kind of feedback is
very welcome!
The actual changes for adding SDIO support will be sent separately in
the future.


Changes since v2 at [3]:
- patch #1: dropped "mac80211: Add stations iterator where the iterator
  function may sleep" which was already applied to mac80211-next by
  Johannes (thanks!)
- patch #2 (previously #3): move locking to the (only) caller of
  rtw_ra_mask_info_update() to make the locking consistent with other
  functions. Thank you Ping-Ke for this suggestion!
- cover-letter: update link to the current SDIO work-in-progress code
  at [0]

Changes since v1 at [2] (which I sent back in summer):
- patch #1: fixed kernel doc copy & paste (remove _atomic) as suggested
  by Ping-Ke and Johannes
- patch #1: added paragraph about driver authors having to be careful
  where they use this new function as suggested by Johannes
- patch #2 (new): keep rtw_iterate_vifs_atomic() to not undo the fix
  from commit 5b0efb4d670c8 ("rtw88: avoid circular locking between
  local->iflist_mtx and rtwdev->mutex") and instead call
  rtw_bf_cfg_csi_rate() from rtw_watch_dog_work() (outside the atomic
  section) as suggested by Ping-Ke.
- patch #3 (new): keep rtw_iterate_vifs_atomic() to prevent deadlocks
  as Johannes suggested. Keep track of all relevant stations inside
  rtw_ra_mask_info_update_iter() and the iter-data and then call
  rtw_update_sta_info() while held under rtwdev->mutex instead
- patch #7: shrink the critical section as suggested by Ping-Ke


[0] https://github.com/xdarklight/linux/tree/rtw88-test-20220107
[1] https://lore.kernel.org/linux-wireless/CAFBinCDMPPJ7qW7xTkep1Trg+zP0B9Jxei6sgjqmF4NDA1JAhQ@mail.gmail.com/
[2] https://lore.kernel.org/netdev/2170471a1c144adb882d06e08f3c9d1a@realtek.com/T/
[3] https://lore.kernel.org/netdev/20211228211501.468981-1-martin.blumenstingl@googlemail.com/


Martin Blumenstingl (8):
  rtw88: Move rtw_chip_cfg_csi_rate() out of rtw_vif_watch_dog_iter()
  rtw88: Move rtw_update_sta_info() out of
    rtw_ra_mask_info_update_iter()
  rtw88: Use rtw_iterate_vifs where the iterator reads or writes
    registers
  rtw88: Use rtw_iterate_stas where the iterator reads or writes
    registers
  rtw88: Replace usage of rtw_iterate_keys_rcu() with rtw_iterate_keys()
  rtw88: Configure the registers from rtw_bf_assoc() outside the RCU
    lock
  rtw88: hci: Convert rf_lock from a spinlock to a mutex
  rtw88: fw: Convert h2c.lock from a spinlock to a mutex

 drivers/net/wireless/realtek/rtw88/bf.c       | 13 ++---
 drivers/net/wireless/realtek/rtw88/fw.c       | 14 +++---
 drivers/net/wireless/realtek/rtw88/hci.h      | 11 ++---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 12 ++++-
 drivers/net/wireless/realtek/rtw88/main.c     | 47 +++++++++----------
 drivers/net/wireless/realtek/rtw88/main.h     |  4 +-
 drivers/net/wireless/realtek/rtw88/phy.c      |  4 +-
 drivers/net/wireless/realtek/rtw88/ps.c       |  2 +-
 drivers/net/wireless/realtek/rtw88/util.h     |  4 +-
 drivers/net/wireless/realtek/rtw88/wow.c      |  2 +-
 10 files changed, 58 insertions(+), 55 deletions(-)

-- 
2.34.1

