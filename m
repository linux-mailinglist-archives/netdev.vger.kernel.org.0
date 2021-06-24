Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3333F3B2B21
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhFXJLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:11:25 -0400
Received: from aer-iport-1.cisco.com ([173.38.203.51]:16187 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbhFXJLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 05:11:24 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jun 2021 05:11:23 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3742; q=dns/txt; s=iport;
  t=1624525745; x=1625735345;
  h=from:to:cc:subject:date:message-id;
  bh=h+oyrnzZ0NoEEyQDDsreEFJQT4OxY07jQkHJdIUaE6k=;
  b=MOSmWUgrP6O5rpKtXmOjoTql3mhz8rTgavdklIKcF72/xozZRpTBF/jH
   /R6EGkQDRjpFQw0kiQwVfcDUUYIo90aXaZKUS/G4qYiCfUb+DAFyRg/iT
   Pns+Xr0Fq6X2H+Dq/T7+etGn6R9z19E2iCLf1gmnGixs/XQ+itnKKwSfy
   4=;
X-IronPort-AV: E=Sophos;i="5.83,296,1616457600"; 
   d="scan'208";a="37239248"
Received: from aer-iport-nat.cisco.com (HELO aer-core-1.cisco.com) ([173.38.203.22])
  by aer-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 24 Jun 2021 09:01:50 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-1.cisco.com (8.15.2/8.15.2) with ESMTP id 15O91nko032259;
        Thu, 24 Jun 2021 09:01:49 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, pablo@netfilter.org,
        Georg Kohmann <geokohma@cisco.com>
Subject: [PATCH net] ipv6/netfilter: Drop Packet Too Big with invalid payload
Date:   Thu, 24 Jun 2021 11:01:35 +0200
Message-Id: <20210624090135.22406-1-geokohma@cisco.com>
X-Mailer: git-send-email 2.10.2
X-Outbound-SMTP-Client: 10.47.15.16, rdbuild16.cisco.com
X-Outbound-Node: aer-core-1.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PMTU is updated even though received ICMPv6 PTB do not match any
transmitted traffic. This breaks TAHI IPv6 Core Conformance Test
Revision 5.0.1, v6LC.4.1.12 Validate Packet Too Big[1].

Referring to RFC8201 IPv6 Path MTU Discovery, section 4: "Nodes should
appropriately validate the payload of ICMPv6 PTB messages to ensure
these are received in response to transmitted traffic (i.e., a reported
error condition that corresponds to an IPv6 packet actually sent by the
application) per [ICMPv6]."

nf_conntrack_inet_error() return -NF_ACCEPT if the inner header of
ICMPv6 error packet is not related to an existing connection. Drop PTB
packet when this occur. This will prevent ipv6 from handling the packet
and update the PMTU.

The included test script below use ICMPv6 echo requests and PTB with an
invalid ICMPv6 identifier to check whether the host under test will
ignore the PTB or not. The host should not fragment the last echo
response.

[1] https://www.ipv6ready.org/docs/Core_Conformance_5_0_1.pdf
===== SCRIPT FOR SIMULATING TEST v6LC.4.1.12. =====

from scapy.all import *

def send_packet_too_big(addr, reply, mtu, id):
    reply[ICMPv6EchoReply].id = id
    I=IPv6(dst=addr)
    PacketTooBig=ICMPv6PacketTooBig(mtu=mtu, code=255)
    reply.data = reply.data[:mtu-len(I/PacketTooBig/reply)]
    reply[IPv6].fl = 0
    packet = I/PacketTooBig/reply
    del packet.cksum
    send(packet)

def send_echo_request(addr, payload, id=0, wait=True):
    I=IPv6(dst=addr)
    EchoRequest=ICMPv6EchoRequest(data=payload)
    EchoRequest.id = id
    if wait:
        return sr1(I/EchoRequest, timeout=5)
    else:
        return send(I/EchoRequest)

def validate_packets(addr):
    packets = sniff(filter = "ip6 and host {}".format(addr), timeout=2)
    for packet in packets:
        if IPv6ExtHdrFragment in packet[IPv6]:
            if ICMPv6EchoReply in packet[IPv6][IPv6ExtHdrFragment]:
                print("Fail - Received a fragmented echo")
                return
    print("Success - No fragmented echo reply received")

if __name__ == '__main__':
    print("Simulating IPv6 Core Conformance Test v6LC4.1.12")
    addr = sys.argv[1]
    thread = threading.Thread(target=validate_packets, args=(addr,))
    thread.start()
    echo_reply = send_echo_request(addr, 'A'*1400, id=0)
    if echo_reply:
        send_packet_too_big(addr, echo_reply, mtu=1300, id=1)
        send_echo_request(addr, 'A'*1400, id=0, wait=False)

===== END OF SCRIPT =====

Signed-off-by: Georg Kohmann <geokohma@cisco.com>
---
 net/netfilter/nf_conntrack_proto_icmpv6.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index facd8c6..797cd42 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -139,6 +139,7 @@ int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
 	const struct icmp6hdr *icmp6h;
 	struct icmp6hdr _ih;
 	int type;
+	int ret;
 
 	icmp6h = skb_header_pointer(skb, dataoff, sizeof(_ih), &_ih);
 	if (icmp6h == NULL) {
@@ -167,8 +168,12 @@ int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
 	memcpy(&outer_daddr.ip6, &ipv6_hdr(skb)->daddr,
 	       sizeof(outer_daddr.ip6));
 	dataoff += sizeof(*icmp6h);
-	return nf_conntrack_inet_error(tmpl, skb, dataoff, state,
-				       IPPROTO_ICMPV6, &outer_daddr);
+	ret = nf_conntrack_inet_error(tmpl, skb, dataoff, state,
+				      IPPROTO_ICMPV6, &outer_daddr);
+	if (icmp6h->icmp6_type == ICMPV6_PKT_TOOBIG &&
+	    ret == -NF_ACCEPT)
+		return -NF_DROP;
+	return ret;
 }
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-- 
2.10.2

