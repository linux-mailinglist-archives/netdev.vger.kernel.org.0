Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7AC524AC7
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 12:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352824AbiELKt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 06:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352820AbiELKtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 06:49:19 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E025922A8AF
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 03:49:16 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id t6so6692145wra.4
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 03:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0HzdyfQNWW1X5XUsM4czbpgQTMCq9lkSY4z5qYOvIIU=;
        b=q6yKR70RC8SGImxhGxiCRWeJwFCdlusYXO8ez4aporOW00K0mpI+OjmPWZLv3NjpWU
         Isqgkt9zaOa8BYTrQVnrgiSJg5Sc8MCV/JR1QQisw21SDSyP2DO/34RLb0SLxUcvRmP8
         bhGBbaaOTwYg8iMu/mV3dslq1pQCdFm8elBD7z9fCpfs+3ZLKoRnjqKTxEcjac9VY4gk
         wqlWB6lGvWx4VgzbEtKD3WN0Wx+PIZo5zNISQkZm4RBLgjvyvUbmIeM73UYTku99d72N
         /QhsJ6gd1B5kIDmmCWhdW8mq5puWIAEJ8DhiTErGTX4GoJlmBh3BJtaZrkQIAdUyu5bA
         syTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0HzdyfQNWW1X5XUsM4czbpgQTMCq9lkSY4z5qYOvIIU=;
        b=ikkXkka8i9kgY0VJNwf4SJJjeadn6zTk8SHXSJVrV6YcwgNUIul1c5PnOpmCKcU2pB
         jSdAU9MwRORiXa+XAkjKLwd9ATFp4aPjz1Uxsm5nmCTF8ZVwCBMxEoJtu0UJEHothKcc
         Z9qpzt1Oxl1c0cNbHirSev6Rlds76/aNmTC6jEnbBsHDsH4/mEIpX+KwLo82NKjWXgbU
         26AjY1HK7BxVSb7D8rGff9bpSSv8GLh8BKDvd6S0B4fVyPbgx7+abiIZeN3cW64hqa3z
         cHzwIlgLsWffDAr6ayluRId6DS1vtacugzj5FOzgIInMFDYZeWrHaYeZ3CZB566AFBnz
         pJzg==
X-Gm-Message-State: AOAM530bi5Nki0CGka91Nke54MwgV5HcmHsod0syafB2lWm2PLdksc/Q
        RLSjCcWtpRRXX++bXp3oZ00=
X-Google-Smtp-Source: ABdhPJxz9H50J9mNpu8vgH2+ee2nHyTH0r4N3e9g5ZjN7qgNA4PiblkdNK+oLmK/svHn4+MYmBO6Rw==
X-Received: by 2002:adf:f3cb:0:b0:20a:e4e6:6633 with SMTP id g11-20020adff3cb000000b0020ae4e66633mr27118494wrp.512.1652352555183;
        Thu, 12 May 2022 03:49:15 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id z22-20020a7bc156000000b003942a244f30sm2757409wmi.9.2022.05.12.03.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 03:49:14 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: [PATCH ipsec] xfrm: fix "disable_policy" flag use when arriving from different devices
Date:   Thu, 12 May 2022 13:48:31 +0300
Message-Id: <20220512104831.976553-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In IPv4 setting the "disable_policy" flag on a device means no policy
should be enforced for traffic originating from the device. This was
implemented by seting the DST_NOPOLICY flag in the dst based on the
originating device.

However, dsts are cached in nexthops regardless of the originating
devices, in which case, the DST_NOPOLICY flag value may be incorrect.

Consider the following setup:

                     +------------------------------+
                     | ROUTER                       |
  +-------------+    | +-----------------+          |
  | ipsec src   |----|-|ipsec0           |          |
  +-------------+    | |disable_policy=0 |   +----+ |
                     | +-----------------+   |eth1|-|-----
  +-------------+    | +-----------------+   +----+ |
  | noipsec src |----|-|eth0             |          |
  +-------------+    | |disable_policy=1 |          |
                     | +-----------------+          |
                     +------------------------------+

Where ROUTER has a default route towards eth1.

dst entries for traffic arriving from eth0 would have DST_NOPOLICY
and would be cached and therefore can be reused by traffic originating
from ipsec0, skipping policy check.

Fix by setting a IPSKB_NOPOLICY flag in IPCB and observing it instead
of the DST in IN/FWD IPv4 policy checks.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 include/net/ip.h   |  1 +
 include/net/xfrm.h | 14 +++++++++++++-
 net/ipv4/route.c   | 16 ++++++++++++----
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 3984f2c39c4b..0161137914cf 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -56,6 +56,7 @@ struct inet_skb_parm {
 #define IPSKB_DOREDIRECT	BIT(5)
 #define IPSKB_FRAG_PMTU		BIT(6)
 #define IPSKB_L3SLAVE		BIT(7)
+#define IPSKB_NOPOLICY		BIT(8)
 
 	u16			frag_max_size;
 };
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 6fb899ff5afc..d2efddce65d4 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1093,6 +1093,18 @@ static inline bool __xfrm_check_nopolicy(struct net *net, struct sk_buff *skb,
 	return false;
 }
 
+static inline bool __xfrm_check_dev_nopolicy(struct sk_buff *skb,
+					     int dir, unsigned short family)
+{
+	if (dir != XFRM_POLICY_OUT && family == AF_INET) {
+		/* same dst may be used for traffic originating from
+		 * devices with different policy settings.
+		 */
+		return IPCB(skb)->flags & IPSKB_NOPOLICY;
+	}
+	return skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY);
+}
+
 static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 				       struct sk_buff *skb,
 				       unsigned int family, int reverse)
@@ -1104,7 +1116,7 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 		return __xfrm_policy_check(sk, ndir, skb, family);
 
 	return __xfrm_check_nopolicy(net, skb, dir) ||
-	       (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
+	       __xfrm_check_dev_nopolicy(skb, dir, family) ||
 	       __xfrm_policy_check(sk, ndir, skb, family);
 }
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 98c6f3429593..ea81e93c8c20 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1795,7 +1795,7 @@ static int __mkroute_input(struct sk_buff *skb,
 	struct rtable *rth;
 	int err;
 	struct in_device *out_dev;
-	bool do_cache;
+	bool do_cache, no_policy;
 	u32 itag = 0;
 
 	/* get a working reference to the output device */
@@ -1840,6 +1840,10 @@ static int __mkroute_input(struct sk_buff *skb,
 		}
 	}
 
+	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
+	if (no_policy)
+		IPCB(skb)->flags |= IPSKB_NOPOLICY;
+
 	fnhe = find_exception(nhc, daddr);
 	if (do_cache) {
 		if (fnhe)
@@ -1852,8 +1856,7 @@ static int __mkroute_input(struct sk_buff *skb,
 		}
 	}
 
-	rth = rt_dst_alloc(out_dev->dev, 0, res->type,
-			   IN_DEV_ORCONF(in_dev, NOPOLICY),
+	rth = rt_dst_alloc(out_dev->dev, 0, res->type, no_policy,
 			   IN_DEV_ORCONF(out_dev, NOXFRM));
 	if (!rth) {
 		err = -ENOBUFS;
@@ -2228,6 +2231,7 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	struct rtable	*rth;
 	struct flowi4	fl4;
 	bool do_cache = true;
+	bool no_policy;
 
 	/* IP on this device is disabled. */
 
@@ -2346,6 +2350,10 @@ out:	return err;
 	RT_CACHE_STAT_INC(in_brd);
 
 local_input:
+	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
+	if (no_policy)
+		IPCB(skb)->flags |= IPSKB_NOPOLICY;
+
 	do_cache &= res->fi && !itag;
 	if (do_cache) {
 		struct fib_nh_common *nhc = FIB_RES_NHC(*res);
@@ -2360,7 +2368,7 @@ out:	return err;
 
 	rth = rt_dst_alloc(ip_rt_get_dev(net, res),
 			   flags | RTCF_LOCAL, res->type,
-			   IN_DEV_ORCONF(in_dev, NOPOLICY), false);
+			   no_policy, false);
 	if (!rth)
 		goto e_nobufs;
 
-- 
2.34.1

