Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAA012A3B6
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 18:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfLXR4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 12:56:15 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43393 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfLXR4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 12:56:15 -0500
Received: by mail-pf1-f195.google.com with SMTP id x6so9949044pfo.10
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 09:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2pxfWsOyN98zPcHCWeUaOs+QOyO1VA5VcJEGHF3CYZg=;
        b=ZM813MUSgPN4bZCJxpniNXWlZIskIa/17w5EWXYxd5cNfHthBNYE99/jOvEdlm31gi
         TBzdzzyI3tpUUEA3v816pPMP6PxTsblsQ7dOhuWj+ovweeEEP8D0uT22qmxqZKzQQZct
         L6m1ee/U/Wd/sG0OSTClOyb4mbP9I4nYjWaFYup7iaPzvsFhbjeHg0WJx4kShfwjHusx
         oNXRsB12bXXiTx65W7dsy5kJuFEBx45fhkF7IRhKpZLMb61tjgt3NeQazK+GUqrcFfzV
         +tTihr8ZwRPXVjcIZy80MzqGoaKYYEdlNRQiESBRmlik05a7U/8nYuncjnBkK3mXc9HX
         oaCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2pxfWsOyN98zPcHCWeUaOs+QOyO1VA5VcJEGHF3CYZg=;
        b=D5hoONXN8gZjDuoUbfkV7OclaP7P3KCrqrbVmuhxCKVKqKNoNdhul35Wp0rx2CPZVL
         /8/wTY7kbvreQloklvzaCG4vMJCWOJOBAFRsK8TPcjum637EHXuDdLiNzb7tza+/EaXS
         6n7tDfKF2rVmwJAIpN9LhWgsmUit8il1JiNZ43WX5gSZMtL3GumCjdVlksbBU1eRwevY
         szkSUXrnBlJORC9Pb75bg8hVQjoobBJMhWBS5/ba1wK7/u4dn526NztlWvAo9jGltfOo
         xlCzfaPn+fADV4YK5FnX5iWxPzFTkTuYCgiGKxRvROtcZuZAxw9pekazE8Pc3KDUMjaU
         JDBA==
X-Gm-Message-State: APjAAAXeInbcKnprDS1s8OXbq+xyqBYezHfmjiS+AjgzPFguwlPPgQf/
        fOAM6Zz3z5IxhlyoGn/vv08iVg==
X-Google-Smtp-Source: APXvYqyQ34UvXuGe4aPKC+2q6fzKQqgV7Z9PAHruHmKWW+MYXtNBKn6PeSYA71uGnfIvpgopfCLo0A==
X-Received: by 2002:a65:680f:: with SMTP id l15mr39672197pgt.307.1577210174325;
        Tue, 24 Dec 2019 09:56:14 -0800 (PST)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id l22sm4410433pjc.0.2019.12.24.09.56.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 24 Dec 2019 09:56:13 -0800 (PST)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        simon.horman@netronome.com, willemdebruijn.kernel@gmail.com
Cc:     Tom Herbert <tom@quantonium.net>, Tom Herbert <tom@herbertland.com>
Subject: [PATCH v7 net-next 1/9] ipeh: Fix destopts counters on drop
Date:   Tue, 24 Dec 2019 09:55:40 -0800
Message-Id: <1577210148-7328-2-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577210148-7328-1-git-send-email-tom@herbertland.com>
References: <1577210148-7328-1-git-send-email-tom@herbertland.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@quantonium.net>

Bump IPSTATS_MIB_INHDRERRORS when extension header limit is exceeded.

Only take net from skb->dev, don't use dst for counters.

Signed-off-by: Tom Herbert <tom@herbertland.com>
---
 net/ipv6/exthdrs.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index ab5add0..e7eacc4 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -276,28 +276,25 @@ static const struct tlvtype_proc tlvprocdestopt_lst[] = {
 
 static int ipv6_destopt_rcv(struct sk_buff *skb)
 {
-	struct inet6_dev *idev = __in6_dev_get(skb->dev);
 	struct inet6_skb_parm *opt = IP6CB(skb);
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
 	__u16 dstbuf;
 #endif
-	struct dst_entry *dst = skb_dst(skb);
 	struct net *net = dev_net(skb->dev);
 	int extlen;
 
 	if (!pskb_may_pull(skb, skb_transport_offset(skb) + 8) ||
 	    !pskb_may_pull(skb, (skb_transport_offset(skb) +
 				 ((skb_transport_header(skb)[1] + 1) << 3)))) {
-		__IP6_INC_STATS(dev_net(dst->dev), idev,
-				IPSTATS_MIB_INHDRERRORS);
-fail_and_free:
 		kfree_skb(skb);
-		return -1;
+		goto fail;
 	}
 
 	extlen = (skb_transport_header(skb)[1] + 1) << 3;
-	if (extlen > net->ipv6.sysctl.max_dst_opts_len)
-		goto fail_and_free;
+	if (extlen > net->ipv6.sysctl.max_dst_opts_len) {
+		kfree_skb(skb);
+		goto fail;
+	}
 
 	opt->lastopt = opt->dst1 = skb_network_header_len(skb);
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -316,7 +313,9 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 		return 1;
 	}
 
-	__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
+fail:
+	__IP6_INC_STATS(dev_net(skb->dev), __in6_dev_get(skb->dev),
+			IPSTATS_MIB_INHDRERRORS);
 	return -1;
 }
 
-- 
2.7.4

