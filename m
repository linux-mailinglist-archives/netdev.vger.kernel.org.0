Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023251B2B14
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 17:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgDUPWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 11:22:37 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36158 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgDUPWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 11:22:37 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 803D4200D12;
        Tue, 21 Apr 2020 17:22:35 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 746FE200CF3;
        Tue, 21 Apr 2020 17:22:35 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 35CC7205A2;
        Tue, 21 Apr 2020 17:22:35 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     brouer@redhat.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/4] dpaa2-eth: add support for xdp bulk enqueue
Date:   Tue, 21 Apr 2020 18:21:50 +0300
Message-Id: <20200421152154.10965-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first 3 patches are there to setup the scene for using the bulk
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

Ioana Ciornei (4):
  dpaa2-eth: return num_enqueued frames from enqueue callback
  dpaa2-eth: use the bulk ring mode enqueue interface
  dpaa2-eth: split the .ndo_xdp_xmit callback into two stages
  dpaa2-eth: use bulk enqueue in .ndo_xdp_xmit

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 141 +++++++++++-------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |   6 +-
 2 files changed, 88 insertions(+), 59 deletions(-)

-- 
2.17.1

