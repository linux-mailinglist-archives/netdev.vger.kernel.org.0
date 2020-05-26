Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEF21E1EDF
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 11:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731687AbgEZJl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 05:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbgEZJlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 05:41:55 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720B9C03E97E
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 02:41:55 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ci21so1126854pjb.3
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 02:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4ArQmoWdw/C2ck8BH1jip/LkbQmXVbex0NhxAJEq7tg=;
        b=D+bUwwfUGZW1esk0agp/gWh0L7PDkg8dOJFOVfVpxEcRCIbphWG9qmfeN1yZGSku8K
         /xpb82+dV5bknXbVWn9wN83wNXnJcr0gtTL7jReyZM7M4332Rji45FMl0imjXGU3oOmT
         nZUSwMDYsxnofQiRT1RFPxnsLZHQ2EqAGaraYsAp0UU7SgO2TMfR5eciQ3VLOYeZ1Oy1
         /3nAJdtaGxFZJ3RkYJHH2bwalyQjgYH6l2UCveOOPqPJPuI1oNeso45OtwlcdqVOOP+O
         Sk0VjvgxLdWXDanXpalnGhdhPOtPFF2tiDJYtZlW05+aZnBT4xf3D6jt2zcpQT2TlxIp
         kHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4ArQmoWdw/C2ck8BH1jip/LkbQmXVbex0NhxAJEq7tg=;
        b=Tm4uHnlvtYLQbhcQAnCK4Hmhg61qAA//oRehAG3ZdNWXgAXjnL9iDuTIOF/E7oTgyV
         8PbZdnqPJRyaEXzkNGlklyDhRxyl1+SnTCl7ENOLa4Sy2Z0fjBlSXTZyqOTz4piQBGic
         +sYOZhyihRKePXVx0q+sG2/JZ07EbM/frxTURoOU1e/nZgF/67pzOG7Pc1hLGpQQv74E
         x4ckop14IJT8Dg1Mpyv8ba8GYJMmkarKPfZkPdFJtqZJfWeyPlJVV8ItIWQh09UcPGuq
         w/aS5W2DZ60y14q1dOsXVTfK4Lusnxzvtmw4vb7cZiGFtQChWTlQOWf0x41dC8QG4XUy
         gREQ==
X-Gm-Message-State: AOAM530CHflbF7J5L0OCevURGIHka9nV3EVfM/k2iGdI/FOJpebfIpnL
        3cQjKMcEW7e+pFK25pw+gdPrzcBn
X-Google-Smtp-Source: ABdhPJw+k1vxNWTQC8NoZ4Rvba4RvF6IcdHHwPhpJsrRllkncz99ryF7oXgxkWN8pjSeVlMwrouLoA==
X-Received: by 2002:a17:902:fe04:: with SMTP id g4mr241602plj.327.1590486114512;
        Tue, 26 May 2020 02:41:54 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w73sm14937205pfd.113.2020.05.26.02.41.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 May 2020 02:41:53 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] xfrm: fix a NULL-ptr deref in xfrm_local_error
Date:   Tue, 26 May 2020 17:41:46 +0800
Message-Id: <690acd84dbe4f2e3955f54a1d6bfe71548a481cf.1590486106.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to fix a crash:

  [ ] kasan: GPF could be caused by NULL-ptr deref or user memory access
  [ ] general protection fault: 0000 [#1] SMP KASAN PTI
  [ ] RIP: 0010:ipv6_local_error+0xac/0x7a0
  [ ] Call Trace:
  [ ]  xfrm6_local_error+0x1eb/0x300
  [ ]  xfrm_local_error+0x95/0x130
  [ ]  __xfrm6_output+0x65f/0xb50
  [ ]  xfrm6_output+0x106/0x46f
  [ ]  udp_tunnel6_xmit_skb+0x618/0xbf0 [ip6_udp_tunnel]
  [ ]  vxlan_xmit_one+0xbc6/0x2c60 [vxlan]
  [ ]  vxlan_xmit+0x6a0/0x4276 [vxlan]
  [ ]  dev_hard_start_xmit+0x165/0x820
  [ ]  __dev_queue_xmit+0x1ff0/0x2b90
  [ ]  ip_finish_output2+0xd3e/0x1480
  [ ]  ip_do_fragment+0x182d/0x2210
  [ ]  ip_output+0x1d0/0x510
  [ ]  ip_send_skb+0x37/0xa0
  [ ]  raw_sendmsg+0x1b4c/0x2b80
  [ ]  sock_sendmsg+0xc0/0x110

This occurred when sending a v4 skb over vxlan6 over ipsec, in which case
skb->protocol == htons(ETH_P_IPV6) while skb->sk->sk_family == AF_INET in
xfrm_local_error(). Then it will go to xfrm6_local_error() where it tries
to get ipv6 info from a ipv4 sk.

This issue was actually fixed by Commit 628e341f319f ("xfrm: make local
error reporting more robust"), but brought back by Commit 844d48746e4b
("xfrm: choose protocol family by skb protocol").

So to fix it, we should call xfrm6_local_error() only when skb->protocol
is htons(ETH_P_IPV6) and skb->sk->sk_family is AF_INET6.

Fixes: 844d48746e4b ("xfrm: choose protocol family by skb protocol")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 69c33ca..69c4900 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -642,7 +642,8 @@ void xfrm_local_error(struct sk_buff *skb, int mtu)
 
 	if (skb->protocol == htons(ETH_P_IP))
 		proto = AF_INET;
-	else if (skb->protocol == htons(ETH_P_IPV6))
+	else if (skb->protocol == htons(ETH_P_IPV6) &&
+		 skb->sk->sk_family == AF_INET6)
 		proto = AF_INET6;
 	else
 		return;
-- 
2.1.0

