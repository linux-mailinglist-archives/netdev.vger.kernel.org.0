Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C88221A426
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 17:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgGIP5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 11:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgGIP5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 11:57:32 -0400
Received: from localhost.localdomain.com (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 777E72077D;
        Thu,  9 Jul 2020 15:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594310252;
        bh=/hYDyIwEH9rjd957bQCbW5tu9SOD+1iN0znNbq7hnNg=;
        h=From:To:Cc:Subject:Date:From;
        b=ZTLVlDjlZ57SNcOKez7sti6h2duhaBYL8LEyV5isdqdmUbbnRJ9uJlU/iSZ3RqG4F
         jFkNFQQDeZnN9gxRWXnV10Ff7U+wj63NVqw2s8ymZIrqX1ZflNYGC+HP4eN1cBM/9h
         xd5LLUtk07rdpxzIiUsa/KOXwUQze/rPv41+0i5A=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, bpf@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, echaudro@redhat.com, sameehj@amazon.com
Subject: [PATCH 0/6] rework mvneta napi_poll loop for XDP multi-buffers
Date:   Thu,  9 Jul 2020 17:57:17 +0200
Message-Id: <cover.1594309075.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rework mvneta_rx_swbm routine in order to process all rx descriptors before
building the skb or run the xdp program attached to the interface.
Introduce xdp_get_shared_info_from_{buff,frame} utility routines to get the
skb_shared_info pointer from xdp_buff or xdp_frame.
This is a preliminary series to enable multi-buffers and jumbo frames for XDP
according to [1]

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org

Lorenzo Bianconi (6):
  xdp: introduce xdp_get_shared_info_from_{buff,frame} utility routines
  net: mvneta: move skb build after descriptors processing
  net: mvneta: move mvneta_run_xdp after descriptors processing
  net: mvneta: drop all fragments in XDP_DROP
  net: mvneta: get rid of skb in mvneta_rx_queue
  net: mvneta: move rxq->left_size on the stack

 drivers/net/ethernet/marvell/mvneta.c | 220 ++++++++++++++------------
 include/net/xdp.h                     |  15 ++
 2 files changed, 137 insertions(+), 98 deletions(-)

-- 
2.26.2

