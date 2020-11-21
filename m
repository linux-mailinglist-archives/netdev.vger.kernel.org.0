Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BAB2BBD89
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 07:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgKUGes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 01:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgKUGer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 01:34:47 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E74C0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:34:47 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id k2so13128554wrx.2
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1/xlmPnAKQeD0cO6ZV0O9++jY/BgRGkHW+yfYnnb42o=;
        b=cFwPO7wDiZUzuznmqOfkLQ29iZOVkV+Ftota9R02ldkbVyZ76O3oDWWacxA1WJIpJH
         nhXEhzKiiVyKCWfHRDENbiegHnknlgadG/WR+gD8GkSu78gs2xCcrHPPHDmWwx3aTUjT
         w05kU8IteTj5zZ86RfBrnXp2ZVVh4yyDWYiWvss798k6IBr5zqtadFwXb/EqGXshF1yB
         k55tgYTJhBEa0mFJOjuDtqCIlczh6qfgSvuuyIkyND3vZYMeIouw06d0OXdS69tmWmAq
         v7xKsyqu2ocO5q/cwaMVgjeSmbVlkdnP+alIK5wH4DKTBtpMejwgkDBcGLBi7yKsGNvv
         SCqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1/xlmPnAKQeD0cO6ZV0O9++jY/BgRGkHW+yfYnnb42o=;
        b=hVJ5Rf2q7wiTSxsHCpV9i7Y+eOPtR42j+QbffVlqwhJPApszu/mLkr3JTbTmE7FHOy
         6SopKp23OQXSVoteH4N8Z2gPD2QxP111ut1ygOd7D9P3AFBU6vbjTHz0YkhpEcKwFZeT
         mK82sYJjhIJS1NIuTiyE3Q7xlb1d7bNlULjgJ7yujxixHmGhr7B04quVF+X/e2U/x7Oc
         aFGBPRmjwbjjAiBHhnUt3f6xHLGixGAe2HkpTohwHrKtjbvqXn7KzlsVGPru2OtzILH2
         8fsJvFumZ5zUvYznIcjq8D+cQi0vmvW4yl4EpAvs6TnAGNEDbhyRFXDUkqwf7G6AZcY+
         pSmQ==
X-Gm-Message-State: AOAM533VeWZmVB9NAHdFn+jZ/RVG7PNA9zTrWdDDHC3P6tTa88e/WgkC
        AjloQBoOkxMMXD85iMTaqt8=
X-Google-Smtp-Source: ABdhPJxqwqyq/FGWADlMJtf1TRTKDVOOy5JtOjn9ePfM4qhxVjscpdEaQIeBtvqgp7+jrx3JXvh8QQ==
X-Received: by 2002:adf:ffc2:: with SMTP id x2mr19462466wrs.129.1605940485866;
        Fri, 20 Nov 2020 22:34:45 -0800 (PST)
Received: from localhost.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id w10sm7913102wra.34.2020.11.20.22.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 22:34:43 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     Jason@zx2c4.com, netdev@vger.kernel.org, xie.he.0141@gmail.com,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH net,v2] net/packet: fix packet receive on L3 devices without visible hard header
Date:   Sat, 21 Nov 2020 08:34:26 +0200
Message-Id: <20201121063426.3184468-1-eyal.birger@gmail.com>
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

