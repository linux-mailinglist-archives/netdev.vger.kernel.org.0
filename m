Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A9929BBA
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390419AbfEXQD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:03:57 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:39394 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390349AbfEXQD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:03:57 -0400
Received: by mail-qk1-f202.google.com with SMTP id x68so10505686qka.6
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YSYZ7I7vvg7Tq7BgGLVZXjzffIsFpA9i6n5UyQiYS7w=;
        b=n0vAsOBbXCziXPtk8U8yp6n5iveY+r3acBHzi2Gb2UnSdWEZDRkLF8MmvEL8zIqi6o
         qaOknMiMkKkBzFw22YXyzXJTgjdRY3y47eM6vB5Hx8hHGc8zxyelfoUbawcDNDal/VeL
         qzHAV3U/xRQhfe6Nom3xiOmqnpM2yXE7M6W5SOeccCbZQt/Iuhjb3aoE9U0L7UvfW9I6
         ZR/kVSobn4JG4d6gwaHPiErD4y3nTX75rcPg0Q+FF7mUz4Gx9Vb0FqT7SwObONIuCqbc
         K5B2C+fCQ75oFZWEU5QuVt2WgQuTpBV+A0gy0+xRcXJIAJEnT5mWUrsVfz8n9MSYxTCW
         W2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YSYZ7I7vvg7Tq7BgGLVZXjzffIsFpA9i6n5UyQiYS7w=;
        b=eqHZp9aVnwA3ZhVMBb911bxOqw6vPfGKnhpGHovgnMA3m/MmvTUIW5sgLrue8+alSs
         gfLYPK3Oajre6sXLNeoM+dGVwyAwtN5WZR2jhwEaTtZj6ifwifKEFujUJ8r6SutZONPS
         814SKB0yu11XVRPoqEo/baDCbJx5lw7SChPLGtFtHLMdZs3EnYkybOd+S3V8UxWjDaZf
         W96U2FdA6S2ixipXxB2rb7rr331oErvJ77aSKVuFYcMzNKSGP/mU2hhvSkHLvkLcTFjM
         T+GYR1xFI/qOiFwg01wrLAiTWFaL5agVm0STUQKRc7gsqlAzU870d3K+I0YEtvkiprwh
         ynWQ==
X-Gm-Message-State: APjAAAWgmU0x46Ah3MXaKthOLoYAI9mWpU1oRC17AS9zL40ShvL/7tFT
        +sX0wx/YU31fs1SvlscP7PNf2Ncyi0NxZg==
X-Google-Smtp-Source: APXvYqysIE5B7Wlbcy2y3QOp/KBXHW6x4N/SHhlsKY9AGCgl4cwN6E001O9Es0SHfxlHD+gq5uZtT5nXZa1vug==
X-Received: by 2002:a37:a387:: with SMTP id m129mr81687764qke.39.1558713836035;
 Fri, 24 May 2019 09:03:56 -0700 (PDT)
Date:   Fri, 24 May 2019 09:03:33 -0700
In-Reply-To: <20190524160340.169521-1-edumazet@google.com>
Message-Id: <20190524160340.169521-5-edumazet@google.com>
Mime-Version: 1.0
References: <20190524160340.169521-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 04/11] ipv4: no longer reference init_net in ip4_frags_ns_ctl_table[]
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

(struct net *)->ipv4.fqdir will soon be a pointer, so make
sure ip4_frags_ns_ctl_table[] does not reference init_net.

ip4_frags_ns_ctl_register() can perform the needed initialization
for all netns.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ip_fragment.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index f1831367cc2b188bdcc93f25818dda13e4348427..fb035f4f36ca72c6a9013830a3fb327d802b3e00 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -544,30 +544,24 @@ static int dist_min;
 static struct ctl_table ip4_frags_ns_ctl_table[] = {
 	{
 		.procname	= "ipfrag_high_thresh",
-		.data		= &init_net.ipv4.fqdir.high_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= &init_net.ipv4.fqdir.low_thresh
 	},
 	{
 		.procname	= "ipfrag_low_thresh",
-		.data		= &init_net.ipv4.fqdir.low_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra2		= &init_net.ipv4.fqdir.high_thresh
 	},
 	{
 		.procname	= "ipfrag_time",
-		.data		= &init_net.ipv4.fqdir.timeout,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ipfrag_max_dist",
-		.data		= &init_net.ipv4.fqdir.max_dist,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
@@ -600,13 +594,13 @@ static int __net_init ip4_frags_ns_ctl_register(struct net *net)
 		if (!table)
 			goto err_alloc;
 
-		table[0].data = &net->ipv4.fqdir.high_thresh;
-		table[0].extra1 = &net->ipv4.fqdir.low_thresh;
-		table[1].data = &net->ipv4.fqdir.low_thresh;
-		table[1].extra2 = &net->ipv4.fqdir.high_thresh;
-		table[2].data = &net->ipv4.fqdir.timeout;
-		table[3].data = &net->ipv4.fqdir.max_dist;
 	}
+	table[0].data	= &net->ipv4.fqdir.high_thresh;
+	table[0].extra1	= &net->ipv4.fqdir.low_thresh;
+	table[1].data	= &net->ipv4.fqdir.low_thresh;
+	table[1].extra2	= &net->ipv4.fqdir.high_thresh;
+	table[2].data	= &net->ipv4.fqdir.timeout;
+	table[3].data	= &net->ipv4.fqdir.max_dist;
 
 	hdr = register_net_sysctl(net, "net/ipv4", table);
 	if (!hdr)
-- 
2.22.0.rc1.257.g3120a18244-goog

