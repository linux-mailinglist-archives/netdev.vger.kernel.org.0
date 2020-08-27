Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6E1254C8F
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 20:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgH0SHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 14:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgH0SHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 14:07:46 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B76C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:07:46 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o13so3933636pgf.0
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=UQthjuzTB/9KGHud5/I4cENfUGre42NNkNm7OtwDPXI=;
        b=B026/uVXozUm70AfvUGwlzYnB5jlQowQ/pBASYk2jnK12MMR7MXYffR/bp3gFSJNK6
         WbP2DpfjT2C5SqZVCGod+SK3D6nklQYQW0EWHfkVzAxNzo0VSKfiTrYcf0odHm561cbP
         MJVmd9rMeqZSoF+i5Y/YdmjLk3hbXqTGAEoNcnXDeupKONV15y/2IwipvjZkHqVZYS4G
         0pHoLZpeL99HYdIGt6J362yvwr85O713aUTMsBH7GLKBk5oryv3ignC9UjcAkRuxbg6W
         EXb6CN4lZMHcv5ykj1PRjis0CIKHnH/rDJXB25n2TKw+zAKzS+F2VwjSylguNB7uLHg1
         zkSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UQthjuzTB/9KGHud5/I4cENfUGre42NNkNm7OtwDPXI=;
        b=bXVOErbXacOCECMyJeIIkkFMvLqJIuGYsIwDmW9uyh8pptZ41dJJmVy62saGaGldEC
         ltM/OL8SlPJM1s/e5M70FEhNQjbO4nGfgSfv8u9lwH+lb9flm9ZG6HOBN4fI/EtCTTx3
         wQ2qfXmvY5LVDXsh8+OrQ9QrgTfohAq9XxbeH/2+js/40uTteNA1i/AFCJPgohI2JOx2
         XgBSMfLsJbWzykiUGyAAXoVMetDLVYXEj1I13dDQA7SebLQgCBs5ejbIZRcMUI/D0CEi
         VR38God78weIBZh8IeL8T4KTsMniPgRtZIgUoLKJEpDKbcaVWPEaOyS3o5HCrFPhlMYe
         45Kg==
X-Gm-Message-State: AOAM531QckYf7VVTJ9eBXB722ygF4Fq0yy9XA3M7U9U8xFv6YQus8sq3
        uxpwVqTgmRatLWFA/Ts03g2i9SQ7RibZ5Q==
X-Google-Smtp-Source: ABdhPJxiYnA/1D45ZH2fxR5/YECJoNGfwIrHpvReylwE8N3K0dPkb0tyDgrJpDX6LIg/T2WfqPi3jA==
X-Received: by 2002:a17:902:748c:: with SMTP id h12mr17214201pll.316.1598551665436;
        Thu, 27 Aug 2020 11:07:45 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n1sm3480249pfu.2.2020.08.27.11.07.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 11:07:44 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 00/12] ionic memory usage rework
Date:   Thu, 27 Aug 2020 11:07:23 -0700
Message-Id: <20200827180735.38166-1-snelson@pensando.io>
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

