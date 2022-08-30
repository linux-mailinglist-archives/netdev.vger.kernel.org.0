Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0A95A69C8
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 19:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbiH3RWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 13:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiH3RWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 13:22:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C893BE1A9A;
        Tue, 30 Aug 2022 10:20:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E10996177A;
        Tue, 30 Aug 2022 17:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03172C433C1;
        Tue, 30 Aug 2022 17:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880039;
        bh=g+P08BfSsgdySgNRNWUPK6wH+vVCcn/SW9pXz0emGpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OC8IVAxhsX8VT8xRBdeSFG1STEoO+rFiTq2UYdzRUTVoq2pqGj+H7xxMUx61IsOIY
         SLXTi8P6zwrluUJwmDgHZVEmnlWAExygR3PQVbeskHE104GWX+Axi0yZZoX5yAKmX6
         Vru3HjO+50s0RWspL2tdlOJpaVM4uF8pL9V/8BNaG3OYMmIUsBzXynGXdXFi/S4bMt
         z6ZxdtoTqx1ah5jR+51LBvBrLmdQAPZVQZpf9di4VyKhDaHLvyNPWKpVY9AAPqJfpa
         SVok9aTxQu5ndDbNXx8jbrHfUXpw9dCePVuerC9khf50hnJTvbaqqBt7F39TkYNNhC
         4RZFCHqUxYhqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     lily <floridsleeves@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, asml.silence@gmail.com,
        imagedong@tencent.com, luiz.von.dentz@intel.com,
        vasily.averin@linux.dev, jk@codeconstruct.com.au,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 25/33] net/core/skbuff: Check the return value of skb_copy_bits()
Date:   Tue, 30 Aug 2022 13:18:16 -0400
Message-Id: <20220830171825.580603-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: lily <floridsleeves@gmail.com>

[ Upstream commit c624c58e08b15105662b9ab9be23d14a6b945a49 ]

skb_copy_bits() could fail, which requires a check on the return
value.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5b3559cb1d827..c4a1cd9861857 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4179,9 +4179,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 				SKB_GSO_CB(nskb)->csum_start =
 					skb_headroom(nskb) + doffset;
 			} else {
-				skb_copy_bits(head_skb, offset,
-					      skb_put(nskb, len),
-					      len);
+				if (skb_copy_bits(head_skb, offset, skb_put(nskb, len), len))
+					goto err;
 			}
 			continue;
 		}
-- 
2.35.1

