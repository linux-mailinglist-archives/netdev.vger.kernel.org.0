Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F893BCE73
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbhGFL0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233025AbhGFLTy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B274461CBB;
        Tue,  6 Jul 2021 11:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570218;
        bh=fKUD4iN2+LvMxirRuESye6PTUzOC5Oed4ow7L8huVTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZR4i4UU28UA2HMnd8EOnI0Uh4ntp4dZBJMqMG3s8O5P19Wzya/M9RQAwsr1+t06J
         f2G8Wj+yzgwpWnCWHoRIwcB/XWVx406QffUA8u+K+xdRknXeQsoEZe8E84I3VBFW3d
         7K4/LPcFXmdqSR+NpK0MMBYpBEi9o6ww4t2WaWJLi7qtzEjbiOOKE9fEoS+LYLc9Cs
         zqWvHmcEbxR1/2GYB76XhbahBVg4r8AMrNUNbcBANq4lJOxrRmVvnedQIUGlr0H3xQ
         TxbdP9RqgV7Q1mo462iYozIUchAjcnK3xqSOITMOxFFLtHuVwEmejB/LGmiSFQ0SSl
         BRa2zRjdT6mug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 126/189] net: sched: fix error return code in tcf_del_walker()
Date:   Tue,  6 Jul 2021 07:13:06 -0400
Message-Id: <20210706111409.2058071-126-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 55d96f72e8ddc0a294e0b9c94016edbb699537e1 ]

When nla_put_u32() fails, 'ret' could be 0, it should
return error code in tcf_del_walker().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f6d5755d669e..d17a66aab8ee 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -381,7 +381,8 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	}
 	mutex_unlock(&idrinfo->lock);
 
-	if (nla_put_u32(skb, TCA_FCNT, n_i))
+	ret = nla_put_u32(skb, TCA_FCNT, n_i);
+	if (ret)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
 
-- 
2.30.2

