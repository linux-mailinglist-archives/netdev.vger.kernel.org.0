Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915933690F0
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 13:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242241AbhDWLQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 07:16:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43718 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242050AbhDWLQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 07:16:30 -0400
Received: from mail-pj1-f72.google.com ([209.85.216.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1lZtmr-0000N0-BG
        for netdev@vger.kernel.org; Fri, 23 Apr 2021 11:15:53 +0000
Received: by mail-pj1-f72.google.com with SMTP id t22-20020a17090a4496b029014cf3d7ff6eso3164284pjg.1
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 04:15:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bSnrI9pLqbkLYsZ1fjcEqsSyBUockPgKVVHwwmrSw5Y=;
        b=pc1CN1wuBtAVhBTtXx7sw6rrFiNAbPa/pbNstjf8t4+lAuPwNg1up61XnEKeCvbzM9
         c6qI9B1SZLNGZhav7yHDTjzpywvDND4D3RC4CSSynUQMjjqdORjlCIbfoNlt6YUw5xAC
         f3mGFgIPxVZ8zrp6SRpbBMHFT92u0BtSmQlVBdaQGe/Vy/q0ZxjZ0We2jFQk1muFBDI0
         BRKoLeenT2tQWLIh//QjZX9kELVPldFG8ki6iJCs6w1W3ViUlRQTqzDdNFE6Pj2cix1/
         R49Fxn9ncQSYtBzky4MfqhMn+qQlBP0+KPimhMUItAZ+FvwdRXF4dRSCar+/X/8eogrp
         +ozg==
X-Gm-Message-State: AOAM5324aoFV6m65YPlmOKcNsh9ofajigBse9aDS1KyvwQjURjUxkxLI
        j6q+vq+k4V3KsfydqJvp6iwH9QZDbEEVNOgoFe6m7Yvv2dFe8m7v9gHF7oZZHyBFMFSukVWRX3k
        ermbCV+NR5l5e3P+MtMrUG2d74B7lfhAL
X-Received: by 2002:a17:902:bb95:b029:ec:8ad4:d62c with SMTP id m21-20020a170902bb95b02900ec8ad4d62cmr3554101pls.19.1619176551755;
        Fri, 23 Apr 2021 04:15:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzH8VIHkl3araIMp1Mu6LTIx3ouUWdz8gp9ETzkSXTwaEPzx+B+Sa5hINQ712Xtrcqz8tmkHA==
X-Received: by 2002:a17:902:bb95:b029:ec:8ad4:d62c with SMTP id m21-20020a170902bb95b02900ec8ad4d62cmr3554065pls.19.1619176551302;
        Fri, 23 Apr 2021 04:15:51 -0700 (PDT)
Received: from localhost.localdomain (61-220-137-38.HINET-IP.hinet.net. [61.220.137.38])
        by smtp.gmail.com with ESMTPSA id z17sm4227370pfe.181.2021.04.23.04.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 04:15:50 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        skhan@linuxfoundation.org
Subject: [PATCH] selftests/net: bump timeout to 5 minutes
Date:   Fri, 23 Apr 2021 19:15:38 +0800
Message-Id: <20210423111538.83084-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found that with the latest mainline kernel (5.12.0-051200rc8) on
some KVM instances / bare-metal systems, the following tests will take
longer than the kselftest framework default timeout (45 seconds) to
run and thus got terminated with TIMEOUT error:
* xfrm_policy.sh - took about 2m20s
* pmtu.sh - took about 3m5s
* udpgso_bench.sh - took about 60s

Bump the timeout setting to 5 minutes to allow them have a chance to
finish.

https://bugs.launchpad.net/bugs/1856010
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/Makefile | 2 ++
 tools/testing/selftests/net/settings | 1 +
 2 files changed, 3 insertions(+)
 create mode 100644 tools/testing/selftests/net/settings

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 25f198b..2be4670 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -37,6 +37,8 @@ TEST_GEN_FILES += ipsec
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
 
+TEST_FILES := settings
+
 KSFT_KHDR_INSTALL := 1
 include ../lib.mk
 
diff --git a/tools/testing/selftests/net/settings b/tools/testing/selftests/net/settings
new file mode 100644
index 0000000..694d707
--- /dev/null
+++ b/tools/testing/selftests/net/settings
@@ -0,0 +1 @@
+timeout=300
-- 
2.7.4

