Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDA24300F6
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 09:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243829AbhJPH5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 03:57:02 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:59570
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239780AbhJPH5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 03:57:02 -0400
Received: from HP-EliteBook-840-G7.. (36-229-230-94.dynamic-ip.hinet.net [36.229.230.94])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 4245440006;
        Sat, 16 Oct 2021 07:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634370893;
        bh=dmMqH189MgMERJiF32ZGqhoe38YQLnpFNd8vh1JzIdw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=lBFyLyAYgyhpAC51eRIk+yhL5Y1H1nZ1L5j7lphkKn9NfVsMg4fOk0TJbn+OIEqdC
         Kg4c69Nzy+q8RyTMjE0BFLZfwpskU1RGiSFibVLW9O3FB/08GiorEf2UlbOOh97ARF
         lgNgHovsVyOcDYWjZG/qLn00Tzm8Ct/5FOluOU2Cjiqms9GxUANKt7aAhURfl9iHmI
         qPzHdEBnRG4o4NrtlAkUrNu8FmUCiZDgJh0wgFbBd+3HbxFC00kKyQP2GJg5gGQNJS
         Einw4X8uqoMm3wBbKKR5UOey3OKOlqi240ee5Ntp72We+N+MwEDmcQaCV6VxNZVQBU
         o5LVCSJub0ScQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [RFC] [PATCH net-next v7 0/4] r8169: Implement dynamic ASPM mechanism for recent 1.0/2.5Gbps Realtek NICs
Date:   Sat, 16 Oct 2021 15:54:38 +0800
Message-Id: <20211016075442.650311-1-kai.heng.feng@canonical.com>
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

v6:
https://lore.kernel.org/netdev/20211007161552.272771-1-kai.heng.feng@canonical.com/

v5:
https://lore.kernel.org/netdev/20210916154417.664323-1-kai.heng.feng@canonical.com/

v4:
https://lore.kernel.org/netdev/20210827171452.217123-1-kai.heng.feng@canonical.com/

v3:
https://lore.kernel.org/netdev/20210819054542.608745-1-kai.heng.feng@canonical.com/

v2:
https://lore.kernel.org/netdev/20210812155341.817031-1-kai.heng.feng@canonical.com/

v1:
https://lore.kernel.org/netdev/20210803152823.515849-1-kai.heng.feng@canonical.com/

Kai-Heng Feng (4):
  PCI/ASPM: Add pcie_aspm_capable()
  r8169: Enable chip-specific ASPM regardless of PCIe ASPM status
  r8169: Use mutex to guard config register locking
  r8169: Implement dynamic ASPM mechanism

 drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++---
 drivers/pci/pcie/aspm.c                   | 11 ++++
 include/linux/pci.h                       |  2 +
 3 files changed, 74 insertions(+), 9 deletions(-)

-- 
2.32.0

