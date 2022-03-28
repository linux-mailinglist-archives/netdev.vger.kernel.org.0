Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5114E9947
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 16:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243766AbiC1OX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 10:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiC1OXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 10:23:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4A75DA69;
        Mon, 28 Mar 2022 07:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648477303; x=1680013303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZCFU/iO/6IJwEcmS057U/YdEqbEp8/R4vhB5XlrJkWY=;
  b=I3c8zvF8L6BXo5XP3daEWDb9rxNorHUFu5cdp7iSq7jtGdb9gVXgJu3D
   Tm7rqHJr1tfrUFTo9GZFpmJbG21tUP3hJMbdiDbEpYNmW7mwfgtBwwFG4
   ASXnqySbm4cS4MgXTc3JApPaiPLfI3pmf7bODrIGhiRAYFaPBb/XqUtad
   /WsbcMpgrBR9qqDRaUAaUn4YkXBc0UpEIUtXjPBH3IIDIIjLcd17ezsA+
   4voPIdpP9dDlxe2MIbymi5aPKJss7Y83xyILwie6e1JS6pEZ9hMRQuprR
   2o1j/IiLbh9YTHDTaveUzBtm7XJ0ybwTZ6zFYTe4LecEnrOuPJ58bIYQy
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="259196079"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="259196079"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 07:21:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="649076516"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga002.fm.intel.com with ESMTP; 28 Mar 2022 07:21:41 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, bjorn@kernel.org
Subject: [PATCH bpf 1/4] xsk: do not write NULL in SW ring at allocation failure
Date:   Mon, 28 Mar 2022 16:21:20 +0200
Message-Id: <20220328142123.170157-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220328142123.170157-1-maciej.fijalkowski@intel.com>
References: <20220328142123.170157-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

For the case when xp_alloc_batch() is used but the batched allocation
cannot be used, there is a slow path that uses the non-batched
xp_alloc(). When it fails to allocate an entry, it returns NULL. The
current code wrote this NULL into the entry of the provided results
array (pointer to the driver SW ring usually) and returned. This might
not be what the driver expects and to make things simpler, just write
successfully allocated xdp_buffs into the SW ring,. The driver might
have information in there that is still important after an allocation
failure.

Note that at this point in time, there are no drivers using
xp_alloc_batch() that could trigger this slow path. But one might get
added.

Fixes: 47e4075df300 ("xsk: Batched buffer allocation for the pool")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_buff_pool.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index b34fca6ada86..af040ffa14ff 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -591,9 +591,13 @@ u32 xp_alloc_batch(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u32 max)
 	u32 nb_entries1 = 0, nb_entries2;
 
 	if (unlikely(pool->dma_need_sync)) {
+		struct xdp_buff *buff;
+
 		/* Slow path */
-		*xdp = xp_alloc(pool);
-		return !!*xdp;
+		buff = xp_alloc(pool);
+		if (buff)
+			*xdp = buff;
+		return !!buff;
 	}
 
 	if (unlikely(pool->free_list_cnt)) {
-- 
2.27.0

