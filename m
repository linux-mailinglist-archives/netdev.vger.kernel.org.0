Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F177E4E0B
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395197AbfJYOEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732091AbfJYN4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:56:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AFED222C4;
        Fri, 25 Oct 2019 13:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011798;
        bh=Uo/2wz8IumRDL/GCR/T0JDnrYH1c4veTbSER1Hd9qyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1kbKYys2veWQpxlNSWjG5I6PZF08L3IBqlGofmcdDzIUzOixQiUeyBoVCE9H2m3AL
         +OwKjWtJ9OZZCT5T/XXyWcxdXkmaZUA8k/+1jLwanAQhhnCYd13MvD7hralS+UWiM8
         6WL5VudorhPgSxzkgm3SHt0fm/qRmYhsHrLWh2Ho=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com,
        syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com,
        Edward Cree <ecree@solarflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/37] net: ipv6: fix listify ip6_rcv_finish in case of forwarding
Date:   Fri, 25 Oct 2019 09:55:43 -0400
Message-Id: <20191025135603.25093-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135603.25093-1-sashal@kernel.org>
References: <20191025135603.25093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit c7a42eb49212f93a800560662d17d5293960d3c3 ]

We need a similar fix for ipv6 as Commit 0761680d5215 ("net: ipv4: fix
listify ip_rcv_finish in case of forwarding") does for ipv4.

This issue can be reprocuded by syzbot since Commit 323ebb61e32b ("net:
use listified RX for handling GRO_NORMAL skbs") on net-next. The call
trace was:

  kernel BUG at include/linux/skbuff.h:2225!
  RIP: 0010:__skb_pull include/linux/skbuff.h:2225 [inline]
  RIP: 0010:skb_pull+0xea/0x110 net/core/skbuff.c:1902
  Call Trace:
    sctp_inq_pop+0x2f1/0xd80 net/sctp/inqueue.c:202
    sctp_endpoint_bh_rcv+0x184/0x8d0 net/sctp/endpointola.c:385
    sctp_inq_push+0x1e4/0x280 net/sctp/inqueue.c:80
    sctp_rcv+0x2807/0x3590 net/sctp/input.c:256
    sctp6_rcv+0x17/0x30 net/sctp/ipv6.c:1049
    ip6_protocol_deliver_rcu+0x2fe/0x1660 net/ipv6/ip6_input.c:397
    ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:438
    NF_HOOK include/linux/netfilter.h:305 [inline]
    NF_HOOK include/linux/netfilter.h:299 [inline]
    ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:447
    dst_input include/net/dst.h:442 [inline]
    ip6_sublist_rcv_finish+0x98/0x1e0 net/ipv6/ip6_input.c:84
    ip6_list_rcv_finish net/ipv6/ip6_input.c:118 [inline]
    ip6_sublist_rcv+0x80c/0xcf0 net/ipv6/ip6_input.c:282
    ipv6_list_rcv+0x373/0x4b0 net/ipv6/ip6_input.c:316
    __netif_receive_skb_list_ptype net/core/dev.c:5049 [inline]
    __netif_receive_skb_list_core+0x5fc/0x9d0 net/core/dev.c:5097
    __netif_receive_skb_list net/core/dev.c:5149 [inline]
    netif_receive_skb_list_internal+0x7eb/0xe60 net/core/dev.c:5244
    gro_normal_list.part.0+0x1e/0xb0 net/core/dev.c:5757
    gro_normal_list net/core/dev.c:5755 [inline]
    gro_normal_one net/core/dev.c:5769 [inline]
    napi_frags_finish net/core/dev.c:5782 [inline]
    napi_gro_frags+0xa6a/0xea0 net/core/dev.c:5855
    tun_get_user+0x2e98/0x3fa0 drivers/net/tun.c:1974
    tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2020

Fixes: d8269e2cbf90 ("net: ipv6: listify ipv6_rcv() and ip6_rcv_finish()")
Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
Reported-by: syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_input.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 2b6d430223837..acf0749ee5bbd 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -80,8 +80,10 @@ static void ip6_sublist_rcv_finish(struct list_head *head)
 {
 	struct sk_buff *skb, *next;
 
-	list_for_each_entry_safe(skb, next, head, list)
+	list_for_each_entry_safe(skb, next, head, list) {
+		skb_list_del_init(skb);
 		dst_input(skb);
+	}
 }
 
 static void ip6_list_rcv_finish(struct net *net, struct sock *sk,
-- 
2.20.1

