Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CE341D0CD
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 03:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347560AbhI3BFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 21:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346422AbhI3BFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 21:05:21 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C80EC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 18:03:39 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id r7so2969180pjo.3
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 18:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=agm9urRkkd7RnPZ1IYFk64CAVDW3XAeYjrfZvS7GRT4=;
        b=aGEfkAYBo78UQCT4EcUlV2HZN2dgoLRDuTmv3sxShjYw9DbLYeltN+JAJ9NB+m9YFP
         a+FL2vaQgjNhSV3fixAaxeEjKG2wzjmONpDt70LvYJ6bbZEsYmK2r48oOe8GycbvczYl
         mU832IF6DGu2UoqJgtQZj/JYnEX5Z65Lsx+r1lZzfen1tktV+9Q6QI7jOvarpMY8adXZ
         BCuPFvroR6YC1MmPuDf0c+s/q9hJMQ/R20z9CaReI7kDwdPkf6ewFgZpY14JzgofSfId
         Zb/aRB1qwHyjClOyJB5P44gRHp62PFWSZLK1rcv6CyV/JAKaykkPVUH1v6HBlWtS16wX
         IjTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=agm9urRkkd7RnPZ1IYFk64CAVDW3XAeYjrfZvS7GRT4=;
        b=W4xYOty7fUCoGV49pZr5vOS7rZEYVdr7wKzTbJYUI7M3Lp56CLKyTgkEhnb8gef6vc
         5sUSt6CJTZFCcHa/5TTwxwY6GiJQFtvCsOdJRwbVrbUqzkf53Q5dMN64paPBowKmImho
         HOhNkJN/bF2pee4pxlkBWyaB51Kz29oM4Td5OwEkWApLAqp8yq8W6YT1Ska+eRpppHIc
         Wx3m+8Tv/w/rBAbiFeHAhP4VWWzcTUMD1xkpVLHzgk3lHIxCrTk020LYeV/ibnHvydd7
         7btG90NXf/uYN4OwmsnKT+2oXXExHf7RYJbe5GaSEookQAdHQTCeraNX9LlqystGAeTm
         tfAg==
X-Gm-Message-State: AOAM5305hLiwTIEzFQn4aNphjn81Q75P2l0TSHB3MosMTjYPNnivN1+L
        mNtBx60NEAHv3j/Vb+rltrk=
X-Google-Smtp-Source: ABdhPJwL1o41O+6nWd34IeRzwVc+pwDRq9FyBoVNdJYGq+7noNQN7hZfFUgMpr3qwjp6GzukgL6vxw==
X-Received: by 2002:a17:90b:1105:: with SMTP id gi5mr9855986pjb.100.1632963818998;
        Wed, 29 Sep 2021 18:03:38 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8858:a0b7:dcc9:9a3b])
        by smtp.gmail.com with ESMTPSA id p17sm711695pju.34.2021.09.29.18.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 18:03:38 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next 1/2] net: snmp: inline snmp_get_cpu_field()
Date:   Wed, 29 Sep 2021 18:03:32 -0700
Message-Id: <20210930010333.2625706-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
In-Reply-To: <20210930010333.2625706-1-eric.dumazet@gmail.com>
References: <20210930010333.2625706-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This trivial function is called ~90,000 times on 256 cpus hosts,
when reading /proc/net/netstat. And this number keeps inflating.

Inlining it saves many cycles.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ip.h   | 6 +++++-
 net/ipv4/af_inet.c | 6 ------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 9192444f2964ebb59454a7dfa5ddf3b19dea04c9..cf229a53119428307da898af4b0dc23e1cecc053 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -291,7 +291,11 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 #define NET_ADD_STATS(net, field, adnd)	SNMP_ADD_STATS((net)->mib.net_statistics, field, adnd)
 #define __NET_ADD_STATS(net, field, adnd) __SNMP_ADD_STATS((net)->mib.net_statistics, field, adnd)
 
-u64 snmp_get_cpu_field(void __percpu *mib, int cpu, int offct);
+static inline u64 snmp_get_cpu_field(void __percpu *mib, int cpu, int offt)
+{
+	return  *(((unsigned long *)per_cpu_ptr(mib, cpu)) + offt);
+}
+
 unsigned long snmp_fold_field(void __percpu *mib, int offt);
 #if BITS_PER_LONG==32
 u64 snmp_get_cpu_field64(void __percpu *mib, int cpu, int offct,
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 40558033f857c0ca7d98b778f70487e194f3d066..967926c1bf56cfc915258b0969914b11f24c1e16 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1662,12 +1662,6 @@ int inet_ctl_sock_create(struct sock **sk, unsigned short family,
 }
 EXPORT_SYMBOL_GPL(inet_ctl_sock_create);
 
-u64 snmp_get_cpu_field(void __percpu *mib, int cpu, int offt)
-{
-	return  *(((unsigned long *)per_cpu_ptr(mib, cpu)) + offt);
-}
-EXPORT_SYMBOL_GPL(snmp_get_cpu_field);
-
 unsigned long snmp_fold_field(void __percpu *mib, int offt)
 {
 	unsigned long res = 0;
-- 
2.33.0.800.g4c38ced690-goog

