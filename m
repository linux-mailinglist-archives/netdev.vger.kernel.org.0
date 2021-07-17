Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EC13CC64B
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 22:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbhGQUoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 16:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235549AbhGQUoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 16:44:11 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8005C061762;
        Sat, 17 Jul 2021 13:41:12 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l6so7879130wmq.0;
        Sat, 17 Jul 2021 13:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vG0sIpzBhVt6BJJBVFqkVBxLXJrhZTlu49Bhd8MJC9A=;
        b=Wnq6ro1U/OswcapqBzqmYALTMTKdw6WDZvEECOJkaSDjpRjhdnJP+K6G3a3oTgOM+k
         0ggOU8DnTqCrOJSUShMhlF5RJ+yI7XVIS+R+TzPADvWeJIPghPUcJd1B0BXm18wvDRqD
         yYBZxHCOHvF4MaDwaa6sCpCudz0FQxupbVoxmk49WA7ct0wlTvik0bvg9i1/LhytnRVP
         EiGh5fy1EHu13SbK8XXK8hcww6Junmcdvt9Q4YbyBtro6MJEU0tq9JutvIW45DiZ9KZZ
         wyH3KS3D4/B8Sn/iXfCPhsBmW9YohXoSjRMwIpYXTY6Q6YdL/8rNJGNQdR0hqzH7DVVq
         OeQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vG0sIpzBhVt6BJJBVFqkVBxLXJrhZTlu49Bhd8MJC9A=;
        b=AZ+JITg9ihBlcMj90EzOXv6I2yLZGQkl/R6HggN/Yvjbr2Vv2g0GZMZA1BsxaOBihc
         zi8R3E3vGugUYvcfVz6ZS6nJ0m4G+ShfX+oMcFgVuz5hqx4MCwwhPBMg837toXxza9LS
         OrKhW9vY3flKmyoz48HMGKzAE0p08K34gK8syseCmuCfUcoW1K0qZfzhuiBXVYeU/wmq
         Mc8B4Q2NAUmzAMLgw7rnIstzCTT0Rgchuh4axC4Cf+m8f/925Fcpr9A3Ukl3R5Sxsldy
         sBNPBCqVueYSJP+TGiSdakj3RwQGPsP31n17BDawVdiaKi0gwEi2R7UNKARPpkWcam7n
         vctg==
X-Gm-Message-State: AOAM53183/uiyR5sQpSUeNyNW8Q3OjYhgD4pcNU5gG/lZBZOTUaVJqwh
        UfGm0DycmnaoeqpeEp0gPoNbRw7UUbQ=
X-Google-Smtp-Source: ABdhPJxSwo07uM+I2ABeTgC9BqzvwaJO2QywvsOnBJomSwkoIjSWMfav00r8wbzEtfYKrtvH1uBNbg==
X-Received: by 2002:a7b:c1cd:: with SMTP id a13mr23607010wmj.75.1626554470334;
        Sat, 17 Jul 2021 13:41:10 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7602-4e00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7602:4e00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id n7sm14078357wmq.37.2021.07.17.13.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 13:41:09 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v1 0/7] rtw88: prepare locking for SDIO support
Date:   Sat, 17 Jul 2021 22:40:50 +0200
Message-Id: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello rtw88 and mac80211 maintainers/contributors,

there is an ongoing effort where Jernej and I are working on adding
SDIO support to the rtw88 driver.
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
see [0]):
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


[0] https://lore.kernel.org/linux-wireless/CAFBinCDMPPJ7qW7xTkep1Trg+zP0B9Jxei6sgjqmF4NDA1JAhQ@mail.gmail.com/


Martin Blumenstingl (7):
  mac80211: Add stations iterator where the iterator function may sleep
  rtw88: Use rtw_iterate_vifs where the iterator reads or writes
    registers
  rtw88: Use rtw_iterate_stas where the iterator reads or writes
    registers
  rtw88: Replace usage of rtw_iterate_keys_rcu() with rtw_iterate_keys()
  rtw88: Configure the registers from rtw_bf_assoc() outside the RCU
    lock
  rtw88: hci: Convert rf_lock from a spinlock to a mutex
  rtw88: fw: Convert h2c.lock from a spinlock to a mutex

 drivers/net/wireless/realtek/rtw88/bf.c       |  8 ++++++--
 drivers/net/wireless/realtek/rtw88/fw.c       | 14 +++++++-------
 drivers/net/wireless/realtek/rtw88/hci.h      | 11 ++++-------
 drivers/net/wireless/realtek/rtw88/mac80211.c |  2 +-
 drivers/net/wireless/realtek/rtw88/main.c     | 16 +++++++---------
 drivers/net/wireless/realtek/rtw88/main.h     |  4 ++--
 drivers/net/wireless/realtek/rtw88/phy.c      |  4 ++--
 drivers/net/wireless/realtek/rtw88/ps.c       |  2 +-
 drivers/net/wireless/realtek/rtw88/util.h     |  4 ++--
 drivers/net/wireless/realtek/rtw88/wow.c      |  2 +-
 include/net/mac80211.h                        | 18 ++++++++++++++++++
 net/mac80211/util.c                           | 13 +++++++++++++
 12 files changed, 64 insertions(+), 34 deletions(-)

-- 
2.32.0

