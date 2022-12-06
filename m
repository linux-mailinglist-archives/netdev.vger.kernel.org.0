Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92292644D1B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiLFUOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiLFUNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:13:44 -0500
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7AECE05;
        Tue,  6 Dec 2022 12:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1670357354;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=vHz0iN8tbZ6Y0jcudE5x1bJjHnXLoE1xqIZUeAGOuLY=;
    b=lM1/cF6odVSMgBj1/6yjvvPM+HXy62/4MbqMqgUdaWioNISPzv/Dclvl3q6MKiRY9B
    AGyq1sI9GJ3qSLHqUcLpJ2AhQqzuVQB5D03PCsseO9gwkr4axSiXMoOlSsi2yozi5sAT
    oiVSW/SPs94QZvq0ZSPaQBLGp4k6ZWy6kUkeizKUASNQv34FR3xMl4eetF4mHG66e0ea
    a4Rdt6kN5hS1ptForLVyLtVmY6OQNHJw3LHzF4f6MWRdvi4Cky79qr94sp++eLFifPaf
    RLX92yQUPww7tljKKFQWKjVIoDRD2qy/IIaW11cWx1WrJYOgqh5+JutH1RbUKL7KVUwr
    UZ1g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9JiLceSWNadhq4/jU"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783yB6K9EwN2
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 6 Dec 2022 21:09:14 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com,
        Wei Chen <harperchen1110@gmail.com>
Subject: [PATCH] can: af_can: fix NULL pointer dereference in can_rcv_filter
Date:   Tue,  6 Dec 2022 21:08:51 +0100
Message-Id: <20221206200851.2825-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Analogue to commit 8aa59e355949 ("can: af_can: fix NULL pointer dereference
in can_rx_register()") we need to check for a missing initialization of
ml_priv in the receieve path of CAN frames. Since commit 4e096a18867a
("net: introduce CAN specific pointer in the struct net_device") the check
for dev->type to be ARPHRD_CAN is not sufficient anymore since bonding or
tun netdevices claim to be CAN devices but do not initialize ml_priv
accordingly.

Fixes: 4e096a18867a ("net: introduce CAN specific pointer in the struct net_device")
Reported-by: syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/af_can.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 27dcdcc0b808..c69168f11e44 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -675,11 +675,11 @@ static void can_receive(struct sk_buff *skb, struct net_device *dev)
 }
 
 static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 		   struct packet_type *pt, struct net_device *orig_dev)
 {
-	if (unlikely(dev->type != ARPHRD_CAN || (!can_is_can_skb(skb)))) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || !can_is_can_skb(skb))) {
 		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 
 		kfree_skb(skb);
 		return NET_RX_DROP;
@@ -690,11 +690,11 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 }
 
 static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
 		     struct packet_type *pt, struct net_device *orig_dev)
 {
-	if (unlikely(dev->type != ARPHRD_CAN || (!can_is_canfd_skb(skb)))) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || !can_is_canfd_skb(skb))) {
 		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 
 		kfree_skb(skb);
 		return NET_RX_DROP;
@@ -705,11 +705,11 @@ static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
 }
 
 static int canxl_rcv(struct sk_buff *skb, struct net_device *dev,
 		     struct packet_type *pt, struct net_device *orig_dev)
 {
-	if (unlikely(dev->type != ARPHRD_CAN || (!can_is_canxl_skb(skb)))) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || !can_is_canxl_skb(skb))) {
 		pr_warn_once("PF_CAN: dropped non conform CAN XL skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 
 		kfree_skb(skb);
 		return NET_RX_DROP;
-- 
2.30.2

