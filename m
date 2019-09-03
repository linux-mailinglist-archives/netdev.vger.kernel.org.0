Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C37A5ED1
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 03:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbfICB2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 21:28:31 -0400
Received: from gateway20.websitewelcome.com ([192.185.47.18]:13107 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbfICB2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 21:28:30 -0400
X-Greylist: delayed 1210 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Sep 2019 21:28:30 EDT
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id CE8D0400E0C8A
        for <netdev@vger.kernel.org>; Mon,  2 Sep 2019 19:03:02 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 4xIxiaXAt2qH74xIxiWMBV; Mon, 02 Sep 2019 20:08:19 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IPXpQjejrqZ52pjbtbF1TXRKNnTxNBlTRR+B1eBDFS4=; b=NggBeGRRGpw5drYbZbu6G1smfC
        9Z1ZTY75tiynbOHUZ1oFqX2WQnDVAGQx6cqNIgciH6dnIxALTY3m6gv+1KCjASWFOJj1/39Ta2Nzc
        Se0lFwg9cBX36Jv4xV4sRvWrIZuOMCoZQGaSvX+uMBadeiQjIaDH7TSKxyQwsdKn6DStD6EnbVxpz
        RZbQs/YFYrnCTEVe/Z51Lc3hYgmFFyD5tuhvl24zAx/xa8jGaRGSyb5neNRGI440Js62Ini1cYUnQ
        St34WaTw0GRZTpxYXqXEn2KYa/6AUSo/W4eFLHmwvELlL2ZR0FSHxlUxG5dsYwSD3/FRFfZqPu0P4
        ri16SXyg==;
Received: from [189.152.216.116] (port=44906 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1i4xIw-0011oi-Kr; Mon, 02 Sep 2019 20:08:18 -0500
Date:   Mon, 2 Sep 2019 20:08:17 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] net: sched: taprio: Fix potential integer overflow in
 taprio_set_picos_per_byte
Message-ID: <20190903010817.GA13595@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.152.216.116
X-Source-L: No
X-Exim-ID: 1i4xIw-0011oi-Kr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.152.216.116]:44906
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add suffix LL to constant 1000 in order to avoid a potential integer
overflow and give the compiler complete information about the proper
arithmetic to use. Notice that this constant is being used in a context
that expects an expression of type s64, but it's currently evaluated
using 32-bit arithmetic.

Addresses-Coverity-ID: 1453459 ("Unintentional integer overflow")
Fixes: f04b514c0ce2 ("taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_byte")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/sched/sch_taprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 8d8bc2ec5cd6..956f837436ea 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -966,7 +966,7 @@ static void taprio_set_picos_per_byte(struct net_device *dev,
 
 skip:
 	picos_per_byte = div64_s64(NSEC_PER_SEC * 1000LL * 8,
-				   speed * 1000 * 1000);
+				   speed * 1000LL * 1000);
 
 	atomic64_set(&q->picos_per_byte, picos_per_byte);
 	netdev_dbg(dev, "taprio: set %s's picos_per_byte to: %lld, linkspeed: %d\n",
-- 
2.23.0

