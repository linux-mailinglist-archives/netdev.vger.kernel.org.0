Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690943B29D6
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 10:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhFXIHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 04:07:30 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:45868 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231788AbhFXIHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 04:07:30 -0400
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id EFA06A33CE5;
        Thu, 24 Jun 2021 10:05:09 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1lwKMH-0005eE-U7; Thu, 24 Jun 2021 10:05:09 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net] dev_forward_skb: do not scrub skb mark within the same name space
Date:   Thu, 24 Jun 2021 10:05:05 +0200
Message-Id: <20210624080505.21628-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal is to keep the mark during a bpf_redirect(), like it is done for
legacy encapsulation / decapsulation, when there is no x-netns.
This was initially done in commit 213dd74aee76 ("skbuff: Do not scrub skb
mark within the same name space").

When the call to skb_scrub_packet() was added in dev_forward_skb() (commit
8b27f27797ca ("skb: allow skb_scrub_packet() to be used by tunnels")), the
second argument (xnet) was set to true to force a call to skb_orphan(). At
this time, the mark was always cleanned up by skb_scrub_packet(), whatever
xnet value was.
This call to skb_orphan() was removed later in commit
9c4c325252c5 ("skbuff: preserve sock reference when scrubbing the skb.").
But this 'true' stayed here without any real reason.

Let's correctly set xnet in ____dev_forward_skb(), this function has access
to the previous interface and to the new interface.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5cbc950b34df..5ab2d1917ca1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4114,7 +4114,7 @@ static __always_inline int ____dev_forward_skb(struct net_device *dev,
 		return NET_RX_DROP;
 	}
 
-	skb_scrub_packet(skb, true);
+	skb_scrub_packet(skb, !net_eq(dev_net(dev), dev_net(skb->dev)));
 	skb->priority = 0;
 	return 0;
 }
-- 
2.30.0

