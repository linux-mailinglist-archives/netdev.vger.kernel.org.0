Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C4359041E
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238325AbiHKQcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238505AbiHKQaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:30:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9914DB56EF;
        Thu, 11 Aug 2022 09:09:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36E816144D;
        Thu, 11 Aug 2022 16:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4E5C433B5;
        Thu, 11 Aug 2022 16:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234173;
        bh=MmYKNfMEFjoJY8J/61fcKI9hw6iqnOw64iIDCkSxvlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHXacPQ+hbRsQ9kUOE8RgElRTQELSPAs9xHUUWYvY2UzP+e0oBJBgSDFvsW8wMngD
         lv/oeByXUAcW4/d4IBb1Tg7bdZByFrqBDBmcYOlXMatxgv6j3h45eVclb3sdpNtemc
         w4ppfN49tAjqv75lNioobCeg7s1MJxCs1UCYY9/FeZrJIbbj89GzGvXw3wOvW7/JV/
         p2Uj7Av20obGIHV03iVERH4zd3wUQ7dymJqD1+gKQkj/IX1LCwRixki2VwJPCdpuFV
         3f0W4LV8NXg0OhWCksSZ++cmcKp62BDHR74MKe9W4Jhn+wDXu3KNVTQe3urZFJpSvb
         +fQZK1u0crAVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/25] Bluetooth: use memset avoid memory leaks
Date:   Thu, 11 Aug 2022 12:08:16 -0400
Message-Id: <20220811160826.1541971-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160826.1541971-1-sashal@kernel.org>
References: <20220811160826.1541971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>

[ Upstream commit d3715b2333e9a21692ba16ef8645eda584a9515d ]

Use memset to initialize structs to prevent memory leaks
in l2cap_ecred_connect

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 959a16b13303..aef4d172c0d5 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1298,6 +1298,7 @@ static void l2cap_le_connect(struct l2cap_chan *chan)
 
 	l2cap_le_flowctl_init(chan, 0);
 
+	memset(&req, 0, sizeof(req));
 	req.psm     = chan->psm;
 	req.scid    = cpu_to_le16(chan->scid);
 	req.mtu     = cpu_to_le16(chan->imtu);
-- 
2.35.1

