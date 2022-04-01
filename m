Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DC44EF674
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350899AbiDAPev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349546AbiDAO4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:56:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7322E14A6DF;
        Fri,  1 Apr 2022 07:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F42160AC9;
        Fri,  1 Apr 2022 14:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A97C3410F;
        Fri,  1 Apr 2022 14:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824263;
        bh=v3hgsLK7hAdOzztv7jlsy2Qjn+2kOUKUZtNG8/pZkyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3Hdin8NcGcNkfviMWMeERIJ4qfB96KKhtA2Rm1wpyJb/XQAKgDYOk9zLgKv4cnTS
         bVz8XTtm8EerYDe9Plzdcp1E3uYaDbN7BVnE1z+kfnu6VAimI0YYqHIYLz9b2pVnvD
         kO92OooIwxgcCPo2sEa/J7VgTwWPFFbVxS1PTc96l2d5Iec+9UOjjm2hcKHJUh/T3+
         EpaPz3SXaeUsbxKnhLkLqeRgYuIbjGfd7afFeleDaNutxXUovfxcWaSZz/+K9NGqdA
         GE6BF5fY3LxgVqVGS4Mxmv3p/eziNPUqCe7nlTgVIyr8WBYP69Jvt4Bw5H2HZFRuEY
         pBBoxhV66YyQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        George Shuklin <george.shuklin@gmail.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, idosch@nvidia.com, petrm@nvidia.com,
        edumazet@google.com, avagin@gmail.com, yajun.deng@linux.dev,
        cong.wang@bytedance.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 55/65] net: account alternate interface name memory
Date:   Fri,  1 Apr 2022 10:41:56 -0400
Message-Id: <20220401144206.1953700-55-sashal@kernel.org>
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

[ Upstream commit 5d26cff5bdbebdf98ba48217c078ff102536f134 ]

George reports that altnames can eat up kernel memory.
We should charge that memory appropriately.

Reported-by: George Shuklin <george.shuklin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 9ff6d4160dab..77b3d9cc08a1 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3632,7 +3632,7 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
 	if (err)
 		return err;
 
-	alt_ifname = nla_strdup(attr, GFP_KERNEL);
+	alt_ifname = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (!alt_ifname)
 		return -ENOMEM;
 
-- 
2.34.1

