Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242A61EBE8E
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 16:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgFBO6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 10:58:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:37388 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgFBO6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 10:58:43 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jg8NF-0007c5-HT; Tue, 02 Jun 2020 16:58:41 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     lmb@cloudflare.com, alan.maguire@oracle.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 3/3] bpf, selftests: Adapt cls_redirect to call csum_level helper
Date:   Tue,  2 Jun 2020 16:58:34 +0200
Message-Id: <e7458f10e3f3d795307cbc5ad870112671d9c6f7.1591108731.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1591108731.git.daniel@iogearbox.net>
References: <cover.1591108731.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25831/Tue Jun  2 14:41:03 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adapt bpf_skb_adjust_room() to pass in BPF_F_ADJ_ROOM_NO_CSUM_RESET flag and
use the new bpf_csum_level() helper to inc/dec the checksum level by one after
the encap/decap.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/testing/selftests/bpf/progs/test_cls_redirect.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.c b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
index 1668b993eb86..f0b72e86bee5 100644
--- a/tools/testing/selftests/bpf/progs/test_cls_redirect.c
+++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
@@ -380,9 +380,10 @@ static ret_t accept_locally(struct __sk_buff *skb, encap_headers_t *encap)
 	}
 
 	if (bpf_skb_adjust_room(skb, -encap_overhead, BPF_ADJ_ROOM_MAC,
-				BPF_F_ADJ_ROOM_FIXED_GSO)) {
+				BPF_F_ADJ_ROOM_FIXED_GSO |
+				BPF_F_ADJ_ROOM_NO_CSUM_RESET) ||
+	    bpf_csum_level(skb, BPF_CSUM_LEVEL_DEC))
 		return TC_ACT_SHOT;
-	}
 
 	return bpf_redirect(skb->ifindex, BPF_F_INGRESS);
 }
@@ -472,7 +473,9 @@ static ret_t forward_with_gre(struct __sk_buff *skb, encap_headers_t *encap,
 	}
 
 	if (bpf_skb_adjust_room(skb, delta, BPF_ADJ_ROOM_NET,
-				BPF_F_ADJ_ROOM_FIXED_GSO)) {
+				BPF_F_ADJ_ROOM_FIXED_GSO |
+				BPF_F_ADJ_ROOM_NO_CSUM_RESET) ||
+	    bpf_csum_level(skb, BPF_CSUM_LEVEL_INC)) {
 		metrics->errors_total_encap_adjust_failed++;
 		return TC_ACT_SHOT;
 	}
-- 
2.21.0

