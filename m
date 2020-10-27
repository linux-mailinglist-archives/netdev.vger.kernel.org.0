Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8114229C80C
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829205AbgJ0TA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:00:59 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41556 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371357AbgJ0TAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id s9so3113073wro.8
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a8a/oVFoV9MTiz2akf3h4usj7NJQcCNmdh3b+TKbrQA=;
        b=P4jRtSivE3zFaJhLu81Q2XNew3IIJiT+Px3Whj9g1g8Gc7u3qcaobFj+YtwCNzgSSs
         bo8/7GN+l7b3fv3p3sWA2JZy8UXUxtly4N3B3zPvjQR1pdN/IVrQ1FeDuifm+bibZmge
         j/SvIb2kbVUtNsodCKc879jyO1WDZPwI/+7Jo4MkjSpcwzVFBujXq+tZl655OLydnq88
         OR/k0qUg3B/RDIvTRZyEA4zUbLE3exjfJh1yGXSXi753GzDTqdyAMNZzQGHpR5VIWkvh
         6F2C1sBxCrTzh022tfqYSSsKeSxdVQBHKJT8HwqC2s/KSMIhucdtCW3A8YwyoCntzkPy
         9YjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a8a/oVFoV9MTiz2akf3h4usj7NJQcCNmdh3b+TKbrQA=;
        b=iNexRAmkbtZco+jwfyx+nzPageMV3ACttg649gq/x87udQEzpx14gJXVYV60epfkJZ
         AHXZSJtwTBIl59WmYMmQmH9emP1Bww2U9bfiiT3oVvf6dtv4SkBKtYnp7kmkbG/0yoAu
         Wc903XYFnKGeO50NO/kpS+QOMlyPq3O7vX6vZj552VjijsYfa1sYy8xE6B6DaEE9GG5f
         Uu9CWwHqAkqS/y8bdN6IkKbfk1fERLs4GmqxkLx7ivT2Zal+kD6ZdinpUe/1liUaPXu3
         PWZBlQ8JG+f8/+nRgAw9ffLyL4JD2q9NxRlE94qMjsxWpOOriDr8wzqKbCFs++PxxVCy
         qGaQ==
X-Gm-Message-State: AOAM530EXoiyRbcv828JZ6SM2APO43q4DLxr00vi74TUXm4vBIPdF5M0
        wA5Qnf5TILpCBhbh11nkJAc7mrl3obflewyA
X-Google-Smtp-Source: ABdhPJy6oZTZKiqP/ci+0HGrgHauw0AUcqHOwQrQTf7wYMyuZtDGcv00BLROWYVJvzm94AUKlbObSg==
X-Received: by 2002:adf:f1cd:: with SMTP id z13mr4456623wro.197.1603825209356;
        Tue, 27 Oct 2020 12:00:09 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:08 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 03/16] selftests: net: bridge: igmp: check for specific udp ip protocol
Date:   Tue, 27 Oct 2020 20:59:21 +0200
Message-Id: <20201027185934.227040-4-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201027185934.227040-1-razor@blackwall.org>
References: <20201027185934.227040-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We have to specifically check for udp protocol in addition to the mac
address because in IGMPv3 tests group-specific queries will use the same
mac address.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 tools/testing/selftests/net/forwarding/bridge_igmp.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 1c19459dbc58..5562aef14c0a 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -93,7 +93,7 @@ mcast_packet_test()
 	# was received by it or not.
 	tc qdisc add dev $host2_if ingress
 	tc filter add dev $host2_if ingress protocol ip pref 1 handle 101 \
-		flower dst_mac $mac action drop
+		flower ip_proto udp dst_mac $mac action drop
 
 	$MZ $host1_if -c 1 -p 64 -b $mac -A $src_ip -B $ip -t udp "dp=4096,sp=2048" -q
 	sleep 1
-- 
2.25.4

