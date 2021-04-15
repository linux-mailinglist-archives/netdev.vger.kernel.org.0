Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47F4360321
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhDOHTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:19:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35483 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbhDOHTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:19:02 -0400
Received: from mail-pj1-f72.google.com ([209.85.216.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1lWwGs-00037C-OD
        for netdev@vger.kernel.org; Thu, 15 Apr 2021 07:18:38 +0000
Received: by mail-pj1-f72.google.com with SMTP id t16-20020a17090a0d10b029014e4569c8b6so7796469pja.4
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 00:18:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5R2UEdalYH+QJwAiSQKftUG6+6vnMGSX5LzgwS8fZTU=;
        b=VFGxxl2nxxhpWPi3E2JFMwSF5q2mRseaMrRq4bt/CpFsDP4Isv4hRnlZr/e+/CuLP+
         xf1jtiT1WrqtDFnJpqSskno5juEstIKV39dKujEsLkewrjnn5sMliVZnY1u+HiYNEr+q
         aaupPiNOsMVNThWuZbsuRFsljJhcULdnVuL8pYkKJ/kRQaYUWgD5L6FRTieIwJiyh7oK
         I16qEKC0ZK2+8pkUTNVLAdSkmJHk+qTmQTIYTIxmi0PfSg3L19q+RqKsTNLo7Wbnah36
         Pa3LC23cCc7jVBKH6ITdkuHhxZYBk6tg/Pyakzece8EEm4jQ8wzZ+CbJxUX25Zh6XwoL
         12rg==
X-Gm-Message-State: AOAM533+z64sbe0a8Kmugn4xx6x8Zd3HOPBFiFkqtTySFjLL+QmlcTXS
        mYp/BZDjueb+5kO1iT/GORFzN4VqdNEPQvTCbu9R71oOs9F11LwlSlhAb4fXj4hGpSgMcpzB0Xu
        208BsOVqGly/dOlKninlNzpLRD1ucY3zH
X-Received: by 2002:a62:5cc3:0:b029:203:54be:e4c9 with SMTP id q186-20020a625cc30000b029020354bee4c9mr1955789pfb.80.1618471117356;
        Thu, 15 Apr 2021 00:18:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzulbQcEb+SL0c0oEOvqz6I23syA3ZKRAT/SnGjUswHi0aNKxnJZy3J42T0G5Q7Z+0TGkGXEA==
X-Received: by 2002:a62:5cc3:0:b029:203:54be:e4c9 with SMTP id q186-20020a625cc30000b029020354bee4c9mr1955745pfb.80.1618471116517;
        Thu, 15 Apr 2021 00:18:36 -0700 (PDT)
Received: from Leggiero.taipei.internal (114-136-27-149.emome-ip.hinet.net. [114.136.27.149])
        by smtp.gmail.com with ESMTPSA id h7sm1283475pfo.44.2021.04.15.00.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 00:18:35 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     shuah@kernel.org, davem@davemloft.net
Subject: [PATCH] selftests: xfrm: put cleanup code into a exit trap
Date:   Thu, 15 Apr 2021 15:18:23 +0800
Message-Id: <20210415071823.29091-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the xfrm_policy.sh script takes longer than the default kselftest
framework 45 seconds timeout to run, it will be terminated and thus
leave those netns namespace files created by the test alone.

In this case a second attempt will fail with:
  # Cannot create namespace file "/run/netns/ns1": File exists

It might affect the outcome of other tests as well.

Move the netns cleanup code into an exit trap so that we can ensure
these namespace files will be removed after the test.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/xfrm_policy.sh | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/xfrm_policy.sh b/tools/testing/selftests/net/xfrm_policy.sh
index bdf450e..bb4632b 100755
--- a/tools/testing/selftests/net/xfrm_policy.sh
+++ b/tools/testing/selftests/net/xfrm_policy.sh
@@ -28,6 +28,11 @@ KEY_AES=0x0123456789abcdef0123456789012345
 SPI1=0x1
 SPI2=0x2
 
+cleanup() {
+    for i in 1 2 3 4;do ip netns del ns$i 2>/dev/null ;done
+}
+trap cleanup EXIT
+
 do_esp_policy() {
     local ns=$1
     local me=$2
@@ -481,6 +486,4 @@ check_hthresh_repeat "policies with repeated htresh change"
 
 check_random_order ns3 "policies inserted in random order"
 
-for i in 1 2 3 4;do ip netns del ns$i;done
-
 exit $ret
-- 
2.7.4

