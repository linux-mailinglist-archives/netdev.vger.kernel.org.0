Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC30C5F9222
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbiJIWqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiJIWoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:44:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2711437D8;
        Sun,  9 Oct 2022 15:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6605B80DDF;
        Sun,  9 Oct 2022 22:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C75C433D6;
        Sun,  9 Oct 2022 22:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354119;
        bh=XuUITKr7vbmhrz9QteERKEkyD+hZRA6lE/w2OQoHIFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1ZJEm0jcfoO4FGx4/hGeozM1UWak+2UA+3njGsaNhx6z8OnrR3l/xLkun0h0jcI0
         RYGANUA8uI7mgtZqAUMpxccr6FJHq5QeDgU5AN6EY3xn+81KpAeuBIBRTihCaiM1/J
         OM8dUeqGr1mjbOCr1+FT2W+zGlj60941zfR2iOKzjBS+cSUO/KLfvWq+QAPiToCV9V
         8Ax7cHAAHcXlq0Mj8BqrzLucuqwtEDXwoy5UT/Eirlg+J5yb2UMxfcIn3hr+ZZKN++
         mn0ngqUI6iU1vMlNGeuLlcWncyM6W+6fhRHGCtARjb54rWL6V9Vr9MMp+IehlWg2tk
         juTFZb5UIaVqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, olek2@wp.pl,
        yangyingliang@huawei.com, rdunlap@infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/34] net: lantiq_etop: Fix return type for implementation of ndo_start_xmit
Date:   Sun,  9 Oct 2022 18:21:05 -0400
Message-Id: <20221009222129.1218277-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222129.1218277-1-sashal@kernel.org>
References: <20221009222129.1218277-1-sashal@kernel.org>
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
index 2d0c52f7106b..14c35ca72b75 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -451,7 +451,7 @@ ltq_etop_stop(struct net_device *dev)
 	return 0;
 }
 
-static int
+static netdev_tx_t
 ltq_etop_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	int queue = skb_get_queue_mapping(skb);
-- 
2.35.1

