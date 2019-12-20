Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E18A0128596
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 00:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfLTXjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 18:39:23 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38708 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfLTXjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 18:39:23 -0500
Received: by mail-pg1-f193.google.com with SMTP id a33so5705722pgm.5
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 15:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3H5XZqaDC1mbheFPQAH51aSqmoBGxxCr4SkUcbX1YTI=;
        b=zhLy/VLcfEw91aScjJNQ/mMwcAFeEm//4DCexkaljSduRVV/Bkqa3lf3eXsJvQa4Um
         mDHPu/yILLv1zH+mAkoQVrQkRqC9HzZ0nwZmrK8VMs2FuqcPng9jQBUa25+t8iixJbiD
         wXF2ec7SnGRED1RTBBhHoraOLvfRaxAbGfaykLiU/AxFpMBZoc5upxQcT5d7Zs02edlK
         6IOjuxk3+8FToGPbJTcGzaWNaBhIPUzl1xs9vofCjQ0Jok5oSt3T7ztmDk/aQMe5Ex6b
         oAVp053MBQSJkj54oKHZ/lvCaDQ9wustedtJLGZjvJXONncKL/r95I8d2Nla+13TyJNK
         pnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3H5XZqaDC1mbheFPQAH51aSqmoBGxxCr4SkUcbX1YTI=;
        b=G5/gEq2IiMmc2fA6tDh4uEhY2Sw46oHROnMLaLsAEgTGE03Dje7STOqgNvviMdbEdc
         6R4mvHcT9Ny8S2p7xMkDaAA7rIEuVmm2vLZuJ3JmkjuygkxGM1h2obU7bPBxxi4xO5DY
         yaE1mspoQ3PAr/zzDIq8h2Iy5J3QOODCqbW81dHKkfCWSx8XvZ47ImzM9v7TQBm3gBDa
         K2IcLCHX1Wi6dDofsPTFrlyV6j+BAa1Vq7FyfadbljX1tdpYY5nFfGif4a7OYiqC6fFX
         XIewVWtNeKWhgPM4pMxDoTbyYEkdd4O5OonM4SJddVR+nmW57M3RVgkvueno50IeSvUu
         qDRw==
X-Gm-Message-State: APjAAAV4jTz70Io3JGmnNoOBrFU968azfKvwKl6zsi9tCXSdRqbdhaVd
        ppYSw1cF06MQZVFCXVkVFrfs8Q==
X-Google-Smtp-Source: APXvYqzz9QBjri38R3h5WSkyj5nIa8sgGsIhhsXDGdmgcHzxD9Sohk5vU1KIsrLE+hadrpZtHIFVBg==
X-Received: by 2002:aa7:982d:: with SMTP id q13mr17940599pfl.152.1576885162505;
        Fri, 20 Dec 2019 15:39:22 -0800 (PST)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id 207sm14833555pfu.88.2019.12.20.15.39.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 15:39:21 -0800 (PST)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        simon.horman@netronome.com
Cc:     Tom Herbert <tom@quantonium.net>, Tom Herbert <tom@herbertland.com>
Subject: [PATCH v6 net-next 1/9] ipeh: Fix destopts and hopopts counters on drop
Date:   Fri, 20 Dec 2019 15:38:36 -0800
Message-Id: <1576885124-14576-2-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576885124-14576-1-git-send-email-tom@herbertland.com>
References: <1576885124-14576-1-git-send-email-tom@herbertland.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@quantonium.net>

For destopts, bump IPSTATS_MIB_INHDRERRORS when limit of length
of extension header is exceeded.

For hop-by-hop options, bump IPSTATS_MIB_INHDRERRORS in same
situations as for when destopts are dropped.

Signed-off-by: Tom Herbert <tom@herbertland.com>
---
 net/ipv6/exthdrs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index ab5add0..f605e4e 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -288,9 +288,9 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 	if (!pskb_may_pull(skb, skb_transport_offset(skb) + 8) ||
 	    !pskb_may_pull(skb, (skb_transport_offset(skb) +
 				 ((skb_transport_header(skb)[1] + 1) << 3)))) {
+fail_and_free:
 		__IP6_INC_STATS(dev_net(dst->dev), idev,
 				IPSTATS_MIB_INHDRERRORS);
-fail_and_free:
 		kfree_skb(skb);
 		return -1;
 	}
@@ -820,8 +820,10 @@ static const struct tlvtype_proc tlvprochopopt_lst[] = {
 
 int ipv6_parse_hopopts(struct sk_buff *skb)
 {
+	struct inet6_dev *idev = __in6_dev_get(skb->dev);
 	struct inet6_skb_parm *opt = IP6CB(skb);
 	struct net *net = dev_net(skb->dev);
+	struct dst_entry *dst = skb_dst(skb);
 	int extlen;
 
 	/*
@@ -834,6 +836,8 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
 	    !pskb_may_pull(skb, (sizeof(struct ipv6hdr) +
 				 ((skb_transport_header(skb)[1] + 1) << 3)))) {
 fail_and_free:
+		__IP6_INC_STATS(dev_net(dst->dev), idev,
+				IPSTATS_MIB_INHDRERRORS);
 		kfree_skb(skb);
 		return -1;
 	}
@@ -850,6 +854,7 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
 		opt->nhoff = sizeof(struct ipv6hdr);
 		return 1;
 	}
+	__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
 	return -1;
 }
 
-- 
2.7.4

