Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFE34B3DBA
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 22:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbiBMVbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 16:31:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbiBMVbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 16:31:03 -0500
Received: from smtp.smtpout.orange.fr (smtp06.smtpout.orange.fr [80.12.242.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1BF53B48
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 13:30:56 -0800 (PST)
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id JMSHnpnUSSrXTJMSInbeiQ; Sun, 13 Feb 2022 22:30:54 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 13 Feb 2022 22:30:54 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] Bluetooth: 6lowpan: No need to clear memory twice
Date:   Sun, 13 Feb 2022 22:30:47 +0100
Message-Id: <2f67f1c5ed7de38b78a296c798f3d4afe9e3bd63.1644787831.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'peer_addr' is a structure embedded in 'struct lowpan_peer'. So there is no
need to explicitly call memset(0) on it. It is already zeroed by kzalloc()
when 'peer' is allocated.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/bluetooth/6lowpan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 133d7ea063fb..8e8c07541153 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -641,7 +641,6 @@ static struct l2cap_chan *add_peer_chan(struct l2cap_chan *chan,
 		return NULL;
 
 	peer->chan = chan;
-	memset(&peer->peer_addr, 0, sizeof(struct in6_addr));
 
 	baswap((void *)peer->lladdr, &chan->dst);
 
-- 
2.32.0

