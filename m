Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561BD2AB7CB
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgKIMJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 07:09:53 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10976 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbgKIMJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 07:09:53 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A9C9iFM011312;
        Mon, 9 Nov 2020 04:09:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=G/xzgY4R63QcXVPiHC+0z3pg4LL4rHMCp+akPCgiwiw=;
 b=CVzyxbKnlVKohq6ITOFsZ8eczV8qjNWLSqr+PtqyvuTiil2Juxm16t7yCq8K2goSYGgJ
 DhZ9HN7lyO2yOWGXFyYUuiwB7fSrKQYSJEgV3rc/SVS49M3gNvkDmTI50zc50lw5qur7
 K9S6cN6gQB9oZlKBHAk64CZKMvzwQiR2Yjbz80gYLIqCRShgNw67/CSgB8yT3zJeTBUW
 ojuWvPGh8SCVUs/040OihQAxdWGw7NK3tHaQHR4ca5z0IwuRWWdO0bzsfqo4J9uhnYMa
 cTjormbmi3/7b3gcDFk2pZavqYpshdlQ4++Y675kV1ufVW0refYX+0oEWIHNlXIVIcrV Bg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34nuysad8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 04:09:44 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 9 Nov
 2020 04:09:42 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 9 Nov
 2020 04:09:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 9 Nov 2020 04:09:41 -0800
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 1BB263F7041;
        Mon,  9 Nov 2020 04:09:37 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v9,net-next,00/12] Add Support for Marvell OcteonTX2 Cryptographic Acceleration Unit
Date:   Mon, 9 Nov 2020 17:39:12 +0530
Message-ID: <20201109120924.358-1-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_02:2020-11-05,2020-11-09 signatures=0
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

Changes since v8:
 * Load firmware files individually instead of tar.
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
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c |  429 +++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  352 ++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   52 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |  574 ++++++
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  331 ++++
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 1415 ++++++++++++++
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |  162 ++
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   28 +
 .../marvell/octeontx2/otx2_cptvf_algs.c       | 1664 +++++++++++++++++
 .../marvell/octeontx2/otx2_cptvf_algs.h       |  170 ++
 .../marvell/octeontx2/otx2_cptvf_main.c       |  405 ++++
 .../marvell/octeontx2/otx2_cptvf_mbox.c       |  139 ++
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     |  541 ++++++
 .../ethernet/marvell/octeontx2/af/Makefile    |    3 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |   33 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |    1 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  233 +++
 .../marvell/octeontx2/af/rvu_debugfs.c        |  272 +++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   63 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   13 +-
 include/linux/soc/marvell/octeontx2/asm.h     |   29 +
 29 files changed, 7903 insertions(+), 19 deletions(-)
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

