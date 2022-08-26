Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF175A1F4A
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244437AbiHZDJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 23:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243013AbiHZDJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:09:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36157CD52D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 20:09:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B265D61E76
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BB6C43470;
        Fri, 26 Aug 2022 03:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661483381;
        bh=U+rRVQ5sAdozv8sQu4U9NT8eV91m8JjR04k0G/nE7cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjJr4rSYTiFnhff5/tW+m1NpCUK1/wbHu44HY5ghLUH3qlOPn2BlydUYgSu6Btmw6
         ZnVTukx18Ar/v1pMcASUZYQzWHzx/j9f43xVf6gcfEinlkjxypy2SUZZNPzNlOHdyg
         d7Q74JGzP1WP/H9Nl6UykwgmJSRePbdFvTF7FpwiIyVe3ZqzZoAxqeV4rZF2wdI6C5
         o1d19An5lc7yLKRvUHLlNvRlW+aP+CMFhePJBc2Oy2JJfURP39thLR3WshUqQ79r51
         oRtQpd3zjK+Qu7kVdAoWuEszwi/oIdPpSWcA/6Kg+3CJQyS1xZr+1piBTIh8IkKfYe
         p7U1UifsW0Eog==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net, idosch@idosch.org,
        dsahern@gmail.com, stephen@networkplumber.org,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v3 6/6] ethtool: report missing header via ext_ack in the default handler
Date:   Thu, 25 Aug 2022 20:09:35 -0700
Message-Id: <20220826030935.2165661-7-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220826030935.2165661-1-kuba@kernel.org>
References: <20220826030935.2165661-1-kuba@kernel.org>
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
the low hanging fruit and check for missing header in
the default request handler.

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v3: s/handing/hanging/
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

