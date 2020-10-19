Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9C1292685
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgJSLmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:42:14 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53098 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726087AbgJSLmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 07:42:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09JBc1sr012606;
        Mon, 19 Oct 2020 04:42:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=3O6vNabCjApdh2Y3hsDoLTo2dXmwuuma5bKrIDfO1gQ=;
 b=h55nWiCy0eS7mEpUfQ7ZN+2GqUNpuKVDFAPCp1OIH/PdtOpEwSkqr49WCc54RJy+fjJZ
 ZAqyzoOTlGCWn8i1hR20zZuI4u4xOyMus7QYOOEdiW3JxrI4scGAAPhrO7UpzOQhvMrD
 8w4K0Q7Qj587S5mpPxkNr1ML3kqC8sq2vSBBWwozYsV8uhhRyWdWY7TCvYHWnW5kBtpN
 7Jg+DgJwx6Co9/uuFgVmbLZTlyzTI558sJzD8iofuxdaozhBLMEkHPTAhDjA+EuuSDP7
 XQ00nON7G588Q4TUFv1ajS0ElZ7Sou+2tRdV3pzCWp4jXhP9ob5RHELUISqL6Li8u+0Z jg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 347wyq52e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 19 Oct 2020 04:42:08 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Oct
 2020 04:42:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 19 Oct 2020 04:42:07 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id A0C1E3F703F;
        Mon, 19 Oct 2020 04:42:03 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v8,net-next,00/12] Add Support for Marvell OcteonTX2
Date:   Mon, 19 Oct 2020 17:11:45 +0530
Message-ID: <20201019114157.4347-1-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-19_05:2020-10-16,2020-10-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces crypto(CPT) drivers(PF & VF) for Marvell OcteonTX2
CN96XX Soc.

OcteonTX2 SOC's resource virtualization unit (RVU) supports multiple
physical and virtual functions. Each of the PF/VF's functionality is
determined by what kind of resources are attached to it. When the CPT
block is attached to a VF, it can function as a security device.
The following document provides an overview of the hardware and
different drivers for the OcteonTX2 SOC: 
https://www.kernel.org/doc/Documentation/networking/device_drivers/marvell/octeontx2.rst

The CPT PF driver is responsible for:
- Forwarding messages to/from VFs from/to admin function(AF),
- Enabling/disabling VFs,
- Loading/unloading microcode (creation/deletion of engine groups).

The CPT VF driver works as a crypto offload device.

This patch series includes:
- Patch to update existing Marvell sources to support the CPT driver.
- Patch that adds mailbox messages to the admin function (AF) driver,
to configure CPT HW registers.
- CPT PF driver patches that include AF<=>PF<=>VF mailbox communication,
sriov_configure, and firmware load to the acceleration engines.
- CPT VF driver patches that include VF<=>PF mailbox communication and
crypto offload support through the kernel cryptographic API.

This series is tested with CRYPTO_EXTRA_TESTS enabled and
CRYPTO_DISABLE_TESTS disabled.

Changes since v7:
 * Removed writable entries in debugfs.
 * Dropped IPsec support.
Changes since v6:
 * Removed driver version.
Changes since v4:
 * Rebased the patches onto net-next tree with base
   'commit bc081a693a56 ("Merge branch 'Offload-tc-vlan-mangle-to-mscc_ocelot-switch'")' 
Changes since v3:
 * Splitup the patches into smaller patches with more informartion.
Changes since v2:
 * Fixed C=1 warnings.
 * Added code to exit CPT VF driver gracefully.
 * Moved OcteonTx2 asm code to a header file under include/linux/soc/
Changes since v1:
 * Moved Makefile changes from patch4 to patch2 and patch3.

Srujana Challa (12):
  octeontx2-pf: move lmt flush to include/linux/soc
  octeontx2-af: add mailbox interface for CPT
  octeontx2-af: add debugfs entries for CPT block
  drivers: crypto: add Marvell OcteonTX2 CPT PF driver
  crypto: octeontx2: add mailbox communication with AF
  crypto: octeontx2: enable SR-IOV and mailbox communication with VF
  crypto: octeontx2: load microcode and create engine groups
  crypto: octeontx2: add LF framework
  crypto: octeontx2: add support to get engine capabilities
  crypto: octeontx2: add virtual function driver support
  crypto: octeontx2: add support to process the crypto request
  crypto: octeontx2: register with linux crypto framework

 MAINTAINERS                                   |    2 +
 drivers/crypto/marvell/Kconfig                |   14 +
 drivers/crypto/marvell/Makefile               |    1 +
 drivers/crypto/marvell/octeontx2/Makefile     |   10 +
 .../marvell/octeontx2/otx2_cpt_common.h       |  123 ++
 .../marvell/octeontx2/otx2_cpt_hw_types.h     |  464 +++++
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  202 ++
 .../marvell/octeontx2/otx2_cpt_reqmgr.h       |  197 ++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c |  426 +++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  351 ++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   52 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |  480 +++++
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  331 ++++
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 1533 +++++++++++++++
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |  162 ++
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   28 +
 .../marvell/octeontx2/otx2_cptvf_algs.c       | 1665 +++++++++++++++++
 .../marvell/octeontx2/otx2_cptvf_algs.h       |  170 ++
 .../marvell/octeontx2/otx2_cptvf_main.c       |  401 ++++
 .../marvell/octeontx2/otx2_cptvf_mbox.c       |  139 ++
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     |  539 ++++++
 .../ethernet/marvell/octeontx2/af/Makefile    |    3 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |   33 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |    2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |    2 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  229 +++
 .../marvell/octeontx2/af/rvu_debugfs.c        |  304 +++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   63 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   13 +-
 include/linux/soc/marvell/octeontx2/asm.h     |   29 +
 30 files changed, 7948 insertions(+), 20 deletions(-)
 create mode 100644 drivers/crypto/marvell/octeontx2/Makefile
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
 create mode 100644 include/linux/soc/marvell/octeontx2/asm.h

-- 
2.28.0

