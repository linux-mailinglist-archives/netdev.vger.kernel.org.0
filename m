Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CA16E2425
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 15:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjDNNSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 09:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjDNNSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 09:18:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8617E272C
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 06:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681478275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQobNm3aR9EOikzSg36YJgP/IcbjuTNAeYHYfdXVc74=;
        b=FTNLrtFXm4bXl9yyKfzK5H1Mz1L5dgm1QDPiY9hQLpCDH9sWO3weN4DGi6V326JHhu6Kxv
        +gGLiCYivCX6n8iSWB7datKRDagEcg85SGPiZ10mfH9WhY/qDPR6KLtlvWsl2h0dliRem+
        xzje1/LDnYZJYACUiVxOkRIIoslKqEs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-WryAU8GGONKFfPMmRBOdlQ-1; Fri, 14 Apr 2023 09:17:52 -0400
X-MC-Unique: WryAU8GGONKFfPMmRBOdlQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F20C8185A790;
        Fri, 14 Apr 2023 13:17:51 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.8.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B5CAC16028;
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
Subject: [PATCH net-next 2/3] selftests: openvswitch: add flow dump support
Date:   Fri, 14 Apr 2023 09:17:49 -0400
Message-Id: <20230414131750.4185160-3-aconole@redhat.com>
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

Add a basic set of fields to print in a 'dpflow' format.  This will be
used by future commits to check for flow fields after parsing, as
well as verifying the flow fields pushed into the kernel from
userspace.

Signed-off-by: Aaron Conole <aconole@redhat.com>
---
 .../selftests/net/openvswitch/ovs-dpctl.py    | 1026 +++++++++++++++++
 1 file changed, 1026 insertions(+)

diff --git a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
index 626013dfd020e..21b1b8deda7d9 100644
--- a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -6,15 +6,21 @@
 
 import argparse
 import errno
+import ipaddress
+import logging
 import sys
+import time
 
 try:
     from pyroute2 import NDB
 
+    from pyroute2.netlink import NLA_F_NESTED
     from pyroute2.netlink import NLM_F_ACK
+    from pyroute2.netlink import NLM_F_DUMP
     from pyroute2.netlink import NLM_F_REQUEST
     from pyroute2.netlink import genlmsg
     from pyroute2.netlink import nla
+    from pyroute2.netlink import nlmsg_atoms
     from pyroute2.netlink.exceptions import NetlinkError
     from pyroute2.netlink.generic import GenericNetlinkSocket
 except ModuleNotFoundError:
@@ -40,6 +46,36 @@ OVS_VPORT_CMD_DEL = 2
 OVS_VPORT_CMD_GET = 3
 OVS_VPORT_CMD_SET = 4
 
+OVS_FLOW_CMD_NEW = 1
+OVS_FLOW_CMD_DEL = 2
+OVS_FLOW_CMD_GET = 3
+OVS_FLOW_CMD_SET = 4
+
+
+def macstr(mac):
+    outstr = ":".join(["%02X" % i for i in mac])
+    return outstr
+
+
+def convert_mac(mac_str, mask=False):
+    if mac_str is None or mac_str == "":
+        mac_str = "00:00:00:00:00:00"
+    if mask is True and mac_str != "00:00:00:00:00:00":
+        mac_str = "FF:FF:FF:FF:FF:FF"
+    mac_split = mac_str.split(":")
+    ret = bytearray([int(i, 16) for i in mac_split])
+    return bytes(ret)
+
+
+def convert_ipv4(ip, mask=False):
+    if ip is None:
+        ip = 0
+    if mask is True:
+        if ip != 0:
+            ip = int(ipaddress.IPv4Address(ip)) & 0xFFFFFFFF
+
+    return int(ipaddress.IPv4Address(ip))
+
 
 class ovs_dp_msg(genlmsg):
     # include the OVS version
@@ -49,6 +85,847 @@ class ovs_dp_msg(genlmsg):
     fields = genlmsg.fields + (("dpifindex", "I"),)
 
 
+class ovsactions(nla):
+    nla_flags = NLA_F_NESTED
+
+    nla_map = (
+        ("OVS_ACTION_ATTR_UNSPEC", "none"),
+        ("OVS_ACTION_ATTR_OUTPUT", "uint32"),
+        ("OVS_ACTION_ATTR_USERSPACE", "userspace"),
+        ("OVS_ACTION_ATTR_SET", "none"),
+        ("OVS_ACTION_ATTR_PUSH_VLAN", "none"),
+        ("OVS_ACTION_ATTR_POP_VLAN", "flag"),
+        ("OVS_ACTION_ATTR_SAMPLE", "none"),
+        ("OVS_ACTION_ATTR_RECIRC", "uint32"),
+        ("OVS_ACTION_ATTR_HASH", "none"),
+        ("OVS_ACTION_ATTR_PUSH_MPLS", "none"),
+        ("OVS_ACTION_ATTR_POP_MPLS", "flag"),
+        ("OVS_ACTION_ATTR_SET_MASKED", "none"),
+        ("OVS_ACTION_ATTR_CT", "ctact"),
+        ("OVS_ACTION_ATTR_TRUNC", "uint32"),
+        ("OVS_ACTION_ATTR_PUSH_ETH", "none"),
+        ("OVS_ACTION_ATTR_POP_ETH", "flag"),
+        ("OVS_ACTION_ATTR_CT_CLEAR", "flag"),
+        ("OVS_ACTION_ATTR_PUSH_NSH", "none"),
+        ("OVS_ACTION_ATTR_POP_NSH", "flag"),
+        ("OVS_ACTION_ATTR_METER", "none"),
+        ("OVS_ACTION_ATTR_CLONE", "none"),
+        ("OVS_ACTION_ATTR_CHECK_PKT_LEN", "none"),
+        ("OVS_ACTION_ATTR_ADD_MPLS", "none"),
+        ("OVS_ACTION_ATTR_DEC_TTL", "none"),
+    )
+
+    class ctact(nla):
+        nla_flags = NLA_F_NESTED
+
+        nla_map = (
+            ("OVS_CT_ATTR_NONE", "none"),
+            ("OVS_CT_ATTR_COMMIT", "flag"),
+            ("OVS_CT_ATTR_ZONE", "uint16"),
+            ("OVS_CT_ATTR_MARK", "none"),
+            ("OVS_CT_ATTR_LABELS", "none"),
+            ("OVS_CT_ATTR_HELPER", "asciiz"),
+            ("OVS_CT_ATTR_NAT", "natattr"),
+            ("OVS_CT_ATTR_FORCE_COMMIT", "flag"),
+            ("OVS_CT_ATTR_EVENTMASK", "uint32"),
+            ("OVS_CT_ATTR_TIMEOUT", "asciiz"),
+        )
+
+        class natattr(nla):
+            nla_flags = NLA_F_NESTED
+
+            nla_map = (
+                ("OVS_NAT_ATTR_NONE", "none"),
+                ("OVS_NAT_ATTR_SRC", "flag"),
+                ("OVS_NAT_ATTR_DST", "flag"),
+                ("OVS_NAT_ATTR_IP_MIN", "ipaddr"),
+                ("OVS_NAT_ATTR_IP_MAX", "ipaddr"),
+                ("OVS_NAT_ATTR_PROTO_MIN", "uint16"),
+                ("OVS_NAT_ATTR_PROTO_MAX", "uint16"),
+                ("OVS_NAT_ATTR_PERSISTENT", "flag"),
+                ("OVS_NAT_ATTR_PROTO_HASH", "flag"),
+                ("OVS_NAT_ATTR_PROTO_RANDOM", "flag"),
+            )
+
+            def dpstr(self, more=False):
+                print_str = "nat("
+
+                if self.get_attr("OVS_NAT_ATTR_SRC"):
+                    print_str += "src"
+                elif self.get_attr("OVS_NAT_ATTR_DST"):
+                    print_str += "dst"
+                else:
+                    print_str += "XXX-unknown-nat"
+
+                if self.get_attr("OVS_NAT_ATTR_IP_MIN") or self.get_attr(
+                    "OVS_NAT_ATTR_IP_MAX"
+                ):
+                    if self.get_attr("OVS_NAT_ATTR_IP_MIN"):
+                        print_str += "=%s," % str(
+                            self.get_attr("OVS_NAT_ATTR_IP_MIN")
+                        )
+
+                    if self.get_attr("OVS_NAT_ATTR_IP_MAX"):
+                        print_str += "-%s," % str(
+                            self.get_attr("OVS_NAT_ATTR_IP_MAX")
+                        )
+                else:
+                    print_str += ","
+
+                if self.get_attr("OVS_NAT_ATTR_PROTO_MIN"):
+                    print_str += "proto_min=%d," % self.get_attr(
+                        "OVS_NAT_ATTR_PROTO_MIN"
+                    )
+
+                if self.get_attr("OVS_NAT_ATTR_PROTO_MAX"):
+                    print_str += "proto_max=%d," % self.get_attr(
+                        "OVS_NAT_ATTR_PROTO_MAX"
+                    )
+
+                if self.get_attr("OVS_NAT_ATTR_PERSISTENT"):
+                    print_str += "persistent,"
+                if self.get_attr("OVS_NAT_ATTR_HASH"):
+                    print_str += "hash,"
+                if self.get_attr("OVS_NAT_ATTR_RANDOM"):
+                    print_str += "random"
+                print_str += ")"
+                return print_str
+
+        def dpstr(self, more=False):
+            print_str = "ct("
+
+            if self.get_attr("OVS_CT_ATTR_COMMIT") is not None:
+                print_str += "commit,"
+            if self.get_attr("OVS_CT_ATTR_ZONE") is not None:
+                print_str += "zone=%d," % self.get_attr("OVS_CT_ATTR_ZONE")
+            if self.get_attr("OVS_CT_ATTR_HELPER") is not None:
+                print_str += "helper=%s," % self.get_attr("OVS_CT_ATTR_HELPER")
+            if self.get_attr("OVS_CT_ATTR_NAT") is not None:
+                print_str += self.get_attr("OVS_CT_ATTR_NAT").dpstr(more)
+                print_str += ","
+            if self.get_attr("OVS_CT_ATTR_FORCE_COMMIT") is not None:
+                print_str += "force,"
+            if self.get_attr("OVS_CT_ATTR_EVENTMASK") is not None:
+                print_str += "emask=0x%X," % self.get_attr(
+                    "OVS_CT_ATTR_EVENTMASK"
+                )
+            if self.get_attr("OVS_CT_ATTR_TIMEOUT") is not None:
+                print_str += "timeout=%s" % self.get_attr(
+                    "OVS_CT_ATTR_TIMEOUT"
+                )
+            print_str += ")"
+            return print_str
+
+    class userspace(nla):
+        nla_flags = NLA_F_NESTED
+
+        nla_map = (
+            ("OVS_USERSPACE_ATTR_UNUSED", "none"),
+            ("OVS_USERSPACE_ATTR_PID", "uint32"),
+            ("OVS_USERSPACE_ATTR_USERDATA", "array(uint8)"),
+            ("OVS_USERSPACE_ATTR_EGRESS_TUN_PORT", "uint32"),
+        )
+
+        def dpstr(self, more=False):
+            print_str = "userspace("
+            if self.get_attr("OVS_USERSPACE_ATTR_PID") is not None:
+                print_str += "pid=%d," % self.get_attr(
+                    "OVS_USERSPACE_ATTR_PID"
+                )
+            if self.get_attr("OVS_USERSPACE_ATTR_USERDATA") is not None:
+                print_str += "userdata="
+                for f in self.get_attr("OVS_USERSPACE_ATTR_USERDATA"):
+                    print_str += "%x." % f
+            if self.get_attr("OVS_USERSPACE_ATTR_TUN_PORT") is not None:
+                print_str += "egress_tun_port=%d" % self.get_attr(
+                    "OVS_USERSPACE_ATTR_TUN_PORT"
+                )
+            print_str += ")"
+            return print_str
+
+    def dpstr(self, more=False):
+        print_str = ""
+
+        for field in self.nla_map:
+            if field[1] == "none" or self.get_attr(field[0]) is None:
+                continue
+            if print_str != "":
+                print_str += ","
+
+            if field[1] == "uint32":
+                if field[0] == "OVS_ACTION_ATTR_OUTPUT":
+                    print_str += "%d" % int(self.get_attr(field[0]))
+                elif field[0] == "OVS_ACTION_ATTR_RECIRC":
+                    print_str += "recirc(0x%x)" % int(self.get_attr(field[0]))
+                elif field[0] == "OVS_ACTION_ATTR_TRUNC":
+                    print_str += "trunc(%d)" % int(self.get_attr(field[0]))
+            elif field[1] == "flag":
+                if field[0] == "OVS_ACTION_ATTR_CT_CLEAR":
+                    print_str += "ct_clear"
+                elif field[0] == "OVS_ACTION_ATTR_POP_VLAN":
+                    print_str += "pop_vlan"
+                elif field[0] == "OVS_ACTION_ATTR_POP_ETH":
+                    print_str += "pop_eth"
+                elif field[0] == "OVS_ACTION_ATTR_POP_NSH":
+                    print_str += "pop_nsh"
+                elif field[0] == "OVS_ACTION_ATTR_POP_MPLS":
+                    print_str += "pop_mpls"
+            else:
+                datum = self.get_attr(field[0])
+                print_str += datum.dpstr(more)
+
+        return print_str
+
+
+class ovskey(nla):
+    nla_flags = NLA_F_NESTED
+    nla_map = (
+        ("OVS_KEY_ATTR_UNSPEC", "none"),
+        ("OVS_KEY_ATTR_ENCAP", "none"),
+        ("OVS_KEY_ATTR_PRIORITY", "uint32"),
+        ("OVS_KEY_ATTR_IN_PORT", "uint32"),
+        ("OVS_KEY_ATTR_ETHERNET", "ethaddr"),
+        ("OVS_KEY_ATTR_VLAN", "uint16"),
+        ("OVS_KEY_ATTR_ETHERTYPE", "be16"),
+        ("OVS_KEY_ATTR_IPV4", "ovs_key_ipv4"),
+        ("OVS_KEY_ATTR_IPV6", "ovs_key_ipv6"),
+        ("OVS_KEY_ATTR_TCP", "ovs_key_tcp"),
+        ("OVS_KEY_ATTR_UDP", "ovs_key_udp"),
+        ("OVS_KEY_ATTR_ICMP", "ovs_key_icmp"),
+        ("OVS_KEY_ATTR_ICMPV6", "ovs_key_icmpv6"),
+        ("OVS_KEY_ATTR_ARP", "ovs_key_arp"),
+        ("OVS_KEY_ATTR_ND", "ovs_key_nd"),
+        ("OVS_KEY_ATTR_SKB_MARK", "uint32"),
+        ("OVS_KEY_ATTR_TUNNEL", "none"),
+        ("OVS_KEY_ATTR_SCTP", "ovs_key_sctp"),
+        ("OVS_KEY_ATTR_TCP_FLAGS", "be16"),
+        ("OVS_KEY_ATTR_DP_HASH", "uint32"),
+        ("OVS_KEY_ATTR_RECIRC_ID", "uint32"),
+        ("OVS_KEY_ATTR_MPLS", "array(ovs_key_mpls)"),
+        ("OVS_KEY_ATTR_CT_STATE", "uint32"),
+        ("OVS_KEY_ATTR_CT_ZONE", "uint16"),
+        ("OVS_KEY_ATTR_CT_MARK", "uint32"),
+        ("OVS_KEY_ATTR_CT_LABELS", "none"),
+        ("OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4", "ovs_key_ct_tuple_ipv4"),
+        ("OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6", "ovs_key_ct_tuple_ipv6"),
+        ("OVS_KEY_ATTR_NSH", "none"),
+        ("OVS_KEY_ATTR_PACKET_TYPE", "none"),
+        ("OVS_KEY_ATTR_ND_EXTENSIONS", "none"),
+        ("OVS_KEY_ATTR_TUNNEL_INFO", "none"),
+        ("OVS_KEY_ATTR_IPV6_EXTENSIONS", "none"),
+    )
+
+    class ovs_key_proto(nla):
+        fields = (
+            ("src", "!H"),
+            ("dst", "!H"),
+        )
+
+        fields_map = (
+            ("src", "src", "%d", lambda x: int(x) if x is not None else 0),
+            ("dst", "dst", "%d", lambda x: int(x) if x is not None else 0),
+        )
+
+        def __init__(
+            self,
+            protostr,
+            data=None,
+            offset=None,
+            parent=None,
+            length=None,
+            init=None,
+        ):
+            self.proto_str = protostr
+            nla.__init__(
+                self,
+                data=data,
+                offset=offset,
+                parent=parent,
+                length=length,
+                init=init,
+            )
+
+        def dpstr(self, masked=None, more=False):
+            outstr = self.proto_str + "("
+            first = False
+            for f in self.fields_map:
+                if first:
+                    outstr += ","
+                if masked is None:
+                    outstr += "%s=" % f[0]
+                    if isinstance(f[2], str):
+                        outstr += f[2] % self[f[1]]
+                    else:
+                        outstr += f[2](self[f[1]])
+                    first = True
+                elif more or f[3](masked[f[1]]) != 0:
+                    outstr += "%s=" % f[0]
+                    if isinstance(f[2], str):
+                        outstr += f[2] % self[f[1]]
+                    else:
+                        outstr += f[2](self[f[1]])
+                    outstr += "/"
+                    if isinstance(f[2], str):
+                        outstr += f[2] % masked[f[1]]
+                    else:
+                        outstr += f[2](masked[f[1]])
+                    first = True
+            outstr += ")"
+            return outstr
+
+    class ethaddr(ovs_key_proto):
+        fields = (
+            ("src", "!6s"),
+            ("dst", "!6s"),
+        )
+
+        fields_map = (
+            (
+                "src",
+                "src",
+                macstr,
+                lambda x: int.from_bytes(x, "big"),
+                convert_mac,
+            ),
+            (
+                "dst",
+                "dst",
+                macstr,
+                lambda x: int.from_bytes(x, "big"),
+                convert_mac,
+            ),
+        )
+
+        def __init__(
+            self,
+            data=None,
+            offset=None,
+            parent=None,
+            length=None,
+            init=None,
+        ):
+            ovskey.ovs_key_proto.__init__(
+                self,
+                "eth",
+                data=data,
+                offset=offset,
+                parent=parent,
+                length=length,
+                init=init,
+            )
+
+    class ovs_key_ipv4(ovs_key_proto):
+        fields = (
+            ("src", "!I"),
+            ("dst", "!I"),
+            ("proto", "B"),
+            ("tos", "B"),
+            ("ttl", "B"),
+            ("frag", "B"),
+        )
+
+        fields_map = (
+            (
+                "src",
+                "src",
+                lambda x: str(ipaddress.IPv4Address(x)),
+                int,
+                convert_ipv4,
+            ),
+            (
+                "dst",
+                "dst",
+                lambda x: str(ipaddress.IPv4Address(x)),
+                int,
+                convert_ipv4,
+            ),
+            ("proto", "proto", "%d", lambda x: int(x) if x is not None else 0),
+            ("tos", "tos", "%d", lambda x: int(x) if x is not None else 0),
+            ("ttl", "ttl", "%d", lambda x: int(x) if x is not None else 0),
+            ("frag", "frag", "%d", lambda x: int(x) if x is not None else 0),
+        )
+
+        def __init__(
+            self,
+            data=None,
+            offset=None,
+            parent=None,
+            length=None,
+            init=None,
+        ):
+            ovskey.ovs_key_proto.__init__(
+                self,
+                "ipv4",
+                data=data,
+                offset=offset,
+                parent=parent,
+                length=length,
+                init=init,
+            )
+
+    class ovs_key_ipv6(ovs_key_proto):
+        fields = (
+            ("src", "!16s"),
+            ("dst", "!16s"),
+            ("label", "!I"),
+            ("proto", "B"),
+            ("tclass", "B"),
+            ("hlimit", "B"),
+            ("frag", "B"),
+        )
+
+        fields_map = (
+            (
+                "src",
+                "src",
+                lambda x: str(ipaddress.IPv6Address(x)),
+                lambda x: int.from_bytes(x, "big"),
+                lambda x: ipaddress.IPv6Address(x),
+            ),
+            (
+                "dst",
+                "dst",
+                lambda x: str(ipaddress.IPv6Address(x)),
+                lambda x: int.from_bytes(x, "big"),
+                lambda x: ipaddress.IPv6Address(x),
+            ),
+            ("label", "label", "%d", int),
+            ("proto", "proto", "%d", int),
+            ("tclass", "tclass", "%d", int),
+            ("hlimit", "hlimit", "%d", int),
+            ("frag", "frag", "%d", int),
+        )
+
+        def __init__(
+            self,
+            data=None,
+            offset=None,
+            parent=None,
+            length=None,
+            init=None,
+        ):
+            ovskey.ovs_key_proto.__init__(
+                self,
+                "ipv6",
+                data=data,
+                offset=offset,
+                parent=parent,
+                length=length,
+                init=init,
+            )
+
+    class ovs_key_tcp(ovs_key_proto):
+        def __init__(
+            self,
+            data=None,
+            offset=None,
+            parent=None,
+            length=None,
+            init=None,
+        ):
+            ovskey.ovs_key_proto.__init__(
+                self,
+                "tcp",
+                data=data,
+                offset=offset,
+                parent=parent,
+                length=length,
+                init=init,
+            )
+
+    class ovs_key_udp(ovs_key_proto):
+        def __init__(
+            self,
+            data=None,
+            offset=None,
+            parent=None,
+            length=None,
+            init=None,
+        ):
+            ovskey.ovs_key_proto.__init__(
+                self,
+                "udp",
+                data=data,
+                offset=offset,
+                parent=parent,
+                length=length,
+                init=init,
+            )
+
+    class ovs_key_sctp(ovs_key_proto):
+        def __init__(
+            self,
+            data=None,
+            offset=None,
+            parent=None,
+            length=None,
+            init=None,
+        ):
+            ovskey.ovs_key_proto.__init__(
+                self,
+                "sctp",
+                data=data,
+                offset=offset,
+                parent=parent,
+                length=length,
+                init=init,
+            )
+
+    class ovs_key_icmp(ovs_key_proto):
+        fields = (
+            ("type", "B"),
+            ("code", "B"),
+        )
+
+        fields_map = (
+            ("type", "type", "%d", int),
+            ("code", "code", "%d", int),
+        )
+
+        def __init__(
+            self,
+            data=None,
+            offset=None,
+            parent=None,
+            length=None,
+            init=None,
+        ):
+            ovskey.ovs_key_proto.__init__(
+                self,
+                "icmp",
+                data=data,
+                offset=offset,
+                parent=parent,
+                length=length,
+                init=init,
+            )
+
+    class ovs_key_icmpv6(ovs_key_icmp):
+        def __init__(
+            self,
+            data=None,
+            offset=None,
+            parent=None,
+            length=None,
+            init=None,
+        ):
+            ovskey.ovs_key_proto.__init__(
+                self,
+                "icmpv6",
+                data=data,
+                offset=offset,
+                parent=parent,
+                length=length,
+                init=init,
+            )
+
+    class ovs_key_arp(ovs_key_proto):
+        fields = (
+            ("sip", "!I"),
+            ("tip", "!I"),
+            ("op", "!H"),
+            ("sha", "!6s"),
+            ("tha", "!6s"),
+            ("pad", "xx"),
+        )
+
+        fields_map = (
+            (
+                "sip",
+                "sip",
+                lambda x: str(ipaddress.IPv4Address(x)),
+                int,
+                convert_ipv4,
+            ),
+            (
+                "tip",
+                "tip",
+                lambda x: str(ipaddress.IPv4Address(x)),
+                int,
+                convert_ipv4,
+            ),
+            ("op", "op", "%d", lambda x: int(x) if x is not None else 0),
+            (
+                "sha",
+                "sha",
+                macstr,
+                lambda x: int.from_bytes(x, "big"),
+                convert_mac,
+            ),
+            (
+                "tha",
+                "tha",
+                macstr,
+                lambda x: int.from_bytes(x, "big"),
+                convert_mac,
+            ),
+        )
+
+        def __init__(
+            self,
+            data=None,
+            offset=None,
+            parent=None,
+            length=None,
+            init=None,
+        ):
+            ovskey.ovs_key_proto.__init__(
+                self,
+                "arp",
+                data=data,
+                offset=offset,
+                parent=parent,
+                length=length,
+                init=init,
+            )
+
+    class ovs_key_nd(ovs_key_proto):
+        fields = (
+            ("target", "!16s"),
+            ("sll", "!6s"),
+            ("tll", "!6s"),
+        )
+
+        fields_map = (
+            (
+                "target",
+                "target",
+                lambda x: str(ipaddress.IPv6Address(x)),
+                lambda x: int.from_bytes(x, "big"),
+            ),
+            ("sll", "sll", macstr, lambda x: int.from_bytes(x, "big")),
+            ("tll", "tll", macstr, lambda x: int.from_bytes(x, "big")),
+        )
+
+        def __init__(
+            self,
+            data=None,
+            offset=None,
+            parent=None,
+            length=None,
+            init=None,
+        ):
+            ovskey.ovs_key_proto.__init__(
+                self,
+                "nd",
+                data=data,
+                offset=offset,
+                parent=parent,
+                length=length,
+                init=init,
+            )
+
+    class ovs_key_ct_tuple_ipv4(ovs_key_proto):
+        fields = (
+            ("src", "!I"),
+            ("dst", "!I"),
+            ("tp_src", "!H"),
+            ("tp_dst", "!H"),
+            ("proto", "B"),
+        )
+
+        fields_map = (
+            (
+                "src",
+                "src",
+                lambda x: str(ipaddress.IPv4Address(x)),
+                int,
+            ),
+            (
+                "dst",
+                "dst",
+                lambda x: str(ipaddress.IPv6Address(x)),
+                int,
+            ),
+            ("tp_src", "tp_src", "%d", int),
+            ("tp_dst", "tp_dst", "%d", int),
+            ("proto", "proto", "%d", int),
+        )
+
+        def __init__(
+            self,
+            data=None,
+            offset=None,
+            parent=None,
+            length=None,
+            init=None,
+        ):
+            ovskey.ovs_key_proto.__init__(
+                self,
+                "ct_tuple4",
+                data=data,
+                offset=offset,
+                parent=parent,
+                length=length,
+                init=init,
+            )
+
+    class ovs_key_ct_tuple_ipv6(nla):
+        fields = (
+            ("src", "!16s"),
+            ("dst", "!16s"),
+            ("tp_src", "!H"),
+            ("tp_dst", "!H"),
+            ("proto", "B"),
+        )
+
+        fields_map = (
+            (
+                "src",
+                "src",
+                lambda x: str(ipaddress.IPv6Address(x)),
+                lambda x: int.from_bytes(x, "big", convertmac),
+            ),
+            (
+                "dst",
+                "dst",
+                lambda x: str(ipaddress.IPv6Address(x)),
+                lambda x: int.from_bytes(x, "big"),
+            ),
+            ("tp_src", "tp_src", "%d", int),
+            ("tp_dst", "tp_dst", "%d", int),
+            ("proto", "proto", "%d", int),
+        )
+
+        def __init__(
+            self,
+            data=None,
+            offset=None,
+            parent=None,
+            length=None,
+            init=None,
+        ):
+            ovskey.ovs_key_proto.__init__(
+                self,
+                "ct_tuple6",
+                data=data,
+                offset=offset,
+                parent=parent,
+                length=length,
+                init=init,
+            )
+
+    class ovs_key_mpls(nla):
+        fields = (("lse", ">I"),)
+
+    def dpstr(self, mask=None, more=False):
+        print_str = ""
+
+        for field in (
+            (
+                "OVS_KEY_ATTR_PRIORITY",
+                "skb_priority",
+                "%d",
+                lambda x: False,
+                True,
+            ),
+            (
+                "OVS_KEY_ATTR_SKB_MARK",
+                "skb_mark",
+                "%d",
+                lambda x: False,
+                True,
+            ),
+            (
+                "OVS_KEY_ATTR_RECIRC_ID",
+                "recirc_id",
+                "0x%08X",
+                lambda x: False,
+                True,
+            ),
+            (
+                "OVS_KEY_ATTR_DP_HASH",
+                "dp_hash",
+                "0x%08X",
+                lambda x: False,
+                True,
+            ),
+            (
+                "OVS_KEY_ATTR_CT_STATE",
+                "ct_state",
+                "0x%04x",
+                lambda x: False,
+                True,
+            ),
+            (
+                "OVS_KEY_ATTR_CT_ZONE",
+                "ct_zone",
+                "0x%04x",
+                lambda x: False,
+                True,
+            ),
+            (
+                "OVS_KEY_ATTR_CT_MARK",
+                "ct_mark",
+                "0x%08x",
+                lambda x: False,
+                True,
+            ),
+            (
+                "OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4",
+                None,
+                None,
+                False,
+                False,
+            ),
+            (
+                "OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6",
+                None,
+                None,
+                False,
+                False,
+            ),
+            (
+                "OVS_KEY_ATTR_IN_PORT",
+                "in_port",
+                "%d",
+                lambda x: True,
+                True,
+            ),
+            ("OVS_KEY_ATTR_ETHERNET", None, None, False, False),
+            (
+                "OVS_KEY_ATTR_ETHERTYPE",
+                "eth_type",
+                "0x%04x",
+                lambda x: int(x) == 0xFFFF,
+                True,
+            ),
+            ("OVS_KEY_ATTR_IPV4", None, None, False, False),
+            ("OVS_KEY_ATTR_IPV6", None, None, False, False),
+            ("OVS_KEY_ATTR_ARP", None, None, False, False),
+            ("OVS_KEY_ATTR_TCP", None, None, False, False),
+            (
+                "OVS_KEY_ATTR_TCP_FLAGS",
+                "tcp_flags",
+                "0x%04x",
+                lambda x: False,
+                True,
+            ),
+            ("OVS_KEY_ATTR_UDP", None, None, False, False),
+            ("OVS_KEY_ATTR_SCTP", None, None, False, False),
+            ("OVS_KEY_ATTR_ICMP", None, None, False, False),
+            ("OVS_KEY_ATTR_ICMPV6", None, None, False, False),
+            ("OVS_KEY_ATTR_ND", None, None, False, False),
+        ):
+            v = self.get_attr(field[0])
+            if v is not None:
+                m = None if mask is None else mask.get_attr(field[0])
+                if field[4] is False:
+                    print_str += v.dpstr(m, more)
+                    print_str += ","
+                else:
+                    if m is None or field[3](m):
+                        print_str += field[1] + "("
+                        print_str += field[2] % v
+                        print_str += "),"
+                    elif more or m != 0:
+                        print_str += field[1] + "("
+                        print_str += (field[2] % v) + "/" + (field[2] % m)
+                        print_str += "),"
+
+        return print_str
+
+
 class OvsDatapath(GenericNetlinkSocket):
     OVS_DP_F_VPORT_PIDS = 1 << 1
     OVS_DP_F_DISPATCH_UPCALL_PER_CPU = 1 << 3
@@ -300,6 +1177,135 @@ class OvsVport(GenericNetlinkSocket):
         return reply
 
 
+class OvsFlow(GenericNetlinkSocket):
+    class ovs_flow_msg(ovs_dp_msg):
+        nla_map = (
+            ("OVS_FLOW_ATTR_UNSPEC", "none"),
+            ("OVS_FLOW_ATTR_KEY", "ovskey"),
+            ("OVS_FLOW_ATTR_ACTIONS", "ovsactions"),
+            ("OVS_FLOW_ATTR_STATS", "flowstats"),
+            ("OVS_FLOW_ATTR_TCP_FLAGS", "uint8"),
+            ("OVS_FLOW_ATTR_USED", "uint64"),
+            ("OVS_FLOW_ATTR_CLEAR", "none"),
+            ("OVS_FLOW_ATTR_MASK", "ovskey"),
+            ("OVS_FLOW_ATTR_PROBE", "none"),
+            ("OVS_FLOW_ATTR_UFID", "array(uint32)"),
+            ("OVS_FLOW_ATTR_UFID_FLAGS", "uint32"),
+        )
+
+        class flowstats(nla):
+            fields = (
+                ("packets", "=Q"),
+                ("bytes", "=Q"),
+            )
+
+        def dpstr(self, more=False):
+            ufid = self.get_attr("OVS_FLOW_ATTR_UFID")
+            ufid_str = ""
+            if ufid is not None:
+                ufid_str = (
+                    "ufid:{:08x}-{:04x}-{:04x}-{:04x}-{:04x}{:08x}".format(
+                        ufid[0],
+                        ufid[1] >> 16,
+                        ufid[1] & 0xFFFF,
+                        ufid[2] >> 16,
+                        ufid[2] & 0,
+                        ufid[3],
+                    )
+                )
+
+            key_field = self.get_attr("OVS_FLOW_ATTR_KEY")
+            keymsg = None
+            if key_field is not None:
+                keymsg = key_field
+
+            mask_field = self.get_attr("OVS_FLOW_ATTR_MASK")
+            maskmsg = None
+            if mask_field is not None:
+                maskmsg = mask_field
+
+            acts_field = self.get_attr("OVS_FLOW_ATTR_ACTIONS")
+            actsmsg = None
+            if acts_field is not None:
+                actsmsg = acts_field
+
+            print_str = ""
+
+            if more:
+                print_str += ufid_str + ","
+
+            if keymsg is not None:
+                print_str += keymsg.dpstr(maskmsg, more)
+
+            stats = self.get_attr("OVS_FLOW_ATTR_STATS")
+            if stats is None:
+                print_str += " packets:0, bytes:0,"
+            else:
+                print_str += " packets:%d, bytes:%d," % (
+                    stats["packets"],
+                    stats["bytes"],
+                )
+
+            used = self.get_attr("OVS_FLOW_ATTR_USED")
+            print_str += " used:"
+            if used is None:
+                print_str += "never,"
+            else:
+                used_time = int(used)
+                cur_time_sec = time.clock_gettime(time.CLOCK_MONOTONIC)
+                used_time = (cur_time_sec * 1000) - used_time
+                print_str += "{}s,".format(used_time / 1000)
+
+            print_str += " actions:"
+            if (
+                actsmsg is None
+                or "attrs" not in actsmsg
+                or len(actsmsg["attrs"]) == 0
+            ):
+                print_str += "drop"
+            else:
+                print_str += actsmsg.dpstr(more)
+
+            return print_str
+
+    def __init__(self):
+        GenericNetlinkSocket.__init__(self)
+
+        self.bind(OVS_FLOW_FAMILY, OvsFlow.ovs_flow_msg)
+
+    def dump(self, dpifindex, flowspec=None):
+        """
+        Returns a list of messages containing flows.
+
+        dpifindex should be a valid datapath obtained by calling
+        into the OvsDatapath lookup
+
+        flowpsec is a string which represents a flow in the dpctl
+        format.
+        """
+        msg = OvsFlow.ovs_flow_msg()
+
+        msg["cmd"] = OVS_FLOW_CMD_GET
+        msg["version"] = OVS_DATAPATH_VERSION
+        msg["reserved"] = 0
+        msg["dpifindex"] = dpifindex
+
+        msg_flags = NLM_F_REQUEST | NLM_F_ACK
+        if flowspec is None:
+            msg_flags |= NLM_F_DUMP
+        rep = None
+
+        try:
+            rep = self.nlm_request(
+                msg,
+                msg_type=self.prid,
+                msg_flags=msg_flags,
+            )
+        except NetlinkError as ne:
+            raise ne
+        return rep
+
+
 def print_ovsdp_full(dp_lookup_rep, ifindex, ndb=NDB(), vpl=OvsVport()):
     dp_name = dp_lookup_rep.get_attr("OVS_DP_ATTR_NAME")
     base_stats = dp_lookup_rep.get_attr("OVS_DP_ATTR_STATS")
@@ -340,12 +1346,16 @@ def print_ovsdp_full(dp_lookup_rep, ifindex, ndb=NDB(), vpl=OvsVport()):
 
 
 def main(argv):
+    nlmsg_atoms.ovskey = ovskey
+    nlmsg_atoms.ovsactions = ovsactions
+
     parser = argparse.ArgumentParser()
     parser.add_argument(
         "-v",
         "--verbose",
         action="count",
         help="Increment 'verbose' output counter.",
+        default=0,
     )
     subparsers = parser.add_subparsers()
 
@@ -387,10 +1397,18 @@ def main(argv):
     delifcmd.add_argument("dpname", help="Datapath Name")
     delifcmd.add_argument("delif", help="Interface name for adding")
 
+    dumpflcmd = subparsers.add_parser("dump-flows")
+    dumpflcmd.add_argument("dumpdp", help="Datapath Name")
+
     args = parser.parse_args()
 
+    if args.verbose > 0:
+        if args.verbose > 1:
+            logging.basicConfig(level=logging.DEBUG)
+
     ovsdp = OvsDatapath()
     ovsvp = OvsVport()
+    ovsflow = OvsFlow()
     ndb = NDB()
 
     if hasattr(args, "showdp"):
@@ -441,6 +1459,14 @@ def main(argv):
             msg += " removed."
         else:
             msg += " failed to remove."
+    elif hasattr(args, "dumpdp"):
+        rep = ovsdp.info(args.dumpdp, 0)
+        if rep is None:
+            print("DP '%s' not found." % args.dumpdp)
+            return 1
+        rep = ovsflow.dump(rep["dpifindex"])
+        for flow in rep:
+            print(flow.dpstr(True if args.verbose > 0 else False))
 
     return 0
 
-- 
2.39.2

