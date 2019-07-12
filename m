Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 784D26767B
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfGLWWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:22:10 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44368 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727245AbfGLWWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:22:10 -0400
Received: by mail-io1-f67.google.com with SMTP id s7so23660586iob.11
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 15:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=FJBphtJzxfv/bW1v6btlQGrLVG76gEXfXb89lUeYsAI=;
        b=vVe/Gp9Tf0zN+cOsrI00upKIR5YAADZWQVZoR+dlXLbRsasEapQaKCW7VY5/osw8ii
         FOl74FSZz6yAtfz7OniXrRBZvUmOhU6A2Bgw94b91BG/Kezig0ptMOhPTKZgSox37d/S
         FgZTXPvwnDWmZ3HRSOikjaY2oQKSxz45bPXyYrKyIbXWw1AxmHzdhVxVa6JycfA7KddH
         yopwUmGUJtF5yHr/DdC1HWVkjAIuSrycHbTq4wTmo6yo7edTCEL3BoeUll/DebocS9Vj
         wWjpDBnB9g6fwckgoKcx827HpsnahsgQU1EgzOmtY43YahJScIIPqGJ7rwdJ61GZ1d/Q
         TGTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FJBphtJzxfv/bW1v6btlQGrLVG76gEXfXb89lUeYsAI=;
        b=olHAhxhqmiMwqzhw8/dEBM6cL2qeGFOYi8ZTlc5zYj0iiss6A4r3e/JB4kzMESreMV
         hiykYwPhDlTgj/JriGgFjn35eqy2DnOwCefcU+i1Q/fA067yCbaLKeDDBVUt6YysVkqa
         v0XoBZkj0hdkPLNWO6f49HoaEzr5u+YRv6/irXQzyYWafrFWogi2pIzpZEQ0te3bicXt
         Hszrmt7gqFmIOeoHWhkqi+tYZMHe5Qsd94UYu27hETBKo9uA+TzZ36A/l+Q2px9skp5x
         mQQLtM+o6EyNjGuxwr5C2fyTduL6+KK4nFBAxy6xpnMeQCdMe7i5J3osWPschlLmeXGs
         /fkg==
X-Gm-Message-State: APjAAAUbp2kyLclZTe+VVh1Z7FrwEGuHXv0pvQ89vw3lchVOr7ndBYVp
        lIu0ymaChcoGcjfvMiI0NeRtKlNQ
X-Google-Smtp-Source: APXvYqxYrkwTT1nJ3A1Q/s+fKXCGaqr3xbgMC1KIleV31rFz9yqmHnrVYe7rL1qEYofrJK18wJRvlA==
X-Received: by 2002:a5d:9416:: with SMTP id v22mr13808971ion.4.1562970129742;
        Fri, 12 Jul 2019 15:22:09 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id q22sm8074594ioj.56.2019.07.12.15.22.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 12 Jul 2019 15:22:09 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/2] net sched: update skbedit action for batched events operations
Date:   Fri, 12 Jul 2019 18:21:59 -0400
Message-Id: <1562970120-29517-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add get_fill_size() routine used to calculate the action size
when building a batch of events.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 net/sched/act_skbedit.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 215a06705cef..dc3c653ec45e 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -306,6 +306,17 @@ static int tcf_skbedit_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static size_t tcf_skbedit_get_fill_size(const struct tc_action *act)
+{
+	return nla_total_size(sizeof(struct tc_skbedit))
+		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_PRIORITY */
+		+ nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_QUEUE_MAPPING */
+		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_MARK */
+		+ nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_PTYPE */
+		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_MASK */
+		+ nla_total_size_64bit(sizeof(u64)); /* TCA_SKBEDIT_FLAGS */
+}
+
 static struct tc_action_ops act_skbedit_ops = {
 	.kind		=	"skbedit",
 	.id		=	TCA_ID_SKBEDIT,
@@ -315,6 +326,7 @@ static struct tc_action_ops act_skbedit_ops = {
 	.init		=	tcf_skbedit_init,
 	.cleanup	=	tcf_skbedit_cleanup,
 	.walk		=	tcf_skbedit_walker,
+	.get_fill_size	=	tcf_skbedit_get_fill_size,
 	.lookup		=	tcf_skbedit_search,
 	.size		=	sizeof(struct tcf_skbedit),
 };
-- 
2.7.4

