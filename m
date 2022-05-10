Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B583520C1C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiEJDhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235530AbiEJDgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:36:49 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A5917D3B6
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:32:39 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so897456pjb.1
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GYpPq4J8axpzp/fW72f0SY/pW+RvbiYhaWPc3DAnPYg=;
        b=EBiAqo4W9UuyeCGWTgyDa8C8GuIMgnYqVuKAXTxblhYcyUTollmt9sS93TPL7M03c8
         nJBSDkYgU0sugWydBpxdCmnicLWYjDwOLopvwXaPWAP3Tc1wqgPUXBLHYm7DTIsfD8+H
         W7NxFfY2ZanMUX6YlXSLG5VAMdG8yCWW+mcYXf7qosO20HB6drv4ydseAk13eOTSP9hu
         mLFZhoRWdCrWIssfEyZ6iky3OXbE4vwLo9bcn9wPbmOaVAnqlh/gsqq0CvoNJiORDkFg
         qBKW7t6cAWMOfz1yyrc56l7+1tiqRkdTzhL961emoXdS9EkSykj6v5RhR0MCqzMGRDyM
         gj1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GYpPq4J8axpzp/fW72f0SY/pW+RvbiYhaWPc3DAnPYg=;
        b=xeJeB1mdmo1ymwtrejAznKE+2+mXg02UMKIUAAZrEsx+bYrvgVAe38XFRwZ5tCIYoj
         wLJzKIgyWgGNOOn13mvRufNJ7M8kN1tTVFfK32yGXFaVF1AddFJWWQLznloB3hp5HpXj
         Q2EFLdGlJ6nwRBmFc45jdYqW+AOS2hroqGGt5TGEvejucW3v/2FPB8ALwSY93ylbrvbd
         KZDk26Vv3DodblZ2IHNILsHA2J2JwlfjZXQRx0Vm1x6s3JZCAdplrZ522zW6AmgTFlk2
         9OwxX1kLK9C3om78Oz+TCH1fPNBq3TBMExPPlz9bL0bq7GYw9uFD/iuVoqiTeqH2d9MB
         YX4w==
X-Gm-Message-State: AOAM531dyiQVlQqOOJTo6Ydzz1dQy8/1Pv+xAziGmufT0w/mvDhrMVEN
        Ndn/yDPlWex6IsJatC2JBrQ=
X-Google-Smtp-Source: ABdhPJzmQbIuide0c0uQwhayx0C680u/NFA+r88rCAK0IoCJSJAxjUq0UCUYd71EVe9jHC9x3Unc0A==
X-Received: by 2002:a17:902:8303:b0:15f:86f:70a with SMTP id bd3-20020a170902830300b0015f086f070amr10370839plb.5.1652153558655;
        Mon, 09 May 2022 20:32:38 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id me16-20020a17090b17d000b001d77f392280sm538185pjb.30.2022.05.09.20.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:32:38 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v6 net-next 10/13] net: loopback: enable BIG TCP packets
Date:   Mon,  9 May 2022 20:32:16 -0700
Message-Id: <20220510033219.2639364-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220510033219.2639364-1-eric.dumazet@gmail.com>
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Set the driver limit to GSO_MAX_SIZE (512 KB).

This allows the admin/user to set a GSO limit up to this value.

Tested:

ip link set dev lo gso_max_size 200000
netperf -H ::1 -t TCP_RR -l 100 -- -r 80000,80000 &

tcpdump shows :

18:28:42.962116 IP6 ::1 > ::1: HBH 40051 > 63780: Flags [P.], seq 3626480001:3626560001, ack 3626560001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 80000
18:28:42.962138 IP6 ::1.63780 > ::1.40051: Flags [.], ack 3626560001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 0
18:28:42.962152 IP6 ::1 > ::1: HBH 63780 > 40051: Flags [P.], seq 3626560001:3626640001, ack 3626560001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 80000
18:28:42.962157 IP6 ::1.40051 > ::1.63780: Flags [.], ack 3626640001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 0
18:28:42.962180 IP6 ::1 > ::1: HBH 40051 > 63780: Flags [P.], seq 3626560001:3626640001, ack 3626640001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 80000
18:28:42.962214 IP6 ::1.63780 > ::1.40051: Flags [.], ack 3626640001, win 17743, options [nop,nop,TS val 3771179266 ecr 3771179265], length 0
18:28:42.962228 IP6 ::1 > ::1: HBH 63780 > 40051: Flags [P.], seq 3626640001:3626720001, ack 3626640001, win 17743, options [nop,nop,TS val 3771179266 ecr 3771179265], length 80000
18:28:42.962233 IP6 ::1.40051 > ::1.63780: Flags [.], ack 3626720001, win 17743, options [nop,nop,TS val 3771179266 ecr 3771179266], length 0

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/loopback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 720394c0639b20a2fd6262e4ee9d5813c02802f1..14e8d04cb4347cb7b9171d576156fb8e8ecebbe3 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -191,6 +191,8 @@ static void gen_lo_setup(struct net_device *dev,
 	dev->netdev_ops		= dev_ops;
 	dev->needs_free_netdev	= true;
 	dev->priv_destructor	= dev_destructor;
+
+	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 }
 
 /* The loopback device is special. There is only one instance
-- 
2.36.0.512.ge40c2bad7a-goog

