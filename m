Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBBF10500D
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfKUKIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:08:48 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46032 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfKUKIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:08:48 -0500
Received: by mail-pl1-f195.google.com with SMTP id w7so1328599plz.12
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 02:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=S6ko7ieOu6ek5USSBgHa7MFoeMQ6Jwy/CmRLB9vsZKo=;
        b=TYHvDxr8vAqyXovKVwlQHOqI3C/h2Ads4fIZ6XEuYhUthR1VTFdfFRr4Vsoaej8361
         v6v7rfwUGvN55dbglEsIzElxUsiJt6bL6NkDzJ23t3tTE1tGkbwQ8kpQxkFZeA8wFbGY
         xu7kM8b7gXo2S3M29Xiwsid7arBOIzRyxGCvJdlni24bUNURSz7StMC0/VhuOiwSxUG8
         4jtq7VdkURQDv+5OJ4j+D1SvXD8J2f40Hl9AOwFEzqJ25lnjR4NQ3Kth/oYvzisFl69K
         VO4J0mZ51MozuXc7SMAUOa+YUtsli1ZJsKvh2/gqWEC1vOjLfJGnPSSXPfaJfFTb6d4r
         tb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=S6ko7ieOu6ek5USSBgHa7MFoeMQ6Jwy/CmRLB9vsZKo=;
        b=iQWy7qzJ6SWjYBLMVSnMruGbvpqqejBvrJZR7CxXNbUl2ulrkSeBQg7OdHucEzmPzO
         i3vb0DY/j4vE8t5MnpqlJk0Pm/48n7JnPQ7MuP8JlCdM+eQDinng8vFLQkm40h3qYf6B
         8gCCbPTwBRzsi/QfWPBOa4UIO6iMTHx+6caH3ZUerGFtejM6Wd74qayWT7p8SCiQ9IN/
         owbrmTJmGhP0cfWvAR/h0TMyaHUTvgzDZJkp4Q1G/rwoSRobsfPT5aJhNWVz0UF/Gl7E
         LvBz0LgoEMdlNcDAp4jvRP5fkNU2TLLUHNv2CJ7Ghhiz2d5Mb2o1rW6v7x0q7ZreXzFf
         iCoQ==
X-Gm-Message-State: APjAAAWisBGDImU09mg1cI99a7Gls/NvVCHgjL8+PDdKtP2gPR6ReZVy
        RT7mv60XZuPCTjATw355Q8yS2GbX
X-Google-Smtp-Source: APXvYqzAnuWBftzFviaaQCnbWApgkrirI2Z68usCkwPu0aJcXF0f9IQ60JBzHQJPaOvQbwsMtQr2Og==
X-Received: by 2002:a17:902:b68b:: with SMTP id c11mr7758966pls.17.1574330926115;
        Thu, 21 Nov 2019 02:08:46 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l10sm2403155pjw.6.2019.11.21.02.08.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:08:45 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next] net: remove the unnecessary strict_start_type in some policies
Date:   Thu, 21 Nov 2019 18:08:38 +0800
Message-Id: <bcd455a3339a42f32dd2970d5495740ea1ee142d.1574330918.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ct_policy and mpls_policy are parsed with nla_parse_nested(), which
does NL_VALIDATE_STRICT validation, strict_start_type is not needed
to set as it is actually trying to make some attributes parsed with
NL_VALIDATE_STRICT.

This patch is to remove it, and do the same on rtm_nh_policy which
is parsed by nlmsg_parse().

Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/nexthop.c   | 1 -
 net/sched/act_ct.c   | 1 -
 net/sched/act_mpls.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index fc34fd1..511eaa9 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -23,7 +23,6 @@ static void remove_nexthop(struct net *net, struct nexthop *nh,
 #define NH_DEV_HASHSIZE (1U << NH_DEV_HASHBITS)
 
 static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
-	[NHA_UNSPEC]		= { .strict_start_type = NHA_UNSPEC + 1 },
 	[NHA_ID]		= { .type = NLA_U32 },
 	[NHA_GROUP]		= { .type = NLA_BINARY },
 	[NHA_GROUP_TYPE]	= { .type = NLA_U16 },
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 68d6af5..c13638ae 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -474,7 +474,6 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 }
 
 static const struct nla_policy ct_policy[TCA_CT_MAX + 1] = {
-	[TCA_CT_UNSPEC] = { .strict_start_type = TCA_CT_UNSPEC + 1 },
 	[TCA_CT_ACTION] = { .type = NLA_U16 },
 	[TCA_CT_PARMS] = { .type = NLA_EXACT_LEN, .len = sizeof(struct tc_ct) },
 	[TCA_CT_ZONE] = { .type = NLA_U16 },
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 4d8c822..c7d5e12 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -119,7 +119,6 @@ static int valid_label(const struct nlattr *attr,
 }
 
 static const struct nla_policy mpls_policy[TCA_MPLS_MAX + 1] = {
-	[TCA_MPLS_UNSPEC]	= { .strict_start_type = TCA_MPLS_UNSPEC + 1 },
 	[TCA_MPLS_PARMS]	= NLA_POLICY_EXACT_LEN(sizeof(struct tc_mpls)),
 	[TCA_MPLS_PROTO]	= { .type = NLA_U16 },
 	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_U32, valid_label),
-- 
2.1.0

