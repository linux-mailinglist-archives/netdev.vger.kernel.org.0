Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EAC480D35
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbhL1VPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhL1VPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:15:21 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97195C061574;
        Tue, 28 Dec 2021 13:15:20 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id c66so12364034wma.5;
        Tue, 28 Dec 2021 13:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CzlhoSU/pOiVyXee3kNsw2hksYzIheCUqtx/f2txkkg=;
        b=HdBnvWb9tw87lcNiEqu22C6OoNShxUnwemrncXp9lKUx8XMsvIOWOhtPOeSK6smU4Z
         P3nRJ/JkzblktJvCeyUmd0TsfCfzeNiIAnN3hRHfJ3gbq5rGtWn1W8NYdTQcBDn4YzQq
         gaQKqfjCSSifzezuZPRWhqZXiMGXhA5KE8YzEyOkCd+xBtjBtlSkZHeHNpwLnn6hLkEc
         ZXckBtYMjh5m57/MPB2lllD+oY91z+XT0Fq/ipDa2f10eLnGTRsoK0MrnacSNLK1wx2a
         FswiA7/LpRy6CjBu64h0p1P5bqys9+yGonxbwWu2HtjmfQ1yTf+RXgM8Xhj7KJR1XBvW
         GDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CzlhoSU/pOiVyXee3kNsw2hksYzIheCUqtx/f2txkkg=;
        b=y4zqJkA47hhr8w6b4AFfe07bkKCwn0/23Iv5wzoGdvmoAu8EcOt5AIb4fgbbc7lsKy
         4T4oJddWdsZryF/4YF8St0t4dj5hs91XQQqhINCXU/sQtrKulf6IgBtww89WxaffLhwL
         5vO0MdGtH9h//UNnEm/3XAv02tSygrnDlMZRU7qrF095hE9HmKU11XUDjJ10pab7tVvd
         tjSt1/BrTEAPLy1E4zTPB0SijU2A6RZNvUSKfFGajlnnkFmROx0KoHMjQ0DU930f22Fv
         5gNeKlTkjLg1NxMFsNXd9OOTYU7lrzgAtzwXuk6g6xdCU2oCaKL7Z1bDX7WImV2AiiVk
         +qIg==
X-Gm-Message-State: AOAM530CjxzSDxytVk7spgMFQSQExngUQrrUbEuazwJ72p7Z7K4+/7ep
        xvu3sbw1BeKyfPZMbiUmGjjAvKtcK80=
X-Google-Smtp-Source: ABdhPJzkrK0OrdINgMoBVIa8GgpKot110yJKfw67O5Jm52mF/0hT16ZYW8zintLZSh7q/3qnsZpTQQ==
X-Received: by 2002:a7b:ce8e:: with SMTP id q14mr19384307wmj.51.1640726118769;
        Tue, 28 Dec 2021 13:15:18 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c1d2-d400-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:c1d2:d400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id o11sm21939036wmq.15.2021.12.28.13.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 13:15:18 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 0/9] rtw88: prepare locking for SDIO support
Date:   Tue, 28 Dec 2021 22:14:52 +0100
Message-Id: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
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
We are at a point where scanning, assoc etc. works (though it's not
fast yet, in my tests I got ~6Mbit/s in either direction).

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


[0] https://github.com/xdarklight/linux/tree/rtw88-sdio-locking-prep-linux-next-20211226
[1] https://lore.kernel.org/linux-wireless/CAFBinCDMPPJ7qW7xTkep1Trg+zP0B9Jxei6sgjqmF4NDA1JAhQ@mail.gmail.com/
[2] https://lore.kernel.org/netdev/2170471a1c144adb882d06e08f3c9d1a@realtek.com/T/


Martin Blumenstingl (9):
  mac80211: Add stations iterator where the iterator function may sleep
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
 drivers/net/wireless/realtek/rtw88/mac80211.c | 14 +++++-
 drivers/net/wireless/realtek/rtw88/main.c     | 47 +++++++++----------
 drivers/net/wireless/realtek/rtw88/main.h     |  4 +-
 drivers/net/wireless/realtek/rtw88/phy.c      |  4 +-
 drivers/net/wireless/realtek/rtw88/ps.c       |  2 +-
 drivers/net/wireless/realtek/rtw88/util.h     |  4 +-
 drivers/net/wireless/realtek/rtw88/wow.c      |  2 +-
 include/net/mac80211.h                        | 21 +++++++++
 net/mac80211/util.c                           | 13 +++++
 12 files changed, 94 insertions(+), 55 deletions(-)

-- 
2.34.1

