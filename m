Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A13516F9B
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 05:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfEHDpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 23:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbfEHDpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 23:45:01 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A175321019;
        Wed,  8 May 2019 03:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557287100;
        bh=AVoiE2lZH32ITTlMetlfK8P6RepUTMvjC/2G0G/WiMc=;
        h=From:To:Cc:Subject:Date:From;
        b=yYb8wg/C70oGRt28lpWSVwEimnc2LphZV2I+HjR/G/VNI2gt/DQjb5tGG17qcxSpP
         g+eGaw6NUEWJUOVdswCcwQhX2nnvRYqQhPlfYGowaDJJWnEaD/Jmsazfc6IodZyVF4
         /QU+bnVLB0W8blHzEt7MpJ5u58zVnE4MnSLfvqD0=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipv4: Fix raw socket lookup for local traffic
Date:   Tue,  7 May 2019 20:44:59 -0700
Message-Id: <20190508034459.31250-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

inet_iif should be used for the raw socket lookup. inet_iif considers
rt_iif which handles the case of local traffic.

As it stands, ping to a local address with the '-I <dev>' option fails
ever since ping was changed to use SO_BINDTODEVICE instead of
cmsg + IP_PKTINFO.

IPv6 works fine.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/raw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index c55a5432cf37..dc91c27bb788 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -173,6 +173,7 @@ static int icmp_filter(const struct sock *sk, const struct sk_buff *skb)
 static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 {
 	int sdif = inet_sdif(skb);
+	int dif = inet_iif(skb);
 	struct sock *sk;
 	struct hlist_head *head;
 	int delivered = 0;
@@ -185,8 +186,7 @@ static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 
 	net = dev_net(skb->dev);
 	sk = __raw_v4_lookup(net, __sk_head(head), iph->protocol,
-			     iph->saddr, iph->daddr,
-			     skb->dev->ifindex, sdif);
+			     iph->saddr, iph->daddr, dif, sdif);
 
 	while (sk) {
 		delivered = 1;
-- 
2.11.0

