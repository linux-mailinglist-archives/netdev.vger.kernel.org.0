Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F9659BC77
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 11:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiHVJNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 05:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbiHVJND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 05:13:03 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDBB2F38E;
        Mon, 22 Aug 2022 02:12:53 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id b2so7369111qkh.12;
        Mon, 22 Aug 2022 02:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=EoKU5NMd0nzh9okS9yEL/Pxx8uJ6M3X3Pa8DzwXaJ+s=;
        b=dPK7MlOv/3Rv0kwtSMm0JB69QUtxCgCKxZmnOprsQIp6PvJ3ToiOcWmfZBZx6b9sq/
         m8b779okEh51eTPdfVb0smV5QcFUx7z+tXP8B0DebRax4kx7tZ2+gIGlMi2gAfmmouGX
         ycbiDJpu9TLbqRwR+05Dw7w9We5KHvTc3Y3zqHcmXQKpSR6y57iaHbfFfxL+Ss+5Nljy
         tmY+4HHzyPVTg/+mrGf5GHB3JzK/cccnOy45IaZ9PUvzjbq/UBa/C2vunSot0+gAr9JR
         g1ModSkIE9De7+Kdq+rNIwCfBbiUiqTfPB/f77Z3Zkh/k2m11k2mZZAdl8u8pgmTP1nj
         AZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=EoKU5NMd0nzh9okS9yEL/Pxx8uJ6M3X3Pa8DzwXaJ+s=;
        b=qyfgBuHtQdj9v2wUNiCZ+Vd/hDVQrF+7qMAlApBVHkwUxhWXS7WDoBYbqni8jL8/qW
         vUaOsyyfLG8nrTFrqri/+ccOCFFzHYwcnddl2IhqEKnTE/lV8wscltugKdgLw7XOW4F7
         chVX5ypm61fF/VSK5CJOFxsUfRgyEchdb6P8IFFqUAiHGYH60jSelV30Eoq+m0G7Bw2v
         0T+TIWPsxHIRPgEtzuIqSfv6qDs30kvrVHh39U3ZaE13DQ+ZleRyxEpbgKkxdOK0qahn
         YJhUVyWh5PlrIiRNxVv6HVxc57L0D5RJXCLOCPXNql06o6vzXentk+R9fNetGkLjlPXG
         1BlQ==
X-Gm-Message-State: ACgBeo08us/oMmQRP9m6hM3SKVKwJqvMYomYRGUli0OWHgnui5nxOpu/
        0qsSTluEsxNXCP6Y3oPjpw==
X-Google-Smtp-Source: AA6agR7kAtYh6BJ3ptuhEepdvK5e3yQ+AwZtrhWmc2vVNkIQj/8XuOwa+/n08Fo7y/e1nzWn0CXVZw==
X-Received: by 2002:a05:620a:f8c:b0:6b5:bcfd:87e3 with SMTP id b12-20020a05620a0f8c00b006b5bcfd87e3mr11737015qkn.93.1661159572324;
        Mon, 22 Aug 2022 02:12:52 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id az41-20020a05620a172900b006bb8b5b79efsm10293327qkb.129.2022.08.22.02.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 02:12:51 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 4/5] net/sched: sch_htb: Use Qdisc backpressure infrastructure
Date:   Mon, 22 Aug 2022 02:12:45 -0700
Message-Id: <c0554e13c7f2abb8fa38a70975ba3adbe4d9ecff.1661158173.git.peilin.ye@bytedance.com>
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
supports UDP sockets).  Use it in HTB Qdisc.

Tested with 500 Mbits/sec rate limit using 16 iperf UDP 1 Gbit/sec
clients.  Before:

[  3]  0.0-15.0 sec  54.2 MBytes  30.4 Mbits/sec   0.875 ms 1245750/1284444 (97%)
[  3]  0.0-15.0 sec  54.2 MBytes  30.3 Mbits/sec   1.288 ms 1238753/1277402 (97%)
[  3]  0.0-15.0 sec  54.8 MBytes  30.6 Mbits/sec   1.761 ms 1261762/1300817 (97%)
[  3]  0.0-15.0 sec  53.9 MBytes  30.1 Mbits/sec   1.635 ms 1241690/1280133 (97%)
<...>                                                       ^^^^^^^^^^^^^^^^^^^^^

Total throughput is 482.0 Mbits/sec and average drop rate is 97.0%.

Now enable Qdisc backpressure for UDP sockets, with
udp_backpressure_interval default to 100 milliseconds:

[  3]  0.0-15.0 sec  53.0 MBytes  29.6 Mbits/sec   1.621 ms 54/37856 (0.14%)
[  3]  0.0-15.0 sec  55.9 MBytes  31.3 Mbits/sec   1.368 ms  6/39895 (0.015%)
[  3]  0.0-15.0 sec  52.3 MBytes  29.2 Mbits/sec   1.560 ms 56/37340 (0.15%)
[  3]  0.0-15.0 sec  52.7 MBytes  29.5 Mbits/sec   1.495 ms 57/37677 (0.15%)
<...>                                                       ^^^^^^^^^^^^^^^^

Total throughput is 485.9 Mbits/sec (0.81% higher) and average drop rate
is 0.1% (99.9% lower).

Fairness between flows is slightly affected, with per-flow average
throughput ranging from 29.2 to 31.8 Mbits/sec (compared with 29.7 to
30.6 Mbits/sec).

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/sched/sch_htb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 23a9d6242429..e337b3d0dab3 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -623,6 +623,7 @@ static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			__qdisc_enqueue_tail(skb, &q->direct_queue);
 			q->direct_pkts++;
 		} else {
+			qdisc_backpressure(skb);
 			return qdisc_drop(skb, sch, to_free);
 		}
 #ifdef CONFIG_NET_CLS_ACT
@@ -634,6 +635,7 @@ static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 #endif
 	} else if ((ret = qdisc_enqueue(skb, cl->leaf.q,
 					to_free)) != NET_XMIT_SUCCESS) {
+		qdisc_backpressure(skb);
 		if (net_xmit_drop_count(ret)) {
 			qdisc_qstats_drop(sch);
 			cl->drops++;
-- 
2.20.1

