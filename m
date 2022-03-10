Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC8B4D3E24
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239031AbiCJAaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239010AbiCJAaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:30:09 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD71412551E
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:29:08 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id q19so3334648pgm.6
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 16:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m3R0BhiqPxOZEoq0u9oSqVsOJdu8BSFsUrtrIwkGaQ4=;
        b=PiHaWL2Z7Ii/ZlXjTFY2fEmQ7kaOLaOshSuRYMEwmekU8x3VPynq+lIlJOQX7XIyc/
         XKuYYZdEa3QSNVT+PMHBsPU8M+eenYuFoMvY9cFxxN0yZvAeAOTCs/EaiwubslXcHe7u
         nrJdWjtQABr1xD0VEenNC4JXZjGh1dz3XsnU01H3QsOg40RDONSIYKAKTvphv+y1veQp
         B4hQ+lpmOjdJO3C66K0J6CMhmY32St4OPa/wWfGBDAFj0VY6DYOUM4c2ixEulidQtYYK
         n/crF7s65lhS6MCwzfnn7GqhBSNCFyIFnhxWL9zFMFAOuNtGqubkgR/7L6pFHaOI8p7s
         jlFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m3R0BhiqPxOZEoq0u9oSqVsOJdu8BSFsUrtrIwkGaQ4=;
        b=fO0tk+42KdEkOX+rkcW0hDbhoUcYhlr1l9zowIl0cJ5C7teacuFmmErqJKG0984+2x
         fUCVvOL5/FTUU5SjopMbaaSIebD8v9vfgTA4qY/pfvNAcpPgKmkv+oSFVR2HzN9fPVRa
         dy0UqcsJlAqDcAUpZspqt0d/fn6GFmVkewiIvJO5pp/JnsPbok+lOOFJ6xuJqdGGk6vB
         OsMqtV2YSyr6jWOrWe1GaNjx0uPWJb1SWXDOcXGtMBFwyan42vljzs3UHK61/GoToAqX
         pwnOi7NlwzggPzrn2imvHmGEUtQWa+2upSm2AGT8odzYgeKgJA529qHcRR8pmwsRCBKi
         6noA==
X-Gm-Message-State: AOAM531V+qcqdm4mxpI95Zcloc+F4z4QI/MFMUjEot7rWKRuILUSz1G7
        9kBLz/xhTQ0lapvlYiCOfaI=
X-Google-Smtp-Source: ABdhPJzJ7HqekbKSCYUd+Uz2J9U7oYkNHGCtxJC4NiYHZSkpk2vbnkw0n4wGv0cuEfgLhotc1sO8Xg==
X-Received: by 2002:a63:6a41:0:b0:37c:7a6e:e7a3 with SMTP id f62-20020a636a41000000b0037c7a6ee7a3mr1827286pgc.528.1646872148202;
        Wed, 09 Mar 2022 16:29:08 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id nv4-20020a17090b1b4400b001bf64a39579sm7557660pjb.4.2022.03.09.16.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:29:07 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v3 net-next 09/14] net: loopback: enable BIG TCP packets
Date:   Wed,  9 Mar 2022 16:28:41 -0800
Message-Id: <20220310002846.460907-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310002846.460907-1-eric.dumazet@gmail.com>
References: <20220310002846.460907-1-eric.dumazet@gmail.com>
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

