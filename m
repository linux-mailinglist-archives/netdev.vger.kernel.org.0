Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC003D4D7E
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 14:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhGYMDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 08:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhGYMDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 08:03:21 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE29C061757;
        Sun, 25 Jul 2021 05:43:50 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id k7so6152459qki.11;
        Sun, 25 Jul 2021 05:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NbRAvZ3A0RSyVfZ/ijyRr1Shy3EKdcYLm1nVw9+5hFk=;
        b=P6br9yAQPgsCKHVu1a0G7y+LZkHOj2T3UBieWyW98vHdbW+dTR/gHOlHZpT+my+BmI
         xuJ3yHgHXFBZSHCt4sQPKBbFrfpseO/yUMWNNvPyTfP4QI5aipOAIZcv7bXNM8kyXRmM
         jLaxr+aZBEabAWfRlUe3s+ahUOgX6gWEA8/tYoqMP//kjr1JhuGRxpfvVmNp6nQE8CMd
         GqAnJqTtl/we4ASAgnyvRP5dB4TiAEC8VuYVc61TpLTKJGjIJHeQyrfTZ/CnoHnDToM8
         ULPOQCvnx/4Rz0AZAP4xx206DlevIqHC6MqphzkafTlg+g9ma845x2hQ2d0/0IYe4wX9
         ifFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NbRAvZ3A0RSyVfZ/ijyRr1Shy3EKdcYLm1nVw9+5hFk=;
        b=BUGGcc0Czy2fuP1LNIA5wV3s+R5Jtu3syqbM7qYmOoKc0tE8gbeHQLXaleEGGC26b9
         ENf2AxVDXk3SwGEi/CXV6AyYryHJ+9x/Ru/OKuZbmHfcy6AflMNbR7ivjfZHf3sBw640
         UHvQnZcxspyySrlp7XZq1l6z8Z3XjyDdJdRuyOKzUKxDRT33O9jt08uaL6hw8x9Y3/+m
         e1otovGi9M0wh8tPt5WTTofR3N0eJ85WNYpXk5YmEBFlmBO8qYovd1gwBvUiktwxbvfh
         M9gjoTwB4FF+f7Ii6aBL3s8xjgQrQsuyY5pTDqCmPPLodvK3diU+rTU+ThWy2BbYsbyB
         bnVw==
X-Gm-Message-State: AOAM530+ZhG+AMy/6tkdzYGt+qOtD8CnoiOM0atLxqIMwYjsVejByhF6
        zLxMhTjRgEJ45jfBRs6tKSKUX18BHW+DcWE=
X-Google-Smtp-Source: ABdhPJxVkeN4764L++b6f0dUHoPDObwW5Bm1tt3or4AdqIedVV+76BPa83BIkGz3zG9DAH56z5nnrw==
X-Received: by 2002:a37:ae05:: with SMTP id x5mr13291916qke.321.1627217030048;
        Sun, 25 Jul 2021 05:43:50 -0700 (PDT)
Received: from localhost.localdomain (74.121.150.105.16clouds.com. [74.121.150.105])
        by smtp.gmail.com with ESMTPSA id f13sm3868949qkk.29.2021.07.25.05.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 05:43:49 -0700 (PDT)
From:   Chen Shen <peterchenshen@gmail.com>
To:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chen Shen <peterchenshen@gmail.com>
Subject: [PATCH] sctp: delete addr based on sin6_scope_id
Date:   Sun, 25 Jul 2021 20:43:39 +0800
Message-Id: <20210725124339.72884-1-peterchenshen@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_inet6addr_event deletes 'addr' from 'local_addr_list' when setting
netdev down, but it has possibility to delete the incorroct entry (match
the first one with the same ipaddr, but the different 'ifindex'), if
there are some netdevs with the same 'local-link' ipaddr added already.
It should delete the entry depending on 'sin6_addr' and 'sin6_scope_id'
both, otherwise, the endpoint will call 'sctp_sf_ootb' if it can't find
the accroding association when receives 'heartbeat', and finally will
reply 'abort' which causes the test case for NOKIA SYSCOM GW failed.

For example:
1.when linux startup
the entries in local_addr_list:
ifindex:35 addr:fe80::40:43ff:fe80:0 (eths0.201)
ifindex:36 addr:fe80::40:43ff:fe80:0 (eths0.209)
ifindex:37 addr:fe80::40:43ff:fe80:0 (eths0.210)

the route table:
local fe80::40:43ff:fe80:0 dev eths0.201
local fe80::40:43ff:fe80:0 dev eths0.209
local fe80::40:43ff:fe80:0 dev eths0.210

2.after 'ifconfig eths0.209 down'
the entries in local_addr_list:
ifindex:36 addr:fe80::40:43ff:fe80:0 (eths0.209)
ifindex:37 addr:fe80::40:43ff:fe80:0 (eths0.210)

the route table:
local fe80::40:43ff:fe80:0 dev eths0.201
local fe80::40:43ff:fe80:0 dev eths0.210

3.asoc not found for src:[fe80::40:43ff:fe80:0]:37381 dst:[:1]:53335
::1->fe80::40:43ff:fe80:0 HEARTBEAT
fe80::40:43ff:fe80:0->::1 ABORT

Change-Id: I9fd4745a9a95489c62571c2764d37259c0209eff
Signed-off-by: Chen Shen <peterchenshen@gmail.com>
---
 net/sctp/ipv6.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 52c92b8d827f..66ebf1e3383d 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -100,7 +100,9 @@ static int sctp_inet6addr_event(struct notifier_block *this, unsigned long ev,
 					&net->sctp.local_addr_list, list) {
 			if (addr->a.sa.sa_family == AF_INET6 &&
 					ipv6_addr_equal(&addr->a.v6.sin6_addr,
-						&ifa->addr)) {
+						&ifa->addr) &&
+					addr->a.v6.sin6_scope_id ==
+						ifa->idev->dev->ifindex) {
 				sctp_addr_wq_mgmt(net, addr, SCTP_ADDR_DEL);
 				found = 1;
 				addr->valid = 0;
-- 
2.19.0

