Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3394B34F001
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhC3Rn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:43:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:32950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231951AbhC3RnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 13:43:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B02461864;
        Tue, 30 Mar 2021 17:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617126202;
        bh=uYaW/QH+iAL6DZPnWmQKFiyh6Yn3jj88Y9rk5M4PDI8=;
        h=From:To:Cc:Subject:Date:From;
        b=KY4NiuirAgvvcw9rU/I4HctuKyILN0nc84NHEluvNhqgbaJdqtC8zmqpUdBHOSEW0
         0Zvxpr5oFYZJNlqLJB9IkCEoTfRLKnd4LPFFvM1GyD3eRCMrbZunZyPkMx9xr+uG/u
         FN+it0rz/R6PKJOch/GPzIOrF322E/MjpSy9T3sd+XN6kn8i5TVSyN5MupoTnEsmos
         oGKG5TgemCns8Y0bcJAGNmt7aO/JFCJT7vPBUIkoOhRDpndlwL4N2KvzgEjrAOHBMp
         jrcCb/o/5sXqMGJ5XpB8tXWQDbE3Ioc+byun+ZzuvxRDrNEFsHVPp5EjNKEfUKjFaL
         CxuREO80YaIGw==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, nic_swsd@realtek.com,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v4 0/3] PCI: Disable parity checking
Date:   Tue, 30 Mar 2021 12:43:15 -0500
Message-Id: <20210330174318.1289680-1-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

I think this is essentially the same as Heiner's v3 posting, with these
changes:

  - Added a pci_disable_parity() interface in pci.c instead of making a
    public pci_quirk_broken_parity() because quirks.c is only compiled when
    CONFIG_PCI_QUIRKS=y.

  - Removed the setting of dev->broken_parity_status because it's really
    only used by EDAC error reporting, and if we disable parity error
    reporting, we shouldn't get there.  This change will be visible in the
    sysfs "broken_parity_status" file, but I doubt that's important.

I dropped Leon's reviewed-by because I fiddled with the code.  Similarly I
haven't added your signed-off-by, Heiner, because I don't want you blamed
for my errors.  But if this looks OK to you I'll add it.

v1: https://lore.kernel.org/r/a6f09e1b-4076-59d1-a4e3-05c5955bfff2@gmail.com
v2: https://lore.kernel.org/r/bbc33d9b-af7c-8910-cdb3-fa3e3b2e3266@gmail.com
- reduce scope of N2100 change to using the new PCI core quirk
v3: https://lore.kernel.org/r/992c800e-2e12-16b0-4845-6311b295d932@gmail.com/
- improve commit message of patch 2

v4:
- add pci_disable_parity() (not conditional on CONFIG_PCI_QUIRKS)
- remove setting of dev->broken_parity_status


Bjorn Helgaas (1):
  PCI: Add pci_disable_parity()

Heiner Kallweit (2):
  IB/mthca: Disable parity reporting
  ARM: iop32x: disable N2100 PCI parity reporting

 arch/arm/mach-iop32x/n2100.c              |  8 ++++----
 drivers/net/ethernet/realtek/r8169_main.c | 14 --------------
 drivers/pci/pci.c                         | 17 +++++++++++++++++
 drivers/pci/quirks.c                      | 13 ++++---------
 include/linux/pci.h                       |  1 +
 5 files changed, 26 insertions(+), 27 deletions(-)

-- 
2.25.1

