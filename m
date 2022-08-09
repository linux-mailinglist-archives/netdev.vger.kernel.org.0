Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04EA358DD00
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 19:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245083AbiHIRWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 13:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245069AbiHIRWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 13:22:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1974423BDF
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 10:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660065718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HT/+CzBXLiMdVIbXZNthSz5gOXrGW4yWOVm0tFnrCm8=;
        b=ga7TpxhThqugM5dHAeWdFIMAWTsWOqXvK3ZdYHgHGxTOXaASQbmyuhHPkidCfNBx45NMJx
        zH/fLF/3aHzh7+t6Ap2AkGwohspTbBEiFDfLdSH69tpe8XSaiY78RNiHPOdqOiSCYeTblH
        1kNZuUN3tdXztaUyLd+3MSbNwVC35So=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-QW0qJO5mPV6vM7WxF4a8hQ-1; Tue, 09 Aug 2022 13:21:55 -0400
X-MC-Unique: QW0qJO5mPV6vM7WxF4a8hQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D9AF8037B3;
        Tue,  9 Aug 2022 17:21:55 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.10.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D80F62026D4C;
        Tue,  9 Aug 2022 17:21:54 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC net] bonding: 802.3ad: fix no transmission of LACPDUs
Date:   Tue,  9 Aug 2022 13:21:46 -0400
Message-Id: <c2f698e6f73e6e78232ab4ded065c3828d245dbd.1660065706.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running the script in
`tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh` puts
bonding into a state where it never transmits LACPDUs.

line 53: echo 65535 > /sys/class/net/fbond/bonding/ad_actor_sys_prio
setting bond param: ad_actor_sys_prio
given:
    params.ad_actor_system = 0
call stack:
    bond_option_ad_actor_sys_prio()
    -> bond_3ad_update_ad_actor_settings()
       -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
       -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
            params.ad_actor_system == 0
results:
     ad.system.sys_mac_addr = bond->dev->dev_addr

line 59: ip link set fbond address 52:54:00:3B:7C:A6
setting bond MAC addr
call stack:
    bond->dev->dev_addr = new_mac

line 63: echo 65535 > /sys/class/net/fbond/bonding/ad_actor_sys_prio
setting bond param: ad_actor_sys_prio
given:
    params.ad_actor_system = 0
call stack:
    bond_option_ad_actor_sys_prio()
    -> bond_3ad_update_ad_actor_settings()
       -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
       -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
            params.ad_actor_system == 0
results:
     ad.system.sys_mac_addr = bond->dev->dev_addr

line 71: ip link set veth1-bond down master fbond
given:
    params.ad_actor_system = 0
    params.mode = BOND_MODE_8023AD
    ad.system.sys_mac_addr == bond->dev->dev_addr
call stack:
    bond_enslave
    -> bond_3ad_initialize(); because first slave
       -> if ad.system.sys_mac_addr != bond->dev->dev_addr
          return
results:
     Nothing is run in bond_3ad_initialize() because dev_add equals
     sys_mac_addr leaving the global ad_ticks_per_sec zero as it is
     never initialized anywhere else.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---
 MAINTAINERS                                   |  1 +
 drivers/net/bonding/bond_3ad.c                |  2 +-
 .../net/bonding/bond-break-lacpdu-tx.sh       | 88 +++++++++++++++++++
 3 files changed, 90 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 386178699ae7..6e7cebc1bca3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3636,6 +3636,7 @@ F:	Documentation/networking/bonding.rst
 F:	drivers/net/bonding/
 F:	include/net/bond*
 F:	include/uapi/linux/if_bonding.h
+F:	tools/testing/selftests/net/bonding/
 
 BOSCH SENSORTEC BMA400 ACCELEROMETER IIO DRIVER
 M:	Dan Robertson <dan@dlrobertson.com>
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index d7fb33c078e8..e357bc6b8e05 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -84,7 +84,7 @@ enum ad_link_speed_type {
 static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned = {
 	0, 0, 0, 0, 0, 0
 };
-static u16 ad_ticks_per_sec;
+static u16 ad_ticks_per_sec = 1000/AD_TIMER_INTERVAL;
 static const int ad_delta_in_ticks = (AD_TIMER_INTERVAL * HZ) / 1000;
 
 static const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned =
diff --git a/tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh b/tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh
new file mode 100644
index 000000000000..be9f1b64e89e
--- /dev/null
+++ b/tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh
@@ -0,0 +1,88 @@
+#!/bin/sh
+
+# Regression Test:
+#   Verify LACPDUs get transmitted after setting the MAC address of
+#   the bond.
+#
+# https://bugzilla.redhat.com/show_bug.cgi?id=2020773
+#
+#       +---------+
+#       | fab-br0 |
+#       +---------+
+#            |
+#       +---------+
+#       |  fbond  |
+#       +---------+
+#        |       |
+#    +------+ +------+
+#    |veth1 | |veth2 |
+#    +------+ +------+
+#
+# We use veths instead of physical interfaces
+
+set -e
+#set -x
+tmp=$(mktemp -q dump.XXXXXX)
+cleanup() {
+	ip link del fab-br0 >/dev/null 2>&1 || :
+	ip link del fbond  >/dev/null 2>&1 || :
+	ip link del veth1-bond  >/dev/null 2>&1 || :
+	ip link del veth2-bond  >/dev/null 2>&1 || :
+	modprobe -r bonding  >/dev/null 2>&1 || :
+	rm -f -- ${tmp}
+}
+
+trap cleanup 0 1 2
+cleanup
+sleep 1
+
+# create the bridge
+ip link add fab-br0 address 52:54:00:3B:7C:A6 mtu 1500 type bridge \
+	forward_delay 15
+
+# create the bond
+ip link add fbond type bond
+ip link set fbond up
+
+# set bond sysfs parameters
+ip link set fbond down
+echo 802.3ad           > /sys/class/net/fbond/bonding/mode
+echo 200               > /sys/class/net/fbond/bonding/miimon
+echo 1                 > /sys/class/net/fbond/bonding/xmit_hash_policy
+echo 65535             > /sys/class/net/fbond/bonding/ad_actor_sys_prio
+echo stable            > /sys/class/net/fbond/bonding/ad_select
+echo slow              > /sys/class/net/fbond/bonding/lacp_rate
+echo any               > /sys/class/net/fbond/bonding/arp_all_targets
+
+# set bond address
+ip link set fbond address 52:54:00:3B:7C:A6
+ip link set fbond up
+
+# set again bond sysfs parameters
+echo 65535             > /sys/class/net/fbond/bonding/ad_actor_sys_prio
+
+# create veths
+ip link add name veth1-bond type veth peer name veth1-end
+ip link add name veth2-bond type veth peer name veth2-end
+
+# add ports
+ip link set fbond master fab-br0
+ip link set veth1-bond down master fbond
+ip link set veth2-bond down master fbond
+
+# bring up
+ip link set veth1-end up
+ip link set veth2-end up
+ip link set fab-br0 up
+ip link set fbond up
+ip addr add dev fab-br0 10.0.0.3
+
+tcpdump -n -i veth1-end -e ether proto 0x8809 >${tmp} 2>&1 &
+sleep 60
+pkill tcpdump >/dev/null 2>&1
+num=$(grep "packets captured" ${tmp} | awk '{print $1}')
+if test "$num" -gt 0; then
+	echo "PASS, captured ${num}"
+else
+	echo "FAIL"
+fi
-- 
2.31.1

