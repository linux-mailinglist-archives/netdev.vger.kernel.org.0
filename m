Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FCB644D1E
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiLFUOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiLFUNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:13:54 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F78A442DF;
        Tue,  6 Dec 2022 12:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1670357590;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=cEy9I3IooZKqrPiC5qfTfxbUZuX41PuBOXe1+pD769A=;
    b=Usv/ZHWEFAZKFNn7BOzB1LHOyE2AwCSTD86cfS3ghtC8X7ff939qu4/zDPyS22dh78
    69eLq/wEl0iZGHEHX/O5HK4K7T98qypOOcxzA8NJh9w/2el/PXsw1vhYdVXyBf6pWBc6
    k2ZCK0I4hBL8i7CO6cL36bop+9MUrmP68LjZu98dqGk1pn6cdQOl51oMX5tkme7AEVVM
    zUgF/nUh4mzk5gzDFPaC7OvnWtIFMZw+naivyoB4FOow6IZde9vSMlgT/Lthl3UGskvy
    HuYIpJZzNfaqBxKrDCfWnPbSjtt28GHiOWuOTLIamA0ewE2Gvx9aWPmq1InVC+s+sWWF
    ZfQA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9JiLceSWNadhq4/jU"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783yB6KD9wNO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 6 Dec 2022 21:13:09 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com,
        Wei Chen <harperchen1110@gmail.com>
Subject: [PATCH v2] can: af_can: fix NULL pointer dereference in can_rcv_filter
Date:   Tue,  6 Dec 2022 21:12:59 +0100
Message-Id: <20221206201259.3028-1-socketcan@hartkopp.net>
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
ml_priv in the receive path of CAN frames. Since commit 4e096a18867a
("net: introduce CAN specific pointer in the struct net_device") the check
for dev->type to be ARPHRD_CAN is not sufficient anymore since bonding or
tun netdevices claim to be CAN devices but do not initialize ml_priv
accordingly.

Fixes: 4e096a18867a ("net: introduce CAN specific pointer in the struct net_device")
Reported-by: syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---

V2: fix misspeling detected by checkpatch

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

