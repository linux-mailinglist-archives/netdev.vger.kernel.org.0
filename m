Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12173410DA6
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 00:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhISWmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 18:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhISWmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 18:42:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018B4C061574
        for <netdev@vger.kernel.org>; Sun, 19 Sep 2021 15:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1Isc+Bx6LON9etx9O/99WDdKqFUamh4vAScZqFf9/BU=; b=xbHovcB7pMTkpWofkKHC9DggxF
        5slIvcai2YTKedqGLQb3aHsIc48EnqEqiBE+jIecp7Fovg+jlGYdFpBf6EzE6w/bCvYisQWfJTFuf
        gkUsR2u1rTsSZfbpqnQ9RVoQ2Z9HG0UwKecc9Bf2HifdFj2xVyAYGxmP75VOtFFtWygXAeRiHzRSx
        9ViIpwfMkyO7lpmGpo5Ol/n3JYQwvTt6Fd9/ixlVnGQjBSigZVr3amlVv9Q3ciY6KZTbEgxly3fQB
        kbL5/yoEAMWr69WozOhz/32H3/Xgbc/wPjRl9mGHM563hhe74U9iq4LbOM+MphlT+WPvnwerZEa2f
        9EmkFCeA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41446 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mS5UA-00018h-Eq; Sun, 19 Sep 2021 23:40:34 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mS5U9-002wsa-TC; Sun, 19 Sep 2021 23:40:33 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH net] net: sched: fix initialiser warning in sch_frag.c
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mS5U9-002wsa-TC@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sun, 19 Sep 2021 23:40:33 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Debian gcc 10.2.1 complains thusly:

net/sched/sch_frag.c:93:10: warning: missing braces around initializer [-Wmissing-braces]
   struct rtable sch_frag_rt = { 0 };
          ^
net/sched/sch_frag.c:93:10: warning: (near initialization for 'sch_frag_rt.dst') [-Wmissing-braces]

Fix it by removing the unnecessary '0' initialiser, leaving the
braces.

Fixes: 31fe34a0118e ("net/sched: sch_frag: fix stack OOB read while fragmenting IPv4 packets")
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 net/sched/sch_frag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_frag.c b/net/sched/sch_frag.c
index 8c06381391d6..ab359d63287c 100644
--- a/net/sched/sch_frag.c
+++ b/net/sched/sch_frag.c
@@ -90,7 +90,7 @@ static int sch_fragment(struct net *net, struct sk_buff *skb,
 	}
 
 	if (skb_protocol(skb, true) == htons(ETH_P_IP)) {
-		struct rtable sch_frag_rt = { 0 };
+		struct rtable sch_frag_rt = { };
 		unsigned long orig_dst;
 
 		sch_frag_prepare_frag(skb, xmit);
-- 
2.30.2

