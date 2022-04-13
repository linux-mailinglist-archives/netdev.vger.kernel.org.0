Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A844FFA2E
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbiDMPcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiDMPcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:32:54 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC94377FC;
        Wed, 13 Apr 2022 08:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863831; x=1681399831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hwRtOeN1pipEIxhLjSgAdaALV7fhjpXgexFd9B2XHYU=;
  b=cy3a0xy9zU1KQl7KpizsUio71EVI/VKXUCd9zcNytcb6i4IQkwDcw+Ji
   OKEqj/JMIxIJp80hFYAzOHIaY9GnH7AMX0pWg6m97shH97areRvPC9RTU
   BQcSXNUTkoPP3uckvFmsdyVgfarCeClZW/Q0BCgaz0qeym2vWL5ClraZU
   Gp+67rzbvM8SA6wi1xRpGVqwE5eE94XcRoI6u2iSwSZWzwIyTsqU8VL1a
   +ftCvpImQqxc9xwUgf2ks+aSHTcg5oLRj++b1S7m+hiL2PJnZOJOgLFcw
   B1A0385gmw+nbe7huTNzxWI+y0cmTTOYd9FrsA36cE3uEWqK9UyHkS5It
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544157"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544157"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:30:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318190"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:30:28 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 01/14] xsk: improve xdp_do_redirect() error codes
Date:   Wed, 13 Apr 2022 17:30:02 +0200
Message-Id: <20220413153015.453864-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
References: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
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

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
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

