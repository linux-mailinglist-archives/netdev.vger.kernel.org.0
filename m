Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C009F37F406
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 10:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhEMIaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 04:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhEMIaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 04:30:00 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EB1C061574;
        Thu, 13 May 2021 01:28:49 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id x8so24806073qkl.2;
        Thu, 13 May 2021 01:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YZuHIqE1Xt0+x34JLFf8F3EO5A3fSgWJriKswBQRHNU=;
        b=s2u9kp9VqS0VaNIN/T8JeWGd0C7NRwfSRznS7S3J7CXLS+XikyE6DgF0bSscWqVtF4
         2fhb+NWXyfI2ywyJaQL1pLJfIDK/jpY9kYCdkXCK5teCkTBsoLxp1L/OYcWSYe6H4pVA
         Pv7gqKzleU5zBmzoadDSi1D1Zs3mfSH5ugpefiN8uce7UXz6WLh/WPAltF/AqXdD2opz
         dEb7YidI+KBnQvmt9nsHUm6f/35QGPghjDItLpwxaaVdGEui5jfUP90KI5pDa2Kew8sj
         NNDZKJOXT+VgiWanZAPKDzsnZ47VRw5L5NA9HgtMa25wEkS/ZsVcubVL39Egm1+MP/1a
         X+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YZuHIqE1Xt0+x34JLFf8F3EO5A3fSgWJriKswBQRHNU=;
        b=NtSlBoY1WgOam1kV0Td3bNoZ2IxkPoIeHRkPc5BECchdK1upV1gmzbzTm5Da7mfVAn
         pjRd7L+cIiC22NC+SMp7sCbyVZhKgRFqF1yqGnQ3COBtfSZqjEsilvjCxhDPltprg1nR
         bjpC8YfLuIUddRqEP3Y2kkkrJ/01dBqQk3ULLMfX+uelk7OBIdEh1WJ/H8yMayZ2Z91R
         XWuJWWKCjJ6wsq1UOe403sXdJydBgJuKMoT8x2cbFyx5aI+w0rqXz3mUE0SalbOQcgld
         pW2uLz8Zzxhu54To3u2JVsIWCS/4Cu6yhp9AKpPjj+F+wzOEY1gwBq394bdijSruVvED
         cPhQ==
X-Gm-Message-State: AOAM532dn+zm3SgG+q8KfUCYEjkzdjTLaVcxNkQFeOPPuhk8FZoTUPCL
        nrVbt/s5XHJ0xXG8fEktG3tx9Ix5HDT0lA==
X-Google-Smtp-Source: ABdhPJwBnqnTPyylBOAT+AP4wUwUX+DXyg+HYtYfmfbJ0SHpU1RuthJs2B+skd73CAUTeBZvwMFzSw==
X-Received: by 2002:a37:916:: with SMTP id 22mr15867553qkj.241.1620894528973;
        Thu, 13 May 2021 01:28:48 -0700 (PDT)
Received: from jrr-vaio.internal.cc-sw.com (cpe-74-136-172-82.kya.res.rr.com. [74.136.172.82])
        by smtp.gmail.com with ESMTPSA id m205sm1874679qke.2.2021.05.13.01.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 01:28:48 -0700 (PDT)
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jonathon Reinhart <jonathon.reinhart@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Subject: [PATCH] netfilter: conntrack: Make global sysctls readonly in non-init netns
Date:   Thu, 13 May 2021 04:28:35 -0400
Message-Id: <20210513082835.18854-1-jonathon.reinhart@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 2671fa4dc0109d3fb581bc3078fdf17b5d9080f6 upstream.

These sysctls point to global variables:
- [0] "nf_conntrack_max"        (&nf_conntrack_max)
- [2] "nf_conntrack_buckets"    (&nf_conntrack_htable_size_user)
- [5] "nf_conntrack_expect_max" (&nf_ct_expect_max)

Because their data pointers are not updated to point to per-netns
structures, they must be marked read-only in a non-init_net ns.
Otherwise, changes in any net namespace are reflected in (leaked into)
all other net namespaces. This problem has existed since the
introduction of net namespaces.

This patch is necessarily different from the upstream patch due to the
heavy refactoring which took place since 4.19:

d0febd81ae77 ("netfilter: conntrack: re-visit sysctls in unprivileged namespaces")
b884fa461776 ("netfilter: conntrack: unify sysctl handling")
4a65798a9408 ("netfilter: conntrack: add mnemonics for sysctl table")

Signed-off-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>
---

Upstream commit 2671fa4dc010 was already applied to the 5.10, 5.11, and
5.12 trees.

This was tested on 4.19.190, so please apply to 4.19.y.

It should also apply to:
- 4.14.y
- 4.9.y

Note that 5.4.y would require a slightly different patch that looks more
like 2671fa4dc010.

---
 net/netfilter/nf_conntrack_standalone.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 2e3ae494f369..da0c9fa381d2 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -594,8 +594,11 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	if (net->user_ns != &init_user_ns)
 		table[0].procname = NULL;
 
-	if (!net_eq(&init_net, net))
+	if (!net_eq(&init_net, net)) {
+		table[0].mode = 0444;
 		table[2].mode = 0444;
+		table[5].mode = 0444;
+	}
 
 	net->ct.sysctl_header = register_net_sysctl(net, "net/netfilter", table);
 	if (!net->ct.sysctl_header)
-- 
2.20.1

