Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4F638D5FF
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 15:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhEVNV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 09:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbhEVNVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 09:21:55 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FFAC061574;
        Sat, 22 May 2021 06:20:30 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4FnPGy2yvJzQjmk;
        Sat, 22 May 2021 15:20:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id 21ryPJUcxS0H; Sat, 22 May 2021 15:20:21 +0200 (CEST)
From:   =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [RFC PATCH 0/3] mwifiex: Add quirks for MS Surface devices
Date:   Sat, 22 May 2021 15:18:24 +0200
Message-Id: <20210522131827.67551-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: ***
X-Rspamd-Score: 3.22 / 15.00 / 15.00
X-Rspamd-Queue-Id: C6B3D17FF
X-Rspamd-UID: d74d50
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This series is based on the patches from Tsuchiya Yuto which have been
submitted previously already, where it was suggested to cc linux-pci and
Bjorn to ask if there's a better way of doing those quirks.

Original series sent in by Tsuchiya: https://lore.kernel.org/linux-wireless/20201028142753.18855-1-kitakar@gmail.com/

Here's the summary written by Tsuchiya:

This series adds firmware reset quirks for Microsoft Surface devices
(PCIe-88W8897). Surface devices somehow requires quirks to reset the
firmware. Otherwise, current mwifiex driver can reset only software level.
This is not enough to recover from a bad state.

To do so, in the first patch, I added a DMI-based quirk implementation
for Surface devices that use mwifiex chip.

The required quirk is different by generation. Surface gen3 devices
(Surface 3 and Surface Pro 3) require a quirk that calls _DSM method
(the third patch).
Note that Surface Pro 3 is not yet supported because of the difference
between Surface 3. On Surface 3, the wifi card will be immediately
removed/reprobed after the _DSM call. On the other hand, Surface Pro 3
doesn't. Need to remove/reprobe wifi card ourselves. This behavior makes
the support difficult.

Surface gen4+ devices (Surface Pro 4 and later) require a quirk that
puts wifi into D3cold before FLR.

While here, created new files for quirks (mwifiex/pcie_quirks.c and
mwifiex/pcie_quirks.h) because the changes are a little bit too big to
add into pcie.c.

Jonas Dreßler (1):
  mwifiex: pcie: add DMI-based quirk implementation for Surface devices

Tsuchiya Yuto (2):
  mwifiex: pcie: add reset_d3cold quirk for Surface gen4+ devices
  mwifiex: pcie: add reset_wsid quirk for Surface 3

 drivers/net/wireless/marvell/mwifiex/Makefile |   1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c   |  21 ++
 drivers/net/wireless/marvell/mwifiex/pcie.h   |   1 +
 .../wireless/marvell/mwifiex/pcie_quirks.c    | 246 ++++++++++++++++++
 .../wireless/marvell/mwifiex/pcie_quirks.h    |  17 ++
 5 files changed, 286 insertions(+)
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.h

-- 
2.31.1

