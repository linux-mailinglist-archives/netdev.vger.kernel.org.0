Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569582649AF
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgIJQ0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbgIJQW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:22:26 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E82C061757
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:22:25 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l17so6883238edq.12
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UE2d6K+3KE0gCdUqss+RnnAABd5rhFrQF4Qjt8ugQno=;
        b=gDyQ3UlCRUWMGHXpFRyeFun97+THmCP3ojdk1LZYK4LBCCSkY1FE2MC3AMGoBf9GKt
         txGec+wbX4x3zenibCdvEXDUf9Lm05a4heVJ0b5v/gB8eeSl+hi7iCE4YwI/EecvqQCP
         dN+PY6q/pPOz0WE4G/to0/82tsEuAibkkBqlxuMO1xthDTmoNEKBMzcnDEesSktHHKJ7
         NMSKth20jlQliDg8p3QUCH7JShatiGU1IGqhVqmQ/5maXKg0o9wb+ZKmnzdxqHVPai1y
         MLS+33cp4QSQDK3MwoPZRDB+DtpYFASLV94B5FQsakS3epFo45C1nzz+n9gwSaKP2T6l
         Va+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UE2d6K+3KE0gCdUqss+RnnAABd5rhFrQF4Qjt8ugQno=;
        b=QNuwOTud1shqfHobzmDsFaZWDQqeafUol8ZDKJbHCGj0LE4yRT3jpv2KZnTLhflgyB
         9VKjWY6MfkU6FXEBgMJSAPW3EqbCxc9DH7005DcxS//LPnHL+0I3//UcijnRief1wfeZ
         NU+jNQBi0VDrZq9J5icUJa2TY254Jme/8cZ/vGFLNe5IcrJpMvzCrLTTaE95X/w4nc8t
         Oi7G2cNurSN9OycQ4UShyMy66nwP2IorKF5MZicBS4xhNdjJTUavu8butp7yL2LHUBIK
         XZvBLQIoCR+PEMvXOgFAYG0FOB0T5XnSez6DtBjTrX2cmRrgn+vxUK1JkLYCXpsJjJn0
         TRDg==
X-Gm-Message-State: AOAM533nCvTtKYfQVLYXRIklPZdot+yuH4kjfaaqLtB9USHuCIXkrn/1
        h18ZgOdk3bAy4K06YlrX1OU=
X-Google-Smtp-Source: ABdhPJznCzWw/XH/w/TCkXViNf9wRiLUsvUyJK3kvGA9U00I6Edskc1mrIOvtulGLQXqg3uFQ5mDWQ==
X-Received: by 2002:a05:6402:3192:: with SMTP id di18mr10262130edb.116.1599754943895;
        Thu, 10 Sep 2020 09:22:23 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id lr14sm7984998ejb.0.2020.09.10.09.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:22:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        willemdebruijn.kernel@gmail.com, edumazet@google.com
Cc:     netdev@vger.kernel.org
Subject: [RFC PATCH] __netif_receive_skb_core: don't untag vlan from skb on DSA master
Date:   Thu, 10 Sep 2020 19:22:18 +0300
Message-Id: <20200910162218.1216347-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A DSA master interface has upper network devices, each representing an
Ethernet switch port attached to it. Demultiplexing the source ports and
setting skb->dev accordingly is done through the catch-all ETH_P_XDSA
packet_type handler. Catch-all because DSA vendors have various header
implementations, which can be placed anywhere in the frame: before the
DMAC, before the EtherType, before the FCS, etc. So, the ETH_P_XDSA
handler acts like an rx_handler more than anything.

It is unlikely for the DSA master interface to have any other upper than
the DSA switch interfaces themselves. Only maybe a bridge upper*, but it
is very likely that the DSA master will have no 8021q upper. So
__netif_receive_skb_core() will try to untag the VLAN, despite the fact
that the DSA switch interface might have an 8021q upper. So the skb will
never reach that.

So far, this hasn't been a problem because most of the possible
placements of the DSA switch header mentioned in the first paragraph
will displace the VLAN header when the DSA master receives the frame, so
__netif_receive_skb_core() will not actually execute any VLAN-specific
code for it. This only becomes a problem when the DSA switch header does
not displace the VLAN header (for example with a tail tag).

What the patch does is it bypasses the untagging of the skb when there
is a DSA switch attached to this net device. So, DSA is the only
packet_type handler which requires seeing the VLAN header. Once skb->dev
will be changed, __netif_receive_skb_core() will be invoked again and
untagging, or delivery to an 8021q upper, will happen in the RX of the
DSA switch interface itself.

*see commit 9eb8eff0cf2f ("net: bridge: allow enslaving some DSA master
network devices". This is actually the reason why I prefer keeping DSA
as a packet_type handler of ETH_P_XDSA rather than converting to an
rx_handler. Currently the rx_handler code doesn't support chaining, and
this is a problem because a DSA master might be bridged.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Resent, sorry, I forgot to copy the list.

 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 152ad3b578de..952541ce1d9d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -98,6 +98,7 @@
 #include <net/busy_poll.h>
 #include <linux/rtnetlink.h>
 #include <linux/stat.h>
+#include <net/dsa.h>
 #include <net/dst.h>
 #include <net/dst_metadata.h>
 #include <net/pkt_sched.h>
@@ -5192,7 +5193,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 		}
 	}
 
-	if (unlikely(skb_vlan_tag_present(skb))) {
+	if (unlikely(skb_vlan_tag_present(skb)) && !netdev_uses_dsa(skb->dev)) {
 check_vlan_id:
 		if (skb_vlan_tag_get_id(skb)) {
 			/* Vlan id is non 0 and vlan_do_receive() above couldn't
-- 
2.25.1

