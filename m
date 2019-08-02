Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983FC800D1
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392214AbfHBTRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:17:00 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36304 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392202AbfHBTQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:16:59 -0400
Received: by mail-io1-f66.google.com with SMTP id o9so50889032iom.3
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 12:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Dnnz5VWCpf+4lPEi9I99vaZCEO1eO1JT5LR0jDai47s=;
        b=PdDcG3fne6XMtcbdg0xuCbj5wCwSZYlTH6l6ku41+TrycbZazxuo7BoVE6zyDou729
         mnE/tFP6Coou3ZKSTchBA7uZLvFW2MVmzhyfnfFXww4JClADMWVIBSsX174UvEZt3/5+
         kRwONtYnuyV998KvQN2i0hBwowL7P6kzVd/0dAYqwRI9V06sT0CilG5TcYQFP6g185xu
         WR/2zJwBFUCZOa91/i4P9ZZBs2zYd6lI+dNnMjpwvm40DF7aw6OlBlSoTO8JxhcBTZX/
         qUGfRK6CyV2wcvz26f/3OR4yDvLuvVG56z6ME2BE5dirZcMehmdd5UW0zAB5lJZFDoBq
         WEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Dnnz5VWCpf+4lPEi9I99vaZCEO1eO1JT5LR0jDai47s=;
        b=cK4nkzu0jOW6OhzmXnzKdDuImRNqV07NFbj8sAAUeXX4Kvb+Y8EDyu+aSuaWhFHFuP
         7giUAAXDnFK/SNivxvZyiFEaFUf4tRiRwKIEXIyj9O+zxdh01O6zUB0XwrO4u8yoaygl
         JUTurUPE7NtprM+rPKAmh2IUgl+QvtXCiANM3V8uyniuxOTSwPuITO3vQ4OjcUjzNfSe
         7cQ7HHbcLP9uVz0m99FIvaSjriWEXSvbY8e0Q1/l7pV9BdXXsW9aL18CCTAw1iTpC6k9
         FRWKviwGk/vYb5ZWbyAIJMI1loqNofwfzMjY04DcwqRl0nprXI7ORflWE6FiYjI5ax7G
         vY2Q==
X-Gm-Message-State: APjAAAU7VWJZwJD540TIVjlsZo0jked04w9Qhwu4iTkG+jo2OI5gwxBZ
        aMOtg51P7VnjGVVCUaGBAEY=
X-Google-Smtp-Source: APXvYqxEdP4BBA4Bm+S2PidDLlB4hdWnLIpy6d3vP3vAKLXr5DsWm8XK4rjkVHBE2FU5tlz6iPDhnA==
X-Received: by 2002:a6b:b756:: with SMTP id h83mr22843268iof.147.1564773418766;
        Fri, 02 Aug 2019 12:16:58 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id n22sm117987934iob.37.2019.08.02.12.16.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 02 Aug 2019 12:16:58 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net 1/2] net sched: update vlan action for batched events operations
Date:   Fri,  2 Aug 2019 15:16:46 -0400
Message-Id: <1564773407-26209-2-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564773407-26209-1-git-send-email-mrv@mojatatu.com>
References: <1564773407-26209-1-git-send-email-mrv@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add get_fill_size() routine used to calculate the action size
when building a batch of events.

Fixes: c7e2b9689 ("sched: introduce vlan action")
Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 net/sched/act_vlan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 9269d350fb8a..e0c97267bccb 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -306,6 +306,14 @@ static int tcf_vlan_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static size_t tcf_vlan_get_fill_size(const struct tc_action *act)
+{
+	return nla_total_size(sizeof(struct tc_vlan))
+		+ nla_total_size(sizeof(u16)) /* TCA_VLAN_PUSH_VLAN_ID */
+		+ nla_total_size(sizeof(u16)) /* TCA_VLAN_PUSH_VLAN_PROTOCOL */
+		+ nla_total_size(sizeof(u8)); /* TCA_VLAN_PUSH_VLAN_PRIORITY */
+}
+
 static struct tc_action_ops act_vlan_ops = {
 	.kind		=	"vlan",
 	.id		=	TCA_ID_VLAN,
@@ -315,6 +323,7 @@ static struct tc_action_ops act_vlan_ops = {
 	.init		=	tcf_vlan_init,
 	.cleanup	=	tcf_vlan_cleanup,
 	.walk		=	tcf_vlan_walker,
+	.get_fill_size	=	tcf_vlan_get_fill_size,
 	.lookup		=	tcf_vlan_search,
 	.size		=	sizeof(struct tcf_vlan),
 };
-- 
2.7.4

