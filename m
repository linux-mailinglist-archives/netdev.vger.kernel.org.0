Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0623A172C
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbhFIO0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbhFIO0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 10:26:51 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF29C0617A6
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 07:24:40 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id j189so23840354qkf.2
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 07:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E6nHsj1/Xf3pm2h5JRXn0FkvmuDGJ5A5pXc47ElOtj0=;
        b=D8KN3CRKx+ASqBn+7M5xQKou+opGtxk2rw6gLETBktGTwxek7vtjdvw+7ikl9hDSVr
         qjQvGC7l1K52Tru9u3WX4BIRaKzicBRvgErZ1bYw8gPUqFEazbIJArQHfl2Slm2kSSDm
         UnmdjwoJnLDMiNWtpF1P90tnY67AucxquV23Asis3aNVCJ8wbGqnDTARVZRczy0pp2ns
         4n3WY1sqX/FqKotFxOQ2WDnwXzV7e+Tc4or8RG9t9gzmFninQC2MvfPIWssdOBlrrWb2
         W4ZdT1pwv+aZBWSOA22KuR8QI2qRh93p4bhvHy++QsI4bZbQ//dSztK9e3M6nVPtf/Wb
         HFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E6nHsj1/Xf3pm2h5JRXn0FkvmuDGJ5A5pXc47ElOtj0=;
        b=Qa0s76WqQNyN9C9YOBypmYc256tapf1S6VkMuP0dILO/ggv+Oe1CsGvmS8/FVWp2NK
         LHfrk1Wz0zNXSt7VYu6Wd9SXxxIqtR+5Dyt8xIFTKOCb9A39v2eVVuLguDnqxmZkNusP
         GSEkmXuYQZ1pN9/BF2eEpyz/ROh2Ib8BnlnskAufCmUVmwWH7hn6QLlIrzkes26bQNYU
         41wLHj5XcIq0WGsBeqkjWvq+Uv0SHAokObBwobdwcwaq9WydghqYN/bnkCJzQ8jDXAii
         UEpmsNf0UdfiWp5SLf0Jil1WLigkEMOIWt3p5vf9uOczQskqEigk2NBK7/rV6+mvhqTb
         s7Wg==
X-Gm-Message-State: AOAM533Ufp7U3xvnI6EYHymTn9Ny0UiVjVkU1LuES1SAAObKLjpaJ8wI
        aCML4DQwHfWjQsZJHvNJmyA=
X-Google-Smtp-Source: ABdhPJwmbrAAee0AIeE8HM94zWkfzFn4bT5ti5/bbOJ6AqLSbK48Rv6ix+tZI00k1UNrndY0C9KieQ==
X-Received: by 2002:ae9:c218:: with SMTP id j24mr27218983qkg.94.1623248679995;
        Wed, 09 Jun 2021 07:24:39 -0700 (PDT)
Received: from horizon.localdomain ([177.220.174.185])
        by smtp.gmail.com with ESMTPSA id b123sm146381qke.87.2021.06.09.07.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 07:24:39 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 65661C0473; Wed,  9 Jun 2021 11:24:37 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dcaratti@redhat.com, Paul Blakey <paulb@nvidia.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@nvidia.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net] net/sched: act_ct: handle DNAT tuple collision
Date:   Wed,  9 Jun 2021 11:23:56 -0300
Message-Id: <87588ad6631f7d60691fddb860e075ebebeaa5ec.1623248030.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This this the counterpart of 8aa7b526dc0b ("openvswitch: handle DNAT
tuple collision") for act_ct. From that commit changelog:

"""
With multiple DNAT rules it's possible that after destination
translation the resulting tuples collide.

...

Netfilter handles this case by allocating a null binding for SNAT at
egress by default.  Perform the same operation in openvswitch for DNAT
if no explicit SNAT is requested by the user and allocate a null binding
for SNAT for packets in the "original" direction.
"""

Fixes: 95219afbb980 ("act_ct: support asymmetric conntrack")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---

I have a tdc test for this but I'll submit it to net-next once this one
gets accepted. It requires some changes to tdc itself.

 net/sched/act_ct.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 18edd9ad1410947c0464341cf601b87bf7a7a6ff..a656baa321fe1686ac8f87f8a35819f067f65869 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -904,14 +904,19 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
 	}
 
 	err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
-	if (err == NF_ACCEPT &&
-	    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
-		if (maniptype == NF_NAT_MANIP_SRC)
-			maniptype = NF_NAT_MANIP_DST;
-		else
-			maniptype = NF_NAT_MANIP_SRC;
-
-		err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
+	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
+		if (ct->status & IPS_SRC_NAT) {
+			if (maniptype == NF_NAT_MANIP_SRC)
+				maniptype = NF_NAT_MANIP_DST;
+			else
+				maniptype = NF_NAT_MANIP_SRC;
+
+			err = ct_nat_execute(skb, ct, ctinfo, range,
+					     maniptype);
+		} else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
+			err = ct_nat_execute(skb, ct, ctinfo, NULL,
+					     NF_NAT_MANIP_SRC);
+		}
 	}
 	return err;
 #else
-- 
2.31.1

