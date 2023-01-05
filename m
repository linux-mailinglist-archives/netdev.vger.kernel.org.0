Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C27865E460
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjAEEGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjAEEFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:05:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D7B37252
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B901CB819AD
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C023C433F0;
        Thu,  5 Jan 2023 04:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672891542;
        bh=lTYNgMJoA6exOnKhKnUDhYtJqWLmyw9dmJzx3Ji0AWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jICjor6X/jPAUoPlvOwG3LEGYyvNJw4agKaj1VF7+fqtxgGxmj4g6mjHssmCva+A+
         8p9rCCF15xuhqU65ejzuoeATuPRkonkjiC1NEbMOn+p9keG5qwn6+DtkQnAuAHZmSY
         lKrJN3uOWzQZFpC+DGx6YnDEhX/DxLGvuw3QVkA8mE/dy6KUnu557QPkpmgtt4VFa4
         deWqK5Ogcmu6t12Q8XDcHVzx127dQTs/kbuC6OVXQJUonis9V/6qeJsHHUlL8IgTjI
         TQiVJIGOVicytUhyf3mQuibYJN+RVHjQZ3jty0UoFcdXHcgZa/ry4yxjPxPxxf0Zys
         GoszpkMZwXzrg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 09/15] devlink: health: combine loops in dump
Date:   Wed,  4 Jan 2023 20:05:25 -0800
Message-Id: <20230105040531.353563-10-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105040531.353563-1-kuba@kernel.org>
References: <20230105040531.353563-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Walk devlink instances only once. Dump the instance reporters
and port reporters before moving to the next instance.
User space should not depend on ordering of messages.

This will make improving stability of the walk easier.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index d88461b33ddf..83cd7bd55941 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7940,10 +7940,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			idx++;
 		}
 		mutex_unlock(&devlink->reporters_lock);
-		devlink_put(devlink);
-	}
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		xa_for_each(&devlink->ports, port_index, port) {
 			mutex_lock(&port->reporters_lock);
-- 
2.38.1

