Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02D152078B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiEIW0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiEIW0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:26:08 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C3616D130
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:22:13 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so512605pjv.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p3Dsd59N+6kEn6Kc3V/BT0dF8qv2VGnxNUcT+/bT0K8=;
        b=j4OppxFueBYyvHwTfnJ8eG0itTC/XAooEsnyfHal4ORIuDpsTVfSwdyNGNl310jJHS
         TvxpykrO4jbjpTauhaMSjReE4U2dDr/KSCI9zeRaOKMXZAR74geAglDiO+iJp6Lir1+q
         tlrvClpm3Il7vCA5mcZbbDUXX/Fmd0zZnYrSLm4A4cX3D00KzW4cCSkq+ZGWZFAWyQJ6
         Ygj8Jjc1yF/DlDUU7LDzYyZzlWHYSaU5rUSZhhHoO11aXj9Boz65VZRz5BUuOQYPetIx
         bDCowRC+ylJTRbSphmd+q0R3L/xKljPDQrgs4oAceae6f28duxd07COghslfeVLTkQt4
         qWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p3Dsd59N+6kEn6Kc3V/BT0dF8qv2VGnxNUcT+/bT0K8=;
        b=KYglUyM8ZdtD4xTHVzIrelQI/A9eNmaBE48Y61+wz7rocwDBoWcI/RcQdXuidiZKY4
         4GzZkaoVZ8z9334R0ps+2qEO+GpIq2/ua5VTkXh1bKThUj0vf9GJSksjeVB0MwhNXUok
         VK4XiiTqanpsWZZF/A0zwHgr9Yh7M2nYdImKxK9hkTI50WnDa/PdrwUEEKXPF8u3i/MZ
         9sdZnoN0CTNxkajX+Bnbakn7L3hJjeic9MpkgQFNnv7dwkVtf70/9MMqhXwAudX0rWxR
         QA+jkioSDU3IBMRH7/ocdIX85BFJLVblCE87WGV3rkiedvZ1iOTgWNn1H5TqK9zwOCC8
         XPlQ==
X-Gm-Message-State: AOAM532H34FeMWjSMzkYY1qv+UIUXiMQhAc+vTarxXuJRPlGEc07i2Tz
        iHPhzaUnwcIUMwZCD6Z9ccY=
X-Google-Smtp-Source: ABdhPJx/HSXZZ0BjLFs2whUTjY8bpg/VRG6zCIZl3d2m3j/9fxcXubrV2sp8+qj80hrlsy5aFpOjbQ==
X-Received: by 2002:a17:90b:4f43:b0:1dc:c1f1:59c9 with SMTP id pj3-20020a17090b4f4300b001dcc1f159c9mr19802288pjb.183.1652134932733;
        Mon, 09 May 2022 15:22:12 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b0015e8d4eb1efsm395823pla.57.2022.05.09.15.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:22:12 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v5 net-next 11/13] veth: enable BIG TCP packets
Date:   Mon,  9 May 2022 15:21:47 -0700
Message-Id: <20220509222149.1763877-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509222149.1763877-1-eric.dumazet@gmail.com>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
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
2.36.0.512.ge40c2bad7a-goog

