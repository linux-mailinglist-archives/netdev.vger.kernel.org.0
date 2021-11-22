Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9168545911A
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239761AbhKVPSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhKVPSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:18:31 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D328CC061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:15:24 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y13so78303919edd.13
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R2B4Fj4YV/PyfqcipOhaZfSpP1N1LY2SlQEPFvPlrys=;
        b=rVTIXXJgpzTsF9KM0vhgVgPmWkHSJUGYUkbmSCYQRi5vhn2zzOJCmWQ6/S+7kFHMf2
         cLG0yeUvaTSmBVBVo9t9Q5jDlAlDXQ6GxInqyrpDtU8wWF+aK8nsVw1VLKjLt/6fwilB
         wlB3Uly3xgovYBcfK2W+X3R6s9WO8pYZQBr5E/WIC/+SThK71KCC0ssiyQCOFfMhuiy+
         Oaw8V8+Fcd+wtYWZf2z89Bq56oV/w9zO4OC9mX4MwVeLmeQYGQNALXHkw7FkwV/OPDb2
         ziQcuIZG15vaM9pKRgA97mx3hLcyIXmXXRM/IJZxNcVwmxoF5HsNAICiD+pH82zF/Nnj
         3aaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R2B4Fj4YV/PyfqcipOhaZfSpP1N1LY2SlQEPFvPlrys=;
        b=2UcFVwbii43h4ivzJru53bGt3xvgZbbV6J0hFB7BYIkLR8agYHDyS5W1xwmaaK5OqN
         vIeMt90JYipaXtVXPj2cv3XXshmpoGTaNHsV0cr/Nh2Fl441lfGzSEm/GfnwgJgPlTpn
         jnPpZIF6Pu1lrE/FgVLORwvktIxJ32GewgN2U6WospM4T5EfG6ED72BEOz0cvw7/eChH
         NvYEqTKpZ4EbJSMaWoF7gpuup1SWDdc2U8CB/AUlMumn0Yy0OiBu/vlvud0jNON+rP/0
         1O3VvzfWAo23cuqpVQr4iBEuqb8zbKbyARbBc5U+ImGgictdT8Gmize3rPU1lXRt5SmF
         dCSw==
X-Gm-Message-State: AOAM531I/wdNdoD2BOhBMn9NLPWt1HkfpLQ0DWgJiCBIOa3mdsOaqI0O
        yLRPx5ZaLIlQ19ekGwxd48ALxt6PsICcXlSs
X-Google-Smtp-Source: ABdhPJy7lkT9yO6iU/CRWgJbyojk5oTwZWyG6srQZYZGR/UIYplwQkKBg05iDhTeb3ebwiydalvANA==
X-Received: by 2002:a17:907:629b:: with SMTP id nd27mr41408983ejc.24.1637594122456;
        Mon, 22 Nov 2021 07:15:22 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id qb21sm3906904ejc.78.2021.11.22.07.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:15:22 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net v2 3/3] selftests: net: fib_nexthops: add test for group refcount imbalance bug
Date:   Mon, 22 Nov 2021 17:15:14 +0200
Message-Id: <20211122151514.2813935-4-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122151514.2813935-1-razor@blackwall.org>
References: <20211122151514.2813935-1-razor@blackwall.org>
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
v2: check for mausezahn before testing and make a few comments
    more verbose

 tools/testing/selftests/net/fib_nexthops.sh | 63 +++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index b5a69ad191b0..d444ee6aa3cb 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -629,6 +629,66 @@ ipv6_fcnal()
 	log_test $? 0 "Nexthops removed on admin down"
 }
 
+ipv6_grp_refs()
+{
+	if [ ! -x "$(command -v mausezahn)" ]; then
+		echo "SKIP: Could not run test; need mausezahn tool"
+		return
+	fi
+
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
+	# a stale per-cpu dst which holds a reference to the nexthop's net
+	# device and to the IPv6 route
+	run_cmd "$IP nexthop replace id 102 group 101"
+	run_cmd "$IP route del 2001:db8:101::1/128"
+
+	# add both nexthops to the group so a reference is taken on them
+	run_cmd "$IP nexthop replace id 102 group 100/101"
+
+	# if the bug described in commit "net: nexthop: release IPv6 per-cpu
+	# dsts when replacing a nexthop group" exists at this point we have
+	# an unlinked IPv6 route (but not freed due to stale dst) with a
+	# reference over the group so we delete the group which will again
+	# only unlink it due to the route reference
+	run_cmd "$IP nexthop del id 102"
+
+	# delete the nexthop with stale dst, since we have an unlinked
+	# group with a ref to it and an unlinked IPv6 route with ref to the
+	# group, the nh will only be unlinked and not freed so the stale dst
+	# remains forever and we get a net device refcount imbalance
+	run_cmd "$IP nexthop del id 100"
+
+	# if a reference was lost this command will hang because the net device
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
@@ -734,6 +794,9 @@ ipv6_grp_fcnal()
 
 	run_cmd "$IP nexthop add id 108 group 31/24"
 	log_test $? 2 "Nexthop group can not have a blackhole and another nexthop"
+
+	ipv6_grp_refs
+	log_test $? 0 "Nexthop group replace refcounts"
 }
 
 ipv6_res_grp_fcnal()
-- 
2.31.1

