Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E682259BC74
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 11:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbiHVJOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 05:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbiHVJNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 05:13:06 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE04F2F012;
        Mon, 22 Aug 2022 02:13:05 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id s11so7402083qtx.6;
        Mon, 22 Aug 2022 02:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=oLhRD+x39eo4QrarK+tsqoJXBmbcLJZygmNFucd2Avo=;
        b=msRFpykTXsCe/Pxd8Y6WfbL+jEIjV+02eeFydYh17S4cRtTLXt9VY9B2mKuhDkiFKv
         W0jleKLm4DXs6spyttKlvblcS1D/lTPPdAFidZ4y3jLFD+S4oKfEnX/HQ5Na9IBUey6U
         a0kXbS8Nk/UcIHPbs+4eI9g8yyYGujNUh2EKGozQQietcyyIMO0nIqymNnMtMqhaikyM
         8gqy80bE+hulmDp3Wi6gnFSj8L0pBoBhoCWtUzCHzpNhGc0sAop+dm5dX/Gwcaf69lVs
         N9GuJ7+UyxVdF+lDTM8GlCV9zGJSofbi6SxTSt8P3dxdUcNqVz6Z/360KnDrsoM7ms1L
         Ge6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=oLhRD+x39eo4QrarK+tsqoJXBmbcLJZygmNFucd2Avo=;
        b=nwgtli7oh5Mr25w3g4u/4Qe8HlyZ5I0CAU0isjP21Dh4TP1VqQZmCbEI1IxprEOdgs
         i2JfWLXXXmttTieEg6ynlG7vgmexakE6iYo69ZXgpWEuc7yRAOa5aL2uSMuWhar3CsnG
         ImrVtuCSz2BHHRYjD73BVnA8rCzIkr6a7doApQBKlCT0wpUsa+eI9mLt+stN5SgiaqLH
         Yo5iIwV8yIIViKPPhmTZU69QD1E6IgyhB+BTtNxTxdCldd+ECz2tEx2i1OxUa7L7YV9E
         HeknFFG5SMcIs54LYfAlM6J6FhaW244kPZvpN4i6ydfkfatK9baql+sn4zdCH3/+OzUA
         p88A==
X-Gm-Message-State: ACgBeo2zawxIUndr9WhpKst4Gj8V8sP2zvU/nnAoFpd8WVc9X09gOAK0
        PNLwm7GXSO0WCxpreCqT5Q==
X-Google-Smtp-Source: AA6agR4N9vnN8Gs4b6r+a2D+aUM9fVUuftjPg9+VD9tSWdsy6YeEUE5rTWIyu3/GFCwRnpeP5qFB9g==
X-Received: by 2002:a05:622a:1214:b0:344:5ec8:d620 with SMTP id y20-20020a05622a121400b003445ec8d620mr14654563qtx.228.1661159585026;
        Mon, 22 Aug 2022 02:13:05 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id bw12-20020a05622a098c00b0031eddc83560sm8626117qtb.90.2022.08.22.02.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 02:13:04 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 5/5] net/sched: sch_cbq: Use Qdisc backpressure infrastructure
Date:   Mon, 22 Aug 2022 02:12:57 -0700
Message-Id: <614f8f31e3b62dfebb8cb4707c81918a6c7e381d.1661158173.git.peilin.ye@bytedance.com>
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
supports UDP sockets).  Use it in CBQ Qdisc.

Tested with 500 Mbits/sec rate limit using 16 iperf UDP 1 Gbit/sec
clients.  Before:

[  3]  0.0-15.0 sec  55.8 MBytes  31.2 Mbits/sec   1.185 ms 1073326/1113110 (96%)
[  3]  0.0-15.0 sec  55.9 MBytes  31.3 Mbits/sec   1.001 ms 1080330/1120201 (96%)
[  3]  0.0-15.0 sec  55.6 MBytes  31.1 Mbits/sec   1.750 ms 1078292/1117980 (96%)
[  3]  0.0-15.0 sec  55.3 MBytes  30.9 Mbits/sec   0.895 ms 1089200/1128640 (97%)
<...>                                                       ^^^^^^^^^^^^^^^^^^^^^

Total throughput is 493.7 Mbits/sec and average drop rate is 96.13%.

Now enable Qdisc backpressure for UDP sockets, with
udp_backpressure_interval default to 100 milliseconds:

[  3]  0.0-15.0 sec  54.2 MBytes  30.3 Mbits/sec   2.302 ms 54/38692 (0.14%)
[  3]  0.0-15.0 sec  54.1 MBytes  30.2 Mbits/sec   2.227 ms 54/38671 (0.14%)
[  3]  0.0-15.0 sec  53.5 MBytes  29.9 Mbits/sec   2.043 ms 57/38203 (0.15%)
[  3]  0.0-15.0 sec  58.1 MBytes  32.5 Mbits/sec   1.843 ms 1/41480 (0.0024%)
<...>                                                       ^^^^^^^^^^^^^^^^^

Total throughput is 497.1 Mbits/sec (0.69% higher), average drop rate is
0.08% (99.9% lower).

Fairness between flows is slightly affected, with per-flow average
throughput ranging from 29.9 to 32.6 Mbits/sec (compared with 30.3 to
31.3 Mbits/sec).

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/sched/sch_cbq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 91a0dc463c48..42e44f570988 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -381,6 +381,7 @@ cbq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		return ret;
 	}
 
+	qdisc_backpressure(skb);
 	if (net_xmit_drop_count(ret)) {
 		qdisc_qstats_drop(sch);
 		cbq_mark_toplevel(q, cl);
-- 
2.20.1

