Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087E5560321
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiF2OfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiF2OfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:35:24 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635D331398;
        Wed, 29 Jun 2022 07:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656513324; x=1688049324;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m5k1JJAnxBdmslaFepvRT8gmxc0TYTIcMGmepHozWM8=;
  b=hSBp2Dr+vRd9nacAlCtzZN+rouIaneVjEMgIRmuk4QQtyv8T9DhHo+Ri
   QAT22qD0Djhxsx8+AVL8lWrVxCiHZXQNomDqsBBvJRxDJXika6y44P+Wa
   NgPecZymRB1+AK1u3JV08zEMBnbM2WmH/kArw8CcgdgRc3kB/XUVUur4w
   AxkJJugqoeyfMPqRn7oFy4HRRDBSnJhGSyi7KkoVe7q0y2hpWvSgDUFaK
   gN5Wrudq3vEnWABkpfLW+udvw4wXrcUqoMel0mM8usqlk89jwNaEnnBT6
   wEPwiLNbRIDvanoH4/v+xZcHimMycSj22PBvTCnJEiBzVxHIl89hqxttp
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="368357919"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="368357919"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 07:35:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="590765139"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 29 Jun 2022 07:35:22 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 1/4] selftests: xsk: avoid bpf_link probe for existing xsk
Date:   Wed, 29 Jun 2022 16:34:55 +0200
Message-Id: <20220629143458.934337-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220629143458.934337-1-maciej.fijalkowski@intel.com>
References: <20220629143458.934337-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently bpf_link probe is done for each call of xsk_socket__create().
For cases where xsk context was previously created and current socket
creation uses it, has_bpf_link will be overwritten, where it has already
been initialized.

Optimize this by moving the query to the xsk_create_ctx() so that when
xsk_get_ctx() finds a ctx then no further bpf_link probes are needed.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
index eb50c3f336f8..fa13d2c44517 100644
--- a/tools/testing/selftests/bpf/xsk.c
+++ b/tools/testing/selftests/bpf/xsk.c
@@ -958,6 +958,7 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
 	ctx->fill = fill;
 	ctx->comp = comp;
 	list_add(&ctx->list, &umem->ctx_list);
+	ctx->has_bpf_link = xsk_probe_bpf_link();
 	return ctx;
 }
 
@@ -1059,7 +1060,6 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 		}
 	}
 	xsk->ctx = ctx;
-	xsk->ctx->has_bpf_link = xsk_probe_bpf_link();
 
 	if (rx && !rx_setup_done) {
 		err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
-- 
2.27.0

