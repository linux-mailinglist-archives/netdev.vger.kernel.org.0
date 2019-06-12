Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683C141C85
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 08:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbfFLGsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 02:48:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39924 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbfFLGsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 02:48:04 -0400
Received: from mail-pf1-f197.google.com ([209.85.210.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1hax3C-0000VQ-0C
        for netdev@vger.kernel.org; Wed, 12 Jun 2019 06:48:02 +0000
Received: by mail-pf1-f197.google.com with SMTP id c17so11351125pfb.21
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 23:48:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iQGtsCBn1c5Cv/4lGqwB4bSu8wIK/ZdJUuePfHlu3Os=;
        b=SbRYP/IGjNcDq56GLxNAyhtupCUIc95O/ImkxvS3Fg0cGOf4w1jzJAEk04/1SDcBXc
         A+u7shpNQol8Ha6OUqYb9DNkKwZOrhEtUP0XuNLiAt1XDc+1smbfgGh334ngANi4vyIF
         jJw5jqvx4E44UN8Y3rJYpyFp5x2JDkMZTce0VGcVcVr5do8oT3Te5BBirPUjeqR22Fqt
         l3BTVOEmh2htv7Mp9RLx5su73EeMeOQDYNG10RpGHh1XurB69qEwcbZ8QJqXQoaZT8Oo
         5GIj7TKiRnbK5VbwgAm0y9IDAQ4zVyFN7oTkGEnucKAjhFPOX+gOyyueFMfPJ9hpnkq0
         khnQ==
X-Gm-Message-State: APjAAAXQaIyJPq4GgmxyadpuuRtuiYUcMJpJRAIaDVVc6x36e0dkuCYJ
        VidG7tzWft/Ct3tBOeIZoQhSnYyGvKISVll6JJGKd12opc/v+SVFbee3e5qblGb6tlD3ftNN7ex
        gIW2TArUz8kj5/FpHKJJAkycSoNaN8oZx
X-Received: by 2002:a17:902:2926:: with SMTP id g35mr34534391plb.269.1560322080596;
        Tue, 11 Jun 2019 23:48:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqydXTegqwqULkVpf/E0LtN7OvqKB1CDRD/xCDPTfnA0oYlo/soUUvOX7voWPt0GmlHRFF0Cpg==
X-Received: by 2002:a17:902:2926:: with SMTP id g35mr34534368plb.269.1560322080271;
        Tue, 11 Jun 2019 23:48:00 -0700 (PDT)
Received: from Leggiero.taipei.internal (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id p68sm9888878pfb.80.2019.06.11.23.47.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 23:47:59 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     davem@davemloft.net, shuah@kernel.org
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/net: skip psock_tpacket test if KALLSYMS was not enabled
Date:   Wed, 12 Jun 2019 14:47:52 +0800
Message-Id: <20190612064752.6701-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The psock_tpacket test will need to access /proc/kallsyms, this would
require the kernel config CONFIG_KALLSYMS to be enabled first.

Check the file existence to determine if we can run this test.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/run_afpackettests | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/run_afpackettests b/tools/testing/selftests/net/run_afpackettests
index ea5938e..8b42e8b 100755
--- a/tools/testing/selftests/net/run_afpackettests
+++ b/tools/testing/selftests/net/run_afpackettests
@@ -21,12 +21,16 @@ fi
 echo "--------------------"
 echo "running psock_tpacket test"
 echo "--------------------"
-./in_netns.sh ./psock_tpacket
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	ret=1
+if [ -f /proc/kallsyms ]; then
+	./in_netns.sh ./psock_tpacket
+	if [ $? -ne 0 ]; then
+		echo "[FAIL]"
+		ret=1
+	else
+		echo "[PASS]"
+	fi
 else
-	echo "[PASS]"
+	echo "[SKIP] CONFIG_KALLSYMS not enabled"
 fi
 
 echo "--------------------"
-- 
2.7.4

