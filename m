Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33FA52EA2D
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 12:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbiETKtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 06:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiETKtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 06:49:05 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0355BE53;
        Fri, 20 May 2022 03:49:04 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j24so10986890wrb.1;
        Fri, 20 May 2022 03:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vm+iy+NOIbMMRLLjKp5SRZvj7j/0bEsMLbF9xbtKOuU=;
        b=DJVpep95PDnmwOH6ep0mHZrxyIWYwVpeMszZ2/zMg2+bddK1SBiUg9+i5K7Euk9Bgw
         jSbNbNakj9Zy+VGnVBYJqnrr9GAsfPFHRlKCg54VxWkVqogrGaToQQafHFfuFUvbMhcP
         BFBwclCJq6DHLCCbkTaYId/a3uDEMDA/w0yfd2JIQwiJViY8XcDrjEEHF1o6HEZJADiB
         gmUigmnOp/qEV6GH9GRktysKVr1F/+9C/Ef039g6/kQKquiG19bhBRFMAStwtm6bpnoH
         8uHh7HDOuYav6B4KixLBV/RUQ+rSK6JU55jJbZeoLW01t3Uy8uoMTrV922PXH8mr99Az
         nq8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vm+iy+NOIbMMRLLjKp5SRZvj7j/0bEsMLbF9xbtKOuU=;
        b=Bu7mvjtBWmoivFRxgb5XFemmWC1fNsEz0cRMQBOjzBIvUvzEEyWzYiW5jAPtcyW5r2
         Zg0+7hyBG/UTu8/fQYhy3MLq/Dslj3mtmOERcTH+hGLrjd4yDbGzPSQYxTms49t1sgm+
         mony2YxBV4kV/Tyy6n84SsT14hvdKbRB0CLuxluWEqzKQU1+dLi2tgyyGGwhk1yDdfWT
         RjtuEOxOtOtt4fzCdN81z9Kuzf6mFi0nVXn0CgpwFrXE3aGEpvUIILDRo3lvpfHPaifN
         GU38Amfq3vimMicIQJHwCy4sTXaB5iZACOIupNSbmPjY03s+0ILq+FtwVEauaH27E2D+
         ZIlg==
X-Gm-Message-State: AOAM531QkS8pN+ymKKI3f+wPwPjWpcJRsrPHGuV/d/+utBqU5KpHRAch
        e7cHK62RpvkGvRw4Ths0kao=
X-Google-Smtp-Source: ABdhPJyHmue/Yr+HDWQsvVNgg5uXHKbkPU52Tv24WpBAePe1Wi+tBvhX+uPOw7Gxhf8ZO2VfwkX0mQ==
X-Received: by 2002:adf:dccc:0:b0:20e:5930:9e85 with SMTP id x12-20020adfdccc000000b0020e59309e85mr7787867wrm.20.1653043742564;
        Fri, 20 May 2022 03:49:02 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id o9-20020adf8b89000000b0020d0351dbb6sm2166876wra.80.2022.05.20.03.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 03:49:02 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     dsahern@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        steffen.klassert@secunet.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nicolas.dichtel@6wind.com, shmulik.ladkani@gmail.com,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next] xfrm: no need to set DST_NOPOLICY in IPv4
Date:   Fri, 20 May 2022 13:48:45 +0300
Message-Id: <20220520104845.2644470-1-eyal.birger@gmail.com>
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

This is a cleanup patch following commit e6175a2ed1f1
("xfrm: fix "disable_policy" flag use when arriving from different devices")
which made DST_NOPOLICY no longer be used for inbound policy checks.

On outbound the flag was set, but never used.

As such, avoid setting it altogether and remove the nopolicy argument
from rt_dst_alloc().

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

---

This patch assumes ipsec-next is aligned with net-next and commit
e6175a2ed1f1 is already merged.
---
 drivers/net/vrf.c   |  2 +-
 include/net/route.h |  3 +--
 net/ipv4/route.c    | 24 ++++++++----------------
 3 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index cfc30ce4c6e1..3c99de582c09 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1077,7 +1077,7 @@ static int vrf_rtable_create(struct net_device *dev)
 		return -ENOMEM;
 
 	/* create a dst for routing packets out through a VRF device */
-	rth = rt_dst_alloc(dev, 0, RTN_UNICAST, 1, 1);
+	rth = rt_dst_alloc(dev, 0, RTN_UNICAST, 1);
 	if (!rth)
 		return -ENOMEM;
 
diff --git a/include/net/route.h b/include/net/route.h
index 991a3985712d..b6743ff88e30 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -244,8 +244,7 @@ void ip_rt_multicast_event(struct in_device *);
 int ip_rt_ioctl(struct net *, unsigned int cmd, struct rtentry *rt);
 void ip_rt_get_source(u8 *src, struct sk_buff *skb, struct rtable *rt);
 struct rtable *rt_dst_alloc(struct net_device *dev,
-			     unsigned int flags, u16 type,
-			     bool nopolicy, bool noxfrm);
+			    unsigned int flags, u16 type, bool noxfrm);
 struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt);
 
 struct in_ifaddr;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 356f535f3443..d990bb3b1587 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1627,12 +1627,11 @@ static void rt_set_nexthop(struct rtable *rt, __be32 daddr,
 
 struct rtable *rt_dst_alloc(struct net_device *dev,
 			    unsigned int flags, u16 type,
-			    bool nopolicy, bool noxfrm)
+			    bool noxfrm)
 {
 	struct rtable *rt;
 
 	rt = dst_alloc(&ipv4_dst_ops, dev, 1, DST_OBSOLETE_FORCE_CHK,
-		       (nopolicy ? DST_NOPOLICY : 0) |
 		       (noxfrm ? DST_NOXFRM : 0));
 
 	if (rt) {
@@ -1727,7 +1726,6 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
 	unsigned int flags = RTCF_MULTICAST;
 	struct rtable *rth;
-	bool no_policy;
 	u32 itag = 0;
 	int err;
 
@@ -1738,12 +1736,11 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (our)
 		flags |= RTCF_LOCAL;
 
-	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
-	if (no_policy)
+	if (IN_DEV_ORCONF(in_dev, NOPOLICY))
 		IPCB(skb)->flags |= IPSKB_NOPOLICY;
 
 	rth = rt_dst_alloc(dev_net(dev)->loopback_dev, flags, RTN_MULTICAST,
-			   no_policy, false);
+			   false);
 	if (!rth)
 		return -ENOBUFS;
 
@@ -1802,7 +1799,7 @@ static int __mkroute_input(struct sk_buff *skb,
 	struct rtable *rth;
 	int err;
 	struct in_device *out_dev;
-	bool do_cache, no_policy;
+	bool do_cache;
 	u32 itag = 0;
 
 	/* get a working reference to the output device */
@@ -1847,8 +1844,7 @@ static int __mkroute_input(struct sk_buff *skb,
 		}
 	}
 
-	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
-	if (no_policy)
+	if (IN_DEV_ORCONF(in_dev, NOPOLICY))
 		IPCB(skb)->flags |= IPSKB_NOPOLICY;
 
 	fnhe = find_exception(nhc, daddr);
@@ -1863,7 +1859,7 @@ static int __mkroute_input(struct sk_buff *skb,
 		}
 	}
 
-	rth = rt_dst_alloc(out_dev->dev, 0, res->type, no_policy,
+	rth = rt_dst_alloc(out_dev->dev, 0, res->type,
 			   IN_DEV_ORCONF(out_dev, NOXFRM));
 	if (!rth) {
 		err = -ENOBUFS;
@@ -2238,7 +2234,6 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	struct rtable	*rth;
 	struct flowi4	fl4;
 	bool do_cache = true;
-	bool no_policy;
 
 	/* IP on this device is disabled. */
 
@@ -2357,8 +2352,7 @@ out:	return err;
 	RT_CACHE_STAT_INC(in_brd);
 
 local_input:
-	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
-	if (no_policy)
+	if (IN_DEV_ORCONF(in_dev, NOPOLICY))
 		IPCB(skb)->flags |= IPSKB_NOPOLICY;
 
 	do_cache &= res->fi && !itag;
@@ -2374,8 +2368,7 @@ out:	return err;
 	}
 
 	rth = rt_dst_alloc(ip_rt_get_dev(net, res),
-			   flags | RTCF_LOCAL, res->type,
-			   no_policy, false);
+			   flags | RTCF_LOCAL, res->type, false);
 	if (!rth)
 		goto e_nobufs;
 
@@ -2598,7 +2591,6 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 
 add:
 	rth = rt_dst_alloc(dev_out, flags, type,
-			   IN_DEV_ORCONF(in_dev, NOPOLICY),
 			   IN_DEV_ORCONF(in_dev, NOXFRM));
 	if (!rth)
 		return ERR_PTR(-ENOBUFS);
-- 
2.34.1

