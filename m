Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103893402A3
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 11:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhCRKCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 06:02:43 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38348 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229834AbhCRKC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 06:02:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IA0SYf020110;
        Thu, 18 Mar 2021 03:02:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=ZHF1vXM75t50ym3MCuCaxSe5zlPNpVJ/o3hqIcs5tJY=;
 b=T3j4GVm0NyD8Y4hjCM+tsrZalp9SVsBDKHwEOQjj6FrGFSi9ll0dn1/QtN7CVtXaaW4b
 I1mlHEA2sUc0GAdPUaMQE8CzeFfasyHUkjcsK8N592J6UAqHS08EqaCebQGkdxsC3sxW
 vzdFhcvmGwtKT2CIgwJSx3aziAbXtLKUfkv3+9/dGam1vekRUKqxoAlMXiY3RNPGhI16
 bw8oG23m5VJjIZ0OIw90GVrxgYOjpLY+P6+bKXkUcmkC+HSdR4Z307rBw4IT8Anwx+pu
 hoZlYSgymEPq/8j/t73yoy6KRsdiCnaHYl5zIsFO8MdUFs8MxF3+kCJ5kf2F7/swKrMX MA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqyxw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 03:02:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 03:02:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 03:02:24 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 2D8FD3F7040;
        Thu, 18 Mar 2021 03:02:20 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, "Naveen Mamindlapalli" <naveenm@marvell.com>
Subject: [PATCH net-next 0/4] Add tc hardware offloads
Date:   Thu, 18 Mar 2021 15:32:11 +0530
Message-ID: <20210318100215.15795-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_04:2021-03-17,2021-03-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for tc hardware offloads.

Patch #1 adds support for offloading flows that matches IP tos and IP
         protocol which will be used by tc hw offload support. Also
         added ethtool n-tuple filter to code to offload the flows
         matching the above fields.
Patch #2 adds tc flower hardware offload support on ingress traffic.
Patch #3 adds TC flower offload stats.
Patch #4 adds tc TC_MATCHALL egress ratelimiting offload.

* tc flower hardware offload in PF driver

The driver parses the flow match fields and actions received from the tc
subsystem and adds/delete MCAM rules for the same. Each flow contains set
of match and action fields. If the action or fields are not supported,
the rule cannot be offloaded to hardware. The tc uses same set of MCAM
rules allocated for ethtool n-tuple filters. So, at a time only one entity
can offload the flows to hardware, they're made mutually exclusive in the
driver.

Following match and actions are supported.

Match: Eth dst_mac, EtherType, 802.1Q {vlan_id,vlan_prio}, vlan EtherType,
       IP proto {tcp,udp,sctp,icmp,icmp6}, IPv4 tos, IPv4{dst_ip,src_ip},
       L4 proto {dst_port|src_port number}.
Actions: drop, accept, vlan pop, redirect to another port on the device.

The Hardware stats are also supported. Currently only packet counter stats
are updated.

* tc egress rate limiting support
Added TC-MATCHALL classifier offload with police action applied for all
egress traffic on the specified interface.

Naveen Mamindlapalli (3):
  octeontx2-pf: Add ip tos and ip proto icmp/icmpv6 flow offload support
  octeontx2-pf: Add tc flower hardware offload on ingress traffic
  octeontx2-pf: add tc flower stats handler for hw offloads

Sunil Goutham (1):
  octeontx2-pf: TC_MATCHALL egress ratelimiting offload

 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  14 +
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   2 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  39 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  17 +-
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  20 +
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  47 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  37 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 786 +++++++++++++++++++++
 11 files changed, 961 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c

-- 
2.16.5

