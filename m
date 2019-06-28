Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEF8F5A397
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfF1Saf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:30:35 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33708 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfF1Saf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:30:35 -0400
Received: by mail-io1-f66.google.com with SMTP id u13so14586996iop.0
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EcccqFafgZ9t0CaVjnKrrQwh/8IwkvWfLKzhhOSUaKI=;
        b=UESEWUEn+iehK5VfxcqiffrnUJS3af3pmEWiA+H19EWRSmk9+oL+Bmd7LPoa47IeiQ
         XLkYWg8heZCZjlcdmqH+l5PFn4QW53qdvRtq+VOpf9zTen+DbMy2ro0xEPqRH+U9FRqk
         Wz2CmzrGUh6ff4GS2gWrWDt5E2KNnBH15coXEQ0S3cEzWnwjYIGyvNimOGEyWw8z/ov6
         jFj0U9KKlMbW4X7ZWxHJYbshkiIWYd8e+SPy/GuWfBzfGA2sic1pxNUsdMhAiU1WBU6a
         C5A08iDOUW4GgdIDOvlEj5pKNDoCSYn5EztNr/0t2Oj0+wxuxM8clPSnxsAozyxWJxaV
         v2hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EcccqFafgZ9t0CaVjnKrrQwh/8IwkvWfLKzhhOSUaKI=;
        b=S3HWOT+JFCje7vhSytg2rewTiYosewSOP3294Upm1Jkcmxk9jQVTGGLRVitV+V1stc
         FiDM76yfGeKEg6/2OlJkEIJHmdBurghKfhLyOatkKC7HoUYFyvfs3xx7rf1N0FXSFuS8
         RYxG0eNXeq+knU//YXMyT9Rzin6UyR76I6ATzReIZFQfnYhKojhXhzvLJaFS1cZQoJlk
         0sjEzP9p2JqDv82BMqx4PMeAAlaP3pY9kcuay2Dm5dKjz3OtWxTam4qDRkbDs3y4DGbS
         K1Nf2m1FVvaK7a8dwVCpcbBSy3sl7/nppJyA0BJBClPZqBxeHoammZof73tv2hLqhqmb
         lbfg==
X-Gm-Message-State: APjAAAXUJai1SJQUQqARACvby6l7q+H8J70y8FAiFqB3DRBccyhLTq3t
        XKQoGKAfZMy43GWra7RRvqcZYg==
X-Google-Smtp-Source: APXvYqzejeH7kI/Z0bL9LoDb/VDrlhaecrZiMvKg4CP8WkQ3RRFSNzG9AfG4stze4rEKR631bJL6bg==
X-Received: by 2002:a6b:e61a:: with SMTP id g26mr5775000ioh.300.1561746634789;
        Fri, 28 Jun 2019 11:30:34 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id t4sm2472804iop.0.2019.06.28.11.30.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 28 Jun 2019 11:30:34 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/2] net sched: update mirred action for batched events operations
Date:   Fri, 28 Jun 2019 14:30:17 -0400
Message-Id: <1561746618-29349-2-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561746618-29349-1-git-send-email-mrv@mojatatu.com>
References: <1561746618-29349-1-git-send-email-mrv@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add get_fill_size() routine used to calculate the action size
when building a batch of events.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 net/sched/act_mirred.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 58e7573dded4..2857c8dd4c04 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -411,6 +411,11 @@ static void tcf_mirred_put_dev(struct net_device *dev)
 	dev_put(dev);
 }
 
+static size_t tcf_mirred_get_fill_size(const struct tc_action *act)
+{
+	return nla_total_size(sizeof(struct tc_mirred));
+}
+
 static struct tc_action_ops act_mirred_ops = {
 	.kind		=	"mirred",
 	.id		=	TCA_ID_MIRRED,
@@ -422,6 +427,7 @@ static struct tc_action_ops act_mirred_ops = {
 	.init		=	tcf_mirred_init,
 	.walk		=	tcf_mirred_walker,
 	.lookup		=	tcf_mirred_search,
+	.get_fill_size	=	tcf_mirred_get_fill_size,
 	.size		=	sizeof(struct tcf_mirred),
 	.get_dev	=	tcf_mirred_get_dev,
 	.put_dev	=	tcf_mirred_put_dev,
-- 
2.7.4

