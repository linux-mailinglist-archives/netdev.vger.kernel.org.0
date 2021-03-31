Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEA53505CD
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 19:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhCaRwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 13:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbhCaRwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 13:52:18 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE65C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:18 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so3369781pjb.1
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q9aJ/VK0rM/yTCrq/7HYUan28YvSVxEkpw9slVa2TMQ=;
        b=qPe+pB8yPiMjltpEcsMTl/H8g7d/Q5cZtma7uAb/HIf5jFCNuHyx5jXvK0740ttIxd
         VxgRZr8uZdGQI/quSbU2l+qMHgLal+DmwO2Fee0yoEFu5zZK2wvCdmfUCjFoEaGYjxon
         mlcxoawu7tUkSEqQmAIJx8gXiYBTjjkvoHP+ed1Fv3dLpmUtDDStLV5YpJdfapSSiwjp
         cqfEvWMvspkZltcc6ZzFS/yazVljv/GdfgUZB423+MgDfPCxZtKLJnqRAzZSYEu5n2e3
         OFBoe4qdx62J8wcdseqjIiCqOXfI/VWIbmJK2cMIG/F6GaCGXjugvlCLLCN7QUuLNQK/
         xzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q9aJ/VK0rM/yTCrq/7HYUan28YvSVxEkpw9slVa2TMQ=;
        b=OnLKQXM6hrPUZhsyruwVObkoS8KnBosxfr3q5IO/eF1sVBrT8CdLy8zFyXi3f0Yimo
         +8MoI6V/8/ehiJJk13/iCNeziPn6Nim8QGamdFbI04SIf3j1NmRZMfoMTPEXSYwJCzEN
         2U+ggWP9cXgQ18HsUh5069Nr9tCLQci5Qh+SLk6LuMfOzfu+u5LbYv4RPPjSHiYhK6U4
         7H24R5wghiKKo8Jo6d6W1H6P5NEvrTjsSJVEUfX6t35Zd/LBX4w3lItkLgcH7YkLvvx4
         q6lJOr1ER4Pbx4VVtDv3gkMvmJMaiAZdXwp/UrJXJtqFeGHar+iZBeg/BhsfOokki+mG
         2Wtg==
X-Gm-Message-State: AOAM532fh9O/EkNYovLm1Tm1+IRcO5UR7jaSSytIaBibZMEgt4M1413E
        CyLP9zakSzo35gOPNY4jaqk=
X-Google-Smtp-Source: ABdhPJx6Mn98eisuIHatw0Pf+d4TSn9OWAxJuH50vP3FRLlm8Ry0cdHW963eiP/vpPZLJURg0g9DdQ==
X-Received: by 2002:a17:90a:670a:: with SMTP id n10mr4560300pjj.101.1617213138342;
        Wed, 31 Mar 2021 10:52:18 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9107:b184:4a71:45d0])
        by smtp.gmail.com with ESMTPSA id q17sm3319028pfq.171.2021.03.31.10.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 10:52:18 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/9] inet: shrink inet_timewait_death_row by 48 bytes
Date:   Wed, 31 Mar 2021 10:52:05 -0700
Message-Id: <20210331175213.691460-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210331175213.691460-1-eric.dumazet@gmail.com>
References: <20210331175213.691460-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

struct inet_timewait_death_row uses two cache lines, because we want
tw_count to use a full cache line to avoid false sharing.

Rework its definition and placement in netns_ipv4 so that:

1) We add 60 bytes of padding after tw_count to avoid
  false sharing, knowing that tcp_death_row will
  have ____cacheline_aligned_in_smp attribute.

2) We do not risk padding before tcp_death_row, because
  we move it at the beginning of netns_ipv4, even if new
 fields are added later.

3) We do not waste 48 bytes of padding after it.

Note that I have not changed dccp.

pahole result for struct netns_ipv4 before/after the patch :

/* size: 832, cachelines: 13, members: 139 */
/* sum members: 721, holes: 12, sum holes: 95 */
/* padding: 16 */
/* paddings: 2, sum paddings: 55 */

->

/* size: 768, cachelines: 12, members: 139 */
/* sum members: 673, holes: 11, sum holes: 39 */
/* padding: 56 */
/* paddings: 2, sum paddings: 7 */
/* forced alignments: 1 */

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 9c8dd424d79b1d1100b6cbaa64d9fda9352a0b3a..1085ed4e0788d7cd432dfc7e5604ef3cd66dc337 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -32,14 +32,18 @@ struct inet_hashinfo;
 
 struct inet_timewait_death_row {
 	atomic_t		tw_count;
+	char			tw_pad[L1_CACHE_BYTES - sizeof(atomic_t)];
 
-	struct inet_hashinfo 	*hashinfo ____cacheline_aligned_in_smp;
+	struct inet_hashinfo 	*hashinfo;
 	int			sysctl_max_tw_buckets;
 };
 
 struct tcp_fastopen_context;
 
 struct netns_ipv4 {
+	/* Please keep tcp_death_row at first field in netns_ipv4 */
+	struct inet_timewait_death_row tcp_death_row ____cacheline_aligned_in_smp;
+
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*forw_hdr;
 	struct ctl_table_header	*frags_hdr;
@@ -175,7 +179,6 @@ struct netns_ipv4 {
 	int sysctl_tcp_comp_sack_nr;
 	unsigned long sysctl_tcp_comp_sack_delay_ns;
 	unsigned long sysctl_tcp_comp_sack_slack_ns;
-	struct inet_timewait_death_row tcp_death_row;
 	int sysctl_max_syn_backlog;
 	int sysctl_tcp_fastopen;
 	const struct tcp_congestion_ops __rcu  *tcp_congestion_control;
-- 
2.31.0.291.g576ba9dcdaf-goog

