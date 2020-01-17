Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 037FD1401AB
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 03:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731972AbgAQCDw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Jan 2020 21:03:52 -0500
Received: from mx24.baidu.com ([111.206.215.185]:59414 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726726AbgAQCDv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 21:03:51 -0500
Received: from BJHW-Mail-Ex14.internal.baidu.com (unknown [10.127.64.37])
        by Forcepoint Email with ESMTPS id D8A96A90E286FBD58984
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 10:03:45 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 17 Jan 2020 10:03:45 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Fri, 17 Jan 2020 10:03:45 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     "edumazet@google.com" <edumazet@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [RFC] tcp: remove BUG_ON in tcp_shifted_skb
Thread-Topic: [RFC] tcp: remove BUG_ON in tcp_shifted_skb
Thread-Index: AdXM2Ssb1+KfzfSvTa66zCYc84q1Uw==
Date:   Fri, 17 Jan 2020 02:03:45 +0000
Message-ID: <5cfa925ff7394e10bbbf5132e44cbea4@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.32]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex14_2020-01-17 10:03:45:698
x-baidu-bdmsfe-viruscheck: BJHW-Mail-Ex14_GRAY_Inside_WithoutAtta_2020-01-17
 10:03:45:682
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think this BUG_ON in tcp_shifted_skb maybe be triggered if a GSO skb is 
sacked, but sack is faked, and not ack the whole mss length, only ack less
than mss length

Is it possible ?

- Li RongQing <lirongqing@baidu.com>

---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 1d1e3493965f..141bc85092b5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1327,7 +1327,8 @@ static bool tcp_shifted_skb(struct sock *sk, struct sk_buff *prev,
        TCP_SKB_CB(prev)->sacked |= (TCP_SKB_CB(skb)->sacked & TCPCB_EVER_RETRANS);
 
        if (skb->len > 0) {
-               BUG_ON(!tcp_skb_pcount(skb));
                NET_INC_STATS(sock_net(sk), LINUX_MIB_SACKSHIFTED);
                return false;
        }
-- 
2.16.2


