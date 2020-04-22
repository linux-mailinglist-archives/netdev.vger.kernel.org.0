Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF51C1B43EE
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgDVMFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:05:36 -0400
Received: from inva020.nxp.com ([92.121.34.13]:41624 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbgDVMFg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 08:05:36 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 71D691A11CB;
        Wed, 22 Apr 2020 14:05:34 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 657EF1A11C4;
        Wed, 22 Apr 2020 14:05:34 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 303332030B;
        Wed, 22 Apr 2020 14:05:34 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     brouer@redhat.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 0/5] dpaa2-eth: add support for xdp bulk enqueue
Date:   Wed, 22 Apr 2020 15:05:08 +0300
Message-Id: <20200422120513.6583-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch moves the DEV_MAP_BULK_SIZE macro into the xdp.h header
file so that drivers can take advantage of it and use it.

The following 3 patches are there to setup the scene for using the bulk
enqueue feature.  First of all, the prototype of the enqueue function is
changed so that it returns the number of enqueued frames. Second, the
bulk enqueue interface is used but without any functional changes, still
one frame at a time is enqueued.  Third, the .ndo_xdp_xmit callback is
split into two stages, create all FDs for the xdp_frames received and
then enqueue them.

The last patch of the series builds on top of the others and instead of
issuing an enqueue operation for each FD it issues a bulk enqueue call
for as many frames as possible. This is repeated until all frames are
enqueued or the maximum number of retries is hit. We do not use the
XDP_XMIT_FLUSH flag since the architecture is not capable to store all
frames dequeued in a NAPI cycle, instead we send out right away all
frames received in a .ndo_xdp_xmit call.


Changes in v2:
 - statically allocate an array of dpaa2_fd by frame queue
 - use the DEV_MAP_BULK_SIZE as the maximum number of xdp_frames
   received in .ndo_xdp_xmit()

Ioana Ciornei (5):
  xdp: export the DEV_MAP_BULK_SIZE macro
  dpaa2-eth: return num_enqueued frames from enqueue callback
  dpaa2-eth: use the bulk ring mode enqueue interface
  dpaa2-eth: split the .ndo_xdp_xmit callback into two stages
  dpaa2-eth: use bulk enqueue in .ndo_xdp_xmit

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 136 ++++++++++--------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |   8 +-
 include/net/xdp.h                             |   2 +
 kernel/bpf/devmap.c                           |   1 -
 4 files changed, 87 insertions(+), 60 deletions(-)

-- 
2.17.1

