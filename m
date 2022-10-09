Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF31E5F916E
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbiJIWcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiJIWaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F56FD0B;
        Sun,  9 Oct 2022 15:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60832B80D33;
        Sun,  9 Oct 2022 22:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF387C433C1;
        Sun,  9 Oct 2022 22:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353984;
        bh=KAnZS9WcwRk8bgKwx6yLV74+eQUR9dCSvwpUrV+4pIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGNrEkilKJAykfYGO1eDrgJ0MCNqCFMpQWyMGMFwoMRM2jUxwpRVGwbBY8OCPE3l1
         0ekGokuolmf1tFoYhF6FHeOdB6QQuLBw1EmMhXM9iMLd4IQWA1exc0GMuIgDlC4v33
         swu0lgmdoA7cZdoM+jbV1W4lLfBb2oiHWq2/Rm5yd1/A7HXjsj6Uqvsmpd2DMTVoMf
         UmOLSQpBeG7bxqx+PiyA2/ppO2D08HE+hNE8LuU2T1Mnn6T/DRDQkN33PNrgW3X5w4
         EDy1eblzkGaS3i1GRiVso/JYBuJjR1mqOmrktKZlRfVxwgniepTBg1wpAG/OlCscAa
         PUvdUYJM3uP2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, jacob.e.keller@intel.com,
        johannes@sipsolutions.net, nicolas.dichtel@6wind.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 10/46] genetlink: hold read cb_lock during iteration of genl_fam_idr in genl_bind()
Date:   Sun,  9 Oct 2022 18:18:35 -0400
Message-Id: <20221009221912.1217372-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
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

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 8f1948bdcf2fb50e9092c0950c3c9ac591382101 ]

In genl_bind(), currently genl_lock and write cb_lock are taken
for iteration of genl_fam_idr and processing of static values
stored in struct genl_family. Take just read cb_lock for this task
as it is sufficient to guard the idr and the struct against
concurrent genl_register/unregister_family() calls.

This will allow to run genl command processing in genl_rcv() and
mnl_socket_setsockopt(.., NETLINK_ADD_MEMBERSHIP, ..) in parallel.

Reported-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20220825081940.1283335-1-jiri@resnulli.us
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/genetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 57010927e20a..76aed0571e3a 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1362,7 +1362,7 @@ static int genl_bind(struct net *net, int group)
 	unsigned int id;
 	int ret = 0;
 
-	genl_lock_all();
+	down_read(&cb_lock);
 
 	idr_for_each_entry(&genl_fam_idr, family, id) {
 		const struct genl_multicast_group *grp;
@@ -1383,7 +1383,7 @@ static int genl_bind(struct net *net, int group)
 		break;
 	}
 
-	genl_unlock_all();
+	up_read(&cb_lock);
 	return ret;
 }
 
-- 
2.35.1

