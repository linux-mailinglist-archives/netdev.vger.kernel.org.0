Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602F24F3BA9
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbiDEMA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380412AbiDELme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 07:42:34 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3765E457B2;
        Tue,  5 Apr 2022 04:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649156807; x=1680692807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ytWUfx3/ys0CGOoMx9C2IYY7bI8XUBc9hMr4xRvcsP4=;
  b=Jwn3H0O5IhZDql5+qUrrMj5E0+rYqY37Hs2iQPXibFidoH7bRuvfvpBB
   obzye3U5wjNqgslnrPxrHvkrvgOPheheNqdzMcGLp/kp3xscf1P4tO++/
   ovIo3QHcLUvi9z7QIUk+AkXyrrYq6NHQB5cEC5RIM1QSHpJC4GOGQCyZI
   4ccz+UXHgyzfuN5H0bRp3nFOy/oV1gHxwqShfsExSf82V8qZ4Ed+0OcfT
   tP9qIMQqVCIPWnVDcsz8vB1VGZ62ycmHd35h3P/hI5LzIsjhVgnDSmpfh
   NXbkgIg2EtV/E6p15uQ6S0jz4mKUehr08/iWGpzUzbB0dYLePxnJvCKOK
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241307948"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241307948"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:06:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="641570801"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2022 04:06:43 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, maximmi@nvidia.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 01/10] xsk: improve xdp_do_redirect() error codes
Date:   Tue,  5 Apr 2022 13:06:22 +0200
Message-Id: <20220405110631.404427-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn@kernel.org>

The error codes returned by xdp_do_redirect() when redirecting a frame
to an AF_XDP socket has not been very useful. A driver could not
distinguish between different errors. Prior this change the following
codes where used:

Socket not bound or incorrect queue/netdev: EINVAL
XDP frame/AF_XDP buffer size mismatch: ENOSPC
Could not allocate buffer (copy mode): ENOSPC
AF_XDP Rx buffer full: ENOSPC

After this change:

Socket not bound or incorrect queue/netdev: EINVAL
XDP frame/AF_XDP buffer size mismatch: ENOSPC
Could not allocate buffer (copy mode): ENOMEM
AF_XDP Rx buffer full: ENOBUFS

An AF_XDP zero-copy driver can now potentially determine if the
failure was due to a full Rx buffer, and if so stop processing more
frames, yielding to the userland AF_XDP application.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 net/xdp/xsk.c       | 2 +-
 net/xdp/xsk_queue.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 2c34caee0fd1..f75e121073e7 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -184,7 +184,7 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	xsk_xdp = xsk_buff_alloc(xs->pool);
 	if (!xsk_xdp) {
 		xs->rx_dropped++;
-		return -ENOSPC;
+		return -ENOMEM;
 	}
 
 	xsk_copy_xdp(xsk_xdp, xdp, len);
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 801cda5d1938..644479e65578 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -382,7 +382,7 @@ static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 	u32 idx;
 
 	if (xskq_prod_is_full(q))
-		return -ENOSPC;
+		return -ENOBUFS;
 
 	/* A, matches D */
 	idx = q->cached_prod++ & q->ring_mask;
-- 
2.33.1

