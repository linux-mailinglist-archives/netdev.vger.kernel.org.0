Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B2A3BD5C6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240275AbhGFMZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236690AbhGFLfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6317C61E18;
        Tue,  6 Jul 2021 11:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570644;
        bh=eSycJIMDZXZyrd/1c7nOzr9jCCy03KoTysMTjCZp9IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtjIy4/krKs/AvGAR6CEwAzw8eZ430EQTmmB7pHE3uxaKrqqAyVmi2PafUmsbOH9M
         VKnhW/omgKmBSHsyb5z2FH4S3DzN59tlP5egaygqimU7AQ5XqYtmPuiwnv2MDsdBEY
         ATiSnkWqFo88mbqqNTV0kelCBlmJGTyaSqqd6+LzAN17AHOL4YuBeT/pD4g/XL4m73
         EZwDzwbOltcrOQnL9q44j6y8byfm0mueh1kEJXxZU8U9pywPeNcMIjuI1t73X3a+in
         FQxsMFBhojQJS4PXVCvnL81MqoUoSnxBzMaFr4M1KMD9YD2CaC4FH4h5hS9XLNOdeW
         RUq0ovQhbsRMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 093/137] net: sched: fix error return code in tcf_del_walker()
Date:   Tue,  6 Jul 2021 07:21:19 -0400
Message-Id: <20210706112203.2062605-93-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index 88e14cfeb5d5..f613299ca7f0 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -333,7 +333,8 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	}
 	mutex_unlock(&idrinfo->lock);
 
-	if (nla_put_u32(skb, TCA_FCNT, n_i))
+	ret = nla_put_u32(skb, TCA_FCNT, n_i);
+	if (ret)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
 
-- 
2.30.2

