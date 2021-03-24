Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E210348043
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 19:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbhCXSS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 14:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbhCXSSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 14:18:03 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367F5C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:18:03 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id y19-20020a0568301d93b02901b9f88a238eso23911622oti.11
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GIz2Ptd4zKdP/hveDJ9Ox2s4W0sXpgyIYI77/Jp1I5E=;
        b=TTEYA7Q+WZynb4uZMEKSWTVwfFVND4hIJbhvYEcUXTsAlCFVz533OBEyuxcInG0KJj
         TB7nkS54oHNNWV0qcgpKyaD5oA6Ar/ItfHnrFRSi7/7JytVYC2tpTBwUBxgMvKedJHPT
         HNvc55HIAr/d7o1ObZ1D6Stzc1LrxotbVPPUGXPUpriQ+KpgK3ONg+D5BMlQwZpRer7i
         pn/yrlp8mtLUpiWFz97/xAsoUG3uEOU6ciuOIxC9Iy3gBJH9jYWoBVmndp+XIXbKh1q1
         0ErC1oivo2F7yTB4e1ys68M3Q3z+y0l5m+kbvMqxWHtfIhq1NdUXFWZgF28ZrCf8Cwdq
         Iv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GIz2Ptd4zKdP/hveDJ9Ox2s4W0sXpgyIYI77/Jp1I5E=;
        b=NIPhu6zV73PeaOU9XnJMNzkTzLkvcN109686xfj5d1U2QhB0ke4PWxVRYhMeTU1ATo
         0k+U5ASKNMxreB17Mi/nzeflmFbQLCr0s3nlpjxQBVGH9ezy7PMyjXPBzPi02c1HMcmJ
         SmGQe+UeRlUoCMpzdltYkdCeQ0vmIfZe3kGqtiwax4+bZ9dmMQtHIEU6dEaCx5OaI5kR
         u1xTv6nGGIMd4wBlmJc1CRVZqx1GwU8wkk5BDXN6hliuwqnFhDXbcR254dgY9Qi7p4w2
         l1z13T/XKOc/pl516HojYaCI1nQNQUdbn3WC7V0fj8OedBdvacrnkSFSt3gJ4Nz8jIk8
         5rmg==
X-Gm-Message-State: AOAM532xhdFAEal8lMzQ2BES+eOB4JoaRxO0q5omkS6vXf3fRuseyeTN
        HQGt3af263i3PaYSmuFnxJ9xuC13QfY=
X-Google-Smtp-Source: ABdhPJynafuHruBxRlQHvJvj9kf1+yrsRJQw9QZ5moapku+n8qcDy6zHdVUwAYsHhjC1USjcU/I3lw==
X-Received: by 2002:a9d:6ad9:: with SMTP id m25mr4257410otq.267.1616609882506;
        Wed, 24 Mar 2021 11:18:02 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:abb9:79f4:f528:e200])
        by smtp.googlemail.com with ESMTPSA id f192sm545583oig.48.2021.03.24.11.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 11:18:02 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V5 3/6] net: add sysctl for enabling RFC 8335 PROBE messages
Date:   Wed, 24 Mar 2021 11:18:00 -0700
Message-Id: <e2dbe45a16bc613bdcfd93eec6cecaec75860fcf.1616608328.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
References: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Section 8 of RFC 8335 specifies potential security concerns of
responding to PROBE requests, and states that nodes that support PROBE
functionality MUST be able to enable/disable responses and that
responses MUST be disabled by default

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes:
v1 -> v2:
 - Combine patches related to sysctl

v2 -> v3:
Suggested by Willem de Bruijn <willemdebruijn.kernel@gmail.com>
 - Use proc_dointvec_minmax with zero and one
---
 include/net/netns/ipv4.h   | 1 +
 net/ipv4/sysctl_net_ipv4.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 70a2a085dd1a..362388ab40c8 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -85,6 +85,7 @@ struct netns_ipv4 {
 #endif
 
 	int sysctl_icmp_echo_ignore_all;
+	int sysctl_icmp_echo_enable_probe;
 	int sysctl_icmp_echo_ignore_broadcasts;
 	int sysctl_icmp_ignore_bogus_error_responses;
 	int sysctl_icmp_ratelimit;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index f55095d3ed16..fec3f142d8c9 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -599,6 +599,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
+	{
+		.procname	= "icmp_echo_enable_probe",
+		.data		= &init_net.ipv4.sysctl_icmp_echo_enable_probe,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
+	},
 	{
 		.procname	= "icmp_echo_ignore_broadcasts",
 		.data		= &init_net.ipv4.sysctl_icmp_echo_ignore_broadcasts,
-- 
2.17.1

