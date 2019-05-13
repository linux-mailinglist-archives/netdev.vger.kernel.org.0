Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2AF61BD13
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 20:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfEMSSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 14:18:03 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40756 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfEMSSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 14:18:02 -0400
Received: by mail-pf1-f194.google.com with SMTP id u17so7619522pfn.7;
        Mon, 13 May 2019 11:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=36+jOu0ht7tlgiHoNQcp7BrubpLdVyc37a54it2Dibs=;
        b=ZXGitZOPho3Rn1Br7WqzAUhcPugupfAOS1g1jzI9C/k6MNnQupN8xXXyG+u0VPh2cA
         GUr82NXumWYb0hK3RcK+eY9sKTgqlzeqB8ZwGIcXsYym2r2SDXO81LP+c1EmEkg6gw3s
         +nlDb+JWMFLwvO+nGc5yzf0+1fumqZlCF6gTh6ZMeGCdD35pvbbz947hRNa1+IDnBZUa
         RbGAlkvycYuJFjb/xxzL+SYVdgmx6aYl6nnlr1+XPQgrpXhIrWamIaPZgJvmCI6dgZk7
         FWhbcFj9YBxMe+DfxDlXoYwj0N2bT3dbu5MkG3LDWE2QtFBPg1poreozaMIBgv3F9bMs
         HOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=36+jOu0ht7tlgiHoNQcp7BrubpLdVyc37a54it2Dibs=;
        b=bjjaVLOlKk9wB/WhIUcnJyOYUjB5ZjbgtmD/jZYgLNsQf5ov5jfASXr00Nzdjq9d10
         sn3mtTCyGEolC4BnN24GK/CQHuK5lxTQinnrA+19GPPkpKYNG4p51Y6UQA7fj139fUjd
         a9XRjbBxRdAr2ADIlm0+BgHSaKubg7EDs1zO79sC8zOzdxgCXbpHFJF7KE3a74dfPI0K
         YEZz86BJh3J+IwXN4BH/6w+xU4IDLI0UqEIXlJI/YyzbocoYkVw0VwPGm5s6SIksgTVf
         RfUXlZddY9S+pl8odevA37aDwokaKvUvOAs3e0ChfnwHxs8CdjixIblV+YkrWSosIvrx
         OB6g==
X-Gm-Message-State: APjAAAVGO1dk0jxTU0l1yufMNqElowwd3T3+DKxBumdMJYR77+LJuLBs
        //zbbvQUJ+u8QnIoZETo+HB4LqHbRgb0RA==
X-Google-Smtp-Source: APXvYqyT+RPYpysO9I0q51O/XMMsAZPo7tVSP5n8aXG0ZwVW929gbr4Muy5q7GpBDpTdubVwQnBhmQ==
X-Received: by 2002:a63:6b06:: with SMTP id g6mr21891464pgc.346.1557771481734;
        Mon, 13 May 2019 11:18:01 -0700 (PDT)
Received: from localhost.localdomain ([122.179.175.43])
        by smtp.googlemail.com with ESMTPSA id 140sm12257904pfw.123.2019.05.13.11.17.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 11:18:00 -0700 (PDT)
From:   Jagdish Motwani <j.k.motwani@gmail.com>
To:     netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     j.k.motwani@gmail.com,
        Jagdish Motwani <jagdish.motwani@sophos.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v3] netfilter: nf_queue:fix reinject verdict handling
Date:   Mon, 13 May 2019 23:47:40 +0530
Message-Id: <20190513181740.5929-1-j.k.motwani@gmail.com>
X-Mailer: git-send-email 2.9.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jagdish Motwani <jagdish.motwani@sophos.com>

This patch fixes netfilter hook traversal when there are more than 1 hooks
returning NF_QUEUE verdict. When the first queue reinjects the packet,
'nf_reinject' starts traversing hooks with a proper hook_index. However,
if it again receives a NF_QUEUE verdict (by some other netfilter hook), it
queues the packet with a wrong hook_index. So, when the second queue 
reinjects the packet, it re-executes hooks in between.

Fixes: 960632ece694 ("netfilter: convert hook list to an array")
Signed-off-by: Jagdish Motwani <jagdish.motwani@sophos.com>
---
 net/netfilter/nf_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 9dc1d6e..b5b2be5 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -255,6 +255,7 @@ static unsigned int nf_iterate(struct sk_buff *skb,
 repeat:
 		verdict = nf_hook_entry_hookfn(hook, skb, state);
 		if (verdict != NF_ACCEPT) {
+			*index = i;
 			if (verdict != NF_REPEAT)
 				return verdict;
 			goto repeat;
-- 
2.9.5

