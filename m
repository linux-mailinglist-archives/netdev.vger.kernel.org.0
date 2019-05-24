Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDB529BBC
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390257AbfEXQED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:04:03 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:43148 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389962AbfEXQED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:04:03 -0400
Received: by mail-qk1-f202.google.com with SMTP id p190so10507778qke.10
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PfqUwzbXuTs277IKo16Wq5etgQO9hCFgF2Pi6PNJUgA=;
        b=fxb3t682fQW9RoPe2jA9jdS+GS43i4G9s9gJLLEBvrF0tMBof5+S0og3RG+sgr6eYG
         GCqP3p3mYatN+kow3li45jbp9qfQHJNmRCeogGPMiEwxn3draoHMAYovtRGoF0JA5RF9
         /UUZkpQg3o1NO2m+uoOeDKmAK8V7jQltFkyI9cLGFAyXaBlXbhavn9OBZNAvjISouP+4
         bZ7LeOuADZ7c0uttCB/nD9WGQqBKhrjOYJbzYklECDUxmiCViYEg4jKW4U25gYJJ3/UD
         itP8hGLO+DzXvkuSSlmwrdKJzKnKdM/J0fb5kDLbGVGNSJSQfges4S0XqQ51RaoV97ip
         j9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PfqUwzbXuTs277IKo16Wq5etgQO9hCFgF2Pi6PNJUgA=;
        b=CEjkl6BDd4G5AKcYij3bJfuzrbdBbAK0QFe8xnLaUEst3mRSy6NtflOkmtJkgm7tJ8
         FHAmndQ2ALn87WjjOqsKd7LFIgykyUvpsYxb+Wjlk+ttKsN8e9bGseGpu/Y+qW0wesXR
         S2iawbFhCFRwArVNafE5jLZ3auxVLvvkvSpt7qxolYdIbU0rec8/l6TyxaXlyxvFIP74
         hEupfNTGYU1spieJ1AdfeiXG6yWhkLoRnse4gEmeh0BMFr5jDmPrrYMe3VUy26uiAGqu
         x22aTtLDLYGqp8jC4Pwvno4+cNCSKnVH+a568V8g9nJjBLaXh5JRNE4xbHz4PYEJCxAG
         zdSA==
X-Gm-Message-State: APjAAAXSjuYJo2Bv22wXSulfJ/v247TZMNpFBXJRhpCpk+85nzcOgnl5
        wOaCF6PjVHtJSHJMWKNbxC1I+9WJWmoAvQ==
X-Google-Smtp-Source: APXvYqzxeRhEmmj9A8a6jRGspT+Wr43aaltttjYyu7vYgHI6fVWTIUnS4vGz1RP4K/gtCy2v1er9P7FWyBbyPw==
X-Received: by 2002:ac8:96d:: with SMTP id z42mr75453464qth.24.1558713842503;
 Fri, 24 May 2019 09:04:02 -0700 (PDT)
Date:   Fri, 24 May 2019 09:03:35 -0700
In-Reply-To: <20190524160340.169521-1-edumazet@google.com>
Message-Id: <20190524160340.169521-7-edumazet@google.com>
Mime-Version: 1.0
References: <20190524160340.169521-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 06/11] netfilter: ipv6: nf_defrag: no longer
 reference init_net in nf_ct_frag6_sysctl_table
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(struct net *)->nf_frag.fqdir will soon be a pointer, so make
sure nf_ct_frag6_sysctl_table[] does not reference init_net.

nf_ct_frag6_sysctl_register() can perform the needed initialization
for all netns.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 46073e9a6c566b0f019c94de902f347f6e0f0cba..3387ce53040953f16de1fbb447c744af87e0cefa 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -58,26 +58,21 @@ static struct inet_frags nf_frags;
 static struct ctl_table nf_ct_frag6_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_frag6_timeout",
-		.data		= &init_net.nf_frag.fqdir.timeout,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_frag6_low_thresh",
-		.data		= &init_net.nf_frag.fqdir.low_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra2		= &init_net.nf_frag.fqdir.high_thresh
 	},
 	{
 		.procname	= "nf_conntrack_frag6_high_thresh",
-		.data		= &init_net.nf_frag.fqdir.high_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= &init_net.nf_frag.fqdir.low_thresh
 	},
 	{ }
 };
@@ -93,15 +88,15 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 				GFP_KERNEL);
 		if (table == NULL)
 			goto err_alloc;
-
-		table[0].data = &net->nf_frag.fqdir.timeout;
-		table[1].data = &net->nf_frag.fqdir.low_thresh;
-		table[1].extra2 = &net->nf_frag.fqdir.high_thresh;
-		table[2].data = &net->nf_frag.fqdir.high_thresh;
-		table[2].extra1 = &net->nf_frag.fqdir.low_thresh;
-		table[2].extra2 = &init_net.nf_frag.fqdir.high_thresh;
 	}
 
+	table[0].data	= &net->nf_frag.fqdir.timeout;
+	table[1].data	= &net->nf_frag.fqdir.low_thresh;
+	table[1].extra2	= &net->nf_frag.fqdir.high_thresh;
+	table[2].data	= &net->nf_frag.fqdir.high_thresh;
+	table[2].extra1	= &net->nf_frag.fqdir.low_thresh;
+	table[2].extra2	= &init_net.nf_frag.fqdir.high_thresh;
+
 	hdr = register_net_sysctl(net, "net/netfilter", table);
 	if (hdr == NULL)
 		goto err_reg;
-- 
2.22.0.rc1.257.g3120a18244-goog

