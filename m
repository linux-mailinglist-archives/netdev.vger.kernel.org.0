Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DC81CBD6C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgEIEgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:36:04 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40661 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgEIEgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:36:03 -0400
Received: by mail-pl1-f193.google.com with SMTP id t16so1628929plo.7;
        Fri, 08 May 2020 21:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mn8gewim71f9MERlb7gA0NrH5NCnMa/YvuN+gI3bitk=;
        b=HWFfRnGOGUvIT5VcT9f0YkgryhlYukuXmN8XhUzidvv+aaqrsFntfOSRXN5j9Kf/9c
         olJHoR7E5WEDzA8kCahNlbnzQg9DsWyNuwvU89FOTN6IN7jNZbnYV2bnw6p/3U2bVHgB
         dPRFopZXfRoG2CBh22jnXQY0owBug1C9u4zHJGM/2Ic0TuFcjXpRn+3kY+twvBq4U05W
         kRe5Sb2SzqUKYQYTLOPRmspgprUL9NszVpJS8w/GLdqnfREaST8xTeDe85aBEULig4T8
         8B0zy3PDxM8KmeNT94iYPD59jMkO8h0EsRDreD/cSDCI/EcopYQWcRwH5fXi5Z94Uba3
         Dr0w==
X-Gm-Message-State: AGi0PubjpNKtKXdj+eNN+xPu1+dKbGttW7Y0jsShpq0XEqu7XLTV4sGM
        x8f0QRd6yyGprV0bkBi+/rw=
X-Google-Smtp-Source: APiQypIl4pMOS2kvX+EgsVq1d+QYF+9vTl2JH1P6ntQ3rygaFhrG9ACBwQl0OeR7H5GcEcjmddEcOw==
X-Received: by 2002:a17:902:549:: with SMTP id 67mr5435858plf.115.1588998962772;
        Fri, 08 May 2020 21:36:02 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id fu12sm3684742pjb.20.2020.05.08.21.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:36:01 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id A9F844035F; Sat,  9 May 2020 04:36:00 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     jeyu@kernel.org
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 00/15] net: taint when the device driver firmware crashes
Date:   Sat,  9 May 2020 04:35:37 +0000
Message-Id: <20200509043552.8745-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device driver firmware can crash, and sometimes, this can leave your
system in a state which makes the device or subsystem completely
useless. Detecting this by inspecting /proc/sys/kernel/tainted instead
of scraping some magical words from the kernel log, which is driver
specific, is much easier. So instead this series provides a helper which
lets drivers annotate this and shows how to use this on networking
drivers.

My methodology for finding when firmware crashes is to git grep for
"crash" and then doing some study of the code to see if this indeed
a place where the firmware crashes. In some places this is quite
obvious.

I'm starting off with networking first, if this gets merged later on I
can focus on the other drivers, but I already have some work done on
other subsytems.

Review, flames, etc are greatly appreciated.

This work, only on networking drivers, can be found on my git tree as well:

https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20200509-taint-firmware-net

Luis Chamberlain (15):
  taint: add module firmware crash taint support
  ethernet/839: use new module_firmware_crashed()
  bnx2x: use new module_firmware_crashed()
  bnxt: use new module_firmware_crashed()
  bna: use new module_firmware_crashed()
  liquidio: use new module_firmware_crashed()
  cxgb4: use new module_firmware_crashed()
  ehea: use new module_firmware_crashed()
  qed: use new module_firmware_crashed()
  soc: qcom: ipa: use new module_firmware_crashed()
  wimax/i2400m: use new module_firmware_crashed()
  ath10k: use new module_firmware_crashed()
  ath6kl: use new module_firmware_crashed()
  brcm80211: use new module_firmware_crashed()
  mwl8k: use new module_firmware_crashed()

 drivers/net/ethernet/8390/axnet_cs.c                |  4 +++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c    |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c   |  1 +
 drivers/net/ethernet/brocade/bna/bfa_ioc.c          |  1 +
 drivers/net/ethernet/cavium/liquidio/lio_main.c     |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c     |  1 +
 drivers/net/ethernet/ibm/ehea/ehea_main.c           |  2 ++
 drivers/net/ethernet/qlogic/qed/qed_debug.c         |  3 +++
 drivers/net/ipa/ipa_modem.c                         |  1 +
 drivers/net/wimax/i2400m/rx.c                       |  1 +
 drivers/net/wireless/ath/ath10k/pci.c               |  2 ++
 drivers/net/wireless/ath/ath10k/sdio.c              |  2 ++
 drivers/net/wireless/ath/ath10k/snoc.c              |  1 +
 drivers/net/wireless/ath/ath6kl/hif.c               |  1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/core.c |  1 +
 drivers/net/wireless/marvell/mwl8k.c                |  1 +
 include/linux/kernel.h                              |  3 ++-
 include/linux/module.h                              | 13 +++++++++++++
 include/trace/events/module.h                       |  3 ++-
 kernel/module.c                                     |  5 +++--
 kernel/panic.c                                      |  1 +
 21 files changed, 44 insertions(+), 5 deletions(-)

-- 
2.25.1

