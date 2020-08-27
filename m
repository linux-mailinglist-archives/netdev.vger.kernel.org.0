Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0538C255172
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 01:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgH0XAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 19:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbgH0XAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 19:00:39 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275D0C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:39 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u128so4657312pfb.6
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=+cJuw0wMAcZ5pMpT3Duk4/qG8MTB5Up2A0ZV8SKGF/Y=;
        b=xwTfTEBsGUsrFz0Kpl92tic4/yIEMueh6XLJ1Hx+JuaOI+037ebzDnUrx2xMyimr95
         6ID9ihWEqZRTWuESgqChXmrRuOVBs1VM9JiMGbxZ+X0Oh6izPfl6hJK2Wu7MJ/PeQGBa
         LxiEiWF3sf674E/ijOR+gPkekFkmBbHOSpGDYkwdPgDpVPAaNVIrd5+15zxZpyYLgSjB
         B2i7TPjOD4LoYn8fYbzPj6ZYW5r0zRVHhrD3n+uc5tI3V5SoCZIXsWMjCdFqHWB4d6Ic
         fVMx9RNr4Ne5PAj5fUsAF5blo1HPgOkxicjmKwNDebPSqEKGAP+kO+OKtGgNmqy9ev/X
         P2Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+cJuw0wMAcZ5pMpT3Duk4/qG8MTB5Up2A0ZV8SKGF/Y=;
        b=XlvDZpYNbEOAzoB0NaFf+WVZzXxuxYqdmRcdDoHoLdD5LCFWeqpsxan9YK14Grn759
         fvPdWxcJckrp1YB0J53YQOrcQFZP+UE0W1mdGrOCRsqQiN3wzu7bsE5Fl2LevjIKVxKA
         B2LI2P6wqn/F1bf8TqqdrCv025kfQLcfNLyWWp2gVS351LmvvqHLtqC8P4e3jxjllwpn
         Gzd8yHDKKlJyRCbpr63ah4u4dO/oBvkMYdnIsgeR5Bhgoj2EHBx2Wf+cwtO0or/Ygu5t
         VJ9Hyk6YL6nPkD58GuQsnr4ZWtYJJ9EEE6b1XsPS2E5aSWD+IB8bL0trXFoFnGuIykqQ
         u4+A==
X-Gm-Message-State: AOAM5324z16RVC8MNCcWkgdgsis3UdOvIGlKrAkKOKoRLzXiTUa8mSza
        CNdKXXwciamRS6BHTuxZcIyGCV3jVAxq6A==
X-Google-Smtp-Source: ABdhPJyA7HFTfSRX1YCNeNvP1cXVzQG4TT5/J0Ak3E30z7FCLbhM/y5cFOxKJcF2HP2oU16byDuAnQ==
X-Received: by 2002:a63:4965:: with SMTP id y37mr16802873pgk.349.1598569237977;
        Thu, 27 Aug 2020 16:00:37 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n22sm3137534pjq.25.2020.08.27.16.00.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 16:00:37 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 00/12] ionic memory usage rework
Date:   Thu, 27 Aug 2020 16:00:18 -0700
Message-Id: <20200827230030.43343-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous review comments have suggested [1],[2] that this driver
needs to rework how queue resources are managed and reconfigured
so that we don't do a full driver reset and to better handle
potential allocation failures.  This patchset is intended to
address those comments.

The first few patches clean some general issues and
simplify some of the memory structures.  The last 4 patches
specifically address queue parameter changes without a full
ionic_stop()/ionic_open().

[1] https://lore.kernel.org/netdev/20200706103305.182bd727@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
[2] https://lore.kernel.org/netdev/20200724.194417.2151242753657227232.davem@davemloft.net/

v3: use PTR_ALIGN without typecast
    fix up Neel's attribution

v2: use PTR_ALIGN
    recovery if netif_set_real_num_tx/rx_queues fails
    less racy queue bring up after reconfig
    common-ize the reconfig queue stop and start

Shannon Nelson (12):
  ionic: set MTU floor at ETH_MIN_MTU
  ionic: fix up a couple of debug strings
  ionic: use kcalloc for new arrays
  ionic: remove lif list concept
  ionic: rework and simplify handling of the queue stats block
  ionic: clean up unnecessary non-static functions
  ionic: reduce contiguous memory allocation requirement
  ionic: use index not pointer for queue tracking
  ionic: change mtu without full queue rebuild
  ionic: change the descriptor ring length without full reset
  ionic: change queue count with no reset
  ionic: pull reset_queues into tx_timeout handler

 drivers/net/ethernet/pensando/ionic/ionic.h   |   4 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  32 +-
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  29 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  46 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  49 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |   2 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 127 ++-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 785 +++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  94 ++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |  26 +-
 .../net/ethernet/pensando/ionic/ionic_stats.c |  48 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  82 +-
 12 files changed, 790 insertions(+), 534 deletions(-)

-- 
2.17.1

