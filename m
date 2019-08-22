Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D85A9A113
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733176AbfHVU2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:28:40 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43894 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732323AbfHVU2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:28:39 -0400
Received: by mail-pf1-f194.google.com with SMTP id v12so4724442pfn.10
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 13:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=E2h6wUIRvWocX9fSlcKCQm3OJiK0OMlSKFELjaADYoU=;
        b=Z+JNZz7hInNXUvPw0HG5RCchNfyRpHjHmKotxBawC/vx+aM/72leXWca3NIyVB+nHk
         Bxz2EuRYJz1OT3g5IHlJDhZsW+aA9RXqGFIoF6Re0M8wafl/z6N3DJhh54Fllm5tiOoZ
         iQghT+5LcPj5DVki744OZNgGLtQnV46UK0QKNWx34oyp9FwWOkRm4CU4W9WDNAJQ7jNS
         SXxXsaZ2JxtWDjQvbG/Whxi4DDe53BypS3Hm2o2hW8eNN/WfLNL+0QWYb39gVHI772wU
         XZ/BR+DHsgJFCXH5mPqVm6QzplQLgQi/Lf7kA9vmgfQbW6KNYoAqtx0P4fRV5ERslgDn
         Atcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=E2h6wUIRvWocX9fSlcKCQm3OJiK0OMlSKFELjaADYoU=;
        b=ljG4eo6pl33lwwcdbxLhdsAmZTXuIJrJ2QuXN7RlgMpcmJWauYE58p2IpSyDVX1EfC
         QoJno4xYZ4dww5k94W5persIW0q4RELp/kTlgYfpw4Jz10nYU5AuJN8hMFi3i6sSq4+Y
         8959VNegZHCz23M2AGs96sWORqqQkWXY0xd3jsXPQtP7JQJOwJomFbxcbdQc3kVNqwNv
         bc2wRmb8XLeZX+oFcdCx6LOWIl5TI4YaHo8mgYl/SkwWdGIy3jQxRbZU3zHC/NUEnfZ3
         qByB5GeBHdqMY+0JLt1mat010OipzjQVcXqF3KDoh9L7XMczAPh9fjK+P4uftQBYHqvz
         j/OQ==
X-Gm-Message-State: APjAAAXWLkI2ri7WPaWTfK1MJFfST+TLBUK0Ce5MwImYtArlyiODWGps
        l0UGt6TJ05h+5o8ZGwP4HgWUUdLv
X-Google-Smtp-Source: APXvYqyXLFom7JLTesrr2tBuHTBjDw6ZBCs0vsz30GAVBkI6k38YlJs/RqaOxwV+JGtmqPjhSy7Cmg==
X-Received: by 2002:a17:90b:8c5:: with SMTP id ds5mr1581436pjb.142.1566505718348;
        Thu, 22 Aug 2019 13:28:38 -0700 (PDT)
Received: from Husky.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id m19sm275759pff.108.2019.08.22.13.28.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 22 Aug 2019 13:28:37 -0700 (PDT)
From:   Yi-Hung Wei <yihung.wei@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org
Cc:     Yi-Hung Wei <yihung.wei@gmail.com>
Subject: [PATCH net v2] openvswitch: Fix conntrack cache with timeout
Date:   Thu, 22 Aug 2019 13:17:50 -0700
Message-Id: <1566505070-38748-1-git-send-email-yihung.wei@gmail.com>
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
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
---
v1->v2: Fix rcu dereference issue reported by kbuild test robot.
---
 net/openvswitch/conntrack.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 848c6eb55064..4d7896135e73 100644
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
+		if (!timeout_ext || info->nf_ct_timeout !=
+		    rcu_dereference(timeout_ext->timeout))
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
+			ct_info.nf_ct_timeout = rcu_dereference(
+				nf_ct_timeout_find(ct_info.ct)->timeout);
+
 	}
 
 	if (helper) {
-- 
2.7.4

