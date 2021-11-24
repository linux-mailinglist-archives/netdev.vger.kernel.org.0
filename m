Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2D445B74D
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 10:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhKXJYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:24:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:40557 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhKXJYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 04:24:47 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="259126386"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="259126386"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 01:20:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="674799081"
Received: from sashimi-thinkstation-p920.png.intel.com ([10.158.65.178])
  by orsmga005.jf.intel.com with ESMTP; 24 Nov 2021 01:20:40 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     bjorn@kernel.org, Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH bpf-next 0/4] samples/bpf: xdpsock app enhancements
Date:   Wed, 24 Nov 2021 17:18:17 +0800
Message-Id: <20211124091821.3916046-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds below capabilities to xdpsock app:-

1/4: Add VLAN tag (ID & Priority) to the generated Tx-Only frames.
2/4: Add DMAC and SMAC setting to the generated Tx-Only frames.
     If parameters are not set, the previous DMAC and SMAC are used.
3/4: Add cyclic transmission (cycle-time) setting for Tx-only operation.
     This option can be used together with batch size and packet count.
4/4: Add time-out with retries to Tx complete cleaning process to prevent
     unsuccessful XDP Transmission from causing the Tx cleaning process
     from polling indefinitely.

With above enhancements to xdpsock, we can know run concurrent VLAN-tagged
XDP TX streams in periodic Tx with batch size fashion.

For examples:
 DMAC (-G)             = fa:8d:f1:e2:0b:e8
 SMAC (-H)             = ce:17:07:17:3e:3a
 VLAN ID (-J)          = 1
 VLAN Pri (-K)         = 1-3
 Tx Queue (-q)         = 1-3
 Cycle Time in us (-T) = 1000
 Batch (-b)            = 16
 Packet Count          = 1000000

Sending Board
=============
Terminal-1:
 $ xdpsock -i enp0s29f1 -t -N -z -H ce:17:07:17:3e:3a -G fa:8d:f1:e2:0b:e8 -V -J 1 -K 1 -q 1 -T 1000 -b 16 -C 1000000 -x

Terminal-2:
 $ xdpsock -i enp0s29f1 -t -N -z -H ce:17:07:17:3e:3a -G fa:8d:f1:e2:0b:e8 -V -J 1 -K 2 -q 2 -T 1000 -b 16 -C 1000000 -x

Terminal-3:
 $ xdpsock -i enp0s29f1 -t -N -z -H ce:17:07:17:3e:3a -G fa:8d:f1:e2:0b:e8 -V -J 1 -K 3 -q 3 -T 1000 -b 16 -C 1000000 -x

Receiving Board
===============
Terminal-1:
 $ xdpsock -i enp0s29f1 -r -N -z -q 1

Terminal-2:
 $ xdpsock -i enp0s29f1 -r -N -z -q 2

Terminal-3:
 $ xdpsock -i enp0s29f1 -r -N -z -q 3

Thanks

Ong Boon Leong (4):
  samples/bpf: xdpsock: add VLAN support for Tx-only operation
  samples/bpf: xdpsock: add Dest and Src MAC setting for Tx-only
    operation
  samples/bpf: xdpsock: add period cycle time to Tx operation
  samples/bpf: xdpsock: add time-out for cleaning Tx

 samples/bpf/xdpsock_user.c | 154 ++++++++++++++++++++++++++++++++-----
 1 file changed, 134 insertions(+), 20 deletions(-)

-- 
2.25.1

