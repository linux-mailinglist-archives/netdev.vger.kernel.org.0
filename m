Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8064FFA49
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbiDMPdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236551AbiDMPd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:33:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D6F381A5;
        Wed, 13 Apr 2022 08:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863867; x=1681399867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1ZZv1T3pCpwRQJnAcBaHCxkSUHlK085zX9k9Xlvk0xE=;
  b=VCkhNqT7cxDutkkBJO3PG0p/57Q4/6R1QbhoFT2Hd3CfxKWdYWjb66Yg
   FW3X4XytTeCbK60hklYZENRzmGa0c/7kCFGuncRJO9mCSmKB1oCoBarH3
   LYv1yHh+HMC2cU4ZmpWg/KAnxqXH6PgdNRmri9NSN+ywpHTpqsg722/Jn
   oUK13GDEAGAf26xLS9yZ2AJYDCNuCxwafDj7aQ2+2YXWxquQrhzX443V/
   fA1kwMzF+fsXga9flsuudsvqbL81xlAnHwdrBDTQXh+/pIFjRhBa6QPCd
   6FiYTvNmKF657E9+w3Kf7GeP2bstxmCY47FPR3xwx7EjTZUok2FeDZYPW
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544354"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544354"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:31:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318442"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:31:05 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 14/14] xsk: drop ternary operator from xskq_cons_has_entries
Date:   Wed, 13 Apr 2022 17:30:15 +0200
Message-Id: <20220413153015.453864-15-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
References: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
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

