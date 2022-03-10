Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8125A4D40EC
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239675AbiCJFsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239674AbiCJFsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:48:41 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098D125E85
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:47:32 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id e3so4157506pjm.5
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=34jEWn3KlsSJ9jeDwhLaeV4mw//NGL1b1oh39nIT+68=;
        b=HSFju2DIjxuFBSl+u4Rc/cC0pBMAXqdgdPgQ/NNJ7pqYz0wzWPGHtODWrZBcG/SoiH
         T1bHNNWFLDalnNd4s0N7cPC4s38pG/eNyk/wg5F8PuPne07TaI/ugayP7TpDRPm4TK24
         EvOht/HY4PGPwxAGBgbjko3wr+eh6pY6+r3OfBE8paXVDee33Aua1o7GWPTszskEerW7
         4MeSdtGyJglUzI8nxWCvX/CKEXUZDo3p7M2FBAvZyVUX2Gf4O6ZUNsWgMh7z092mgpGe
         bKlfQv3gu1IOyVYx709PcEzPHUegY/wr2hEpOLkM+Eib8YVY1FKpWltjg76cUnJoXZwB
         fa8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=34jEWn3KlsSJ9jeDwhLaeV4mw//NGL1b1oh39nIT+68=;
        b=PMuSj+1FTDAxRskREC3EyRSD74pmlrpVV3w7Y2h2eVNlidQ1Xv2erR3atq4UxeOMH3
         CaF7AlEV2HQtqbtb98uZ0qLMUyS8JhgebWhS3+xU1AxeR/BCIG1DF+8o5UKksft8Bcox
         vaKJUnIVn9WYGTpHa4nF/QS8532LoIJUs/C7wuRYssiPXnHSFRhYnYSVa9LSNM1IjFsa
         7mwjtCptVmydzQpV7WuHH3i7nP4n0Vj/pYH37XjYaAcll2e+/aO7lzjfVXPmz3EjFbgn
         RsswVAZGVSNb3P+gczPCG4WLHGHtATgwMpXh8QEARgIqWsT5nz4AEMBhTmetvRmyBqU8
         mTxw==
X-Gm-Message-State: AOAM532632d5WmztLTL5XdaIpz1HYcAy2Pjxb39FcIzZtx3DHs8rz/kX
        mgSWQe/BosNTe42ya5Q68BY=
X-Google-Smtp-Source: ABdhPJxWgpmE8m45RPMFv5vX7pJVtnyfOR/SkqcM7PohfX5VWYyo7Np8JNROAoCk958poflcgOCBqA==
X-Received: by 2002:a17:903:2345:b0:153:1b5:6834 with SMTP id c5-20020a170903234500b0015301b56834mr3348151plh.123.1646891251620;
        Wed, 09 Mar 2022 21:47:31 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5270779pfm.200.2022.03.09.21.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:47:31 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 12/14] ipvlan: enable BIG TCP Packets
Date:   Wed,  9 Mar 2022 21:47:01 -0800
Message-Id: <20220310054703.849899-13-eric.dumazet@gmail.com>
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

