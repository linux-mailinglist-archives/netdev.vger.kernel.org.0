Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7CB54A886
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 07:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbiFNFCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 01:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbiFNFCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 01:02:43 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF165193C7
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 22:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1655182962; x=1686718962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Vokrsk0aYjfy16R7vHXnT639HL9n+gLL0qQwwHQEexE=;
  b=cbmjHhDbNFR16ZNYZtkJOVpazZAkT3QsZeoBpjL8ROLsTd6crqIRq3Ek
   XTQ5ehvA4nGxFbLHLeanK738Ruig+DlTjumZA/gyTiYCf06M4tP+7ew7k
   JWXZK3S12D50iRn8toNqXLUsoas3qld3M1LHPcQm6wqExWGFJwTPpB6cb
   w=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 13 Jun 2022 22:02:41 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 22:02:41 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 13 Jun 2022 22:02:40 -0700
Received: from subashab-lnx.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 13 Jun 2022 22:02:39 -0700
From:   Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
To:     <davem@davemloft.net>, <dsahern@kernel.org>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <sbrivio@redhat.com>
CC:     Kaustubh Pandey <quic_kapandey@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Subject: [PATCH net v2 1/2] ipv6: Honor route mtu if it is within limit of dev mtu
Date:   Mon, 13 Jun 2022 23:01:54 -0600
Message-ID: <1655182915-12897-2-git-send-email-quic_subashab@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
References: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaustubh Pandey <quic_kapandey@quicinc.com>

When netdevice MTU is increased via sysfs, NETDEV_CHANGEMTU is raised.

addrconf_notify -> rt6_mtu_change -> rt6_mtu_change_route ->
fib6_nh_mtu_change

As part of handling NETDEV_CHANGEMTU notification we land up on a
condition where if route mtu is less than dev mtu and route mtu equals
ipv6_devconf mtu, route mtu gets updated.

Due to this v6 traffic end up using wrong MTU then configured earlier.
This commit fixes this by removing comparison with ipv6_devconf
and updating route mtu only when it is greater than incoming dev mtu.

This can be easily reproduced with below script:
pre-condition:
device up(mtu = 1500) and route mtu for both v4 and v6 is 1500

test-script:
ip route change 192.168.0.0/24 dev eth0 src 192.168.0.1 mtu 1400
ip -6 route change 2001::/64 dev eth0 metric 256 mtu 1400
echo 1400 > /sys/class/net/eth0/mtu
ip route change 192.168.0.0/24 dev eth0 src 192.168.0.1 mtu 1500
echo 1500 > /sys/class/net/eth0/mtu

Fixes: e9fa1495d738 ("ipv6: Reflect MTU changes on PMTU of exceptions for MTU-less routes")
Signed-off-by: Kaustubh Pandey <quic_kapandey@quicinc.com>
Signed-off-by: Sean Tranchetti <quic_stranche@quicinc.com>
Signed-off-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
---
v1 -> v2: Update the exception route logic as mentioned by David Ahern.
Also add fixes tag.

 net/ipv6/route.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index d25dc83..6f7e8c5 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1991,19 +1991,11 @@ static bool rt6_mtu_change_route_allowed(struct inet6_dev *idev,
 	/* If the new MTU is lower than the route PMTU, this new MTU will be the
 	 * lowest MTU in the path: always allow updating the route PMTU to
 	 * reflect PMTU decreases.
-	 *
-	 * If the new MTU is higher, and the route PMTU is equal to the local
-	 * MTU, this means the old MTU is the lowest in the path, so allow
-	 * updating it: if other nodes now have lower MTUs, PMTU discovery will
-	 * handle this.
 	 */
 
 	if (dst_mtu(&rt->dst) >= mtu)
 		return true;
 
-	if (dst_mtu(&rt->dst) == idev->cnf.mtu6)
-		return true;
-
 	return false;
 }
 
@@ -4914,8 +4906,7 @@ static int fib6_nh_mtu_change(struct fib6_nh *nh, void *_arg)
 		struct inet6_dev *idev = __in6_dev_get(arg->dev);
 		u32 mtu = f6i->fib6_pmtu;
 
-		if (mtu >= arg->mtu ||
-		    (mtu < arg->mtu && mtu == idev->cnf.mtu6))
+		if (mtu >= arg->mtu)
 			fib6_metric_set(f6i, RTAX_MTU, arg->mtu);
 
 		spin_lock_bh(&rt6_exception_lock);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

