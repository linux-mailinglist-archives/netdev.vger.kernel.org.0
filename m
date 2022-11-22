Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BFB633E54
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbiKVOFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbiKVOFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:05:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DD820BEB
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669125797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rYhRWhA1aSMDmEn1uPY3m1Uoc/nxJhjisw6iqoh6KAk=;
        b=Jug1gOBMdHwQxjkze73hRb+ssEKcQWkRvP21etQCS7kZDL1yscN8K/sVGG9dAsYJ5TS2Fn
        8GYfMMLZyjlqUYManSCEwJio+yvk30yVPPebhnc7PpIZERcc+8iBgZ8C0IqfLTUHvuc7PG
        HNVX5LMwI0Y2W0SYgIWcbdBcdukb4dE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-4mjhlybcObqbcyDAl7QVdg-1; Tue, 22 Nov 2022 09:03:16 -0500
X-MC-Unique: 4mjhlybcObqbcyDAl7QVdg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12028973283;
        Tue, 22 Nov 2022 14:03:16 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.16.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9132A40C6EC6;
        Tue, 22 Nov 2022 14:03:15 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, dev@openvswitch.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [RFC net-next 6/6] selftests: openvswitch: add exclude support for packet commands
Date:   Tue, 22 Nov 2022 09:03:07 -0500
Message-Id: <20221122140307.705112-7-aconole@redhat.com>
In-Reply-To: <20221122140307.705112-1-aconole@redhat.com>
References: <20221122140307.705112-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a test case to show that we can exclude flows based
on specific configurations.

Signed-off-by: Aaron Conole <aconole@redhat.com>
---
 .../selftests/net/openvswitch/openvswitch.sh  | 53 +++++++++++++++++--
 .../selftests/net/openvswitch/ovs-dpctl.py    | 34 +++++++++++-
 2 files changed, 81 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/openvswitch/openvswitch.sh b/tools/testing/selftests/net/openvswitch/openvswitch.sh
index ce14913150fe..f04f2f748332 100755
--- a/tools/testing/selftests/net/openvswitch/openvswitch.sh
+++ b/tools/testing/selftests/net/openvswitch/openvswitch.sh
@@ -11,7 +11,8 @@ VERBOSE=0
 TRACING=0
 
 tests="
-	netlink_checks				ovsnl: validate netlink attrs and settings"
+	netlink_checks				ovsnl: validate netlink attrs and settings
+	upcall_interfaces			ovs: test the upcall interfaces"
 
 info() {
     [ $VERBOSE = 0 ] || echo $*
@@ -72,7 +73,15 @@ ovs_add_dp () {
 
 ovs_add_if () {
 	info "Adding IF to DP: br:$2 if:$3"
-	ovs_sbx "$1" python3 $ovs_base/ovs-dpctl.py add-if "$2" "$3" || return 1
+	if [ "$4" != "-u" ]; then
+		ovs_sbx "$1" python3 $ovs_base/ovs-dpctl.py add-if "$2" "$3" \
+		    || return 1
+	else
+		python3 $ovs_base/ovs-dpctl.py add-if \
+		    -u "$2" "$3" >$ovs_dir/$3.out 2>$ovs_dir/$3.err &
+		pid=$!
+		on_exit "ovs_sbx $1 kill -TERM $pid 2>/dev/null"
+	fi
 }
 
 ovs_del_if () {
@@ -103,10 +112,16 @@ ovs_add_netns_and_veths () {
 	ovs_sbx "$1" ip netns exec "$3" ip link set "$5" up || return 1
 
 	if [ "$6" != "" ]; then
-		ovs_sbx "$1" ip netns exec "$4" ip addr add "$6" dev "$5" \
+		ovs_sbx "$1" ip netns exec "$3" ip addr add "$6" dev "$5" \
 		    || return 1
 	fi
-	ovs_add_if "$1" "$2" "$4" || return 1
+
+	if [ "$7" != "-u" ]; then
+		ovs_add_if "$1" "$2" "$4" || return 1
+	else
+		ovs_add_if "$1" "$2" "$4" -u || return 1
+	fi
+
 	[ $TRACING -eq 1 ] && ovs_netns_spawn_daemon "$1" "$3" \
 			tcpdump -i any -s 65535 >> ${ovs_dir}/tcpdump_"$3".log
 
@@ -158,6 +173,36 @@ test_netlink_checks () {
 	return 0
 }
 
+test_upcall_interfaces() {
+	sbx_add "test_upcall_interfaces" || return 1
+
+	info "setting up new DP"
+	ovs_add_dp "test_upcall_interfaces" ui0 || return 1
+
+	ovs_add_netns_and_veths "test_upcall_interfaces" ui0 upc left0 l0 \
+	    172.31.110.1/24 -u || return 1
+
+	sleep 1
+	info "sending arping"
+	ip netns exec upc arping -I l0 172.31.110.20 -c 1 \
+	    >$ovs_dir/arping.stdout 2>$ovs_dir/arping.stderr
+
+	grep -E "MISS upcall\[0/yes\]: .*arp\(sip=172.31.110.1,tip=172.31.110.20,op=1,sha=" $ovs_dir/left0.out >/dev/null 2>&1 || return 1
+	# now tear down the DP and set it up with the new options
+	ovs_sbx "test_upcall_interfaces" python3 $ovs_base/ovs-dpctl.py \
+	    del-dp ui0 || return 1
+	ovs_sbx "test_upcall_interfaces" python3 $ovs_base/ovs-dpctl.py \
+	    add-dp -e miss -- ui0 || return 1
+	ovs_add_if "test_upcall_interfaces" ui0 left0 -u || return 1
+
+	sleep 1
+	info "sending second arping"
+	ip netns exec upc arping -I l0 172.31.110.20 -c 1 \
+	    >$ovs_dir/arping.stdout 2>$ovs_dir/arping.stderr
+	grep -E "MISS upcall\[0/yes\]: \(none\)" $ovs_dir/left0.out >/dev/null 2>&1 || return 1
+	return 0
+}
+
 run_test() {
 	(
 	tname="$1"
diff --git a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
index 94204af48d28..ba115fb51773 100644
--- a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -111,6 +111,7 @@ class OvsDatapath(GenericNetlinkSocket):
 
     OVS_DP_F_VPORT_PIDS = 1 << 1
     OVS_DP_F_DISPATCH_UPCALL_PER_CPU = 1 << 3
+    OVS_DP_F_EXCLUDE_UPCALL_FLOW_KEY = 1 << 4
 
     class dp_cmd_msg(ovs_dp_msg):
         """
@@ -127,6 +128,8 @@ class OvsDatapath(GenericNetlinkSocket):
             ("OVS_DP_ATTR_PAD", "none"),
             ("OVS_DP_ATTR_MASKS_CACHE_SIZE", "uint32"),
             ("OVS_DP_ATTR_PER_CPU_PIDS", "array(uint32)"),
+            ("OVS_DP_ATTR_IFINDEX", "uint32"),
+            ("OVS_DP_ATTR_EXCLUDE_CMDS", "uint32"),
         )
 
         class dpstats(nla):
@@ -171,7 +174,8 @@ class OvsDatapath(GenericNetlinkSocket):
 
         return reply
 
-    def create(self, dpname, shouldUpcall=False, versionStr=None, p=OvsPacket()):
+    def create(self, dpname, shouldUpcall=False, versionStr=None, p=OvsPacket(),
+               exclude=[]):
         msg = OvsDatapath.dp_cmd_msg()
         msg["cmd"] = OVS_DP_CMD_NEW
         if versionStr is None:
@@ -200,6 +204,23 @@ class OvsDatapath(GenericNetlinkSocket):
             for i in range(1, nproc):
                 procarray += [int(p.epid)]
             msg["attrs"].append(["OVS_DP_ATTR_UPCALL_PID", procarray])
+
+        excluded = 0
+        print("exclude", exclude)
+        if len(exclude) > 0:
+            for ex in exclude:
+                if ex == "miss":
+                    excluded |= 1 << OvsPacket.OVS_PACKET_CMD_MISS
+                elif ex == "action":
+                    excluded |= 1 << OvsPacket.OVS_PACKET_CMD_ACTION
+                elif ex == "execute":
+                    excluded |= 1 << OvsPacket.OVS_PACKET_CMD_EXECUTE
+                else:
+                    print("DP CREATE: Unknown type: '%s'" % ex)
+            msg["attrs"].append(["OVS_DP_ATTR_EXCLUDE_CMDS", excluded])
+            if versionStr is None or versionStr.find(":") == -1:
+                dpfeatures |= OvsDatapath.OVS_DP_F_EXCLUDE_UPCALL_FLOW_KEY
+
         msg["attrs"].append(["OVS_DP_ATTR_USER_FEATURES", dpfeatures])
 
         try:
@@ -1240,6 +1261,14 @@ def main(argv):
         action="store_true",
         help="Leave open a reader for upcalls",
     )
+    adddpcmd.add_argument(
+        "-e",
+        "--exclude",
+        type=str,
+        default=[],
+        nargs="+",
+        help="Exclude flow key from upcall packet commands"
+    )
     adddpcmd.add_argument(
         "-V",
         "--versioning",
@@ -1305,7 +1334,8 @@ def main(argv):
                 msg += ":'%s'" % args.showdp
             print(msg)
     elif hasattr(args, "adddp"):
-        rep = ovsdp.create(args.adddp, args.upcall, args.versioning, ovspk)
+        rep = ovsdp.create(args.adddp, args.upcall, args.versioning, ovspk,
+                           args.exclude)
         if rep is None:
             print("DP '%s' already exists" % args.adddp)
         else:
-- 
2.34.3

