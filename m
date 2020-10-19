Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB764292161
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 05:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgJSDJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 23:09:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49518 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731363AbgJSDJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 23:09:47 -0400
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kULYQ-0006Zs-5M
        for netdev@vger.kernel.org; Mon, 19 Oct 2020 03:09:46 +0000
Received: by mail-pf1-f198.google.com with SMTP id m11so1643078pff.12
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 20:09:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Pj6q4HWe0k0tbwlWbAngPQFUEd/hNK+pTPGNhrSqmPM=;
        b=uAhy7o4mJpq7p5z1RXnDtgM2aoI3IoMQpk4d0dZgfXSclrvajpli+Jf54xVrmaapQl
         vMIZBrqWzEvdo8UxfeLSkd3LLUZ9aJPMOdSkHNmcCgzQJqit3xH2zAHcIunjRGqo2365
         hokqZM8j7qfwg1e7p56y8Nc+VceotDhA0WlXelX3BO6vdcB6zsxEe/37uLr3EcPxpfbO
         Fef1TfzLh7Ynn02scBJLGBdDvfQwr//NfpCvBcWw1ryVO+XISN+dzBzMUK1nqLbyUCr2
         CDoCRiwE53vrsMBPlo/WbT+osMOtrVRa6sQQSmydmvGlyQmYW9uKZ+FeW+74qNs46yqp
         9xBw==
X-Gm-Message-State: AOAM532Fcli6w2AF6CfV5K4j/p/RoV5/xwZ6BxIez0e3nq/Xl5InGPip
        n1b8X1LP7fj3VjD4DqHXMtNw6sA8Q616RhT9dW1m0mpZCGxx8wecg15yI3apQQnxLIgNP9Ct4g9
        vwI420zPXVeX4IJ/g7OuM1JFb8XmtC/3e
X-Received: by 2002:a63:5312:: with SMTP id h18mr10677181pgb.75.1603076984603;
        Sun, 18 Oct 2020 20:09:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPgV6YGPl+Wc2EzbriXge5wY1hmqcBKLT/ClI2pcRqnTp7Ot3LJF/d+2PMLKeEU01MWAxnOw==
X-Received: by 2002:a63:5312:: with SMTP id h18mr10677163pgb.75.1603076984221;
        Sun, 18 Oct 2020 20:09:44 -0700 (PDT)
Received: from Leggiero.taipei.internal (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id q8sm10077687pfg.118.2020.10.18.20.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 20:09:43 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     kuba@kernel.org, davem@davemloft.net, skhan@linuxfoundation.org
Cc:     po-hsu.lin@canonical.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCHv5] selftests: rtnetlink: load fou module for kci_test_encap_fou() test
Date:   Mon, 19 Oct 2020 11:09:28 +0800
Message-Id: <20201019030928.9859-1-po-hsu.lin@canonical.com>
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
index 4364924..4d5df8e 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -33,3 +33,4 @@ CONFIG_KALLSYMS=y
 CONFIG_TRACEPOINTS=y
 CONFIG_NET_DROP_MONITOR=m
 CONFIG_NETDEVSIM=m
+CONFIG_NET_FOU=m
diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 8a2fe6d..c9ce3df 100755
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

