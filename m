Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6997D1E24B3
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgEZO6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:58:22 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35141 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729300AbgEZO6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:58:21 -0400
Received: by mail-pl1-f194.google.com with SMTP id q16so8786249plr.2;
        Tue, 26 May 2020 07:58:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+44buva8vuZuGNV129HqBHwOpK3H/7jOMxiBF8Hwg4A=;
        b=J4Ce9IOkd12quegBH+T+vSf4hI6m0MuSFSAjMnefmOe9Q2EJC7QwttwNo0RHZCvawK
         U1108lskmv2eo2UmRUd5rviYuMnqma5J5eFm4cyPildnaHibRCXd8lcoK/z2oR4grghf
         3cZeShgvaKCa29yOuQh8/XuuFzMVonssHnVDmfvJcs7JMZpdLqtOdRBsMJssYUsUc+YM
         rPRGGuGHetaCANQ3+PTWE5xC+4w32dQxVuBqVJjX9/M052kLD6xw/epKEudZPVD2fxJV
         7iDzrnpE9s3sb63XOazBQWYtGxi+ZpgLpO28hSOLBkSy1iaDxXtQBoBQEJ5o+06tKEyK
         F9pQ==
X-Gm-Message-State: AOAM531GXXL9IoZqxSLOX4sG+zXOmiGkO+B2W3/NyLR2kdwLzLHFbDBs
        ldfn16ZkBbZQAHokFh6PByhTd5yQ8jWoHw==
X-Google-Smtp-Source: ABdhPJxIqLa35HGQlmlp2ZMuQep5DTzZgAdztLc44Wf5z8Y9Y7fScbXtJNI1kTkLPcn4MC8FPRGJNA==
X-Received: by 2002:a17:90a:74c8:: with SMTP id p8mr25723366pjl.95.1590505099649;
        Tue, 26 May 2020 07:58:19 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id e13sm14153199pfh.19.2020.05.26.07.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 07:58:18 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 70A69404EF; Tue, 26 May 2020 14:58:17 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     jeyu@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     michael.chan@broadcom.com, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, akpm@linux-foundation.org,
        arnd@arndb.de, rostedt@goodmis.org, mingo@redhat.com,
        aquini@redhat.com, cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, tiwai@suse.de, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, derosier@gmail.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, vkoul@kernel.org,
        mchehab+huawei@kernel.org, robh@kernel.org, mhiramat@kernel.org,
        sfr@canb.auug.org.au, linux@dominikbrodowski.net,
        glider@google.com, paulmck@kernel.org, elver@google.com,
        bauerman@linux.ibm.com, yamada.masahiro@socionext.com,
        samitolvanen@google.com, yzaikin@google.com, dvyukov@google.com,
        rdunlap@infradead.org, corbet@lwn.net, dianders@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v3 0/8] kernel: taint when the driver firmware crashes
Date:   Tue, 26 May 2020 14:58:07 +0000
Message-Id: <20200526145815.6415-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To those new on CC -- this is intended to be a simple generic interface
to the kernel to annotate when the firwmare has crashed leaving the
driver or system in a questionable state, in the worst case requiring
full system reboot. This series is first addressing only a few
networking patches, however, I already have an idea of where such
firmware crashes happen across the tree. The goal with this series then
is to first introduce the simple framework, and only if that moves
forward will I continue to chug on with the rest of the drivers /
subsystems.

This is *not* a networking specific problem only.

This v3 augments the last series by introducing the uevent for panic
events, one of them is during tainting. The uvent mechanism is
independent from any of this firmware taint mechanism. I've also
addressed Jessica Yu's feedback. Given I've extended the patches a bit
with other minor cleanup which checkpatch.pl complains over, and since
this infrastructure is still being discussed, I've trimmed the patch
series size to only cover drivers for which I've received an Acked-by
from the respective driver maintainer, or where we have bug reports to
support such dire situations on the driver such as ath10k.

During the last v2 it was discussed that we should instead use devlink
for this work, however the initial RFC patches produced by Jakub
Kicinski [0] shows how devlink is networking specific, and the intent
behind this series is to produce simple helpers which can be used by *any*
device driver, for any subsystem, not just networking. Subsystem
specific infrastructure to help address firwmare crashes may still make
sense, however that does not mean we *don't* need something even more
generic regardless of the subsystem the issue happens on. Since uevents
for taints are exposed, we now expose these through uapi as well, and
that was something which eventually had to happen given that the current
scheme of relying on sensible character representations for each taint
will not scale beyond the alphabet.

This series is avaialble my 20200526-taint-firmware-net-intro branch, based on
linux-next tag next-20200526 [1].

[0] https://lkml.kernel.org/r/20200519211531.3702593-1-kuba@kernel.org
[1] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20200526-taint-firmware-net-intro

Luis Chamberlain (7):
  kernel.h: move taint and system state flags to uapi
  panic: add uevent support
  taint: add firmware crash taint support
  panic: make taint data type clearer
  ath10k: use new taint_firmware_crashed()
  liquidio: use new taint_firmware_crashed()
  qed: use new taint_firmware_crashed()

Vasundhara Volam (1):
  bnxt_en: use new taint_firmware_crashed()

 Documentation/admin-guide/tainted-kernels.rst |   6 +
 MAINTAINERS                                   |   8 +
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   1 +
 .../net/ethernet/cavium/liquidio/lio_main.c   |   1 +
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     |   1 +
 drivers/net/wireless/ath/ath10k/pci.c         |   2 +
 drivers/net/wireless/ath/ath10k/sdio.c        |   2 +
 drivers/net/wireless/ath/ath10k/snoc.c        |   1 +
 include/asm-generic/bug.h                     |   4 +-
 include/linux/kernel.h                        |  40 +--
 include/linux/module.h                        |  13 +
 include/linux/panic_events.h                  |  26 ++
 include/trace/events/module.h                 |   3 +-
 include/uapi/linux/kernel.h                   |  36 +++
 include/uapi/linux/panic_events.h             |  17 ++
 init/main.c                                   |   1 +
 kernel/Makefile                               |   1 +
 kernel/module.c                               |  13 +-
 kernel/panic.c                                |  16 +-
 kernel/panic_events.c                         | 289 ++++++++++++++++++
 lib/Kconfig.debug                             |  13 +
 tools/debugging/kernel-chktaint               |   7 +
 22 files changed, 454 insertions(+), 47 deletions(-)
 create mode 100644 include/linux/panic_events.h
 create mode 100644 include/uapi/linux/panic_events.h
 create mode 100644 kernel/panic_events.c

-- 
2.26.2

