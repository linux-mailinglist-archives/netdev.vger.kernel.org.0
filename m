Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D852710973
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfEAOpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:45:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49344 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfEAOpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MEUvNyNWKXsgGczVIfpVFIFdGkZS3PB9dMs3+AgvGwo=; b=qwjJ7oSWJoQq5zluFR0qIh1hG
        O1Z+1AhE1EhkvlpG/hTdT8B9mVIPl911Eh5M4dQTyoOTap+BCmn70BW3OnvRD+QYLrEcvQdYGv1U9
        C7GE4Xsb+5S/7SpvayWHn+Vy6eGHhIVuitYcRUmuOt+zZ4h1vOXmfD2laPdB8J3cPMudgTZX+kpU3
        A+ssTntr4H9jVeoWeHqLjgioqewjeKfG5NynQKEal0soQwKfbJaDd//VPmHYyUDSwOhyW+skw4oU1
        VepQWsh2xN2x5siP3eurT2FIFWJO4plxmCedK7sttsuddE20/Sk9RFLBZ939DhcNiWr6w6B5Rth+S
        /cpJm+y6Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLqTj-00025L-Cl; Wed, 01 May 2019 14:44:59 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v2 0/7] Convert skb_frag_t to bio_vec
Date:   Wed,  1 May 2019 07:44:50 -0700
Message-Id: <20190501144457.7942-1-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

The skb_frag_t and bio_vec are fundamentally the same (page, offset,
length) tuple.  This patch series unifies the two, leaving the
skb_frag_t typedef in place.  This has the immediate advantage that
we already have iov_iter support for bvecs and don't need to add
support for iterating skbuffs.  It enables a long-term plan to use
bvecs more broadly within the kernel and should make network-storage
drivers able to do less work converting between skbuffs and biovecs.

It will consume more memory on 32-bit kernels.  If that proves
problematic, we can look at ways of addressing it.

Matthew Wilcox (Oracle) (7):
  net: Increase the size of skb_frag_t
  net: Reorder the contents of skb_frag_t
  net: Use skb accessors in network drivers
  net: Use skb accessors in network core
  net: Rename skb_frag page to bv_page
  net: Rename skb_frag_t size to bv_len
  net: Convert skb_frag_t to bio_vec

 drivers/hsi/clients/ssi_protocol.c            |  3 +-
 drivers/net/ethernet/3com/3c59x.c             |  2 +-
 drivers/net/ethernet/agere/et131x.c           |  4 +--
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  3 +-
 drivers/net/ethernet/calxeda/xgmac.c          |  2 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   | 17 +++++-----
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 15 ++++-----
 drivers/net/ethernet/cortina/gemini.c         |  5 ++-
 drivers/net/ethernet/freescale/fec_main.c     |  4 +--
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  3 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  3 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  3 +-
 drivers/net/ethernet/marvell/mvneta.c         |  4 +--
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  7 ++--
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c |  5 +--
 drivers/net/usb/usbnet.c                      |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c       |  6 ++--
 drivers/net/wireless/ath/wil6210/txrx_edma.c  |  2 +-
 drivers/net/xen-netback/netback.c             |  4 +--
 drivers/staging/octeon/ethernet-tx.c          |  3 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c   |  6 ++--
 include/linux/bvec.h                          |  5 ++-
 include/linux/skbuff.h                        | 32 +++++++------------
 net/core/skbuff.c                             | 24 ++++++++------
 net/core/tso.c                                |  8 ++---
 net/ipv4/tcp.c                                | 12 ++++---
 net/kcm/kcmsock.c                             |  8 ++---
 net/tls/tls_device.c                          | 14 ++++----
 31 files changed, 108 insertions(+), 105 deletions(-)

-- 
2.20.1

