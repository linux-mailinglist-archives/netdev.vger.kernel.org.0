Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F0D33A6EB
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 17:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbhCNQsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 12:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbhCNQsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 12:48:35 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ACEC061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 09:48:34 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 18so5129853pfo.6
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 09:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GIz2Ptd4zKdP/hveDJ9Ox2s4W0sXpgyIYI77/Jp1I5E=;
        b=SMMG3Sv+4cUZBBkxcNVzQQuaHz7/TFZq7GWlkkVjo75DzCoIEjE9OjmMNBH6XhXTLl
         mCZfgBCK5e8R+RmS4LPpfTJc0sM5SmzCedPEAxtOdwiBI5tWVK6MpM+8RNnb5bL7N7oC
         ZyXy08bRmze2vysVldo7GOGuID6B7sgQl7RRj9fkeGw1PZA3H6xiKaUxfCEKay9+n0yV
         +nY5O0HXAN/bbi+bbrHOSPChF45cEGro72u5jZkLPihI/OfQctq/3tZjW7QTxouVx0aw
         KXgWDeR7sJlw3lwwIdtmP6r2fLslLEc9gcP/NEe3Kt5y4FN+bJjCil+kJ/Z8kITmy4DI
         6DPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GIz2Ptd4zKdP/hveDJ9Ox2s4W0sXpgyIYI77/Jp1I5E=;
        b=AfOsG+gclQe+weB1jtAIK6NKh8pf210+FIUU0kNSDHjr0Vb/JDL38CnGJbNdeMinbI
         5NzKQ7w33G6SEkpts7/063WtQFvKWGVNWSXWNGhyuQR3eunR9TwbFIwMNVh4xe72cRc/
         EOVE+0IX7VVBarvJIq4GVMyTgB9pgSnKVDkWOLzUJz18ZR4+Pu5FzJvbnrTpAiV9UyCz
         HvuLSKjkjxAPmN53H2Ez2QpZWmgeujqzW8dHvahkSNrP+TNWuHPUS3lx54KzQqkqVPZc
         rxfFWTqyVaTb3FAkXc3RoNFh9CtIkDM/NWCsxoAWXMc0L/78Cwl/ywgqfWSmE0eUYMur
         iazg==
X-Gm-Message-State: AOAM5318FCPH/sY3cK7Ygadu2Q5lyqVDt2UQcklK+iRGGviF67a539G3
        kLjBk53FdI/J/bF7YZ2zy4U=
X-Google-Smtp-Source: ABdhPJzRdv5ng8szg4YfR02lfiuz5ECjQ14piK46nuPXJMPvUIJaRMFyLpZUxltuB1aIzxbg6YW9wQ==
X-Received: by 2002:a62:e708:0:b029:1f8:c092:ff93 with SMTP id s8-20020a62e7080000b02901f8c092ff93mr6978130pfh.21.1615740514529;
        Sun, 14 Mar 2021 09:48:34 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:ed7e:5608:ecd4:c342])
        by smtp.googlemail.com with ESMTPSA id i17sm12069071pfq.135.2021.03.14.09.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 09:48:34 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH V4 net-next 3/5] net: add sysctl for enabling RFC 8335 PROBE messages
Date:   Sun, 14 Mar 2021 09:48:31 -0700
Message-Id: <d51e9d7c27c63992cbc863ca7f0f308654fadc54.1615738431.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1615738431.git.andreas.a.roeseler@gmail.com>
References: <cover.1615738431.git.andreas.a.roeseler@gmail.com>
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

