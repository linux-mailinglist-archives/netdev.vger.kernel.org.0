Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3EE4C3A2
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 00:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbfFSWcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 18:32:15 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42239 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfFSWcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 18:32:14 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so460276plb.9
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 15:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZBRiDHj2Qi4Q8hZbrg7ij7OVMKRMOh5DuaaYEMelFvk=;
        b=HUY5aA6y1auGd5N/OSsL/rBwJnGsrQYOGAwPeHKlmTfAI0QYoF6b59g5VZmZ3Mm4+t
         jTFje7J4DNxxy0pZ94KFlankJ5GzjssHmGD+B8SBvLWo+piDvk/tz3hRaTgvLGRRdZl9
         YnIeQAtTXJ6DVTZV21gsmlKG5SwNUvfFuyOXLPVoJoStIgOB0xV+uW5F7eX2kJGKTKqP
         MnD29HCKLPd3T9qCKGiij2gMfFF2Sx5sS3lbyu/pTBcvkFPO7aeG0eKHSVhmAPFf08dA
         GfhRpmaXEegxcnWLzb4O3qo9ttXSS5h4Ic85RB7I/cL5Rxbj1iDsmtRxRTKbhO2SbwRg
         T4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZBRiDHj2Qi4Q8hZbrg7ij7OVMKRMOh5DuaaYEMelFvk=;
        b=Xu8QwmS65V7NKR2U6o4dmSUPu52OFRyrlYLEbhHALKyvS5yUTiK5E/Cdf0SKQKfGJw
         wvM1MmHiDnxjfWOetd6nylfsoKTjerFRtJLEtWLd8EeEMHkCYlJHkN8dsnLr0rOy5ICW
         SyWFFRunB0woaWpnaq3xZN8IzVne9DayTp/64UAiT49EAQaY/yAU/skfvP577BYOeV2r
         +60rKsROiVexNE3QEZefCA1DJGVhzAYjKhAiEYwoUwXPpSYEGCcv5cL3srZd+lHpVWbI
         MfKzyBDCwD5juIC7KrZyyOSbmjEFxbUE6JCKqW2VrEXipk4cgKQm0n5zfuInRBU3jSwi
         TkyA==
X-Gm-Message-State: APjAAAX5yyw0J35PLo8GP+hBh40xdI+MFbvkdec2aS/nC+knHMzKhwda
        yg/GAWHoBOnvdFHq0OddTyw=
X-Google-Smtp-Source: APXvYqzaF6BlpRd0ly+G8f4Dz1zTc5bm7pIaCfYpzaBlGwgJtVlpaUhBfbtSRSirWl+sRplK2wZiLA==
X-Received: by 2002:a17:902:aa0a:: with SMTP id be10mr115480053plb.27.1560983533625;
        Wed, 19 Jun 2019 15:32:13 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id g8sm20037687pgd.29.2019.06.19.15.32.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 15:32:12 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>, Wei Wang <weiwan@google.com>
Subject: [PATCH v2 net-next 2/5] ipv6: initialize rt6->rt6i_uncached in all pre-allocated dst entries
Date:   Wed, 19 Jun 2019 15:31:55 -0700
Message-Id: <20190619223158.35829-3-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190619223158.35829-1-tracywwnj@gmail.com>
References: <20190619223158.35829-1-tracywwnj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>

Initialize rt6->rt6i_uncached on the following pre-allocated dsts:
net->ipv6.ip6_null_entry
net->ipv6.ip6_prohibit_entry
net->ipv6.ip6_blk_hole_entry

This is a preparation patch for later commits to be able to distinguish
dst entries in uncached list by doing:
!list_empty(rt6->rt6i_uncached)

Signed-off-by: Wei Wang <weiwan@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
---
 net/ipv6/route.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 9dcbc56e4151..33dc8af9a4bf 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6010,6 +6010,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 	net->ipv6.ip6_null_entry->dst.ops = &net->ipv6.ip6_dst_ops;
 	dst_init_metrics(&net->ipv6.ip6_null_entry->dst,
 			 ip6_template_metrics, true);
+	INIT_LIST_HEAD(&net->ipv6.ip6_null_entry->rt6i_uncached);
 
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 	net->ipv6.fib6_has_custom_rules = false;
@@ -6021,6 +6022,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 	net->ipv6.ip6_prohibit_entry->dst.ops = &net->ipv6.ip6_dst_ops;
 	dst_init_metrics(&net->ipv6.ip6_prohibit_entry->dst,
 			 ip6_template_metrics, true);
+	INIT_LIST_HEAD(&net->ipv6.ip6_prohibit_entry->rt6i_uncached);
 
 	net->ipv6.ip6_blk_hole_entry = kmemdup(&ip6_blk_hole_entry_template,
 					       sizeof(*net->ipv6.ip6_blk_hole_entry),
@@ -6030,6 +6032,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 	net->ipv6.ip6_blk_hole_entry->dst.ops = &net->ipv6.ip6_dst_ops;
 	dst_init_metrics(&net->ipv6.ip6_blk_hole_entry->dst,
 			 ip6_template_metrics, true);
+	INIT_LIST_HEAD(&net->ipv6.ip6_blk_hole_entry->rt6i_uncached);
 #endif
 
 	net->ipv6.sysctl.flush_delay = 0;
-- 
2.22.0.410.gd8fdbe21b5-goog

