Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34328FEDF
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 11:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfHPJY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 05:24:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41642 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfHPJY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 05:24:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id j16so890377wrr.8;
        Fri, 16 Aug 2019 02:24:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/VxpV6HL/eaLGj7FsELgy9XZqdi/XB/wlgbntskeVnQ=;
        b=IbAKXSF5R1mr1Ot5O0SVLwAG2d11xlP91LdIq3kT56OXCfcZQpdGKIylwQP3f1bF5V
         cj+htenCqB1qBD1rvN+lyZF9nXCUCaeeJ0rSyIw3uuCrFgH7rGaf1+QIgKbEuGRdOjzh
         criNKo5Du8irVDnbTXz7vicG14NNNWilRuwW0LUjrPCMYxazCc+DczVaDj5GXf3r3Miu
         q5Hf+xL4WVFY9W+0XERsk+zkFtddPw2URZewd5zzvDjPcOdYRCqdjVfl4K1Zw9Op4zpR
         0zwzM3zhWiRRFZ+i2PxOn4fn2725rRu/cwlHN0nttr8XcJiQT4Xn1pfhzkRJyFCVYVRK
         yhWg==
X-Gm-Message-State: APjAAAVtDI8tsSHPbZTPV4bguM28TsQVTUXOL7oqYePXixGMBsnPLfdz
        qUdpugQy7H7Kp+Jc0NjAzU0=
X-Google-Smtp-Source: APXvYqyy6pgFa+BB7KaySmOfpgsDcaufflSKyMcUlSVwwJjnZb2uc2ckVujWGkNfhMrvbZguRjo1Mw==
X-Received: by 2002:adf:eac3:: with SMTP id o3mr8886853wrn.264.1565947494195;
        Fri, 16 Aug 2019 02:24:54 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id q20sm16521138wrc.79.2019.08.16.02.24.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 02:24:53 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Denis Efremov <efremov@linux.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Sebastian Ott <sebott@linux.ibm.com>,
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
        Andrew Murray <andrew.murray@arm.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 00/10] Add definition for the number of standard PCI BARs
Date:   Fri, 16 Aug 2019 12:24:27 +0300
Message-Id: <20190816092437.31846-1-efremov@linux.com>
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

Changes in v2:
  - Reverse checks in pci_iomap_range,pci_iomap_wc_range.
  - Refactor loops in vfio_pci to keep PCI_STD_RESOURCES.
  - Add 2 new patches to replace the magic constant with new define.
  - Split net patch in v1 to separate stmmac and dwc-xlgmac patches.

Denis Efremov (10):
  PCI: Add define for the number of standard PCI BARs
  s390/pci: Loop using PCI_STD_NUM_BARS
  x86/PCI: Loop using PCI_STD_NUM_BARS
  stmmac: pci: Loop using PCI_STD_NUM_BARS
  net: dwc-xlgmac: Loop using PCI_STD_NUM_BARS
  rapidio/tsi721: Loop using PCI_STD_NUM_BARS
  efifb: Loop using PCI_STD_NUM_BARS
  vfio_pci: Loop using PCI_STD_NUM_BARS
  PCI: hv: Use PCI_STD_NUM_BARS
  PCI: Use PCI_STD_NUM_BARS

 arch/s390/include/asm/pci.h                      |  5 +----
 arch/s390/include/asm/pci_clp.h                  |  6 +++---
 arch/s390/pci/pci.c                              | 16 ++++++++--------
 arch/s390/pci/pci_clp.c                          |  6 +++---
 arch/x86/pci/common.c                            |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c |  4 ++--
 drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c   |  2 +-
 drivers/pci/controller/pci-hyperv.c              | 10 +++++-----
 drivers/pci/pci.c                                | 11 ++++++-----
 drivers/pci/quirks.c                             |  4 ++--
 drivers/rapidio/devices/tsi721.c                 |  2 +-
 drivers/vfio/pci/vfio_pci.c                      | 11 +++++++----
 drivers/vfio/pci/vfio_pci_config.c               | 10 ++++++----
 drivers/vfio/pci/vfio_pci_private.h              |  4 ++--
 drivers/video/fbdev/efifb.c                      |  2 +-
 include/linux/pci.h                              |  2 +-
 include/uapi/linux/pci_regs.h                    |  1 +
 17 files changed, 51 insertions(+), 47 deletions(-)

-- 
2.21.0

