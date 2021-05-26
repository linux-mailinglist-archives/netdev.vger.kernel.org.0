Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87521391517
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 12:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbhEZKkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbhEZKkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 06:40:17 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2ED2C061756;
        Wed, 26 May 2021 03:38:44 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r10so547208wrj.11;
        Wed, 26 May 2021 03:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wkQYCEaVCPImpDNQXApDXqkhMOXth/QVgA22IjicNCE=;
        b=kxrmMXPTgj8Rg96huyyVsmvRDD+vQ50+xp5vx4cOLvOHfDyA0nt1uCgjoahFsQ9udJ
         em/dRiB29wGUtZhJ0+5ML0f3v0JRSHkPArkpBGMyCcQ6oWEuHvZzEbvBmxj2GOW9x62E
         zXgkrprVOigTpYaQLboFm48pM0b5QAvWPGUqb/yiK0ADD07q0JkzvtPS/xPLOOegfoHh
         xbCdv0mckb3fIh3xxgA5hwRobeWXSAECq6gfIlnsKClWalcsdrwYY4W1ka/DpofupBQa
         28rShX4GNLZYjozAQDi0scOnJbzvK7qI2/X9fHnGIdkkWx+uYm5q2G1kpiwwcXUvHZQr
         bg5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wkQYCEaVCPImpDNQXApDXqkhMOXth/QVgA22IjicNCE=;
        b=tzFWoD3pVfaAzhEkRJ51fP0ysNUfivFBkH/y41KJJokE4O1xUTjO1i0D0roXiIDGjq
         53oPZWQb8DyuqAQa1qjzVrYNk2gyRXivY66VRs6qAhtY0wiyy+W8gq+9eY3HVKTMjgzT
         QhX7T5YsryVZ7LWyMVjrOg/18M7e/DKxks494vUFCn+puoznPavBh6n0HmjElCFhYd+w
         N2GUNxkOWwxc4MgM8C+NkAoIk74bDoR4ncvrSo5iTkoYywqLRRMUF1NXF2hrlinDu5M3
         6anpmkVJFgD7bZcG+LQ5W/ZRvFKDIoSGk0827LlffdmN/BaF/YRuL/OQfyczg3TAKpj4
         5qvQ==
X-Gm-Message-State: AOAM530w4HraRH1hKpoiT5stFqaJbXmRJO/musdJLWb+gW/Q6Z+3Zfjp
        Y01B6ojXqBJggsdULlG7JAM=
X-Google-Smtp-Source: ABdhPJzssKk98FzRygK+8LF/Rw5iY/xRZeT+GSZNlzXKDKxpPwrJxp7vQAkIwly0OLep+uPdL51xtw==
X-Received: by 2002:a5d:4ccc:: with SMTP id c12mr32300476wrt.137.1622025523220;
        Wed, 26 May 2021 03:38:43 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:a50a:8c74:4a8f:62b3])
        by smtp.gmail.com with ESMTPSA id j101sm15364927wrj.66.2021.05.26.03.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 03:38:42 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Neal Cardwell <ncardwell@google.com>,
        Matt Mathis <mattmathis@google.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Leonard Crestez <lcrestez@drivenets.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFCv2 1/3] tcp: Use smaller mtu probes if RACK is enabled
Date:   Wed, 26 May 2021 13:38:25 +0300
Message-Id: <750563aba3687119818dac09fc987c27c7152324.1622025457.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1622025457.git.cdleonard@gmail.com>
References: <cover.1622025457.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RACK allows detecting a loss in rtt + min_rtt / 4 based on just one
extra packet. If enabled use this instead of relying of fast retransmit.

Suggested-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  5 +++++
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/sysctl_net_ipv4.c             |  7 +++++++
 net/ipv4/tcp_ipv4.c                    |  1 +
 net/ipv4/tcp_output.c                  | 26 +++++++++++++++++++++++++-
 5 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index a5c250044500..7ab52a105a5d 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -349,10 +349,15 @@ tcp_mtu_probe_floor - INTEGER
 	If MTU probing is enabled this caps the minimum MSS used for search_low
 	for the connection.
 
 	Default : 48
 
+tcp_mtu_probe_rack - BOOLEAN
+	Try to use shorter probes if RACK is also enabled
+
+	Default: 1
+
 tcp_min_snd_mss - INTEGER
 	TCP SYN and SYNACK messages usually advertise an ADVMSS option,
 	as described in RFC 1122 and RFC 6691.
 
 	If this ADVMSS option is smaller than tcp_min_snd_mss,
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 746c80cd4257..b4ff12f25a7f 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -112,10 +112,11 @@ struct netns_ipv4 {
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	u8 sysctl_tcp_l3mdev_accept;
 #endif
 	u8 sysctl_tcp_mtu_probing;
 	int sysctl_tcp_mtu_probe_floor;
+	int sysctl_tcp_mtu_probe_rack;
 	int sysctl_tcp_base_mss;
 	int sysctl_tcp_min_snd_mss;
 	int sysctl_tcp_probe_threshold;
 	u32 sysctl_tcp_probe_interval;
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 4fa77f182dcb..275c91fb9cf8 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -847,10 +847,17 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &tcp_min_snd_mss_min,
 		.extra2		= &tcp_min_snd_mss_max,
 	},
+	{
+		.procname	= "tcp_mtu_probe_rack",
+		.data		= &init_net.ipv4.sysctl_tcp_mtu_probe_rack,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		.procname	= "tcp_probe_threshold",
 		.data		= &init_net.ipv4.sysctl_tcp_probe_threshold,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 4f5b68a90be9..ed8af4a7325b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2892,10 +2892,11 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_base_mss = TCP_BASE_MSS;
 	net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
 	net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
 	net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
 	net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
+	net->ipv4.sysctl_tcp_mtu_probe_rack = 1;
 
 	net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
 	net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
 	net->ipv4.sysctl_tcp_keepalive_intvl = TCP_KEEPALIVE_INTVL;
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bde781f46b41..9691f435477b 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2311,10 +2311,19 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
 	}
 
 	return true;
 }
 
+/* Check if rack is supported for current connection */
+static int tcp_mtu_probe_is_rack(const struct sock *sk)
+{
+	struct net *net = sock_net(sk);
+
+	return (net->ipv4.sysctl_tcp_recovery & TCP_RACK_LOSS_DETECTION &&
+			net->ipv4.sysctl_tcp_mtu_probe_rack);
+}
+
 /* Create a new MTU probe if we are ready.
  * MTU probe is regularly attempting to increase the path MTU by
  * deliberately sending larger packets.  This discovers routing
  * changes resulting in larger path MTUs.
  *
@@ -2351,11 +2360,26 @@ static int tcp_mtu_probe(struct sock *sk)
 	 * smaller than a threshold, backoff from probing.
 	 */
 	mss_now = tcp_current_mss(sk);
 	probe_size = tcp_mtu_to_mss(sk, (icsk->icsk_mtup.search_high +
 				    icsk->icsk_mtup.search_low) >> 1);
-	size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;
+	/* Probing the MTU requires one packet which is larger that current MSS as well
+	 * as enough following mtu-sized packets to ensure that a probe loss can be
+	 * detected without a full Retransmit Time Out.
+	 */
+	if (tcp_mtu_probe_is_rack(sk)) {
+		/* RACK allows recovering in min_rtt / 4 based on just one extra packet
+		 * Use two to account for unrelated losses
+		 */
+		size_needed = probe_size + 2 * tp->mss_cache;
+	} else {
+		/* Without RACK send enough extra packets to trigger fast retransmit
+		 * This is dynamic DupThresh + 1
+		 */
+		size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;
+	}
+
 	interval = icsk->icsk_mtup.search_high - icsk->icsk_mtup.search_low;
 	/* When misfortune happens, we are reprobing actively,
 	 * and then reprobe timer has expired. We stick with current
 	 * probing process by not resetting search range to its orignal.
 	 */
-- 
2.25.1

