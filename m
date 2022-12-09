Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DDC648830
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiLISIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiLISIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:08:07 -0500
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CAD8BD04;
        Fri,  9 Dec 2022 10:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1670609281;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=KYw2VDhn5dXPLqloWUGF/BBcweIJWdPNrVtyI2PdUYs=;
    b=kBaMCR9V8dtMMxhNwiyPMURdr2oo7kpJniBaqShIoVPpfO+mMerVGPa6cWaWwbwGtP
    RjJjjw98l7/plhwLY/RCiM/+1tFZ1dC6S/140MFWcMOWJ1bP2Pjg27oSqZqq8Qe1vlWk
    EG98ocJYpnYL+geK2P1Qzi9ycafeKq0cIZ9+f2rQBd/8EixvJyh5kIeG1ToKwkzmqCVo
    Vk4ph0xYPWcei2L6r7O2PpBp+Q6+F8YHp7K0XL1u+GI3SotQW/j/CzrAQXcNhXazdeS5
    orqprfn5guEtiBHVBCGRJ5exbcSE/V56a38KxoUSXhKIkw/velDtKJXE/3/StJyY1Xh6
    kZCw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJygjsS+Kjg=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 48.2.1 DYNA|AUTH)
    with ESMTPSA id Dde783yB9I8174b
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 9 Dec 2022 19:08:01 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     stable@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com,
        Wei Chen <harperchen1110@gmail.com>
Subject: [PATCH stable] can: af_can: fix NULL pointer dereference in can_rcv_filter
Date:   Fri,  9 Dec 2022 19:07:45 +0100
Message-Id: <20221209180745.2977-1-socketcan@hartkopp.net>
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

Analogue to commit 8aa59e355949 ("can: af_can: fix NULL pointer
dereference in can_rx_register()") we need to check for a missing
initialization of ml_priv in the receive path of CAN frames.

Since commit 4e096a18867a ("net: introduce CAN specific pointer in the
struct net_device") the check for dev->type to be ARPHRD_CAN is not
sufficient anymore since bonding or tun netdevices claim to be CAN
devices but do not initialize ml_priv accordingly.

Upstream commit 0acc442309a0 ("can: af_can: fix NULL pointer
dereference in can_rcv_filter")

Fixes: 4e096a18867a ("net: introduce CAN specific pointer in the struct net_device")
Reported-by: syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: stable@vger.kernel.org # 5.12 .. 6.0
---
 net/can/af_can.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 1fb49d51b25d..4392f1d9c027 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -678,11 +678,11 @@ static void can_receive(struct sk_buff *skb, struct net_device *dev)
 static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 		   struct packet_type *pt, struct net_device *orig_dev)
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CAN_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;
 	}
 
@@ -704,11 +704,11 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
 		     struct packet_type *pt, struct net_device *orig_dev)
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CANFD_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;
 	}
 
-- 
2.30.2

