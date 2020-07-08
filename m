Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F22B218669
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgGHLyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbgGHLyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:54:21 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC05C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:54:20 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l2so2718682wmf.0
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=qnBIZbb0XeTE5BYLiH5ViM6OV5tmr4w2iqnhLrE34D0=;
        b=QR/zlQ4k6kD0MQic4uX6tBsyHY+VPO1fqVZA8YPhRcyxbeF/ljQ8FVHaK2PtMpOuYE
         XJp1uQvfoCbpfQ8mfo7GITTbo8R06halOaQJRAEcD2CgTgxpfrGKhjLjDFeoOsJ+GggO
         EUCbI3fiHKL8YEIdtWgv+QyDvKs1w/rwEEL7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qnBIZbb0XeTE5BYLiH5ViM6OV5tmr4w2iqnhLrE34D0=;
        b=lu1myHUhwOP0YkATU5oFzg7wb9oBf2q1AnCufK+iHijN/hFDPnCNDkijb36Py+38mz
         M38NOB65zd9yzhPaCRCGZGkV37jqsBCbxpq341jerl75AAhDEuhRXDk4EqwjwQ8gWmVd
         SjBOdmx2saBQHYMX/AyTw2R/SYhix6NSXgEzVXM02vEX2ltrKAhhQEocPafMcEmHUqbH
         QELTe70brPgzBAqguZOSW3jsM1L1C5hSW1U9o308LLtUcGqD23E/vMfXmVHc1vgbpC5R
         x6gtmwKR0qQorGDvi16HflHAFF7AuphANgaRQdeXf8Rc/+xvUvbLSB3bGep8ZeZwryc8
         ifMQ==
X-Gm-Message-State: AOAM530MeKe07DWbUJob6MDmVZK8jB9+BcaycGqkPJEeMhWoyxfeYo/a
        g5kGFYGaGFsjnKn4ISQ9nqf+Sg==
X-Google-Smtp-Source: ABdhPJzk3t0kKMiGZ7ZHtJB3Sneyop/MeDx5w+zCD5HuA4UTttB8YGxNTJVwNM04HmvpUpKtSHyO7Q==
X-Received: by 2002:a1c:2503:: with SMTP id l3mr8840834wml.188.1594209259411;
        Wed, 08 Jul 2020 04:54:19 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm6352888wrh.54.2020.07.08.04.54.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:54:18 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v4 0/9] bnxt_en: Driver update for net-next.
Date:   Wed,  8 Jul 2020 07:53:52 -0400
Message-Id: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements ethtool -X to setup user-defined RSS indirection
table.  The new infrastructure also allows the proper logical ring index
to be used to populate the RSS indirection when queried by ethtool -x.
Prior to these patches, we were incorrectly populating the output of
ethtool -x with internal ring IDs which would make no sense to the user.

The last 2 patches add some cleanups to the VLAN acceleration logic
and check the firmware capabilities before allowing VLAN acceleration
offloads.

v4: Move bnxt_get_rxfh_indir_size() fix to a new patch #2.
    Modify patch #7 to revert RSS map to default only when necessary.

v3: Use ALIGN() in patch 5.
    Add warning messages in patch 6.

v2: Some RSS indirection table changes requested by Jakub Kicinski.

Edwin Peer (2):
  bnxt_en: clean up VLAN feature bit handling
  bnxt_en: allow firmware to disable VLAN offloads

Michael Chan (7):
  bnxt_en: Set up the chip specific RSS table size.
  bnxt_en: Fix up bnxt_get_rxfh_indir_size().
  bnxt_en: Add logical RSS indirection table structure.
  bnxt_en: Add helper function to return the number of RSS contexts.
  bnxt_en: Fill HW RSS table from the RSS logical indirection table.
  bnxt_en: Return correct RSS indirection table entries to ethtool -x.
  bnxt_en: Implement ethtool -X to set indirection table.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 242 ++++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  20 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  52 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |   1 +
 4 files changed, 246 insertions(+), 69 deletions(-)

-- 
1.8.3.1

