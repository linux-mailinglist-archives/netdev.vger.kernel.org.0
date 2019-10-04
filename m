Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA65CC0EC
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 18:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbfJDQiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 12:38:11 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35988 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJDQiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 12:38:10 -0400
Received: by mail-pg1-f193.google.com with SMTP id 23so4062884pgk.3
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 09:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=B4O1M0b3ByS/E8WnqjiwQjVvVNgrqnmluzp4B44F3OI=;
        b=i5CxeDyN20kDLsfTZwQIJJmWqwrMcrbfNQmG1QivAzWJmQbIypibjliubZXRxzoh9q
         iO2RW9ON728MZzfmF7Jq83XxcCDAHJUMCYnOUiLKBZO2AMLsujM9UaIeewpAwFLBrnzv
         GnF+0XVKbt+YTc2wyL5ymO8oaPy4rPuWSeKqEyVcVGYVQmMI2KZD8+KyrdjlS5vxvbMp
         JApCzTB/qpn3xvNYApnYqtIG6gWmbJLEoWk/i7ogqxV2v090CE7XCNI54b3cI8Iin7vO
         koEecWbnC/UYBs3uQUzdu1zD3MjpHRc5ZGiV7edP9W5K6pxJ43bvHdQfc50ijQBjswb4
         95PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B4O1M0b3ByS/E8WnqjiwQjVvVNgrqnmluzp4B44F3OI=;
        b=Zkxpom5bz5cWTmHYnvkrQNNU/RSqYiWx6urJZBxUsS+K+jKAM2GLzpO4tZexZb2F6L
         /ARNazCYv7AajnsrxlNoPiFCHticeHiI+OYFZ62unBWWMLRJUdl5obi2mpXLAvDw0NBz
         wcxrzud8rdh0i9TdF4RnZ0yoqS/MdgFy/UDqf9U6tR/HpQmybd+Yh3r49R83rn5dG+rB
         BBxb3jmmpIzpqXschG8UbS+exkqJxr9zu2q1kppA88dtUfax1PGSP8W7qT/VrLvHpomf
         F9ZFGBjHFcmNuItsuOCyFG3lzeVr7E5snbWxQjfMHLM639k6LrOeH4wdShpupzkR9Vt0
         ydBw==
X-Gm-Message-State: APjAAAV58gu9KYlfEcvU8SbdRmmI6H05R39J8C632/+Q8yZK6Eun1N1Q
        UVzbEpmUybpuTV9GmpYKnyHoQX6wbh0=
X-Google-Smtp-Source: APXvYqxCyzoYifRPKj9gJ6Z8QNq+nQZ90qYC+yWWRg2hNtwpfwARi+7qU8Ga5CEqUotA9eqPTukJkA==
X-Received: by 2002:a63:1e1e:: with SMTP id e30mr15336969pge.405.1570207089455;
        Fri, 04 Oct 2019 09:38:09 -0700 (PDT)
Received: from Husky.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id c7sm6125069pfr.75.2019.10.04.09.38.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 04 Oct 2019 09:38:08 -0700 (PDT)
From:   Yi-Hung Wei <yihung.wei@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Yi-Hung Wei <yihung.wei@gmail.com>
Subject: [PATCH net-next v2] openvswitch: Allow attaching helper in later commit
Date:   Fri,  4 Oct 2019 09:26:44 -0700
Message-Id: <1570206404-10565-1-git-send-email-yihung.wei@gmail.com>
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
v1->v2, Use logical OR instead of bitwise OR as Dave suggested.

---
 net/openvswitch/conntrack.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 05249eb45082..df9c80bf621d 100644
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
+		if ((nf_ct_is_confirmed(ct) ? !cached || add_helper :
+					      info->commit) &&
 		    ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
 			return -EINVAL;
 		}
-- 
2.7.4

