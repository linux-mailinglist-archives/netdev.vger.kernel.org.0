Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A962954BF1E
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 03:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbiFOBRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 21:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiFOBQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 21:16:59 -0400
Received: from rpt-glb-mail01.tpgi.com.au (rpt-glb-mail01.tpgi.com.au [60.241.0.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C25518399
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 18:16:58 -0700 (PDT)
X-TPG-Junk-Checked: Yes
X-TPG-Junk-Status: score=5.4 tests=DKIM_ADSP_CUSTOM_MED,FORGED_GMAIL_RCVD,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,RDNS_DYNAMIC,SPF_HELO_FAIL,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,T_SCC_BODY_TEXT_LINE
X-TPG-Junk-Level: *****
X-TPG-Abuse: host=193-119-124-135.tpgi.com.au; ip=193.119.124.135; date=Wed, 15 Jun 2022 11:16:14 +1000; auth=iEj2ZfQRwc6ozpDLztTMgpwuFWivWeUIwRXsv1WQFa8=
Received: from jmaxwell.com (193-119-124-135.tpgi.com.au [193.119.124.135])
        (authenticated bits=0)
        by rpt-glb-mail01.tpgi.com.au (envelope-from jmaxwell37@gmail.com) (8.14.3/8.14.3) with ESMTP id 25F1G5XX018835;
        Wed, 15 Jun 2022 11:16:14 +1000
From:   Jon Maxwell <jmaxwell37@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, cutaylor-pub@yahoo.com, atenart@kernel.org,
        daniel@iogearbox.net, joe@cilium.io, i@lmb.io, kafai@fb.com,
        alexei.starovoitov@gmail.com, jmaxwell37@gmail.com,
        bpf@vger.kernel.org
Subject: [PATCH v2] net: bpf: fix request_sock leak in filter.c
Date:   Wed, 15 Jun 2022 11:15:40 +1000
Message-Id: <20220615011540.813025-1-jmaxwell37@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,
        SPOOF_GMAIL_MID,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2 of this patch contains, refactor as per Daniel Borkmann's suggestions to 
validate RCU flags on the listen socket so that it balances with 
bpf_sk_release() and update comments as per Martin KaFai Lau's suggestion.
One small change to Daniels suggestion, put "sk = sk2" under "if (sk2 != sk)"
to avoid an extra instruction.
 
A customer reported a request_socket leak in a Calico cloud environment. We 
found that a BPF program was doing a socket lookup with takes a refcnt on 
the socket and that it was finding the request_socket but returning the parent 
LISTEN socket via sk_to_full_sk() without decrementing the child request socket 
1st, resulting in request_sock slab object leak. This patch retains the 
existing behaviour of returning full socks to the caller but it also decrements
the child request_socket if one is present before doing so to prevent the leak.

Thanks to Curtis Taylor for all the help in diagnosing and testing this. And 
thanks to Antoine Tenart for the reproducer and patch input.

Fixes: f7355a6c0497 ("bpf: Check sk_fullsock() before returning from bpf_sk_lookup()")
Fixes: edbf8c01de5a ("bpf: add skc_lookup_tcp helper")
Tested-by: Curtis Taylor <cutaylor-pub@yahoo.com>
Co-developed-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
---
 net/core/filter.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2e32cee2c469..ec2a1e68af12 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6204,10 +6204,21 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 					   ifindex, proto, netns_id, flags);
 
 	if (sk) {
-		sk = sk_to_full_sk(sk);
-		if (!sk_fullsock(sk)) {
+		struct sock *sk2 = sk_to_full_sk(sk);
+
+		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk
+		 * sock refcnt is decremented to prevent a request_sock leak.
+		 */
+		if (!sk_fullsock(sk2))
+			sk2 = NULL;
+		if (sk2 != sk) {
 			sock_gen_put(sk);
-			return NULL;
+			/* Ensure there is no need to bump sk2 refcnt */
+			if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
+				WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
+				return NULL;
+			}
+			sk = sk2;
 		}
 	}
 
@@ -6241,10 +6252,21 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 					 flags);
 
 	if (sk) {
-		sk = sk_to_full_sk(sk);
-		if (!sk_fullsock(sk)) {
+		struct sock *sk2 = sk_to_full_sk(sk);
+
+		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk
+		 * sock refcnt is decremented to prevent a request_sock leak.
+		 */
+		if (!sk_fullsock(sk2))
+			sk2 = NULL;
+		if (sk2 != sk) {
 			sock_gen_put(sk);
-			return NULL;
+			/* Ensure there is no need to bump sk2 refcnt */
+			if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
+				WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
+				return NULL;
+			}
+			sk = sk2;
 		}
 	}
 
-- 
2.31.1

