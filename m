Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22241B3A50
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 14:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732509AbfIPM1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 08:27:04 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45259 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732452AbfIPM1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 08:27:04 -0400
Received: by mail-qk1-f196.google.com with SMTP id z67so36011403qkb.12
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 05:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2HxW+wVKO86+KUc5PYwM54DxVNGsW87ney6IUuy8Vkc=;
        b=UFDRLGBofwXhAXjbyk9Inj4PDPmYqgMWUffL9OdoVaLhaLZhDXQudl0oevipsA1z4q
         m/hYEq6heNLFCkoqupOHophWzOzlCsJGK4wuKUQD76sPavYGeUGZGgnS/txQAmCi0Db8
         pLRLZ66r3DSaJmA2EODRHv7ZmGHgRkyahZyB0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2HxW+wVKO86+KUc5PYwM54DxVNGsW87ney6IUuy8Vkc=;
        b=iIX+F8jTSGPcEjvIQV/TXsOzoL1IQxxYEmjtJ6H4C29p+90DkyrvxV0HxW/0/PIuXR
         +qtI1HoUa27ycpgI8D0oXH+DIVkPgpaYiWemXHZc1hrijGIdJI9TPvbcnKKep4TPgwrt
         EkXz0woGZ9ssIcfNwvAxdGE0vd1pUAG4FYBGJiHjbn+/LKtCdwp/EMUN1NtRRYhwhgBa
         DrXrGJS4NFKgqoM6MNzg/EcM/2VP5gLP271a82t7U3rlGiqdhdM5I2wSmah810VoF35q
         wdmLPnWmUGSKnC/AbWEO2yPCF5razAziA2BoxvIuoCkWzQ5oXEdp/Dgfzpga9E7jnMY3
         F9Jw==
X-Gm-Message-State: APjAAAVPUlZb8w1znKV4nlP4GWNs2T0k5KuaFTUS45K967FNJf/99k3T
        HhtS/Gu2/nHQvSvJ2xU8wn5hD/jLcNo=
X-Google-Smtp-Source: APXvYqztyzZpO52uHk6fO+YgA4+QG2CatRlNN5yD+pb0S6dW7Nh7I5SAJFwX/FF5WBz9MBcvKwEXqw==
X-Received: by 2002:a37:2c44:: with SMTP id s65mr45272820qkh.303.1568636822997;
        Mon, 16 Sep 2019 05:27:02 -0700 (PDT)
Received: from robot.nc.rr.com (cpe-2606-A000-111D-8179-B743-207D-F4F9-B992.dyn6.twc.com. [2606:a000:111d:8179:b743:207d:f4f9:b992])
        by smtp.googlemail.com with ESMTPSA id z8sm4935043qkf.37.2019.09.16.05.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 05:27:02 -0700 (PDT)
From:   Donald Sharp <sharpd@cumulusnetworks.com>
To:     netdev@vger.kernel.org, dsahern@kernel.org
Subject: [PATCH] selftests: Add test cases for `ip nexthop flush proto XX`
Date:   Mon, 16 Sep 2019 08:26:50 -0400
Message-Id: <20190916122650.24124-1-sharpd@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some test cases to allow the fib_nexthops.sh test code
to test the flushing of nexthops based upon the proto passed
in upon creation of the nexthop group.

Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index f9ebeac1e6f2..796670ebc65b 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -940,6 +940,20 @@ basic()
 	run_cmd "$IP nexthop add id 104 group 1 dev veth1"
 	log_test $? 2 "Nexthop group and device"
 
+	# Tests to ensure that flushing works as expected.
+	run_cmd "$IP nexthop add id 105 blackhole proto 99"
+	run_cmd "$IP nexthop add id 106 blackhole proto 100"
+	run_cmd "$IP nexthop add id 107 blackhole proto 99"
+	run_cmd "$IP nexthop flush proto 99"
+	check_nexthop "id 105" ""
+	check_nexthop "id 106" "id 106 blackhole proto 100"
+	check_nexthop "id 107" ""
+	run_cmd "$IP nexthop flush proto 100"
+	check_nexthop "id 106" ""
+
+	run_cmd "$IP nexthop flush proto 100"
+	log_test $? 0 "Test proto flush"
+
 	run_cmd "$IP nexthop add id 104 group 1 blackhole"
 	log_test $? 2 "Nexthop group and blackhole"
 
-- 
2.21.0

