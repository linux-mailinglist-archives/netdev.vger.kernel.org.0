Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5669A5A0763
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiHYCls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiHYCli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:41:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213A89C532
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 19:41:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99423B82739
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04ADEC433B5;
        Thu, 25 Aug 2022 02:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661395289;
        bh=d/zrKgNc9d0TzFIaUNs4s2WwXsmPI66vM4g7mS2AC7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zg2Bug0cJ5Xil1sDEp9ii0m2gRTO7DDIwoW+yFbUlBSOexpdGz4vKywT5n89oWVcJ
         ZGrWGCAz6pY3GHbEtJETr4aUeXcxriLj4eD+Om2XnSNqEIK2VRIQEDsXG5GlOcmqbe
         E53K6oa9vyZ3BXcJ7MiP+n3xi5Pk9MNzDt8jmElfghXzxgtVpK2R++U59Kf4b6xa50
         sUNcvNDphWnWttwW2PT96YWBCqaLFYMZIr8/XDLvQfKLBUAiDkF62lsc8QS/08pXHy
         a8Nnk7L6FF0aRQkvs/rZcjOLJ1QwF3RL16b6gwMIpW0siTs7Oesv6zuJQzJJAj5vPD
         /lW4vfROs51Yg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net,
        Jakub Kicinski <kuba@kernel.org>, idosch@nvidia.com
Subject: [PATCH net-next v2 6/6] ethtool: report missing header via ext_ack in the default handler
Date:   Wed, 24 Aug 2022 19:41:22 -0700
Message-Id: <20220825024122.1998968-7-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825024122.1998968-1-kuba@kernel.org>
References: <20220825024122.1998968-1-kuba@kernel.org>
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

The actual presence check for the header is in
ethnl_parse_header_dev_get() but it's a few layers in,
and already has a ton of arguments so let's just pick
the low handing fruit and check for missing header in
the default request handler.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: idosch@nvidia.com
---
 net/ethtool/netlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index e26079e11835..0ccb177aaf04 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -361,6 +361,9 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 	ops = ethnl_default_requests[cmd];
 	if (WARN_ONCE(!ops, "cmd %u has no ethnl_request_ops\n", cmd))
 		return -EOPNOTSUPP;
+	if (GENL_REQ_ATTR_CHECK(info, ops->hdr_attr))
+		return -EINVAL;
+
 	req_info = kzalloc(ops->req_info_size, GFP_KERNEL);
 	if (!req_info)
 		return -ENOMEM;
-- 
2.37.2

