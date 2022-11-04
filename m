Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE7B61923B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 08:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiKDHxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 03:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKDHxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 03:53:35 -0400
X-Greylist: delayed 184 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 04 Nov 2022 00:53:32 PDT
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B551E15;
        Fri,  4 Nov 2022 00:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1667548219;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=7n/shGnfP1l0uRtNIQNgUJX4uMoz9OqYhtqOImv6qnk=;
    b=JhUQ6jLty4ryG0uaVYXYC6wuQ1KgBnaVJwLIe2DIyTrJftW4MURaUGlOJoBp/Zb8Or
    TqAECd/s8jr4xIw51uLWlVxwRzTmLtpT7dhKqGE6odrXr+QtAJw3vazDObRGD1Eexogt
    owmIF92Bc3PZa/uPC5Ou/Z3LKPf0mNL68MeT4Ju4oV3OfklxEIGgJxrFRUMAKkyQ8raz
    L6lM+sMCKJa5LKdktwBHNqlK0lHKJ8FIlHExzHNWREkps69mUXNgGKXfBHVx/jvvEeKy
    NiC9ObJQLG31QDEb9mex79P6bnmFyJGfb4KEnjLdOvsxBuXv5J4z1dKURw4xzPEWuaMu
    V+hg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9JiLceSWJaYxMWqfZ"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783yA47oJPCK
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 4 Nov 2022 08:50:19 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        syzbot+d168ec0caca4697e03b1@syzkaller.appspotmail.com
Subject: [PATCH] can: j1939: fix missing CAN header initialization
Date:   Fri,  4 Nov 2022 08:50:00 +0100
Message-Id: <20221104075000.105414-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The read access to struct canxl_frame::len inside of a j1939 created skbuff
revealed a missing initialization of reserved and later filled elements in
struct can_frame.

This patch initializes the 8 byte CAN header with zero.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/linux-can/20221104052235.GA6474@pengutronix.de/T/#t
Reported-by: syzbot+d168ec0caca4697e03b1@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/j1939/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index 144c86b0e3ff..821d4ff303b3 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -334,10 +334,13 @@ int j1939_send_one(struct j1939_priv *priv, struct sk_buff *skb)
 	dlc = skb->len;
 
 	/* re-claim the CAN_HDR from the SKB */
 	cf = skb_push(skb, J1939_CAN_HDR);
 
+	/* initialize header structure */
+	memset(cf, 0, J1939_CAN_HDR);
+
 	/* make it a full can frame again */
 	skb_put(skb, J1939_CAN_FTR + (8 - dlc));
 
 	canid = CAN_EFF_FLAG |
 		(skcb->priority << 26) |
-- 
2.30.2

