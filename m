Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BA9458474
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 16:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238308AbhKUP2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 10:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237998AbhKUP2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 10:28:05 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE081C061574
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 07:25:00 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id d24so27876799wra.0
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 07:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YdI2qAbhBKDe5VUn7Rq1JEgY1oY5Lzihg79Dg/tTIx0=;
        b=67ovZ62UZz9/LUB2MeZzKqIgS8d6QuKc+D53LwY1a+/FeMYZo/ku98Sa8ByY6tIf1/
         hCZzkAXuIAQpREFwvem/tMSHwfRTXPwCdU08lXyVq0cAD2GhzHUZJAiISEjM3hmE1kp4
         aWImJ65iBzdHjoqVxfxcE3fxGC31dTf/Fre2mUPOg1e++S07hNWup6+yXnV+dPjImNRr
         7nnnEDyNqBqCXneZhH1g87AH2IXr2O610dc1Bps+gHiRh5Xi1Zg6rCJpbjpIcSgnlyhS
         +EtiADZi3us9OPg9pM1tfb7ehjuBztUwug120gNmku1+sUBujUCJxOk9cjtyDQF+BUNp
         Jctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YdI2qAbhBKDe5VUn7Rq1JEgY1oY5Lzihg79Dg/tTIx0=;
        b=6shZ93ImH41Wm8GxxYMJifyQlxhwY50wcuBspZryTuX+5PxGMtcQa/95wwirTnKsYI
         H5cWhIt5nlTEffZlf3r9gqY91xCRRivmc132zLZu1SaznYhoTayaxiS8RXB7yH+44A7g
         AWFVmHlLkVEgoGDIqH6EZ9A6ctnVj1yVn1Qm7bcuuOSD008003xN/Qg+AGVd9WvtMdhp
         Z74mfMljoDOXIaT64E7yLolOe21XFR+LsBKsa1QrlJ/uK0eDlIoosJ6o7wfIkBhmtrcM
         ri8SwqbMsZS+UUAzhpifj2vBZcewt8j0scS55+xHKbry68frmgJ3a3QHnr1mclcFg7qA
         9q6A==
X-Gm-Message-State: AOAM531whtmYU/GwCTINR2McROGa3zEOTyv/uXHZsNUwSqa4HfAqexvi
        mwkI5+cX0Q5dawLKzclWoft4E+7IldMDphVI
X-Google-Smtp-Source: ABdhPJzDL2LqzQZ2FuOR8j9hGNcTWVndiA2CSjElwXLS12kr97dTQJ+ZlAo6v93ev2Xbsr0t/eEFjA==
X-Received: by 2002:a05:6000:2a3:: with SMTP id l3mr29275683wry.415.1637508299249;
        Sun, 21 Nov 2021 07:24:59 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m36sm7165559wms.25.2021.11.21.07.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 07:24:58 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 3/3] selftests: net: fib_nexthops: add test for group refcount imbalance bug
Date:   Sun, 21 Nov 2021 17:24:53 +0200
Message-Id: <20211121152453.2580051-4-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211121152453.2580051-1-razor@blackwall.org>
References: <20211121152453.2580051-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

The new selftest runs a sequence which causes circular refcount
dependency between deleted objects which cannot be released and results
in a netdevice refcount imbalance.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 56 +++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index b5a69ad191b0..48d88a36ae27 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -629,6 +629,59 @@ ipv6_fcnal()
 	log_test $? 0 "Nexthops removed on admin down"
 }
 
+ipv6_grp_refs()
+{
+	run_cmd "$IP link set dev veth1 up"
+	run_cmd "$IP link add veth1.10 link veth1 up type vlan id 10"
+	run_cmd "$IP link add veth1.20 link veth1 up type vlan id 20"
+	run_cmd "$IP -6 addr add 2001:db8:91::1/64 dev veth1.10"
+	run_cmd "$IP -6 addr add 2001:db8:92::1/64 dev veth1.20"
+	run_cmd "$IP -6 neigh add 2001:db8:91::2 lladdr 00:11:22:33:44:55 dev veth1.10"
+	run_cmd "$IP -6 neigh add 2001:db8:92::2 lladdr 00:11:22:33:44:55 dev veth1.20"
+	run_cmd "$IP nexthop add id 100 via 2001:db8:91::2 dev veth1.10"
+	run_cmd "$IP nexthop add id 101 via 2001:db8:92::2 dev veth1.20"
+	run_cmd "$IP nexthop add id 102 group 100"
+	run_cmd "$IP route add 2001:db8:101::1/128 nhid 102"
+
+	# create per-cpu dsts through nh 100
+	run_cmd "ip netns exec me mausezahn -6 veth1.10 -B 2001:db8:101::1 -A 2001:db8:91::1 -c 5 -t tcp "dp=1-1023, flags=syn" >/dev/null 2>&1"
+
+	# remove nh 100 from the group to delete the route potentially leaving
+	# a stale per-cpu dst
+	run_cmd "$IP nexthop replace id 102 group 101"
+	run_cmd "$IP route del 2001:db8:101::1/128"
+
+	# add both nexthops to the group so a reference is taken on them
+	run_cmd "$IP nexthop replace id 102 group 100/101"
+
+	# if the bug exists at this point we have an unlinked IPv6 route
+	# (but not freed due to stale dst) with a reference over the group
+	# so we delete the group which will again only unlink it due to the
+	# route reference
+	run_cmd "$IP nexthop del id 102"
+
+	# delete the nexthop with stale dst, since we have an unlinked
+	# group with a ref to it and an unlinked IPv6 route with ref to the
+	# group, the nh will only be unlinked and not freed so the stale dst
+	# remains forever and we get a net device refcount imbalance
+	run_cmd "$IP nexthop del id 100"
+
+	# if the bug exists this command will hang because the net device
+	# cannot be removed
+	timeout -s KILL 5 ip netns exec me ip link del veth1.10 >/dev/null 2>&1
+
+	# we can't cleanup if the command is hung trying to delete the netdev
+	if [ $? -eq 137 ]; then
+		return 1
+	fi
+
+	# cleanup
+	run_cmd "$IP link del veth1.20"
+	run_cmd "$IP nexthop flush"
+
+	return 0
+}
+
 ipv6_grp_fcnal()
 {
 	local rc
@@ -734,6 +787,9 @@ ipv6_grp_fcnal()
 
 	run_cmd "$IP nexthop add id 108 group 31/24"
 	log_test $? 2 "Nexthop group can not have a blackhole and another nexthop"
+
+	ipv6_grp_refs
+	log_test $? 0 "Nexthop group replace refcounts"
 }
 
 ipv6_res_grp_fcnal()
-- 
2.31.1

