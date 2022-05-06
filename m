Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D74C51DC33
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 17:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346346AbiEFPf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 11:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442941AbiEFPfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 11:35:30 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB53A6D397
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 08:31:22 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p6so7334972pjm.1
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 08:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/P9EWKSxN2uCXkVodpKaHqSst+cMbWDBm9KaQ/M+xK8=;
        b=TOonhpbWODRKCjtHXI++ZqipYfxS00shKPb04NrNXXWvgjy3rTJYBegCjhhLMyAIFp
         /PvLUTUOBVOsqNhyBskQ4evyGGTEsAQTSExEMShKM7R3TIE6gOj2wsV7tY6AYsKLUxkY
         MSkj7DkxgqcdabNUi81eignY3Uy7dcDYo8jOESh/7CGhN8BJnh1hQiee10jz33TLaF9B
         /MowMLwG03bkrpniuv/n2r44dRCrAEdoFOIP5X3JojT76MowYGnYQLRKrBTLEJRF/ocY
         WVyVVaQRA4B75dAV0+4hm0Gfn7AoPs6kwQ33G2J4EHvQSGsc3W4k5UcOPhuClqWRvCqU
         jK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/P9EWKSxN2uCXkVodpKaHqSst+cMbWDBm9KaQ/M+xK8=;
        b=dPjoOJBRKHOm/j9Uzwvx6chold4kC+WkY8rPXg9DfwPOiAaEu8TSjNLvc+NzaoOE4N
         cIQCgX5aSqwQ2vBvyiphWkc/+WLRoucuVZ1tmG5dzgs2Uql4QZ2D2p09Z9ViHazlm60W
         WgtDrWHStj9BYAZHWXjqhy51ozFhKz1qUM+YGxULvMjinPXSD076ky/7wL74nj7XU8rx
         1VdqiUnG8dEfKba52+0ShX53cTnut+18vIJrK242ufcmpD7Xr8P2oYE2W3t76rJoptEb
         SOScr3habAICkFk71jHHkQ0uc5Z+3f0oxCSHVdaYNCPtoFZXa8Ktd1TLk9PozRszbLwT
         BJTA==
X-Gm-Message-State: AOAM533L+GBXzt/+BVxff/d0MlNiCQixzHcxbGp3SfSw9SZNYAGdy11y
        TbMZ6vGbgxuul3H7YmxBdx0=
X-Google-Smtp-Source: ABdhPJxOr+r7UUWXXdqgmZbRIWTCPD1mM3ksalB9WQ9vOlTVqANHMBkrrxflD7bkZ44p3PAqybWiZQ==
X-Received: by 2002:a17:902:d2d1:b0:15e:9b06:28b3 with SMTP id n17-20020a170902d2d100b0015e9b0628b3mr4284761plc.148.1651851082514;
        Fri, 06 May 2022 08:31:22 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:709e:d3d8:321b:df52])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902d70400b0015e8d4eb1bfsm1918612ply.9.2022.05.06.08.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:31:22 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 10/12] veth: enable BIG TCP packets
Date:   Fri,  6 May 2022 08:30:46 -0700
Message-Id: <20220506153048.3695721-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220506153048.3695721-1-eric.dumazet@gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
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

ip link set dev veth10 gso_ipv6_max_size 200000

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/veth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index f474e79a774580e4cb67da44b5f0c796c3ce8abb..989248b0f0c64349494a54735bb5abac66a42a93 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1647,6 +1647,7 @@ static void veth_setup(struct net_device *dev)
 	dev->hw_features = VETH_FEATURES;
 	dev->hw_enc_features = VETH_FEATURES;
 	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
+	netif_set_tso_max_size(dev, 512 * 1024);
 }
 
 /*
-- 
2.36.0.512.ge40c2bad7a-goog

