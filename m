Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C4D499C0C
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 23:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1576102AbiAXV7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 16:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456557AbiAXVjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:39:31 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE0BC0417CF
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:08 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id z131so5380676pgz.12
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tFjgLXrRuL7F2KSwzfEoWVhMB06yvCvTNDbKGRLmzI8=;
        b=mURdRWQwUrU8+IX86vcFEfrEaZHWiZOi1c5WB1rUUZ9SgxLpWWvTJPqoY6csF5hdiy
         m5ryDUQlPioD5xmw/WybPBkgrZP6sK9gBZhEPvtfw6j/xOZIHBP1RNMydDzbUbBt2oz/
         5gSeLo5Ek5jJpjhVhSPAg+PLTRY0OhOoYNbSXmHfRwiDflWFOzLOFjsYXkZCnaMYSibv
         mT6VkFJYblbmjZ3OrMGrteaxqgjtYlWwRWzETFQi9nEPu+GXvjUioDoyFaeo3PqubPJu
         701y8kp3+N/K059GzuIQIn7h+VXvhitozpwoiofDXckSAgmyL6TwFOh2iYeIxd0vJF3R
         9fuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tFjgLXrRuL7F2KSwzfEoWVhMB06yvCvTNDbKGRLmzI8=;
        b=WWszy0ir760exwVPpFpY/MLCE7q9ugEp3AKRKj1sZKRxfRXXpGUkGe2Jjvi/IWgtko
         O/GQp8nD7//wJClwGgB+Y38XvI148HAwT1DGGew00n5hJCiM9Yc6V65u+udl7XGSblSn
         t7ZE87Hfy2tadGfWuXyhXupG5+9U4ZVLtUTlwOc/eD/B40+ty5OV4maWBav5Va2KJtfz
         /WcO6snH/y5S0gkPvREJRQbWI7RJOxHxNDUxwNFDiEOtoHmPzkoX2naeHQaOXdROygjw
         XuwJDEH7Jqm1tganwSJTKlBUf9zkV87Ml0Uze3x9YbQObCUcNdosK01tydmYWfxYnUwe
         HC4A==
X-Gm-Message-State: AOAM533NLH7hjfdRyL0iJypQm58VMUjzX3iPvQZdnjUN/OpqCrzzucTa
        uSPRG1CpVX4ZgJJjge+orFI=
X-Google-Smtp-Source: ABdhPJyf+b5q8P7A/2RslQpYwzn6Qeq0pf9qBOl8ZOMaLy+63IB5jqctT0iCbnGhJyhcNBJIOs6Z0w==
X-Received: by 2002:a63:2502:: with SMTP id l2mr5027045pgl.162.1643055908448;
        Mon, 24 Jan 2022 12:25:08 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e903:2adf:9289:9a45])
        by smtp.gmail.com with ESMTPSA id c19sm17871115pfv.76.2022.01.24.12.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 12:25:08 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/6] tcp/dccp: no longer use twsk_net(tw) from tw_timer_handler()
Date:   Mon, 24 Jan 2022 12:24:53 -0800
Message-Id: <20220124202457.3450198-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220124202457.3450198-1-eric.dumazet@gmail.com>
References: <20220124202457.3450198-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We will soon get rid of inet_twsk_purge().

This means that tw_timer_handler() might fire after
a netns has been dismantled/freed.

Instead of adding a function (and data structure) to find a netns
from tw->tw_net_cookie, just update the SNMP counters
a bit earlier, when the netns is known to be alive.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_timewait_sock.h | 5 ++---
 net/ipv4/inet_timewait_sock.c    | 9 ++++-----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index c221fe2b77dd24d8e0d13db9819cdf3ac13fe742..b323db969b8b6df98ad84a9bb9aad646b4a8730c 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -65,10 +65,9 @@ struct inet_timewait_sock {
 	/* these three are in inet_sock */
 	__be16			tw_sport;
 	/* And these are ours. */
-	unsigned int		tw_kill		: 1,
-				tw_transparent  : 1,
+	unsigned int		tw_transparent  : 1,
 				tw_flowlabel	: 20,
-				tw_pad		: 2,	/* 2 bits hole */
+				tw_pad		: 3,	/* 3 bits hole */
 				tw_tos		: 8;
 	u32			tw_txhash;
 	u32			tw_priority;
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 6e8f4a6cd222e89b1c7f9fdd73b10d336ff026a1..e37e4852711c52bf8f6d01877297266cd19294ed 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -148,10 +148,6 @@ static void tw_timer_handler(struct timer_list *t)
 {
 	struct inet_timewait_sock *tw = from_timer(tw, t, tw_timer);
 
-	if (tw->tw_kill)
-		__NET_INC_STATS(twsk_net(tw), LINUX_MIB_TIMEWAITKILLED);
-	else
-		__NET_INC_STATS(twsk_net(tw), LINUX_MIB_TIMEWAITED);
 	inet_twsk_kill(tw);
 }
 
@@ -247,8 +243,11 @@ void __inet_twsk_schedule(struct inet_timewait_sock *tw, int timeo, bool rearm)
 	 * of PAWS.
 	 */
 
-	tw->tw_kill = timeo <= 4*HZ;
 	if (!rearm) {
+		bool kill = timeo <= 4*HZ;
+
+		__NET_INC_STATS(twsk_net(tw), kill ? LINUX_MIB_TIMEWAITKILLED :
+						     LINUX_MIB_TIMEWAITED);
 		BUG_ON(mod_timer(&tw->tw_timer, jiffies + timeo));
 		atomic_inc(&tw->tw_dr->tw_count);
 	} else {
-- 
2.35.0.rc0.227.g00780c9af4-goog

