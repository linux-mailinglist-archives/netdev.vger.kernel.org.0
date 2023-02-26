Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6BB6A319B
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 16:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjBZPBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 10:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjBZO7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:59:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AAC1D911;
        Sun, 26 Feb 2023 06:52:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33D54B80BA8;
        Sun, 26 Feb 2023 14:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A3DC433EF;
        Sun, 26 Feb 2023 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423135;
        bh=VUBNHyPiMUDCeNLDF3HTZh9T+HdCso0ox85U9JL0BUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSLk/nw407Nb+9ilM+fA21wwO7L4n9d+c+N84qlKIN86NUrFwshsDh/QBi5/ay8mY
         tJIZ3BfPxdgpU8PKOL29/DNJMpJE1vChCIgbOdWncIge+gpDXP+wNo5iprjK5ZnZUR
         wo0nJUpLqm6W7ODc1OHWIdNjQXJjzzxH3zQcSLAUHMfFgNvbjf8FGKk9VRZQiFMzoQ
         ZyEi+dsgTagPrra+Uc3BBaPnpkPDo/q6ZpORV+jGkG1O65RWxPZZ6oFUJr9qlogtES
         UqtNOPBM+F/h4srQxioXbHm8rJNy7yNK7MR36lqhf0TWQOKsHFwkznwgTCjLxO9xyu
         FfRtP3oeAeMPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moshe Shemesh <moshe@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, idosch@nvidia.com,
        jacob.e.keller@intel.com, michal.wilczynski@intel.com,
        vikas.gupta@broadcom.com, shayd@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/19] devlink: health: Fix nla_nest_end in error flow
Date:   Sun, 26 Feb 2023 09:51:21 -0500
Message-Id: <20230226145123.829229-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145123.829229-1-sashal@kernel.org>
References: <20230226145123.829229-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit bfd4e6a5dbbc12f77620602e764ac940ccb159de ]

devlink_nl_health_reporter_fill() error flow calls nla_nest_end(). Fix
it to call nla_nest_cancel() instead.

Note the bug is harmless as genlmsg_cancel() cancel the entire message,
so no fixes tag added.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2dd354d869cd7..c6fef33d5d6d4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4991,7 +4991,7 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 	return 0;
 
 reporter_nest_cancel:
-	nla_nest_end(msg, reporter_attr);
+	nla_nest_cancel(msg, reporter_attr);
 genlmsg_cancel:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
-- 
2.39.0

