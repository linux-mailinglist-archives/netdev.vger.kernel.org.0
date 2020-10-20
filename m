Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3727C29380E
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 11:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392356AbgJTJdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 05:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391743AbgJTJdw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 05:33:52 -0400
Received: from lore-desk.redhat.com (unknown [151.66.125.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81CF4222C8;
        Tue, 20 Oct 2020 09:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603186432;
        bh=xJJ2mll+trXb9qquBSjZ4m8KzNDyoJUSqV1Laxoot+Q=;
        h=From:To:Cc:Subject:Date:From;
        b=fY1OYO0oj6Xxh8rpXCAYzE9GWGziQyhK9xHgN61Mpghbu8xMZIRbcoHWMbhQqZbw7
         0HtyyYbSyz6ar9K+xbWLrRocjwI/jOPmiQIimQlYReae7OQG4VtRs2OmRki5aVptp0
         QmMrRNOwpxDSZqsNt/XMoLsL/YFdjoHw+p3lVleE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [RFC 0/2] xdp: introduce bulking for page_pool tx return path
Date:   Tue, 20 Oct 2020 11:33:36 +0200
Message-Id: <cover.1603185591.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp_return_frame/xdp_return_frame_napi and page_pool_put_page are usually
run inside the driver NAPI tx completion loop so it is possible batch them.
Introduce bulking capability in xdp tx return path (XDP_TX and XDP_REDIRECT).
Convert mvneta driver to xdp_return_frame_bulk APIs.

mvneta upstream code:
XDP_TX:		~296Kpps
XDP_REDIRECT:	~273Kpps

mvneta + xdp_return_frame_bulk APIs:
XDP_TX:		~303Kpps
XDP_REDIRECT:	~287Kpps

Lorenzo Bianconi (2):
  net: xdp: introduce bulking for xdp tx return path
  net: page_pool: add bulk support for ptr_ring

 drivers/net/ethernet/marvell/mvneta.c |  8 ++---
 include/net/page_pool.h               | 21 ++++++++++++
 include/net/xdp.h                     | 11 ++++++
 net/core/page_pool.c                  | 37 ++++++++++++++++++++
 net/core/xdp.c                        | 49 +++++++++++++++++++++++++++
 5 files changed, 122 insertions(+), 4 deletions(-)

-- 
2.26.2

