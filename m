Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4073384B
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 20:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfFCSh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 14:37:58 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45811 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbfFCSh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 14:37:57 -0400
Received: by mail-pg1-f195.google.com with SMTP id w34so8752599pga.12
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 11:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YZsnBAN22tVtHFJc56q+rxbdD8fX8T8HXkSym7OyHiQ=;
        b=Ps1O4MtbD2rEMRtRw6yvXGSxDXrH7HjPdY7KCq/lSlW7htShDFp+u033WFVJDjOXPb
         OLNlYon0Wpzph3sUz2BCPyDgUNjVZMpJf1kV0lUidQnpFyFPagCNB03AVdSVyyqUvAr/
         bxUU+BnIId5lrXnzJ6D/l5svsqW8IvWW9U+R8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YZsnBAN22tVtHFJc56q+rxbdD8fX8T8HXkSym7OyHiQ=;
        b=C3lq0hypQHAg6G+Cx9oPXbyVC0t2jBfooKRaLCB8zsVcccz+v9AaucAVUke3i+J0JE
         0bx8JSn4BOiu2ZUU/dolEBxJthmg3HIqhi2xNlQRrfq3PVo+WLbJlr9V9Zs3YlgrKl/Z
         GvQfvRgoPYpugYNR4rha2+lbrwEWHACdlLp5aAXaW9Kqyrx3AaO4MVL4Tk9DXmu3uwCS
         GNSqPsPnvS0ohtPg5Xl26IHLO/r1nxqMHgJLnXoJ/bIAgBUwJunRCYEzeyKuiM9W/Vr5
         AiTuFUmweo0lv88meM/9k/CS961XXDfoks1BF3tOmLZHfer4cCwIVrC+5F2GnKZbzs5P
         AgsQ==
X-Gm-Message-State: APjAAAXeSBcEciGsZTMkGIlRa1Te/8ohjGawbY4jV1XQ7PP1pOFnUchW
        lsckHuQDH9ZdZ6R4McoJRo/Bbw==
X-Google-Smtp-Source: APXvYqwbLiM1y3Cof2KgcMMeZ8t9NIYK+vbdXny/5bFAdCAVPmxQ/CP9Y2AV9T+xZdprrAWMKhZjdw==
X-Received: by 2002:a62:764d:: with SMTP id r74mr9422273pfc.110.1559587076759;
        Mon, 03 Jun 2019 11:37:56 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id t2sm14808969pfh.166.2019.06.03.11.37.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 11:37:56 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        linux-wireless@vger.kernel.org,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        netdev@vger.kernel.org, brcm80211-dev-list@cypress.com,
        Douglas Anderson <dianders@chromium.org>,
        linux-mmc@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Franky Lin <franky.lin@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 0/3] brcmfmac: sdio: Deal better w/ transmission errors waking from idle
Date:   Mon,  3 Jun 2019 11:37:37 -0700
Message-Id: <20190603183740.239031-1-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series attempts to deal better with the expected transmission
errors that we get when waking up (from idle) the SDIO-based WiFi on
rk3288-veyron-minnie, rk3288-veyron-speedy, and rk3288-veyron-mickey.

Some details about those errors can be found in
<https://crbug.com/960222>, but to summarize it here: if we try to
send the wakeup command to the WiFi card at the same time it has
decided to wake up itself then it will behave badly on the SDIO bus.
This can cause timeouts or CRC errors.

When I tested on 4.19 and 4.20 these CRC errors can be seen to cause
re-tuning.  Since I am currently developing on 4.19 this was the
original problem I attempted to solve.

On mainline it turns out that you don't see the retuning errors but
you see tons of spam about timeouts trying to wakeup from sleep.  I
tracked down the commit that was causing that and have partially
reverted it here.  I have no real knowledge about Broadcom WiFi, but
the commit that was causing problems sounds (from the descriptioin) to
be a hack commit penalizing all Broadcom WiFi users because of a bug
in a Cypress SD controller.  I will let others comment if this is
truly the case and, if so, what the right solution should be.

There wasn't a good resolution on v1 and it's been a while, so I'm
sending out a v2.  Other than changing patch #1 to a full revert, the
only other changes here are just to the patch descriptions.

Changes in v2:
- A full revert, not just a partial one (Arend).  ...with explicit Cc.
- Updated commit message to clarify based on discussion of v1.

Douglas Anderson (3):
  Revert "brcmfmac: disable command decode in sdio_aos"
  mmc: core: API for temporarily disabling auto-retuning due to errors
  brcmfmac: sdio: Disable auto-tuning around commands expected to fail

 drivers/mmc/core/core.c                       | 27 +++++++++++++++++--
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  9 +++----
 include/linux/mmc/core.h                      |  2 ++
 include/linux/mmc/host.h                      |  1 +
 4 files changed, 32 insertions(+), 7 deletions(-)

-- 
2.22.0.rc1.311.g5d7573a151-goog

