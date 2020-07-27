Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0960122E943
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgG0JlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0JlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:41:05 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA564C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:05 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id il6so3257154pjb.0
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=CtPRMcL8QponGXzr0Agd3jyRJRpx8MUE31fQ1G5YVWA=;
        b=DERhPzR/5VAKDre+JKOITF00VeIPbKwO518cYcdv6AJCcpf4tZJCTwXqZE91Ve1Tfz
         QvZ8/d2XA2aFPSLDOC3oOSUzE5a7Zag/bRm5Jtt+RP0/NVFa3EIA/b+Nw9iPwlyCfZGr
         Yj8IDXe3jm/qo3UqCTgSom9dvi3bmbOCGNlX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CtPRMcL8QponGXzr0Agd3jyRJRpx8MUE31fQ1G5YVWA=;
        b=l0hAsS/Q/W1Qkxkb9Rg1AmJR1gf2rmgUtH3FrEpjSXnsmoJeqxjZmLFvpSzv7alMrB
         /cGYnQ/ACXoTQvYiq0r35n4eFGEIeav3KEyLJeAP8+B1UXKNC/oMMIfU+UDBpPXPGedN
         CYFuMI+OJuT7xxOe/807kZDLBoVdj4yMa5CjEN3CzaVUZz5oLv5XoOboAcrL+o0teabI
         qSai07oRhB7HmVJrvmNG6XfR5rIGdzWeXF8dNbMKO+/4OYAPFkmh/XJ2Xzp+EzTttKGK
         Z27SyjRT7NKEZAHeyMRCA5JZFurBz+6mOxFz99oTyIqGSF5pQXDfMLQMLXxgsHF86Grf
         auZw==
X-Gm-Message-State: AOAM531VB8pNhp51+//4oxBnKn86WUuR1tKDHIuaMg+kt5BUtGI/Rbub
        /SNPHnlLh8XVHqVfUnhi8jCGtg==
X-Google-Smtp-Source: ABdhPJxQA3wjJRqEe2Vy5JLc3XhWGWZQuxwOhDJNhwe/+TXGXThjFpG7XjMJJKYlf2EJdyQOJnN8eA==
X-Received: by 2002:a17:90a:204:: with SMTP id c4mr17193277pjc.165.1595842865317;
        Mon, 27 Jul 2020 02:41:05 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f131sm14560945pgc.14.2020.07.27.02.41.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2020 02:41:04 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 00/10] bnxt_en update.
Date:   Mon, 27 Jul 2020 05:40:35 -0400
Message-Id: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
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

v2: Fix bnxt_re RDMA driver compile issue.

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

 drivers/infiniband/hw/bnxt_re/hw_counters.c       |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 494 ++++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  96 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c     |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 138 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h     | 468 ++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c   |   2 +-
 8 files changed, 861 insertions(+), 343 deletions(-)

-- 
1.8.3.1

