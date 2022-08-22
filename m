Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D6459BC7F
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 11:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbiHVJNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 05:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbiHVJND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 05:13:03 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3965530544;
        Mon, 22 Aug 2022 02:12:43 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id w18so7377830qki.8;
        Mon, 22 Aug 2022 02:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=RwkX5VuQNq6CPzJFAR5XBewgxtXPqi3xSbTnyOwN7+I=;
        b=W16aPagnB+Eqqwg3eqLrkblOdKSXmNZjPlTsvIty0BfcZwt7bOxAQKgtjJB4PHOp6H
         Ld/SodOaEnThPZKGKxB1aOLggBKnhwm2uYreRwRg9vEQ2SR4c5tXKN8d6uZjT5FMoVAt
         0bqNcUQ1XNySmsF/om7ndNCq2XAW+FQSzQF3nDrTNOPh3n6RJTgMUSFpbsG17lBLYGpF
         7Q0Y6q/fL7X/hN5rKHkZ7iHoo/ZLnCMk/21hZhvQBcZA1h4d/gzZEXT3NzVdP7F6+f2K
         e6ygCwn2jmqFqwyKNaceIEOD3r+15lnziXt2zHjnTfqSJ6Q4/3R5/olLY52we/yBe1us
         QdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=RwkX5VuQNq6CPzJFAR5XBewgxtXPqi3xSbTnyOwN7+I=;
        b=uRjIxQI6ClhA+f+Idr3ubRtOXtIHRyiTwOK3xXsLSoeN97q3MFDfYUcpr3oLC1IzG4
         PPgo2FnEr1yr++Nv7uYJqvilT6LALOZDFMy+N9Zvs+kZsJEWN0ZNCfNjS1vA/YZQfVU7
         SafhXLpvXNbih33FbV/Y2IVtqdHA5P+o50uHF+1WTY1+NwBWgdPq/MfqcofFbn+x+ibD
         RlJUxTYssh/bxFtPFSfjHrzFYyjf5iHL17oE3T/SKdXtBLiFqIWG97zmq/Jeq9jD1/2t
         8Fsb6NaxXoEVPitY1Isv4JNE7YLV83j2HawryXUhH58JUOCKEoHgcLfNFMniXcaurPIO
         E7mw==
X-Gm-Message-State: ACgBeo16XvnUxFE/y1m6D2G2ivvlFCyuk71h1cTjNphJ8/PdGtBnodpg
        Lahr+VQdtAHVQfuwxyiOP4jOwnl4oQ==
X-Google-Smtp-Source: AA6agR5Ii9soHdFQXnzDhWF4g+b/ct1l8BF9/MouvVlVlmQMFdFO0cRsthpx3Qe2pavQ5Iu0x6h5Mg==
X-Received: by 2002:a37:e20c:0:b0:6bb:2157:749c with SMTP id g12-20020a37e20c000000b006bb2157749cmr11775624qki.752.1661159562294;
        Mon, 22 Aug 2022 02:12:42 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id y12-20020a05620a25cc00b006bb78d095c5sm9862563qko.79.2022.08.22.02.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 02:12:41 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Dave Taht <dave.taht@gmail.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH RFC v2 net-next 3/5] net/sched: sch_tbf: Use Qdisc backpressure infrastructure
Date:   Mon, 22 Aug 2022 02:12:34 -0700
Message-Id: <e55ba88846dee3c6cc6e1c84bcb80590cde0adc4.1661158173.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1661158173.git.peilin.ye@bytedance.com>
References: <cover.1661158173.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Recently we introduced a Qdisc backpressure infrastructure (currently
supports UDP sockets).  Use it in TBF Qdisc.

Tested with 500 Mbits/sec rate limit and SFQ inner Qdisc using 16 iperf UDP
1 Gbit/sec clients.  Before:

[  3]  0.0-15.0 sec  53.6 MBytes  30.0 Mbits/sec   0.208 ms 1190234/1228450 (97%)
[  3]  0.0-15.0 sec  54.7 MBytes  30.6 Mbits/sec   0.085 ms   955591/994593 (96%)
[  3]  0.0-15.0 sec  55.4 MBytes  31.0 Mbits/sec   0.170 ms  966364/1005868 (96%)
[  3]  0.0-15.0 sec  55.0 MBytes  30.8 Mbits/sec   0.167 ms   925083/964333 (96%)
<...>                                                         ^^^^^^^^^^^^^^^^^^^

Total throughput is 480.2 Mbits/sec and average drop rate is 96.5%.

Now enable Qdisc backpressure for UDP sockets, with
udp_backpressure_interval default to 100 milliseconds:

[  3]  0.0-15.0 sec  54.4 MBytes  30.4 Mbits/sec   0.097 ms 450/39246 (1.1%)
[  3]  0.0-15.0 sec  54.4 MBytes  30.4 Mbits/sec   0.331 ms 435/39232 (1.1%)
[  3]  0.0-15.0 sec  54.4 MBytes  30.4 Mbits/sec   0.040 ms 435/39212 (1.1%)
[  3]  0.0-15.0 sec  54.4 MBytes  30.4 Mbits/sec   0.031 ms 426/39208 (1.1%)
<...>                                                       ^^^^^^^^^^^^^^^^

Total throughput is 486.4 Mbits/sec (1.29% higher) and average drop rate
is 1.1% (98.86% lower).

However, enabling Qdisc backpressure affects fairness between flow if we
use TBF Qdisc with default bfifo inner Qdisc:

[  3]  0.0-15.0 sec  46.1 MBytes  25.8 Mbits/sec   1.102 ms 142/33048 (0.43%)
[  3]  0.0-15.0 sec  72.8 MBytes  40.7 Mbits/sec   0.476 ms 145/52081 (0.28%)
[  3]  0.0-15.0 sec  53.2 MBytes  29.7 Mbits/sec   1.047 ms 141/38086 (0.37%)
[  3]  0.0-15.0 sec  45.5 MBytes  25.4 Mbits/sec   1.600 ms 141/32573 (0.43%)
<...>                                                       ^^^^^^^^^^^^^^^^^

In the test, per-flow throughput ranged from 16.4 to 68.7 Mbits/sec.
However, total throughput was still 486.4 Mbits/sec (0.87% higher than
before), and average drop rate was 0.41% (99.58% lower than before).

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/sched/sch_tbf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 72102277449e..cf9cc7dbf078 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -222,6 +222,7 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 		len += segs->len;
 		ret = qdisc_enqueue(segs, q->qdisc, to_free);
 		if (ret != NET_XMIT_SUCCESS) {
+			qdisc_backpressure(skb);
 			if (net_xmit_drop_count(ret))
 				qdisc_qstats_drop(sch);
 		} else {
@@ -250,6 +251,7 @@ static int tbf_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 	ret = qdisc_enqueue(skb, q->qdisc, to_free);
 	if (ret != NET_XMIT_SUCCESS) {
+		qdisc_backpressure(skb);
 		if (net_xmit_drop_count(ret))
 			qdisc_qstats_drop(sch);
 		return ret;
-- 
2.20.1

