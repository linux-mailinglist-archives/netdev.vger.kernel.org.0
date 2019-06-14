Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A836246CCC
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfFNXWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:22:34 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:40026 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFNXWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:22:34 -0400
Received: by mail-yw1-f74.google.com with SMTP id t203so4214359ywe.7
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 16:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ArF7Y2tfpeEQe2L/wOI6CBIb7ffTUes1h1n0lPR98II=;
        b=tLuvaqoEvZLLVqKVuc4+Wj63mUsZEe4q3pO68kvSMPgBiqDKCH/Nt+PUWUyUWHLDlU
         5Z17EpsAoySds2/aunNzDcqbUzk8wn4BDJcPC3yTx4XW0OelKH9bUyV6BZCAH1DeiDo8
         w7g5eIAIdH6HQe04UTSIj4awMtkcxvYJTaR493c38pNG9nnHIsSZ6JU6ezu34dFUGVNc
         7qG06JKB//u6twNMjs1PViw9D8N1nvWHW+wddYaD3xmeowc3LFYWs+l7tfWl//4Nn6dD
         vqad+IPyCpGTMlrLS9BOOCJTVqYMUCUX09FJN5piSZLQQazjYaPr4+CEKhAlaWz4uei2
         VcTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ArF7Y2tfpeEQe2L/wOI6CBIb7ffTUes1h1n0lPR98II=;
        b=h6zxCLnNS5KPen+7lPt0syQc5Noje0lWcvh7JM3OzjIU+p21Gldibv5rSb/frovjRv
         MSLss1WiNjrxGmoTmuEFGXvmxi2Hw9sMOcvxG4hABH75Ecnfza7f85IYo5VTmfPcgkAT
         P38eMOdHVCThk8sYziPwOh0VmVhGabjfOtk9B/VtIwWPY/jKIrg3bi4B8k17QN+3/Ywd
         s4t6Ha+Kwz0OiU+p27Je4C+seRgm+3hkGx7PWZsCNZrv3ZfHPwT+a28KgjK5aupviRkC
         1C8QkbJmr/ii/ojIFcyNBkXAOUV6tixxqvopum2fEGpsXZOETT+I1ATd+R5pDkOfLM2w
         xkFQ==
X-Gm-Message-State: APjAAAVjCR61dI5mFO+03xbxHCdPxsiZa5iLJYsc2/oPbn6ehYj3kCxb
        LVMvy/oORfnUA0gM48rjF452XBpbAY4BgQ==
X-Google-Smtp-Source: APXvYqwW+oOVIi41fh+Mz2PDARALgT36t/bMcFsTZ21die0/JqC0gdSZGPmU19uc2B09P8EIYJbgWmjGUNKVwQ==
X-Received: by 2002:a0d:cd47:: with SMTP id p68mr52818079ywd.268.1560554553676;
 Fri, 14 Jun 2019 16:22:33 -0700 (PDT)
Date:   Fri, 14 Jun 2019 16:22:19 -0700
In-Reply-To: <20190614232221.248392-1-edumazet@google.com>
Message-Id: <20190614232221.248392-3-edumazet@google.com>
Mime-Version: 1.0
References: <20190614232221.248392-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net 2/4] tcp: add tcp_rx_skb_cache sysctl
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of relying on rps_needed, it is safer to use a separate
static key, since we do not want to enable TCP rx_skb_cache
by default. This feature can cause huge increase of memory
usage on hosts with millions of sockets.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 Documentation/networking/ip-sysctl.txt | 8 ++++++++
 include/net/sock.h                     | 6 ++----
 net/ipv4/sysctl_net_ipv4.c             | 9 +++++++++
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 14fe93049d28e965d7349b03c5c8782c3d386e7d..288aa264ac26d98637a5bb1babc334bfc699bef1 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -772,6 +772,14 @@ tcp_challenge_ack_limit - INTEGER
 	in RFC 5961 (Improving TCP's Robustness to Blind In-Window Attacks)
 	Default: 100
 
+tcp_rx_skb_cache - BOOLEAN
+	Controls a per TCP socket cache of one skb, that might help
+	performance of some workloads. This might be dangerous
+	on systems with a lot of TCP sockets, since it increases
+	memory usage.
+
+	Default: 0 (disabled)
+
 UDP variables:
 
 udp_l3mdev_accept - BOOLEAN
diff --git a/include/net/sock.h b/include/net/sock.h
index e9d769c04637a3c0b967c9bfa6def724834796b9..b02645e2dfad722769c1455bcde76e46da9fc5ac 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2433,13 +2433,11 @@ static inline void skb_setup_tx_timestamp(struct sk_buff *skb, __u16 tsflags)
  * This routine must be called with interrupts disabled or with the socket
  * locked so that the sk_buff queue operation is ok.
 */
+DECLARE_STATIC_KEY_FALSE(tcp_rx_skb_cache_key);
 static inline void sk_eat_skb(struct sock *sk, struct sk_buff *skb)
 {
 	__skb_unlink(skb, &sk->sk_receive_queue);
-	if (
-#ifdef CONFIG_RPS
-	    !static_branch_unlikely(&rps_needed) &&
-#endif
+	if (static_branch_unlikely(&tcp_rx_skb_cache_key) &&
 	    !sk->sk_rx_skb_cache) {
 		sk->sk_rx_skb_cache = skb;
 		skb_orphan(skb);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 875867b64d6a6597bf4fcd3498ed55741cbe33f7..886b58d31351df44725bdc34081e798bcb89ecf0 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -51,6 +51,9 @@ static int comp_sack_nr_max = 255;
 static u32 u32_max_div_HZ = UINT_MAX / HZ;
 static int one_day_secs = 24 * 3600;
 
+DEFINE_STATIC_KEY_FALSE(tcp_rx_skb_cache_key);
+EXPORT_SYMBOL(tcp_rx_skb_cache_key);
+
 /* obsolete */
 static int sysctl_tcp_low_latency __read_mostly;
 
@@ -559,6 +562,12 @@ static struct ctl_table ipv4_table[] = {
 		.extra1		= &sysctl_fib_sync_mem_min,
 		.extra2		= &sysctl_fib_sync_mem_max,
 	},
+	{
+		.procname	= "tcp_rx_skb_cache",
+		.data		= &tcp_rx_skb_cache_key.key,
+		.mode		= 0644,
+		.proc_handler	= proc_do_static_key,
+	},
 	{ }
 };
 
-- 
2.22.0.410.gd8fdbe21b5-goog

