Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13AD51DFBF
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 21:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391526AbiEFTs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 15:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388813AbiEFTs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 15:48:56 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC0C6A009;
        Fri,  6 May 2022 12:45:12 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id 126so6641549qkm.4;
        Fri, 06 May 2022 12:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1YXdjAkPRz7R0GDRHx5qp1cZI2CVvENVv7OuXkzP9JQ=;
        b=JZw3DRAfFlP/GScz37EOfnmFGWu5HnV1hE15YSpgW/LbCC7v0Ovq0hX05JUbA4Bja0
         d38/4A8DaHqlecmfbOgfAqadmdQd18SldlKPQyOK6pjemx6H9puQCYZSlSYrAalDIY8i
         /4jbOjzEKgbneWdSWNyBxHbCqofQqRGNcEWni2zSmJcpt2PWIOYR0rqWRWbu0vsg+LNX
         uH+za1HU3H5iHViSzT5CR3sjxkcmriZnJ9phv0wtNiTwHNRnfvnhuWoHBNomJ89rYYmV
         ar5XB7gmgXuXgmIakq+VNv4NccUjSidxBRr/HHkRH8YVIL/NoihVmYqfwffYG0w9saTb
         tacQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1YXdjAkPRz7R0GDRHx5qp1cZI2CVvENVv7OuXkzP9JQ=;
        b=CBwzp5vaWVvQDitpYo5LIzZ3a67PMCfD+gWtOUWRorRIwqPZex80tLBnK3URHkFkeA
         A9O9OquVhM1qIR4XbryKeQjSfJDM5RMKtg6nbEKtyI9IyStMroSctcD4h/rNSea8QM8F
         njzdJNDj4OgrqICfleTk7RjVl5L/64sDNBqjK0koHFECjQ9LnNTc2gdkjmOzXcgXrHw4
         5zSVbKZAQPNLD0noC4oaq5E8pvWXcW7cw0oDxaGAORplcMUdfrKZMFJdDdL9HdUdq5ke
         ss/dw6KofVgf86GKHunIgbWFL+ggiTQM4Ba/gGymoM0+yx+zczmfZN73J42x/FE16oF7
         6J5A==
X-Gm-Message-State: AOAM530CthOYsR0zLkb0mFruRcqJ7VZ2v1REUQBzdqkgJktrHQelEoLS
        NUXfdbvhhWhRClPKyCM11Q==
X-Google-Smtp-Source: ABdhPJwlhp9W8HQGq13lFPgo2AFK4RaLx2MrR9/OlkgRqmrr2YKDwso0Dn8UVyul19xWdnm5f4qsEg==
X-Received: by 2002:a05:620a:44c6:b0:6a0:51fb:49cf with SMTP id y6-20020a05620a44c600b006a051fb49cfmr453864qkp.537.1651866312103;
        Fri, 06 May 2022 12:45:12 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-72-174-210.compute-1.amazonaws.com. [52.72.174.210])
        by smtp.gmail.com with ESMTPSA id t196-20020a37aacd000000b0069fc13ce1d7sm2889949qke.8.2022.05.06.12.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 12:45:11 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH RFC v1 net-next 2/4] net/sched: sch_tbf: Use Qdisc backpressure infrastructure
Date:   Fri,  6 May 2022 12:44:59 -0700
Message-Id: <e089df17037a30119909b07d72fb4f15f18325aa.1651800598.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651800598.git.peilin.ye@bytedance.com>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
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

Recently we introduced a Qdisc backpressure infrastructure for TCP and
UDP sockets.  Use it in TBF.

Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/sched/sch_tbf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 72102277449e..06229765290b 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -250,6 +250,7 @@ static int tbf_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 	ret = qdisc_enqueue(skb, q->qdisc, to_free);
 	if (ret != NET_XMIT_SUCCESS) {
+		qdisc_backpressure_overlimit(sch, skb);
 		if (net_xmit_drop_count(ret))
 			qdisc_qstats_drop(sch);
 		return ret;
@@ -306,6 +307,7 @@ static struct sk_buff *tbf_dequeue(struct Qdisc *sch)
 			return skb;
 		}
 
+		qdisc_backpressure_throttle(sch);
 		qdisc_watchdog_schedule_ns(&q->watchdog,
 					   now + max_t(long, -toks, -ptoks));
 
-- 
2.20.1

