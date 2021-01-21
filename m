Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545862FE9D9
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbhAUMU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:20:29 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:54640 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730855AbhAUMQu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 07:16:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 095C42049A;
        Thu, 21 Jan 2021 13:16:04 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Qe0rztY3DOcE; Thu, 21 Jan 2021 13:16:03 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E0CEC204B4;
        Thu, 21 Jan 2021 13:16:02 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 21 Jan 2021 13:16:02 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 21 Jan
 2021 13:16:02 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id B44CC3180757;
 Thu, 21 Jan 2021 13:16:01 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/5] selftests: xfrm: fix test return value override issue in xfrm_policy.sh
Date:   Thu, 21 Jan 2021 13:15:57 +0100
Message-ID: <20210121121558.621339-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121121558.621339-1-steffen.klassert@secunet.com>
References: <20210121121558.621339-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

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
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 tools/testing/selftests/net/xfrm_policy.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/xfrm_policy.sh b/tools/testing/selftests/net/xfrm_policy.sh
index 7a1bf94c5bd3..5922941e70c6 100755
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
2.25.1

