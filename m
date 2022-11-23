Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAED636154
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236824AbiKWOSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbiKWOSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:18:35 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7B16037C
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:18:33 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id a29so28307726lfj.9
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Cl/DMCkVzUgLuaiNEp4gc18HhldIP35Tm09AOeDeV9U=;
        b=GgITb1xtbaR4nlUqLZl+/t04P5pi5eDHXqxJ72OCRCj7Ykd9AiqDBcgbeJ2PEvsfUn
         upWMb02KZ+BbzXJOwUyZ1xgpvC8UJIiZHhB46LMq6OMpEabgn4qYIc1ZjcMhnAcNYwr+
         /x0fQC6UDGQQRmr3RHxN4tvq+FGwZ7agPRRKk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cl/DMCkVzUgLuaiNEp4gc18HhldIP35Tm09AOeDeV9U=;
        b=1QGCROc8qwfr4Q4qDDA9ZKTyvXGUUR0J2cEPMJPxNlDoSI5AKi9gQBmdHitZbvuGdN
         ugifo93WmrgPqNNTWiBSilN6yZ4zHLRvU2vjW6eQ+8YZDwVsDcXvqpZTe7b+TVsoYPm6
         kHMv3Byj6br3PkwRP4ChrgmHkyP5mS/B0hoGZ7RtJBRRt183TtrtbjnUzGKembBQ3/Cy
         2YPrDa+6sj9IWeyotarwvWL/MrHTzSUlKJiZaPLTwEo7ZSApTdKOA6riME4wwyqui5GC
         o7QCQtkB2TvpNX6b2sDYa2Q+haqiARC7jdqhkVLfyBbgdphSRSVXNTkP37MeS+ltVirZ
         9Mxg==
X-Gm-Message-State: ANoB5pmUe3ULO7V1Vefm2nscBnvnVkTYrVgIf/IObAQEScgw54W+C5Pg
        0gFk5UgN3F88LJvBf4vgl4xAng==
X-Google-Smtp-Source: AA0mqf4xvSwP4X2g4YJ99/oO05IuZxFOSGFck+nzEwQSz6fHILEmuGh1PwnKJkM/qjIpk3hKKfou7w==
X-Received: by 2002:a05:6512:3b88:b0:4a3:9533:f4c9 with SMTP id g8-20020a0565123b8800b004a39533f4c9mr3669283lfv.615.1669213111973;
        Wed, 23 Nov 2022 06:18:31 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id k14-20020ac2456e000000b004a478c2f4desm2898619lfm.163.2022.11.23.06.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 06:18:31 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: loopback: use NET_NAME_PREDICTABLE for name_assign_type
Date:   Wed, 23 Nov 2022 15:18:28 +0100
Message-Id: <20221123141829.1825170-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the name_assign_type attribute was introduced (commit
685343fc3ba6, "net: add name_assign_type netdev attribute"), the
loopback device was explicitly mentioned as one which would make use
of NET_NAME_PREDICTABLE:

    The name_assign_type attribute gives hints where the interface name of a
    given net-device comes from. These values are currently defined:
...
      NET_NAME_PREDICTABLE:
        The ifname has been assigned by the kernel in a predictable way
        that is guaranteed to avoid reuse and always be the same for a
        given device. Examples include statically created devices like
        the loopback device [...]

Switch to that so that reading /sys/class/net/lo/name_assign_type
produces something sensible instead of returning -EINVAL.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---

This is mostly cosmetic, but ideally I'd like to get to a situation
where I don't need to do

  assign_type=$(cat /sys/class/net/$dev/name_assign_type 2> /dev/null || echo 0)

or otherwise special-case [ $dev = "lo" ].

As always, there's a small chance that this could cause a regression,
but it seems extremely unlikely that anybody relies on
/sys/class/net/lo/name_assign_type being unreadable and thus
effectively is known to be NET_NAME_UNKNOWN.

 drivers/net/loopback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 14e8d04cb434..2e9742952c4e 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -211,7 +211,7 @@ static __net_init int loopback_net_init(struct net *net)
 	int err;
 
 	err = -ENOMEM;
-	dev = alloc_netdev(0, "lo", NET_NAME_UNKNOWN, loopback_setup);
+	dev = alloc_netdev(0, "lo", NET_NAME_PREDICTABLE, loopback_setup);
 	if (!dev)
 		goto out;
 
-- 
2.37.2

