Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1760E249A38
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 12:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgHSKXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 06:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbgHSKXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 06:23:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DADC061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 03:23:04 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k8LFC-006mAw-IA; Wed, 19 Aug 2020 12:22:58 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] netlink: fix state reallocation in policy export
Date:   Wed, 19 Aug 2020 12:22:55 +0200
Message-Id: <20200819122255.6b32aa54d205.I316de8a67c79a393ae1826a1b2dcc08f31b1856e@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Evidently, when I did this previously, we didn't have more than
10 policies and didn't run into the reallocation path, because
it's missing a memset() for the unused policies. Fix that.

Fixes: d07dcf9aadd6 ("netlink: add infrastructure to expose policies to userspace")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/netlink/policy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index f6491853c797..3f3b421fd70c 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -51,6 +51,9 @@ static int add_policy(struct nl_policy_dump **statep,
 	if (!state)
 		return -ENOMEM;
 
+	memset(&state->policies[state->n_alloc], 0,
+	       sizeof(state->policies[0]) * (n_alloc - state->n_alloc));
+
 	state->policies[state->n_alloc].policy = policy;
 	state->policies[state->n_alloc].maxtype = maxtype;
 	state->n_alloc = n_alloc;
-- 
2.26.2

