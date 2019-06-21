Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 112714DE1B
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 02:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfFUAhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 20:37:05 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40631 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfFUAhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 20:37:04 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so2444006pgj.7
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZBRiDHj2Qi4Q8hZbrg7ij7OVMKRMOh5DuaaYEMelFvk=;
        b=AKVAXKUz6aU7iCHDWbaTt8ZiAvLAp81zE1Sjmob5+mTbxfsd8NoE+iQSaFeT3tuhdv
         6MY02xLnxrcVitHQRD/8tIpJ7SOKbNWB+HqP2wbSwKghBeocLicZxaBhTpwMX0CUaqb5
         SvcT5xXQtGA6314RRnNNtl+GUx8WB2o8ZHKBXehrbCrcDwvgYW5YJ2+1liZvk9SH2WxA
         rb6Fd4Ovl9UzfBUz/UyiT/Rf3Zw9Hg7fhp0VLfDfVUr1+CknAUd/v+j6NkChC68A7yWk
         kOQKZtO902W1WUQobLmkuUG5d7XVRD3At7TJzDHMdCXz+SCgz2LrU+eFZQOJONHmfex5
         0UHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZBRiDHj2Qi4Q8hZbrg7ij7OVMKRMOh5DuaaYEMelFvk=;
        b=sqjxEhRqtuemQUAguPqRL4fktqJB2XGJviSKZkj1mcOgzBmemM1y6X4XwwGHp0WjuV
         ySA/Lo14CxxUciG2bEARQg2DAYspqSTJTv3A7MrRhkMxfEx85oIe+HGGOFk9G3DwNuhn
         Jen6xlvN1diSaObOKUkHnhWbNJKZYUOPDiCd+urbJXgD+LmOItxAPbnez/WlHT6yzJkT
         nOyS+HpYXGs+TyNu/nKoPr141/+j0SKLb5x1djfJqRcLZF4hbLp2BPQUOank1M73mJYp
         74kFgghp5E1ViYXwn2LlhYLi+NaxTUFEOyb+tNIVAwGiPJZETsOS0gBmepi34KM8rRkk
         ZGPg==
X-Gm-Message-State: APjAAAVcTx/nYCrUqhcQIkNa428o6sUQmV15SZBGVjarxxDD+gDJRAns
        UuGExsfNOVaQgNamVyFakhA=
X-Google-Smtp-Source: APXvYqznW8jiRtmj7t29rpZ/rXAwqfIlfLRG4Fg46+azTfuvwz8oihkA9LpT5ictH/PXziCZ+o5uMQ==
X-Received: by 2002:a63:474a:: with SMTP id w10mr14748858pgk.352.1561077423575;
        Thu, 20 Jun 2019 17:37:03 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id 2sm588206pff.174.2019.06.20.17.37.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 17:37:02 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Wei Wang <weiwan@google.com>
Subject: [PATCH v3 net-next 2/5] ipv6: initialize rt6->rt6i_uncached in all pre-allocated dst entries
Date:   Thu, 20 Jun 2019 17:36:38 -0700
Message-Id: <20190621003641.168591-3-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190621003641.168591-1-tracywwnj@gmail.com>
References: <20190621003641.168591-1-tracywwnj@gmail.com>
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

