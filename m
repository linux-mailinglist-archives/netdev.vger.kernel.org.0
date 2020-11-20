Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381072BA0C7
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 04:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgKTDFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 22:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgKTDFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 22:05:12 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E483C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 19:05:10 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id a186so6242752wme.1
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 19:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yi6hIVa6EFqTihmdYqH54Gb/uY+A5BQ86LSmJXLd5uw=;
        b=QGDT2HITCFc1kEH7mUvKOfFwRE2u5qE2fXigO5ltKrWhfozxUxm+Kn5A4sbXXxcpsE
         JdLB25n5solE7xIzczL1DI51M0JzsU4dbvwF+tjRfBJxK+FlXpqB4uf3rb0JIvEyB8LQ
         fp9B5BZoNgsg2Ac2RImt8qcWdG8Vwh9uMinOGreiC78cKuNGXowsm+Zm20afUOmX+Ajl
         RVdBfxStquF7Am4Fip/+Ccntx8YI6If7RjeJslEEK3+I8TPfxFh0/nwmLawp/eAUhf+T
         jyRkEnvjoZGC5eh9LeDbGM3daJ+ZpyH1DCljwhbHo8pNV99HTQu0GIfQt+O4nQq0vivP
         dYhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yi6hIVa6EFqTihmdYqH54Gb/uY+A5BQ86LSmJXLd5uw=;
        b=kbXvWzloz9HO7EILFwLOFuIGOf7uMlBlBchUUW9kJ2mwi6ztV0JXLDbxY0wrtRswcf
         grT0tBzziqmJ9TgTogTltAHJWhhIArc56cjj6oO/IS3cQ3dxE7uOx0RYNphaY+Wl9/bA
         zR0NOTG+sl9F5wTiu9q/txQW4BleJBkNVmMwucDoFmDNtqASlYbqP2RfMMhMemO71y00
         f9ltXg+1+s67vFDGiT4ALGemyQvTtliZSfOXtPkJeoa8krMr+F4KCE1M2CEssBCrbKG+
         a5XlE8GPbdZ6Q6TnK44GiWrrh2yCnw+ZkX9oYiooX/X/BMBkPrCbvUpQlHj4LC2xxhs+
         W23w==
X-Gm-Message-State: AOAM5302LWsTDgfa9kivJP+P5sze3MZylkjc/KKLUzYyCX1NeQLu36p8
        Sz8jsGVWkr+fVCxRmyB0w+g=
X-Google-Smtp-Source: ABdhPJzdMfp9pOjdTdWHSemX2hKdv+x279LMXcBgyzlQMHEYhzktBtzpanFqeCC54ZG9U4Yne0Sbvw==
X-Received: by 2002:a1c:7f48:: with SMTP id a69mr7716551wmd.21.1605841508914;
        Thu, 19 Nov 2020 19:05:08 -0800 (PST)
Received: from localhost.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id a18sm2580140wme.18.2020.11.19.19.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 19:05:08 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, willemb@google.com,
        Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>
Subject: [net] net/packet: fix incoming receive for L3 devices without visible hard header
Date:   Fri, 20 Nov 2020 05:04:12 +0200
Message-Id: <20201120030412.1646940-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the patchset merged by commit b9fcf0a0d826
("Merge branch 'support-AF_PACKET-for-layer-3-devices'") L3 devices which
did not have header_ops were given one for the purpose of protocol parsing
on af_packet transmit path.

That change made af_packet receive path regard these devices as having a
visible L3 header and therefore aligned incoming skb->data to point to the
skb's mac_header. Some devices, such as ipip, xfrmi, and others, do not
reset their mac_header prior to ingress and therefore their incoming
packets became malformed.

Ideally these devices would reset their mac headers, or af_packet would be
able to rely on dev->hard_header_len being 0 for such cases, but it seems
this is not the case.

Fix by changing af_packet RX ll visibility criteria to include the
existence of a '.create()' header operation, which is used when creating
a device hard header - via dev_hard_header() - by upper layers, and does
not exist in these L3 devices.

Fixes: b9fcf0a0d826 ("Merge branch 'support-AF_PACKET-for-layer-3-devices'")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/packet/af_packet.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index cefbd50c1090..a241059fd536 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -93,8 +93,8 @@
 
 /*
    Assumptions:
-   - If the device has no dev->header_ops, there is no LL header visible
-     above the device. In this case, its hard_header_len should be 0.
+   - If the device has no dev->header_ops->create, there is no LL header
+     visible above the device. In this case, its hard_header_len should be 0.
      The device may prepend its own header internally. In this case, its
      needed_headroom should be set to the space needed for it to add its
      internal header.
@@ -108,21 +108,21 @@
 On receive:
 -----------
 
-Incoming, dev->header_ops != NULL
+Incoming, dev->header_ops != NULL && dev->header_ops->create != NULL
    mac_header -> ll header
    data       -> data
 
-Outgoing, dev->header_ops != NULL
+Outgoing, dev->header_ops != NULL && dev->header_ops->create != NULL
    mac_header -> ll header
    data       -> ll header
 
-Incoming, dev->header_ops == NULL
+Incoming, dev->header_ops == NULL || dev->header_ops->create == NULL
    mac_header -> data
      However drivers often make it point to the ll header.
      This is incorrect because the ll header should be invisible to us.
    data       -> data
 
-Outgoing, dev->header_ops == NULL
+Outgoing, dev->header_ops == NULL || dev->header_ops->create == NULL
    mac_header -> data. ll header is invisible to us.
    data       -> data
 
@@ -272,6 +272,18 @@ static bool packet_use_direct_xmit(const struct packet_sock *po)
 	return po->xmit == packet_direct_xmit;
 }
 
+static bool packet_ll_header_rcv_visible(const struct net_device *dev)
+{
+	/* The device has an explicit notion of ll header,
+	 * exported to higher levels
+	 *
+	 * Otherwise, the device hides details of its frame
+	 * structure, so that corresponding packet head is
+	 * never delivered to user.
+	 */
+	return dev->header_ops && dev->header_ops->create;
+}
+
 static u16 packet_pick_tx_queue(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
@@ -2069,7 +2081,7 @@ static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	skb->dev = dev;
 
-	if (dev->header_ops) {
+	if (packet_ll_header_rcv_visible(dev)) {
 		/* The device has an explicit notion of ll header,
 		 * exported to higher levels.
 		 *
@@ -2198,7 +2210,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (!net_eq(dev_net(dev), sock_net(sk)))
 		goto drop;
 
-	if (dev->header_ops) {
+	if (packet_ll_header_rcv_visible(dev)) {
 		if (sk->sk_type != SOCK_DGRAM)
 			skb_push(skb, skb->data - skb_mac_header(skb));
 		else if (skb->pkt_type == PACKET_OUTGOING) {
-- 
2.25.1

