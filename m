Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159005F9366
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 01:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbiJIXNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 19:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbiJIXMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 19:12:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5047D578A5;
        Sun,  9 Oct 2022 15:38:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACCF760C33;
        Sun,  9 Oct 2022 22:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040C6C433C1;
        Sun,  9 Oct 2022 22:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354377;
        bh=dldXAdnZpfgGdJ/LZ5o1hkLVakuPLh+B5WRHwUtaWYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4MLTC4OXDLzEJBk3vCsoHp+7SpAB9a/iD6WAE1G3SE95Y6ec1viwLycbD38Y8Xxe
         JrxYq7CqLtWYyqlDoVpvpPp1uPZUh7CHtzt5erAKXM+RijDLBFd1T75j4aBYEiZtpT
         G+XNaoP2hsZCiW96cMMhe87FnYa0hRsCjAgPH5jyw0lzdRQc2skliqxLcxKxB/csV0
         ktmeJET7PPSC2drwuc0/xsz+Zb0neCz0sVUGW+i1odzpvAqwZZT2AQzqe2X1YdsXVO
         TgYoiXGBJBEsYxEkbNEedUGtd9K80GET5kBgqWfXw4L4hwmSDiiA0FcnP9koAL1CbM
         hC6ds7XX4mP1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, olek2@wp.pl,
        rdunlap@infradead.org, yangyingliang@huawei.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/23] net: lantiq_etop: Fix return type for implementation of ndo_start_xmit
Date:   Sun,  9 Oct 2022 18:25:38 -0400
Message-Id: <20221009222557.1219968-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222557.1219968-1-sashal@kernel.org>
References: <20221009222557.1219968-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: GUO Zihua <guozihua@huawei.com>

[ Upstream commit c8ef3c94bda0e21123202d057d4a299698fa0ed9 ]

Since Linux now supports CFI, it will be a good idea to fix mismatched
return type for implementation of hooks. Otherwise this might get
cought out by CFI and cause a panic.

ltq_etop_tx() would return either NETDEV_TX_BUSY or NETDEV_TX_OK, so
change the return type to netdev_tx_t directly.

Signed-off-by: GUO Zihua <guozihua@huawei.com>
Link: https://lore.kernel.org/r/20220902081521.59867-1-guozihua@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_etop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index afc810069440..c90886d74fde 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -464,7 +464,7 @@ ltq_etop_stop(struct net_device *dev)
 	return 0;
 }
 
-static int
+static netdev_tx_t
 ltq_etop_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	int queue = skb_get_queue_mapping(skb);
-- 
2.35.1

