Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F313912AF6D
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 23:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfLZWwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 17:52:05 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:55264 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfLZWwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 17:52:05 -0500
Received: by mail-pj1-f66.google.com with SMTP id kx11so3921005pjb.4
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 14:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2pxfWsOyN98zPcHCWeUaOs+QOyO1VA5VcJEGHF3CYZg=;
        b=MrW/+63edbHiPVBfoQT0Gw/2WoMOpsX0lIaURrf9N57sGRNegECBZZAbSBp8AOxYgA
         OgdAZkcTq1H162IaI5Pw1VIpiQd0HpC1DYc25D4XkFhMZCYOIo3lSdV9CyKgcLkH4pZD
         XR7ZnkZMZ+LiMXyurBmvaT6kynzxlHjBqzb8W7nUG3UUKOOPugGjJCon/N5zfYAc9/xT
         yTGXKvovkGc1a7qcK9NTf1WI3x8tKJ1rIYE3jv3Ved26WdtxXXEn9tVUgeHmJvSIbCI/
         GyjWU/Zv031pdDx+BTUf+DzZzpJS81e2jllPsFSxzf188mT28Z/sDM6R35i06b8+22lG
         5TCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2pxfWsOyN98zPcHCWeUaOs+QOyO1VA5VcJEGHF3CYZg=;
        b=FB/PcLyZEhfIItlqMwIBHlf1l7Xba49GavqYvjNPU8mjPPC3U/mr+MkYIyY7W80jJr
         w49JLysuq4GlpyM/dpBBXFMYVbV7kPv781z/PApO9eqT0VdkA6tzlPkCiPH+0CVBnpj8
         05ufLSDt3zwbUmq9pWwjBibXh7EUs4juy3hUN4Ay2a6OCgJJqtHrlkC0oXPD0ttHXECu
         uUS/jCBSwoDhGjqbGczPY2yyUn4sKZgcv3qRzWAgSSnXzXAMccHnHoXKdP5cq8fhz/eo
         Lel4du2cJZ7iM4H8dSB3GVJPZROpPe2xlmwUag9TBHho4jkILsZZ+lZHVUo1U9LiXVbm
         Gm6g==
X-Gm-Message-State: APjAAAXxhdZFqvcwcFpvV8YKwTAYmA+Mrboj3ZCD9ft6yOz5TgVwhtXJ
        uS0xUovQiEirvGEh4ZNpfLjPYA==
X-Google-Smtp-Source: APXvYqzZOzl3pldi20O8weuRqSvQ2afL68AxuKG5z043ozvSzKJ8ESo9O6uUf1RO1v3UzbkCTFnH2Q==
X-Received: by 2002:a17:902:9b8e:: with SMTP id y14mr25089282plp.280.1577400724761;
        Thu, 26 Dec 2019 14:52:04 -0800 (PST)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id z13sm11884601pjz.15.2019.12.26.14.52.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 26 Dec 2019 14:52:04 -0800 (PST)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        simon.horman@netronome.com, willemdebruijn.kernel@gmail.com
Cc:     Tom Herbert <tom@quantonium.net>, Tom Herbert <tom@herbertland.com>
Subject: [PATCH v8 net-next 1/9] ipeh: Fix destopts counters on drop
Date:   Thu, 26 Dec 2019 14:51:30 -0800
Message-Id: <1577400698-4836-2-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577400698-4836-1-git-send-email-tom@herbertland.com>
References: <1577400698-4836-1-git-send-email-tom@herbertland.com>
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

