Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D94427CBB
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhJISra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhJISr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:47:29 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04D1C061570
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 11:45:31 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id v11so6583544pgb.8
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 11:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=tEWWuT+bjtcqCDslFgPzNPcrb3eD/epofFYyIRQlACw=;
        b=anIjjx0q3ROHOS8VhCMpY6oOFY+nNDenJ5/0SxhF2TIjV5lZr/owMv5IPjMh/5Qpmv
         aRrpR7E9E/p+iz1uU42pcQE6GqdWOgJ8QA9G90DabyIeOrERM+TG8vz7209h6qas48ye
         h8VJm71iGhb6WCe0nuzCZgenqsLWMY/qHKymSiliEsPGoRwy9D9KGBA36YgFejdTE3hi
         df1d7vDY3ZirUyyrJNFvJ5iqgylLvKlWYeAx5bB2SxExjeM1iNT3H0OOL8fGssQnVRMS
         kBD+2+kO8itMbb136yda4Cq9UGe5JAaUjAa/K/FyQdtLtw89qdHEzjIIMq0BAJ6XEm+G
         F0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tEWWuT+bjtcqCDslFgPzNPcrb3eD/epofFYyIRQlACw=;
        b=w4vI54hnhiszlyON4nU2np2Bcm4x1f/gDWi5D1tylptiEKhOhF/zgqFj6+sg3VtE9M
         VQcff2WhOwmriW2ex92HAdVp4ukMchDpIY5dJaV8zEhaOOIXdwiGQfRmGyWAieVQWTmH
         Nvwz1vDmNA+b+X0dCh5K4TL56QKXUsGpc99LqN26fz2txBpDKrIZQ5eXWaNQ+ySjN7lH
         zczejeOgwVWd+O+q0dpEMZn+9ewtLtzUu1u114JUu+zJdcsWjvHfoygYnFV+vYbj9UOl
         uyIvMZIQNJ4eigmi33iNeeHJRYRhIlCaSSB2I3GbYhp1REQWgxzZ7y2cdFGhCcT5ndcU
         QDlA==
X-Gm-Message-State: AOAM530O0XW8+MWn1L0B0uMKcL4tJS2kUyGRgzZiPkp5f3GZcEwaQMb0
        JC2b8/fMXba0utKsAhFPduRfjD15oTwpyA==
X-Google-Smtp-Source: ABdhPJziDU8+tkfLo0s/Qc8CP2zZesY48huOQFUN3l/IIIIKCP5z2g/XNlaS0DARUm4FC8+DRtlMJw==
X-Received: by 2002:a05:6a00:887:b0:44b:dee9:b7b1 with SMTP id q7-20020a056a00088700b0044bdee9b7b1mr17031777pfj.84.1633805131227;
        Sat, 09 Oct 2021 11:45:31 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s30sm3368433pgo.39.2021.10.09.11.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:45:30 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/9] ionic: add vlanid overflow management
Date:   Sat,  9 Oct 2021 11:45:14 -0700
Message-Id: <20211009184523.73154-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add vlans to the existing rx_filter_sync mechanics currently
used for managing mac filters.

Older versions of our firmware had no enforced limits on the
number of vlans that the driver could request, but requesting
large numbers of vlans caused issues in FW memory management,
so an arbitrary limit was added in the FW.  The FW now
returns -ENOSPC when it hits that limit, which the driver
needs to handle.

Unfortunately, the FW doesn't advertise the vlan id limit,
as it does with mac filters, so the driver won't know the
limit until it bumps into it.  We'll grab the current vlan id
count and use that as the limit from there on and thus prevent
getting any more -ENOSPC errors.

Just as is done for the mac filters, the device puts the device
into promiscuous mode when -ENOSPC is seen for vlan ids, and
the driver will track the vlans that aren't synced to the FW.
When vlans are removed, the driver will retry the un-synced
vlans.  If all outstanding vlans are synced, the promiscuous
mode will be disabled.

The first 6 patches rework the existing filter management to
make it flexible enough for additional filter types.  Next
we add the vlan ids into the management.  The last 2 patches
allow us to catch the max vlan -ENOSPC error without adding
an unnecessary error message to the kernel log.

Shannon Nelson (9):
  ionic: add filterlist to debugfs
  ionic: move lif mac address functions
  ionic: remove mac overflow flags
  ionic: add generic filter search
  ionic: generic filter add
  ionic: generic filter delete
  ionic: handle vlan id overflow
  ionic: allow adminq requests to override default error message
  ionic: tame the filter no space message

 drivers/net/ethernet/pensando/ionic/ionic.h   |   7 +-
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  46 ++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 190 +-------------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   4 +-
 .../net/ethernet/pensando/ionic/ionic_main.c  |  47 ++--
 .../net/ethernet/pensando/ionic/ionic_phc.c   |   8 +-
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 241 +++++++++++++++++-
 .../ethernet/pensando/ionic/ionic_rx_filter.h |   2 +
 8 files changed, 345 insertions(+), 200 deletions(-)

-- 
2.17.1

