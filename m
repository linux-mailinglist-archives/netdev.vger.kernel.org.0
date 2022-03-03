Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17B24CC4E7
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbiCCSRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbiCCSRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:17:33 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773651A41EC
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:16:45 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 132so5246893pga.5
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 10:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m3R0BhiqPxOZEoq0u9oSqVsOJdu8BSFsUrtrIwkGaQ4=;
        b=oKtbaLz5QKuWnWU3PxkDEB15D3R1sAbAI5AD+CumwGA/Q1vUt+eLP1jT7rbBs7Tbwf
         vo2O76HmTqRsegBXV9pCE/EHF46ooDhm+y61Vc7lu0dP8d+W+Sd/G3tsMlppHKoQmyCC
         71USNrkq7EEFxxga+GOrIG+wtPqJRhGUZoSy5OXFn64clXho0+ZOkI4sFGuWg2ptMGFy
         M9UHnBkQRVhFN8apa+dcYQcJ1zLyHBqa7h1RN1NEAC/wP4FOBpxgVESdy3U9PIrkq1z3
         wnF/xWwceJ1IexaM5zYYOfIoSDM9J6+BrZltPgACXboz9H8qVZJiWsJ+KOR6F75lKeA0
         xa9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m3R0BhiqPxOZEoq0u9oSqVsOJdu8BSFsUrtrIwkGaQ4=;
        b=6C5l0MMb9TAbxkCpNgIIyvW1dL22QfSvBnfnhdcCmajsOVvr3U2KzyHkGtjhjbVh7n
         XPHuLaYAp48uq/2V8JT0dRAwtR2Zvp8xpScPyO+OrzdNKpNl7gEg/fMW0RXdOQs7M9TQ
         XFIzT6UZKonuE8XpjlqFLGrxPDFleEyTAA33q6gm/MeMP/agP9UHGDLq7O1NIKcPFaoQ
         g84dHZRP/lDuUk+vJcuGuammh0GHTyPWNXd996KvUkX2XuYC6U7yM32ApHtCUJzerRWL
         xfC5iHnebWZWsuK87qn76sANu/TwlAUKc6ubgFOW/L4jRpA6K4/tTCNBtt57si9khwOJ
         utLg==
X-Gm-Message-State: AOAM531cFWm8APLSTp2n/Nqpg/nBGXqGN3OaX7zPYfWqabrZkkUAZ5do
        xyZ2mumNjaEYYkNBzz+e1eE=
X-Google-Smtp-Source: ABdhPJwmFeTdz1zJLdRSLA1+3IgLc6hew4SKRtMMIV+hzx1LCfpZtnW/HIvS4SNsPY2ojv07w2ASaA==
X-Received: by 2002:a05:6a00:23d4:b0:4c9:f1b6:8e97 with SMTP id g20-20020a056a0023d400b004c9f1b68e97mr39166470pfc.27.1646331404984;
        Thu, 03 Mar 2022 10:16:44 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5388:c313:5e37:a261])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090adb4e00b001bee5dd39basm7611016pjx.1.2022.03.03.10.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:16:44 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 09/14] net: loopback: enable BIG TCP packets
Date:   Thu,  3 Mar 2022 10:16:02 -0800
Message-Id: <20220303181607.1094358-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220303181607.1094358-1-eric.dumazet@gmail.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
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

Set the driver limit to 512 KB per TSO ipv6 packet.

This allows the admin/user to set a GSO ipv6 limit up to this value.

Tested:

ip link set dev lo gso_ipv6_max_size 200000
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
index 720394c0639b20a2fd6262e4ee9d5813c02802f1..9c21d18f0aa75a310ac600081b450f6312ff16fc 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -191,6 +191,8 @@ static void gen_lo_setup(struct net_device *dev,
 	dev->netdev_ops		= dev_ops;
 	dev->needs_free_netdev	= true;
 	dev->priv_destructor	= dev_destructor;
+
+	netif_set_tso_ipv6_max_size(dev, 512 * 1024);
 }
 
 /* The loopback device is special. There is only one instance
-- 
2.35.1.616.g0bdcbb4464-goog

