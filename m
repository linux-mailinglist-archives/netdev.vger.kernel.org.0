Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9527AC2769
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731763AbfI3UzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:55:07 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36198 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731201AbfI3UzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:55:07 -0400
Received: by mail-pf1-f196.google.com with SMTP id y22so6282558pfr.3
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 13:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uZdB3B+GeHnHFcSAUQUPucIR5yPhqWZ2SRjd1/vvOdo=;
        b=Wi0hVkK1yQHGTlsDjJcLqNe58ZfkHJ6/i+UwowmZiz6C4wMmmrbKE1Xw1Q7HprLwkE
         mQan76cCQHc20hc+dqyj3TILlGIQ8TBZ+ba31nzjk+FwAEj129xHEjN5bLXLII5gOoKB
         d+hL+Fzr/4tML2Lw54ToTHXLBK5ARI3wNpTS38kZ9500dUjpRnytptcMgkVgT95QwjIn
         BfiofNZxJJmA8/nk/dJfUvy81Z2wBuvXLRTnTAn1sHNJazM4+oc3Cv+FOOKJKTYpJlbJ
         s9fSyVtj/2rJYBqcgmrArI6xEh31jW5XOE8jMoAkZoMg9rklgAdzYGZGArDLn2+nNNq5
         oJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uZdB3B+GeHnHFcSAUQUPucIR5yPhqWZ2SRjd1/vvOdo=;
        b=CwQ4JOwNCA665aoOmbMw/m5aWN5jyN6a7rAAageoosJnftvyfDLRwcDfSUD3U+fJiN
         62I/uXIXI3iz67p3EECvV4mbcRaNHFytAbTnPzFhUEFwO/jea/7bRcClkmHX6JAxy0aO
         0+tLv6wPNr/ldQORu+D7/rwG4XfNAQt107PHDLWFP1zJlUMkH++AzBW+XxTq3NmotFnn
         b981d8yf48J2mumgfyKMk6hf9Y1bcH1019jKOdI+sClOkIS+x7oHv+1lyv55nfCV9lsE
         zPcrwvW5ufs/DzUhznXwDKxq6qIwfl9ktl1Vy7jbd4erriEfmWMjKGx5lJlPcMLeAczZ
         xmWQ==
X-Gm-Message-State: APjAAAWx6wjU49MpSGP2uhFEpNxuaeEmzQvF9wdoiHDcSEni6QCBg6dO
        W++gclv8pFTTavzDfBOMhdUhH6t/T2Q=
X-Google-Smtp-Source: APXvYqyaS1UfNSKPgi91VpiKs/url5kKfksZ4t/ekyvCb17/ze1sMwGgAmlJmAl3VLl8azWtLO19Dw==
X-Received: by 2002:a62:bd03:: with SMTP id a3mr23739773pff.29.1569873069358;
        Mon, 30 Sep 2019 12:51:09 -0700 (PDT)
Received: from Husky.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id d6sm15844574pgj.22.2019.09.30.12.51.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 30 Sep 2019 12:51:08 -0700 (PDT)
From:   Yi-Hung Wei <yihung.wei@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Yi-Hung Wei <yihung.wei@gmail.com>
Subject: [PATCH] openvswitch: Allow attaching helper in later commit
Date:   Mon, 30 Sep 2019 12:39:04 -0700
Message-Id: <1569872344-14380-1-git-send-email-yihung.wei@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows to attach conntrack helper to a confirmed conntrack
entry.  Currently, we can only attach alg helper to a conntrack entry
when it is in the unconfirmed state.  This patch enables an use case
that we can firstly commit a conntrack entry after it passed some
initial conditions.  After that the processing pipeline will further
check a couple of packets to determine if the connection belongs to
a particular application, and attach alg helper to the connection
in a later stage.

Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
---
 net/openvswitch/conntrack.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 05249eb45082..4eb3d2748b65 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -971,6 +971,8 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct) {
+		bool add_helper = false;
+
 		/* Packets starting a new connection must be NATted before the
 		 * helper, so that the helper knows about the NAT.  We enforce
 		 * this by delaying both NAT and helper calls for unconfirmed
@@ -988,16 +990,17 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		}
 
 		/* Userspace may decide to perform a ct lookup without a helper
-		 * specified followed by a (recirculate and) commit with one.
-		 * Therefore, for unconfirmed connections which we will commit,
-		 * we need to attach the helper here.
+		 * specified followed by a (recirculate and) commit with one,
+		 * or attach a helper in a later commit.  Therefore, for
+		 * connections which we will commit, we may need to attach
+		 * the helper here.
 		 */
-		if (!nf_ct_is_confirmed(ct) && info->commit &&
-		    info->helper && !nfct_help(ct)) {
+		if (info->commit && info->helper && !nfct_help(ct)) {
 			int err = __nf_ct_try_assign_helper(ct, info->ct,
 							    GFP_ATOMIC);
 			if (err)
 				return err;
+			add_helper = true;
 
 			/* helper installed, add seqadj if NAT is required */
 			if (info->nat && !nfct_seqadj(ct)) {
@@ -1007,11 +1010,13 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		}
 
 		/* Call the helper only if:
-		 * - nf_conntrack_in() was executed above ("!cached") for a
-		 *   confirmed connection, or
+		 * - nf_conntrack_in() was executed above ("!cached") or a
+		 *   helper was just attached ("add_helper") for a confirmed
+		 *   connection, or
 		 * - When committing an unconfirmed connection.
 		 */
-		if ((nf_ct_is_confirmed(ct) ? !cached : info->commit) &&
+		if ((nf_ct_is_confirmed(ct) ? !cached | add_helper :
+					      info->commit) &&
 		    ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
 			return -EINVAL;
 		}
-- 
2.7.4

