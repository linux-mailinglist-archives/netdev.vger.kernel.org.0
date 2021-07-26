Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149993D52EE
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 07:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhGZFHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 01:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhGZFHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 01:07:34 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84688C061757;
        Sun, 25 Jul 2021 22:48:03 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id x12so1037160qvo.12;
        Sun, 25 Jul 2021 22:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IjUSYUWGzcBLQG2iUil833w4Zd3GqFtQlxGn9nyit5k=;
        b=S9uFWcpxD/QrakM9dEgq7JCJjBUPkX7T1EySjVtZwLGkdUscQN63QmH6Q5zUZf6AuU
         WkA3XibX9Evq7Z4Bpxx0BTT46+3hFFkeip6slBVPcazG9e+JYhN9tvJ4SYBdO8Kn1B3M
         6kCm7DmeCzcnnKKJw2DZ0hSmeRieTzVEX6axuqOXizgmfAbVSd5vNFWyP+GJ7PzwSJBh
         yigd0EK/l1Xu0SNQOpEKDTY8g7d4ESRn9WFX39wihsb6/ASbBmZyWdnXka0RDkZQjE6s
         T2sQctiULV4+IUSaWs9Oxgb/hJWjGRghDcrOIN0LvEpiT5vxam9C5M2hS7smSqNYvHkY
         6Ntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IjUSYUWGzcBLQG2iUil833w4Zd3GqFtQlxGn9nyit5k=;
        b=PEGUeXnYcgXG96a01QvU8jHxdaTmEBn2o46iSvrUqE7z24ndFF5R13dUaea2Wa8d3b
         ci3B7Z4oIa3NKLSnMNpTHzzQCVMDU3DffpMe2ci31XFlbp3lWha554LAhOEQ+zfHTt0/
         Zb7gKg6cd7oZic1NZ00Yjjk08beZxAOc065h7X8bbL+z0vshaslDISOzy2LJgw6a7IKO
         uzanxMrJ9KNS36KDZiN5MZOMyPEdL8Dk9Fgsx/Pn2NMMcvnj3vqImO4GvZBkz34tXRrB
         2mqkEkkMFlnLkL6RWd8FTdZgZlicMloYdNV6QjXEK4Tca9wd+3pqX3Eh5/9v3jsPq1eJ
         w1jQ==
X-Gm-Message-State: AOAM532rXz3cis65QqTKFfhPf7YyuzUgDiThKPv8Qp8xN3TU0cNvm6m0
        JB5I0rM7RjEW9df/6Jof6Q==
X-Google-Smtp-Source: ABdhPJwm7C4CimaVH15ZzSIqWqjk0cJnOJWk7qqez3PMwEi4SZVW9nem4uFkEGvQaoWw65dU5tghmA==
X-Received: by 2002:ad4:5cad:: with SMTP id q13mr16416000qvh.10.1627278482331;
        Sun, 25 Jul 2021 22:48:02 -0700 (PDT)
Received: from localhost.localdomain (74.121.150.105.16clouds.com. [74.121.150.105])
        by smtp.gmail.com with ESMTPSA id h7sm14799668qtq.79.2021.07.25.22.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 22:48:01 -0700 (PDT)
From:   Chen Shen <peterchenshen@gmail.com>
To:     marcelo.leitner@gmail.com
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chen Shen <peterchenshen@gmail.com>
Subject: [PATCH v2] sctp: delete addr based on sin6_scope_id
Date:   Mon, 26 Jul 2021 13:47:34 +0800
Message-Id: <20210726054733.75937-1-peterchenshen@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YP3tOORtoNHZXQdt@horizon.localdomain>
References: <YP3tOORtoNHZXQdt@horizon.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_inet6addr_event deletes 'addr' from 'local_addr_list' when setting
netdev down, but it is possible to delete the incorrect entry (match
the first one with the same ipaddr, but the different 'ifindex'), if
there are some netdevs with the same 'local-link' ipaddr added already.
It should delete the entry depending on 'sin6_addr' and 'sin6_scope_id'
both. otherwise, the endpoint will call 'sctp_sf_ootb' if it can't find
the according association when receives 'heartbeat', and finally will
reply 'abort'.

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

Signed-off-by: Chen Shen <peterchenshen@gmail.com>
---
 net/sctp/ipv6.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 52c92b8d827f..f5f54229b055 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -99,8 +99,9 @@ static int sctp_inet6addr_event(struct notifier_block *this, unsigned long ev,
 		list_for_each_entry_safe(addr, temp,
 					&net->sctp.local_addr_list, list) {
 			if (addr->a.sa.sa_family == AF_INET6 &&
-					ipv6_addr_equal(&addr->a.v6.sin6_addr,
-						&ifa->addr)) {
+			    ipv6_addr_equal(&addr->a.v6.sin6_addr,
+					    &ifa->addr) &&
+			    addr->a.v6.sin6_scope_id == ifa->idev->dev->ifindex) {
 				sctp_addr_wq_mgmt(net, addr, SCTP_ADDR_DEL);
 				found = 1;
 				addr->valid = 0;
-- 
2.19.0

