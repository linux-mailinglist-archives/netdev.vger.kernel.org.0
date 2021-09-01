Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85D13FDA48
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 15:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244866AbhIAMbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 08:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244645AbhIAMbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 08:31:01 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4F6C0612AB
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 05:29:12 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so4494622pjc.3
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 05:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ry8r/FE2YszM7sldRKW00TBIHYPJpEu8TienZ1iylz4=;
        b=gf4/6yTNwgL6TQ8IRoYqr/lUPoCHCebu1EjoZXc2IBxXGQnpw7JDqr84cghCHRRfLx
         4tRfhpFLVzCRzEOnIkZVgS9cMg/1lq3YHHESdKDZx7KSKKow49KVh/3/ZvmqPtGB40NN
         LagZgSYCnboUfsbFBlY6+vM4OegW0s6v8xX069phDN1mqxWyO6mnFsxaMDXO5e3NvpeU
         QqXOfkSiM/mpcQUyqiCD5tZ3Hp4XyvfKHLLZ0e3VjB8Ezp9Ycxzbw+nE0w7uU/83T39Y
         57uZQ8yGjov7a+grFNCDbc3o5E8Z9XB7sFxlFj/a3dtdPTt97OelZCXmL3crAhTzTYiT
         PviQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ry8r/FE2YszM7sldRKW00TBIHYPJpEu8TienZ1iylz4=;
        b=czO0LEOuODwOg4+8zMlGDEv0vESy40NSFmf7Eblq8A21FsKL3h2+ihDd6Mi5E9H5OZ
         kQa3MighGG39OKAqaIduQd9E7gtp682saQOgczfc7tWub1dsK8bKWuAEnXiub+MBr5WQ
         +q6HWcwBBGhwKCePfDMJEJuvmxGKzhd2iP3mTsq/6gospr0WA8Z1+aL04boADyTJH4R2
         eRTtc2CQ/YwJZOGvlBiz2a1a767pYWidPRxNeSU8m2LIInBBAAzA6/lBIiHqSPPyNDeE
         m1b0Sqmj813WxKqUehaU5+RwEaN4c15rvUOxjrEwOogYHwf1d6i9eS+RMi4EoTSVAFZ1
         Vtpw==
X-Gm-Message-State: AOAM531riqgmi7v1kaM4NR9Vb8i4OtUy6y0ntePTilPUzsjnlX9Gtqxh
        UWRv/h0SSaXwsW4QCYMz1NBcueNRY1c=
X-Google-Smtp-Source: ABdhPJyhvUAXXvsPaD9AWYvURCP9fCRb3O29dBVZiMGMX1ePcfF0ntqBu14R2x9kXyVaAwdWo5ViFg==
X-Received: by 2002:a17:90a:d187:: with SMTP id fu7mr11591740pjb.106.1630499351500;
        Wed, 01 Sep 2021 05:29:11 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b7sm22018997pgs.64.2021.09.01.05.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 05:29:11 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>, Xiumei Mu <xmu@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH net] wireguard: remove peer cache in netns_pre_exit
Date:   Wed,  1 Sep 2021 20:29:04 +0800
Message-Id: <20210901122904.9094-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wg_peer_remove_all() will put peer's refcount and clear peer's dst cache
if no ref hold. Currently, it was only called in wg_destruct().

When delete a netns with wg interface in side, the wg_netns_pre_exit() is
called first. Later in netdev_run_todo() the function will be hung at
netdev_wait_allrefs(dev) as dev->priv_destructor(dev) runs later, the
peer's dst cache could not be cleared and there is still a reference on
the device. This could cause kernel errors like:

unregister_netdevice: waiting for wg0 to become free. Usage count = 2
(if remove the veth interface in netns first)
or
unregister_netdevice: waiting for veth1 to become free. Usage count = 2
(if not remove veth interface first)

Fix it by removing peer cache in netns_pre_exit.

Also add a test in netns.sh for this issue.

Reported-by: Xiumei Mu <xmu@redhat.com>
Tested-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/wireguard/device.c             |  1 +
 tools/testing/selftests/wireguard/netns.sh | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 551ddaaaf540..c370854c76eb 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -407,6 +407,7 @@ static void wg_netns_pre_exit(struct net *net)
 			mutex_lock(&wg->device_update_lock);
 			rcu_assign_pointer(wg->creating_net, NULL);
 			wg_socket_reinit(wg, NULL, NULL);
+			wg_peer_remove_all(wg);
 			mutex_unlock(&wg->device_update_lock);
 		}
 	}
diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index ebc4ee0fe179..d94c2c887bcd 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -614,6 +614,24 @@ ip1 link add wg1 type wireguard
 ip2 link add wg2 type wireguard
 ip1 link set wg1 netns $netns2
 ip2 link set wg2 netns $netns1
+
+ip1 link add dev wg0 type wireguard
+ip2 link add dev wg0 type wireguard
+configure_peers
+ip1 link add veth1 type veth peer name veth2
+ip1 link set veth2 netns $netns2
+ip1 addr add fd00:aa::1/64 dev veth1
+ip2 addr add fd00:aa::2/64 dev veth2
+ip1 link set veth1 up
+ip2 link set veth2 up
+waitiface $netns1 veth1
+waitiface $netns2 veth2
+ip1 -6 route add default dev veth1 via fd00:aa::2
+ip2 -6 route add default dev veth2 via fd00:aa::1
+n1 wg set wg0 peer "$pub2" endpoint [fd00:aa::2]:2
+n2 wg set wg0 peer "$pub1" endpoint [fd00:aa::1]:1
+n1 ping6 -c 1 fd00::2
+
 pp ip netns delete $netns1
 pp ip netns delete $netns2
 pp ip netns add $netns1
-- 
2.31.1

