Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0037A6A315A
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 15:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjBZO5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 09:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjBZO4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:56:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301821ABD4;
        Sun, 26 Feb 2023 06:51:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14137B80C01;
        Sun, 26 Feb 2023 14:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F2AC433D2;
        Sun, 26 Feb 2023 14:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423080;
        bh=Q1wBiENj9Othi67AtU0NvlR1nHLaoZ+GwDEZTqoALrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWmnsS3WcYK9D+bVkFcKdu3OD98FLWux8cmCumCBNCv53QbZZW30D5i9EMFeFjccF
         dIZXShLkV/76dWqve+2luNyvV2NdG9El/Dh2yOL7oUDT8eonw+GdVYf/k8IAUjXJO7
         RXY+xVXELEeskCvAX/EuL0Bj0y3qVC0RbeacJDjhn0mpJdVZxcr21n+epfZYVN7Cod
         zIvTS/e7oz0k2znIf2VWGewhXqhYJXPhd+Pfswuo1aAsXeGZP66F0x/zWSspY0t0ia
         I5FdDIeaaGr0gkDkVcualMlM1FRsXhVFgJ/Q4RocTyN7mhSQUeeUGTJZEdn43eK1Cn
         UZ4YGqV29goOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moshe Shemesh <moshe@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, idosch@nvidia.com,
        jacob.e.keller@intel.com, michal.wilczynski@intel.com,
        vikas.gupta@broadcom.com, shayd@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/27] devlink: health: Fix nla_nest_end in error flow
Date:   Sun, 26 Feb 2023 09:50:14 -0500
Message-Id: <20230226145014.828855-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145014.828855-1-sashal@kernel.org>
References: <20230226145014.828855-1-sashal@kernel.org>
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
index 72047750dcd96..4fccd27a6082e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6093,7 +6093,7 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 	return 0;
 
 reporter_nest_cancel:
-	nla_nest_end(msg, reporter_attr);
+	nla_nest_cancel(msg, reporter_attr);
 genlmsg_cancel:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
-- 
2.39.0

