Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494C7E5D34
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfJZNfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727075AbfJZNQ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1790222CB;
        Sat, 26 Oct 2019 13:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095818;
        bh=D4p/k8K+pcrKKBqKJkh62m+JChkk/cjGS2MuusHjUes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4i4RYJwW7VO0nFDaeY+R+swtGjut0Ml6+Ip/hFjae/Psx5/9htURC/rhGvNy1get
         DCoRFePHl7DzzWUqfCmnB5pMT5tMWJ/8xHFjtQ0PgdEOiZJ4MiJVwXdqAZf6Tz2QGa
         izrMl6Gc/v2ifq7gIDioQPx8Ulq7SNQ+loaqHfFU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 32/99] net_sched: fix backward compatibility for TCA_ACT_KIND
Date:   Sat, 26 Oct 2019 09:14:53 -0400
Message-Id: <20191026131600.2507-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 4b793feccae3b06764268377a4030eb774ed924e ]

For TCA_ACT_KIND, we have to keep the backward compatibility too,
and rely on nla_strlcpy() to check and terminate the string with
a NUL.

Note for TC actions, nla_strcmp() is already used to compare kind
strings, so we don't need to fix other places.

Fixes: 199ce850ce11 ("net_sched: add policy validation for action attributes")
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 2558f00f6b3ed..4e7429c6f8649 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -832,8 +832,7 @@ static struct tc_cookie *nla_memdup_cookie(struct nlattr **tb)
 }
 
 static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
-	[TCA_ACT_KIND]		= { .type = NLA_NUL_STRING,
-				    .len = IFNAMSIZ - 1 },
+	[TCA_ACT_KIND]		= { .type = NLA_STRING },
 	[TCA_ACT_INDEX]		= { .type = NLA_U32 },
 	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
 				    .len = TC_COOKIE_MAX_SIZE },
@@ -865,8 +864,10 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 			NL_SET_ERR_MSG(extack, "TC action kind must be specified");
 			goto err_out;
 		}
-		nla_strlcpy(act_name, kind, IFNAMSIZ);
-
+		if (nla_strlcpy(act_name, kind, IFNAMSIZ) >= IFNAMSIZ) {
+			NL_SET_ERR_MSG(extack, "TC action name too long");
+			goto err_out;
+		}
 		if (tb[TCA_ACT_COOKIE]) {
 			cookie = nla_memdup_cookie(tb);
 			if (!cookie) {
-- 
2.20.1

