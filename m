Return-Path: <netdev+bounces-7889-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF234721FAC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44707280FF1
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89CE61097C;
	Mon,  5 Jun 2023 07:36:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4662F194
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC19C433D2;
	Mon,  5 Jun 2023 07:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685950580;
	bh=5H7FUn5pwJFv3fBM+cmCTciSdUDXJ11tuvYg9R9jMdQ=;
	h=From:To:Cc:Subject:Date:From;
	b=tGePzUVkXXMYfTa/g8FAN9/vulgXNerBcqbqIPCJByyH5y+RQx7XWdrM8Wb+IaLLX
	 gFEYQanJ5Hsc2e7oSwBPZiNEJT9QDGxmMKbUtjzrgtvsgKrgSglMzpKDxvfw/fc5C8
	 4rBcnVmYd5h9jisN2aHdk/KkgZ2B0DK/+FoszzHf0epg4deOl9MzA3NnZmQ1tD48KF
	 sXPdF6oO7LhCw5IhuGRvYQH7C7ubELGwKnRWUAMeGWAic1P9N+lCZdWsYAwQyHEJX7
	 rM3lSYEEwyajniN2GCS0vIDShTVpMsDyEBKaWJcOJht39lOw9CZOUvHMCFkjP/9BKz
	 9aByhQ+QZLAuw==
From: Leon Romanovsky <leon@kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Raed Salem <raeds@nvidia.com>
Subject: [PATCH ipsec-rc] xfrm: add missed call to delete offloaded policies
Date: Mon,  5 Jun 2023 10:36:15 +0300
Message-Id: <45c05c0028fd9bbd42893966caee2a314af91bab.1685950471.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Offloaded policies are deleted through two flows: netdev is going
down and policy flush.

In both cases, the code lacks relevant call to delete offloaded policy.

Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 6d15788b5123..6dcc714a9258 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1831,6 +1831,7 @@ int xfrm_policy_flush(struct net *net, u8 type, bool task_valid)
 
 		__xfrm_policy_unlink(pol, dir);
 		spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
+		xfrm_dev_policy_delete(pol);
 		cnt++;
 		xfrm_audit_policy_delete(pol, 1, task_valid);
 		xfrm_policy_kill(pol);
@@ -1869,6 +1870,7 @@ int xfrm_dev_policy_flush(struct net *net, struct net_device *dev,
 
 		__xfrm_policy_unlink(pol, dir);
 		spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
+		xfrm_dev_policy_delete(pol);
 		cnt++;
 		xfrm_audit_policy_delete(pol, 1, task_valid);
 		xfrm_policy_kill(pol);
-- 
2.40.1


