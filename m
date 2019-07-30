Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97EAE7AB34
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731454AbfG3Okj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:40:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38954 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731474AbfG3Oki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:40:38 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6UEcPhv003519
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:40:37 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2q1xr6bc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:40:36 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 07:40:35 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 8BB5C2576FD0D; Tue, 30 Jul 2019 07:40:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <willy@infradead.org>, <davem@davemloft.net>,
        <jakub.kicinski@netronome.com>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH v2 0/3 net-next] Finish conversion of skb_frag_t to bio_vec
Date:   Tue, 30 Jul 2019 07:40:31 -0700
Message-ID: <20190730144034.444022-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=699 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent conversion of skb_frag_t to bio_vec did not include
skb_frag's page_offset.  Add accessor functions for this field,
utilize them, and remove the union, restoring the original structure.

v2:
  - rename accessors
  - follow kdoc conventions

Jonathan Lemon (3):
  linux: Add page_offset accessors
  net: Use skb_frag_off accessors
  linux: Remove bvec page_offset, use bv_offset

 drivers/atm/eni.c                             |  2 +-
 drivers/hsi/clients/ssi_protocol.c            |  2 +-
 drivers/infiniband/hw/hfi1/vnic_sdma.c        |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |  3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 .../ethernet/cavium/thunder/nicvf_queues.c    |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   | 12 ++--
 .../ethernet/freescale/fs_enet/fs_enet-main.c |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 +-
 drivers/net/ethernet/jme.c                    |  4 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  2 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  6 +-
 drivers/net/ethernet/sfc/tx.c                 |  2 +-
 drivers/net/ethernet/sun/cassini.c            |  8 +--
 drivers/net/ethernet/sun/niu.c                |  2 +-
 drivers/net/ethernet/sun/sunvnet_common.c     |  4 +-
 drivers/net/ethernet/ti/netcp_core.c          |  2 +-
 drivers/net/hyperv/netvsc_drv.c               |  4 +-
 drivers/net/thunderbolt.c                     |  2 +-
 drivers/net/usb/usbnet.c                      |  2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c             |  2 +-
 drivers/net/xen-netback/netback.c             |  6 +-
 drivers/net/xen-netfront.c                    |  8 +--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c             |  2 +-
 drivers/scsi/fcoe/fcoe.c                      |  3 +-
 drivers/scsi/fcoe/fcoe_transport.c            |  2 +-
 drivers/scsi/qedf/qedf_main.c                 |  2 +-
 .../staging/unisys/visornic/visornic_main.c   |  2 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c   |  4 +-
 include/linux/bvec.h                          |  5 +-
 include/linux/skbuff.h                        | 69 ++++++++++++++++---
 net/appletalk/ddp.c                           |  4 +-
 net/core/datagram.c                           |  6 +-
 net/core/dev.c                                |  2 +-
 net/core/pktgen.c                             |  2 +-
 net/core/skbuff.c                             | 54 ++++++++-------
 net/ipv4/tcp.c                                |  6 +-
 net/ipv4/tcp_output.c                         |  2 +-
 net/kcm/kcmsock.c                             |  2 +-
 net/tls/tls_device.c                          |  8 +--
 net/tls/tls_device_fallback.c                 |  2 +-
 net/xfrm/xfrm_ipcomp.c                        |  2 +-
 46 files changed, 161 insertions(+), 111 deletions(-)

-- 
2.17.1

