Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF10926F54A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 07:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgIRFIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 01:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIRFIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 01:08:37 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909D8C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 22:08:37 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id p13so2682896plr.17
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 22:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=AET5NYtjacJg/hdDo6GkOEDGpazNSC59fCtzWBtCTKY=;
        b=IRYZeAlNKa8jRqRLtExpukpZlvhoDfKntaLfhONKvMfZvP4PDy0qtOve0LNTQwfPJY
         TnGeuEFkzEy4EtqfIore0vgfF1eoqzilg7w3HEHRoiY1a/bZtzkd5V7HJoDS0fZFHQao
         2xl0ld0x5mRYJj48uNfi4fEAiRO8rKqmDSR2SpfpUkJOBQ0ALom+LyFlEdKvZmli6ydJ
         fncRQTeXUT7Vv79XqUQLubnxRtK/YbuY3Z1Y7zRQ1817g0SBbDZmTSZNmmF/QWMyf7KK
         xOePlovBRr13Lhg0fXbxzjyKxsgaFhSFOnBOxvBNfG2HMX9LeAWX7grGMzfynvMfAesU
         /Ukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=AET5NYtjacJg/hdDo6GkOEDGpazNSC59fCtzWBtCTKY=;
        b=bpkMxx6LCa/UJ+Y5aPVxw1SXjkueK1LewQfUTTxjhGpr7WT9Ung25nXTdlXmqBRrHy
         KMXNuwknWXueqQmEocYz/GhGRiokj2dE53V13TvYKphzth83vnr7ISKFH8gleB3c0I/O
         jBSw9zS9OG4ZOlOfFUT+50QikVZV5KNWxquKvVeixyAlc5EmTyJTnP3TkAtu/bF7o6u4
         aCbAxdeG47ff/vpxKK9ZxrDi2GCVkES0qGypxXIoDezNRE4pcjPhqfepiT0BGfrsB4U3
         OjqfBNm1SCa0cXRJfZ5opqBxk6vuHvwlj86lxdXl+kZeGE/RdmvIuOdwPreqRanSh7Q8
         lqjw==
X-Gm-Message-State: AOAM533AAP26NTawX3Ea4Mcmgk8YbI6QuGwGVkR6QqTzDogDm+jbEIjC
        F9xR+6CVG2FU5KfD5yUJo7JCwN3bsjpxiFXplJp3P58+CeTAqZ4eI3bz+r6W8RZAVt+9yQ6WlYZ
        QenbKGoHUwwU+J4SFqWKRBxXLD1dlGFYCE4UgEuSsaMPpAqVYp7pdcLFN/HUJns0w
X-Google-Smtp-Source: ABdhPJxckfMeilEdpwa4fk48+iuUSCO1bXQAhbwAVnzGLiGUUqSVcZR91vETOG2QL4hlC4V2cFbtofvvgDsU
X-Received: from coldfire2.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef4:e398])
 (user=maheshb job=sendgmr) by 2002:a62:93:0:b029:13e:d13d:a085 with SMTP id
 141-20020a6200930000b029013ed13da085mr29652631pfa.28.1600405716670; Thu, 17
 Sep 2020 22:08:36 -0700 (PDT)
Date:   Thu, 17 Sep 2020 22:08:32 -0700
Message-Id: <20200918050832.1556691-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH next] net: fix build without CONFIG_SYSCTL definition
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Earlier commit 316cdaa1158a ("net: add option to not create fall-back
tunnels in root-ns as well") removed the CONFIG_SYSCTL to enable the
kernel-commandline to work. However, this variable gets defined only
when CONFIG_SYSCTL option is selected.

With this change the behavior would default to creating fall-back
tunnels in all namespaces when CONFIG_SYSCTL is not selected and
the kernel commandline option will be ignored.

Fixes: 316cdaa1158a ("net: add option to not create fall-back tunnels in root-ns as well")
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
---
 include/linux/netdevice.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 909b1fbb0481..fef0eb96cf69 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -634,8 +634,9 @@ extern int sysctl_devconf_inherit_init_net;
  */
 static inline bool net_has_fallback_tunnels(const struct net *net)
 {
-	return (net == &init_net && sysctl_fb_tunnels_only_for_init_net == 1) ||
-	       !sysctl_fb_tunnels_only_for_init_net;
+	return !IS_ENABLED(CONFIG_SYSCTL) ||
+	       !sysctl_fb_tunnels_only_for_init_net ||
+	       (net == &init_net && sysctl_fb_tunnels_only_for_init_net == 1);
 }
 
 static inline int netdev_queue_numa_node_read(const struct netdev_queue *q)
-- 
2.28.0.681.g6f77f65b4e-goog

