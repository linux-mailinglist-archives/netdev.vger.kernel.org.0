Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63106E2427
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 15:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjDNNSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 09:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjDNNSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 09:18:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D92E62
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 06:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681478274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GQ9CPF1ujf56CWjjPtT+YZKYgZ0IGnwiz0bicREsGTM=;
        b=Ojkb0RLgZt5onaiJbrunxe+HIwPGPjym2vLSKHYZehWl7YiENHe6xNM6l1YwUhvB6yomr5
        JufSbKscurg7f0a3vrbR1iF5EUlO4raJ8FYdmx0yEL1x+7ry3VtXStRkv+di3p7aOh/mAM
        bnNkbk+249fTVWyaTEN9g4YcdxACu8M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-_syMIV-LNxC6xgrsFAr2XA-1; Fri, 14 Apr 2023 09:17:53 -0400
X-MC-Unique: _syMIV-LNxC6xgrsFAr2XA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 790FB101A54F;
        Fri, 14 Apr 2023 13:17:51 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.8.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E8FEC16028;
        Fri, 14 Apr 2023 13:17:51 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, Pravin Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 1/3] selftests: openvswitch: add interface support
Date:   Fri, 14 Apr 2023 09:17:48 -0400
Message-Id: <20230414131750.4185160-2-aconole@redhat.com>
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

Includes an associated test to generate netns and connect
interfaces, with the option to include packet tracing.

This will be used in the future when flow support is added
for additional test cases.

Signed-off-by: Aaron Conole <aconole@redhat.com>
---
 .../selftests/net/openvswitch/openvswitch.sh  |  55 ++++++++
 .../selftests/net/openvswitch/ovs-dpctl.py    | 118 ++++++++++++++++--
 2 files changed, 163 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/openvswitch/openvswitch.sh b/tools/testing/selftests/net/openvswitch/openvswitch.sh
index 7ce46700a3ae3..18383b0b7b9cb 100755
--- a/tools/testing/selftests/net/openvswitch/openvswitch.sh
+++ b/tools/testing/selftests/net/openvswitch/openvswitch.sh
@@ -70,6 +70,49 @@ ovs_add_dp () {
 	on_exit "ovs_sbx $sbxname python3 $ovs_base/ovs-dpctl.py del-dp $1;"
 }
 
+ovs_add_if () {
+	info "Adding IF to DP: br:$2 if:$3"
+	ovs_sbx "$1" python3 $ovs_base/ovs-dpctl.py add-if "$2" "$3" || return 1
+}
+
+ovs_del_if () {
+	info "Deleting IF from DP: br:$2 if:$3"
+	ovs_sbx "$1" python3 $ovs_base/ovs-dpctl.py del-if "$2" "$3" || return 1
+}
+
+ovs_netns_spawn_daemon() {
+	sbx=$1
+	shift
+	netns=$1
+	shift
+	info "spawning cmd: $*"
+	ip netns exec $netns $*  >> $ovs_dir/stdout  2>> $ovs_dir/stderr &
+	pid=$!
+	ovs_sbx "$sbx" on_exit "kill -TERM $pid 2>/dev/null"
+}
+
+ovs_add_netns_and_veths () {
+	info "Adding netns attached: sbx:$1 dp:$2 {$3, $4, $5}"
+	ovs_sbx "$1" ip netns add "$3" || return 1
+	on_exit "ovs_sbx $1 ip netns del $3"
+	ovs_sbx "$1" ip link add "$4" type veth peer name "$5" || return 1
+	on_exit "ovs_sbx $1 ip link del $4 >/dev/null 2>&1"
+	ovs_sbx "$1" ip link set "$4" up || return 1
+	ovs_sbx "$1" ip link set "$5" netns "$3" || return 1
+	ovs_sbx "$1" ip netns exec "$3" ip link set "$5" up || return 1
+
+	if [ "$6" != "" ]; then
+		ovs_sbx "$1" ip netns exec "$3" ip addr add "$6" dev "$5" \
+		    || return 1
+	fi
+
+	ovs_add_if "$1" "$2" "$4" || return 1
+	[ $TRACING -eq 1 ] && ovs_netns_spawn_daemon "$1" "$ns" \
+			tcpdump -i any -s 65535
+
+	return 0
+}
+
 usage() {
 	echo
 	echo "$0 [OPTIONS] [TEST]..."
@@ -101,6 +144,18 @@ test_netlink_checks () {
 		return 1
 	fi
 
+	ovs_add_netns_and_veths "test_netlink_checks" nv0 left left0 l0 || \
+	    return 1
+	ovs_add_netns_and_veths "test_netlink_checks" nv0 right right0 r0 || \
+	    return 1
+	[ $(python3 $ovs_base/ovs-dpctl.py show nv0 | grep port | \
+	    wc -l) == 3 ] || \
+	      return 1
+	ovs_del_if "test_netlink_checks" nv0 right0 || return 1
+	[ $(python3 $ovs_base/ovs-dpctl.py show nv0 | grep port | \
+	    wc -l) == 2 ] || \
+	      return 1
+
 	return 0
 }
 
diff --git a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
index 5d467d1993cb1..626013dfd020e 100644
--- a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -50,7 +50,6 @@ class ovs_dp_msg(genlmsg):
 
 
 class OvsDatapath(GenericNetlinkSocket):
-
     OVS_DP_F_VPORT_PIDS = 1 << 1
     OVS_DP_F_DISPATCH_UPCALL_PER_CPU = 1 << 3
 
@@ -170,6 +169,12 @@ class OvsDatapath(GenericNetlinkSocket):
 
 
 class OvsVport(GenericNetlinkSocket):
+    OVS_VPORT_TYPE_NETDEV = 1
+    OVS_VPORT_TYPE_INTERNAL = 2
+    OVS_VPORT_TYPE_GRE = 3
+    OVS_VPORT_TYPE_VXLAN = 4
+    OVS_VPORT_TYPE_GENEVE = 5
+
     class ovs_vport_msg(ovs_dp_msg):
         nla_map = (
             ("OVS_VPORT_ATTR_UNSPEC", "none"),
@@ -197,17 +202,30 @@ class OvsVport(GenericNetlinkSocket):
             )
 
     def type_to_str(vport_type):
-        if vport_type == 1:
+        if vport_type == OvsVport.OVS_VPORT_TYPE_NETDEV:
             return "netdev"
-        elif vport_type == 2:
+        elif vport_type == OvsVport.OVS_VPORT_TYPE_INTERNAL:
             return "internal"
-        elif vport_type == 3:
+        elif vport_type == OvsVport.OVS_VPORT_TYPE_GRE:
             return "gre"
-        elif vport_type == 4:
+        elif vport_type == OvsVport.OVS_VPORT_TYPE_VXLAN:
             return "vxlan"
-        elif vport_type == 5:
+        elif vport_type == OvsVport.OVS_VPORT_TYPE_GENEVE:
             return "geneve"
-        return "unknown:%d" % vport_type
+        raise ValueError("Unknown vport type:%d" % vport_type)
+
+    def str_to_type(vport_type):
+        if vport_type == "netdev":
+            return OvsVport.OVS_VPORT_TYPE_NETDEV
+        elif vport_type == "internal":
+            return OvsVport.OVS_VPORT_TYPE_INTERNAL
+        elif vport_type == "gre":
+            return OvsVport.OVS_VPORT_TYPE_INTERNAL
+        elif vport_type == "vxlan":
+            return OvsVport.OVS_VPORT_TYPE_VXLAN
+        elif vport_type == "geneve":
+            return OvsVport.OVS_VPORT_TYPE_GENEVE
+        raise ValueError("Unknown vport type: '%s'" % vport_type)
 
     def __init__(self):
         GenericNetlinkSocket.__init__(self)
@@ -238,8 +256,51 @@ class OvsVport(GenericNetlinkSocket):
                 raise ne
         return reply
 
+    def attach(self, dpindex, vport_ifname, ptype):
+        msg = OvsVport.ovs_vport_msg()
+
+        msg["cmd"] = OVS_VPORT_CMD_NEW
+        msg["version"] = OVS_DATAPATH_VERSION
+        msg["reserved"] = 0
+        msg["dpifindex"] = dpindex
+        port_type = OvsVport.str_to_type(ptype)
+
+        msg["attrs"].append(["OVS_VPORT_ATTR_TYPE", port_type])
+        msg["attrs"].append(["OVS_VPORT_ATTR_NAME", vport_ifname])
+        msg["attrs"].append(["OVS_VPORT_ATTR_UPCALL_PID", [self.pid]])
+
+        try:
+            reply = self.nlm_request(
+                msg, msg_type=self.prid, msg_flags=NLM_F_REQUEST | NLM_F_ACK
+            )
+            reply = reply[0]
+        except NetlinkError as ne:
+            raise ne
+        return reply
+
+    def detach(self, dpindex, vport_ifname):
+        msg = OvsVport.ovs_vport_msg()
+
+        msg["cmd"] = OVS_VPORT_CMD_DEL
+        msg["version"] = OVS_DATAPATH_VERSION
+        msg["reserved"] = 0
+        msg["dpifindex"] = dpindex
+        msg["attrs"].append(["OVS_VPORT_ATTR_NAME", vport_ifname])
 
-def print_ovsdp_full(dp_lookup_rep, ifindex, ndb=NDB()):
+        try:
+            reply = self.nlm_request(
+                msg, msg_type=self.prid, msg_flags=NLM_F_REQUEST | NLM_F_ACK
+            )
+            reply = reply[0]
+        except NetlinkError as ne:
+            if ne.code == errno.ENODEV:
+                reply = None
+            else:
+                raise ne
+        return reply
+
+
+def print_ovsdp_full(dp_lookup_rep, ifindex, ndb=NDB(), vpl=OvsVport()):
     dp_name = dp_lookup_rep.get_attr("OVS_DP_ATTR_NAME")
     base_stats = dp_lookup_rep.get_attr("OVS_DP_ATTR_STATS")
     megaflow_stats = dp_lookup_rep.get_attr("OVS_DP_ATTR_MEGAFLOW_STATS")
@@ -265,7 +326,6 @@ def print_ovsdp_full(dp_lookup_rep, ifindex, ndb=NDB()):
         print("  features: 0x%X" % user_features)
 
     # port print out
-    vpl = OvsVport()
     for iface in ndb.interfaces:
         rep = vpl.info(iface.ifname, ifindex)
         if rep is not None:
@@ -312,9 +372,25 @@ def main(argv):
     deldpcmd = subparsers.add_parser("del-dp")
     deldpcmd.add_argument("deldp", help="Datapath Name")
 
+    addifcmd = subparsers.add_parser("add-if")
+    addifcmd.add_argument("dpname", help="Datapath Name")
+    addifcmd.add_argument("addif", help="Interface name for adding")
+    addifcmd.add_argument(
+        "-t",
+        "--ptype",
+        type=str,
+        default="netdev",
+        choices=["netdev", "internal"],
+        help="Interface type (default netdev)",
+    )
+    delifcmd = subparsers.add_parser("del-if")
+    delifcmd.add_argument("dpname", help="Datapath Name")
+    delifcmd.add_argument("delif", help="Interface name for adding")
+
     args = parser.parse_args()
 
     ovsdp = OvsDatapath()
+    ovsvp = OvsVport()
     ndb = NDB()
 
     if hasattr(args, "showdp"):
@@ -328,7 +404,7 @@ def main(argv):
 
             if rep is not None:
                 found = True
-                print_ovsdp_full(rep, iface.index, ndb)
+                print_ovsdp_full(rep, iface.index, ndb, ovsvp)
 
         if not found:
             msg = "No DP found"
@@ -343,6 +419,28 @@ def main(argv):
             print("DP '%s' added" % args.adddp)
     elif hasattr(args, "deldp"):
         ovsdp.destroy(args.deldp)
+    elif hasattr(args, "addif"):
+        rep = ovsdp.info(args.dpname, 0)
+        if rep is None:
+            print("DP '%s' not found." % args.dpname)
+            return 1
+        rep = ovsvp.attach(rep["dpifindex"], args.addif, args.ptype)
+        msg = "vport '%s'" % args.addif
+        if rep and rep["header"]["error"] is None:
+            msg += " added."
+        else:
+            msg += " failed to add."
+    elif hasattr(args, "delif"):
+        rep = ovsdp.info(args.dpname, 0)
+        if rep is None:
+            print("DP '%s' not found." % args.dpname)
+            return 1
+        rep = ovsvp.detach(rep["dpifindex"], args.delif)
+        msg = "vport '%s'" % args.delif
+        if rep and rep["header"]["error"] is None:
+            msg += " removed."
+        else:
+            msg += " failed to remove."
 
     return 0
 
-- 
2.39.2

