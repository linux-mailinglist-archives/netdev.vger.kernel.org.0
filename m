Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D795641D8FB
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350627AbhI3Lld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350594AbhI3Ll0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:41:26 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87995C061777
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:35 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id l8so21221345edw.2
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ce3l0OvB2Gpoh3gPrIu9QlxGlLt5g5zxnFHEz7aNjwQ=;
        b=hz3Jady3OVGlfHpvZHNUoiZmWgUBHYUqZoRmjXAQBRz+wYkm9+sej2tbdZ2Ejm0Pho
         NRS9KwvKcICtV1kUCxth0Qg1qlAm4z3y1SpImbFfmeGnhz6sd1vDblcYdoXD/VZnAAH1
         8RQ1AKd4FT9XUB+xNxOBm4DJauo4LD/sqnB6gfeSdXgY5qehVje1MgVQdAv5YU1hmaBd
         Ura74OmAc0gnRp3MYXZGcqowuvXwvSWVGnMDZOJcv7f6kzHjxv23kziQZ6Bbd20zn8P5
         H57X0gdxQE3qnMd4bedKJbuB3pISBWFCbQgV6MR+hrOT+SzJlNnC4h8JceG8QMswtqOP
         lZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ce3l0OvB2Gpoh3gPrIu9QlxGlLt5g5zxnFHEz7aNjwQ=;
        b=boXS/2tzmJOpwFWh4r4TdRcNeFU79cLsZcoq+SyXy+bijNS+LkdWo3Nm/dkZADdKO5
         ZfJq7S4AblhLQtMtkeMCFRGmXSEe6bM0cZR88tvb6boTCBnDWYKzeMo7Tqxe8oNMhRzS
         Fc+6tSbvfUgF4N7nKlkwLvezLVDszVXIU1iIm+SvbfE3uq1L3G8KVr/pRI9Xr4y8WJF+
         gXDqJ2oTBL4SQQrw3XfjYOeg507e1biQf+0evwhzMemQPswOj+Jsi2fQFgcDgs5KZpfN
         q3iKOIt29Q37bUaQAx55IvsceIYcStbwsyNII0nXwb5diuOSYbhOl1+jI/0sQWDjxKyM
         a36A==
X-Gm-Message-State: AOAM532hB+BNPKDWh8eoCDYANPVSjnMblLN3Vr/hhumP2xwKoTSwa8lH
        YqZvmF34wgeZP21TCus65U9gsQvVUWHY/JqB
X-Google-Smtp-Source: ABdhPJyuM4wQCjR8ZV4BKAc6IZalZWX1KKXL1+e8TsuMULpNDLvnRxtRsrnVTfChVGCBRvp+7GYSpA==
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr6629156edd.135.1633001973765;
        Thu, 30 Sep 2021 04:39:33 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b27sm1277704ejq.34.2021.09.30.04.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:39:33 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 11/12] ip: route: print and cache detailed nexthop information when requested
Date:   Thu, 30 Sep 2021 14:38:43 +0300
Message-Id: <20210930113844.1829373-12-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930113844.1829373-1-razor@blackwall.org>
References: <20210930113844.1829373-1-razor@blackwall.org>
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

