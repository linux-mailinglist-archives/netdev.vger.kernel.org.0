Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054D398874
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 02:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbfHVAZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 20:25:02 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35464 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbfHVAZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 20:25:02 -0400
Received: by mail-pg1-f193.google.com with SMTP id n4so2365110pgv.2
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 17:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5IZne9IYSvkvdK1V46tLOfi3w1HYRIkO+XOieNtGKjc=;
        b=HxI7R9tUyslZC5K3yk0U7yYtkNgNYTVD/VilhCCsk0VaIA4jUWAl44rtMJhPyIuhkL
         LaTRqR5jGgHkYxhU8Tsaex+rmbuCWCiDeq8dwCxPiBYRDz9Z+L3WfzAW/z6Zng1mYAyc
         9IG5XSPM3dif643ks9xSGDkTcA+Dk4aGgU0FKLo9ad/aHNmreeAjY0+RYoCVNKMP9wCE
         iVua81esYLQPii1f3F2QDpnbD78lRBISN6vxOZKZJyE1l5aD0TyeRL3qcnVHbFcDM5qP
         qyFel8xWu3HUorvLVpBFRZMAnE4ZPC6cWbSqiMKn0pusdLdo1gMOJV2nzcG4vU/V2PMD
         kMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5IZne9IYSvkvdK1V46tLOfi3w1HYRIkO+XOieNtGKjc=;
        b=cpiTyYSZTT/2xGDvOTbQHaUZuZ2Ek9U51YUny/9QP0ZKuxB38aokEbMttyc0MP9dgj
         L5L6CfvCa/wM18wmFXFtb7QerMRKvkdSiCmY5Gf1KECwUEOho3nhUWcPyGqq2p0L6atB
         YbAxWZ+KAksNwp8JzRihHzEnZc0pPXDhe+d2tJsGcLrlZpgxbvNrD45HAh23ojXDDfpk
         2pu/f31pi8deEpyawuIeFMNeNG3pO+3wM990gTbx/1ibcpaNp2TH6AHhVJknu2AeJZ9D
         nLxhkpD7WPF5Nodfhis4JO5BiFt6JtqcReke7yKZg4BqqdYMvNo3OKul5uhewxEX3BTe
         ho2A==
X-Gm-Message-State: APjAAAVb+MiqiQSF3krOEGbYVTu+aEFsXUG0dQI0IWAGBJIa5z6M6TXJ
        Ev4hgyxnb1MhADYY6QCH2akAxB/i
X-Google-Smtp-Source: APXvYqxhVG8pJAXQewpM8mNo7n7/UhnXPyrkg59rXvLSKT5s7G2Z26tU4xdc8Un6kNoyuk12MW/c8g==
X-Received: by 2002:a63:8ac4:: with SMTP id y187mr32102197pgd.412.1566433500874;
        Wed, 21 Aug 2019 17:25:00 -0700 (PDT)
Received: from Husky.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id y13sm20287316pfb.48.2019.08.21.17.24.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 21 Aug 2019 17:24:59 -0700 (PDT)
From:   Yi-Hung Wei <yihung.wei@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org
Cc:     Yi-Hung Wei <yihung.wei@gmail.com>
Subject: [PATCH net] openvswitch: Fix conntrack cache with timeout
Date:   Wed, 21 Aug 2019 17:14:14 -0700
Message-Id: <1566432854-35880-1-git-send-email-yihung.wei@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses a conntrack cache issue with timeout policy.
Currently, we do not check if the timeout extension is set properly in the
cached conntrack entry.  Thus, after packet recirculate from conntrack
action, the timeout policy is not applied properly.  This patch fixes the
aforementioned issue.

Fixes: 06bd2bdf19d2 ("openvswitch: Add timeout support to ct action")
Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
---
 net/openvswitch/conntrack.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 848c6eb55064..45498fcf540d 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -67,6 +67,7 @@ struct ovs_conntrack_info {
 	struct md_mark mark;
 	struct md_labels labels;
 	char timeout[CTNL_TIMEOUT_NAME_MAX];
+	struct nf_ct_timeout *nf_ct_timeout;
 #if IS_ENABLED(CONFIG_NF_NAT)
 	struct nf_nat_range2 range;  /* Only present for SRC NAT and DST NAT. */
 #endif
@@ -697,6 +698,14 @@ static bool skb_nfct_cached(struct net *net,
 		if (help && rcu_access_pointer(help->helper) != info->helper)
 			return false;
 	}
+	if (info->nf_ct_timeout) {
+		struct nf_conn_timeout *timeout_ext;
+
+		timeout_ext = nf_ct_timeout_find(ct);
+		if (!timeout_ext ||
+		    info->nf_ct_timeout != timeout_ext->timeout)
+			return false;
+	}
 	/* Force conntrack entry direction to the current packet? */
 	if (info->force && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
 		/* Delete the conntrack entry if confirmed, else just release
@@ -1657,6 +1666,10 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 				      ct_info.timeout))
 			pr_info_ratelimited("Failed to associated timeout "
 					    "policy `%s'\n", ct_info.timeout);
+		else
+			ct_info.nf_ct_timeout =
+				nf_ct_timeout_find(ct_info.ct)->timeout;
+
 	}
 
 	if (helper) {
-- 
2.7.4

