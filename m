Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE483FA490
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 11:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhH1IoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 04:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhH1IoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 04:44:09 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9F3C0613D9
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 01:43:18 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id t42so7820291pfg.12
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 01:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2nqfBMF2wXARY3kNV0Lpt3bfQVireleerfhBJGuI2Sg=;
        b=ViAHzXN9r/M5PHWF2fsRvTMxz/tb8vYq4hHnB34jOK//hqE1we1NBlDzFZ1IArPV8r
         eGbVPS02gkKSFVjJTtoiDmMQng8f1dK1HKNiN6vAaGbqaUq9sBLVGnKmEKK/ljVwqZpn
         2NHEQSmeTA0DmJ+RyKoJXzwVIUyQyXq0LWgv9saER6cNvcrnX6zZ0vNv5tmDimJHx1hm
         o+a0MMiHtrPcqsjRTmSHtlq8KiN8k0/VMWK8GVfoZ6qLLE06a/3Z1A1/tPmyLLfOTydw
         m6NlLHv/uTuHGrOgtO9I2slDsUBdbnwoFl/iGUnBxc1VTX4oEKtoiJhFSHRyf0OcPCkA
         vqGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2nqfBMF2wXARY3kNV0Lpt3bfQVireleerfhBJGuI2Sg=;
        b=OQkuteZU7j2gFJ2eTfa/oE1x+mYtw8C6pbF/+ZopXLt4c4QouO/T1nhyPaiVp6Oc7L
         4C4NqUZICyNA+r4FLm9n6TSbgaYvq1exUIm0uDt31XiPrSU0gAQTllMjdkIpLMqf4+TA
         FSL3qn3vqKTAiMYs1t/Fw1u2x2jXKGARLnFvL++lFq2eoDH50TVMewONWLnt+Q5GX+1P
         YxPye84uNLqTLHmHpAoeEL3UvKquUDTBMsgIft9Y/5KAhncM4aQTEkAJmGcRMBORErW7
         6nAB21a8ThbTEuY7SA52jHwYwwS0dkRlH22+KIG5HYs62skZuCLW4XCSG4rr8w593zwn
         N/rw==
X-Gm-Message-State: AOAM530xd2sabOnRv8hKH5Xo5elwSVflWz0JEHvq2FKAp4dT6Kr6ut+R
        BTB8chadSTdv/Udb5Gj6XWs=
X-Google-Smtp-Source: ABdhPJycqjuPjrmGLYVLdbgFlgtrS0btqqe24+XYH8GCKBZZWqUPm2w0M7sWwZ8UJSDtjXE9eN576Q==
X-Received: by 2002:a65:51c7:: with SMTP id i7mr11423026pgq.300.1630140198091;
        Sat, 28 Aug 2021 01:43:18 -0700 (PDT)
Received: from localhost.localdomain ([223.62.190.153])
        by smtp.googlemail.com with ESMTPSA id v20sm9623353pgi.39.2021.08.28.01.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 01:43:17 -0700 (PDT)
From:   shjy180909@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, nikolay@nvidia.com,
        MichelleJin <shjy180909@gmail.com>
Subject: [PATCH net-next] net: bridge: use mld2r_ngrec instead of icmpv6_dataun
Date:   Sat, 28 Aug 2021 08:43:07 +0000
Message-Id: <20210828084307.70316-1-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: MichelleJin <shjy180909@gmail.com>

using icmp6h->mld2r_ngrec instead of icmp6h->icmp6_dataun.un_data16[1].

Signed-off-by: MichelleJin <shjy180909@gmail.com>
---
 net/bridge/br_multicast.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 2c437d4bf632..8e38e02208bd 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2731,8 +2731,8 @@ static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
 	struct net_bridge_mdb_entry *mdst;
 	struct net_bridge_port_group *pg;
 	unsigned int nsrcs_offset;
+	struct mld2_report *mld2r;
 	const unsigned char *src;
-	struct icmp6hdr *icmp6h;
 	struct in6_addr *h_addr;
 	struct mld2_grec *grec;
 	unsigned int grec_len;
@@ -2740,12 +2740,12 @@ static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
 	int i, len, num;
 	int err = 0;
 
-	if (!ipv6_mc_may_pull(skb, sizeof(*icmp6h)))
+	if (!ipv6_mc_may_pull(skb, sizeof(*mld2r)))
 		return -EINVAL;
 
-	icmp6h = icmp6_hdr(skb);
-	num = ntohs(icmp6h->icmp6_dataun.un_data16[1]);
-	len = skb_transport_offset(skb) + sizeof(*icmp6h);
+	mld2r = (struct mld2_report *) icmp6_hdr(skb);
+	num = ntohs(mld2r->mld2r_ngrec);
+	len = skb_transport_offset(skb) + sizeof(*mld2r);
 
 	for (i = 0; i < num; i++) {
 		__be16 *_nsrcs, __nsrcs;
-- 
2.25.1

