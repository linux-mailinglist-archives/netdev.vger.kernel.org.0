Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E6E425785
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242594AbhJGQSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:18:37 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:53954
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242220AbhJGQSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:18:36 -0400
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 552F33FFDC;
        Thu,  7 Oct 2021 16:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633623401;
        bh=0KLgW6RNFHGRR3uPAzV96CLFDLpsWVBFEtnvoPaS81A=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=lWhgTiy2lGSZx3R7dSParXUd5ML4pjvSOvIfTGs4l56VPnK90GoA/ShoBCP9H3sJ4
         19g9xh8NVOrQPyLue6ebnBk52KHhegOsc2nKS/rKAkzclXlYn+197QZsPrI41VTUOu
         RyqKNDgtgvP94luSf/Ucv8Bh08Q33u9KuQBfwLIhqXE0DWQlLyh139n/VRHgps0KRW
         gBugO2ba7rVSzk97wdUYvEiilsYLPp+c6QtKLpFSxZgFb5CBa8OLKg/n6gwSKeWCri
         vGQwbopZeRtC2yQiR5rSdcdK6Dl67RvmIDzjcwiXWOAc1hEkOl4uR2HtI6tKy36Iog
         iVeGbkACgbkPw==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [RFC] [PATCH net-next v6 0/3] r8169: Implement dynamic ASPM mechanism for recent 1.0/2.5Gbps Realtek NICs
Date:   Fri,  8 Oct 2021 00:15:49 +0800
Message-Id: <20211007161552.272771-1-kai.heng.feng@canonical.com>
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

Kai-Heng Feng (3):
  PCI/ASPM: Introduce a new helper to report ASPM capability
  r8169: Enable chip-specific ASPM regardless of PCIe ASPM status
  r8169: Implement dynamic ASPM mechanism

 drivers/net/ethernet/realtek/r8169_main.c | 69 ++++++++++++++++++++---
 drivers/pci/pcie/aspm.c                   | 11 ++++
 include/linux/pci.h                       |  2 +
 3 files changed, 73 insertions(+), 9 deletions(-)

-- 
2.32.0

