Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DE44EF661
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350453AbiDAPeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349536AbiDAO4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:56:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F3514D78E;
        Fri,  1 Apr 2022 07:44:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BC4D3CE2588;
        Fri,  1 Apr 2022 14:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E75C2BBE4;
        Fri,  1 Apr 2022 14:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824267;
        bh=RHkjZ/ykG3AVJbGV6ZXCEx5WIuzehh5fbGHFjHEsLow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1r2iZo+cHcveVW88ZGYWyzm92BXbKpZ5gX5iC/H/4GhHCFkgeC7UHWFwHnM/m/s9
         ZKXwu4maujMFsZRaUPGOIxDwHz8ZGNgdeddYTqY1rkVsjNZqSFY0BA0ZHAzSzS3vxt
         D/0xy6rxBjNnuDy1ulv8OZ314znPMPtoErPxH+KloWwhYBd0IT1+/zdphtjGRVx0Gy
         nPg32p/EmdCnWf5DmzUAD6sDkmXGTcB3pyjQBDtPlpgezd1PwCUnsH39+y3WmTJaBF
         fTlDjla+g6lvePx9nz7pgzK40Jqz821ELLJAc4S1ApOfRnRWKIyCG8zGkUlJ4Rrp8O
         gav44YiWQChNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        George Shuklin <george.shuklin@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, idosch@nvidia.com, petrm@nvidia.com,
        edumazet@google.com, yajun.deng@linux.dev, johannes.berg@intel.com,
        cong.wang@bytedance.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 56/65] net: limit altnames to 64k total
Date:   Fri,  1 Apr 2022 10:41:57 -0400
Message-Id: <20220401144206.1953700-56-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 155fb43b70b5fce341347a77d1af2765d1e8fbb8 ]

Property list (altname is a link "property") is wrapped
in a nlattr. nlattrs length is 16bit so practically
speaking the list of properties can't be longer than
that, otherwise user space would have to interpret
broken netlink messages.

Prevent the problem from occurring by checking the length
of the property list before adding new entries.

Reported-by: George Shuklin <george.shuklin@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 77b3d9cc08a1..873081cda950 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3626,12 +3626,23 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
 			   bool *changed, struct netlink_ext_ack *extack)
 {
 	char *alt_ifname;
+	size_t size;
 	int err;
 
 	err = nla_validate(attr, attr->nla_len, IFLA_MAX, ifla_policy, extack);
 	if (err)
 		return err;
 
+	if (cmd == RTM_NEWLINKPROP) {
+		size = rtnl_prop_list_size(dev);
+		size += nla_total_size(ALTIFNAMSIZ);
+		if (size >= U16_MAX) {
+			NL_SET_ERR_MSG(extack,
+				       "effective property list too long");
+			return -EINVAL;
+		}
+	}
+
 	alt_ifname = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (!alt_ifname)
 		return -ENOMEM;
-- 
2.34.1

