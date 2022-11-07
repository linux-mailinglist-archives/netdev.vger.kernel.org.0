Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6F761FDF6
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbiKGSzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbiKGSza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:55:30 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0F821E2B;
        Mon,  7 Nov 2022 10:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=itzNjPSgtI5YQ3ZzVEgPaMFuJJoHJB+VuPcGUc7XBPA=; b=TvI9XFrPBGbzQWNayCtd/QHfzC
        c+nStyV96uynxPWlvUEeHDMR8U/pZ1cMjcW1n8KF5LGoD5/zjioGbXaAPOXGpVL467XaV+/7yZY9W
        vmA5sPiVfmJvbuCirrUKlLOGeZ7yablPwQuT6B68IM2Ha+Nw+hgBL9Ta4puijo45e8Bs=;
Received: from p200300daa72ee1007849d74f78949f6c.dip0.t-ipconnect.de ([2003:da:a72e:e100:7849:d74f:7894:9f6c] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1os7HE-000LCc-Hs; Mon, 07 Nov 2022 19:55:20 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] flow_dissector: detect DSA using skb->protocol even when VLAN tag is present
Date:   Mon,  7 Nov 2022 19:54:47 +0100
Message-Id: <20221107185452.90711-9-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221107185452.90711-1-nbd@nbd.name>
References: <20221107185452.90711-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes flow dissection with ethernet devices that can combine VLAN rx hwaccel
with DSA, since skb->protocol is set to htons(ETH_P_XDSA) by the network stack.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/core/flow_dissector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 25cd35f5922e..43f6bbca7447 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -970,7 +970,7 @@ bool __skb_flow_dissect(const struct net *net,
 		hlen = skb_headlen(skb);
 #if IS_ENABLED(CONFIG_NET_DSA)
 		if (unlikely(skb->dev && netdev_uses_dsa(skb->dev) &&
-			     proto == htons(ETH_P_XDSA))) {
+			     skb->protocol == htons(ETH_P_XDSA))) {
 			const struct dsa_device_ops *ops;
 			int offset = 0;
 
-- 
2.38.1

