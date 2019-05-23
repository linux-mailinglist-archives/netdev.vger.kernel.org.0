Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441A32740E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbfEWBfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:35:21 -0400
Received: from mail-ot1-f73.google.com ([209.85.210.73]:45533 "EHLO
        mail-ot1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfEWBfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 21:35:20 -0400
Received: by mail-ot1-f73.google.com with SMTP id g80so2166376otg.12
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 18:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4Pf3YZv0j1wBBas5QgITPdveUU1zj8Fsx1zohy5EQ5I=;
        b=CIjVCjtKlb6IqLbOS2USuSR2mPMdSckvjiigMuOj8qb/UXcZ9QS8lavcVxOp+hRjaK
         7LyESYrSxIm/4QQoxuSthnZP6O/F4Adc4VBhdo+/bnqze53AvkFcWYZHt/cj5fKxNvU9
         Oa+wSQsVp+bvHw0CYhZ+KkhrEaoKtTMA3LdUwCt8RzlLgAh7nVk4q7H0l8B3yez58FX4
         EZG5FCNeKkQjN9Y75aG8XkggKe2z0jMu1vx63jrFmzY3ErCQIbctFWWUSBWP4e6HxZD7
         yjBBgNnuup4Z++u/jHQS9iGlBc+mnbWZlwEZbndhAXrLVo3CkAjSITtcWzjZ3NvHGlk8
         MD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4Pf3YZv0j1wBBas5QgITPdveUU1zj8Fsx1zohy5EQ5I=;
        b=ik+VB9EOc9FfCcBj5qZuXECDjxtSwZID2QnyqAO5wYOE0um+u48L87NGG7PDugkevp
         ObAMmvDgOBjn2myE2qo68orotETKTEA2Wd8dYfru5GgmzkX4UFIONmwQbtB0rFM3XZwW
         wlpoMNq2d00Pno8xUJtoKgY5iSz7sInIwibzep7GVF14TBIhsa9bYUggVWZU2shKx1UG
         TnGlHXvr0Mznz7iPlx+QVC9H+MakFfDJmtlCsT4yXkZH5kTxh7pZODv0n2dCBtPAzQ4O
         0kN/yQocUHYf9j/j6u9qxhS/y/IQm4d94MezB72xqunR1TrMYwbfao2+mrs1cv4hCNx5
         upuQ==
X-Gm-Message-State: APjAAAWVH+oUrlqVB4bM797rgra9/XHnU3NFM2qgqQadeVxfNdevt+gY
        OmOlNNfB0hWvx20BK2KOBp7msDyW3Msf/w==
X-Google-Smtp-Source: APXvYqy8JXjqvg1IPV70IKW44vRyl0n0q9nZbzW6E/HNSCNFwnlRM3Jv0Dmbeekds5X0vDnak6sWMgBb7NEk9Q==
X-Received: by 2002:aca:c64e:: with SMTP id w75mr1108129oif.25.1558575319926;
 Wed, 22 May 2019 18:35:19 -0700 (PDT)
Date:   Wed, 22 May 2019 18:35:16 -0700
Message-Id: <20190523013516.132053-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH net] ipv4/igmp: fix build error if !CONFIG_IP_MULTICAST
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip_sf_list_clear_all() needs to be defined even if !CONFIG_IP_MULTICAST

Fixes: 3580d04aa674 ("ipv4/igmp: fix another memory leak in igmpv3_del_delrec()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: kbuild test robot <lkp@intel.com>
---
 net/ipv4/igmp.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 1a8d36dd49d40a0bd352e78e87b87735f894e2cf..eb03153dfe12b23b86d24bd08882354656ccf152 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -188,6 +188,17 @@ static void ip_ma_put(struct ip_mc_list *im)
 	     pmc != NULL;					\
 	     pmc = rtnl_dereference(pmc->next_rcu))
 
+static void ip_sf_list_clear_all(struct ip_sf_list *psf)
+{
+	struct ip_sf_list *next;
+
+	while (psf) {
+		next = psf->sf_next;
+		kfree(psf);
+		psf = next;
+	}
+}
+
 #ifdef CONFIG_IP_MULTICAST
 
 /*
@@ -633,17 +644,6 @@ static void igmpv3_clear_zeros(struct ip_sf_list **ppsf)
 	}
 }
 
-static void ip_sf_list_clear_all(struct ip_sf_list *psf)
-{
-	struct ip_sf_list *next;
-
-	while (psf) {
-		next = psf->sf_next;
-		kfree(psf);
-		psf = next;
-	}
-}
-
 static void kfree_pmc(struct ip_mc_list *pmc)
 {
 	ip_sf_list_clear_all(pmc->sources);
-- 
2.21.0.1020.gf2820cf01a-goog

