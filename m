Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F69C596002
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 18:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbiHPQTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 12:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbiHPQTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 12:19:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D3BCE9
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 09:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 73DE2CE19CF
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 16:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5423BC433C1;
        Tue, 16 Aug 2022 16:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660666781;
        bh=ubWJJpB6FlwS98BS2ErebUv6bhusNR1Ur0PtLHy6nDo=;
        h=From:To:Cc:Subject:Date:From;
        b=DnqNvYXF17TF9c+AcJfY7hvQ73llxyQ50G2xn48mFVKmLA9YSOU4cU3AkvjFEFMTO
         OcAROcRAXnH7cAalR50LUq+wT+EEhOXz5dm/Xa/+a5ZpDuFNZKbbWziCiZwcsZO+3p
         67Zr4GTVKDS3cYDkkcnL6Q4wu5i39CSL4Z5Tb7GkIc4RxLKWVjDzl0dtHEoWqvu3KR
         KUHVSH6HnmwZjrGR+OMKTu05i3M5Sy9ECvVp3EgymF6V+4dd8ftbUgH0oaB8Z0s9Ms
         3u3JH7hyEMIWtNnr9qCyWaMqT6cgCOxMobntZ3YTKrL7n5Ot6A9FMfRuD2gR4VFbJt
         SxHnxNGvXEXBg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com,
        johannes.berg@intel.com
Subject: [PATCH net v2] net: genl: fix error path memory leak in policy dumping
Date:   Tue, 16 Aug 2022 09:19:39 -0700
Message-Id: <20220816161939.577583-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If construction of the array of policies fails when recording
non-first policy we need to unwind.

netlink_policy_dump_add_policy() itself also needs fixing as
it currently gives up on error without recording the allocated
pointer in the pstate pointer.

Reported-by: syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com
Fixes: 50a896cf2d6f ("genetlink: properly support per-op policy dumping")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: johannes.berg@intel.com
---
 net/netlink/genetlink.c |  6 +++++-
 net/netlink/policy.c    | 14 ++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 1afca2a6c2ac..57010927e20a 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1174,13 +1174,17 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 							     op.policy,
 							     op.maxattr);
 			if (err)
-				return err;
+				goto err_free_state;
 		}
 	}
 
 	if (!ctx->state)
 		return -ENODATA;
 	return 0;
+
+err_free_state:
+	netlink_policy_dump_free(ctx->state);
+	return err;
 }
 
 static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index 8d7c900e27f4..87e3de0fde89 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -144,7 +144,7 @@ int netlink_policy_dump_add_policy(struct netlink_policy_dump_state **pstate,
 
 	err = add_policy(&state, policy, maxtype);
 	if (err)
-		return err;
+		goto err_try_undo;
 
 	for (policy_idx = 0;
 	     policy_idx < state->n_alloc && state->policies[policy_idx].policy;
@@ -164,7 +164,7 @@ int netlink_policy_dump_add_policy(struct netlink_policy_dump_state **pstate,
 						 policy[type].nested_policy,
 						 policy[type].len);
 				if (err)
-					return err;
+					goto err_try_undo;
 				break;
 			default:
 				break;
@@ -174,6 +174,16 @@ int netlink_policy_dump_add_policy(struct netlink_policy_dump_state **pstate,
 
 	*pstate = state;
 	return 0;
+
+err_try_undo:
+	/* Try to preserve reasonable unwind semantics - if we're starting from
+	 * scratch clean up fully, otherwise record what we got and caller will.
+	 */
+	if (!*pstate)
+		netlink_policy_dump_free(state);
+	else
+		*pstate = state;
+	return err;
 }
 
 static bool
-- 
2.37.2

