Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4AA74F3C2C
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbiDEMFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380516AbiDELmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 07:42:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B162110CF05;
        Tue,  5 Apr 2022 04:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649156826; x=1680692826;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1ZZv1T3pCpwRQJnAcBaHCxkSUHlK085zX9k9Xlvk0xE=;
  b=UoORFY445vXdTcBE2JxoaR0RgnQgTrd1bsOICD1rkEA+YtyoTDOhdJwm
   m5nGs4DepYscBYW3FSGxjYuFxz2SrREu9t5xgbGrGfetY3iYCdPUjAT1T
   bb0F/lbJmPiEmbn58+xmBT493a1JuJVm5yEge/7hCxI+hbRfp9g/eib60
   NtPxK4Z5b4KW0PeA2shsCcm3j75wjyGwsBtwFwXNPfkrfA60mvulBbfZH
   6TcVIH7RHRVWU+IJ1eKN0KzSprX8gv+tUu9F5x/FQJD4WX4Y16klib+WC
   VTtKrc2onJCDKfEbPFeVqfsHbQgWuR2imgXdwfSqOjpt6KMv3w36z9nVy
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241308027"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241308027"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:07:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="641570891"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2022 04:07:04 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, maximmi@nvidia.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 10/10] xsk: drop ternary operator from xskq_cons_has_entries
Date:   Tue,  5 Apr 2022 13:06:31 +0200
Message-Id: <20220405110631.404427-11-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
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

Simplify the mentioned helper function by removing ternary operator. The
expression that is there outputs the boolean value by itself.

This helper might be used in the hot path so this simplification can
also be considered as micro optimization.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 net/xdp/xsk_queue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 644479e65578..a794410989cc 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -263,7 +263,7 @@ static inline u32 xskq_cons_nb_entries(struct xsk_queue *q, u32 max)
 
 static inline bool xskq_cons_has_entries(struct xsk_queue *q, u32 cnt)
 {
-	return xskq_cons_nb_entries(q, cnt) >= cnt ? true : false;
+	return xskq_cons_nb_entries(q, cnt) >= cnt;
 }
 
 static inline bool xskq_cons_peek_addr_unchecked(struct xsk_queue *q, u64 *addr)
-- 
2.33.1

