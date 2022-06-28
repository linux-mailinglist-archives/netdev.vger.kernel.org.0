Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E7A55EEA5
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbiF1Txt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbiF1TvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:51:14 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53942E9FA;
        Tue, 28 Jun 2022 12:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445804; x=1687981804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kf6pyiBAKh8PfjaMPwYDzTHelnIuBG2itheZfTrrJ9k=;
  b=Bt1WTvpGUKeNpAUYxZtPcTdoDmTu0ZXBBNQm4Qv4aefbgkaUFRUWOvJP
   YSeO50iCTD1kZWrGLBErJWhYczVJG+r8InAvlH7fa2i1e40h6kuAtWJu2
   Ws/8TrYicsY6nviLg5Ipcc0GkQ7rh+yUbgIIfiPS35kXD6fAAi9fqdTjr
   i4ysNmBsUR2XMCBCibj/Nl+ghdmFuaWe30NZ0NGpbK/uvtbneDpFUGhgb
   nsslFJ3GIJejEMpQLJmCM5H3EObtL7AQ259xS1CAHN2vlYDh3Wv+21B3j
   MlDqFWowV+7R9erB/lIrD5y3Djh1t2ZkDc95oCTATlHaxw3STif9dnFfE
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="343523405"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="343523405"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:50:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="623054245"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 28 Jun 2022 12:49:59 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9m022013;
        Tue, 28 Jun 2022 20:49:57 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 48/52] libbpf: compress Endianness ops with a macro
Date:   Tue, 28 Jun 2022 21:48:08 +0200
Message-Id: <20220628194812.1453059-49-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
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

All of the Endianness helpers for BPF programs have the same
pattern and can be defined using a compression macro, which
will also protect against typos and copy-paste mistakes.
Not speaking of saving locs, of course.
Ahh, if we only could define macros inside other macros.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/lib/bpf/bpf_endian.h | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/tools/lib/bpf/bpf_endian.h b/tools/lib/bpf/bpf_endian.h
index ec9db4feca9f..b03db6aa3f14 100644
--- a/tools/lib/bpf/bpf_endian.h
+++ b/tools/lib/bpf/bpf_endian.h
@@ -77,23 +77,15 @@
 # error "Fix your compiler's __BYTE_ORDER__?!"
 #endif
 
-#define bpf_htons(x)				\
+#define __bpf_endop(op, x)			\
 	(__builtin_constant_p(x) ?		\
-	 __bpf_constant_htons(x) : __bpf_htons(x))
-#define bpf_ntohs(x)				\
-	(__builtin_constant_p(x) ?		\
-	 __bpf_constant_ntohs(x) : __bpf_ntohs(x))
-#define bpf_htonl(x)				\
-	(__builtin_constant_p(x) ?		\
-	 __bpf_constant_htonl(x) : __bpf_htonl(x))
-#define bpf_ntohl(x)				\
-	(__builtin_constant_p(x) ?		\
-	 __bpf_constant_ntohl(x) : __bpf_ntohl(x))
-#define bpf_cpu_to_be64(x)			\
-	(__builtin_constant_p(x) ?		\
-	 __bpf_constant_cpu_to_be64(x) : __bpf_cpu_to_be64(x))
-#define bpf_be64_to_cpu(x)			\
-	(__builtin_constant_p(x) ?		\
-	 __bpf_constant_be64_to_cpu(x) : __bpf_be64_to_cpu(x))
+	 __bpf_constant_##op(x) : __bpf_##op(x))
+
+#define bpf_htons(x)			__bpf_endop(htons, x)
+#define bpf_ntohs(x)			__bpf_endop(ntohs, x)
+#define bpf_htonl(x)			__bpf_endop(htonl, x)
+#define bpf_ntohl(x)			__bpf_endop(ntohl, x)
+#define bpf_cpu_to_be64(x)		__bpf_endop(cpu_to_be64, x)
+#define bpf_be64_to_cpu(x)		__bpf_endop(be64_to_cpu, x)
 
 #endif /* __BPF_ENDIAN__ */
-- 
2.36.1

