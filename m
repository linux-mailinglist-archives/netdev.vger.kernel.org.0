Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B88C229BFB
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731580AbgGVPyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:54:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53252 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbgGVPyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:54:52 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MFsX1v008864;
        Wed, 22 Jul 2020 08:54:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=SijvNI5NIKaZFrGNhM0xy21xWbTHmh+au1JzoqBjn4I=;
 b=PuN63TYvvtG4lJVYarWDtOCU9Nx5LJDT3nIKTHsCBeV07PW4gxiK2Jv/pdVjVxf/KT45
 1I439JXRwLeSNJVYR9aHnfESDgUPNwqRIp0UijdqBKifq/ZslMAaBXFjBPgm39HfFXJX
 7FNlY0tlcvMO6KmHmshT7h9wAgx6MmmtSNIJfq/QoSMUfiIyh3jre8ATsHUdB/wf3Shs
 Te6VBp6eH78R27Cp2uiZFshXSQ55ntde9YVfpG+njFCPu2b8AdHmd3QRGpMz4GU3d2xV
 jRlnSjPnfSUwy5B2xmhrHDwtiXS6xsfmzsbNIZ4RW/Obe/AO1//08luedLa14RxGbqgu gQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkrkk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 08:54:33 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 08:54:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 08:54:30 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id C09873F703F;
        Wed, 22 Jul 2020 08:54:24 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Doug Ledford" <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 00/15] qed/qede: improve chain API and add XDP_REDIRECT support
Date:   Wed, 22 Jul 2020 18:53:34 +0300
Message-ID: <20200722155349.747-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_09:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds missing XDP_REDIRECT case handling in QLogic Everest
Ethernet driver with all necessary prerequisites and ops.
QEDE Tx relies heavily on chain API, so make sure it is in its best
at first.

Alexander Lobakin (15):
  qed: reformat "qed_chain.h" a bit
  qed: reformat Makefile
  qed: move chain methods to a separate file
  qed: prevent possible double-frees of the chains
  qed: sanitize PBL chains allocation
  qed: move chain initialization inlines next to allocation functions
  qed: simplify initialization of the chains with an external PBL
  qed: simplify chain allocation with init params struct
  qed: add support for different page sizes for chains
  qed: optimize common chain accessors
  qed: introduce qed_chain_get_elem_used{,u32}()
  qede: reformat several structures in "qede.h"
  qede: reformat net_device_ops declarations
  qede: refactor XDP Tx processing
  qede: add .ndo_xdp_xmit() and XDP_REDIRECT support

 drivers/infiniband/hw/qedr/main.c             |  20 +-
 drivers/infiniband/hw/qedr/verbs.c            |  97 ++---
 drivers/net/ethernet/qlogic/qed/Makefile      |  37 +-
 drivers/net/ethernet/qlogic/qed/qed_chain.c   | 367 ++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_dev.c     | 273 -------------
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h |  32 +-
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c   |  39 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c     |  44 ++-
 .../net/ethernet/qlogic/qed/qed_sp_commands.c |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_spq.c     |  90 +++--
 drivers/net/ethernet/qlogic/qede/qede.h       | 175 +++++----
 drivers/net/ethernet/qlogic/qede/qede_fp.c    | 174 ++++++---
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 185 +++++----
 include/linux/qed/qed_chain.h                 | 328 ++++++----------
 include/linux/qed/qed_if.h                    |   9 +-
 15 files changed, 1016 insertions(+), 858 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_chain.c

--

Netdev folks, could you please take the entire series through your tree
after the necessary acks and reviews? Patches 8-9 also touch qedr driver
under rdma tree, but these changes can't be separated as it would break
incremental buildability and bisecting.

-- 
2.25.1

