Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78F81A6068
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 07:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfICFGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 01:06:09 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45215 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfICFGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 01:06:09 -0400
Received: by mail-pf1-f195.google.com with SMTP id y72so2429769pfb.12
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 22:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=xiUxgq5MPOTWy5NZ0GLvJuHf8hJ7dXKo+PtcEnhJeQQ=;
        b=QljRJyi1IARYAXJCfhvIe/1gwQFzsA7chwZXqPZb4/IIuMpi0/qlT1KzKJqd7bLJ8n
         mSwe9aZNiIWpFpQCOk38etlqEV8fZAYCqx5+Yd0W7KjhTwIsRi/auBW+AisQhlzpQ1d8
         3WWhqPmeJ+RoWkhW3tNn1wxa4SnJJpitT2NdfizlVethyQSJNta5/my5nluYkolg1P3V
         9haaIczM4e8ybXxoxaNgYDjQkmhBXuURkzmQo5rhwvWDOAbcbBZbtweI6Hxnf/jeUMPt
         TJtjX4oU79UeT8hueJ6k0hpSE/jjEL0uiWxo+sQB03IG+xO6gMYYZFG62wAytR0PlPJf
         55LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=xiUxgq5MPOTWy5NZ0GLvJuHf8hJ7dXKo+PtcEnhJeQQ=;
        b=TvUn3x8nQtJws+1aQrFu1177cHm0TeeihGoprGwEVHRZtUsejASugntDHCan/E6sO/
         k0KlUDAtNVFGVQpVkSfVlSiFIkFzT19PBrIR4nu9HfLUEVLkRjjqFQidB3Ul96sNApk1
         vi5tNRUYizoP99TAGa824FYSN78uHUX1tB0BBKBOcpT+qZ3d1AO02/DWIeRBxQtJulxa
         sKGgsvN/JPPbIG8GODmm9AcVw7fJs32hbiw7gOXdQ1wfyou8u1ZMKNlP+NjhKBV/VGIS
         HSPAhmOAOGQXBGNK4TH9cTF8NwemQu7oBrb7DV5ufmumCCfbC8GaJSCQswS6NR2s2Mos
         y+Pw==
X-Gm-Message-State: APjAAAW7KztfgqGpB5dHAMWqCO78qf6aXorSCK9zqi7QgyRGe6WS1afG
        8aHOyJBOoRTo8YRMvJ3+QuZqVeakya8=
X-Google-Smtp-Source: APXvYqyF61dmjIOqVrIp8wTAQjkYtXN9dd+EVXgWBIXliTiJChu56Of/I58JT7lB5Fx5brRJk7i/SQ==
X-Received: by 2002:a62:cec4:: with SMTP id y187mr5466982pfg.84.1567487168116;
        Mon, 02 Sep 2019 22:06:08 -0700 (PDT)
Received: from [192.168.1.2] (155-97-234-108.usahousing.utah.edu. [155.97.234.108])
        by smtp.gmail.com with ESMTPSA id a5sm13261735pjs.31.2019.09.02.22.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Sep 2019 22:06:07 -0700 (PDT)
To:     davem@davemloft.net
Cc:     shiraz.saleem@intel.com, jgg@ziepe.ca, arnd@arndb.de,
        arnd@arndb.de, netdev@vger.kernel.org, sirus@cs.utah.edu
From:   Cyrus Sh <sirus.shahini@gmail.com>
Subject: [PATCH] Clock-independent TCP ISN generation
Message-ID: <70c41960-6d14-3943-31ca-75598ad3d2d7@gmail.com>
Date:   Mon, 2 Sep 2019 23:06:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses the privacy issue of TCP ISN generation in Linux
kernel. Currently an adversary can deanonymize a user behind an anonymity
network by inducing a load pattern on the target machine and correlating
its clock skew with the pattern. Since the kernel adds a clock-based
counter to generated ISNs, the adversary can observe SYN packets with
similar IP and port numbers to find out the clock skew of the target
machine and this can help them identify the user.  To resolve this problem
I have changed the related function to generate the initial sequence
numbers randomly and independent from the cpu clock. This feature is
controlled by a new sysctl option called "tcp_random_isn" which I've added
to the kernel. Once enabled the initial sequence numbers are guaranteed to
be generated independently from each other and from the hardware clock of
the machine. If the option is off, ISNs are generated as before.  To get
more information about this patch and its effectiveness you can refer to my
post here:
https://bitguard.wordpress.com/?p=982
and to see a discussion about the issue you can read this:
https://trac.torproject.org/projects/tor/ticket/16659

Signed-off-by: Sirus Shahini <sirus.shahini@gmail.com>
---
 include/net/tcp.h           |  1 +
 include/uapi/linux/sysctl.h |  1 +
 kernel/sysctl_binary.c      |  1 +
 net/core/secure_seq.c       | 24 +++++++++++++++++++++++-
 net/ipv4/sysctl_net_ipv4.c  |  7 +++++++
 net/ipv4/tcp_input.c        |  1 +
 6 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 81e8ade..4ad1bbf 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -241,6 +241,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 
 /* sysctl variables for tcp */
 extern int sysctl_tcp_max_orphans;
+extern int sysctl_tcp_random_isn;
 extern long sysctl_tcp_mem[3];
 
 #define TCP_RACK_LOSS_DETECTION  0x1 /* Use RACK to detect losses */
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 87aa2a6..ba8927e 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -426,6 +426,7 @@ enum
 	NET_TCP_ALLOWED_CONG_CONTROL=123,
 	NET_TCP_MAX_SSTHRESH=124,
 	NET_TCP_FRTO_RESPONSE=125,
+	NET_IPV4_TCP_RANDOM_ISN=126,
 };
 
 enum {
diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 73c1320..0faf7d4 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -332,6 +332,7 @@ static const struct bin_table bin_net_ipv4_netfilter_table[] = {
 };
 
 static const struct bin_table bin_net_ipv4_table[] = {
+	{CTL_INT,   NET_IPV4_TCP_RANDOM_ISN     "tcp_random_isn"}
 	{CTL_INT,	NET_IPV4_FORWARD,			"ip_forward" },
 
 	{ CTL_DIR,	NET_IPV4_CONF,		"conf",		bin_net_ipv4_conf_table },
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 7b6b1d2..b644bbe 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -22,6 +22,7 @@
 
 static siphash_key_t net_secret __read_mostly;
 static siphash_key_t ts_secret __read_mostly;
+static siphash_key_t last_secret = {{0,0}} ;
 
 static __always_inline void net_secret_init(void)
 {
@@ -134,8 +135,29 @@ u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 		   __be16 sport, __be16 dport)
 {
 	u32 hash;
-
+	u32 temp;
+	
 	net_secret_init();
+	
+	if (sysctl_tcp_random_isn){
+		if (!last_secret.key[0] && !last_secret.key[1]){
+			memcpy(&last_secret,&net_secret,sizeof(last_secret));	
+					
+		}else{
+			temp = *((u32*)&(net_secret.key[0]));
+			temp >>= 8;
+			last_secret.key[0]+=temp;
+			temp = *((u32*)&(net_secret.key[1]));
+			temp >>= 8;
+			last_secret.key[1]+=temp;
+		}
+		hash = siphash_3u32((__force u32)saddr, (__force u32)daddr,
+			        (__force u32)sport << 16 | (__force u32)dport,
+			        &last_secret);
+		return hash;
+	}
+	
+	
 	hash = siphash_3u32((__force u32)saddr, (__force u32)daddr,
 			    (__force u32)sport << 16 | (__force u32)dport,
 			    &net_secret);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 0b980e8..74b2b6a 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -479,6 +479,13 @@ static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 
 static struct ctl_table ipv4_table[] = {
 	{
+    	.procname	= "tcp_random_isn",
+		.data		= &sysctl_tcp_random_isn,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec  
+	},
+	{
 		.procname	= "tcp_max_orphans",
 		.data		= &sysctl_tcp_max_orphans,
 		.maxlen		= sizeof(int),
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c21e8a2..c6b4ebf 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -80,6 +80,7 @@
 #include <linux/jump_label_ratelimit.h>
 #include <net/busy_poll.h>
 
+int sysctl_tcp_random_isn __read_mostly = 0;
 int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
 
 #define FLAG_DATA		0x01 /* Incoming frame contained data.		*/
-- 
2.7.4
