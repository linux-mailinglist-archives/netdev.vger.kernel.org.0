Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB686A3114
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 15:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjBZO4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 09:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjBZOyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:54:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E4A1ADF6;
        Sun, 26 Feb 2023 06:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E7B72CE0E9A;
        Sun, 26 Feb 2023 14:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD721C4339B;
        Sun, 26 Feb 2023 14:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422915;
        bh=JftbA8pjZkYzKu2cNx8SXIkVrmj9tuBPjcZuuDyJOxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MuWhV4yT49Lj9vRAUiH/WdB0iIr5Rz0Murk/POdX+VUkGsepEUJPnS1cEXFJgErZK
         uCAmQvqDiTJkKgiZ1hTrLavFdxSZP7XFY+Nt7DLEz5bv9jr3HFoZ1fXCo1ZMrMDc1V
         K4pdVoq6EV8GxB3utzlU0T0gfnqwf1aaLxYQDjLwki9VeonBanqykLop68arsdiaGa
         EECj3WMT/bZt0lEPi+DYRIwF6wOybG1M+LsKmol3M387Lyjvi7XwmbQvef6Zpj/Not
         xsbWAejlRMYuvk/yTiWomXagP2VnbsoRwUwiK9FK2vKl2xDftPyABAQBZ4Bo357NpC
         ZNuQOyZfpKEUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moshe Shemesh <moshe@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, idosch@nvidia.com,
        jacob.e.keller@intel.com, michal.wilczynski@intel.com,
        vikas.gupta@broadcom.com, shayd@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 47/49] devlink: health: Fix nla_nest_end in error flow
Date:   Sun, 26 Feb 2023 09:46:47 -0500
Message-Id: <20230226144650.826470-47-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 2aa77d4b80d0a..8f0c084e4135d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7628,7 +7628,7 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 	return 0;
 
 reporter_nest_cancel:
-	nla_nest_end(msg, reporter_attr);
+	nla_nest_cancel(msg, reporter_attr);
 genlmsg_cancel:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
-- 
2.39.0

