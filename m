Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E975485426
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388849AbfHGT5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:57:41 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42471 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388713AbfHGT5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:57:41 -0400
Received: by mail-ot1-f68.google.com with SMTP id l15so109223111otn.9
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 12:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=STDBXZU+AObze0RyNc+5+shz+wPa9UDPBg3q4vreqTI=;
        b=elMPmohe8WF1u3gOvifQvRXeDHMPwoYK6qPtJaiQaJMZHa/v2dd7aEMSrhhaAD3czE
         zm1SXt5i1c+S1+AAuwrfaWheK3NrbvkWDsGveFyZOPiBGxSVScqjKulqaMbaG7TzMf4w
         bi28kgbKVdd9jeGnMRF9xDU7sSce2o7f1vIvpuHYqjQX8As991ciEMtiYKpgYQu38J9a
         3IMcKpPIsAcP+3Zd39w8n6wpKkLvuQxTOC+YQOsv2oXOLiv7OsD2xV7+/SggTRquDc0C
         xZ60zUfsUGuIgCys6JnhuDPRjZI9LHN4VJ7/gn4v3KqUkOptpGJwmdpOkl/912t8fYcY
         lJ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=STDBXZU+AObze0RyNc+5+shz+wPa9UDPBg3q4vreqTI=;
        b=F+PbCv/Z3sEpglEXenyzTPFrOQoqpYrK+8Z7A1Matt5L2tYjzoR6YQQUqzxXmfDkal
         lBgB0v5ptFA/MpCngUACydkyyz7eeTmfXUPkNw3S8JGyk0xi5LJfbMrcEWV4IViP6912
         SNBI9nDdoIIqSpJKPoiqxH8L0Z46C38tn6inDB8N68fUvmY2p7CFFZYNZVILegxNzHxZ
         syLdRZsnMvymNcyEXgoPIiTcNqAFLAlKZnvYSeXKQFHXYCeR4TKKeyhzkk/z9Vr2PGq0
         wnkcXWO/Db1tWjh1qYAdKxKcD0UAdrio19wqLcyV2iteMg6N19GGWfo7JsljFGIdgKW3
         nFag==
X-Gm-Message-State: APjAAAWHCglVI+dWznO3v4ceZ5FxIMh3wDh74DF1AdMYf4A0sPe7jcqV
        A197hD7rQw8wGTLjfXCq/lOAHQ==
X-Google-Smtp-Source: APXvYqwmnWTVDWJZ8gZNEOVIxD3FGnwkDSb3Os2+jKQMGp6TTUvylUZltEv5PJR4s7+qbyHt87QGGg==
X-Received: by 2002:a02:5d46:: with SMTP id w67mr12130411jaa.127.1565207860735;
        Wed, 07 Aug 2019 12:57:40 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id n7sm68971618ioo.79.2019.08.07.12.57.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 07 Aug 2019 12:57:40 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net 1/2] net sched: update skbedit action for batched events operations
Date:   Wed,  7 Aug 2019 15:57:28 -0400
Message-Id: <1565207849-11442-2-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565207849-11442-1-git-send-email-mrv@mojatatu.com>
References: <1565207849-11442-1-git-send-email-mrv@mojatatu.com>
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
index b100870f02a6..37dced00b63d 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -307,6 +307,17 @@ static int tcf_skbedit_search(struct net *net, struct tc_action **a, u32 index)
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
@@ -316,6 +327,7 @@ static struct tc_action_ops act_skbedit_ops = {
 	.init		=	tcf_skbedit_init,
 	.cleanup	=	tcf_skbedit_cleanup,
 	.walk		=	tcf_skbedit_walker,
+	.get_fill_size	=	tcf_skbedit_get_fill_size,
 	.lookup		=	tcf_skbedit_search,
 	.size		=	sizeof(struct tcf_skbedit),
 };
-- 
2.7.4

