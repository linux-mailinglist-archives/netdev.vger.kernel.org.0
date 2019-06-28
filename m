Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CCC5A6C4
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfF1WP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:15:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726631AbfF1WP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 18:15:58 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SMDg7g017188
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:15:58 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tdu5p82j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:15:58 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Jun 2019 15:15:56 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 8439E241A371E; Fri, 28 Jun 2019 15:15:55 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <jakub.kicinski@netronome.com>,
        <jeffrey.t.kirsher@intel.com>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 0/3 bpf-next] intel: AF_XDP support for TX of RX packets
Date:   Fri, 28 Jun 2019 15:15:52 -0700
Message-ID: <20190628221555.3009654-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=732 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280254
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NOTE: This patch depends on my previous "xsk: reuse cleanup" patch,
sent to netdev earlier.

The motivation is to have packets which were received on a zero-copy
AF_XDP socket, and which returned a TX verdict from the bpf program,
queued directly on the TX ring (if they're in the same napi context).

When these TX packets are completed, they are placed back onto the
reuse queue, as there isn't really any other place to handle them.

Space in the reuse queue is preallocated at init time for both the
RX and TX rings.  Another option would have a smaller TX queue size
and count in-flight TX packets, dropping any which exceed the reuseq
size - this approach is omitted for simplicity.


Jonathan Lemon (3):
  net: add convert_to_xdp_frame_keep_zc function
  i40e: Support zero-copy XDP_TX on the RX path for AF_XDP sockets.
  ixgbe: Support zero-copy XDP_TX on the RX path for AF_XDP sockets.

 drivers/net/ethernet/intel/i40e/i40e_txrx.h  |  1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 54 ++++++++++++--
 drivers/net/ethernet/intel/ixgbe/ixgbe.h     |  1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 74 +++++++++++++++++---
 include/net/xdp.h                            | 20 ++++--
 5 files changed, 134 insertions(+), 16 deletions(-)

-- 
2.17.1

