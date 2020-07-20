Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC72225A94
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 10:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgGTI5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 04:57:09 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:63183 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgGTI5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 04:57:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595235428; x=1626771428;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=e8/HhYk/urxGZ+2YhG3WZsbvahVba0IK/eo3FV+lCrs=;
  b=2T/Ohm3hZrimnV9QcP6l8LP/Nv/x3v4jL8mCId1ChNdlwv6Y66KPZ22S
   vakWC+7gsk02gdVsXpbe1U4stbX6gJvko0dH+5zsdSbjBxymIEp/3jInh
   2geddI1lcFlB871jyWnM0QpmuHPqd8G3SJvkwAalUn3c/jB3xN8f2cnMz
   PibzIfX2Tjl+N8rQvcX1N2FQ1XXzU/oQhHupHcCJAtg0H8zaVFqBgCRVJ
   34/YA7FVQRq6AzyIlRyuvdX9i/mMHoOoVznDnhxA/XZaqYwYebJCR5tR4
   S/V2kOo9gAvlC5OmXSCzMVWETIvuZ792pCHORw02/QVJ+bsjJOSDCeX6f
   g==;
IronPort-SDR: HIkjrBjtDBPfTUJHMmkfw9G6lvWuXgvhdapm1isB7eSaJg0mowbzxqPhs54TAyLV/+ayGi6hQe
 KaFDUqEzzux15k6BCNpU9e0vVnuaxOLFud+m+uD79hMMHpJpFcoYGM6Oh+iCZLQlBAgQyb07t0
 mbjJ0wCppxqytbd309NtQ7yiCQ4jh5PQelA2m5aBuPwvxpg0scs7JfNdK0Msnw7xrAhrHqMoi8
 rSkQLmfMCpLVBMzZ5df2ZS98bPrZQqoXK5PVIVVZPEsny2YI6vegCSSEUowhtKZ663QivDYFpR
 C5M=
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="19791024"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2020 01:57:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Jul 2020 01:57:07 -0700
Received: from ness.mchp-main.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 20 Jul 2020 01:57:05 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux@armlinux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <netdev@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>, <f.fainelli@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v7 0/2] net: macb: Wake-on-Lan magic packet GEM and MACB handling
Date:   Mon, 20 Jul 2020 10:56:51 +0200
Message-ID: <cover.1595235208.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

Hi,

Here is the second part of support for WoL magic-packet on the current macb
driver. This one
is addressing the bulk of the feature and is based on current net-next/master.

MACB and GEM code must co-exist and as they don't share exactly the same
register layout, I had to specialize a bit the suspend/resume paths and plug a
specific IRQ handler in order to avoid overloading the "normal" IRQ hot path.

These changes were tested on both sam9x60 which embeds a MACB+FIFO controller
and sama5d2 which has a GEM+packet buffer type of controller.

Best regards,
  Nicolas

Changes in v7:
- Release the spinlock before exiting macb_suspend/resume in case of error
  changing IRQ handler

Changes in v6:
- rebase on net-next/master now that the "fixes" patches of the series are
  merged in both net and net-next.
- GEM addition and MACB update to finish the support of WoL magic-packet on the
  two revisions of the controller.

These 2 patches were last posted in v3 series.

History of previous changes already added to git commit message here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f9f41e3db40ee8d61b427d4d88c7365d968052a9


Nicolas Ferre (2):
  net: macb: WoL support for GEM type of Ethernet controller
  net: macb: Add WoL interrupt support for MACB type of Ethernet
    controller

 drivers/net/ethernet/cadence/macb.h      |   3 +
 drivers/net/ethernet/cadence/macb_main.c | 191 +++++++++++++++++++----
 2 files changed, 167 insertions(+), 27 deletions(-)

-- 
2.27.0

