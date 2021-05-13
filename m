Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F125937F48A
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 10:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbhEMI6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 04:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbhEMI6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 04:58:45 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20960C061761;
        Thu, 13 May 2021 01:57:34 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id a2so24823807qkh.11;
        Thu, 13 May 2021 01:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=COkVIizRsyiwRJig2+uSHaIiIYnZtFVnYWEkEuvuuX0=;
        b=riiBPo7+PW8Fn1TXWc8RTILLF2dlxaQLDN4d/vsjnomSI+X5Yp5gzTAmNQB+Wo7QBC
         tO02MAwzNoFYrUD+pZHiR9ol68WtoeNU1j2MCvVOFkTzOTkJkEgrzN4VSY8BfQ4lHeqD
         f3tAgOIHV2EmbIqvYJSDkPxXyVWbo7Nq9dsdtWo1D2nN8IWg6ntc4YNZPkKM7Ot3VYc6
         u1p0T7m5n4UnD8sWZW5VAXt763bvENlvr9chfMg/o/WLaOwiuwDEGLIPwfckF0B2Zg6m
         uv/Hu02CgSywAisq/gvfCv4Ol0Fszsu6xNWYQJAdbDU+CGURz1i8TJsDky2aHzXMqznU
         gtzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=COkVIizRsyiwRJig2+uSHaIiIYnZtFVnYWEkEuvuuX0=;
        b=JlLjKOMtHbhWW8mw44jF/AG+RXHe0riEbwM5p4I/tlEMD7m4CWr1Y9xheTKrMnsBCq
         5LKGgj8b60UFM2nC4M/kttFsF+5rDOxxgUnxfvsEunrkl5OncNXRvdRLnbj3KqoK4V2g
         b3Kd5p3F/5AWToXvN5MyCbtidIBV5YTTL+IJzopq5piatoh405Cuq+rJKdkyiaZdyM1B
         dbC/G3GG7+5vBd84VjDXfngUelPSDNOnueUtLu5MCqVclzaqHowRxXZgsB9dJWXSx+Tg
         Am2N2cC+99Y5Qg7Sszr9KhAM4Ig4f4qhTIDnuXGTa2y1DwanuCnyZvR8S6KjGaIJ+ixC
         UlEw==
X-Gm-Message-State: AOAM533vH9xS2QpzxYtzXTk/tjTlQoA7WRe4vBNZewiFZcbffMZaYiew
        KpFQZc6+bfC0naO9VTa0SjivIFEgkzkedA==
X-Google-Smtp-Source: ABdhPJyhqDvgCwt4aqMja/DZDNxs7D67ZTDnJWb50BUwqWI1+/Ki6S+1ZnWndbPtRLnYrFhvrHRD3w==
X-Received: by 2002:a05:620a:1f2:: with SMTP id x18mr36674398qkn.279.1620896253899;
        Thu, 13 May 2021 01:57:33 -0700 (PDT)
Received: from jrr-vaio.internal.cc-sw.com (cpe-74-136-172-82.kya.res.rr.com. [74.136.172.82])
        by smtp.gmail.com with ESMTPSA id a195sm1966648qkg.101.2021.05.13.01.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 01:57:33 -0700 (PDT)
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jonathon Reinhart <jonathon.reinhart@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Subject: [PATCH] netfilter: conntrack: Make global sysctls readonly in non-init netns
Date:   Thu, 13 May 2021 04:57:20 -0400
Message-Id: <20210513085720.32367-1-jonathon.reinhart@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 2671fa4dc0109d3fb581bc3078fdf17b5d9080f6 upstream.

These sysctls point to global variables:
- NF_SYSCTL_CT_MAX (&nf_conntrack_max)
- NF_SYSCTL_CT_EXPECT_MAX (&nf_ct_expect_max)
- NF_SYSCTL_CT_BUCKETS (&nf_conntrack_htable_size_user)

Because their data pointers are not updated to point to per-netns
structures, they must be marked read-only in a non-init_net ns.
Otherwise, changes in any net namespace are reflected in (leaked into)
all other net namespaces. This problem has existed since the
introduction of net namespaces.

This patch is necessarily different from the upstream patch due to the
refactoring which took place since 5.4 in commit d0febd81ae77
("netfilter: conntrack: re-visit sysctls in unprivileged namespaces").

Signed-off-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>
---

Upstream commit 2671fa4dc010 was already applied to the 5.10, 5.11, and
5.12 trees.

This was tested on 5.4.118, so please apply to 5.4.y.
---
 net/netfilter/nf_conntrack_standalone.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 1a6982540126..46e3c9f5f4ce 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1071,8 +1071,11 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 #endif
 	}
 
-	if (!net_eq(&init_net, net))
+	if (!net_eq(&init_net, net)) {
+		table[NF_SYSCTL_CT_MAX].mode = 0444;
+		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
+	}
 
 	net->ct.sysctl_header = register_net_sysctl(net, "net/netfilter", table);
 	if (!net->ct.sysctl_header)
-- 
2.20.1

