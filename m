Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57C522E46F
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 05:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgG0DaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 23:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgG0DaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 23:30:14 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC60C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:14 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id l2so1951972pff.0
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Sv5nMkyT4ydpuucyAgqfQgg/0dK7cQSUI31I8xscPjk=;
        b=XMRZ2sS04f1q/7albglB3SFwj9Ouxq6rrZx6b4bIAeUTNrZi4s71xLTFNwL/JnFd80
         a4cVdIU29IdkG8MhRShtyHyD0+Jy0/5aU7bwiJcvjPEzljuyq+JW6J3MEsunGRGvN+1b
         pJXLbA0XYY6NCcA0H5YtxLRFcFOiboOWjU5JY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Sv5nMkyT4ydpuucyAgqfQgg/0dK7cQSUI31I8xscPjk=;
        b=k4KCVELk82PYhikWlkMpa/qPQtQqbjeVMe5H5fTnDP14VpeDmIZn+tXpLVm2daJUlv
         XphoRsZPnc2PYG1KzS1ScIt3kebX3Z0Ai2M1w5Fk0YM2GOVA6yVDIMS6L981+PZlE/zR
         8vqzodT+g4a+StuYE+8NF/QjsnoSOBoXp24xjyeO3nhswKnivZVxHEvKJ3iWePMi/REC
         dAFffnf4+cKwUmIoZwv0y1Xo0MGAYx7NKVcIh+jzSlWHNQSI7NSOT5klfMwFAKa1reCj
         3NyxQR2e1OHgQU9/j3eTzKGxYndD/u9O/TaMxqxMm7LokLiEOtY/um2YmG6rALBfO4Tq
         bsfw==
X-Gm-Message-State: AOAM532RHBNLpK+uE9pb6WaYTzM4AWZTM9yJ4Sl8/wqeL+LDX3CTUnV1
        7hW4b5WJlLMlThD44kbBhrcJZw==
X-Google-Smtp-Source: ABdhPJwluLXey8PQi3Z08zBHCD6un6V8kATLMYerz6EB+oO6H/GjXi7vWqk6aNBPA7EMUzOmkiLSxw==
X-Received: by 2002:aa7:97a1:: with SMTP id d1mr18591756pfq.190.1595820613774;
        Sun, 26 Jul 2020 20:30:13 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n25sm13504506pff.51.2020.07.26.20.30.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2020 20:30:13 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/10] bnxt_en update.
Date:   Sun, 26 Jul 2020 23:29:36 -0400
Message-Id: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset removes the PCIe histogram and other debug register
data from ethtool -S. The removed data are not counters and they have
very large and constantly fluctuating values that are not suitable for
the ethtool -S decimal counter display.

The rest of the patches implement counter rollover for all hardware
counters that are not 64-bit counters.  Different generations of
hardware have different counter widths.  The driver will now query
the counter widths of all counters from firmware and implement
rollover support on all non-64-bit counters.

The last patch adds the PCIe histogram and other PCIe register data back
using the ethtool -d interface.

Michael Chan (8):
  bnxt_en: Update firmware interface to 1.10.1.54.
  bnxt_en: Use macros to define port statistics size and offset.
  bnxt_en: Refactor statistics code and structures.
  bnxt_en: Allocate additional memory for all statistics blocks.
  bnxt_en: Retrieve hardware counter masks from firmware if available.
  bnxt_en: Retrieve hardware masks for port counters.
  bnxt_en: Accumulate all counters.
  bnxt_en: Switch over to use the 64-bit software accumulated counters.

Vasundhara Volam (2):
  bnxt_en: Remove PCIe non-counters from ethtool statistics
  bnxt_en: Add support for 'ethtool -d'

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 494 ++++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  96 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c     |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 138 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h     | 468 ++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c   |   2 +-
 7 files changed, 860 insertions(+), 342 deletions(-)

-- 
1.8.3.1

