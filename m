Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A080B5FC769
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 16:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiJLOco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 10:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiJLOcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 10:32:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC775CE9A5
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665585158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=59ODeYb/zj0xWpehY5IjWapAt6RkzLSO55I3d59wWk8=;
        b=PxIP9btN6aYa4XXZTVMZp9o6t9Qaeixao9FC3KfwwKLkGnJteze0WF03pNTc9AO7OlWfWp
        2qOLhDsCtd7PCfncxnkjLGsnb9M7a/pF6AvzEfyC2n1tx5dsrMgeGE1jE7s6cVWyrhOxd6
        2Xb1i7pNj+dmGemzYNwrKDfKuiJUkEY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-vMwQdboiM6uXOlQ93jUmFA-1; Wed, 12 Oct 2022 10:32:35 -0400
X-MC-Unique: vMwQdboiM6uXOlQ93jUmFA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A52AA811E81;
        Wed, 12 Oct 2022 14:32:34 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.34.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F82A492B05;
        Wed, 12 Oct 2022 14:32:34 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>, Liang Li <liali@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [net RFC] selftests: bonding: up/down delay w/ slave link flapping
Date:   Wed, 12 Oct 2022 10:32:29 -0400
Message-Id: <016a7258b6150e97ddca69d993f8223aa0761d14.1665585149.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify when a bond is configured with {up,down}delay and the link state
of slave members flaps if there are no remaining members up the bond
should immediately select a member to bring up. (from bonding.txt
section 13.1 paragraph 4)

Suggested-by: Liang Li <liali@redhat.com>
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---

Notes:
    Bug: Currently the bond never comes back up.

 .../selftests/drivers/net/bonding/Makefile    |  3 +-
 .../net/bonding/slave-link-flapping.sh        | 85 +++++++++++++++++++
 2 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/slave-link-flapping.sh

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index e9dab5f9d773..cb40ef91c152 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -5,7 +5,8 @@ TEST_PROGS := \
 	bond-arp-interval-causes-panic.sh \
 	bond-break-lacpdu-tx.sh \
 	bond-lladdr-target.sh \
-	dev_addr_lists.sh
+	dev_addr_lists.sh \
+	slave-link-flapping.sh
 
 TEST_FILES := lag_lib.sh
 
diff --git a/tools/testing/selftests/drivers/net/bonding/slave-link-flapping.sh b/tools/testing/selftests/drivers/net/bonding/slave-link-flapping.sh
new file mode 100755
index 000000000000..a1499933fd39
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/slave-link-flapping.sh
@@ -0,0 +1,85 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+# Regression Test:
+#  When the bond is configured with down/updelay and the link state of
+#  slave members flaps if there are no remaining members up the bond
+#  should immediately select a member to bring up. (from bonding.txt
+#  section 13.1 paragraph 4)
+#
+#  +-------------+       +-----------+
+#  | client      |       | switch    |
+#  |             |       |           |
+#  |    +--------| link1 |-----+     |
+#  |    |        +-------+     |     |
+#  |    |        |       |     |     |
+#  |    |        +-------+     |     |
+#  |    | bond   | link2 | Br0 |     |
+#  +-------------+       +-----------+
+#     172.20.2.1           172.20.2.2
+
+set -e
+
+BOND="bond0"
+LINK1="veth1"
+LINK2="veth2"
+CLIENTIP="172.20.2.1"
+SWITCHIP="172.20.2.2"
+NAMESPACES="switch client"
+
+cleanup()
+{
+	for n in ${NAMESPACES}; do
+		ip netns delete ${n} >/dev/null 2>&1 || true
+	done
+	modprobe -r bonding
+}
+
+setup_network()
+{
+	# create namespaces
+	for n in ${NAMESPACES}; do
+		ip netns add ${n}
+	done
+
+	# create veths
+	ip link add name ${LINK1}-bond type veth peer name ${LINK1}-end
+	ip link add name ${LINK2}-bond type veth peer name ${LINK2}-end
+
+	# create switch
+	ip netns exec switch ip link add br0 up type bridge
+	ip link set ${LINK1}-end netns switch up
+	ip link set ${LINK2}-end netns switch up
+	ip netns exec switch ip link set ${LINK1}-end master br0
+	ip netns exec switch ip link set ${LINK2}-end master br0
+	ip netns exec switch ip addr add ${SWITCHIP}/24 dev br0
+
+	# create client
+	ip link set ${LINK1}-bond netns client
+	ip link set ${LINK2}-bond netns client
+	ip netns exec client ip link add ${BOND} type bond \
+		mode 2 miimon 100 updelay 10000
+	ip netns exec client ip link set ${LINK1}-bond master ${BOND}
+	ip netns exec client ip link set ${LINK2}-bond master ${BOND}
+	ip netns exec client ip link set ${BOND} up
+	ip netns exec client ip addr add ${CLIENTIP}/24 dev ${BOND}
+}
+
+trap cleanup 0 1 2
+cleanup
+sleep 1
+
+dmesg --clear
+setup_network
+
+# verify connectivity
+ip netns exec client ping ${SWITCHIP} -c 5 >/dev/null 2>&1
+
+# force the links of the bond down
+ip netns exec switch ip link set ${LINK1}-end down
+sleep 2
+ip netns exec switch ip link set ${LINK1}-end up
+ip netns exec switch ip link set ${LINK2}-end down
+
+# re-verify connectivity
+ip netns exec client ping ${SWITCHIP} -c 5 >/dev/null 2>&1
-- 
2.31.1

