Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EA8560329
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiF2Ofd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbiF2Ofb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:35:31 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD90733EB9;
        Wed, 29 Jun 2022 07:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656513329; x=1688049329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cEqvGYYPld/OsvdtFaKN8twS+H01mWDIAjjLlNCYGoc=;
  b=c9JYhTYO9zcaAeM97L/qUNImTq8UozRGRxQPfLcCR2KfAml28YGCX/jK
   cVq/y1bFbPoiuD7EmwSFPiCVGBLtPY2O6nwTyK8Bu7DkmDVFcNOGBEjFF
   sGp5+YkTJt/JOgSU2FKM9Y3EItEygdm/zjW3b6xWCk2R3wsXtdVVD9Mhb
   3QeKyZG/8NBQGdHUIbyvLNaH8to4b0pU/9xygBPa5SQU/ZtXclPN7sExv
   9YlzXERVNPQ9c6t9tTbNKH6vSuc7zADRQF2iit47a+VFcx/TDE4AKpWzH
   4V9cjY8+yTQCZsRb/0ND6FMl56a2gMGWyusEf+Wk1M9m3IekHfC0zP46e
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="368357952"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="368357952"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 07:35:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="590765185"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 29 Jun 2022 07:35:27 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 4/4] selftests: xsk: destroy BPF resources only when ctx refcount drops to 0
Date:   Wed, 29 Jun 2022 16:34:58 +0200
Message-Id: <20220629143458.934337-5-maciej.fijalkowski@intel.com>
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

Currently, xsk_socket__delete frees BPF resources regardless of ctx
refcount. Xdpxceiver has a test to verify whether underlying BPF
resources would not be wiped out after closing XSK socket that was bound
to interface with other active sockets. From library's xsk part
perspective it also means that the internal xsk context is shared and
its refcount is bumped accordingly.

After a switch to loading XDP prog based on previously opened XSK
socket, mentioned xdpxceiver test fails with:
not ok 16 [xdpxceiver.c:swap_xsk_resources:1334]: ERROR: 9/"Bad file descriptor

which means that in swap_xsk_resources(), xsk_socket__delete() released
xskmap which in turn caused a failure of xsk_socket__update_xskmap().

To fix this, when deleting socket, decrement ctx refcount before
releasing BPF resources and do so only when refcount dropped to 0 which
means there are no more active sockets for this ctx so BPF resources can
be freed safely.

Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xsk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
index db911127720e..95ce5cd572bb 100644
--- a/tools/testing/selftests/bpf/xsk.c
+++ b/tools/testing/selftests/bpf/xsk.c
@@ -1156,8 +1156,6 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 		goto out_mmap_tx;
 	}
 
-	ctx->prog_fd = -1;
-
 	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
 		err = __xsk_setup_xdp_prog(xsk, NULL);
 		if (err)
@@ -1238,7 +1236,10 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 
 	ctx = xsk->ctx;
 	umem = ctx->umem;
-	if (ctx->prog_fd != -1) {
+
+	xsk_put_ctx(ctx, true);
+
+	if (!ctx->refcount) {
 		xsk_delete_bpf_maps(xsk);
 		close(ctx->prog_fd);
 		if (ctx->has_bpf_link)
@@ -1257,7 +1258,6 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 		}
 	}
 
-	xsk_put_ctx(ctx, true);
 
 	umem->refcount--;
 	/* Do not close an fd that also has an associated umem connected
-- 
2.27.0

