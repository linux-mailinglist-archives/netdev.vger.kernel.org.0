Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE543F7FCC
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbhHZBZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhHZBZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 21:25:52 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E193C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:25:06 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s11so1534992pgr.11
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Jpr642UFVmNeqHX0tbumohhWhFAxPk++0mL6b/ZoUyY=;
        b=kIHlhLNFAE/EMOmBApzhhTYhG+6rSWjC2dtI9TGbvDia//1fAFuvWJecyI60rBDBcU
         rDafR7MvNn+2GduOdZblk5pdEOoOnWKfNCJjy1KAc5+5Gs1RLrIcZGfjeKtp0vQ4YI/d
         L3GBxZLLcbiyc+aOE4+5U+4oxd5hqg2GLET8pVhm9q+9TYOFZClQ4UIr808plH5FXA+p
         7bhkls7IOkqV441PX+b69cISWoxvG3SpUZdFNyGrny6uS8WSw31pQgk46KJHSfILYoDz
         xe91vVSIkdklgNNJYiR1flDu5EFt7xh1xffO/lOMaQEjl+Y/xWDeZinmNzrL3BnzOzsY
         hDtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Jpr642UFVmNeqHX0tbumohhWhFAxPk++0mL6b/ZoUyY=;
        b=DX/0sdDRJ2/LNnqKN2oSTP//uVZU5wXlHPE5KJcDfzYnmnyBBP8EOKGdSoa43Nu95c
         +CKb3ECTSCi7yyaZyiSlxgTldosK5YgonHROMrz9rMJiAH3i8LHX2vmb4CfO/CLzacGB
         PRCBlciPIollhJsfnWjWOu/4l6gLJ04TO9TGFB48Kc1qKcBepTdyqggE/cTIDb31FCW7
         2Ii/FPkwAI7tjIHJP+GO+e20U5u1q6xrq691mPB4R+5T3S17e+Xhi54NEKPfjYFgGniH
         EuNDGty6Ypo7puqfZhDdQNQB/6PAVyyPqccVE65mNPSTse58/t5nuXFsIgqETCy9ghyl
         KE9A==
X-Gm-Message-State: AOAM533FDR+FSxEl7x7vX/eBk31kgf18G8k2k/VbClW6X8+mI6are0mh
        n71Lm06UBgYbPJMzjWkOezvwFzlKlOcTPQ==
X-Google-Smtp-Source: ABdhPJyG8DjqMmO8+HryRedfItqJyuo4QDajHFSDczwhzx9PBfxoXVeMjtf4k1ciqb4t+yz89wVLGA==
X-Received: by 2002:a63:1056:: with SMTP id 22mr1020037pgq.178.1629941105697;
        Wed, 25 Aug 2021 18:25:05 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h13sm1113458pgh.93.2021.08.25.18.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 18:25:05 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/5] ionic: queue and filter mgmt updates
Date:   Wed, 25 Aug 2021 18:24:45 -0700
Message-Id: <20210826012451.54456-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After a pair of simple code cleanups, we change the mac filter
management to split the updates between the driver's filter
list and the device's filter list so that we can keep the calls
to dev_uc_sync() and dev_mc_sync() under the netif_addr_lock
in ndo_set_rx_mode, and then sync the driver's list to the
device later in the rx_mode work task.

Shannon Nelson (5):
  ionic: remove old work task types
  ionic: flatten calls to set-rx-mode
  ionic: sync the filters in the work task
  ionic: refactor ionic_lif_addr to remove a layer
  ionic: handle mac filter overflow

 .../net/ethernet/pensando/ionic/ionic_dev.c   |  13 ++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 218 ++++++++++--------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   8 +-
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 143 +++++++++++-
 .../ethernet/pensando/ionic/ionic_rx_filter.h |  14 +-
 5 files changed, 285 insertions(+), 111 deletions(-)

-- 
2.17.1

