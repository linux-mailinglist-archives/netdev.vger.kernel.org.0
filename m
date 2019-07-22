Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1115E709E9
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732255AbfGVTlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:41:31 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39318 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfGVTla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:41:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so18147478pgi.6
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 12:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DVKdTNoigJK3tKLrAPYbGoGUg1JbXWzatImSN67GwBc=;
        b=OeH4xnRTpEcCwpDsbln+XVCEDATCRRhFSaioShscdA8yNTlsxxvy0eWwLU2OM5WV/c
         ai0cBFVknsdB24Q1JB5lfHsbzPcQYeVETDj2UWdIFvtOlDQ6afzXVBdpY6WHzlo9SOxC
         8JU/JxUj4CbZVvqUkGs3Y47KMXq1dD3wmtluQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DVKdTNoigJK3tKLrAPYbGoGUg1JbXWzatImSN67GwBc=;
        b=o1WNJZNfKdK3LKM2utqXV9blt4h9WhEJwo13f/UeQtGd8NibeUDUC/pHuwfo7frVFG
         /8aN/43kYBgk8jkYKEfEVchqJloG/hH+JZCE/aarByQ9sLnY/QO8geuaEq3BeBCzuU/I
         dAOKGeQNJC6LHNqL4OpxB7T55jXYKdAb8gkNklUCbkNaON7V19jKgqTykJ/9LBwBOy/b
         yGWFtFhO0ozlaEvVHDsmSuq/mpQwkyxuvTUwidCXS3CsdrmA1IycqZ9roswqyyiiKIIS
         a2cTa4ViurznnlrlWii37jpvMubUu0V54Dn0GPAcMHlHGU6i3EW9AxHenIT/dI72G4Qo
         gtAQ==
X-Gm-Message-State: APjAAAWEazbDbVL5wc48lj7vxX4l9AM2vrO2Hpc6ZFMxCneccAefn02T
        zHnWdpjWz1FhmWrkMX1gg++9UA==
X-Google-Smtp-Source: APXvYqxEQYeSxC6AA34sxzoDJbLZJgp0tP84qrw7fyPEIReuxzmhiIMgt4eKQcdcsm72+G8sCkgnlg==
X-Received: by 2002:a63:590f:: with SMTP id n15mr26207045pgb.190.1563824488798;
        Mon, 22 Jul 2019 12:41:28 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id z4sm29838803pgp.80.2019.07.22.12.41.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 12:41:28 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     Ganapathi Bhat <gbhat@marvell.com>, linux-wireless@vger.kernel.org,
        Andreas Fenkart <afenkart@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        linux-mmc@vger.kernel.org, davem@davemloft.net,
        Xinming Hu <huxinming820@gmail.com>,
        Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>
Subject: [PATCH v2 0/2] mmc: core: Fix Marvell WiFi reset by adding SDIO API to replug card
Date:   Mon, 22 Jul 2019 12:39:37 -0700
Message-Id: <20190722193939.125578-1-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As talked about in the thread at:

http://lkml.kernel.org/r/CAD=FV=X7P2F1k_zwHc0mbtfk55-rucTz_GoDH=PL6zWqKYcpuw@mail.gmail.com

...when the Marvell WiFi card tries to reset itself it kills
Bluetooth.  It was observed that we could re-init the card properly by
unbinding / rebinding the host controller.  It was also observed that
in the downstream Chrome OS codebase the solution used was
mmc_remove_host() / mmc_add_host(), which is similar to the solution
in this series.

So far I've only done testing of this series using the reset test
source that can be simulated via sysfs.  Specifically I ran this test:

for i in $(seq 1000); do
  echo "LOOP $i --------"
  echo 1 > /sys/kernel/debug/mwifiex/mlan0/reset

  while true; do
    if ! ping -w15 -c1 "${GW}" >/dev/null 2>&1; then
      fail=$(( fail + 1 ))
      echo "Fail WiFi ${fail}"
      if [[ ${fail} == 3 ]]; then
        exit 1
      fi
    else
      fail=0
      break
    fi
  done

  hciconfig hci0 down
  sleep 1
  if ! hciconfig hci0 up; then
    echo "Fail BT"
    exit 1
  fi
done

I ran this several times and got several hundred iterations each
before a failure.  When I saw failures:

* Once I saw a "Fail BT"; manually resetting the card again fixed it.
  I didn't give it time to see if it would have detected this
  automatically.
* Once I saw the ping fail because (for some reason) my device only
  got an IPv6 address from my router and the IPv4 ping failed.  I
  changed my script to use 'ping6' to see if that would help.
* Once I saw the ping fail because the higher level network stack
  ("shill" in my case) seemed to crash.  A few minutes later the
  system recovered itself automatically.  https://crbug.com/984593 if
  you want more details.
* Sometimes while I was testing I saw "Fail WiFi 1" indicating a
  transitory failure.  Usually this was an association failure, but in
  one case I saw the device do "Firmware wakeup failed" after I
  triggered the reset.  This caused the driver to trigger a re-reset
  of itself which eventually recovered things.  This was good because
  it was an actual test of the normal reset flow (not the one
  triggered via sysfs).

Changes in v2:
- s/routnine/routine (Brian Norris, Matthias Kaehlcke).
- s/contining/containing (Matthias Kaehlcke).
- Add Matthias Reviewed-by tag.
- Removed clear_bit() calls and old comment (Brian Norris).
- Explicit CC of Andreas Fenkart.
- Explicit CC of Brian Norris.
- Add "Fixes" pointing at the commit Brian talked about.
- Add Brian's Reviewed-by tag.

Douglas Anderson (2):
  mmc: core: Add sdio_trigger_replug() API
  mwifiex: Make use of the new sdio_trigger_replug() API to reset

 drivers/mmc/core/core.c                     | 28 +++++++++++++++++++--
 drivers/mmc/core/sdio_io.c                  | 20 +++++++++++++++
 drivers/net/wireless/marvell/mwifiex/sdio.c | 16 +-----------
 include/linux/mmc/host.h                    | 15 ++++++++++-
 include/linux/mmc/sdio_func.h               |  2 ++
 5 files changed, 63 insertions(+), 18 deletions(-)

-- 
2.22.0.657.g960e92d24f-goog

