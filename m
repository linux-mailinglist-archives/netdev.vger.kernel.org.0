Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 443BF29BBB
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390491AbfEXQEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:04:00 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:39357 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390314AbfEXQEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:04:00 -0400
Received: by mail-ua1-f73.google.com with SMTP id k28so2272175uag.6
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MrZ/Q/NJeC7Aufx/6OJ9iS4bRb8EKEx8CiFWUwQkqgU=;
        b=iYVEyRBTH6NFzgg50NfG6cQgO+qlloV8izM6C+L+Na+N+HPIfx26Levi19uRfI3I9n
         2flMa827n5DvDcW7tiSjWnn4MorswQGrGe1JBIIBt8lbTxooOUspA6tCdFTcrD8UacSy
         qVrU8Z2kubJ3XTBnOx33cKJ2hymoe+BWPcYd+4SMkNnO4hCOTkCmeWrWlcQGvTVtOgR3
         3acY+x3k3AaaUO6MC2tMBFkcGHsMa2fW+9m/9IpDs+hXGjgBoR7kTE5B7O0NJJc1nfnH
         wJxhSZYY46ASZUtvLAUZpOBXY0eQnIbnGMustCua/uTn5E3AVDxV6sEDXfymYOQHgpvg
         nIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MrZ/Q/NJeC7Aufx/6OJ9iS4bRb8EKEx8CiFWUwQkqgU=;
        b=I8d8P8IWyPZaNAVDksORZ6h8ibdCuutrZ+IUeRDEMESU896UY3haoXge0LJmgZTlBG
         S92F1/q84WTc+Meq1zkCPPMD3AxhHUegjqDoitX0pmNdz0yaQIy7zpZoMHuSAB5PYpAZ
         nC1kNMzVVf2f+Pwqonk2nIoLVhp8eSrajorrLAnGbGy9DN0ob73RmTuiX2Y89mdkQjuz
         8bUQ5jz1xWlD/Ck/WUQREQw5OXTueKVX87YvhwqfTgzsJzxSrox6CsGe4yRi8SmUoxus
         9hu+4vgokEPQJdq+Muhaorg0UbHdW5w9Xy0dPbeIjYgkjlWOyUzCTZ528WFQxYpFyo+q
         AAmg==
X-Gm-Message-State: APjAAAWcGdF5xWEO5XptSnPPkZYCiQu2gUIRYr9QepgZugSqP7VZSW8L
        CZHRxVBfyfSeZNvFoRjEOPR69QIZ2VzJEQ==
X-Google-Smtp-Source: APXvYqxLEqrrgl0wKxY8VIrX9PhWcoRmtYAbOZplFOeQkE4RAaURJKZEQw+1uVio2BRb75tiXGeRR/ksSsfBhA==
X-Received: by 2002:a9f:366b:: with SMTP id s40mr3282738uad.121.1558713839446;
 Fri, 24 May 2019 09:03:59 -0700 (PDT)
Date:   Fri, 24 May 2019 09:03:34 -0700
In-Reply-To: <20190524160340.169521-1-edumazet@google.com>
Message-Id: <20190524160340.169521-6-edumazet@google.com>
Mime-Version: 1.0
References: <20190524160340.169521-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 05/11] ipv6: no longer reference init_net in ip6_frags_ns_ctl_table[]
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

(struct net *)->ipv6.fqdir will soon be a pointer, so make
sure ip6_frags_ns_ctl_table[] does not reference init_net.

ip6_frags_ns_ctl_register() can perform the needed initialization
for all netns.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/reassembly.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 5160fd9ed223b723249b1c3f8ac3e2a97c7ffc43..aabc9b2e83e4ba9ae4af6a6d7047fe926c391d59 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -401,23 +401,18 @@ static const struct inet6_protocol frag_protocol = {
 static struct ctl_table ip6_frags_ns_ctl_table[] = {
 	{
 		.procname	= "ip6frag_high_thresh",
-		.data		= &init_net.ipv6.fqdir.high_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= &init_net.ipv6.fqdir.low_thresh
 	},
 	{
 		.procname	= "ip6frag_low_thresh",
-		.data		= &init_net.ipv6.fqdir.low_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra2		= &init_net.ipv6.fqdir.high_thresh
 	},
 	{
 		.procname	= "ip6frag_time",
-		.data		= &init_net.ipv6.fqdir.timeout,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -449,12 +444,12 @@ static int __net_init ip6_frags_ns_sysctl_register(struct net *net)
 		if (!table)
 			goto err_alloc;
 
-		table[0].data = &net->ipv6.fqdir.high_thresh;
-		table[0].extra1 = &net->ipv6.fqdir.low_thresh;
-		table[1].data = &net->ipv6.fqdir.low_thresh;
-		table[1].extra2 = &net->ipv6.fqdir.high_thresh;
-		table[2].data = &net->ipv6.fqdir.timeout;
 	}
+	table[0].data	= &net->ipv6.fqdir.high_thresh;
+	table[0].extra1	= &net->ipv6.fqdir.low_thresh;
+	table[1].data	= &net->ipv6.fqdir.low_thresh;
+	table[1].extra2	= &net->ipv6.fqdir.high_thresh;
+	table[2].data	= &net->ipv6.fqdir.timeout;
 
 	hdr = register_net_sysctl(net, "net/ipv6", table);
 	if (!hdr)
-- 
2.22.0.rc1.257.g3120a18244-goog

