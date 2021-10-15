Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125E642ED37
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbhJOJLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 05:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236895AbhJOJLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 05:11:50 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347ACC061570;
        Fri, 15 Oct 2021 02:09:44 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t11so5989874plq.11;
        Fri, 15 Oct 2021 02:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dqkAJ7cyGwsKnh2HC9/AWtnTSkngUFywloc5uLJfxlk=;
        b=Qdi/nUwkPz3L8BZgwRAxsKrBMXZCyZsVVsVOBFXz/6Lq9nlo4X8kG9ke5cLralNnXl
         MbomyyR84FuiSSrsFryNJ5sSqU1ejs17TrcdAzH1GmLtCuZy2c4pAwi4f/Agm8bwzRDV
         TESNkWnkxJKYhg62FJmrhOtyhrrebVTlbkqTWscfxADrZI2sKvvZ0VbGGM4S84Esknkj
         sddE19X8bs0nmpctoTWirrcIYbvIg2V4BU4GrpO7Qh2tJ/iMrsK7oK9E0EntzJRXJsj+
         ffI3uRkhZqDBxSxQnua9n33szhCGTQcSc13BxMW9AiIhguPabimRZxYBHI4pQzqS9mxR
         Fvrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dqkAJ7cyGwsKnh2HC9/AWtnTSkngUFywloc5uLJfxlk=;
        b=QtZn3fJW5mIgNkd0tC1hCu2o+S9w9GKuTrGU9s+MMfE5/VrgMDWM1dvJ42Twd4mtd5
         Ww4X80kRWh1NLRbhCZJFB3DsXNEOXV3QOjbbp7NvXz3faWAniLYdkV84ucGzKYEsPiju
         i5e6b16I9STEUXuv29+hMZQa+f+G5SvrnmQoHAXvR6KeeZx0GvW7u/zNQzs7p2y/OX2g
         rPcKnQEzvUrujwcHn97XQ4F8BK5MUoSR980LMIKM3+j6Hd+OuB5BXssof4vNwgktM2V+
         rPXqqXEC+hFz4Yz1TC0XCtHVlObbBMgw1TBKA2Skvdv8re+oqyNBK59YskzlCaplk+dY
         YZow==
X-Gm-Message-State: AOAM533zW+giQ2i04fWn7L09HVbyXtd5ex9dYaJevxqGWYphODs7SQnR
        kggi/ngZUvNzGGDB9OeGOKGkWX/XeNM=
X-Google-Smtp-Source: ABdhPJw4trk3u0yFq0vchr54Pz4m53l/MZxSY8AUPnBgmNddBu6L18Rrduqp9EJ92NqyYawO/EbWpA==
X-Received: by 2002:a17:90a:642:: with SMTP id q2mr12561538pje.55.1634288983429;
        Fri, 15 Oct 2021 02:09:43 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:fb72:79a:c1e7:291b])
        by smtp.gmail.com with ESMTPSA id i18sm4601981pfq.198.2021.10.15.02.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 02:09:42 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH netfilter] netfilter: conntrack: udp: generate event on switch to stream timeout
Date:   Fri, 15 Oct 2021 02:09:34 -0700
Message-Id: <20211015090934.2870662-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Without this it's hard to offload udp due to lack of a conntrack event
at the appropriate time (ie. once udp stream is established and stream
timeout is in effect).

Without this udp conntrack events 'update/assured/timeout=30'
either need to be ignored, or polling loop needs to be <30 second
instead of <120 second.

With this change:
      [NEW] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 [UNREPLIED] src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282
   [UPDATE] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282
   [UPDATE] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]
   [UPDATE] udp      17 120 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]
  [DESTROY] udp      17 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]
(the 3rd update/assured/120 event is new)

Cc: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: d535c8a69c19 'netfilter: conntrack: udp: only extend timeout to stream mode after 2s'
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 include/net/netfilter/nf_conntrack.h             |  1 +
 .../uapi/linux/netfilter/nf_conntrack_common.h   |  1 +
 net/netfilter/nf_conntrack_proto_udp.c           | 16 ++++++++++++++--
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index cc663c68ddc4..12029d616cfa 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -26,6 +26,7 @@
 
 struct nf_ct_udp {
 	unsigned long	stream_ts;
+	bool		notified;
 };
 
 /* per conntrack: protocol private data */
diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 4b3395082d15..a8e91b5821fa 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -144,6 +144,7 @@ enum ip_conntrack_events {
 	IPCT_SECMARK,		/* new security mark has been set */
 	IPCT_LABEL,		/* new connlabel has been set */
 	IPCT_SYNPROXY,		/* synproxy has been set */
+	IPCT_UDPSTREAM,		/* udp stream has been set */
 #ifdef __KERNEL__
 	__IPCT_MAX
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 68911fcaa0f1..f0d9869aa30f 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -97,18 +97,23 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 	if (!timeouts)
 		timeouts = udp_get_timeouts(nf_ct_net(ct));
 
-	if (!nf_ct_is_confirmed(ct))
+	if (!nf_ct_is_confirmed(ct)) {
 		ct->proto.udp.stream_ts = 2 * HZ + jiffies;
+		ct->proto.udp.notified = false;
+	}
 
 	/* If we've seen traffic both ways, this is some kind of UDP
 	 * stream. Set Assured.
 	 */
 	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		unsigned long extra = timeouts[UDP_CT_UNREPLIED];
+		bool stream = false;
 
 		/* Still active after two seconds? Extend timeout. */
-		if (time_after(jiffies, ct->proto.udp.stream_ts))
+		if (time_after(jiffies, ct->proto.udp.stream_ts)) {
 			extra = timeouts[UDP_CT_REPLIED];
+			stream = true;
+		}
 
 		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
 
@@ -116,9 +121,16 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 		if (unlikely((ct->status & IPS_NAT_CLASH)))
 			return NF_ACCEPT;
 
+		if (stream) {
+			stream = !ct->proto.udp.notified;
+			ct->proto.udp.notified = true;
+		}
+
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_ASSURED, ct);
+		else if (stream)
+			nf_conntrack_event_cache(IPCT_UDPSTREAM, ct);
 	} else {
 		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[UDP_CT_UNREPLIED]);
 	}
-- 
2.33.0.1079.g6e70778dc9-goog

