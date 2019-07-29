Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF17791E9
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387401AbfG2RTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:19:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11374 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726601AbfG2RTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:19:47 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6THIsCc017854
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 10:19:46 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2u1tf12d2f-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 10:19:46 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 29 Jul 2019 10:19:43 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 8162925693E85; Mon, 29 Jul 2019 10:19:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <willy@infraded.org>, <davem@davemloft.net>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 0/3 net-next] Finish conversion of skb_frag_t to bio_vec
Date:   Mon, 29 Jul 2019 10:19:38 -0700
Message-ID: <20190729171941.250569-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-29_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=669 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907290189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent conversion of skb_frag_t to bio_vec did not include
skb_frag's page_offset.  Add accessor functions for this field,
utilize them, and remove the union, restoring the original structure.

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
 include/linux/skbuff.h                        | 63 +++++++++++++++++--
 net/appletalk/ddp.c                           |  4 +-
 net/core/datagram.c                           |  6 +-
 net/core/dev.c                                |  2 +-
 net/core/pktgen.c                             |  2 +-
 net/core/skbuff.c                             | 54 ++++++++--------
 net/ipv4/tcp.c                                |  6 +-
 net/ipv4/tcp_output.c                         |  2 +-
 net/kcm/kcmsock.c                             |  2 +-
 net/tls/tls_device.c                          |  8 +--
 net/tls/tls_device_fallback.c                 |  2 +-
 net/xfrm/xfrm_ipcomp.c                        |  2 +-
 46 files changed, 158 insertions(+), 108 deletions(-)

-- 
2.17.1

