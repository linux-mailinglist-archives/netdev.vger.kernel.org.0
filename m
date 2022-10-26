Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3CB60D863
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 02:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbiJZAPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 20:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiJZAPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 20:15:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807C6D73EB
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 17:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BBF9B81FC3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D934C433D6;
        Wed, 26 Oct 2022 00:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666743330;
        bh=YL/wEoPB4huA2toZyjAa+vlRVdcNpTwXfWckiS7Ne6Y=;
        h=From:To:Cc:Subject:Date:From;
        b=fd6uPzvidiGcNWjGE5xWy04dAhHNs0zgpXZ0CEroaB61LfhAE+KGSy0HB0gTQ5MY/
         Xjxj4bZ2HM8nRPQjtip6kP3RAvE/yYbvwg7d63ua6qA7DhsMgmS30Z/wy/5V3LPFJi
         3xOd8gyEZgxl5UM/5+gQQqr72mUZxFlYO4+pMBE4vcJptymbMFnEMBTA5u3X0NMzQT
         WGirXyzkOAHARrnPCMZEAUGZY4MMv6HdwNXJYFdBLPCtTkXA83YwyqtYafM1U6tqq3
         6UIesMJv/AD3jKdEKigwTRpnBxff+2kjzDt+Uqntbh70dQA2/4R8Rmji0Ymu3ihQWr
         1NvaOoOFe0KMQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, johannes@sipsolutions.net,
        Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com
Subject: [PATCH net] genetlink: limit the use of validation workarounds to old ops
Date:   Tue, 25 Oct 2022 17:15:24 -0700
Message-Id: <20221026001524.1892202-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During review of previous change another thing came up - we should
limit the use of validation workarounds to old commands.
Don't list the workarounds one by one, as we're rejecting all existing
ones. We can deal with the masking in the unlikely event that new flag
is added.

Link: https://lore.kernel.org/all/6ba9f727e555fd376623a298d5d305ad408c3d47.camel@sipsolutions.net/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@nvidia.com
---
 net/netlink/genetlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index b1fd059c9992..3e16527beb91 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -380,6 +380,8 @@ static int genl_validate_ops(const struct genl_family *family)
 		genl_get_cmd_by_index(i, family, &op);
 		if (op.dumpit == NULL && op.doit == NULL)
 			return -EINVAL;
+		if (WARN_ON(op.cmd >= family->resv_start_op && op.validate))
+			return -EINVAL;
 		for (j = i + 1; j < genl_get_cmd_cnt(family); j++) {
 			struct genl_ops op2;
 
-- 
2.37.3

