Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E3654049A
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345250AbiFGRRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235464AbiFGRRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:17:46 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9617F4E3BF
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:17:44 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a10so16188173pju.3
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZCkITjwU6+t7qKCD0kNZF73oF6jkTD3D32IscKNuK8s=;
        b=hE8e4eg3Ul9USMOJgPwPZlw7AHAFJaOJr5m/SvRPFvFN/h3u8ELhDkybuWOXa/2hws
         K5jiY7zTJ6s8nqeGbCsZkzTFZFV2SS10kfqmb03nSgka1VFw9Xk/7V1xNiOk0dOUH72d
         3skuHiF8ER+gijxRBu7xIb2FBvQMPyHQripPYcGAplLzyoXFfFDIVgwCOJ0T669hGrJV
         EnOGQtmVmXol2MfzzIk7M/hsUnWDl4ddF0ZR4+zl+M5IlvVvkeMX3ZCgE/2oFn2u8sBs
         3MGmHRHwn7CXLh7Rny32/wV9pHlofAhUXuVEqhh/nwPdab2M/Ge78cxAQ/lBgFBejs7p
         LGHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZCkITjwU6+t7qKCD0kNZF73oF6jkTD3D32IscKNuK8s=;
        b=SAoVN6T5eTZVpZGWSrarTM7HO7Bv+RZnCR0Iov6fonmhwffXiBUcy+Np0ZkCkLDPcf
         wHPFdTjzOkShl0M+zO/mTKsro8NYRMi3gda7FTIZCqGgew9FBc9eSWf0xMbF+wzahtZ8
         DOuQOfxNBwCC77A3CH0Cfxn6rshljW9vHBhAw1+fYlzYR4Lr/SLHQ6rUNqxLf/63NRLs
         8EHpMAjZm6cr5JnzXDg4TWxhsLDIygR1YrTNswoOSDMmPfALjZ6Ga5FBoZmCU21DNo1t
         /zdNMEWzk404cwalAGsgcgtpayvMOarKe8GjYTB3a5Mbi+7MaLLfYgzI7oj0JhXpg8tf
         afDQ==
X-Gm-Message-State: AOAM5305oECiPiDce3G0F450+rhT7Xo8Eo94bBaMcU2a+XGDEiqF9zFU
        2lhby4rPJyjoLsOzJE+i5xA=
X-Google-Smtp-Source: ABdhPJxfnLVC+u3HWvkv2AjVeqiY+vV3LvaP9l99oF7xNikzWhG7/SvUegmNeshUOPA6tkjPS9Gz4Q==
X-Received: by 2002:a17:902:d5ce:b0:167:6c02:754c with SMTP id g14-20020a170902d5ce00b001676c02754cmr15621237plh.135.1654622264134;
        Tue, 07 Jun 2022 10:17:44 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id d4-20020a621d04000000b0051b930b7bbesm13001616pfd.135.2022.06.07.10.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 10:17:43 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/8] net: use DEBUG_NET_WARN_ON_ONCE() in dev_loopback_xmit()
Date:   Tue,  7 Jun 2022 10:17:26 -0700
Message-Id: <20220607171732.21191-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220607171732.21191-1-eric.dumazet@gmail.com>
References: <20220607171732.21191-1-eric.dumazet@gmail.com>
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

