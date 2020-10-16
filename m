Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3371D28FD19
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 06:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgJPEMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 00:12:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60286 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgJPEMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 00:12:24 -0400
Received: from mail-pl1-f200.google.com ([209.85.214.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kTH6M-0002nU-AX
        for netdev@vger.kernel.org; Fri, 16 Oct 2020 04:12:22 +0000
Received: by mail-pl1-f200.google.com with SMTP id e6so594943pld.12
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 21:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lj+knYxUtKPg4RXVIM/N60ZjQtEWBhu0c8E4sC/HXuk=;
        b=L3RSGvNH0lYORdax40HZ94Y6Mpwtag/tyGPAt+a4zWXepE9jd1n/fQbqQ9LDlCof11
         MqEH8kiVmk7Zmfzy4ktJgZRASAGedR2q6J6BhE+I0wzMEslMy0mkHZTJrcJkal1i23Gm
         TYpiiumIdq2XgxZFiyPtRHd3+Kr6insDxf9WTClGuF9x/j+C7pyKKqk92W+vWKwrW0Q/
         Rjn7oiJtYH6QZgpjqFltwwwpnyIFaIdZQUSmBHbty9YEEMN2lXVW2iBOPuZyYG27R8DI
         UIetjCXi4b45r1xM6tTFFJMY54LAQ1Pw6y5zvSvznFgITCsyquvdssI8HhnpACHFsLxg
         3YkA==
X-Gm-Message-State: AOAM532/K1lggqmjX0jOchPUBL9Ru4QOjXhXji1vdyKW7yIQ9S4j2LNw
        Oyi26sPBz4I7IbaSO5z4IuEtmEkWnTCJtNbZENW0GngIjBnVzZBKDWn/jHIDMbPCpuCZrEmuldl
        CHxDpGyCmDHDO8nrQ9zxpfukxwbSD2M0f
X-Received: by 2002:a17:90a:f504:: with SMTP id cs4mr1960313pjb.134.1602821540786;
        Thu, 15 Oct 2020 21:12:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwuiSKw3Fc623zX1J/CAP9plBsNCtvs5MGJMMDxfzVtSTbK7rn7o0Xn8rYN4eGs9/I/aF82TA==
X-Received: by 2002:a17:90a:f504:: with SMTP id cs4mr1960296pjb.134.1602821540489;
        Thu, 15 Oct 2020 21:12:20 -0700 (PDT)
Received: from Leggiero.taipei.internal (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id w12sm889596pfu.53.2020.10.15.21.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 21:12:19 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     kuba@kernel.org, davem@davemloft.net, skhan@linuxfoundation.org
Cc:     po-hsu.lin@canonical.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCHv4] selftests: rtnetlink: load fou module for kci_test_encap_fou() test
Date:   Fri, 16 Oct 2020 12:12:11 +0800
Message-Id: <20201016041211.18827-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kci_test_encap_fou() test from kci_test_encap() in rtnetlink.sh
needs the fou module to work. Otherwise it will fail with:

  $ ip netns exec "$testns" ip fou add port 7777 ipproto 47
  RTNETLINK answers: No such file or directory
  Error talking to the kernel

Add the CONFIG_NET_FOU into the config file as well. Which needs at
least to be set as a loadable module.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/config       | 1 +
 tools/testing/selftests/net/rtnetlink.sh | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 3b42c06b..c5e50ab 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -31,3 +31,4 @@ CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_NETEM=y
 CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_KALLSYMS=y
+CONFIG_NET_FOU=m
diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 7c38a90..6f8f159 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -520,6 +520,11 @@ kci_test_encap_fou()
 		return $ksft_skip
 	fi
 
+	if ! /sbin/modprobe -q -n fou; then
+		echo "SKIP: module fou is not found"
+		return $ksft_skip
+	fi
+	/sbin/modprobe -q fou
 	ip -netns "$testns" fou add port 7777 ipproto 47 2>/dev/null
 	if [ $? -ne 0 ];then
 		echo "FAIL: can't add fou port 7777, skipping test"
-- 
2.7.4

