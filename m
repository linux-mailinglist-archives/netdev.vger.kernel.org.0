Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61ED66AF9D
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 08:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjAOHQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 02:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjAOHQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 02:16:32 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C071FCDC1;
        Sat, 14 Jan 2023 23:16:23 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id s13-20020a17090a6e4d00b0022900843652so9496623pjm.1;
        Sat, 14 Jan 2023 23:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pBBA/Ht2M9hrjp8K0+TAAr/in6NVCRMPTM9sEcsGTI=;
        b=TY29OTqQECMOlR/zS6uHrCnyuLbhI6U629I5wSrhbqmPy/qdZMSf8uc7lwZIXtxlfV
         Fwj//6L5O8VdY9fKCKuXu/FFs4VG8KV0Uf5vZpPACSJbCawh8XQ19+ShIURy1+BsDRS3
         3V9R5xxn9rsoFO+FOr1B8GQEAtQdZvX/t4ktgyYjYoIYBG7bp4AGzI+ODDCMC0YTZmnM
         XEYU8zjXzAvNEWzsXLUwECa2/PF2GuqbdT5QFGv2G/Ieiax7gcuLEQ25ZPLla3xsgpdl
         w4uYn9Vyxl/tvJs1u/ux1KvULz5G6A5NoVuQJyrrHJ/HqP3qe9ko0Lv8YZ1I75N0xqjT
         40gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2pBBA/Ht2M9hrjp8K0+TAAr/in6NVCRMPTM9sEcsGTI=;
        b=P6VYJfelmVryS4MD3ShmNWV9Z3wnF1X1stYBHOe1I5pSnp4uQtRgw1eiCTfsMK7BGJ
         Ww102z+otZlHygrw0a5CyGkzi495fJZw6xHmSGyg1RZtJNa7tBEY5eGYLyA0o23ax/Rl
         BMou1u+CwBu4FoCD53MJJr9Nr/7LL5TEeny/HBSrSszr3Lb28E9Ebze3Z8+b8cBfeqiF
         BDgyZxpyU0vYD6U3C9jLKhH7813pTuHayufQNEN9jDq3xJB3zQJPUyTTt6SH4zj1CXXp
         U40xk6dg3m+DhCw8wYPA5tuTHYVHzA128H0LLVHbB1z44Napi9a5yFQdSrxfYNrhRHqL
         wH9A==
X-Gm-Message-State: AFqh2kqU1RVsBslXNDRaJWjt8saVWw79OzZfmxUo+ceQVsJoZ1FOc6Il
        WUkTi6xyRZexZv3OSJyENw==
X-Google-Smtp-Source: AMrXdXtzmo4m2cUEYPwfgS0qvgxnGMjTJS/9W3B/Raka4RCyzbPYiZe4IrggsnQCc5Rb2qbbMkye1A==
X-Received: by 2002:a05:6a20:9497:b0:a4:486c:568f with SMTP id hs23-20020a056a20949700b000a4486c568fmr83748236pzb.59.1673766983249;
        Sat, 14 Jan 2023 23:16:23 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7990d000000b0058a313f4e4esm10272796pff.149.2023.01.14.23.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 23:16:22 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 01/10] samples/bpf: ensure ipv6 is enabled before running tests
Date:   Sun, 15 Jan 2023 16:16:04 +0900
Message-Id: <20230115071613.125791-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230115071613.125791-1-danieltimlee@gmail.com>
References: <20230115071613.125791-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, a few of BPF tests use ipv6 functionality. The problem here
is that if ipv6 is disabled, these tests will fail, and even if the
test fails, it will not tell you why it failed.

    $ sudo ./test_cgrp2_sock2.sh
    RTNETLINK answers: Permission denied

In order to fix this, this commit ensures ipv6 is enabled prior to
running tests.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/tc_l2_redirect.sh   | 3 +++
 samples/bpf/test_cgrp2_sock2.sh | 4 +++-
 samples/bpf/test_cgrp2_tc.sh    | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/tc_l2_redirect.sh b/samples/bpf/tc_l2_redirect.sh
index 37d95ef3c20f..a28a8fc99dbe 100755
--- a/samples/bpf/tc_l2_redirect.sh
+++ b/samples/bpf/tc_l2_redirect.sh
@@ -8,6 +8,7 @@ REDIRECT_USER='./tc_l2_redirect'
 REDIRECT_BPF='./tc_l2_redirect_kern.o'
 
 RP_FILTER=$(< /proc/sys/net/ipv4/conf/all/rp_filter)
+IPV6_DISABLED=$(< /proc/sys/net/ipv6/conf/all/disable_ipv6)
 IPV6_FORWARDING=$(< /proc/sys/net/ipv6/conf/all/forwarding)
 
 function config_common {
@@ -64,6 +65,7 @@ function config_common {
 
 	sysctl -q -w net.ipv4.conf.all.rp_filter=0
 	sysctl -q -w net.ipv6.conf.all.forwarding=1
+	sysctl -q -w net.ipv6.conf.all.disable_ipv6=0
 }
 
 function cleanup {
@@ -77,6 +79,7 @@ function cleanup {
 	$IP link del ip6t >& /dev/null
 	sysctl -q -w net.ipv4.conf.all.rp_filter=$RP_FILTER
 	sysctl -q -w net.ipv6.conf.all.forwarding=$IPV6_FORWARDING
+	sysctl -q -w net.ipv6.conf.all.disable_ipv6=$IPV6_DISABLED
 	rm -f /sys/fs/bpf/tc/globals/tun_iface
 	[[ -z $DEBUG ]] || set -x
 	set -e
diff --git a/samples/bpf/test_cgrp2_sock2.sh b/samples/bpf/test_cgrp2_sock2.sh
index 6a3dbe642b2b..ac45828ed2bd 100755
--- a/samples/bpf/test_cgrp2_sock2.sh
+++ b/samples/bpf/test_cgrp2_sock2.sh
@@ -7,13 +7,15 @@ LINK_PIN=$BPFFS/test_cgrp2_sock2
 function config_device {
 	ip netns add at_ns0
 	ip link add veth0 type veth peer name veth0b
-	ip link set veth0b up
 	ip link set veth0 netns at_ns0
+	ip netns exec at_ns0 sysctl -q net.ipv6.conf.veth0.disable_ipv6=0
 	ip netns exec at_ns0 ip addr add 172.16.1.100/24 dev veth0
 	ip netns exec at_ns0 ip addr add 2401:db00::1/64 dev veth0 nodad
 	ip netns exec at_ns0 ip link set dev veth0 up
+	sysctl -q net.ipv6.conf.veth0b.disable_ipv6=0
 	ip addr add 172.16.1.101/24 dev veth0b
 	ip addr add 2401:db00::2/64 dev veth0b nodad
+	ip link set veth0b up
 }
 
 function config_cgroup {
diff --git a/samples/bpf/test_cgrp2_tc.sh b/samples/bpf/test_cgrp2_tc.sh
index 395573be6ae8..a6f1ed03ddf6 100755
--- a/samples/bpf/test_cgrp2_tc.sh
+++ b/samples/bpf/test_cgrp2_tc.sh
@@ -73,11 +73,13 @@ setup_net() {
 	start)
 	    $IP link add $HOST_IFC type veth peer name $NS_IFC || return $?
 	    $IP link set dev $HOST_IFC up || return $?
+	    sysctl -q net.ipv6.conf.$HOST_IFC.disable_ipv6=0
 	    sysctl -q net.ipv6.conf.$HOST_IFC.accept_dad=0
 
 	    $IP netns add ns || return $?
 	    $IP link set dev $NS_IFC netns ns || return $?
 	    $IP -n $NS link set dev $NS_IFC up || return $?
+	    $IP netns exec $NS sysctl -q net.ipv6.conf.$NS_IFC.disable_ipv6=0
 	    $IP netns exec $NS sysctl -q net.ipv6.conf.$NS_IFC.accept_dad=0
 	    $TC qdisc add dev $HOST_IFC clsact || return $?
 	    $TC filter add dev $HOST_IFC egress bpf da obj $BPF_PROG sec $BPF_SECTION || return $?
-- 
2.34.1

