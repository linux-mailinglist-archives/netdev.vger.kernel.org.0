Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371AB282297
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgJCIoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 04:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgJCIoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 04:44:55 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9572C0613E8
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 01:44:54 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOd9w-00FmcE-49; Sat, 03 Oct 2020 10:44:52 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3 1/5] netlink: compare policy more accurately
Date:   Sat,  3 Oct 2020 10:44:42 +0200
Message-Id: <20201003104138.80819804bfa9.I78718edf29745b8e5f5ea2d289e59c8884fdd8c7@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201003084446.59042-1-johannes@sipsolutions.net>
References: <20201003084446.59042-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The maxtype is really an integral part of the policy, and while we
haven't gotten into a situation yet where this happens, it seems
that some developer might eventually have two places pointing to
identical policies, with different maxattr to exclude some attrs
in one of the places.

Even if not, it's really the right thing to compare both since the
two data items fundamentally belong together.

v2:
 - also do the proper comparison in get_policy_idx()

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/netlink/policy.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index ebc64b20b6ee..753b265acec5 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -35,7 +35,8 @@ static int add_policy(struct netlink_policy_dump_state **statep,
 		return 0;
 
 	for (i = 0; i < state->n_alloc; i++) {
-		if (state->policies[i].policy == policy)
+		if (state->policies[i].policy == policy &&
+		    state->policies[i].maxtype == maxtype)
 			return 0;
 
 		if (!state->policies[i].policy) {
@@ -63,12 +64,14 @@ static int add_policy(struct netlink_policy_dump_state **statep,
 }
 
 static unsigned int get_policy_idx(struct netlink_policy_dump_state *state,
-				   const struct nla_policy *policy)
+				   const struct nla_policy *policy,
+				   unsigned int maxtype)
 {
 	unsigned int i;
 
 	for (i = 0; i < state->n_alloc; i++) {
-		if (state->policies[i].policy == policy)
+		if (state->policies[i].policy == policy &&
+		    state->policies[i].maxtype == maxtype)
 			return i;
 	}
 
@@ -182,7 +185,8 @@ int netlink_policy_dump_write(struct sk_buff *skb,
 			type = NL_ATTR_TYPE_NESTED_ARRAY;
 		if (pt->nested_policy && pt->len &&
 		    (nla_put_u32(skb, NL_POLICY_TYPE_ATTR_POLICY_IDX,
-				 get_policy_idx(state, pt->nested_policy)) ||
+				 get_policy_idx(state, pt->nested_policy,
+						pt->len)) ||
 		     nla_put_u32(skb, NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE,
 				 pt->len)))
 			goto nla_put_failure;
-- 
2.26.2

