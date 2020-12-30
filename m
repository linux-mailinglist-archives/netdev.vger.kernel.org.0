Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B742E7794
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 10:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgL3Jw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 04:52:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59575 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgL3Jwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 04:52:55 -0500
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kuY9N-00083w-SR
        for netdev@vger.kernel.org; Wed, 30 Dec 2020 09:52:14 +0000
Received: by mail-pf1-f198.google.com with SMTP id 15so5716106pfu.6
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 01:52:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=i+QpbOc8ony+XYCIFM3o157TRlJnFXAk3ZOK7FKW9BI=;
        b=V82DjcMFXP56vA9DKcYVSfbxap1TIOkKEd2gpz6WWV4gJZrHmyU0RODp2Vomed4Lyr
         foD7kn+KpoXrDNtOf0mh9t/+dIY4Ca1oAmnyu4hxRt2JGbXN5C73nCbl7O2K8TxNyFE5
         R2ICCn4PNx2duUsBBTFmqsftmjY/IfWSsI8dF9I1gY48HTxO+P3W0kYBU+jnn9ah2lKk
         JEt4cTrb4/Gw2YX/m+F1143SaPmwMaHcLJTE5j0fmpMl+PM9EkVG/5j5ABQ56/A4Mg1T
         zUPwRGZa3VuAUFfnh2vssxBdXq2kndcjjv+B/82lzcvCSQDX+hOZ9/4azjbrjBQbG85O
         jYUw==
X-Gm-Message-State: AOAM533DByB4V0I7h4qWVkQMm+V0900ct7hNldghmSop0IVVFG/223ar
        a4JaNZNYeGfFp98Gf3AhlZYiwrTWpPwgUOEZvW6xzEhR7s93X881n55P0BAQreA6eKomadEUUw+
        K4xd3gtRCGDBPZ6PJ+0BIYvV5StNCf5OU
X-Received: by 2002:aa7:9a86:0:b029:1a6:d998:922a with SMTP id w6-20020aa79a860000b02901a6d998922amr48132012pfi.80.1609321932206;
        Wed, 30 Dec 2020 01:52:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzr5fqZt0GWUwoVWcweJRpwujCifX5YbQe+UHhaQGaqOLkfkyB0G/hbQ9bL9Z95VEAeqyA3JA==
X-Received: by 2002:aa7:9a86:0:b029:1a6:d998:922a with SMTP id w6-20020aa79a860000b02901a6d998922amr48132008pfi.80.1609321931953;
        Wed, 30 Dec 2020 01:52:11 -0800 (PST)
Received: from Leggiero.taipei.internal (61-220-137-38.HINET-IP.hinet.net. [61.220.137.38])
        by smtp.gmail.com with ESMTPSA id m13sm41214530pff.21.2020.12.30.01.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 01:52:11 -0800 (PST)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        steffen.klassert@secunet.com, fw@strlen.de
Subject: [PATCH] selftests: xfrm: fix test return value override issue in xfrm_policy.sh
Date:   Wed, 30 Dec 2020 17:52:04 +0800
Message-Id: <20201230095204.21467-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running this xfrm_policy.sh test script, even with some cases
marked as FAIL, the overall test result will still be PASS:

$ sudo ./xfrm_policy.sh
PASS: policy before exception matches
FAIL: expected ping to .254 to fail (exceptions)
PASS: direct policy matches (exceptions)
PASS: policy matches (exceptions)
FAIL: expected ping to .254 to fail (exceptions and block policies)
PASS: direct policy matches (exceptions and block policies)
PASS: policy matches (exceptions and block policies)
FAIL: expected ping to .254 to fail (exceptions and block policies after hresh changes)
PASS: direct policy matches (exceptions and block policies after hresh changes)
PASS: policy matches (exceptions and block policies after hresh changes)
FAIL: expected ping to .254 to fail (exceptions and block policies after hthresh change in ns3)
PASS: direct policy matches (exceptions and block policies after hthresh change in ns3)
PASS: policy matches (exceptions and block policies after hthresh change in ns3)
FAIL: expected ping to .254 to fail (exceptions and block policies after htresh change to normal)
PASS: direct policy matches (exceptions and block policies after htresh change to normal)
PASS: policy matches (exceptions and block policies after htresh change to normal)
PASS: policies with repeated htresh change
$ echo $?
0

This is because the $lret in check_xfrm() is not a local variable.
Therefore when a test failed in check_exceptions(), the non-zero $lret
will later get reset to 0 when the next test calls check_xfrm().

With this fix, the final return value will be 1. Make it easier for
testers to spot this failure.

Fixes: 39aa6928d462d0 ("xfrm: policy: fix netlink/pf_key policy lookups")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/xfrm_policy.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/xfrm_policy.sh b/tools/testing/selftests/net/xfrm_policy.sh
index 7a1bf94..5922941 100755
--- a/tools/testing/selftests/net/xfrm_policy.sh
+++ b/tools/testing/selftests/net/xfrm_policy.sh
@@ -202,7 +202,7 @@ check_xfrm() {
 	# 1: iptables -m policy rule count != 0
 	rval=$1
 	ip=$2
-	lret=0
+	local lret=0
 
 	ip netns exec ns1 ping -q -c 1 10.0.2.$ip > /dev/null
 
-- 
2.7.4

