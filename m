Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E5E5ED3AE
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiI1D6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbiI1D6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:58:40 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E33115F68
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:58:39 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28S0rFB2007838;
        Tue, 27 Sep 2022 20:58:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=he8ZRS15N+ZAaVcjS5pcpwSAioOhRGp40tUkxpVQnz8=;
 b=B9hCq2EmQdHoUmap8Lx2Cxp9WyoryJNH7OqDXwwWwHBtIAOAm65NZkG79IzwDVpGTT2n
 Ui63zv44FaF2JLL1ZkeB3juT5i2j+fxb29YfgTXgAwXurzBapjNMAsPcnBe1v0E0lUd3
 MXr8eDFCiJScBNlJgrgXO8jFj45X2AjwoYZq2PFLOe5jI0QsDJPZNqGaDU1XxFsxnHdw
 3js+XcePJtVmlMA9RVgISmO7H+ydBsDbeqpDUSFP9QRhqxlSKX6Q0sRQ6OZFnEfp1MSV
 UaqcqWr3CnUdeyRjsLqO1agfVwjEhefgStxWc6UKsHGedSUok2hDattoKJo3ByiVe57J Eg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jt1dpcy7e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 20:58:23 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 27 Sep
 2022 20:58:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 27 Sep 2022 20:58:22 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 9C2CE3F70E7;
        Tue, 27 Sep 2022 20:58:19 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <naveenm@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH v2 0/8] Introduce macsec hardware offload for cn10k platform
Date:   Wed, 28 Sep 2022 09:28:02 +0530
Message-ID: <1664337490-20231-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: vGdC_xFJ-h9dpJouRtsUjnfKtVkRme6A
X-Proofpoint-GUID: vGdC_xFJ-h9dpJouRtsUjnfKtVkRme6A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_12,2022-09-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CN10K-B and CNF10K-B variaints of CN10K silicon has macsec block(MCS)
to encrypt and decrypt packets at MAC/hardware level. This block is a
global resource with hardware resources like SecYs, SCs and SAs
and is in between NIX block and RPM LMAC. CN10K-B silicon has only
one MCS block which receives packets from all LMACS whereas
CNF10K-B has seven MCS blocks for seven LMACs. Both MCS blocks are
similar in operation except for few register offsets and some
configurations require writing to different registers. This patchset
introduces macsec hardware offloading support. AF driver manages hardware
resources and PF driver consumes them when macsec hardware offloading
is needed.

Patch 1 adds basic pci driver for both CN10K-B and CNF10K-B
silicons and initializes hardware block.
Patches 2 and 3 adds mailboxes to init, reset and manage
resources of the MCS block
Patch 4 adds a low priority rule in MCS TCAM so that the
traffic which do not need macsec processing can be sent/received
Patch 5 adds macsec stats collection support
Patch 6 adds interrupt handling support and any event in which
AF consumer is interested can be notified via mbox notification
Patch 7 adds debugfs support which helps in debugging packet
path
Patch 8 introduces macsec hardware offload feature for
PF netdev driver.

v2 changes:
 Fix build error by changing #ifdef CONFIG_MACSEC to
 #if IS_ENABLED(CONFIG_MACSEC)


Thanks,
Sundeep

Geetha sowjanya (7):
  octeontx2-af: cn10k: Introduce driver for macsec block.
  octeontx2-af: cn10k: mcs: Add mailboxes for port related operations
  octeontx2-af: cn10k: mcs: Manage the MCS block hardware resources
  octeontx2-af: cn10k: mcs: Install a default TCAM for normal traffic
  octeontx2-af: cn10k: mcs: Support for stats collection
  octeontx2-af: cn10k: mcs: Handle MCS block interrupts
  octeontx2-af: cn10k: mcs: Add debugfs support

Subbaraya Sundeep (1):
  octeontx2-pf: mcs: Introduce MACSEC hardware offloading

 drivers/net/ethernet/marvell/octeontx2/af/Makefile |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  471 +++++-
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    | 1601 +++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/mcs.h    |  246 +++
 .../ethernet/marvell/octeontx2/af/mcs_cnf10kb.c    |  214 +++
 .../net/ethernet/marvell/octeontx2/af/mcs_reg.h    | 1102 +++++++++++++
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c |  888 +++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   20 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   21 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  346 ++++
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |    1 +
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  | 1668 ++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |    1 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   90 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   16 +
 15 files changed, 6680 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c

-- 
2.7.4

