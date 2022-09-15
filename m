Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BCD5B97AB
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 11:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiIOJmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 05:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiIOJmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 05:42:16 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3CF6CF4E
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 02:42:14 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id iw17so17837340plb.0
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 02:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=lW13UkQP9cVsvxeXKaV/SWI78ZW+g6LMlqH+WhaVN6s=;
        b=jCrW57x0fQ52fucKZiWwdqahbHCoVJHsBNINXVb3Y13Syy4u/W+vcCvKGKOaGjWLl4
         DH9xw0rbGz4H5YOkbMvf3CntsCLNEUYbCScK278aYZNlohpc0LJG/fMsJ5Mb/WIynlUb
         bGageVgYyD3dMBWHXWUEUHNtOGzbe2k4Utt/3tSYJnaYjavPkNPVqjLYno7v/66ssbDR
         JIQrLTRtv0m2wk112fj7X65RAWISz6CNVSRK/Y2rTM0eBRUvbh12+yqhEVASsdgZu8nK
         zcjxZ58s/cQnMZiUST82aXxA/oI6MKCSb4EbnFI/lLXm1KQ/Sb39O71njfrPGF6c5MND
         JN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=lW13UkQP9cVsvxeXKaV/SWI78ZW+g6LMlqH+WhaVN6s=;
        b=BhpIUK3L0+GQLeHARMAzR/Htmxu5D7fdcDryr7E+TgxBuSY5sQZ0HEQEB5ZkLoIV3+
         8JWBes6YB2gQyJg9ycwKVwpnihspCk8y8LhaVzvG3qwYlmzG904RJ/BLUHr/DtZ0jePw
         GbQsXrgeGNlk6s/aX/sIBG+A8svvE1IJIHI4dJMz0hINMsgYuGa2rwOdNmBydQiaszCs
         4sjRZNUZzKUGoLRMmxhiBiToffujvoMFThQID2l8Zl9LMY3wb+Ml+IbE4uT6DNh70QCG
         MdssZzGnnrDCWWAoQH61GcsZYL2rNjB9ILsdfSMx8w6ycwE4J1YgPGnbLuABxsiLF5eY
         UXDQ==
X-Gm-Message-State: ACrzQf2b1H84Kd+v8nHLhwTEDbS1oiZMpYYdeIsvC5ztf9XqOOJtWigK
        +r/xf8INN6WTgtNiVNrA5KQpRwUkXc36qQ==
X-Google-Smtp-Source: AMsMyM6NcSHl+CoqAZghxSGp2NkRVNyQjX4ESq3ft4dR262a2e9+6BLGtJnFnVwa5CqanyOvLff10Q==
X-Received: by 2002:a17:902:ea11:b0:178:f0a:7472 with SMTP id s17-20020a170902ea1100b001780f0a7472mr3432089plg.46.1663234933697;
        Thu, 15 Sep 2022 02:42:13 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090311c600b00177ef3246absm12684217plh.103.2022.09.15.02.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 02:42:11 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests/bonding: add a test for bonding lladdr target
Date:   Thu, 15 Sep 2022 17:42:02 +0800
Message-Id: <20220915094202.335636-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a regression test for commit 592335a4164c ("bonding: accept
unsolicited NA message") and commit b7f14132bf58 ("bonding: use unspecified
address if no available link local address"). When the bond interface
up and no available link local address, unspecified address(::) is used to
send the NS message. The unsolicited NA message should also be accepted
for validation.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/drivers/net/bonding/Makefile    |  1 +
 .../drivers/net/bonding/bond-lladdr-target.sh | 65 +++++++++++++++++++
 2 files changed, 66 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-lladdr-target.sh

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index ab6c54b12098..d209f7a98b6c 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -2,5 +2,6 @@
 # Makefile for net selftests
 
 TEST_PROGS := bond-break-lacpdu-tx.sh
+TEST_PROGS += bond-lladdr-target.sh
 
 include ../../../lib.mk
diff --git a/tools/testing/selftests/drivers/net/bonding/bond-lladdr-target.sh b/tools/testing/selftests/drivers/net/bonding/bond-lladdr-target.sh
new file mode 100755
index 000000000000..89af402fabbe
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/bond-lladdr-target.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Regression Test:
+#   Verify bond interface could up when set IPv6 link local address target.
+#
+#  +----------------+
+#  |      br0       |
+#  |       |        |    sw
+#  | veth0   veth1  |
+#  +---+-------+----+
+#      |       |
+#  +---+-------+----+
+#  | veth0   veth1  |
+#  |       |        |    host
+#  |     bond0      |
+#  +----------------+
+#
+# We use veths instead of physical interfaces
+sw="sw-$(mktemp -u XXXXXX)"
+host="ns-$(mktemp -u XXXXXX)"
+
+cleanup()
+{
+	ip netns del $sw
+	ip netns del $host
+}
+
+trap cleanup 0 1 2
+
+ip netns add $sw
+ip netns add $host
+
+ip -n $host link add veth0 type veth peer name veth0 netns $sw
+ip -n $host link add veth1 type veth peer name veth1 netns $sw
+
+ip -n $sw link add br0 type bridge
+ip -n $sw link set br0 up
+sw_lladdr=$(ip -n $sw addr show br0 | awk '/fe80/{print $2}' | cut -d'/' -f1)
+# sleep some time to make sure bridge lladdr pass DAD
+sleep 2
+
+ip -n $host link add bond0 type bond mode 1 ns_ip6_target ${sw_lladdr} \
+	arp_validate 3 arp_interval 1000
+# add a lladdr for bond to make sure there is a route to target
+ip -n $host addr add fe80::beef/64 dev bond0
+ip -n $host link set bond0 up
+ip -n $host link set veth0 master bond0
+ip -n $host link set veth1 master bond0
+
+ip -n $sw link set veth0 master br0
+ip -n $sw link set veth1 master br0
+ip -n $sw link set veth0 up
+ip -n $sw link set veth1 up
+
+sleep 5
+
+rc=0
+if ip -n $host link show bond0 | grep -q LOWER_UP; then
+	echo "PASS"
+else
+	echo "FAIL"
+	rc=1
+fi
+exit $rc
-- 
2.37.2

