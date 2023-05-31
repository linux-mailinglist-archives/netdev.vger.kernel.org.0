Return-Path: <netdev+bounces-6651-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D90A4717364
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 03:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D05C22813D9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E04581111;
	Wed, 31 May 2023 01:55:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E8610E1
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 01:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E71C433EF;
	Wed, 31 May 2023 01:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685498126;
	bh=85YWpV5fC/e2jIRHx0N1NPniz8VWa/KFE8zsTTQ3F+o=;
	h=From:To:Cc:Subject:Date:From;
	b=Yss2zuT95TCKKkHtQbHCeWVlHo1kKX8/pR2gI6z6fOtS7KAO48YmLEmgkzLNsThk9
	 WQCs0BMSSruShp9tH7jZj7oLE27fkAxVy8ycN7X7/GAoJCBKz6sUHyV+c60jsbm2D0
	 Oo9glvUEgJqCp16X7Btw+EDROmMcCogZdU79cYKQGokqCTemlJ/sFwJ1nRYYDSiQkD
	 hJqtY8XgThri1RGNW59eCkqZki0rVgRQeb0nUbtavhZBaWZWigijIL1CsFUQX29iKS
	 F1EkhcFpopaOzSiZ5pvnW8fenFO98Zt1DuakkbIfEAElex5IYMCUoUtrnJglLeLO1i
	 lKz3AB8XgBCsw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	jiri@resnulli.us
Subject: [PATCH net-next] devlink: make health report on unregistered instance warn just once
Date: Tue, 30 May 2023 18:55:23 -0700
Message-Id: <20230531015523.48961-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Devlink health is involved in error recovery. Machines in bad
state tend to be fairly unreliable, and occasionally get stuck
in error loops. Even with a reasonable grace period devlink health
may get a thousand reports in an hour.

In case of reporting on an unregistered devlink instance
the subsequent reports don't add much value. Switch to
WARN_ON_ONCE() to avoid flooding dmesg and fleet monitoring
dashboards.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@resnulli.us
---
 net/devlink/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/devlink/health.c b/net/devlink/health.c
index 0839706d5741..194340a8bb86 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -480,7 +480,7 @@ static void devlink_recover_notify(struct devlink_health_reporter *reporter,
 	int err;
 
 	WARN_ON(cmd != DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
-	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
+	ASSERT_DEVLINK_REGISTERED(devlink);
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
-- 
2.40.1


