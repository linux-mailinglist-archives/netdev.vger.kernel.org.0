Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F8EEBB74
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 01:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfKAAoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 20:44:15 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:46739 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbfKAAoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 20:44:15 -0400
Received: from us180.sjc.aristanetworks.com (us180.sjc.aristanetworks.com [172.25.230.4])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 45FE51E742;
        Thu, 31 Oct 2019 17:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1572569054;
        bh=xqPgJttHCD12XhRX3JpEzUxG5V0ouLsJ2hx86TeINbU=;
        h=Date:To:Subject:Cc:From:From;
        b=nCwvt4Obh6jywht2gdRVmnOBeJCVghpi8rQZLv/cG853C3RskTHaSJrAN/5nBslaS
         o6iDW27vvTKtGjn2wz0lu9SMa9MtmZ8fH4lJLALZLwQscHwPkOQwXAJhBGxFRCyA5J
         RCcsciH6relxsnA83jd1KqU6cdLj0pUcHoVtR9vNSwnLBF/cqMGnZE6wV+EJiJxJu1
         Zu1fA725/WjwQqG7SOemSaFu6ZHsFtKz1PAiG8/ORd3+KeHM0b1YCzUk9hwLw7daSC
         iuLSodLMlgLAz61al3slSSqqGbQBHKohKeAbv7ulaKOLvDvQkD+LAWwKZTwGgC3/mn
         Vy9ZBbSN50jDg==
Received: by us180.sjc.aristanetworks.com (Postfix, from userid 10189)
        id 2B2F995C102D; Thu, 31 Oct 2019 17:44:14 -0700 (PDT)
Date:   Thu, 31 Oct 2019 17:44:13 -0700
To:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: icmp: use input address in traceroute
Cc:     fruggeri@arista.com
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20191101004414.2B2F995C102D@us180.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even with icmp_errors_use_inbound_ifaddr set, traceroute returns the
primary address of the interface the packet was received on, even if
the path goes through a secondary address. In the example:

                    1.0.3.1/24
 ---- 1.0.1.3/24    1.0.1.1/24 ---- 1.0.2.1/24    1.0.2.4/24 ----
 |H1|--------------------------|R1|--------------------------|H2|
 ----            N1            ----            N2            ----

where 1.0.3.1/24 is R1's primary address on N1, traceroute from
H1 to H2 returns:

traceroute to 1.0.2.4 (1.0.2.4), 30 hops max, 60 byte packets
 1  1.0.3.1 (1.0.3.1)  0.018 ms  0.006 ms  0.006 ms
 2  1.0.2.4 (1.0.2.4)  0.021 ms  0.007 ms  0.007 ms

After applying this patch, it returns:

traceroute to 1.0.2.4 (1.0.2.4), 30 hops max, 60 byte packets
 1  1.0.1.1 (1.0.1.1)  0.033 ms  0.007 ms  0.006 ms
 2  1.0.2.4 (1.0.2.4)  0.011 ms  0.007 ms  0.007 ms

Original-patch-by: Bill Fenner <fenner@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>

---
 net/ipv4/icmp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 4298aae74e0e..a72fbdf1fb85 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -682,7 +682,8 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 			dev = dev_get_by_index_rcu(net, inet_iif(skb_in));
 
 		if (dev)
-			saddr = inet_select_addr(dev, 0, RT_SCOPE_LINK);
+			saddr = inet_select_addr(dev, iph->saddr,
+						 RT_SCOPE_LINK);
 		else
 			saddr = 0;
 		rcu_read_unlock();
-- 
2.19.1


