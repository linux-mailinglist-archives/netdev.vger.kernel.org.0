Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E824443A1
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhKCOev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbhKCOev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 10:34:51 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5666C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 07:32:14 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so1524623pjc.4
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 07:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P5Xv2oiwNU4bnfBjalF2uJboqEeK464uF9/JBROIcw0=;
        b=IdDYnRJ6GVU8+3gEVhNSKqiTlD7SZ5CoOFviFUxZqnIsA3lwz5dAaT7vqdoKpcGsI1
         yN1CfRM9GfPXy3PGy5oglV6L6hco78r2xOIqS+ElQ1suLBxaZWepoHeJVZyAmYA5bTOf
         c72k8WZQbbVEEWPifqaXy0+dSeCiiPg3Xz9MpkphZHZDIAGUUix3K0o5QFpyjV9KLZ8M
         1Tg+tXrm/Oo4T0JoN/IcPFtnL/pbkPQC4w3qw2Ggv0gXrwhOhor0tUrDcQzBirb8XumN
         lw5mM2Eo5UsUTk/sW4yJhFDR/UyQSZMkw7zFSji56uQdbf0O6yTvb1FLeKIaABB2hUiv
         ncVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P5Xv2oiwNU4bnfBjalF2uJboqEeK464uF9/JBROIcw0=;
        b=sLd9af2W1eROzCiAa4fIvRb9yoJhaMILxGo4VguGl+a4SB/CeTC0YWkYy9x44EECRr
         QnbjvNTx9lYrVvQ+eVGmcrP/1hpozeNxBISdJIrYv2IlcGFv96G3wdypuUL59l2mpfEh
         c28g4PUrfokrVOKz+p37wq2RTeLkh3rT/hs9AetrEzD4Uwt2RzuPOHWWvK4iYbhuZpyV
         Tb7aY3JL9HrV6e43zE31q/RR2IJWn1Xl2xP/+zfuBqaDtuJxTbIIpXS6ux3wVPQX6zWH
         SGrbxQLoKObdbqU0J7lpmzZd9V1mOIo9YjrnRcuWNL2+8JGPAHf3UNHpdqGLp9ITc5oX
         Bg2g==
X-Gm-Message-State: AOAM530mnGTi4cyoJcWhmXqTjMtCnv1hJ+ogvBilLNqYrjDK5kCLKgc6
        2keyOlnh352UYWE42GnSZ2KHQirkb+BhOw==
X-Google-Smtp-Source: ABdhPJy9FnCP6XNNyVp3Xb2uwBtvy72zCrQK8SNlV2N8M6CywWiuMz0zH92MikPSCjCRwdAd7llXDA==
X-Received: by 2002:a17:902:784c:b0:138:f4e5:9df8 with SMTP id e12-20020a170902784c00b00138f4e59df8mr38735141pln.14.1635949934127;
        Wed, 03 Nov 2021 07:32:14 -0700 (PDT)
Received: from localhost.localdomain ([111.201.149.194])
        by smtp.gmail.com with ESMTPSA id u10sm2594141pfh.49.2021.11.03.07.32.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Nov 2021 07:32:13 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH v2] net: sched: check tc_skip_classify as far as possible
Date:   Wed,  3 Nov 2021 22:32:08 +0800
Message-Id: <20211103143208.41282-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

We look up and then check tc_skip_classify flag in net
sched layer, even though skb don't want to be classified.
That case may consume a lot of cpu cycles.

Install the rules as below:
$ for id in $(seq 1 100); do
$       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
$ done

netperf:
$ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
$ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32

Before: 10662.33 tps, 108.95 Mbit/s
After:  12434.48 tps, 145.89 Mbit/s

For TCP_RR, there are 16.6% improvement, TCP_STREAM 33.9%.

Cc: Willem de Bruijn <willemb@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v2: don't delete skb_skip_tc_classify in act_api 
---
 net/core/dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index edeb811c454e..fc29a429e9ad 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3940,6 +3940,9 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	if (!miniq)
 		return skb;
 
+	if (skb_skip_tc_classify(skb))
+		return skb;
+
 	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
 	qdisc_skb_cb(skb)->mru = 0;
 	qdisc_skb_cb(skb)->post_ct = false;
-- 
2.27.0

