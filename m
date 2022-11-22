Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145B9633E50
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbiKVOFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiKVOFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:05:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF581DDE2
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669125795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QNoI4qCUFYL/xV13yMWx+XxtSlVza2fkeLu+mGHpsuU=;
        b=ckBkrin0CLVsg11H0+GI9hdPXo+kJIrcbuGqcSbE8KNwi5bxMFoahBAb63L0/mwLvY2sU1
        oHhuDfgE7CVKl5jy3N4kXgz22k22gcYOl3bWrsQ7e2aVvSmeATnBQfwv1X033HBm6agYg+
        7aG2itiZMm/00sN098GW1VgUtEcqiv0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-naWpKHZOMUKlEWZ2T80u0g-1; Tue, 22 Nov 2022 09:03:12 -0500
X-MC-Unique: naWpKHZOMUKlEWZ2T80u0g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D9E51C08790;
        Tue, 22 Nov 2022 14:03:11 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.16.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B92A540C6EC6;
        Tue, 22 Nov 2022 14:03:10 +0000 (UTC)
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
Subject: [RFC net-next 2/6] selftests: openvswitch: add interface support
Date:   Tue, 22 Nov 2022 09:03:03 -0500
Message-Id: <20221122140307.705112-3-aconole@redhat.com>
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

Includes an associated test to generate netns and connect
interfaces, with the option to include tcp tracing.

This will be used in the future when flow support is added
for additional test cases.

Signed-off-by: Aaron Conole <aconole@redhat.com>
---
 .../selftests/net/openvswitch/openvswitch.sh  |  54 ++++++++
 .../selftests/net/openvswitch/ovs-dpctl.py    | 120 ++++++++++++++++--
 2 files changed, 165 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/openvswitch/openvswitch.sh b/tools/testing/selftests/net/openvswitch/openvswitch.sh
index 7ce46700a3ae..ce14913150fe 100755
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
+
+	ovs_sbx "$1" ip netns add "$3" || return 1
+	on_exit "ovs_sbx $1 ip netns del $3"
+	ovs_sbx "$1" ip link add "$4" type veth peer name "$5" || return 1
+	on_exit "ovs_sbx $1 ip link del $4 >/dev/null 2>&1"
+	ovs_sbx "$1" ip link set "$4" up || return 1
+	ovs_sbx "$1" ip link set "$5" netns "$3" || return 1
+	ovs_sbx "$1" ip netns exec "$3" ip link set "$5" up || return 1
+
+	if [ "$6" != "" ]; then
+		ovs_sbx "$1" ip netns exec "$4" ip addr add "$6" dev "$5" \
+		    || return 1
+	fi
+	ovs_add_if "$1" "$2" "$4" || return 1
+	[ $TRACING -eq 1 ] && ovs_netns_spawn_daemon "$1" "$3" \
+			tcpdump -i any -s 65535 >> ${ovs_dir}/tcpdump_"$3".log
+
+	return 0
+}
+
 usage() {
 	echo
 	echo "$0 [OPTIONS] [TEST]..."
@@ -101,6 +144,17 @@ test_netlink_checks () {
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
 	return 0
 }
 
diff --git a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
index 3243c90d449e..338e9b2cd660 100644
--- a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -170,6 +170,13 @@ class OvsDatapath(GenericNetlinkSocket):
 
 
 class OvsVport(GenericNetlinkSocket):
+
+    OVS_VPORT_TYPE_NETDEV = 1
+    OVS_VPORT_TYPE_INTERNAL = 2
+    OVS_VPORT_TYPE_GRE = 3
+    OVS_VPORT_TYPE_VXLAN = 4
+    OVS_VPORT_TYPE_GENEVE = 5
+
     class ovs_vport_msg(ovs_dp_msg):
         nla_map = (
             ("OVS_VPORT_ATTR_UNSPEC", "none"),
@@ -197,17 +204,30 @@ class OvsVport(GenericNetlinkSocket):
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
@@ -238,8 +258,51 @@ class OvsVport(GenericNetlinkSocket):
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
@@ -265,7 +328,6 @@ def print_ovsdp_full(dp_lookup_rep, ifindex, ndb=NDB()):
         print("  features: 0x%X" % user_features)
 
     # port print out
-    vpl = OvsVport()
     for iface in ndb.interfaces:
         rep = vpl.info(iface.ifname, ifindex)
         if rep is not None:
@@ -312,9 +374,25 @@ def main(argv):
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
@@ -328,7 +406,7 @@ def main(argv):
 
             if rep is not None:
                 found = True
-                print_ovsdp_full(rep, iface.index, ndb)
+                print_ovsdp_full(rep, iface.index, ndb, ovsvp)
 
         if not found:
             msg = "No DP found"
@@ -343,6 +421,30 @@ def main(argv):
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
+        if rep and rep["error"] == 0:
+            msg += " added."
+        else:
+            msg += " failed to add."
+        print(msg)
+    elif hasattr(args, "delif"):
+        rep = ovsdp.info(args.dpname, 0)
+        if rep is None:
+            print("DP '%s' not found." % args.dpname)
+            return 1
+        rep = ovsvp.detach(rep["dpifindex"], args.delif)
+        msg = "vport '%s'" % args.delif
+        if rep and rep["error"] == 0:
+            msg += " removed."
+        else:
+            msg += " failed to remove."
+        print(msg)
 
     return 0
 
-- 
2.34.3

