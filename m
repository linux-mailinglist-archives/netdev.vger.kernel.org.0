Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D383BD346
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238332AbhGFLjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237193AbhGFLgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F6C361ED1;
        Tue,  6 Jul 2021 11:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570766;
        bh=o8/SmWUqbQEyuMyc2gvCsZe1vXGfO6sLcc64P9UU7hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpJtrxOt2xIDn7IDmOevpMznaRhUbsF83MYrVS3HZzLntW15nglRm7MfOfxO2gKZV
         JEsJox9JHRZ3htxrkZjgbWe6yGi52c07Uu9hjUVcwv8wg1nfsw4Hpsdh1ENQrTOYyp
         sX0CH3JMZqyJMYom+B0ZYx51Mz72vTrbtt17IgVAZ4X8tOK8x+Z7dIyBO/xuyr2qSM
         85XfWyNIWf4yQgt3WDaT2LksuxjkYbn421ccsfCnsqu38jjMToDWxIwE3zj8YuLcmX
         You6/Z6dxowsa+AXjA9IQBv3VFO0Rxj5d3Cgl4jcqu2LHRhY0rUfXfYfUFUpe/jvOt
         Aes6u2PAQIMQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 50/74] net: sched: fix error return code in tcf_del_walker()
Date:   Tue,  6 Jul 2021 07:24:38 -0400
Message-Id: <20210706112502.2064236-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index 716cad677318..17e5cd9ebd89 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -316,7 +316,8 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	}
 	mutex_unlock(&idrinfo->lock);
 
-	if (nla_put_u32(skb, TCA_FCNT, n_i))
+	ret = nla_put_u32(skb, TCA_FCNT, n_i);
+	if (ret)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
 
-- 
2.30.2

