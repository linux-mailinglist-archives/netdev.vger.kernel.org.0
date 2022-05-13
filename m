Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE0B52696F
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383360AbiEMSfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383367AbiEMSek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:34:40 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C4D60D9A
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:31 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x88so8807312pjj.1
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KbbhY5BKARAvD4diE5tyU0mGE5QRYDGuqRe9K9Kja0I=;
        b=hPUFFAE2K0ce0VuH8Hjlh6oUvvK9Nj7HUA6mOV0ji1jPJXb3wgynfu4g30QLt1hPtd
         tYguYHNR1MoitG4PPvhrkP6RCNWDtbTE1L+2ispIAzmE3sjn5Ojur8MqBKndQl5JGzVE
         +fp9136Q12Qf3XdYVjagF/W3R6uxchPZyym7pkWyR81Hy9sjvI+O78FSxO79ggvTDbjl
         T4ctAFYrEyDysmiWzt51Ii9QV468HxLrszWIuxJ7tnIGYnJOz8cpJUf37Q2obvbRgR24
         kkRiP99Xhi/MXSbkeqWD3sXEcxRZjRul1D9gBTSntvxJDG+nVFJJIKxs9eLMEIOxcS7p
         oQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KbbhY5BKARAvD4diE5tyU0mGE5QRYDGuqRe9K9Kja0I=;
        b=VPoWCehsqM91CNPJznz69wGVUVKn1jB8J/dUCl2talBGZSQGwugGzjeDjfewoHd2S2
         /221tWyFIqD4BvINJ3I1pNIZatiCuKSXLfuSUDoKxBsiCg2PevHc3D2Xz9UkGrN8jc65
         tdb34342EC0FV1EIFiyohzEKE7LeCHKfIcGjuojo5OxKQxV14/TmYBS0nh2HMVZ/elsa
         S93fCO0cyl7lgFVhf8AoDvEO8dW/j+uvk+cD4d5FQ9uv4NAyyzCLJpiv79pN3PVjGB6V
         BwkbkLH1jXJYeor9CA88DS/phjUN7R8uQYR/v2F4ye72a4Bi0CMbVZCgmh7EbXjGZPsY
         QfUg==
X-Gm-Message-State: AOAM533vKfOfLMTrsHP2smij6iFzoAQ1CnirUOeO67gV3QAtvf11Hvls
        3FGyz5C9dL5G3zHYEoh6hFw=
X-Google-Smtp-Source: ABdhPJwIoidmz7NpmODGp/PQHVcGYU8ugLCkIAmY+M/jI+Fsp9Fnpeh3P7W+cY1R95lZ275dHkX0kg==
X-Received: by 2002:a17:902:a516:b0:15f:309f:7805 with SMTP id s22-20020a170902a51600b0015f309f7805mr6052835plq.114.1652466871235;
        Fri, 13 May 2022 11:34:31 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7842d000000b0050dc76281cesm2053566pfn.168.2022.05.13.11.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:34:30 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v7 net-next 11/13] veth: enable BIG TCP packets
Date:   Fri, 13 May 2022 11:34:06 -0700
Message-Id: <20220513183408.686447-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513183408.686447-1-eric.dumazet@gmail.com>
References: <20220513183408.686447-1-eric.dumazet@gmail.com>
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

Set the TSO driver limit to GSO_MAX_SIZE (512 KB).

This allows the admin/user to set a GSO limit up to this value.

ip link set dev veth10 gso_max_size 200000

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/veth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index f474e79a774580e4cb67da44b5f0c796c3ce8abb..466da01ba2e3e97ba9eb16586b6d5d9f092b3d76 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1647,6 +1647,7 @@ static void veth_setup(struct net_device *dev)
 	dev->hw_features = VETH_FEATURES;
 	dev->hw_enc_features = VETH_FEATURES;
 	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
+	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 }
 
 /*
-- 
2.36.0.550.gb090851708-goog

