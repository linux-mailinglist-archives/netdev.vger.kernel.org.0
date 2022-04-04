Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B7A4F1427
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 13:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbiDDL7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 07:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiDDL7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 07:59:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FE93D1F9;
        Mon,  4 Apr 2022 04:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649073426; x=1680609426;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cKBDLLuOv+dWVKAI7ODe9hrQ39baEJrrNVpI0RZSqZI=;
  b=IeTl+Gfmmtc5CA8V1zI20M+VNYZRPAKkuj50MtJnJdioBrd6tDn+TWpU
   OcOJs7RQAjxTgZpqh16DRs2fVWlxstNe1daQhvQjUXE8uWEvp5nz+Ftlh
   yv4O8KaN1dYTbrKhhfAGUDQxIYPJ2bBas6AvBw3pMl6rMaxV641gtQM4W
   t9oHNpQiyQf/lNH2+f9tvvkSR6b7HFKdIg+HcKg2rdXLfeosUkFaVNr5E
   HN6W5AMFcnvn/33rW25a7DUVOoLLc851epN7rqj8CU+aWHPBnLAvgFlPh
   dYMm4GHszBOD2y6nWRboYUd3zaEgp8CbgnUhutVXvuN2cydkaj1EX/yDg
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="260485246"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="260485246"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 04:57:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="608014017"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 04 Apr 2022 04:57:02 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 234Bv0u5012668;
        Mon, 4 Apr 2022 12:57:00 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH bpf-next] samples: bpf: fix linking xdp_router_ipv4 after migration
Date:   Mon,  4 Apr 2022 13:54:51 +0200
Message-Id: <20220404115451.1116478-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Users of the xdp_sample_user infra should be explicitly linked
with the standard math library (`-lm`). Otherwise, the following
happens:

/usr/bin/ld: xdp_sample_user.c:(.text+0x59fc): undefined reference to `ceil'
/usr/bin/ld: xdp_sample_user.c:(.text+0x5a0d): undefined reference to `ceil'
/usr/bin/ld: xdp_sample_user.c:(.text+0x5adc): undefined reference to `floor'
/usr/bin/ld: xdp_sample_user.c:(.text+0x5b01): undefined reference to `ceil'
/usr/bin/ld: xdp_sample_user.c:(.text+0x5c1e): undefined reference to `floor'
/usr/bin/ld: xdp_sample_user.c:(.text+0x5c43): undefined reference to `ceil
[...]

That happened previously, so there's a block of linkage flags in the
Makefile. xdp_router_ipv4 has been transferred to this infra quite
recently, but hasn't been added to it. Fix.

Fixes: 85bf1f51691c ("samples: bpf: Convert xdp_router_ipv4 to XDP samples helper")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 samples/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index b4fa0e69aa14..342a41a10356 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -219,6 +219,7 @@ TPROGLDLIBS_xdp_redirect	+= -lm
 TPROGLDLIBS_xdp_redirect_cpu	+= -lm
 TPROGLDLIBS_xdp_redirect_map	+= -lm
 TPROGLDLIBS_xdp_redirect_map_multi += -lm
+TPROGLDLIBS_xdp_router_ipv4	+= -lm
 TPROGLDLIBS_tracex4		+= -lrt
 TPROGLDLIBS_trace_output	+= -lrt
 TPROGLDLIBS_map_perf_test	+= -lrt
-- 
2.35.1

