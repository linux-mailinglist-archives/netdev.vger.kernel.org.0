Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD0E6C078
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 19:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388112AbfGQRgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 13:36:44 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38558 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfGQRgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 13:36:43 -0400
Received: by mail-io1-f68.google.com with SMTP id j6so14762698ioa.5
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 10:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yFuQgRLCvgqVYgcCy+Uh7QQG8aoqbyuH7wC0cZg4/DQ=;
        b=vZ1LdyWmsK7LKyCa/QyseT4myK9rFEZd68XauT+ZH8XygzNg8ulcVq3fP2sGRBqWTP
         ETxlsAWcJaL85Q1yiyk1c+8NCe220RF1jm/5xTF5aLwajpHpjNpDeA4XYbWtDBX6cW9f
         3AUOMm2GLlXlTK30SZRmcuaS3fx2/gXOblqc2sXfhcBk3Qkedz1JbTq5Zf8qjvUAW5fI
         buRwPMZerleWPCaWNWuM8MQpRAHC2qyB9PY28GAltxqmco143HLMmIJMfRTQvNX/Kbvb
         XGZ6h31p5cCBUMNnaLGAgG2mfJogSrCxcwWy/7c9xLhxRKIQwN1IHnFyTJn81mMpxkZY
         bVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yFuQgRLCvgqVYgcCy+Uh7QQG8aoqbyuH7wC0cZg4/DQ=;
        b=cDOqZNc2qMe1/LZP7dzDjPAFQxv5iG2XglBnsQpIGAEhdsvmbiRKc3ZjY3j6zUb4YI
         wzsCZd6V5bteCsXRAPCNdIPDkrEMRxvM4K67RimC510OuI328uuOZTi0L4zs+D+2E1eL
         ndFdkqsGKy7rF/CourTL68SJI3rKR1TZB+9pqjm2GDXv8UQplB8ibx2I6OGNg8NUB1w3
         na6R1aO3rYRvDmtcEk1FUPVmLlsTldx8Kh+ccCNPDqLRYTHzJixEB59uULcUfil4PArM
         120O5IPtJT3tOfPXuuorM3BcqFK+2zNGbw1bHJzv/3bCyOE8YgigQSrqEcsXSGeGj4Y2
         IfNw==
X-Gm-Message-State: APjAAAUMvQX4sz6mAZtDjTcR/3joHc0wjGk52QJipL61p45EXH6BsAhB
        uGvCHVXWuFUUHsy5SYGch0E=
X-Google-Smtp-Source: APXvYqxVF93l3glNqKXR3q54YLWpGlxa+7Ymk55flDk8DB8AqwrFrKsRQsYFY9JLLEdrp15Wl6De0A==
X-Received: by 2002:a6b:b556:: with SMTP id e83mr37150548iof.94.1563385002920;
        Wed, 17 Jul 2019 10:36:42 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id 20sm29052967iog.62.2019.07.17.10.36.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 17 Jul 2019 10:36:42 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next v2 1/2] net sched: update skbedit action for batched events operations
Date:   Wed, 17 Jul 2019 13:36:31 -0400
Message-Id: <1563384992-9430-2-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563384992-9430-1-git-send-email-mrv@mojatatu.com>
References: <1563384992-9430-1-git-send-email-mrv@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add get_fill_size() routine used to calculate the action size
when building a batch of events.

Fixes: ca9b0e27e ("pkt_action: add new action skbedit")
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

