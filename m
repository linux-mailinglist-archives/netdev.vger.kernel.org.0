Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C871C40DE54
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 17:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239304AbhIPPpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 11:45:49 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:33024
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231702AbhIPPps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 11:45:48 -0400
Received: from HP-EliteBook-840-G7.. (1-171-209-135.dynamic-ip.hinet.net [1.171.209.135])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 9328D40185;
        Thu, 16 Sep 2021 15:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631807066;
        bh=D+6x42mV/eNHaJg6o/8m7nqSFdYIv9hJf3BQ21j7zcs=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=ri00jAUy9r6dPkWBuJUEzoYqptyPdG5gebAiAm55R/PCkcxPFYfLdc/J4za/sMNNs
         +ANu94vpDQVCEIlLV4zZlOO0biSP1ZkCDUqh9FPWj5J4DLJMwhn2Hj+NKyYtubsZeq
         mK+kyS/LaV8VnK6+64gLvr4SnEHNAKrmnBNIYGoVSOFUvLB/APWBc+5tISpi8XKUCm
         NYcvJd2ggrjlsY6C8vhrU1/RG1ask+YObpDH96NHXTddhstAcAjHsCnx4b+z0Tfver
         RAaadjezettzJT33lf31KRZqtVnB4rIC3SbzmjHgfNGfSBzLjshqYOTnXtlMk0t6hl
         d4VbZGfoUjPSQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [RFC] [PATCH net-next v5 0/3] r8169: Implement dynamic ASPM mechanism for recent 1.0/2.5Gbps Realtek NICs
Date:   Thu, 16 Sep 2021 23:44:14 +0800
Message-Id: <20210916154417.664323-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of the series is to get comments and reviews so we can merge
and test the series in downstream kernel.

The latest Realtek vendor driver and its Windows driver implements a
feature called "dynamic ASPM" which can improve performance on it's
ethernet NICs.

Heiner Kallweit pointed out the potential root cause can be that the
buffer is to small for its ASPM exit latency.

So bring the dynamic ASPM to r8169 so we can have both nice performance
and powersaving at the same time.

For the slow/fast alternating traffic pattern, we'll need some real
world test to know if we need to lower the dynamic ASPM interval.

v4:
https://lore.kernel.org/netdev/20210827171452.217123-1-kai.heng.feng@canonical.com/

v3:
https://lore.kernel.org/netdev/20210819054542.608745-1-kai.heng.feng@canonical.com/

v2:
https://lore.kernel.org/netdev/20210812155341.817031-1-kai.heng.feng@canonical.com/

v1:
https://lore.kernel.org/netdev/20210803152823.515849-1-kai.heng.feng@canonical.com/

Kai-Heng Feng (3):
  PCI/ASPM: Introduce a new helper to report ASPM capability
  r8169: Use PCIe ASPM status for NIC ASPM enablement
  r8169: Implement dynamic ASPM mechanism

 drivers/net/ethernet/realtek/r8169_main.c | 69 ++++++++++++++++++++---
 drivers/pci/pcie/aspm.c                   | 11 ++++
 include/linux/pci.h                       |  2 +
 3 files changed, 73 insertions(+), 9 deletions(-)

-- 
2.32.0

