Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A184EE5F3
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 04:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243997AbiDACRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 22:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238832AbiDACRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 22:17:54 -0400
Received: from mail.meizu.com (edge07.meizu.com [112.91.151.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E803422451A;
        Thu, 31 Mar 2022 19:16:04 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail11.meizu.com
 (172.16.1.15) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 1 Apr 2022
 10:15:57 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Fri, 1 Apr
 2022 10:15:56 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
CC:     Haowen Bai <baihaowen@meizu.com>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] selftests/bpf: Return true/false (not 1/0) from bool functions
Date:   Fri, 1 Apr 2022 10:15:54 +0800
Message-ID: <1648779354-14700-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-124.meizu.com (172.16.1.124) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return boolean values ("true" or "false") instead of 1 or 0 from bool
functions.  This fixes the following warnings from coccicheck:

./tools/testing/selftests/bpf/progs/test_xdp_noinline.c:567:9-10: WARNING:
return of 0/1 in function 'get_packet_dst' with return type bool
./tools/testing/selftests/bpf/progs/test_l4lb_noinline.c:221:9-10: WARNING:
return of 0/1 in function 'get_packet_dst' with return type bool

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 tools/testing/selftests/bpf/progs/test_l4lb_noinline.c |  2 +-
 tools/testing/selftests/bpf/progs/test_xdp_noinline.c  | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c b/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
index 19e4d20..c8bc0c6 100644
--- a/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
@@ -218,7 +218,7 @@ static __noinline bool get_packet_dst(struct real_definition **real,
 
 	if (hash != 0x358459b7 /* jhash of ipv4 packet */  &&
 	    hash != 0x2f4bc6bb /* jhash of ipv6 packet */)
-		return 0;
+		return false;
 
 	real_pos = bpf_map_lookup_elem(&ch_rings, &key);
 	if (!real_pos)
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
index 596c4e7..125d872 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
@@ -564,22 +564,22 @@ static bool get_packet_dst(struct real_definition **real,
 	hash = get_packet_hash(pckt, hash_16bytes);
 	if (hash != 0x358459b7 /* jhash of ipv4 packet */  &&
 	    hash != 0x2f4bc6bb /* jhash of ipv6 packet */)
-		return 0;
+		return false;
 	key = 2 * vip_info->vip_num + hash % 2;
 	real_pos = bpf_map_lookup_elem(&ch_rings, &key);
 	if (!real_pos)
-		return 0;
+		return false;
 	key = *real_pos;
 	*real = bpf_map_lookup_elem(&reals, &key);
 	if (!(*real))
-		return 0;
+		return false;
 	if (!(vip_info->flags & (1 << 1))) {
 		__u32 conn_rate_key = 512 + 2;
 		struct lb_stats *conn_rate_stats =
 		    bpf_map_lookup_elem(&stats, &conn_rate_key);
 
 		if (!conn_rate_stats)
-			return 1;
+			return true;
 		cur_time = bpf_ktime_get_ns();
 		if ((cur_time - conn_rate_stats->v2) >> 32 > 0xffFFFF) {
 			conn_rate_stats->v1 = 1;
@@ -587,14 +587,14 @@ static bool get_packet_dst(struct real_definition **real,
 		} else {
 			conn_rate_stats->v1 += 1;
 			if (conn_rate_stats->v1 >= 1)
-				return 1;
+				return true;
 		}
 		if (pckt->flow.proto == IPPROTO_UDP)
 			new_dst_lru.atime = cur_time;
 		new_dst_lru.pos = key;
 		bpf_map_update_elem(lru_map, &pckt->flow, &new_dst_lru, 0);
 	}
-	return 1;
+	return true;
 }
 
 __attribute__ ((noinline))
-- 
2.7.4

