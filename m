Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B70453068A
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 00:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiEVW3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 18:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiEVW3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 18:29:44 -0400
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607BA35DFE;
        Sun, 22 May 2022 15:29:42 -0700 (PDT)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 0F3EDEFB219;
        Mon, 23 May 2022 00:29:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1653258579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5RsrrUIcLxd7wE1ZN1EHer8TNCgmy1gA2oqSx8f1A4U=;
        b=CAZ76pAxkI/iO9yjqzNcud839rZ1d8coHmFN2PAERvzQf9j7kYZlZwl5cLM4fm/mLKnhBe
        fVjHf6M6jcbMDLSGiwh3OIx+frgWItdBn3EtDvj+h/kPmYXC4QH5wiBNGe2hr/Q5T4LlyF
        x5KrUorPIJPSk/xombCixocebHreoDk=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Yuchung Cheng <ycheng@google.com>,
        Yousuk Seung <ysseung@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Adithya Abraham Philip <abrahamphilip@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konstantin Demin <rockdrilla@gmail.com>
Subject: [RFC] tcp_bbr2: use correct 64-bit division
Date:   Mon, 23 May 2022 00:29:37 +0200
Message-ID: <4740526.31r3eYUQgx@natalenko.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Neal.

It was reported to me [1] by Konstantin (in Cc) that BBRv2 code suffers from integer division issue on 32 bit systems.

Konstantin suggested a solution available in the same linked merge request and copy-pasted by me below for your convenience:

```
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 664c9e119787..fd3f89e3a8a6 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -312,7 +312,7 @@ static u32 bbr_tso_segs_generic(struct sock *sk, unsigned int mss_now,
 	bytes = sk->sk_pacing_rate >> sk->sk_pacing_shift;
 
 	bytes = min_t(u32, bytes, gso_max_size - 1 - MAX_TCP_HEADER);
-	segs = max_t(u32, bytes / mss_now, bbr_min_tso_segs(sk));
+	segs = max_t(u32, div_u64(bytes, mss_now), bbr_min_tso_segs(sk));
 	return segs;
 }
 
diff --git a/net/ipv4/tcp_bbr2.c b/net/ipv4/tcp_bbr2.c
index fa49e17c47ca..488429f0f3d0 100644
--- a/net/ipv4/tcp_bbr2.c
+++ b/net/ipv4/tcp_bbr2.c
@@ -588,7 +588,7 @@ static void bbr_debug(struct sock *sk, u32 acked,
 		 bbr_rate_kbps(sk, bbr_max_bw(sk)), /* bw: max bw */
 		 0ULL,				    /* lb: [obsolete] */
 		 0ULL,				    /* ib: [obsolete] */
-		 (u64)sk->sk_pacing_rate * 8 / 1000,
+		 div_u64((u64)sk->sk_pacing_rate * 8, 1000),
 		 acked,
 		 tcp_packets_in_flight(tp),
 		 rs->is_ack_delayed ? 'd' : '.',
@@ -698,7 +698,7 @@ static u32 bbr_tso_segs_generic(struct sock *sk, unsigned int mss_now,
 	}
 
 	bytes = min_t(u32, bytes, gso_max_size - 1 - MAX_TCP_HEADER);
-	segs = max_t(u32, bytes / mss_now, bbr_min_tso_segs(sk));
+	segs = max_t(u32, div_u64(bytes, mss_now), bbr_min_tso_segs(sk));
 	return segs;
 }
```

Could you please evaluate this report and check whether it is correct, and also check whether the suggested patch is acceptable?

Thanks.

[1] https://gitlab.com/post-factum/pf-kernel/-/merge_requests/6

-- 
Oleksandr Natalenko (post-factum)


