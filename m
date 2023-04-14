Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B46B6E2428
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 15:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjDNNSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 09:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjDNNSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 09:18:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B053A8D
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 06:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681478275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AcKVzSwU6dHqn7p919wuy0R/YmA8jOiCVtvk2s345Ec=;
        b=ancJoE4HN2X+QpMwJHr+tGl2sLH77RKqZgJ90B94z9TdQMNYsE4t5gar6A7d55kP0Lqmgd
        QcW8pu/Wb+3Fqj6NmcWcbFY+nsV7+HfnHu6lJbus7XzurNbt8hhKwk0RtNz9dCk42KfJnS
        ThQ/cgwTWq6j+SWjiGWC3tDOU+Iw83E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-GGMe3DeUMKecEN02ovX3yg-1; Fri, 14 Apr 2023 09:17:53 -0400
X-MC-Unique: GGMe3DeUMKecEN02ovX3yg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68F9C3C11789;
        Fri, 14 Apr 2023 13:17:52 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.8.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AADFC16028;
        Fri, 14 Apr 2023 13:17:52 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, Pravin Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 3/3] selftests: openvswitch: add support for upcall testing
Date:   Fri, 14 Apr 2023 09:17:50 -0400
Message-Id: <20230414131750.4185160-4-aconole@redhat.com>
In-Reply-To: <20230414131750.4185160-1-aconole@redhat.com>
References: <20230414131750.4185160-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The upcall socket interface can be exercised now to make sure that
future feature adjustments to the field can maintain backwards
compatibility.

Signed-off-by: Aaron Conole <aconole@redhat.com>
---
 .../selftests/net/openvswitch/openvswitch.sh  |  38 ++++-
 .../selftests/net/openvswitch/ovs-dpctl.py    | 138 +++++++++++++++++-
 2 files changed, 165 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/openvswitch/openvswitch.sh b/tools/testing/selftests/net/openvswitch/openvswitch.sh
index 18383b0b7b9cb..3117a4be0cd04 100755
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
@@ -106,7 +115,12 @@ ovs_add_netns_and_veths () {
 		    || return 1
 	fi
 
-	ovs_add_if "$1" "$2" "$4" || return 1
+	if [ "$7" != "-u" ]; then
+		ovs_add_if "$1" "$2" "$4" || return 1
+	else
+		ovs_add_if "$1" "$2" "$4" -u || return 1
+	fi
+
 	[ $TRACING -eq 1 ] && ovs_netns_spawn_daemon "$1" "$ns" \
 			tcpdump -i any -s 65535
 
@@ -159,6 +173,24 @@ test_netlink_checks () {
 	return 0
 }
 
+test_upcall_interfaces() {
+	sbx_add "test_upcall_interfaces" || return 1
+
+	info "setting up new DP"
+	ovs_add_dp "test_upcall_interfaces" ui0 -V 2:1 || return 1
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
+	return 0
+}
+
 run_test() {
 	(
 	tname="$1"
diff --git a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
index 21b1b8deda7d9..1c8b36bc15d48 100644
--- a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -8,6 +8,8 @@ import argparse
 import errno
 import ipaddress
 import logging
+import multiprocessing
+import struct
 import sys
 import time
 
@@ -926,6 +928,51 @@ class ovskey(nla):
         return print_str
 
 
+class OvsPacket(GenericNetlinkSocket):
+    OVS_PACKET_CMD_MISS = 1  # Flow table miss
+    OVS_PACKET_CMD_ACTION = 2  # USERSPACE action
+    OVS_PACKET_CMD_EXECUTE = 3  # Apply actions to packet
+
+    class ovs_packet_msg(ovs_dp_msg):
+        nla_map = (
+            ("OVS_PACKET_ATTR_UNSPEC", "none"),
+            ("OVS_PACKET_ATTR_PACKET", "array(uint8)"),
+            ("OVS_PACKET_ATTR_KEY", "ovskey"),
+            ("OVS_PACKET_ATTR_ACTIONS", "ovsactions"),
+            ("OVS_PACKET_ATTR_USERDATA", "none"),
+            ("OVS_PACKET_ATTR_EGRESS_TUN_KEY", "none"),
+            ("OVS_PACKET_ATTR_UNUSED1", "none"),
+            ("OVS_PACKET_ATTR_UNUSED2", "none"),
+            ("OVS_PACKET_ATTR_PROBE", "none"),
+            ("OVS_PACKET_ATTR_MRU", "uint16"),
+            ("OVS_PACKET_ATTR_LEN", "uint32"),
+            ("OVS_PACKET_ATTR_HASH", "uint64"),
+        )
+
+    def __init__(self):
+        GenericNetlinkSocket.__init__(self)
+        self.bind(OVS_PACKET_FAMILY, OvsPacket.ovs_packet_msg)
+
+    def upcall_handler(self, up=None):
+        print("listening on upcall packet handler:", self.epid)
+        while True:
+            try:
+                msgs = self.get()
+                for msg in msgs:
+                    if not up:
+                        continue
+                    if msg["cmd"] == OvsPacket.OVS_PACKET_CMD_MISS:
+                        up.miss(msg)
+                    elif msg["cmd"] == OvsPacket.OVS_PACKET_CMD_ACTION:
+                        up.action(msg)
+                    elif msg["cmd"] == OvsPacket.OVS_PACKET_CMD_EXECUTE:
+                        up.execute(msg)
+                    else:
+                        print("Unkonwn cmd: %d" % msg["cmd"])
+            except NetlinkError as ne:
+                raise ne
+
+
 class OvsDatapath(GenericNetlinkSocket):
     OVS_DP_F_VPORT_PIDS = 1 << 1
     OVS_DP_F_DISPATCH_UPCALL_PER_CPU = 1 << 3
@@ -989,7 +1036,9 @@ class OvsDatapath(GenericNetlinkSocket):
 
         return reply
 
-    def create(self, dpname, shouldUpcall=False, versionStr=None):
+    def create(
+        self, dpname, shouldUpcall=False, versionStr=None, p=OvsPacket()
+    ):
         msg = OvsDatapath.dp_cmd_msg()
         msg["cmd"] = OVS_DP_CMD_NEW
         if versionStr is None:
@@ -1004,11 +1053,18 @@ class OvsDatapath(GenericNetlinkSocket):
         if versionStr is not None and versionStr.find(":") != -1:
             dpfeatures = int(versionStr.split(":")[1], 0)
         else:
-            dpfeatures = OvsDatapath.OVS_DP_F_VPORT_PIDS
-
+            if versionStr is None or versionStr.find(":") == -1:
+                dpfeatures |= OvsDatapath.OVS_DP_F_DISPATCH_UPCALL_PER_CPU
+                dpfeatures &= ~OvsDatapath.OVS_DP_F_VPORT_PIDS
+
+            nproc = multiprocessing.cpu_count()
+            procarray = []
+            for i in range(1, nproc):
+                procarray += [int(p.epid)]
+            msg["attrs"].append(["OVS_DP_ATTR_UPCALL_PID", procarray])
         msg["attrs"].append(["OVS_DP_ATTR_USER_FEATURES", dpfeatures])
         if not shouldUpcall:
-            msg["attrs"].append(["OVS_DP_ATTR_UPCALL_PID", 0])
+            msg["attrs"].append(["OVS_DP_ATTR_UPCALL_PID", [0]])
 
         try:
             reply = self.nlm_request(
@@ -1104,9 +1160,10 @@ class OvsVport(GenericNetlinkSocket):
             return OvsVport.OVS_VPORT_TYPE_GENEVE
         raise ValueError("Unknown vport type: '%s'" % vport_type)
 
-    def __init__(self):
+    def __init__(self, packet=OvsPacket()):
         GenericNetlinkSocket.__init__(self)
         self.bind(OVS_VPORT_FAMILY, OvsVport.ovs_vport_msg)
+        self.upcall_packet = packet
 
     def info(self, vport_name, dpifindex=0, portno=None):
         msg = OvsVport.ovs_vport_msg()
@@ -1144,7 +1201,37 @@ class OvsVport(GenericNetlinkSocket):
 
         msg["attrs"].append(["OVS_VPORT_ATTR_TYPE", port_type])
         msg["attrs"].append(["OVS_VPORT_ATTR_NAME", vport_ifname])
-        msg["attrs"].append(["OVS_VPORT_ATTR_UPCALL_PID", [self.pid]])
+        msg["attrs"].append(
+            ["OVS_VPORT_ATTR_UPCALL_PID", [self.upcall_packet.epid]]
+        )
+
+        try:
+            reply = self.nlm_request(
+                msg, msg_type=self.prid, msg_flags=NLM_F_REQUEST | NLM_F_ACK
+            )
+            reply = reply[0]
+        except NetlinkError as ne:
+            if ne.code == errno.EEXIST:
+                reply = None
+            else:
+                raise ne
+        return reply
+
+    def reset_upcall(self, dpindex, vport_ifname, p=None):
+        msg = OvsVport.ovs_vport_msg()
+
+        msg["cmd"] = OVS_VPORT_CMD_SET
+        msg["version"] = OVS_DATAPATH_VERSION
+        msg["reserved"] = 0
+        msg["dpifindex"] = dpindex
+        msg["attrs"].append(["OVS_VPORT_ATTR_NAME", vport_ifname])
+
+        if p == None:
+            p = self.upcall_packet
+        else:
+            self.upcall_packet = p
+
+        msg["attrs"].append(["OVS_VPORT_ATTR_UPCALL_PID", [p.epid]])
 
         try:
             reply = self.nlm_request(
@@ -1176,6 +1263,9 @@ class OvsVport(GenericNetlinkSocket):
                 raise ne
         return reply
 
+    def upcall_handler(self, handler=None):
+        self.upcall_packet.upcall_handler(handler)
+
 
 class OvsFlow(GenericNetlinkSocket):
     class ovs_flow_msg(ovs_dp_msg):
@@ -1305,6 +1395,24 @@ class OvsFlow(GenericNetlinkSocket):
             raise ne
         return rep
 
+    def miss(self, packetmsg):
+        seq = packetmsg["header"]["sequence_number"]
+        keystr = "(none)"
+        key_field = packetmsg.get_attr("OVS_PACKET_ATTR_KEY")
+        if key_field is not None:
+            keystr = key_field.dpstr(None, True)
+
+        pktdata = packetmsg.get_attr("OVS_PACKET_ATTR_PACKET")
+        pktpres = "yes" if pktdata is not None else "no"
+
+        print("MISS upcall[%d/%s]: %s" % (seq, pktpres, keystr), flush=True)
+
+    def execute(self, packetmsg):
+        print("userspace execute command")
+
+    def action(self, packetmsg):
+        print("userspace action command")
+
 
 def print_ovsdp_full(dp_lookup_rep, ifindex, ndb=NDB(), vpl=OvsVport()):
     dp_name = dp_lookup_rep.get_attr("OVS_DP_ATTR_NAME")
@@ -1385,6 +1493,12 @@ def main(argv):
     addifcmd = subparsers.add_parser("add-if")
     addifcmd.add_argument("dpname", help="Datapath Name")
     addifcmd.add_argument("addif", help="Interface name for adding")
+    addifcmd.add_argument(
+        "-u",
+        "--upcall",
+        action="store_true",
+        help="Leave open a reader for upcalls",
+    )
     addifcmd.add_argument(
         "-t",
         "--ptype",
@@ -1406,8 +1520,9 @@ def main(argv):
         if args.verbose > 1:
             logging.basicConfig(level=logging.DEBUG)
 
+    ovspk = OvsPacket()
     ovsdp = OvsDatapath()
-    ovsvp = OvsVport()
+    ovsvp = OvsVport(ovspk)
     ovsflow = OvsFlow()
     ndb = NDB()
 
@@ -1430,11 +1545,13 @@ def main(argv):
                 msg += ":'%s'" % args.showdp
             print(msg)
     elif hasattr(args, "adddp"):
-        rep = ovsdp.create(args.adddp, args.upcall, args.versioning)
+        rep = ovsdp.create(args.adddp, args.upcall, args.versioning, ovspk)
         if rep is None:
             print("DP '%s' already exists" % args.adddp)
         else:
             print("DP '%s' added" % args.adddp)
+        if args.upcall:
+            ovspk.upcall_handler(ovsflow)
     elif hasattr(args, "deldp"):
         ovsdp.destroy(args.deldp)
     elif hasattr(args, "addif"):
@@ -1442,12 +1559,17 @@ def main(argv):
         if rep is None:
             print("DP '%s' not found." % args.dpname)
             return 1
+        dpindex = rep["dpifindex"]
         rep = ovsvp.attach(rep["dpifindex"], args.addif, args.ptype)
         msg = "vport '%s'" % args.addif
         if rep and rep["header"]["error"] is None:
             msg += " added."
         else:
             msg += " failed to add."
+        if args.upcall:
+            if rep is None:
+                rep = ovsvp.reset_upcall(dpindex, args.addif, ovspk)
+            ovsvp.upcall_handler(ovsflow)
     elif hasattr(args, "delif"):
         rep = ovsdp.info(args.dpname, 0)
         if rep is None:
-- 
2.39.2

