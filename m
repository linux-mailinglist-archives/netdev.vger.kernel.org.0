Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7B1321D14
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhBVQeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:34:22 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:58607 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231442AbhBVQdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 11:33:50 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614011609; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=BqRijYipU9wMMRj5psKXr7YKhuIcT/6FhmGW7Z+ymvI=; b=LGHAXnmC1S6+aKY/e/vO73+Idm5xnDfqOsdQLR/MMSuP37Hi4Bn2SrlILPEgveULbEWEJAPA
 NwAcdM4AzKw0b66CKnmtrcRj9vfrGxGKaLM4H3qtmpklKVsc6v7welrs39j1CSaL8/JIv8Fc
 F+ZUBM5FxCixM7pQpS1/DIz2xOo=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6033dcbcba08663830ecd647 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 22 Feb 2021 16:32:59
 GMT
Sender: kapandey=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E3CCBC43461; Mon, 22 Feb 2021 16:32:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from kapandey-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kapandey)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A575BC433CA;
        Mon, 22 Feb 2021 16:32:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A575BC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kapandey@codeaurora.org
From:   Kaustubh Pandey <kapandey@codeaurora.org>
Cc:     Kaustubh Pandey <kapandey@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sharathv@codeaurora.org,
        chinagar@codeaurora.org
Subject: [PATCH] ipv6: Honor route mtu if it is within limit of dev mtu
Date:   Mon, 22 Feb 2021 22:02:35 +0530
Message-Id: <1614011555-21951-1-git-send-email-kapandey@codeaurora.org>
X-Mailer: git-send-email 2.7.4
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Signed-off-by: Kaustubh Pandey <kapandey@codeaurora.org>
---
 net/ipv6/route.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1536f49..653b6c7 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4813,8 +4813,7 @@ static int fib6_nh_mtu_change(struct fib6_nh *nh, void *_arg)
 		struct inet6_dev *idev = __in6_dev_get(arg->dev);
 		u32 mtu = f6i->fib6_pmtu;
 
-		if (mtu >= arg->mtu ||
-		    (mtu < arg->mtu && mtu == idev->cnf.mtu6))
+		if (mtu >= arg->mtu)
 			fib6_metric_set(f6i, RTAX_MTU, arg->mtu);
 
 		spin_lock_bh(&rt6_exception_lock);
-- 
2.7.4

