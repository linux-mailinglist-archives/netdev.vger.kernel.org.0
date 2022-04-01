Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6074EF0D7
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347576AbiDAOhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348336AbiDAOeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:34:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3B7B7F6;
        Fri,  1 Apr 2022 07:32:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C70C61C1A;
        Fri,  1 Apr 2022 14:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8581C340F2;
        Fri,  1 Apr 2022 14:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823535;
        bh=dGEdT/4UWGJMLbUw9a2FEv9E8tfibTs3j7vfva8scJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYGsJOyPIG0e/wLhrTqkQ9yEBn0WXKzsi11uOzkuXxsfGL8J0TmVlSFr7PZircYWG
         7IJL8oHV08VPEEave8JB1F+vwNqGjfNXSshMY7umkZyl0LiMDJ0gUmwkKS/+ZGRlAH
         pyKJph6pKO9RHby5ZimbZ93gERqLg8fU175HGyKX4/Sw1wO10fIJ0EWB+sBPgZWWv2
         gsXaOtnn3rZqTfay4evHDsXcTZxc+/11TFKwaIxW6bEC0cqhgULEkSocM1Iir0Lf9Z
         yiniONbPfJNliCwqJ1YxfEKUD4Qr6eqpmSxr/htRGjT5/i71IDilaAqLNMBGS06kKI
         DJbrXcPiXq8Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        George Shuklin <george.shuklin@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, idosch@nvidia.com, petrm@nvidia.com,
        edumazet@google.com, yajun.deng@linux.dev, avagin@gmail.com,
        cong.wang@bytedance.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 131/149] net: limit altnames to 64k total
Date:   Fri,  1 Apr 2022 10:25:18 -0400
Message-Id: <20220401142536.1948161-131-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
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
index 9c9ad3d4b766..43b995e935cd 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3652,12 +3652,23 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
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

