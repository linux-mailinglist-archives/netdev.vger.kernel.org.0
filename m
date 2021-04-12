Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CD935B97F
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 06:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhDLEZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 00:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhDLEZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 00:25:54 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23434C061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 21:25:37 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id g24so8985390qts.6
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 21:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u/BBnQINkYlHHpiHGfkcDLKncNPuqLiTCwnR1DOdOZE=;
        b=leNPtYRHiZFqO/HvEmgpi6wc6xL4wnuWA9HcYcLG0peZVUH52ReWS4quKsLVr/ZxZE
         jmPJeVhJSL3yovnhFSucDY2bkWYvttJ5UE9PSuLVmZcBDCnbLC+1/OxXdjPqfdEqk4Z2
         WtajUjXp73RJt8lC+H0HSkyEAoKSdDZMaiY9S5kLyamuQAEXJSIO8ZDD9jUzKegs0gpH
         61nWO7TtcQFInGyrtyc+ftyksa+FTM7LGhyRc/5zE52kQ5czX7Itj5KjOKdSkPiV4ySz
         K8ya6BUv6vINj4bcjpUr/Wgs54dFYo7J0P72K+4lQpdp5SzrwUNTp4bicgziR+L8atYf
         +MPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u/BBnQINkYlHHpiHGfkcDLKncNPuqLiTCwnR1DOdOZE=;
        b=f2wNGNNEiZj5y2PRb5yjpbbWeN4oBMiP3QcvLpNtCBZPqzXQ2dR40L5cX4/Z73qdBl
         MxSxz6qoDz3R76NiNGao45e7Bs4b/Dl6hRtmr/C+YyB3/bIppTsmbUHJMMbUYoj6F1iq
         7nUcVKIoW35Ldbu7cp8VYcVEPP3bYmYi7DOwW1n3uYximjeJ778H+qlEadXfbKewrm9s
         TWhbv96ng3ozxh+FGxGETPP6hzKIyItW+LaUUU4HqhyTnvqXQN+x7R8EMu9XT/Yxm942
         U+4aj3SA23zxLplYYwGFPQLndGjPRM+whFh8uwkwJQYRslaS1A/m2die/dMGI6cJxG+Q
         6rtQ==
X-Gm-Message-State: AOAM5337L0YisReECrRyQOqr58JmamaK1FDOltNnJ31dP/9tx0Lx9Q/C
        KbPHFXm3NOOY7wNsTAInO0wNhX2XRa7adg==
X-Google-Smtp-Source: ABdhPJyGPvBJttObOvCBmau+/7tbzhhSf++fuIqFvnAbyzDUVHts494Y5WSwS/ga3bm4HSCK61nerg==
X-Received: by 2002:ac8:74d2:: with SMTP id j18mr531304qtr.172.1618201536168;
        Sun, 11 Apr 2021 21:25:36 -0700 (PDT)
Received: from jrr-vaio.onthefive.com (2603-6010-7221-eda3-0000-0000-0000-1d7d.res6.spectrum.com. [2603:6010:7221:eda3::1d7d])
        by smtp.gmail.com with ESMTPSA id a187sm7090996qkd.69.2021.04.11.21.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 21:25:35 -0700 (PDT)
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
X-Google-Original-From: Jonathon Reinhart <Jonathon.Reinhart@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jonathon Reinhart <Jonathon.Reinhart@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 2/2] netfilter: conntrack: Make global sysctls readonly in non-init netns
Date:   Mon, 12 Apr 2021 00:24:53 -0400
Message-Id: <20210412042453.32168-3-Jonathon.Reinhart@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210412042453.32168-1-Jonathon.Reinhart@gmail.com>
References: <20210412042453.32168-1-Jonathon.Reinhart@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These sysctls point to global variables:
- NF_SYSCTL_CT_MAX (&nf_conntrack_max)
- NF_SYSCTL_CT_EXPECT_MAX (&nf_ct_expect_max)
- NF_SYSCTL_CT_BUCKETS (&nf_conntrack_htable_size_user)

Because their data pointers are not updated to point to per-netns
structures, they must be marked read-only in a non-init_net ns.
Otherwise, changes in any net namespace are reflected in (leaked into)
all other net namespaces. This problem has existed since the
introduction of net namespaces.

The current logic marks them read-only only if the net namespace is
owned by an unprivileged user (other than init_user_ns).

Commit d0febd81ae77 ("netfilter: conntrack: re-visit sysctls in
unprivileged namespaces") "exposes all sysctls even if the namespace is
unpriviliged." Since we need to mark them readonly in any case, we can
forego the unprivileged user check altogether.

Fixes: d0febd81ae77 ("netfilter: conntrack: re-visit sysctls in unprivileged namespaces")
Signed-off-by: Jonathon Reinhart <Jonathon.Reinhart@gmail.com>
---
 net/netfilter/nf_conntrack_standalone.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 3f2cc7b04b20..54d36d3eb905 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1060,16 +1060,10 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	nf_conntrack_standalone_init_dccp_sysctl(net, table);
 	nf_conntrack_standalone_init_gre_sysctl(net, table);
 
-	/* Don't allow unprivileged users to alter certain sysctls */
-	if (net->user_ns != &init_user_ns) {
+	/* Don't allow non-init_net ns to alter global sysctls */
+	if (!net_eq(&init_net, net)) {
 		table[NF_SYSCTL_CT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
-		table[NF_SYSCTL_CT_HELPER].mode = 0444;
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-		table[NF_SYSCTL_CT_EVENTS].mode = 0444;
-#endif
-		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
-	} else if (!net_eq(&init_net, net)) {
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
 	}
 
-- 
2.20.1

