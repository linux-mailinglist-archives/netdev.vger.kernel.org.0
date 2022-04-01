Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6554EF179
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347750AbiDAOfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348331AbiDAOeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:34:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26965FEB;
        Fri,  1 Apr 2022 07:32:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF16DB8250B;
        Fri,  1 Apr 2022 14:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1689DC340EE;
        Fri,  1 Apr 2022 14:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823531;
        bh=Lz1Url1P/mLAEcNr+659oh6gNBcwli7JYLZvFxiwExs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1v+PIJruRgHETa1BJHVaH1XAepVUiHDHSrfKecJAg2UhbUj4VRYAEE3az+CskO2r
         P2O/6h8YKtKrGkbSDVORMJt64fXPVbQXcdM8JrSpTu+EuyFOw/aQ2kfpV35t6uNZ3J
         f1wgPSFBWeuxu5OsJzHIq2OUKcMuEdWZkxsDmILbpWZXvnH4fWLmGshf84uei8HrB1
         JESKuyp3cWT2ECJgEGj8OWo0gPTusCAx87488YckSIeKWlMI2k0G703blxEc7Icygv
         +2sgzzFagjLfU0NpJ3KdJe35WV8xwZQX6PeQWtl5z4xTnteWVybiwCnFcrEpb1HT14
         BZUekQDd/OtVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        George Shuklin <george.shuklin@gmail.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, idosch@nvidia.com, petrm@nvidia.com,
        edumazet@google.com, yajun.deng@linux.dev, johannes.berg@intel.com,
        cong.wang@bytedance.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 130/149] net: account alternate interface name memory
Date:   Fri,  1 Apr 2022 10:25:17 -0400
Message-Id: <20220401142536.1948161-130-sashal@kernel.org>
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
index 2fb8eb6791e8..9c9ad3d4b766 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3658,7 +3658,7 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
 	if (err)
 		return err;
 
-	alt_ifname = nla_strdup(attr, GFP_KERNEL);
+	alt_ifname = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (!alt_ifname)
 		return -ENOMEM;
 
-- 
2.34.1

