Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6666343C0D5
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 05:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239108AbhJ0Dij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 23:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239073AbhJ0Dii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 23:38:38 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E58DC061570;
        Tue, 26 Oct 2021 20:36:14 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id om14so1008045pjb.5;
        Tue, 26 Oct 2021 20:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TcHSiB70tzVI/cskKWEiX2naPXPWA9ThGSeF8esH5bY=;
        b=hLvRz/fx6p4ElNoMwRY2by5CQYrp5DeDI0l25NYP4Jd1J65bPcaYipn/P9Hbeuy7JL
         w9juhCdcaJW5Bczyxqj6mBF8X1po+6IZuoFyA1kxO9XjM56sXlD9Q08foCO38r833iXI
         aDlSeHDcVEDB71BFg6qg4Wcj7BkNWnljpWp1iVF9qJpiFPahVFdBtp6Dbaq8BS1kk/yL
         MKzQSt7o5aWD6ZeABZZ7DjqgQsH0rif44kN3FiXQmj7Pd2pM3K6NvHsXFJpFlaqbXbt6
         wxmE6SclmYyx+rXTySmaQ1k6stAspqaYfuPHEbYuFJHKS2UtuPLKjggRE5Xapas8f3HZ
         Odxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TcHSiB70tzVI/cskKWEiX2naPXPWA9ThGSeF8esH5bY=;
        b=62qvkoCVk0V/ws6o1YN5+G8gGBLCkLbnXX1Oiv+Hiaa8ciddh4L2EtLFx1hV6GPSTR
         GvUb+w8AlDanvKNry2TrkY4Nbcwji8rg0/GIwjWbjK2IK16Ryn61nKcjHlE24LIff6zN
         4RcQwRqM588SVrCdSPhPSs+DXiYdH9+vRn89oCZvVafwpT/B06IAfyjaOsBVWWJbLZ7l
         JMEMtHxJmfRc63vraeQzNAkhm6Xt8wCXtit1zjsOfyM3BNZJZtsdmtEuB+mbCK5Be5fc
         qZJkSXkV3651w7dUfAr6rSHNPrpElybevJc7HBnxvQ7pAcTMAPyZPKlL1pQZt6hg93F5
         u+Yw==
X-Gm-Message-State: AOAM530VMEhLoFO68rF0rdkpWp1Fu0bmDsxQV8kUxa48AxGBnwVRWSW9
        qh3W2taoeykZkSbWpUzEEMBIptyrrYE=
X-Google-Smtp-Source: ABdhPJzJtnguW9PnDo8oGpETGUs9WSb/SgCq+IlqKmjRU5fwm1nQjd8+YAwKWx033Yl+OHQFuOyXHg==
X-Received: by 2002:a17:90b:1d0a:: with SMTP id on10mr3108589pjb.218.1635305773579;
        Tue, 26 Oct 2021 20:36:13 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p1sm12080847pfo.143.2021.10.26.20.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 20:36:13 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        linux-kselftest@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf 2/4] selftests/bpf/xdp_redirect_multi: use arping to accurate the arp number
Date:   Wed, 27 Oct 2021 11:35:51 +0800
Message-Id: <20211027033553.962413-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027033553.962413-1-liuhangbin@gmail.com>
References: <20211027033553.962413-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The arp request number triggered by ping none exist address is not
accurate, which may lead the test false negative/positive. Change to
use arping to accurate the arp number.

Also do not use grep pattern match for dot.

Suggested-by: Jiri Benc <jbenc@redhat.com>
Fixes: d23292476297 ("selftests/bpf: Add xdp_redirect_multi test")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
index b20b96ba72ef..c2a933caa32d 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
@@ -127,7 +127,7 @@ do_ping_tests()
 	ip netns exec ns3 tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-3_${mode}.log &
 	sleep 0.5
 	# ARP test
-	ip netns exec ns1 ping 192.0.2.254 -i 0.1 -c 4 &> /dev/null
+	ip netns exec ns1 arping -q -c 2 -I veth0 192.0.2.254
 	# IPv4 test
 	ip netns exec ns1 ping 192.0.2.253 -i 0.1 -c 4 &> /dev/null
 	# IPv6 test
@@ -136,13 +136,13 @@ do_ping_tests()
 	pkill -9 tcpdump
 
 	# All netns should receive the redirect arp requests
-	[ $(grep -c "who-has 192.0.2.254" ${LOG_DIR}/ns1-1_${mode}.log) -gt 4 ] && \
+	[ $(grep -cF "who-has 192.0.2.254" ${LOG_DIR}/ns1-1_${mode}.log) -eq 4 ] && \
 		test_pass "$mode arp(F_BROADCAST) ns1-1" || \
 		test_fail "$mode arp(F_BROADCAST) ns1-1"
-	[ $(grep -c "who-has 192.0.2.254" ${LOG_DIR}/ns1-2_${mode}.log) -le 4 ] && \
+	[ $(grep -cF "who-has 192.0.2.254" ${LOG_DIR}/ns1-2_${mode}.log) -eq 2 ] && \
 		test_pass "$mode arp(F_BROADCAST) ns1-2" || \
 		test_fail "$mode arp(F_BROADCAST) ns1-2"
-	[ $(grep -c "who-has 192.0.2.254" ${LOG_DIR}/ns1-3_${mode}.log) -le 4 ] && \
+	[ $(grep -cF "who-has 192.0.2.254" ${LOG_DIR}/ns1-3_${mode}.log) -eq 2 ] && \
 		test_pass "$mode arp(F_BROADCAST) ns1-3" || \
 		test_fail "$mode arp(F_BROADCAST) ns1-3"
 
-- 
2.31.1

