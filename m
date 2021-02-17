Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D49231DED2
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 19:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhBQSI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 13:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhBQSIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 13:08:53 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0E1C061786
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:08:12 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id t11so8972736pgu.8
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TrX1T47rpnOsKpdHaCeKXRVaeQNpP+K3spEqPXN+7r0=;
        b=Wd2EUxsW4/AF+UUmIvrHr04egQihLwvlQ/XKaBzqlQ3oh2Rw/LxcgoxM7gR+F67csS
         znaCol9fr/banJtu0Jo7WT+uRCOVnXODWH830cSZF+unb0pYGdjhukapglEYGisWFIHh
         QQUEgHwOMPNFu5lNDWM5qlEL76qvSYSdfrHrhGgK39oasQfr7oJgw72/kMQO7YDqoNBE
         +N+ZiubZJCwdRYfMVOcgHXkCNkjHmihd1iYP7bxbLZXdnlUQNq3WuhtwDuFkMZeeqbOI
         j17ugd1+PdWzsYG/1K1BfpHl4v1QqqnrTnXGF5BHtgWnTy4BK6jl/S0f3hZAK/k2P/f8
         etWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TrX1T47rpnOsKpdHaCeKXRVaeQNpP+K3spEqPXN+7r0=;
        b=beGKxSf222OMVbcLG7F9PJQLXwvv0kfPrHcfGshfRi+PbSYvbs/zKUGkgzIBcUR4ki
         LY5UnPrFrZc+l+HcQC/8kqRpkhl3/R6OwJD85Na93DiR0Mg0kODv3HEaGj5IsgA0YkGX
         G1nVnYfCStTxfvOWbz0YP6b3M36+wuzZ5xbwEbrtyXacFhsKzDp/NaK16djK5nqts8DI
         Ji0gFcNX4vsZyym/nWcBsJTjaFMR2ThQpTALkpJRjzQua7INjnFKikqyK6yh6fDBVHiH
         uS/wVC6iB4MXtYlit7bdd6/Fkf062VMPE949hr+Z07EMZhbvVz1UzDd/5D9lNJjQ5PqF
         3uzg==
X-Gm-Message-State: AOAM531lXPObM18wrEUUoizwxPSsMR3G8CWMpWtQngPS4e+NGJQLRF9S
        wUxAc3n/0IlGk+Qqm9uAmIU=
X-Google-Smtp-Source: ABdhPJwAEf7kh04WdHU0/gWRjAd0mglw1LVBp2Q77pr5Lvx6iniKHFGWedJfCt/v8u8IgiBJNc2/Qw==
X-Received: by 2002:a63:cc05:: with SMTP id x5mr523347pgf.254.1613585290877;
        Wed, 17 Feb 2021 10:08:10 -0800 (PST)
Received: from localhost.localdomain (h134-215-166-75.lapior.broadband.dynamic.tds.net. [134.215.166.75])
        by smtp.gmail.com with ESMTPSA id q15sm2820084pja.22.2021.02.17.10.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 10:08:10 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH V3 net-next 3/5] net: add sysctl for enabling RFC 8335 PROBE messages
Date:   Wed, 17 Feb 2021 10:08:09 -0800
Message-Id: <4061fa49b789385eb6de616128c8472dacce9896.1613583620.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
References: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Section 8 of RFC 8335 specifies potential security concerns of
responding to PROBE requests, and states that nodes that support PROBE
functionality MUST be able to enable/disable responses and it is
disabled by default. 

Add sysctl to enable responses to PROBE messages. 

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes since v1:
 - Combine patches related to sysctl into one patch

Changes since v2:
Suggested by Willem de Brujin <willemdebrujin.kernel@gmail.com>
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
2.25.1

