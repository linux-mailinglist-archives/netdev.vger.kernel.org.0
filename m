Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C86F633E47
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbiKVOEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiKVOEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:04:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AB01D670
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669125794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UR8kD/9jk6i9BBdJZSKcAvF3HRxWCYSnjKDJt9nFEhM=;
        b=EbXL71C20XeqF4J0OQSI/UHui96+DQpCPR8q6xP/9HUcerd9AfdlbpgJVQtWtCz9/Br1Jw
        rkLRgU4qC7tI/kBos8tu7VAW5FNT+mOACHQGAq3qI3JUUAuca2l4MnmvOVinRvsSape5Ph
        uBhUYOew0O3AP3p0sxk5KXb7lenItD4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-kP4iDNrlNKaPfpOSBUHTWA-1; Tue, 22 Nov 2022 09:03:12 -0500
X-MC-Unique: kP4iDNrlNKaPfpOSBUHTWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD89038123AE;
        Tue, 22 Nov 2022 14:03:11 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.16.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E3EF40C6EC6;
        Tue, 22 Nov 2022 14:03:11 +0000 (UTC)
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
Subject: [RFC net-next 3/6] selftests: openvswitch: add flow dump support
Date:   Tue, 22 Nov 2022 09:03:04 -0500
Message-Id: <20221122140307.705112-4-aconole@redhat.com>
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

Add a basic set of fields to print in a 'dpflow' format.  This will be
used by future commits to check for flow fields after parsing, as
well as verifying the flow fields pushed into the kernel from
userspace.

Signed-off-by: Aaron Conole <aconole@redhat.com>
---
 .../selftests/net/openvswitch/ovs-dpctl.py    | 781 +++++++++++++++++-
 1 file changed, 780 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
index 338e9b2cd660..d654fe1fe4e6 100644
--- a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -6,12 +6,16 @@
 
 import argparse
 import errno
+import ipaddress
+import logging
 import sys
+import time
 
 try:
     from pyroute2 import NDB
 
     from pyroute2.netlink import NLM_F_ACK
+    from pyroute2.netlink import NLM_F_DUMP
     from pyroute2.netlink import NLM_F_REQUEST
     from pyroute2.netlink import genlmsg
     from pyroute2.netlink import nla
@@ -40,6 +44,11 @@ OVS_VPORT_CMD_DEL = 2
 OVS_VPORT_CMD_GET = 3
 OVS_VPORT_CMD_SET = 4
 
+OVS_FLOW_CMD_NEW = 1
+OVS_FLOW_CMD_DEL = 2
+OVS_FLOW_CMD_GET = 3
+OVS_FLOW_CMD_SET = 4
+
 
 class ovs_dp_msg(genlmsg):
     # include the OVS version
@@ -302,6 +311,760 @@ class OvsVport(GenericNetlinkSocket):
         return reply
 
 
+def macstr(mac):
+    outstr = ":".join(["%02X" % i for i in mac])
+    return outstr
+
+
+class OvsFlow(GenericNetlinkSocket):
+    class ovs_flow_msg(ovs_dp_msg):
+        nla_map = (
+            ("OVS_FLOW_ATTR_UNSPEC", "none"),
+            ("OVS_FLOW_ATTR_KEY", "nested"),
+            ("OVS_FLOW_ATTR_ACTIONS", "nested"),
+            ("OVS_FLOW_ATTR_STATS", "flowstats"),
+            ("OVS_FLOW_ATTR_TCP_FLAGS", "uint8"),
+            ("OVS_FLOW_ATTR_USED", "uint64"),
+            ("OVS_FLOW_ATTR_CLEAR", "none"),
+            ("OVS_FLOW_ATTR_MASK", "nested"),
+            ("OVS_FLOW_ATTR_PROBE", "none"),
+            ("OVS_FLOW_ATTR_UFID", "array(uint32)"),
+            ("OVS_FLOW_ATTR_UFID_FLAGS", "uint32"),
+        )
+
+        class nestedacts(nla):
+            __slots__ = ()
+
+            nla_map = ()
+
+        class flowstats(nla):
+            fields = (
+                ("packets", "=Q"),
+                ("bytes", "=Q"),
+            )
+
+        class nestedflow(nla):
+            nla_map = (
+                ("OVS_KEY_ATTR_UNSPEC", "none"),
+                ("OVS_KEY_ATTR_ENCAP", "none"),
+                ("OVS_KEY_ATTR_PRIORITY", "uint32"),
+                ("OVS_KEY_ATTR_IN_PORT", "uint32"),
+                ("OVS_KEY_ATTR_ETHERNET", "ethaddr"),
+                ("OVS_KEY_ATTR_VLAN", "uint16"),
+                ("OVS_KEY_ATTR_ETHERTYPE", "be16"),
+                ("OVS_KEY_ATTR_IPV4", "ovs_key_ipv4"),
+                ("OVS_KEY_ATTR_IPV6", "ovs_key_ipv6"),
+                ("OVS_KEY_ATTR_TCP", "ovs_key_tcp"),
+                ("OVS_KEY_ATTR_UDP", "ovs_key_udp"),
+                ("OVS_KEY_ATTR_ICMP", "ovs_key_icmp"),
+                ("OVS_KEY_ATTR_ICMPV6", "ovs_key_icmpv6"),
+                ("OVS_KEY_ATTR_ARP", "ovs_key_arp"),
+                ("OVS_KEY_ATTR_ND", "ovs_key_nd"),
+                ("OVS_KEY_ATTR_SKB_MARK", "uint32"),
+                ("OVS_KEY_ATTR_TUNNEL", "none"),
+                ("OVS_KEY_ATTR_SCTP", "ovs_key_sctp"),
+                ("OVS_KEY_ATTR_TCP_FLAGS", "uint16"),
+                ("OVS_KEY_ATTR_DP_HASH", "uint32"),
+                ("OVS_KEY_ATTR_RECIRC_ID", "uint32"),
+                ("OVS_KEY_ATTR_MPLS", "array(ovs_key_mpls)"),
+                ("OVS_KEY_ATTR_CT_STATE", "uint32"),
+                ("OVS_KEY_ATTR_CT_ZONE", "uint16"),
+                ("OVS_KEY_ATTR_CT_MARK", "uint32"),
+                ("OVS_KEY_ATTR_CT_LABELS", "none"),
+                ("OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4", "ovs_key_ct_tuple_ipv4"),
+                ("OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6", "ovs_key_ct_tuple_ipv6"),
+                ("OVS_KEY_ATTR_NSH", "none"),
+                ("OVS_KEY_ATTR_PACKET_TYPE", "none"),
+                ("OVS_KEY_ATTR_ND_EXTENSIONS", "none"),
+                ("OVS_KEY_ATTR_TUNNEL_INFO", "none"),
+                ("OVS_KEY_ATTR_IPV6_EXTENSIONS", "none"),
+            )
+
+            class ovs_key_proto(nla):
+                fields = (
+                    ("src", "!H"),
+                    ("dst", "!H"),
+                )
+
+                fields_map = (
+                    ("src", "src", "%d", int),
+                    ("dst", "dst", "%d", int),
+                )
+
+                def __init__(
+                    self,
+                    protostr,
+                    data=None,
+                    offset=None,
+                    parent=None,
+                    length=None,
+                    init=None,
+                ):
+                    self.proto_str = protostr
+                    nla.__init__(
+                        self,
+                        data=data,
+                        offset=offset,
+                        parent=parent,
+                        length=length,
+                        init=init,
+                    )
+
+                def dpstr(self, masked=None, more=False):
+                    outstr = self.proto_str + "("
+                    first = False
+                    for f in self.fields_map:
+                        if first:
+                            outstr += ","
+                        if masked is None:
+                            outstr += "%s=" % f[0]
+                            if isinstance(f[2], str):
+                                outstr += f[2] % self[f[1]]
+                            else:
+                                outstr += f[2](self[f[1]])
+                            first = True
+                        elif more or f[3](masked[f[1]]) != 0:
+                            outstr += "%s=" % f[0]
+                            if isinstance(f[2], str):
+                                outstr += f[2] % self[f[1]]
+                            else:
+                                outstr += f[2](self[f[1]])
+                            outstr += "/"
+                            if isinstance(f[2], str):
+                                outstr += f[2] % masked[f[1]]
+                            else:
+                                outstr += f[2](masked[f[1]])
+                            first = True
+                    outstr += ")"
+                    return outstr
+
+            class ethaddr(ovs_key_proto):
+                fields = (
+                    ("src", "!6s"),
+                    ("dst", "!6s"),
+                )
+
+                fields_map = (
+                    ("src", "src", macstr, lambda x: int.from_bytes(x, "big")),
+                    ("dst", "dst", macstr, lambda x: int.from_bytes(x, "big")),
+                )
+
+                def __init__(
+                    self,
+                    data=None,
+                    offset=None,
+                    parent=None,
+                    length=None,
+                    init=None,
+                ):
+                    OvsFlow.ovs_flow_msg.nestedflow.ovs_key_proto.__init__(
+                        self,
+                        "eth",
+                        data=data,
+                        offset=offset,
+                        parent=parent,
+                        length=length,
+                        init=init,
+                    )
+
+            class ovs_key_ipv4(ovs_key_proto):
+                fields = (
+                    ("src", "!I"),
+                    ("dst", "!I"),
+                    ("proto", "B"),
+                    ("tos", "B"),
+                    ("ttl", "B"),
+                    ("frag", "B"),
+                )
+
+                fields_map = (
+                    (
+                        "src",
+                        "src",
+                        lambda x: str(ipaddress.IPv4Address(x)),
+                        int,
+                    ),
+                    (
+                        "dst",
+                        "dst",
+                        lambda x: str(ipaddress.IPv4Address(x)),
+                        int,
+                    ),
+                    ("proto", "proto", "%d", int),
+                    ("tos", "tos", "%d", int),
+                    ("ttl", "ttl", "%d", int),
+                    ("frag", "frag", "%d", int),
+                )
+
+                def __init__(
+                    self,
+                    data=None,
+                    offset=None,
+                    parent=None,
+                    length=None,
+                    init=None,
+                ):
+                    OvsFlow.ovs_flow_msg.nestedflow.ovs_key_proto.__init__(
+                        self,
+                        "ipv4",
+                        data=data,
+                        offset=offset,
+                        parent=parent,
+                        length=length,
+                        init=init,
+                    )
+
+            class ovs_key_ipv6(ovs_key_proto):
+                fields = (
+                    ("src", "!16s"),
+                    ("dst", "!16s"),
+                    ("label", "!I"),
+                    ("proto", "B"),
+                    ("tclass", "B"),
+                    ("hlimit", "B"),
+                    ("frag", "B"),
+                )
+
+                fields_map = (
+                    (
+                        "src",
+                        "src",
+                        lambda x: str(ipaddress.IPv6Address(x)),
+                        lambda x: int.from_bytes(x, "big"),
+                    ),
+                    (
+                        "dst",
+                        "dst",
+                        lambda x: str(ipaddress.IPv6Address(x)),
+                        lambda x: int.from_bytes(x, "big"),
+                    ),
+                    ("label", "label", "%d", int),
+                    ("proto", "proto", "%d", int),
+                    ("tclass", "tclass", "%d", int),
+                    ("hlimit", "hlimit", "%d", int),
+                    ("frag", "frag", "%d", int),
+                )
+
+                def __init__(
+                    self,
+                    data=None,
+                    offset=None,
+                    parent=None,
+                    length=None,
+                    init=None,
+                ):
+                    OvsFlow.ovs_flow_msg.nestedflow.ovs_key_proto.__init__(
+                        self,
+                        "ipv6",
+                        data=data,
+                        offset=offset,
+                        parent=parent,
+                        length=length,
+                        init=init,
+                    )
+
+            class ovs_key_tcp(ovs_key_proto):
+                def __init__(
+                    self,
+                    data=None,
+                    offset=None,
+                    parent=None,
+                    length=None,
+                    init=None,
+                ):
+                    OvsFlow.ovs_flow_msg.nestedflow.ovs_key_proto.__init__(
+                        self,
+                        "tcp",
+                        data=data,
+                        offset=offset,
+                        parent=parent,
+                        length=length,
+                        init=init,
+                    )
+
+            class ovs_key_udp(ovs_key_proto):
+                def __init__(
+                    self,
+                    data=None,
+                    offset=None,
+                    parent=None,
+                    length=None,
+                    init=None,
+                ):
+                    OvsFlow.ovs_flow_msg.nestedflow.ovs_key_proto.__init__(
+                        self,
+                        "udp",
+                        data=data,
+                        offset=offset,
+                        parent=parent,
+                        length=length,
+                        init=init,
+                    )
+
+            class ovs_key_sctp(ovs_key_proto):
+                def __init__(
+                    self,
+                    data=None,
+                    offset=None,
+                    parent=None,
+                    length=None,
+                    init=None,
+                ):
+                    OvsFlow.ovs_flow_msg.nestedflow.ovs_key_proto.__init__(
+                        self,
+                        "sctp",
+                        data=data,
+                        offset=offset,
+                        parent=parent,
+                        length=length,
+                        init=init,
+                    )
+
+            class ovs_key_icmp(ovs_key_proto):
+                fields = (
+                    ("type", "B"),
+                    ("code", "B"),
+                )
+
+                fields_map = (
+                    ("type", "type", "%d", int),
+                    ("code", "code", "%d", int),
+                )
+
+                def __init__(
+                    self,
+                    data=None,
+                    offset=None,
+                    parent=None,
+                    length=None,
+                    init=None,
+                ):
+                    OvsFlow.ovs_flow_msg.nestedflow.ovs_key_proto.__init__(
+                        self,
+                        "icmp",
+                        data=data,
+                        offset=offset,
+                        parent=parent,
+                        length=length,
+                        init=init,
+                    )
+
+            class ovs_key_icmpv6(ovs_key_icmp):
+                def __init__(
+                    self,
+                    data=None,
+                    offset=None,
+                    parent=None,
+                    length=None,
+                    init=None,
+                ):
+                    OvsFlow.ovs_flow_msg.nestedflow.ovs_key_proto.__init__(
+                        self,
+                        "icmpv6",
+                        data=data,
+                        offset=offset,
+                        parent=parent,
+                        length=length,
+                        init=init,
+                    )
+
+            class ovs_key_arp(ovs_key_proto):
+                fields = (
+                    ("sip", "!I"),
+                    ("tip", "!I"),
+                    ("op", "!H"),
+                    ("sha", "!6s"),
+                    ("tha", "!6s"),
+                    ("pad", "xx"),
+                )
+
+                fields_map = (
+                    (
+                        "sip",
+                        "sip",
+                        lambda x: str(ipaddress.IPv4Address(x)),
+                        int,
+                    ),
+                    (
+                        "tip",
+                        "tip",
+                        lambda x: str(ipaddress.IPv4Address(x)),
+                        int,
+                    ),
+                    ("op", "op", "%d", int),
+                    ("sha", "sha", macstr, lambda x: int.from_bytes(x, "big")),
+                    ("tha", "tha", macstr, lambda x: int.from_bytes(x, "big")),
+                )
+
+                def __init__(
+                    self,
+                    data=None,
+                    offset=None,
+                    parent=None,
+                    length=None,
+                    init=None,
+                ):
+                    OvsFlow.ovs_flow_msg.nestedflow.ovs_key_proto.__init__(
+                        self,
+                        "arp",
+                        data=data,
+                        offset=offset,
+                        parent=parent,
+                        length=length,
+                        init=init,
+                    )
+
+            class ovs_key_nd(ovs_key_proto):
+                fields = (
+                    ("target", "!16s"),
+                    ("sll", "!6s"),
+                    ("tll", "!6s"),
+                )
+
+                fields_map = (
+                    (
+                        "target",
+                        "target",
+                        lambda x: str(ipaddress.IPv6Address(x)),
+                        lambda x: int.from_bytes(x, "big"),
+                    ),
+                    ("sll", "sll", macstr, lambda x: int.from_bytes(x, "big")),
+                    ("tll", "tll", macstr, lambda x: int.from_bytes(x, "big")),
+                )
+
+                def __init__(
+                    self,
+                    data=None,
+                    offset=None,
+                    parent=None,
+                    length=None,
+                    init=None,
+                ):
+                    OvsFlow.ovs_flow_msg.nestedflow.ovs_key_proto.__init__(
+                        self,
+                        "nd",
+                        data=data,
+                        offset=offset,
+                        parent=parent,
+                        length=length,
+                        init=init,
+                    )
+
+            class ovs_key_ct_tuple_ipv4(ovs_key_proto):
+                fields = (
+                    ("src", "!I"),
+                    ("dst", "!I"),
+                    ("tp_src", "!H"),
+                    ("tp_dst", "!H"),
+                    ("proto", "B"),
+                )
+
+                fields_map = (
+                    (
+                        "src",
+                        "src",
+                        lambda x: str(ipaddress.IPv4Address(x)),
+                        int,
+                    ),
+                    (
+                        "dst",
+                        "dst",
+                        lambda x: str(ipaddress.IPv6Address(x)),
+                        int,
+                    ),
+                    ("tp_src", "tp_src", "%d", int),
+                    ("tp_dst", "tp_dst", "%d", int),
+                    ("proto", "proto", "%d", int),
+                )
+
+                def __init__(
+                    self,
+                    data=None,
+                    offset=None,
+                    parent=None,
+                    length=None,
+                    init=None,
+                ):
+                    OvsFlow.ovs_flow_msg.nestedflow.ovs_key_proto.__init__(
+                        self,
+                        "ct_tuple4",
+                        data=data,
+                        offset=offset,
+                        parent=parent,
+                        length=length,
+                        init=init,
+                    )
+
+            class ovs_key_ct_tuple_ipv6(nla):
+                fields = (
+                    ("src", "!16s"),
+                    ("dst", "!16s"),
+                    ("tp_src", "!H"),
+                    ("tp_dst", "!H"),
+                    ("proto", "B"),
+                )
+
+                fields_map = (
+                    (
+                        "src",
+                        "src",
+                        lambda x: str(ipaddress.IPv6Address(x)),
+                        lambda x: int.from_bytes(x, "big"),
+                    ),
+                    (
+                        "dst",
+                        "dst",
+                        lambda x: str(ipaddress.IPv6Address(x)),
+                        lambda x: int.from_bytes(x, "big"),
+                    ),
+                    ("tp_src", "tp_src", "%d", int),
+                    ("tp_dst", "tp_dst", "%d", int),
+                    ("proto", "proto", "%d", int),
+                )
+
+                def __init__(
+                    self,
+                    data=None,
+                    offset=None,
+                    parent=None,
+                    length=None,
+                    init=None,
+                ):
+                    OvsFlow.ovs_flow_msg.nestedflow.ovs_key_proto.__init__(
+                        self,
+                        "ct_tuple6",
+                        data=data,
+                        offset=offset,
+                        parent=parent,
+                        length=length,
+                        init=init,
+                    )
+
+            class ovs_key_mpls(nla):
+                fields = (("lse", ">I"),)
+
+            def dpstr(self, mask=None, more=False):
+                print_str = ""
+
+                for field in (
+                    (
+                        "OVS_KEY_ATTR_PRIORITY",
+                        "skb_priority",
+                        "%d",
+                        lambda x: False,
+                        True,
+                    ),
+                    (
+                        "OVS_KEY_ATTR_SKB_MARK",
+                        "skb_mark",
+                        "%d",
+                        lambda x: False,
+                        True,
+                    ),
+                    (
+                        "OVS_KEY_ATTR_RECIRC_ID",
+                        "recirc_id",
+                        "0x%08X",
+                        lambda x: False,
+                        True,
+                    ),
+                    (
+                        "OVS_KEY_ATTR_DP_HASH",
+                        "dp_hash",
+                        "0x%08X",
+                        lambda x: False,
+                        True,
+                    ),
+                    (
+                        "OVS_KEY_ATTR_CT_STATE",
+                        "ct_state",
+                        "0x%04x",
+                        lambda x: False,
+                        True,
+                    ),
+                    (
+                        "OVS_KEY_ATTR_CT_ZONE",
+                        "ct_zone",
+                        "0x%04x",
+                        lambda x: False,
+                        True,
+                    ),
+                    (
+                        "OVS_KEY_ATTR_CT_MARK",
+                        "ct_mark",
+                        "0x%08x",
+                        lambda x: False,
+                        True,
+                    ),
+                    (
+                        "OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4",
+                        None,
+                        None,
+                        False,
+                        False,
+                    ),
+                    (
+                        "OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6",
+                        None,
+                        None,
+                        False,
+                        False,
+                    ),
+                    (
+                        "OVS_KEY_ATTR_IN_PORT",
+                        "in_port",
+                        "%d",
+                        lambda x: True,
+                        True,
+                    ),
+                    ("OVS_KEY_ATTR_ETHERNET", None, None, False, False),
+                    (
+                        "OVS_KEY_ATTR_ETHERTYPE",
+                        "eth_type",
+                        "0x%04x",
+                        lambda x: int(x) == 0xFFFF,
+                        True,
+                    ),
+                    ("OVS_KEY_ATTR_IPV4", None, None, False, False),
+                    ("OVS_KEY_ATTR_IPV6", None, None, False, False),
+                    ("OVS_KEY_ATTR_ARP", None, None, False, False),
+                    ("OVS_KEY_ATTR_TCP", None, None, False, False),
+                    (
+                        "OVS_KEY_ATTR_TCP_FLAGS",
+                        "tcp_flags",
+                        "0x%04x",
+                        lambda x: False,
+                        True,
+                    ),
+                    ("OVS_KEY_ATTR_UDP", None, None, False, False),
+                    ("OVS_KEY_ATTR_SCTP", None, None, False, False),
+                    ("OVS_KEY_ATTR_ICMP", None, None, False, False),
+                    ("OVS_KEY_ATTR_ICMPV6", None, None, False, False),
+                    ("OVS_KEY_ATTR_ND", None, None, False, False),
+                ):
+                    v = self.get_attr(field[0])
+                    if v is not None:
+                        m = None if mask is None else mask.get_attr(field[0])
+                        if field[4] is False:
+                            print_str += v.dpstr(m, more)
+                            print_str += ","
+                        else:
+                            if m is None or field[3](m):
+                                print_str += field[1] + "("
+                                print_str += field[2] % v
+                                print_str += "),"
+                            elif more or m != 0:
+                                print_str += field[1] + "("
+                                print_str += (
+                                    (field[2] % v) + "/" + (field[2] % m)
+                                )
+                                print_str += "),"
+
+                return print_str
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
+                keymsg = OvsFlow.ovs_flow_msg.nestedflow(data=key_field)
+                keymsg.decode()
+
+            mask_field = self.get_attr("OVS_FLOW_ATTR_MASK")
+            maskmsg = None
+            if mask_field is not None:
+                maskmsg = OvsFlow.ovs_flow_msg.nestedflow(data=mask_field)
+                maskmsg.decode()
+
+            acts_field = self.get_attr("OVS_FLOW_ATTR_ACTIONS")
+            actsmsg = None
+            if acts_field is not None:
+                actsmsg = OvsFlow.ovs_flow_msg.nestedacts(data=acts_field)
+                actsmsg.decode()
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
+                used_time = (cur_time_sec * 1000 * 1000) - used_time
+                print_str += "{}s,".format(used_time / 1000)
+
+            print_str += " actions:"
+            if actsmsg is None or "attrs" not in actsmsg:
+                print_str += "drop"
+
+            return print_str
+
+    def __init__(self):
+        GenericNetlinkSocket.__init__(self)
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
@@ -348,6 +1111,7 @@ def main(argv):
         "--verbose",
         action="count",
         help="Increment 'verbose' output counter.",
+        default=0,
     )
     subparsers = parser.add_subparsers()
 
@@ -389,10 +1153,18 @@ def main(argv):
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
@@ -445,7 +1217,14 @@ def main(argv):
         else:
             msg += " failed to remove."
         print(msg)
-
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
2.34.3

