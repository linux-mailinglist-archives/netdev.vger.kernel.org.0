Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CDC41C871
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345345AbhI2PcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345322AbhI2Pbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:31:47 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B47C061768
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:30:03 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id dn26so10078207edb.13
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ce3l0OvB2Gpoh3gPrIu9QlxGlLt5g5zxnFHEz7aNjwQ=;
        b=KN8K86dhnTe6GLUqnMgmAAjcZPVRvdDAgcBXCBKlaonSq6jIFHD/gJH98/dWGpzC4M
         1gouCe9EqPUZLIPp33803YeXC6h3TG4P+uS08IvWiwN5p6qyL8KmCCafXBNF7UXMnamI
         8RHvDrZG5EkcdjB1mu6Kn/nL0rvgoe5MUvOyCyUXXKSGcyc/3YFsUtdTncmUcD1FdQf3
         BaduBe3sYyzQYJMxNxgeVumWqUTquHniueoyRgsF4IYtrVLhVAoGM4zXUiSQg39+5zxm
         Mj0FwwmtqytPp3+OwE6WIsuRd1DGnmMzNab0F7OPlNK9KK8fhgkNLvUnF+37B2SQo98f
         ZQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ce3l0OvB2Gpoh3gPrIu9QlxGlLt5g5zxnFHEz7aNjwQ=;
        b=uNsdSikD9UFruolYkCscaWMWaTcJSJrmVlmJCLo6zn6kgR9LVxfzRXRF7H1ld86tmb
         orWX9n4I5GnSvtNi10l5wRM40I1Ds+3D7ovM9lChuWzeKdeOytpPAYGr9uOKOS4ZafOS
         lyFKmhq7T9red761PCBuNUH2F54rU2fT1UgbgtbPgYow7otDgdW0nlUwVztceNGO6IB9
         Jf42/MR2BnYPWLQjnVIvx+VyqOJX4kuhoR6e9xqbfqxITJVs2eAhVvBhhDO8QDvfk2EH
         mUShk6geTxIFRYD7X/3UFZh0ku84mDZGMLyRrA+2tYruwmX3UE9gtjYZzXBb8OWgX2Wh
         E4XQ==
X-Gm-Message-State: AOAM532+i9IOZsacK9HASY3MI67cfO9lAlIghANZRv6WgGEhn0BcLo3o
        +r4cvtfzdlaXr1O68yUFsNu/3pFNg7lw7xUl
X-Google-Smtp-Source: ABdhPJyd9H/46xsf5pxs0MzehG7hAIQnjmv/85Eo5ZA6dsLfrKtpLon77V+AXH0ZPM3+mWzbWsevJg==
X-Received: by 2002:a50:cfc1:: with SMTP id i1mr536962edk.251.1632929344277;
        Wed, 29 Sep 2021 08:29:04 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q12sm108434ejs.58.2021.09.29.08.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 08:29:03 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC iproute2-next 10/11] ip: route: print and cache detailed nexthop information when requested
Date:   Wed, 29 Sep 2021 18:28:47 +0300
Message-Id: <20210929152848.1710552-11-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929152848.1710552-1-razor@blackwall.org>
References: <20210929152848.1710552-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

If -d (show_details) is used when printing/monitoring routes then print
detailed nexthop information in the field "nh_info". The nexthop is also
cached for future searches.

Output looks like:
 unicast 198.51.100.0/24 nhid 103 table 3 proto boot scope global
	 nh_info id 103 group 101/102 type resilient buckets 512 idle_timer 0 unbalanced_timer 0 unbalanced_time 0 scope global proto unspec
	 nexthop via 169.254.2.22 dev veth2 weight 1
	 nexthop via 169.254.3.23 dev veth4 weight 1

The nh_info field has the same format as ip -d nexthop show would've had
for the same nexthop id.

For completeness the JSON version looks like:
 {
        "type": "unicast",
        "dst": "198.51.100.0/24",
        "nhid": 103,
        "table": "3",
        "protocol": "boot",
        "scope": "global",
        "flags": [ ],
        "nh_info": {
            "id": 103,
            "group": [ {
                    "id": 101
                },{
                    "id": 102
                } ],
            "type": "resilient",
            "resilient_args": {
                "buckets": 512,
                "idle_timer": 0,
                "unbalanced_timer": 0,
                "unbalanced_time": 0
            },
            "scope": "global",
            "protocol": "unspec",
            "flags": [ ]
        },
        "nexthops": [ {
                "gateway": "169.254.2.22",
                "dev": "veth2",
                "weight": 1,
                "flags": [ ]
            },{
                "gateway": "169.254.3.23",
                "dev": "veth4",
                "weight": 1,
                "flags": [ ]
            } ]
 }

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/iproute.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/ip/iproute.c b/ip/iproute.c
index 3c933df4dd29..8532b5ce315e 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -28,6 +28,7 @@
 #include "rt_names.h"
 #include "utils.h"
 #include "ip_common.h"
+#include "nh_common.h"
 
 #ifndef RTAX_RTTVAR
 #define RTAX_RTTVAR RTAX_HOPS
@@ -968,6 +969,10 @@ int print_route(struct nlmsghdr *n, void *arg)
 				     propagate ? "enabled" : "disabled");
 	}
 
+	if (tb[RTA_NH_ID] && show_details)
+		print_cache_nexthop_id(fp, "\n\tnh_info ", "nh_info",
+				       rta_getattr_u32(tb[RTA_NH_ID]));
+
 	if (tb[RTA_MULTIPATH])
 		print_rta_multipath(fp, r, tb[RTA_MULTIPATH]);
 
-- 
2.31.1

