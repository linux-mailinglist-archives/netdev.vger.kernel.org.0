Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D151F55EE98
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbiF1TyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiF1TvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:51:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10352EA15;
        Tue, 28 Jun 2022 12:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445805; x=1687981805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t8ZlSI0m7zNuVag8i0YVuPoeiLfNpeZeGU0sNzKVBRo=;
  b=iDWCVmm1+5mIhFHPow04aog9KkjbtlJmryxRR61ivEMBKHC1L9ch8rvo
   jhwEY2OX1oaRvXRUwJOMYRkj/+X3FIXwOg5OardII5nH8s86KuK4w8NH4
   Y2PtVplwyK3BEjuKZXFZgrHiMUkNrRqDZ13WzE0gCwmdiF3exkPJM2q8S
   fwP5hIGydO5zbak5EPn4NId1oNCLCEflXZNi5BHTAnS6nyhf3AR9bTqry
   WxiOwc3I4Ov41Af3XLrcZyyMviIAvDCy7OVEMuR8hCuD9Byl1hiKg0gr6
   fMNHslDYYihqpeM3J8wAoB6vo9WoMqQjFVmmE0wd1uNIXeRHaQmGn66Qi
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="261635779"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="261635779"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:50:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="732883570"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 28 Jun 2022 12:50:01 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9n022013;
        Tue, 28 Jun 2022 20:49:59 +0100
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
Subject: [PATCH RFC bpf-next 49/52] libbpf: add LE <--> CPU conversion helpers
Date:   Tue, 28 Jun 2022 21:48:09 +0200
Message-Id: <20220628194812.1453059-50-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Larysa Zaremba <larysa.zaremba@intel.com>

XDP Generic metadata structure has fields of the explicit
Endianness, all 16, 32 and 64-bit wide.
To make it easier to access them, define __le{16,32,64} <--> cpu
helpers the same way it's done for the BEs.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/lib/bpf/bpf_endian.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/lib/bpf/bpf_endian.h b/tools/lib/bpf/bpf_endian.h
index b03db6aa3f14..35941e6f1d99 100644
--- a/tools/lib/bpf/bpf_endian.h
+++ b/tools/lib/bpf/bpf_endian.h
@@ -60,6 +60,18 @@
 # define __bpf_cpu_to_be64(x)		__builtin_bswap64(x)
 # define __bpf_constant_be64_to_cpu(x)	___bpf_swab64(x)
 # define __bpf_constant_cpu_to_be64(x)	___bpf_swab64(x)
+# define __bpf_le16_to_cpu(x)		(x)
+# define __bpf_cpu_to_le16(x)		(x)
+# define __bpf_constant_le16_to_cpu(x)	(x)
+# define __bpf_constant_cpu_to_le16(x)	(x)
+# define __bpf_le32_to_cpu(x)		(x)
+# define __bpf_cpu_to_le32(x)		(x)
+# define __bpf_constant_le32_to_cpu(x)	(x)
+# define __bpf_constant_cpu_to_le32(x)	(x)
+# define __bpf_le64_to_cpu(x)		(x)
+# define __bpf_cpu_to_le64(x)		(x)
+# define __bpf_constant_le64_to_cpu(x)	(x)
+# define __bpf_constant_cpu_to_le64(x)	(x)
 #elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
 # define __bpf_ntohs(x)			(x)
 # define __bpf_htons(x)			(x)
@@ -73,6 +85,18 @@
 # define __bpf_cpu_to_be64(x)		(x)
 # define __bpf_constant_be64_to_cpu(x)  (x)
 # define __bpf_constant_cpu_to_be64(x)  (x)
+# define __bpf_le16_to_cpu(x)		__builtin_bswap16(x)
+# define __bpf_cpu_to_le16(x)		__builtin_bswap16(x)
+# define __bpf_constant_le16_to_cpu(x)	___bpf_swab16(x)
+# define __bpf_constant_cpu_to_le16(x)	___bpf_swab16(x)
+# define __bpf_le32_to_cpu(x)		__builtin_bswap32(x)
+# define __bpf_cpu_to_le32(x)		__builtin_bswap32(x)
+# define __bpf_constant_le32_to_cpu(x)	___bpf_swab32(x)
+# define __bpf_constant_cpu_to_le32(x)	___bpf_swab32(x)
+# define __bpf_le64_to_cpu(x)		__builtin_bswap64(x)
+# define __bpf_cpu_to_le64(x)		__builtin_bswap64(x)
+# define __bpf_constant_le64_to_cpu(x)	___bpf_swab64(x)
+# define __bpf_constant_cpu_to_le64(x)	___bpf_swab64(x)
 #else
 # error "Fix your compiler's __BYTE_ORDER__?!"
 #endif
@@ -87,5 +111,11 @@
 #define bpf_ntohl(x)			__bpf_endop(ntohl, x)
 #define bpf_cpu_to_be64(x)		__bpf_endop(cpu_to_be64, x)
 #define bpf_be64_to_cpu(x)		__bpf_endop(be64_to_cpu, x)
+#define bpf_cpu_to_le16(x)		__bpf_endop(cpu_to_le16, x)
+#define bpf_le16_to_cpu(x)		__bpf_endop(le16_to_cpu, x)
+#define bpf_cpu_to_le32(x)		__bpf_endop(cpu_to_le32, x)
+#define bpf_le32_to_cpu(x)		__bpf_endop(le32_to_cpu, x)
+#define bpf_cpu_to_le64(x)		__bpf_endop(cpu_to_le64, x)
+#define bpf_le64_to_cpu(x)		__bpf_endop(le64_to_cpu, x)
 
 #endif /* __BPF_ENDIAN__ */
-- 
2.36.1

