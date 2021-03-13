Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5036E339C5E
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 07:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbhCMGgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 01:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhCMGfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 01:35:38 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ED9C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 22:35:38 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id r16so2017247pfh.10
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 22:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GGzb6Y5X23vi+3GSmQR73pHzzE/AiJCSJAg0aeZTavc=;
        b=cKRpTyMbZn7usZ8KihbfQrtGk9Vd40vLog9XxrqL3Wt5bldwg5XvrZfjFPuH1chTmv
         2KJU4xjzDpEdC9LQqFkJtM5EAtwXCHzFkR3vCiHBAz2M/dTo0PHxiwrZD9Al8rHZgjRu
         UuwxGinY7dvuYZ6inkAZyOUGBwq4MuvJTkXqilUvAPf1/aPlSZxkxRgl4IeOn5AUM7g5
         QHB2SuxWDRKVGdRezicbIotV6oVeP84S8Em6JJbH2135hRwA+qM2hpwdbAq2+/6UglX5
         +GdBbDmewcZsCfsIVmn4A0zcrQC8VIS/lbjeg91K0IGno9zdw+4g/1Z81dBIo8uC72Xb
         F2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GGzb6Y5X23vi+3GSmQR73pHzzE/AiJCSJAg0aeZTavc=;
        b=ENl2d3wSWATMIN4SWu3/6abgcZtmp+AXvhj+EhtUMaHW0HLz1LJLowganhHuUvLSA6
         2v+aB4IYX/VghjxdsHy1H6VmXHfBMzJBnyyR6RbtbdWJ+HY6je2qtpnpnvC2q/AzA3B4
         +yL2XxnX6NIsuA/KIWxAXZrRJsgsufN/93B9hdauv+x3LwF7+Ho48dB7gLJ2G3Onisvl
         vatLiKY7ChPF2svare/BQOVU6OaWF2ehZPahgfXS4O+4WIaHk+xH3wLCTETgtw+DEqhc
         biL+GwKXOiXfs4QQyZzvfrTNBe+j03K6VYC2+VTbCmXL4wXw2aVXH9sip/nArwt8oBAS
         ZPuw==
X-Gm-Message-State: AOAM5334Mdva+0CbbNc0Pn91aHrv470lDiS959Mz1/WCjAylljUDki9R
        jX87im38aJ5WaCYBOu0PrMk=
X-Google-Smtp-Source: ABdhPJyFnMTExn5sqsp1l68BnrZfbubVaYLlcn7Z076pJ0cbiSRsDg2sX4hRL+/5aYs5WzlB4UBRbQ==
X-Received: by 2002:a63:695:: with SMTP id 143mr14722752pgg.314.1615617338043;
        Fri, 12 Mar 2021 22:35:38 -0800 (PST)
Received: from localhost.localdomain ([2600:8801:131a:4600:d104:25c:8880:8e65])
        by smtp.googlemail.com with ESMTPSA id cp22sm3922132pjb.15.2021.03.12.22.35.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Mar 2021 22:35:37 -0800 (PST)
From:   ishaangandhi <ishaangandhi@gmail.com>
To:     davem@davemloft.net
Cc:     ishaangandhi@gmail.com, netdev@vger.kernel.org, willemb@google.com
Subject: [PATCH v2] icmp: support rfc5837
Date:   Fri, 12 Mar 2021 22:35:35 -0800
Message-Id: <20210313063535.38608-1-ishaangandhi@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ishaan Gandhi <ishaangandhi@gmail.com>

This patch identifies the interface a packet arrived on when sending
ICMP time exceeded, destination unreachable, and parameter problem
messages, in accordance with RFC 5837.

It was tested by pinging a machine with a ttl of 1, and observing the
response in Wireshark.

Changes since v1:
- Add sysctls, feature is disabled by default
- Device name is always less than 63, so don't check this
- MTU is always included in net_device, so don't check its presence
- Support IPv6 as first class citizen
- Increment lengths via sizeof operator as opposed to int literals
- Initialize more local variables with defaults

Change request still unaddressed:
- Willem pointed out yesterday that `skb_iif` is not guaranteed
to be the iif of the device the packet arrived on. To get around this
I propose adding a `skb_orig_iif` field to sk_buff which will remain
unchanged after rounds. Would this be ok?

Signed-off-by: Ishaan Gandhi <ishaangandhi@gmail.com>

---
 Documentation/networking/ip-sysctl.rst |  10 ++
 include/linux/icmp.h                   |   3 +
 include/net/netns/ipv4.h               |   1 +
 include/net/netns/ipv6.h               |   1 +
 include/uapi/linux/icmp.h              |  26 ++++
 net/ipv4/icmp.c                        | 170 +++++++++++++++++++++++++
 net/ipv4/sysctl_net_ipv4.c             |   7 +
 net/ipv6/af_inet6.c                    |   1 +
 net/ipv6/icmp.c                        |  15 +++
 9 files changed, 234 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 837d51f9e1fa..a54b0c75ca76 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1204,6 +1204,16 @@ icmp_errors_use_inbound_ifaddr - BOOLEAN
 
 	Default: 0
 
+icmp_errors_identify_if - BOOLEAN
+
+	If set non-zero, then the kernel will append an extension
+	object identifying the interface on which the packet
+	which caused the error. The object will contain the ifIndex,
+	interface name, interface IP address, and/or MTU, in accordance
+	with RFC5837.
+
+	Default: 0
+
 igmp_max_memberships - INTEGER
 	Change the maximum number of multicast groups we can subscribe to.
 	Default: 20
diff --git a/include/linux/icmp.h b/include/linux/icmp.h
index 8fc38a34cb20..db1a17dbc338 100644
--- a/include/linux/icmp.h
+++ b/include/linux/icmp.h
@@ -39,4 +39,7 @@ static inline bool icmp_is_err(int type)
 void ip_icmp_error_rfc4884(const struct sk_buff *skb,
 			   struct sock_ee_data_rfc4884 *out);
 
+void icmp_identify_arrival_interface(struct sk_buff *skb, struct net *net, int room,
+				     char *icmph, int ip_version);
+
 #endif	/* _LINUX_ICMP_H */
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 9e36738c1fe1..fd68a47f1130 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -90,6 +90,7 @@ struct netns_ipv4 {
 	int sysctl_icmp_ratelimit;
 	int sysctl_icmp_ratemask;
 	int sysctl_icmp_errors_use_inbound_ifaddr;
+	int sysctl_icmp_errors_identify_if;
 
 	struct local_ports ip_local_ports;
 
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 5ec054473d81..9608e0a82401 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -36,6 +36,7 @@ struct netns_sysctl_ipv6 {
 	int icmpv6_echo_ignore_all;
 	int icmpv6_echo_ignore_multicast;
 	int icmpv6_echo_ignore_anycast;
+	int icmpv6_errors_identify_if;
 	DECLARE_BITMAP(icmpv6_ratemask, ICMPV6_MSG_MAX + 1);
 	unsigned long *icmpv6_ratemask_ptr;
 	int anycast_src_echo_reply;
diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index fb169a50895e..f43ecd3c3677 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -118,4 +118,30 @@ struct icmp_extobj_hdr {
 	__u8		class_type;
 };
 
+/* RFC 5837 Bitmasks */
+#define ICMP_5837_MTU_CTYPE		(1 << 0)
+#define ICMP_5837_NAME_CTYPE		(1 << 1)
+#define ICMP_5837_IP_ADDR_CTYPE		(1 << 2)
+#define ICMP_5837_IF_INDEX_CTYPE	(1 << 3)
+
+#define ICMP_5837_ARRIVAL_ROLE_CTYPE	(0 << 6)
+#define ICMP_5837_SUB_IP_ROLE_CTYPE	(1 << 6)
+#define ICMP_5837_FORWARD_ROLE_CTYPE	(2 << 6)
+#define ICMP_5837_NEXT_HOP_ROLE_CTYPE	(3 << 6)
+
+#define ICMP_5837_MIN_ORIG_LEN 128
+
+/* RFC 5837 Interface IP Address sub-object */
+struct interface_ipv4_addr_sub_obj {
+	__be16 afi;
+	__be16 reserved;
+	__be32 addr;
+};
+
+struct interface_ipv6_addr_sub_obj {
+	__be16 afi;
+	__be16 reserved;
+	__be32 addr[4];
+};
+
 #endif /* _UAPI_LINUX_ICMP_H */
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 793aebf07c2a..a3a8b028fdcf 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -87,6 +87,7 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
+#include <net/addrconf.h>
 #include <net/checksum.h>
 #include <net/xfrm.h>
 #include <net/inet_common.h>
@@ -555,6 +556,169 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	return ERR_PTR(err);
 }
 
+/*  Appends interface identification object to ICMP packet to identify
+ *  the interface on which the original datagram arrived, per RFC 5837.
+ *
+ *  Should only be called on the following messages
+ *  - ICMPv4 Time Exceeded
+ *  - ICMPv4 Destination Unreachable
+ *  - ICMPv4 Parameter Problem
+ *  - ICMPv6 Time Exceeded
+ *  - ICMPv6 Destination Unreachable
+ */
+
+void icmp_identify_arrival_interface(struct sk_buff *skb, struct net *net, int room,
+				     char *icmph, int ip_version)
+{
+	unsigned int ext_len, orig_len, word_aligned_orig_len, offset, extra_space_needed,
+		     if_index, mtu = 0, name_len = 0, name_subobj_len = 0;
+	struct interface_ipv4_addr_sub_obj ip4_addr_subobj = {.addr = 0};
+	struct interface_ipv6_addr_sub_obj ip6_addr_subobj;
+	struct icmp_extobj_hdr *iio_hdr;
+	struct inet6_ifaddr ip6_ifaddr;
+	struct inet6_dev *dev6 = NULL;
+	struct icmp_ext_hdr *ext_hdr;
+	char *name = NULL, ctype;
+	struct net_device *dev;
+	void *subobj_offset;
+
+	if (ip_version != 4 && ip_version != 6) {
+		pr_debug("ip_version must be 4 or 6\n");
+		return;
+	}
+	skb_linearize(skb);
+	if_index = inet_iif(skb);
+	orig_len = skb->len - skb_network_offset(skb);
+
+	// IPv4 messages MUST be 32-bit aligned, IPv6 64-bit aligned
+	if (ip_version == 4) {
+		word_aligned_orig_len = (orig_len + 3) & ~0x03;
+		icmph[6] = word_aligned_orig_len / 4;
+	} else {
+		word_aligned_orig_len = (orig_len + 7) & ~0x07;
+		icmph[5] = word_aligned_orig_len / 8;
+	}
+
+	ctype = ICMP_5837_ARRIVAL_ROLE_CTYPE;
+	ext_len = sizeof(struct icmp_ext_hdr) + sizeof(struct icmp_extobj_hdr);
+
+	// Always add if_index to the IIO
+	ext_len += sizeof(__be32);
+	ctype |= ICMP_5837_IF_INDEX_CTYPE;
+
+	dev = dev_get_by_index(net, if_index);
+	// Try to append IP address, name, and MTU
+	if (dev) {
+		if (ip_version == 4) {
+			ip4_addr_subobj.addr = inet_select_addr(dev, 0, RT_SCOPE_UNIVERSE);
+			if (ip4_addr_subobj.addr) {
+				ip4_addr_subobj.afi = htons(1);
+				ip4_addr_subobj.reserved = 0;
+				ctype |= ICMP_5837_IP_ADDR_CTYPE;
+				ext_len += sizeof(ip4_addr_subobj);
+			}
+		}
+		if (ip_version == 6) {
+			dev6 = in6_dev_get(dev);
+			if (dev6) {
+				ip6_ifaddr = *list_last_entry(&dev6->addr_list,
+							      struct inet6_ifaddr, if_list);
+				memcpy(ip6_addr_subobj.addr, ip6_ifaddr.addr.s6_addr32,
+				       sizeof(ip6_addr_subobj.addr));
+				ip6_addr_subobj.afi = htons(2);
+				ip6_addr_subobj.reserved = 0;
+				ctype |= ICMP_5837_IP_ADDR_CTYPE;
+				ext_len += sizeof(ip6_addr_subobj);
+			}
+		}
+
+		name = dev->name;
+		if (name) {
+			name_len = strlen(name);
+			// 1 extra byte for the length field
+			name_subobj_len = name_len + 1;
+			// Sub-objects must be aligned to 32-bits
+			name_subobj_len = (name_subobj_len + 3) & ~0x03;
+			ctype |= ICMP_5837_NAME_CTYPE;
+			ext_len += name_subobj_len;
+		}
+
+		mtu = dev->mtu;
+		ctype |= ICMP_5837_MTU_CTYPE;
+		ext_len += sizeof(__be32);
+	}
+
+	if (word_aligned_orig_len + ext_len > room) {
+		offset = room - ext_len;
+		extra_space_needed = room - orig_len;
+	} else if (orig_len < ICMP_5837_MIN_ORIG_LEN) {
+		// Original packet must be zero padded to 128 bytes
+		offset = ICMP_5837_MIN_ORIG_LEN;
+		extra_space_needed = offset + ext_len - orig_len;
+	} else {
+		// There is enough room to just add to the end of the packet
+		offset = word_aligned_orig_len;
+		extra_space_needed = ext_len;
+	}
+
+	if (skb_tailroom(skb) < extra_space_needed) {
+		if (pskb_expand_head(skb, 0, extra_space_needed - skb_tailroom(skb), GFP_ATOMIC))
+			return;
+	}
+
+	// Zero-pad from the end of the original message to the beginning of the header
+	if (orig_len < ICMP_5837_MIN_ORIG_LEN) {
+		// Original packet must be zero-padded to 128 bytes
+		memset(skb_network_header(skb) + orig_len, 0, ICMP_5837_MIN_ORIG_LEN - orig_len);
+	} else {
+		// Just zero-pad so the original packet is word aligned
+		memset(skb_network_header(skb) + orig_len, 0, word_aligned_orig_len - orig_len);
+	}
+
+	skb_put(skb, extra_space_needed);
+	ext_hdr = (struct icmp_ext_hdr *)(skb_network_header(skb) + offset);
+	iio_hdr = (struct icmp_extobj_hdr *)(ext_hdr + 1);
+	subobj_offset = (void *)(iio_hdr + 1);
+
+	ext_hdr->reserved1 = 0;
+	ext_hdr->reserved2 = 0;
+	ext_hdr->version = 2;
+	ext_hdr->checksum = 0;
+
+	iio_hdr->length = htons(ext_len - sizeof(struct icmp_ext_hdr));
+	iio_hdr->class_num = 2;
+	iio_hdr->class_type = ctype;
+
+	*(__be32 *)subobj_offset = htonl(if_index);
+	subobj_offset += sizeof(__be32);
+
+	if (ip4_addr_subobj.addr) {
+		*(struct interface_ipv4_addr_sub_obj *)subobj_offset = ip4_addr_subobj;
+		subobj_offset += sizeof(ip4_addr_subobj);
+	}
+
+	if (dev6) {
+		*(struct interface_ipv6_addr_sub_obj *)subobj_offset = ip6_addr_subobj;
+		subobj_offset += sizeof(ip6_addr_subobj);
+	}
+
+	if (name) {
+		*(__u8 *)subobj_offset = name_subobj_len;
+		subobj_offset += sizeof(__u8);
+		memcpy(subobj_offset, name, name_len);
+		memset(subobj_offset + name_len, 0, name_subobj_len - (name_len + sizeof(__u8)));
+		subobj_offset += name_subobj_len - sizeof(__u8);
+	}
+
+	if (mtu) {
+		*(__be32 *)subobj_offset = htonl(mtu);
+		subobj_offset += sizeof(__be32);
+	}
+
+	ext_hdr->checksum =
+		csum_fold(skb_checksum(skb, skb_network_offset(skb) + offset, ext_len, 0));
+}
+
 /*
  *	Send an ICMP message in response to a situation
  *
@@ -731,6 +895,11 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 		room = 576;
 	room -= sizeof(struct iphdr) + icmp_param.replyopts.opt.opt.optlen;
 	room -= sizeof(struct icmphdr);
+	if (net->ipv4.sysctl_icmp_errors_identify_if && (type == ICMP_DEST_UNREACH ||
+	    type == ICMP_TIME_EXCEEDED || type == ICMP_PARAMETERPROB)) {
+		icmp_identify_arrival_interface(skb_in, net, room,
+						(char *)&icmp_param.data.icmph, 4);
+	}
 
 	icmp_param.data_len = skb_in->len - icmp_param.offset;
 	if (icmp_param.data_len > room)
@@ -1349,6 +1518,7 @@ static int __net_init icmp_sk_init(struct net *net)
 	net->ipv4.sysctl_icmp_ratelimit = 1 * HZ;
 	net->ipv4.sysctl_icmp_ratemask = 0x1818;
 	net->ipv4.sysctl_icmp_errors_use_inbound_ifaddr = 0;
+	net->ipv4.sysctl_icmp_errors_identify_if = 0;
 
 	return 0;
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 5653e3b011bf..8a2e6ce2e74e 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -628,6 +628,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
+	{
+		.procname	= "icmp_errors_identify_if",
+		.data		= &init_net.ipv4.sysctl_icmp_errors_identify_if,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
 	{
 		.procname	= "icmp_ratelimit",
 		.data		= &init_net.ipv4.sysctl_icmp_ratelimit,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index b304b882e031..3901c2a99be4 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -939,6 +939,7 @@ static int __net_init inet6_net_init(struct net *net)
 	net->ipv6.sysctl.icmpv6_echo_ignore_all = 0;
 	net->ipv6.sysctl.icmpv6_echo_ignore_multicast = 0;
 	net->ipv6.sysctl.icmpv6_echo_ignore_anycast = 0;
+	net->ipv6.sysctl.icmpv6_errors_identify_if = 0;
 
 	/* By default, rate limit error messages.
 	 * Except for pmtu discovery, it would break it.
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 9df8737ae0d3..f1ae0160cb2b 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -595,6 +595,13 @@ static void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	msg.offset = skb_network_offset(skb);
 	msg.type = type;
 
+	if (net->ipv6.sysctl.icmpv6_errors_identify_if &&
+	    (type == ICMPV6_DEST_UNREACH || type == ICMPV6_TIME_EXCEED)) {
+		icmp_identify_arrival_interface(skb, net,
+			IPV6_MIN_MTU - sizeof(struct ipv6hdr) - sizeof(struct icmp6hdr),
+			(char *)&tmp_hdr, 6);
+	}
+
 	len = skb->len - msg.offset;
 	len = min_t(unsigned int, len, IPV6_MIN_MTU - sizeof(struct ipv6hdr) - sizeof(struct icmp6hdr));
 	if (len < 0) {
@@ -1184,6 +1191,13 @@ static struct ctl_table ipv6_icmp_table_template[] = {
 		.mode		= 0644,
 		.proc_handler = proc_do_large_bitmap,
 	},
+	{
+		.procname	= "errors_identify_if",
+		.data		= &init_net.ipv6.sysctl.icmpv6_errors_identify_if,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler = proc_dointvec,
+	},
 	{ },
 };
 
@@ -1201,6 +1215,7 @@ struct ctl_table * __net_init ipv6_icmp_sysctl_init(struct net *net)
 		table[2].data = &net->ipv6.sysctl.icmpv6_echo_ignore_multicast;
 		table[3].data = &net->ipv6.sysctl.icmpv6_echo_ignore_anycast;
 		table[4].data = &net->ipv6.sysctl.icmpv6_ratemask_ptr;
+		table[5].data = &net->ipv6.sysctl.icmpv6_errors_identify_if;
 	}
 	return table;
 }
-- 
2.25.1

