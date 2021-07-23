Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1474B3D3925
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhGWK2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:28:00 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:12243 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbhGWK1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 06:27:53 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GWRHH003fz1CMcG;
        Fri, 23 Jul 2021 19:02:34 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 23 Jul 2021 19:08:24 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <logang@deltatee.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V6 0/8] PCI: Enable 10-Bit tag support for PCIe devices
Date:   Fri, 23 Jul 2021 19:06:34 +0800
Message-ID: <1627038402-114183-1-git-send-email-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.21.59.169]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
field size from 8 bits to 10 bits.

This patchset is to enable 10-Bit tag for PCIe EP devices (include VF) and
RP device.

V5->V6:
- Rebased on v5.14-rc2.
- Add Reviewed-by: Christoph Hellwig <hch@lst.de> in [PATCH V6 2/8].
- PCI: Add "pci=disable_10bit_tag=" parameter for peer-to-peer support.
- Add a 10-bit tag check in P2PDMA.
- Simplified implementation in [PATCH V6 6/8].
- Fix some comments in [PATCH V6 4/8].

V4->V5:
- Fix warning variable 'capa' is uninitialized.
- Fix warning unused variable 'pchild'.

V3->V4:
- Get the value of pcie_devcap2 in set_pcie_port_type().
- Add Reviewed-by: Christoph Hellwig <hch@lst.de> in [PATCH V4 1/6],
  [PATCH V4 3/6], [PATCH V4 4/6], [PATCH V4 5/6].
- Fix some code style.
- Rebased on v5.13-rc6.

V2->V3:
- Use cached Device Capabilities Register suggested by Christoph.
- Fix code style to avoid > 80 char lines.
- Renamve devcap2 to pcie_devcap2.

V1->V2: Fix some comments by Christoph.
- Store the devcap2 value in the pci_dev instead of reading it multiple
      times.
- Change pci_info to pci_dbg to avoid the noisy log.
- Rename ext_10bit_tag_comp_path to ext_10bit_tag.
- Fix the compile error.
- Rebased on v5.13-rc1.

Dongdong Liu (8):
  PCI: Use cached Device Capabilities Register
  PCI: Use cached Device Capabilities 2 Register
  PCI: Add 10-Bit Tag register definitions
  PCI: Enable 10-Bit tag support for PCIe Endpoint devices
  PCI/IOV: Enable 10-Bit tag support for PCIe VF devices
  PCI: Enable 10-Bit tag support for PCIe RP devices
  PCI: Add "pci=disable_10bit_tag=" parameter for peer-to-peer support
  PCI/P2PDMA: Add a 10-bit tag check in P2PDMA

 Documentation/admin-guide/kernel-parameters.txt |  7 +++
 drivers/media/pci/cobalt/cobalt-driver.c        |  5 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  4 +-
 drivers/pci/iov.c                               |  8 +++
 drivers/pci/p2pdma.c                            | 38 +++++++++++++
 drivers/pci/pci.c                               | 70 ++++++++++++++++++++----
 drivers/pci/pci.h                               |  1 +
 drivers/pci/pcie/aspm.c                         | 11 ++--
 drivers/pci/pcie/portdrv_pci.c                  | 72 +++++++++++++++++++++++++
 drivers/pci/probe.c                             | 69 +++++++++++++++++++-----
 drivers/pci/quirks.c                            |  3 +-
 include/linux/pci.h                             |  5 ++
 include/uapi/linux/pci_regs.h                   |  5 ++
 13 files changed, 261 insertions(+), 37 deletions(-)

--
2.7.4

