Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3654EF2A3
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348789AbiDAOz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352629AbiDAOvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:51:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDB5294A39;
        Fri,  1 Apr 2022 07:42:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8C9DB8240F;
        Fri,  1 Apr 2022 14:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D4CC2BBE4;
        Fri,  1 Apr 2022 14:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824091;
        bh=uuujoU80f34Vm6LW6kP45+MJG3kikm0acZFZVljE2Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqY5wa2kIlAjFItX0xUj38nZuFn0e3eoK1zk2l0+4sozZ379COKQMqC3vNgSqUTYm
         BYptXVtgudnFmpMVgYLZSGheSs2k+XUDVUcbNTpQw7l6x/WTG6D0I6NhF6ofNMjHnM
         OQpMEmIuFyQb6QiayGTQGF9HNfJT1AUrbFRhLn1MD4jOnl9uVUMaPPiskWjGNi7QXY
         HDCRLPm5JW6VTC/lbnm9a2BoFVFkXmm+bJ4en7102CLJqxxidYX1qeLb72G6zO5n/O
         eScR3A68y91BeLOQozKDLrjl7Kc3sI0RsAqZq0g4EzT4oi/eW6J1SeKGUbHhjEYDE4
         zL2566npuP99Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        George Shuklin <george.shuklin@gmail.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, idosch@nvidia.com, petrm@nvidia.com,
        edumazet@google.com, johannes.berg@intel.com, avagin@gmail.com,
        cong.wang@bytedance.com, yajun.deng@linux.dev,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 82/98] net: account alternate interface name memory
Date:   Fri,  1 Apr 2022 10:37:26 -0400
Message-Id: <20220401143742.1952163-82-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
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
index 91d7a5a5a08d..a8c319dc224a 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3637,7 +3637,7 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
 	if (err)
 		return err;
 
-	alt_ifname = nla_strdup(attr, GFP_KERNEL);
+	alt_ifname = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (!alt_ifname)
 		return -ENOMEM;
 
-- 
2.34.1

