Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32A98158A72
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 08:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbgBKHdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 02:33:12 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34565 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgBKHdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 02:33:11 -0500
Received: by mail-pl1-f194.google.com with SMTP id j7so3924442plt.1
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 23:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aIwKZHgWPZVzsQUzZ8UKnB19bLveljpjddOzNYirBJQ=;
        b=vNT0fy2fSFWvC5KpJeSr1PoC8lSvB0Pc25k4Bo5Nx5tPx0+pWq0jkM85XsHOEEPlyQ
         Bow+uE8Z1djkmpIeRmp4/k/LKBAQdkNrr/4ckydp2Sy712G+9iL+cZtI90fx1ywpRTdt
         xFcmU6lYjDXmbQk6HoaqyxCcIMtv/5CvQO5RTeJv/vYoY3fqfet+VqU5asj3OE1PabRj
         LmMIvol4jV9uBT7G3utYuFE40/jDLVt3I2cOH9fyIL1bi8JXdlcbBablgf9EgMdT78np
         ATh2+86wQDu/zGQuCUYarw3Gg1+k4+8PQQpgZEzNcEHgcTPkfK3M/Lk5F00lTbToTYf/
         XXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aIwKZHgWPZVzsQUzZ8UKnB19bLveljpjddOzNYirBJQ=;
        b=tEp0Wrbv/ClAtc5+qSIdXgbTRgUVTumCbQ94rA9ZTJy+in+kZcVSn3mTWW4EXLyCxN
         2XtBkx2nv4eTnnHmxS8c+rqD92lADPs0+H6PrM8nYY7lbyZbC/4u4MpqVKXej7wwr+rt
         EwBHj4ic7P3ztyQCKTQlPxhPtTYy8qF4HJy3yfqk0Jse4YiMh5G7uca8LX35H4LuTJRa
         4MwLVJm00j8Q5iqHPceDM7G1ttTx1oO0xYOakSuw7unROVUBmxR1emHOtO00qoeckyZX
         T4zRS0iVMFCPGwgjgko2WblNXVvA+DjAfcsGHYkWP0DZ+qt7/XR1LF1nQZ98q5hJBPg0
         HxoA==
X-Gm-Message-State: APjAAAXxP9jWYUsji5QSAvDVmG2YLr3OPMBMqjUpw0tsM7UHISyB7Hzm
        T1e5N3UvA+dpOp9QBrJlM1bFbXXUuw4=
X-Google-Smtp-Source: APXvYqzMmRGGf1xo2vgNTHyTnZEM7TUeuuhgPq+8lKYZs2I3idKCIdxtqOH/YiNVSv545AtDkYAlnA==
X-Received: by 2002:a17:902:864a:: with SMTP id y10mr16959067plt.2.1581406390643;
        Mon, 10 Feb 2020 23:33:10 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h7sm3121060pfq.36.2020.02.10.23.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 23:33:10 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests: forwarding: use proto icmp for {gretap,ip6gretap}_mac testing
Date:   Tue, 11 Feb 2020 15:32:56 +0800
Message-Id: <20200211073256.32652-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For tc ip_proto filter, when we extract the flow via __skb_flow_dissect()
without flag FLOW_DISSECTOR_F_STOP_AT_ENCAP, we will continue extract to
the inner proto.

So for GRE + ICMP messages, we should not track GRE proto, but inner ICMP
proto.

For test mirror_gre.sh, it may make user confused if we capture ICMP
message on $h3(since the flow is GRE message). So I move the capture
dev to h3-gt{4,6}, and only capture ICMP message.

Before the fix:
]# ./mirror_gre.sh
TEST: ingress mirror to gretap (skip_hw)                            [ OK ]
TEST: egress mirror to gretap (skip_hw)                             [ OK ]
TEST: ingress mirror to ip6gretap (skip_hw)                         [ OK ]
TEST: egress mirror to ip6gretap (skip_hw)                          [ OK ]
TEST: ingress mirror to gretap: envelope MAC (skip_hw)              [FAIL]
 Expected to capture 10 packets, got 0.
TEST: egress mirror to gretap: envelope MAC (skip_hw)               [FAIL]
 Expected to capture 10 packets, got 0.
TEST: ingress mirror to ip6gretap: envelope MAC (skip_hw)           [FAIL]
 Expected to capture 10 packets, got 0.
TEST: egress mirror to ip6gretap: envelope MAC (skip_hw)            [FAIL]
 Expected to capture 10 packets, got 0.
TEST: two simultaneously configured mirrors (skip_hw)               [ OK ]
WARN: Could not test offloaded functionality

After fix:
]# ./mirror_gre.sh
TEST: ingress mirror to gretap (skip_hw)                            [ OK ]
TEST: egress mirror to gretap (skip_hw)                             [ OK ]
TEST: ingress mirror to ip6gretap (skip_hw)                         [ OK ]
TEST: egress mirror to ip6gretap (skip_hw)                          [ OK ]
TEST: ingress mirror to gretap: envelope MAC (skip_hw)              [ OK ]
TEST: egress mirror to gretap: envelope MAC (skip_hw)               [ OK ]
TEST: ingress mirror to ip6gretap: envelope MAC (skip_hw)           [ OK ]
TEST: egress mirror to ip6gretap: envelope MAC (skip_hw)            [ OK ]
TEST: two simultaneously configured mirrors (skip_hw)               [ OK ]
WARN: Could not test offloaded functionality

Fixes: ba8d39871a10 ("selftests: forwarding: Add test for mirror to gretap")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/net/forwarding/mirror_gre.sh    | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/mirror_gre.sh b/tools/testing/selftests/net/forwarding/mirror_gre.sh
index e6fd7a18c655..0266443601bc 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre.sh
@@ -63,22 +63,23 @@ test_span_gre_mac()
 {
 	local tundev=$1; shift
 	local direction=$1; shift
-	local prot=$1; shift
 	local what=$1; shift
 
-	local swp3mac=$(mac_get $swp3)
-	local h3mac=$(mac_get $h3)
+	case "$direction" in
+	ingress) local src_mac=$(mac_get $h1); local dst_mac=$(mac_get $h2)
+		;;
+	egress) local src_mac=$(mac_get $h2); local dst_mac=$(mac_get $h1)
+		;;
+	esac
 
 	RET=0
 
 	mirror_install $swp1 $direction $tundev "matchall $tcflags"
-	tc filter add dev $h3 ingress pref 77 prot $prot \
-		flower ip_proto 0x2f src_mac $swp3mac dst_mac $h3mac \
-		action pass
+	icmp_capture_install h3-${tundev} "src_mac $src_mac dst_mac $dst_mac"
 
-	mirror_test v$h1 192.0.2.1 192.0.2.2 $h3 77 10
+	mirror_test v$h1 192.0.2.1 192.0.2.2 h3-${tundev} 100 10
 
-	tc filter del dev $h3 ingress pref 77
+	icmp_capture_uninstall h3-${tundev}
 	mirror_uninstall $swp1 $direction
 
 	log_test "$direction $what: envelope MAC ($tcflags)"
@@ -120,14 +121,14 @@ test_ip6gretap()
 
 test_gretap_mac()
 {
-	test_span_gre_mac gt4 ingress ip "mirror to gretap"
-	test_span_gre_mac gt4 egress ip "mirror to gretap"
+	test_span_gre_mac gt4 ingress "mirror to gretap"
+	test_span_gre_mac gt4 egress "mirror to gretap"
 }
 
 test_ip6gretap_mac()
 {
-	test_span_gre_mac gt6 ingress ipv6 "mirror to ip6gretap"
-	test_span_gre_mac gt6 egress ipv6 "mirror to ip6gretap"
+	test_span_gre_mac gt6 ingress "mirror to ip6gretap"
+	test_span_gre_mac gt6 egress "mirror to ip6gretap"
 }
 
 test_all()
-- 
2.19.2

