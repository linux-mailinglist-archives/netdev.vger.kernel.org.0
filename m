Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4804D3E26
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239042AbiCJAaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238993AbiCJAaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:30:11 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BED124C2B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:29:12 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 6so3379101pgg.0
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 16:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gtAHZRigkzO4a1Jgu5OwYx4SbI+nNslUCVxlgRRzKWg=;
        b=dAHKTLTZyot91o58QksLS0Wh1MqV1IXD33IMs7LXkj44BH0wwOdOVbmWNgSR4pJwUO
         M3Uc1enWZtUKv1ClQIQGyrkYPj4jAU3xFOA8uGSCtEUrLrnM0U2uWeoF0tXB2T7WU61m
         XulqcSR0a2IsBlasCAQlaJRLps6HuUFQdvMKIkHG4Mdl4KQqFxaxMb8y0zzMtd4NZrtr
         gqnTnvixQeuhNlrJKs6r92UPxQ2h1hLOT0mtmylAREc9apv/DZSdph09rycVyNSeoLiZ
         E3cCamkfoghj8vSNgniwaoiktWWaJ1zxrq7Zcx6KJ0l4WAGofumjs1skP3ET3FpK//Yi
         v0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gtAHZRigkzO4a1Jgu5OwYx4SbI+nNslUCVxlgRRzKWg=;
        b=n53O4BRBuFH4Dl1RUJqKwIUgGq1aH3Ekmce4PZMIaM9QAdPum/gPsr/8Gu0vL9Vvlt
         /UhhLAQgs04uQ4CLIIRh6VLxaQqRy86+Jp66QBMmYIcvIJ+NuFmaj6poqs8rkHStZ22s
         iCEM4ulHaSf62DA13qfWlAFCgbLVjAkvlJ7mR1p+pQiexonXLUhTwDWIGOvcH5QyikLZ
         hmCkSzyCra1nt+DqE0bbzhjJ/IqbzvszPHeQP0gZ5PblKzA8zJ8lHCN2Ev75S06RLx29
         fqZ6II4dpISf9txklwrgu07hNO98g5ebSHOEQ8/rEygxLBBiKuU3662XxeZ8Gy1tarPt
         Mz2g==
X-Gm-Message-State: AOAM531em/IutDmhWzfiKGM6xHG9Hl3Q4xbC955gujPZIXS8PwLShpwl
        l4VmUIaiHArUHuQ3iHOl6ij9VirA7ws=
X-Google-Smtp-Source: ABdhPJxpu/TwK25HJICZkW1v/Ko7fHgD1ohv69k2wPYuGR/1miqjP4uqURoWOb884Ej8y7L3VLp5tA==
X-Received: by 2002:a05:6a00:b52:b0:4f6:d3b4:9323 with SMTP id p18-20020a056a000b5200b004f6d3b49323mr2352368pfo.30.1646872152207;
        Wed, 09 Mar 2022 16:29:12 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id nv4-20020a17090b1b4400b001bf64a39579sm7557660pjb.4.2022.03.09.16.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:29:11 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v3 net-next 11/14] macvlan: enable BIG TCP Packets
Date:   Wed,  9 Mar 2022 16:28:43 -0800
Message-Id: <20220310002846.460907-12-eric.dumazet@gmail.com>
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

Inherit tso_ipv6_max_size from lower device.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/macvlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 33753a2fde292f8f415eefe957d09be5db1c4d55..0a41228d4efabb6bcd36bc954cecb9fe3626b63a 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -902,6 +902,7 @@ static int macvlan_init(struct net_device *dev)
 	dev->hw_enc_features    |= dev->features;
 	netif_set_gso_max_size(dev, lowerdev->gso_max_size);
 	netif_set_gso_max_segs(dev, lowerdev->gso_max_segs);
+	netif_set_tso_ipv6_max_size(dev, lowerdev->tso_ipv6_max_size);
 	dev->hard_header_len	= lowerdev->hard_header_len;
 	macvlan_set_lockdep_class(dev);
 
-- 
2.35.1.616.g0bdcbb4464-goog

