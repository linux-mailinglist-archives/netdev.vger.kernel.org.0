Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5357D39469F
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 19:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhE1Rph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 13:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229450AbhE1Rpg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 13:45:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7976261108;
        Fri, 28 May 2021 17:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622223841;
        bh=R4vuRh4BgZLgLKb0e1A4TwbWzcCWyQLMAjOMCEtRseU=;
        h=From:To:Cc:Subject:Date:From;
        b=JWPEDFOh0lZfB2Dlo2p2Vdr8aSyUmVrZKnqQWyt32g1vsNCPOSLO17a2MshocJ9ax
         dKRPrVHt8TUGFY218ipz+CP8rXxfHdOAChPSAKvnb/hCPOaoP6lgEt4TcEvAuxKbj8
         6DX8uZV9LgEJPag/RIKqNW7K2MBSHOEKQEApsy1TD9Eusbr6tzcsYuoVmE6D0p4aJ8
         2bPB96mxDSpgFWt9hOu6RyhlagAAh9r4G0OB85zyrbwxKslikpaTNRiNxucqMNyVXf
         bRKbCh690lxO+xelMatnBTg4fv9MzDrFETxU89t76K41CVvtLhQ1Ug/xhGoCuYCbow
         uOm3niIFSpvUQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, echaudro@redhat.com,
        dsahern@gmail.com, magnus.karlsson@intel.com, toke@redhat.com,
        brouer@redhat.com, bjorn@kernel.org, maciej.fijalkowski@intel.com,
        john.fastabend@gmail.com
Subject: [RFC bpf-next 0/4] add partial rx hw csum offload support for XDP
Date:   Fri, 28 May 2021 19:43:40 +0200
Message-Id: <cover.1622222367.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable xdp rx checksum offload support for CHECKSUM_UNNECESSARY use-case.
Introduce flag field in xdp_buff/xdp_frame in order to save the checksum
result from the NIC and have a fast access to it performing XDP_REDIRECT.
CHECKSUM_COMPLETE is not supported yet since it will require adding the
csum result to the xdp_metadata area.
Moreover flag field will be reused for xdp multi-buff support.
This series has been tested generating UDP traffic with pktgen and performing
a xdp_redirect from an ixgbe device to a remote CPUMAP entry. PPS results show
a negligible penalty respect to the baseline where the UDP checksum has been
disabled. More info about the test can be found here [0].

[0] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp_frame01_checksum.org

Lorenzo Bianconi (4):
  net: xdp: introduce flags field in xdp_buff and xdp_frame
  mvneta: return csum computation result from mvneta_rx_csum
  net: mvneta: report csum result in xdp_buff
  net: xdp: update csum building the skb

 drivers/net/ethernet/marvell/mvneta.c | 27 ++++++++------------
 include/net/xdp.h                     | 36 +++++++++++++++++++++++++++
 net/core/xdp.c                        |  2 +-
 3 files changed, 48 insertions(+), 17 deletions(-)

-- 
2.31.1

