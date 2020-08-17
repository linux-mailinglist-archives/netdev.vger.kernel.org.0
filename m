Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365DD245AD3
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 04:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgHQCxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 22:53:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37492 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgHQCxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 22:53:36 -0400
Received: from mail-pl1-f198.google.com ([209.85.214.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1k7VHB-0008NT-Vu
        for netdev@vger.kernel.org; Mon, 17 Aug 2020 02:53:34 +0000
Received: by mail-pl1-f198.google.com with SMTP id f7so9073292plj.16
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 19:53:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3thZXTBTKrCmlLY4l7vI4Z+3HdNyGpWqEUhf/airL/4=;
        b=KuEPokzSUGC+SNCY1EOfplfed2E3QgsK5K2bUMrMgy+AwcIgcOTkaqaCzdFWgCGT2p
         0MgWmJ+ixXJtPAVzBiqd8KvMrHk89L/cdcaoSIXlxxbH1j5ghG41ANFyiuGdzgeVk6wB
         sPxSJJ8k5IKYQxWEQnxEvxp/pj0Y+dBvBFa3Uz8+MlLJeCmLaQlcK0+bGbOuJXlibp1y
         oZqxUjXJACuPmXFDLYzdnRNTHak9rGf+Gu7GAEc2ZhXxkE9zkvHBmovjtw/DmrqGfuTx
         I3sr0yCyvWdILPLGD67ndj7XuIPWY94aZ/eH2GHmcJeBZGS+X6L0x8j1zUKy/zqWYcOx
         Uiiw==
X-Gm-Message-State: AOAM5317tKpDWPnilVofzi1WBVC09LINx0W6Ftvp10H/GrWWMyVnmLus
        lLmJLrA9dWTp+Wacg9CtGwcfKpqvlvdTE9fWS4IxPQaqodF/TgEuC30Z2yy+p1fjwLbnwokgCI6
        OT6QR2MfxE57+KgbnxgKEJPO1A99G6UM5
X-Received: by 2002:a17:902:9a90:: with SMTP id w16mr9349555plp.181.1597632812246;
        Sun, 16 Aug 2020 19:53:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYSrXFxMVskI/6CjR5bWlyUSO/dR2wuoqndwsRqss2tPsixONO1ZHIaA3LLldYtnYjj5KQsw==
X-Received: by 2002:a17:902:9a90:: with SMTP id w16mr9349547plp.181.1597632811920;
        Sun, 16 Aug 2020 19:53:31 -0700 (PDT)
Received: from Leggiero.taipei.internal (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id ez7sm15094834pjb.10.2020.08.16.19.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2020 19:53:31 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     davem@davemloft.net, kuba@kernel.org, skhan@linuxfoundation.org
Cc:     po-hsu.lin@canonical.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCHv2] selftests: rtnetlink: load fou module for kci_test_encap_fou()
Date:   Mon, 17 Aug 2020 10:52:13 +0800
Message-Id: <20200813044422.46713-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.17.1
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
 tools/testing/selftests/net/rtnetlink.sh | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 3b42c06b..96d2763 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -31,3 +31,4 @@ CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_NETEM=y
 CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_KALLSYMS=y
+CONFIG_NET_FOU=m
diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index bdbf4b3..7931b65 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -521,6 +521,11 @@ kci_test_encap_fou()
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
@@ -541,6 +546,7 @@ kci_test_encap_fou()
 		return 1
 	fi
 
+	/sbin/modprobe -q -r fou
 	echo "PASS: fou"
 }
 
-- 
2.7.4

