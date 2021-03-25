Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4401E34992F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhCYSIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhCYSIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 14:08:36 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2806BC06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:08:36 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id s21so1394471pjq.1
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zH76kWcIIbUl0mL3yKU5uEMeqp8w6i/B9uM7GDy0Tjg=;
        b=Qt4JWyUtythrFTACsCl+bTcZJebPvhOP7zTGLwxYBnAiXQ4zoEEc82wumb8XKUWDbG
         gSDGl1kclw5zT/5ZfCS46WDj/UPuvfT3CTG6cQBKTTCZ+AAqXi3ZzP52GWVWDmNyRzDD
         YdWYehANtK+cWJ/lWH74xIziSXW6ezIZbTfx2uBGh+CCwhzBjuB3H9C0CQOnE0L6NHGr
         OyS0MfsqbDPfE7rcH9uAQFcQy7/CX87ZQvLhwnrUTywGt2R4u3FI25US79zuRxSqU6Y5
         C3xVd+2s3lkntX0m4p1L1FWTDypk1D6txw1xvk6XsINf3azsLWskupmRFbnZEgOwpQDZ
         hhpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zH76kWcIIbUl0mL3yKU5uEMeqp8w6i/B9uM7GDy0Tjg=;
        b=nLG7Oa5R/qyJf+mu7p0uL6OlE+a1ZMWwmPJhSagR1nRzJIHqNqbhiyJY2sfjVjSYxl
         Mof0XVN8PtTiAbJGWpYlRKlhkRBziEyeQCpVqCMO1GNkfotwoz/m7MX9nKG4Zkxk+4BP
         jfjBoJBV8zzzagIEF5/PZjyc1RUvhozYFqV70tVb3cpNNIn/2YT0hYIFv4lejW+amVWz
         uKAm102fiJsupRB15F+Jtf3QfuGYkSg/JQuVqJSVwxfyB96slcZDF0AkYee8xOjXIhns
         rYotX2QVWgimfhPSMVg/fc4KNFX7rMV6w/9wafUzii1XWh7TaM3gTi9h2/uo9SBG7ZBr
         jt0w==
X-Gm-Message-State: AOAM531VUB0dVE5lSmkPBT8tKVv3umBzTFklQvB6ca+DEwIby6AHDVcp
        BSJ/hxu5KdxSarsro+hpojo=
X-Google-Smtp-Source: ABdhPJwIbe3z2KO26HvG6EXM4qtE3zj7xYSUH8Dzu+VnjC2DPcGSAFtL19WsM/SRVKinEjqC3vRjQQ==
X-Received: by 2002:a17:90a:2e0d:: with SMTP id q13mr10310679pjd.225.1616695715775;
        Thu, 25 Mar 2021 11:08:35 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2c0c:35d8:b060:81b3])
        by smtp.gmail.com with ESMTPSA id j20sm5968359pjn.27.2021.03.25.11.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:08:35 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/5] inet: convert tcp_early_demux and udp_early_demux to u8
Date:   Thu, 25 Mar 2021 11:08:16 -0700
Message-Id: <20210325180817.840042-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210325180817.840042-1-eric.dumazet@gmail.com>
References: <20210325180817.840042-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

For these sysctls, their dedicated helpers have
to use proc_dou8vec_minmax().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h   | 4 ++--
 net/ipv4/sysctl_net_ipv4.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index d2c0a6592ff6c0a3e954c157d109bf22d7bb701b..00f250ee441973586198014df8791c60ae298565 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -107,8 +107,8 @@ struct netns_ipv4 {
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	u8 sysctl_raw_l3mdev_accept;
 #endif
-	int sysctl_tcp_early_demux;
-	int sysctl_udp_early_demux;
+	u8 sysctl_tcp_early_demux;
+	u8 sysctl_udp_early_demux;
 
 	u8 sysctl_nexthop_compat_mode;
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 713e0c0c91e918274cb7cdf7212a6a3e5b8e140c..510a326356127c0a822f9a1215737a5c843fd58c 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -389,7 +389,7 @@ static int proc_tcp_early_demux(struct ctl_table *table, int write,
 {
 	int ret = 0;
 
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
 
 	if (write && !ret) {
 		int enabled = init_net.ipv4.sysctl_tcp_early_demux;
@@ -405,7 +405,7 @@ static int proc_udp_early_demux(struct ctl_table *table, int write,
 {
 	int ret = 0;
 
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
 
 	if (write && !ret) {
 		int enabled = init_net.ipv4.sysctl_udp_early_demux;
@@ -683,14 +683,14 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname       = "udp_early_demux",
 		.data           = &init_net.ipv4.sysctl_udp_early_demux,
-		.maxlen         = sizeof(int),
+		.maxlen         = sizeof(u8),
 		.mode           = 0644,
 		.proc_handler   = proc_udp_early_demux
 	},
 	{
 		.procname       = "tcp_early_demux",
 		.data           = &init_net.ipv4.sysctl_tcp_early_demux,
-		.maxlen         = sizeof(int),
+		.maxlen         = sizeof(u8),
 		.mode           = 0644,
 		.proc_handler   = proc_tcp_early_demux
 	},
-- 
2.31.0.291.g576ba9dcdaf-goog

