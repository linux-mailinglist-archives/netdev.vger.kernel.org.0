Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C051989222
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 17:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfHKPIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 11:08:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40989 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbfHKPIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 11:08:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id j16so228138wrr.8;
        Sun, 11 Aug 2019 08:08:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eztnnIti2zE7e0S0pjOphceDUSBj3rZYDgwaHLj9EiY=;
        b=V/20Cr/g1JzzFMSiYPMIXDrE7vJuebZ6OIFlW1U11OtVN3DT5FToE5wVKS1ws8iKOH
         WcIgrjZU4zTU5oz1AnTVOdulUBt9dIN8Cj5+TBOMeCIrj929yKajdN0N+4MYPa5AfbFm
         levHVHwFJRgjK5IabrVzUk5XxYIsDgRPeSln8lZB/Ks2TvUuCS9TTBLYWmhQHknPn8wH
         T5iZ64b7oO6QigHUpZX0HQBdUEBk/Ocg76JNMlIodm2leBrchKTNQC5hDPESYL2ie7OL
         3p0P4y+a5Bjy4esl/NoBx+AfU4N21bpPiR1sdy/EozhnSxv29/jGHmVk7U8nJFIV05LB
         UY7Q==
X-Gm-Message-State: APjAAAXM1nfD4XVH6N/OuyCUTkE4hJ9TEKdbHqMa+GzD4dqoc1rWQE1+
        RGGLqrpNCbEQGMeSHDKKiK0=
X-Google-Smtp-Source: APXvYqxCb++Qr8Ws4Ku93thYOXelVjwJo4E5ulzYs/K33i2U8jE7T9tJe4MIE3h+YcInT3hZfS6yPA==
X-Received: by 2002:a05:6000:10c9:: with SMTP id b9mr22781411wrx.11.1565536101466;
        Sun, 11 Aug 2019 08:08:21 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id y16sm227049408wrg.85.2019.08.11.08.08.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 08:08:20 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Peter Jones <pjones@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, linux-s390@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Add definition for the number of standard PCI BARs
Date:   Sun, 11 Aug 2019 18:07:55 +0300
Message-Id: <20190811150802.2418-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Code that iterates over all standard PCI BARs typically uses
PCI_STD_RESOURCE_END, but this is error-prone because it requires
"i <= PCI_STD_RESOURCE_END" rather than something like
"i < PCI_STD_NUM_BARS". We could add such a definition and use it the same
way PCI_SRIOV_NUM_BARS is used. There is already the definition
PCI_BAR_COUNT for s390 only. Thus, this patchset introduces it globally.

The patch is splitted into 7 parts for different drivers/subsystems for
easy readability.

Denis Efremov (7):
  PCI: Add define for the number of standard PCI BARs
  s390/pci: Replace PCI_BAR_COUNT with PCI_STD_NUM_BARS
  x86/PCI: Use PCI_STD_NUM_BARS in loops instead of PCI_STD_RESOURCE_END
  PCI/net: Use PCI_STD_NUM_BARS in loops instead of PCI_STD_RESOURCE_END
  rapidio/tsi721: use PCI_STD_NUM_BARS in loops instead of
    PCI_STD_RESOURCE_END
  efifb: Use PCI_STD_NUM_BARS in loops instead of PCI_STD_RESOURCE_END
  vfio_pci: Use PCI_STD_NUM_BARS in loops instead of
    PCI_STD_RESOURCE_END

 arch/s390/include/asm/pci.h                      |  5 +----
 arch/s390/include/asm/pci_clp.h                  |  6 +++---
 arch/s390/pci/pci.c                              | 16 ++++++++--------
 arch/s390/pci/pci_clp.c                          |  6 +++---
 arch/x86/pci/common.c                            |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c |  4 ++--
 drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c   |  2 +-
 drivers/pci/quirks.c                             |  2 +-
 drivers/rapidio/devices/tsi721.c                 |  2 +-
 drivers/vfio/pci/vfio_pci.c                      |  4 ++--
 drivers/vfio/pci/vfio_pci_config.c               |  2 +-
 drivers/vfio/pci/vfio_pci_private.h              |  4 ++--
 drivers/video/fbdev/efifb.c                      |  2 +-
 include/linux/pci.h                              |  2 +-
 include/uapi/linux/pci_regs.h                    |  1 +
 15 files changed, 29 insertions(+), 31 deletions(-)

-- 
2.21.0

