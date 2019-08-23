Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 122BE9AE2D
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 13:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392681AbfHWLdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 07:33:13 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37896 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732587AbfHWLdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 07:33:13 -0400
Received: by mail-pg1-f196.google.com with SMTP id e11so5642330pga.5;
        Fri, 23 Aug 2019 04:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=e+cZDcDRNXNc8zri6wufdoX708flCdxqlrHLRtb2ICQ=;
        b=R14uWYabaccyTsGH+krKYWmeiV28XzUA/iZCMuKsus7esVUWZQ4amigz7Msa8WZ6WB
         n8ChEB6IBfuH+ZCncKvwP1d0fTRngKOA+X1xIP5qSKc4jsCcwIW0/aNk5VOpYGJz+gEW
         kuWmDy7wJCWG6cGSVMTow/hki5muIbe6yPPj9cJq1Czbek4sAoFdsoZskTo99i7Zi/qk
         SP7uZ8MKfUdVnn7DlD9j6arcpnNJTNUtY2bYOU0+A5yI9yZM1Q2ZqJLteV9sC0H4Pus4
         A+WfJw5+oh6Tpyx1M4eZWVFucDYBPb4HcQ2rDGC0EtJnSALEtxe77EEN61cEs24OM8Cy
         +wzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=e+cZDcDRNXNc8zri6wufdoX708flCdxqlrHLRtb2ICQ=;
        b=mXvFeTObdYA9rfg3TeZlETPMUQFE3FcM7gpmonaJjJpauG2HU6U8Uj9bgQodaAmN0m
         h3f1uI5dxhluHGwcf3KsviR/+SsuzV0fEEr9AeHy+7mT1qxZ4Dpzp4hR4xWbXUCoOpVd
         PSbb4MQagYXyFMrKstrmSHP/MZ8nxOcTMCPVKhX+4f5yQe9Gn4UUEirV5vZ6neGL16qn
         49dXNihLSaTYzSNLae6YfDUekLoQ6pzPd1IvIAgixRkitCzN7J12vMZgF/qfoEvSj5d5
         yC+g9GN+Xj7dEfjSJdEGulk0q87qHn9STmSN4P2zcheqEPs5JHFTj9vNs/5g/BgtlRwB
         jC5g==
X-Gm-Message-State: APjAAAUWDpOCLNdp7DL0gbP+iTsom/LAZ2MItuVZLIdSVxcF+YYoa0UE
        oR/OwggQJBE5Fpy+ZvKCJY9m5Quz1Q4=
X-Google-Smtp-Source: APXvYqyfIVb90xcU1sHzhaoKoXAV/ohcFAQAnWmxmf4dLvOYdyZqWmChVlvFxdIuvumPCrXHR3deAA==
X-Received: by 2002:a65:6904:: with SMTP id s4mr3547773pgq.33.1566559992065;
        Fri, 23 Aug 2019 04:33:12 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 6sm2320172pfa.7.2019.08.23.04.33.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 04:33:11 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH net-next] net: ipv6: fix listify ip6_rcv_finish in case of forwarding
Date:   Fri, 23 Aug 2019 19:33:03 +0800
Message-Id: <e355527b374f6ce70fcc286457f87592cd8f3dcc.1566559983.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/ipv6/ip6_input.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index fa014d5..d432d00 100644
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
2.1.0

