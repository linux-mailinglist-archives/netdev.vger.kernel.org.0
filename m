Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0774A7D97
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348912AbiBCBwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348913AbiBCBwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:52:11 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2659C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:52:11 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y17so868087plg.7
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YJi20HQbzfm86dsWjXJgpren2dWXrhVIdEL3wMBAbck=;
        b=CI9FD18VJ6wEKoiquYLUYWEHWra4NMRh3HeQQ0sV2U+dRCUNlaKfIVtIpA528CyRuq
         58VW8inGCW/Ip+IE6Gdd3Bgqmy0Sj4O0yAtjKdf9Jl49qChFMvhPDS11e4uvmhSED/Vs
         71ltIR0D9b0HiZFF4bd4+wy6255gO3p8eFLVNEZGmxpexnmjMxI+BasiV/IHv9/tOEci
         hpP6Ef10OH6BDch91Gmyw2xVPO+U/H6ZNL37PTuL+uhTqztfnIwc22c+L7xsVNP7UfDW
         debKcFNXzqgMcxZvRIh4IAK7UcmF+xVEKVPQJYUXrVlssoeqmqZ8SrEezMelDVK6k2VQ
         xwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YJi20HQbzfm86dsWjXJgpren2dWXrhVIdEL3wMBAbck=;
        b=g1RxQQfFKm3h8tSzRZXPrToXDapsuY1MLaqtGct9C2Q/+2pKVjtYO0DyjwBwZPnDzz
         cIG2Qf9HGx/dtKop2ZRYISo6p5/GM7nzds0j93XHXCy9/hEKu1Jkwf+NIx8isqA1exV2
         tcq3w44EPNbNmt9CHVKyPJxepzDhlabj7h5+NvQ0vlEf/uBst9wFDQw5b4yahtmq5LN4
         +Hr0+ztdNUb+asExlfZVukHl7CuKRgYhfV/IEDk0nIfnCXXONPOs8RTqgMIH6uqN5UEj
         uQypcaQR6qmSRz4wE+BxRBVxPk2GDNAGFmfRIc28HLYapoI8nlXyKQLU0NnI231WsqlY
         Kszg==
X-Gm-Message-State: AOAM530itEHl+jKjbbWv+29yqop6dB7cTEqzECTAMWSUEYAZB3q46RNf
        tCXHbgMmDk23vJgprkRTWNQ=
X-Google-Smtp-Source: ABdhPJys+iStG+5xPRgtbPJn+DhZBQqYavhgjqTusNzQncizZYHTqK1oMK0dE6KSkBeS8RRdDjSh/A==
X-Received: by 2002:a17:903:124e:: with SMTP id u14mr34146902plh.57.1643853131367;
        Wed, 02 Feb 2022 17:52:11 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:52:11 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 10/15] net: loopback: enable BIG TCP packets
Date:   Wed,  2 Feb 2022 17:51:35 -0800
Message-Id: <20220203015140.3022854-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index ed0edf5884ef85bf49534ff85b7dca3d9c6aa3ab..0adb2eaaf6112d83ce067e49a4b62a28a67bfcf4 100644
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
2.35.0.rc2.247.g8bbb082509-goog

