Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF6637A5D3
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 13:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhEKLft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 07:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhEKLft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 07:35:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD2FC061574;
        Tue, 11 May 2021 04:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=z8xth38edps4ercvMCzw87sEignsU1bmAbE1Z2XXkMo=; b=r18c6FH0bQlv+AXcu0qPDkQona
        PXwtIcOpBUP1r4eVHMQB3L78lthcIk6qHQUiMQjk3W02GsVW2ZeNweBq0TZtHsg5hAp++wAiMV/Ho
        pkICVhaXwD+crN3+Y9QH7WJ/VZgYoqBgPQHc3/HWXVJAGw/0ihmNrfQxJN4WIPZy94FYQ4amC1o74
        j8w6Lz+ulFThH5AYXrzmlHJQWi/6DCD3l7T3D0RA0Oozo0xLVEcHs/zFaCOeu4OUtO1vw8Z97o1Mc
        f3agHWPGUZHWXdtpriIJwfAbejid0l7FwMjQRM15W0Xr4MpubxUQr+WTOQ1ALhseL37gBUN25xoJb
        Tmgdk/lQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lgQeL-007EFh-Po; Tue, 11 May 2021 11:34:13 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH] udp: Switch the order of arguments to copy_linear_skb
Date:   Tue, 11 May 2021 12:34:00 +0100
Message-Id: <20210511113400.1722975-1-willy@infradead.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All other skb functions use (off, len); this is the only one which
uses (len, off).  Make it consistent.

Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/udp.h | 2 +-
 net/ipv4/udp.c    | 2 +-
 net/ipv6/udp.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 360df454356c..c4a7a4c56e75 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -392,7 +392,7 @@ static inline bool udp_skb_is_linear(struct sk_buff *skb)
 }
 #endif
 
-static inline int copy_linear_skb(struct sk_buff *skb, int len, int off,
+static inline int copy_linear_skb(struct sk_buff *skb, int off, int len,
 				  struct iov_iter *to)
 {
 	int n;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 15f5504adf5b..783c466e6071 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1859,7 +1859,7 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 
 	if (checksum_valid || udp_skb_csum_unnecessary(skb)) {
 		if (udp_skb_is_linear(skb))
-			err = copy_linear_skb(skb, copied, off, &msg->msg_iter);
+			err = copy_linear_skb(skb, off, copied, &msg->msg_iter);
 		else
 			err = skb_copy_datagram_msg(skb, off, msg, copied);
 	} else {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 199b080d418a..24b202dd370e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -369,7 +369,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 	if (checksum_valid || udp_skb_csum_unnecessary(skb)) {
 		if (udp_skb_is_linear(skb))
-			err = copy_linear_skb(skb, copied, off, &msg->msg_iter);
+			err = copy_linear_skb(skb, off, copied, &msg->msg_iter);
 		else
 			err = skb_copy_datagram_msg(skb, off, msg, copied);
 	} else {
-- 
2.30.2

