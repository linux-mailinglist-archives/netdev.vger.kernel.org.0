Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06412ACAD5
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 03:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbgKJCBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 21:01:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42892 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730205AbgKJCBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 21:01:20 -0500
Received: from mail-pg1-f198.google.com ([209.85.215.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kcIyD-0001tP-Qm
        for netdev@vger.kernel.org; Tue, 10 Nov 2020 02:01:17 +0000
Received: by mail-pg1-f198.google.com with SMTP id i67so7553795pgc.3
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 18:01:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Kx4/PLABbjYnKNkiHtBsxcWT2xciwp1tmLJYXsoWZU=;
        b=IxlqMJ+reESKAFwHqRvTArQczYkAeZuGCoQSqruV/jvTq5VnXK/5S+CGxU887f89FA
         n6YHSDAxSHrFGye+EGuEjSr95+9YS3INXLcure0FbCvCUVrMyZzoMShME9fQ6z806Lmn
         IefGVSbHpCiM2x6klmzAid+Dbfg9uRTTz6J3hzzjysS2gTyDrm9059gjjlxGnz5CB+GK
         auqpUAODvcOf8ZaHVwor3HF5FenVQDKgmsxKe+CEkuhUCyQXhrie1s9aNWid66bjbPvk
         yXubvDKUkbhd7dNB0GHwzWVroRR5oTHCg+gvk9EDewESKzHgYPipC2/+4HSyF+4N7qG+
         xdtg==
X-Gm-Message-State: AOAM531Qve8UsoLyzwapZi/VV6v93ZPO8pu8v/iaZksDDqKDD/TxhUGB
        wJ20auL8QkY4pqv3vndza8Lc/PA10mdIHkCVXQXYzNuB6o5BtL9bZ7pPvQqQN25Oar4xAsR32Q+
        LsgWL7ulMVs+Qgy2l1NIEDyo0xh/OnbCx
X-Received: by 2002:a63:6647:: with SMTP id a68mr14774504pgc.7.1604973676039;
        Mon, 09 Nov 2020 18:01:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy0B3U5VvdSOcU/vErmbB0v844zQxLGn9Arj0dwJAMg7XIjfxQj5kQ++rMnRkGehRdOtJL9Jg==
X-Received: by 2002:a63:6647:: with SMTP id a68mr14774484pgc.7.1604973675818;
        Mon, 09 Nov 2020 18:01:15 -0800 (PST)
Received: from localhost.localdomain (223-136-189-104.emome-ip.hinet.net. [223.136.189.104])
        by smtp.gmail.com with ESMTPSA id c193sm11855552pfb.78.2020.11.09.18.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 18:01:15 -0800 (PST)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org
Cc:     davem@davemloft.net, skhan@linuxfoundation.org,
        po-hsu.lin@canonical.com
Subject: [PATCHv2 2/2] selftests: pmtu.sh: improve the test result processing
Date:   Tue, 10 Nov 2020 10:00:49 +0800
Message-Id: <20201110020049.6705-3-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201110020049.6705-1-po-hsu.lin@canonical.com>
References: <20201110020049.6705-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test will treat all non-zero return codes as failures, it will
make the pmtu.sh test script being marked as FAILED when some
sub-test got skipped.

Improve the result processing by
  * Only mark the whole test script as SKIP when all of the
    sub-tests were skipped
  * If the sub-tests were either passed or skipped, the overall
    result will be PASS
  * If any of them has failed with return code 1 or anything bad
    happened (e.g. return code 127 for command not found), the
    overall result will be FAIL

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/pmtu.sh | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index fb53987..464e31e 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1652,7 +1652,19 @@ run_test() {
 	return $ret
 	)
 	ret=$?
-	[ $ret -ne 0 ] && exitcode=1
+	case $ret in
+		0)
+			all_skipped=false
+			[ $exitcode=$ksft_skip ] && exitcode=0
+		;;
+		$ksft_skip)
+			[ $all_skipped = true ] && exitcode=$ksft_skip
+		;;
+		*)
+			all_skipped=false
+			exitcode=1
+		;;
+	esac
 
 	return $ret
 }
@@ -1786,6 +1798,7 @@ usage() {
 #
 exitcode=0
 desc=0
+all_skipped=true
 
 while getopts :ptv o
 do
-- 
2.7.4

