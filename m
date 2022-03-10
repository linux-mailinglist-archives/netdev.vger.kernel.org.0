Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1FA4D40E5
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239669AbiCJFss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbiCJFsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:48:40 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFC212E15B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:47:26 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id o8so3838057pgf.9
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m3R0BhiqPxOZEoq0u9oSqVsOJdu8BSFsUrtrIwkGaQ4=;
        b=TBfw11vSot0Hi/7+ztT9sVNbY5catDW8bLxFdhEr4bwXID1RHyhEKEd3g9+2J3O+3n
         U9FEJ5AC6vcm6hkkS64/rvjyxXekfrn5rrvNbrDY8GHbRDrHFzaGbZaQwGg20Vg9q1ae
         YD6Iddt7RgmWHMqa8jV5kQ6u8yqdsPRFJXG1UEwPp4g5pdx97D4OMx1efyNLMr3Ej+YJ
         Bd1sv3j1sGYay7DnQj1XHI+aHlrquLgLiuukXEOAsZSdHrV9dVRIMZa0ToZBdhV8q3j7
         XnOZB/COrwFIybZjt4cJ0QUiTC349N2IFi/Cx7vTPDdPVyw8H+Nmud6kqpX+I5Lzwvdw
         nu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m3R0BhiqPxOZEoq0u9oSqVsOJdu8BSFsUrtrIwkGaQ4=;
        b=eayJJci7DtkrUO5O3ix51FzIqTOcGfgMQtuibBotZWNLrkDceMWnHFuuL2Q/i1mGHE
         HBkQrCKDqBWinbw+mOd1hqXtoEz4x84ncw288j4DqWRDTbargO1rIt0U+MJFJ5uYlxv+
         yf0u/KSEjuaRPXhNX4yHqIHNqKIDaceM3vav1i63G+ZVCiBU4llkzjNFuQVQzunoLXLc
         EgKjz+rpVHT3roa+1KdJZonl+5tkMPi2coRdZAZXaXl5yOevNcG+5X+aDKJl6/jeMQyc
         p5Ce8D0ZvOTfZosrmhnUOslsJX+zao9jCbBhgs8iK3Tr4q65xHGjxl2AfExLge6qqS9R
         cceQ==
X-Gm-Message-State: AOAM532gQcjQZEvnBy/kiuNag513fQZALprVvvCVA071TeY8x/oa7OH3
        FVQFWqLnIrbTCHjw4SeV1Jk=
X-Google-Smtp-Source: ABdhPJxUVT4/zlEQUKZgRghRIX7QXByTYt0mfxeLpiCly0BJ1Rqb0+kdEZH7tONOGgtx0xBMuNy7zQ==
X-Received: by 2002:aa7:9730:0:b0:4f6:d6ee:cc0b with SMTP id k16-20020aa79730000000b004f6d6eecc0bmr3340200pfg.41.1646891245940;
        Wed, 09 Mar 2022 21:47:25 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5270779pfm.200.2022.03.09.21.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:47:25 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 09/14] net: loopback: enable BIG TCP packets
Date:   Wed,  9 Mar 2022 21:46:58 -0800
Message-Id: <20220310054703.849899-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310054703.849899-1-eric.dumazet@gmail.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
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

