Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033E14CC4EA
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbiCCSSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiCCSRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:17:40 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734091A39D1
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:16:53 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id z2so5325791plg.8
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 10:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=34jEWn3KlsSJ9jeDwhLaeV4mw//NGL1b1oh39nIT+68=;
        b=O+nMG8a/fbwkaYmsA9XfR6a1yR4ds21kWx70i5Fs2DPkxd0SLxgGMVo+K/9JLL1I+p
         0WIZmcVaEra0T+tRXrI4sSB9WL/GURRlOFLN+uxPchSo8ISgbeuG1wKFfBdR+Mtkyxwh
         WXwTNrou8PrVZeVW4X1BedjLwPf2awcvt7Ly8apfdd3d9l5Xd0WzKjOVgKCUs6nf51yV
         +IOu3UXpjTHB7K+Z+7//0YJtJ0fpOEpbHnrfUJM4TQjATNm8k49NTP5FNmQiU4B0gEOz
         lR0gs+UJKIWc47uu2kwehUXHEyMMUVuc+GDsmJIjD8q1Rdi6TbYkz9fI4www1PtsSFl4
         G2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=34jEWn3KlsSJ9jeDwhLaeV4mw//NGL1b1oh39nIT+68=;
        b=B4KuTtkZEdVCWltGENw3zZgTx55aPl8CMXfPqO+lLGWDuVmBy/K0vzbeDvsPMHgIKD
         WLHoHXLBIA9FDAwU55lKsU6Y8t2YGC6J7wyqC2iNZje+p8eHtUFop2yEOvAvj2EuwccV
         CzbqTRLnVgI+mtnQu4rf4BDehwWf30mLtyz93wode0fTSNuDhKYobbcdly0nQFpDPRAl
         hJPNntFFYLLfWeiiB8vFJodi4hVIm0pOSXvEAWCPXjAVoIdvBaYDPrvACqA/t1Z3TBX1
         omIUgK93k28ThVlydS3LXgBDkXVKmH+lj/BskZoBiY/nwpRyk4kEEuczVK0lLQ+a13tB
         4a9Q==
X-Gm-Message-State: AOAM531tqv6hU5Yc+UEAP1AtoTMm9ljtgcH7uh2ha9aTFugJwM3l0T0i
        Mv3m9DOy3n1WKqHFTJ7xCbA=
X-Google-Smtp-Source: ABdhPJx/XuLoO+3Q+l/yNxZALhVnQi3ypTl6XV6Y9kDc1UX62roGZDoE3/eQhz3IOCvGnc9cTB6FuQ==
X-Received: by 2002:a17:902:e742:b0:14f:fd2f:c8bb with SMTP id p2-20020a170902e74200b0014ffd2fc8bbmr36467487plf.43.1646331412999;
        Thu, 03 Mar 2022 10:16:52 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5388:c313:5e37:a261])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090adb4e00b001bee5dd39basm7611016pjx.1.2022.03.03.10.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:16:52 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 12/14] ipvlan: enable BIG TCP Packets
Date:   Thu,  3 Mar 2022 10:16:05 -0800
Message-Id: <20220303181607.1094358-13-eric.dumazet@gmail.com>
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

From: Coco Li <lixiaoyan@google.com>

Inherit tso_ipv6_max_size from physical device.

Tested:

eth0 tso_ipv6_max_size is set to 524288

ip link add link eth0 name ipvl1 type ipvlan
ip -d link show ipvl1
10: ipvl1@eth0:...
	ipvlan  mode l3 bridge addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 gro_max_size 65536 gso_ipv6_max_size 65535 tso_ipv6_max_size 524288 gro_ipv6_max_size 65536

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ipvlan/ipvlan_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 696e245f6d009d4d5d4a9c3523e4aa1e5d0f8bb6..4de30df25f19b32a78a06d18c99e94662307b7fb 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -141,6 +141,7 @@ static int ipvlan_init(struct net_device *dev)
 	dev->hw_enc_features |= dev->features;
 	netif_set_gso_max_size(dev, phy_dev->gso_max_size);
 	netif_set_gso_max_segs(dev, phy_dev->gso_max_segs);
+	netif_set_tso_ipv6_max_size(dev, phy_dev->tso_ipv6_max_size);
 	dev->hard_header_len = phy_dev->hard_header_len;
 
 	netdev_lockdep_set_classes(dev);
-- 
2.35.1.616.g0bdcbb4464-goog

