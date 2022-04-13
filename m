Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2594FF53B
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbiDMKzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235049AbiDMKyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:54:54 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C4559A4A
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:33 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id c64so1835291edf.11
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8mqGi6nmRQtdTy+PDFk54YLdSIt8nb+5grez+iJIyIQ=;
        b=QHcMActsk48o/Ali36FVmGtylPwMSvJWtiSShrN1MSayZJSwLjSyNfvMr1a/CihU8/
         2aXGBVDTXJEhEfHtDrgXEk+QpsK2Cx4T4Hormg5IXfa5i7gjdzWnri3JQwscS/gVMcnD
         GGGvjmMqLSPo9vTCpDa9ve0rNHD4LZGUAEHGtRNMmAea5QAlDDGTDAzsmRMUjIOB6DU5
         HfEpjDEkLhD2p344keqn11DJkh51F/QHmYJ+Rj2XzRvBqwshtROJqFzcgM1CCWSJwSkp
         /F8UPaDME5EQHHfpDQcjPBzB3OZPNe5tcA09tTNzqcAdjmyD+auXM0JHVM6KTLqSS/QB
         FT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8mqGi6nmRQtdTy+PDFk54YLdSIt8nb+5grez+iJIyIQ=;
        b=BWpVMHLFzlotzwCez7Zp8WsHb3Wgv0BmUQpBy3oB4CVLuSYLLAO2GeOkn2YFyN+0CK
         Jgc3V7PoZXzs0vJJKM24rPU6cw+nBluSHDJ0GKQhzHCJC/la1KuR83TmhdRWJi+8IO+c
         +u+iRSLzRtYLYGAJBLNs50t11XyBxcsi8wTsAr0lRU6NSjv2DXkylIC3qmNS3bl4kVfs
         vOP5q35+2KIrI53s8GkGPpfKuNuldT6M0S16ZOoQ7gEUdoIZJ3GN7Aziasj78LfoK16O
         Dzg8uOOcKheV5mhDx6sqNzaw6cFQ1wpw7iXP+ChEeCHNAn3Njhi213O/MjRIiMQhS8a3
         ikaQ==
X-Gm-Message-State: AOAM533oBN5CKxvYdfk+OlQrmGS+27QLivaxIV5IQwByBQuMEwQ3InPi
        G74uxKm863g456WQ6VYhb42JsouOtsP5B33i
X-Google-Smtp-Source: ABdhPJwxlSGuLnyxI31hE+7V+fuhmPjhJYodVVueVT7xa/NWY1ZvwnY+NcgZckh1odvmfBV7RIX8rQ==
X-Received: by 2002:a50:cd8c:0:b0:41c:bb5a:1c7b with SMTP id p12-20020a50cd8c000000b0041cbb5a1c7bmr42273201edi.351.1649847151603;
        Wed, 13 Apr 2022 03:52:31 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id v8-20020a1709063bc800b006e898cfd926sm2960952ejf.134.2022.04.13.03.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 03:52:31 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v4 10/12] net: rtnetlink: add ndm flags and state mask attributes
Date:   Wed, 13 Apr 2022 13:52:00 +0300
Message-Id: <20220413105202.2616106-11-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413105202.2616106-1-razor@blackwall.org>
References: <20220413105202.2616106-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ndm flags/state masks which will be used for bulk delete filtering.
All of these are used by the bridge and vxlan drivers. Also minimal attr
policy validation is added, it is up to ndo_fdb_del_bulk implementers to
further validate them.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/neighbour.h | 2 ++
 net/core/rtnetlink.c           | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index db05fb55055e..39c565e460c7 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -32,6 +32,8 @@ enum {
 	NDA_NH_ID,
 	NDA_FDB_EXT_ATTRS,
 	NDA_FLAGS_EXT,
+	NDA_NDM_STATE_MASK,
+	NDA_NDM_FLAGS_MASK,
 	__NDA_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 520d50fcaaea..ab7fb9a16da9 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4172,6 +4172,8 @@ EXPORT_SYMBOL(ndo_dflt_fdb_del);
 static const struct nla_policy fdb_del_bulk_policy[NDA_MAX + 1] = {
 	[NDA_VLAN]	= { .type = NLA_U16 },
 	[NDA_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
+	[NDA_NDM_STATE_MASK]	= { .type = NLA_U16  },
+	[NDA_NDM_FLAGS_MASK]	= { .type = NLA_U8 },
 };
 
 static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
-- 
2.35.1

