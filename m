Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A0B2BBD83
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 07:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgKUG24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 01:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKUG24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 01:28:56 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57464C0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:28:53 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id s8so13037790wrw.10
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1/xlmPnAKQeD0cO6ZV0O9++jY/BgRGkHW+yfYnnb42o=;
        b=sLZEVhLh13Xyma6RisAtbnnbcE93Pa/Uzus+9+W8Tm1mTxicts8CTH4Xmb55Cbi/Zu
         7AvD8FanTRvO8BX9SuY6KH/nCvuu3JnpV2LE6tOVfakY8w5kKINUhUAbJmlbl2J7PV/c
         tKadQoXHxbYa8r21JPKFLTFuRIuK6r4kpFBEy3w6oO9OnycTt5EIcpqXHUlgSDN+fy9H
         YetHxT56qk/pHb1DDh6V8/7vsndFSn2MmampAoetVVsxmsK9kdiFkPVyn+giqiis4p2B
         ZAn/LOl/DQliryW+DYOKScJXVoE3Oj8LKznlV1Bdc6zmIr+P7hbhRvUbs8IimeRx4bVd
         UdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1/xlmPnAKQeD0cO6ZV0O9++jY/BgRGkHW+yfYnnb42o=;
        b=jLwskkw+HO9nyDUiTjDR8biGwAZs1y6Ue/2Jo9llAAJzUbE8shQ7B/GefDEYuBcIWK
         v+c7JGENe7qFWF5sx/5SxFb+Nnc3Ml7nwRR6+dWMFwWnMyAECQjOdJyWycn+7xk864kc
         rtL8E7Q6AJgBV8c6L8TudwHsX3g0qVdcj9l/2yzi+IZWVBmOmEQzq1DlxpqtJyWeS4mA
         tyJDRPhYt/6OIkYkuj4QOMU2Wl0cPZNf3gQjx1Nlk+aCD9gEXxKKtMvH5Ta/D0yd5o0u
         pMZgnplLzO9nULPJZm845605/XVOQHEfHv+4yoJ9yhjTjka8um4tbii0NBGC9oupLqie
         iwDA==
X-Gm-Message-State: AOAM533/hhHaZexVALSXB+gbkBPR5WDN9Dwvaarr3Yi+mbkKCICNf/lL
        g7F1vnUfxuvU3Gd3MeEaVu4=
X-Google-Smtp-Source: ABdhPJzW2n2eggfHNxFKJy63ASVi3G5ofepsougxqsvz+bzu9mcrACfenwanSuvqgBTyzzI4k1mbBA==
X-Received: by 2002:adf:8366:: with SMTP id 93mr19664327wrd.321.1605940131181;
        Fri, 20 Nov 2020 22:28:51 -0800 (PST)
Received: from localhost.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id q66sm6852043wme.6.2020.11.20.22.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 22:28:50 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     Jason@zx2c4.com, netdev@vger.kernel.org, xie.he.0141@gmail.com,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [net,v2] net/packet: fix packet receive on L3 devices without visible hard header
Date:   Sat, 21 Nov 2020 08:28:17 +0200
Message-Id: <20201121062817.3178900-1-eyal.birger@gmail.com>
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

As this predicate may be useful in other situations, add it as a common
dev_has_header() helper in netdevice.h.

Fixes: b9fcf0a0d826 ("Merge branch 'support-AF_PACKET-for-layer-3-devices'")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

---

v2:
  - add common dev_has_header() helper as suggested by Willem de Bruijn
---
 include/linux/netdevice.h |  5 +++++
 net/packet/af_packet.c    | 18 +++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 964b494b0e8d..fa275a054f46 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3137,6 +3137,11 @@ static inline bool dev_validate_header(const struct net_device *dev,
 	return false;
 }
 
+static inline bool dev_has_header(const struct net_device *dev)
+{
+	return dev->header_ops && dev->header_ops->create;
+}
+
 typedef int gifconf_func_t(struct net_device * dev, char __user * bufptr,
 			   int len, int size);
 int register_gifconf(unsigned int family, gifconf_func_t *gifconf);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index cefbd50c1090..7a18ffff8551 100644
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
@@ -108,26 +108,26 @@
 On receive:
 -----------
 
-Incoming, dev->header_ops != NULL
+Incoming, dev_has_header(dev) == true
    mac_header -> ll header
    data       -> data
 
-Outgoing, dev->header_ops != NULL
+Outgoing, dev_has_header(dev) == true
    mac_header -> ll header
    data       -> ll header
 
-Incoming, dev->header_ops == NULL
+Incoming, dev_has_header(dev) == false
    mac_header -> data
      However drivers often make it point to the ll header.
      This is incorrect because the ll header should be invisible to us.
    data       -> data
 
-Outgoing, dev->header_ops == NULL
+Outgoing, dev_has_header(dev) == false
    mac_header -> data. ll header is invisible to us.
    data       -> data
 
 Resume
-  If dev->header_ops == NULL we are unable to restore the ll header,
+  If dev_has_header(dev) == false we are unable to restore the ll header,
     because it is invisible to us.
 
 
@@ -2069,7 +2069,7 @@ static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	skb->dev = dev;
 
-	if (dev->header_ops) {
+	if (dev_has_header(dev)) {
 		/* The device has an explicit notion of ll header,
 		 * exported to higher levels.
 		 *
@@ -2198,7 +2198,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (!net_eq(dev_net(dev), sock_net(sk)))
 		goto drop;
 
-	if (dev->header_ops) {
+	if (dev_has_header(dev)) {
 		if (sk->sk_type != SOCK_DGRAM)
 			skb_push(skb, skb->data - skb_mac_header(skb));
 		else if (skb->pkt_type == PACKET_OUTGOING) {
-- 
2.25.1

