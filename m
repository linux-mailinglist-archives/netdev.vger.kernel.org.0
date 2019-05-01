Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D11E10473
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 06:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbfEAESE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 00:18:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37328 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfEAESD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 00:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4CtwH/3Vudsp+9VSENeCNm4OxfDR1zWjqI85mqLBp/I=; b=Y4JmOFT0UT+cEor06n4xKI5uQ
        9jzHRi7luuHV/bMUVFt8FjPMPiOJYCnERMzuI7fxUj1wR+MVyrwyvtXYtZHffLQuKyL6yibrHG1eQ
        F4z2XWP+L5qroaUo8FKBhyq0e0rz2XPOdpwPSMqJiDKbNBAs0wBki5wTWrx9AwLWj1lt0dKu5hC4/
        OUySBa2syEkdiabx9/IRmzgOL42j3eHkuw4+V4C7q/8+XjDuDbTIAUqNCHFD1UOOAv98ITG8YOqc8
        wm5+L3DD+2RLl1O/8AZiVXyw2sWIEJqndfy74JSDSs2NWu7hoO44iZMpKvz7Q6qW2VvpnOtsZt01A
        3dAmme2Dg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLggy-0002GD-Mm; Wed, 01 May 2019 04:18:00 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH 0/5] Beginnings of skb_frag -> bio_vec conversion
Date:   Tue, 30 Apr 2019 21:17:51 -0700
Message-Id: <20190501041757.8647-1-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

It turns out there's a lot of accessors for the skb_frag, which would
make this conversion really easy if some drivers didn't bypass them.
This is what I've done so far; my laptop's not really beefy enough to
cope with changing skbuff.h too often ;-)

This would be a great time to tell me I'm going about this all wrong.
I already found one problem in this patch set; some of the drivers should
have been converted to skb_frag_dma_map() instead of fixing the arguments
to dma_map_page().  But anyway, I need sleep.

Matthew Wilcox (Oracle) (5):
  net: Increase the size of skb_frag_t
  net: Reorder the contents of skb_frag_t
  net: Include bvec.h in skbuff.h
  net: Use skb accessors for skb->page
  net: Rename skb_frag page to bv_page

 drivers/hsi/clients/ssi_protocol.c            |  3 ++-
 .../net/ethernet/cavium/liquidio/lio_main.c   |  2 +-
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  2 +-
 drivers/net/ethernet/freescale/fec_main.c     |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c |  3 ++-
 drivers/net/usb/usbnet.c                      |  2 +-
 drivers/net/xen-netback/netback.c             |  4 ++--
 drivers/staging/octeon/ethernet-tx.c          |  3 +--
 drivers/target/iscsi/cxgbit/cxgbit_target.c   |  6 +++---
 include/linux/skbuff.h                        | 20 +++++++------------
 net/core/skbuff.c                             |  8 ++++----
 net/core/tso.c                                |  4 ++--
 net/kcm/kcmsock.c                             |  2 +-
 net/tls/tls_device.c                          |  4 ++--
 16 files changed, 32 insertions(+), 37 deletions(-)

-- 
2.20.1

