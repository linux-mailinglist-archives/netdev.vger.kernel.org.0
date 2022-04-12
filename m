Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF064FCA84
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 02:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245423AbiDLAyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 20:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343990AbiDLAxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:53:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FE4340C7;
        Mon, 11 Apr 2022 17:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41E8AB815C8;
        Tue, 12 Apr 2022 00:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E9EC385A9;
        Tue, 12 Apr 2022 00:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724494;
        bh=0eZppCwWq3W8uUqYp+iJLjU1beUmHe4ZmPffUoeJlno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umc6QTE3gUc/+glt4GfNSREw9kpbzINrpDVU2g7qdSMb5Hq2oTRg9WB7aYz49XeKy
         B94U5yrKsc7ED8AipY5f4rBamaWbxz+f+UEFn0MDSJQ3lh4pswI1iiI+tTgA2SV6Ug
         BJFtSL68+pRdRzBaOGhZJyWMjsLjFF8lwhOKDu0Q3w2bPg7KqUzvPkhzMdoYDqll0C
         nSZ26czmDQ0EVGvohTBEp5X1CP4WgheNa70lGmBHWrS2x0XwsUEKib7P1y9nZ4b7zG
         q9ijlpYdheNGRw9fosSlWTPfgfuR0DHI4xLZ9vGq4lGeHKnO8RByMEC7T9trqEUXul
         OrZHdMT41TpeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, christopher.lee@cspi.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 27/41] myri10ge: fix an incorrect free for skb in myri10ge_sw_tso
Date:   Mon, 11 Apr 2022 20:46:39 -0400
Message-Id: <20220412004656.350101-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
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

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

[ Upstream commit b423e54ba965b4469b48e46fd16941f1e1701697 ]

All remaining skbs should be released when myri10ge_xmit fails to
transmit a packet. Fix it within another skb_list_walk_safe.

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index c1a75b08ced7..052696ce5096 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2900,11 +2900,9 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 		status = myri10ge_xmit(curr, dev);
 		if (status != 0) {
 			dev_kfree_skb_any(curr);
-			if (segs != NULL) {
-				curr = segs;
-				segs = next;
+			skb_list_walk_safe(next, curr, next) {
 				curr->next = NULL;
-				dev_kfree_skb_any(segs);
+				dev_kfree_skb_any(curr);
 			}
 			goto drop;
 		}
-- 
2.35.1

