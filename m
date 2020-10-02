Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4647C280F8D
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 11:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387687AbgJBJJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 05:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387623AbgJBJJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 05:09:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD0AC0613E5
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 02:09:56 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOH4b-00F9QD-Cv; Fri, 02 Oct 2020 11:09:53 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/5] netlink: compare policy more accurately
Date:   Fri,  2 Oct 2020 11:09:41 +0200
Message-Id: <20201002110205.73a89b98cf10.I78718edf29745b8e5f5ea2d289e59c8884fdd8c7@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002090944.195891-1-johannes@sipsolutions.net>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
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

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/netlink/policy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index 2a0d85cbc0a2..7bc8f81ecc43 100644
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
-- 
2.26.2

