Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16B855EE94
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbiF1TyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiF1TvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:51:22 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8182F396;
        Tue, 28 Jun 2022 12:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445808; x=1687981808;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u+AC2MYbg8VVczXn+494HhsrP8hqR5Z3OTGl9vIateQ=;
  b=RUhS4kqJRnwUoQde8NR344wvzGJTF570Cg8XQHAm1y2eNjcCDy+W8BOu
   sVsr+CfqTl9sdVW0cafr9Z4Ju1AvTOV02J5dgsJKgzemfHzCotxhj0aIN
   Ff/9Yt9wk+CGvp8PKDNPukoIcu3zA2fAs6pgx87gAm0BppOdG6mtaW442
   bMFufC1KlsuYPAE9/W7L40idiOEe63bg603AA2gksT6SNuWhtJIdIImul
   m4NHSCo9wc/cBIPaPx4rC+g9QPSpnMBXcuzn49VqgnrVT/2Fw7nIcZkBC
   eeluJO7POHgaMdfm/i92W0RNgd8e5RLwYrUOsS3TtGT8dVMubenVK9ioC
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="279379122"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="279379122"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:50:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="767288265"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2022 12:50:03 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9p022013;
        Tue, 28 Jun 2022 20:50:01 +0100
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
Subject: [PATCH RFC bpf-next 51/52] selftests/bpf: fix using test_xdp_meta BPF prog via skeleton infra
Date:   Tue, 28 Jun 2022 21:48:11 +0200
Message-Id: <20220628194812.1453059-52-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

progs/test_xdp_meta works fine when loading via iproute2, but the
skeleton infra can't load it, saying that the types of the BPF
programs present in the binary are not set.
This is due to that the convention is to place XDP progs in the
section which named 'xdp' and TC BPF progs in the section 'tc',
so do it here as well.

Fixes: 22c8852624fc ("bpf: improve selftests and add tests for meta pointer")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/testing/selftests/bpf/progs/test_xdp_meta.c | 4 ++--
 tools/testing/selftests/bpf/test_xdp_meta.sh      | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_xdp_meta.c b/tools/testing/selftests/bpf/progs/test_xdp_meta.c
index a7c4a7d49fe6..fe2d71ae0e71 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_meta.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_meta.c
@@ -8,7 +8,7 @@
 #define round_up(x, y) ((((x) - 1) | __round_mask(x, y)) + 1)
 #define ctx_ptr(ctx, mem) (void *)(unsigned long)ctx->mem
 
-SEC("t")
+SEC("tc")
 int ing_cls(struct __sk_buff *ctx)
 {
 	__u8 *data, *data_meta, *data_end;
@@ -28,7 +28,7 @@ int ing_cls(struct __sk_buff *ctx)
 	return diff ? TC_ACT_SHOT : TC_ACT_OK;
 }
 
-SEC("x")
+SEC("xdp")
 int ing_xdp(struct xdp_md *ctx)
 {
 	__u8 *data, *data_meta, *data_end;
diff --git a/tools/testing/selftests/bpf/test_xdp_meta.sh b/tools/testing/selftests/bpf/test_xdp_meta.sh
index ea69370caae3..7232714e89b3 100755
--- a/tools/testing/selftests/bpf/test_xdp_meta.sh
+++ b/tools/testing/selftests/bpf/test_xdp_meta.sh
@@ -42,11 +42,11 @@ ip netns exec ${NS2} ip addr add 10.1.1.22/24 dev veth2
 ip netns exec ${NS1} tc qdisc add dev veth1 clsact
 ip netns exec ${NS2} tc qdisc add dev veth2 clsact
 
-ip netns exec ${NS1} tc filter add dev veth1 ingress bpf da obj test_xdp_meta.o sec t
-ip netns exec ${NS2} tc filter add dev veth2 ingress bpf da obj test_xdp_meta.o sec t
+ip netns exec ${NS1} tc filter add dev veth1 ingress bpf da obj test_xdp_meta.o sec tc
+ip netns exec ${NS2} tc filter add dev veth2 ingress bpf da obj test_xdp_meta.o sec tc
 
-ip netns exec ${NS1} ip link set dev veth1 xdp obj test_xdp_meta.o sec x
-ip netns exec ${NS2} ip link set dev veth2 xdp obj test_xdp_meta.o sec x
+ip netns exec ${NS1} ip link set dev veth1 xdp obj test_xdp_meta.o sec xdp
+ip netns exec ${NS2} ip link set dev veth2 xdp obj test_xdp_meta.o sec xdp
 
 ip netns exec ${NS1} ip link set dev veth1 up
 ip netns exec ${NS2} ip link set dev veth2 up
-- 
2.36.1

