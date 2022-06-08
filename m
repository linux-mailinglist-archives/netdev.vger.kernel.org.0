Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802C954385B
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245097AbiFHQE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245077AbiFHQEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:04:50 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A4727CD47
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:04:44 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id e66so19285080pgc.8
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZCkITjwU6+t7qKCD0kNZF73oF6jkTD3D32IscKNuK8s=;
        b=PICl5jzHxj29QCkg1nTQLSxnyB2qIPaUZxTd+gFaC1UULxznmKCuhJT9IY60q6k3VQ
         ON+EaKLYQqurOuuXf2yHKTKrqzwfwMg5ky9X1V0BVkrPyzcXZTaI+uXrFw8Z/WLnEYqb
         uAqT1fTh8stJa2AC+N7hRqZ697jLGvM/ntlLPTIx1zF1SxTNc2eSa507L3FsWcIvIDHo
         ezqS9YoViTFju2+3cGEgayuBt5adnT/kgxRMr2dw8SXz5h8LO7i4gUWZq5kbQqsSm+hS
         WjghCMi+aaryJuZjtZDzOJ44Fvmo/yf0zYPJCqsaRGyAsvYohHXB4aliygA2urav90P0
         pQeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZCkITjwU6+t7qKCD0kNZF73oF6jkTD3D32IscKNuK8s=;
        b=vZlHTWBvO2BS9r6fVEVsXOSTZUZ1oI7A47M16Dm61AE/thIqHJj+H5dLFRG7PDEKrk
         90G/AGzuormcrVXvSoMiKOei1bv+tJX/6toM4OFYPEsOIFu0KyxN5zQwqpHwkYbs6agC
         hEMXdkVLmu3uIiod9KTkpfj95rpRuPCpFIPYOBUDErIHhroDyuXY6wAtMZqcXNgfGKpO
         r7tFa8ayNWouuHi/bI/XCuMq3Zg7Razupm8efi4npbzkjJMgxzz82gn5qYmDXdNOyie+
         MeLhEILqAvsZejzC71i+YXWex/GFPE8W4CMnItzyE0K6IS2x0FSh5eptut9LZvczsUdy
         XYbQ==
X-Gm-Message-State: AOAM531Uht/kf93fKyOhJTCdl0CvSd8tQPzDWcAR61dI/dTIzIhVN7/1
        kYeFuw9U863Tt3mYfc5B0UU=
X-Google-Smtp-Source: ABdhPJx2i8ncNsNDhkhF6jQVdHVX7znlDqg6Pi1+vnY10pIgWBveR0olLKChOOU12RUiLgfwFU3z+Q==
X-Received: by 2002:a63:4514:0:b0:3fc:20d2:2e74 with SMTP id s20-20020a634514000000b003fc20d22e74mr30781347pga.623.1654704284278;
        Wed, 08 Jun 2022 09:04:44 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id ju10-20020a17090b20ca00b001df264610c4sm18622019pjb.0.2022.06.08.09.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:04:44 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 2/8] net: use DEBUG_NET_WARN_ON_ONCE() in dev_loopback_xmit()
Date:   Wed,  8 Jun 2022 09:04:32 -0700
Message-Id: <20220608160438.1342569-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220608160438.1342569-1-eric.dumazet@gmail.com>
References: <20220608160438.1342569-1-eric.dumazet@gmail.com>
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

One check in dev_loopback_xmit() has not caught issues
in the past.

Keep it for CONFIG_DEBUG_NET=y builds only.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 08ce317fcec89609f6f8e9335b3d9f57e813024d..27ad09ad80a4550097ce4d113719a558b5e2a811 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3925,7 +3925,7 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 	skb->pkt_type = PACKET_LOOPBACK;
 	if (skb->ip_summed == CHECKSUM_NONE)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
-	WARN_ON(!skb_dst(skb));
+	DEBUG_NET_WARN_ON_ONCE(!skb_dst(skb));
 	skb_dst_force(skb);
 	netif_rx(skb);
 	return 0;
-- 
2.36.1.255.ge46751e96f-goog

