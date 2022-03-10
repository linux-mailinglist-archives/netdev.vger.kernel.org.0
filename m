Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8D24D41EC
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 08:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbiCJHg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 02:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236537AbiCJHg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 02:36:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0992E79C78
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 23:35:26 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646897724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XBt8ZxM9l6PdH/gcgODOu/4DY2CfD1qg+b7hsM0BHUY=;
        b=zHlZgPJHfCFFecbH4zQvzYWh9BClwcRkWMLvoGtcG2YTS9vt8FksmIcSlrDIj3TaMPkiac
        ps6Z0moW/lPk1L32XRghI9gyjaX5+HuXuS9NB7mG55d+orgPBeRHVGuFNfYPIQ7i4DVy1y
        wQrsIvlzm0CyZA1oMDqzOnI6zEHXZcC7TVzkluF8L5NKOKy5ll60XmBXfxdn0afriP5HV+
        x2NTr6jDmH9OK2O/mkOtWwLghhPpovjs7y2O7g2Q5FLHHLWfpyGniCEEBzipyGDUps5U2t
        0GGm71YEccAyrNiOHoASCuKZjgDsYYBTv9QT4X72FEdZ9sg4qaf15X+OpuwQwQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646897724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XBt8ZxM9l6PdH/gcgODOu/4DY2CfD1qg+b7hsM0BHUY=;
        b=Zk2vUkvGIzC8meR34CDiti/3I+DxCKjnt1884Xn53foDq/+15jZNhI73tJNmt/m48TzIH0
        MpHREcy1TYjWQrAQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@nvidia.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        zhang kai <zhangkaiheb@126.com>,
        Juhee Kang <claudiajkang@gmail.com>,
        Andreas Oetken <ennoerlangen@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Anthony Harivel <anthony.harivel@linutronix.de>
Subject: [PATCH net-next] flow_dissector: Add support for HSRv0
Date:   Thu, 10 Mar 2022 08:35:05 +0100
Message-Id: <20220310073505.49990-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bf08824a0f47 ("flow_dissector: Add support for HSR") added support for
HSR within the flow dissector. However, it only works for HSR in version
1. Version 0 uses a different Ether Type. Add support for it.

Reported-by: Anthony Harivel <anthony.harivel@linutronix.de>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 net/core/flow_dissector.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 34441a32e3be..03b6e649c428 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1283,6 +1283,7 @@ bool __skb_flow_dissect(const struct net *net,
 		break;
 	}
 
+	case htons(ETH_P_PRP):
 	case htons(ETH_P_HSR): {
 		struct hsr_tag *hdr, _hdr;
 
-- 
2.30.2

