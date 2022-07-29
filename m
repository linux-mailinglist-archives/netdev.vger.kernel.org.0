Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14091584B04
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbiG2FSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiG2FR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:17:59 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FF96C12F
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 22:17:58 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id e69so2934840iof.5
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 22:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2+vi8n4wdcimIrSm8wC3WWHwvDIP84lJbqht80Qtm/0=;
        b=CKBeb9ClSZdNjiOgt6A2yA+YzjIvIhAJrgx9pKL7M3V18kMlV+LVzbA9VU4LXsAgK3
         LuvwGbBviUfZ9EbSV/pplApIec80SLIk4k/T8NZn6FaOiXM6or9wkOYcGrM1HemK1Ffn
         Sgqjwhm0f6vFDzwwYaOquF7ifTpQvx3vhagnvKR3RdskmkiAB8sdtabHyu4xY0/UlIM2
         4trhy52Ah2ZBEU3epHv3BjoN3uwf9iTFfKbOlUzjAxf3eq2fsfTz6DetDXmvtdu7oPXf
         BIE6TtHg6SLz8ws/JTVZNaxAXii9SJTvcZdxq0qfW2mw/GT5xHHWAqHh+scf+thK11im
         4P9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2+vi8n4wdcimIrSm8wC3WWHwvDIP84lJbqht80Qtm/0=;
        b=lveiXJXQuzKmJ7+8zW2y2YWi2QPuSwthRcVgq2AekMg+RqMFrViLMTJEPeiGJEWEtF
         pKUP8ZcXU0CHzthYNZVbWokWQBSJj5tQrnbno6dURjApabNkkUVMNmsxy28oOyD80xSl
         mpcPB9kaxBJfdYHa+ziH19nGxqh9/aztDCnEE0Gncqi1HLRls4H+yQ4/y9e1JgBZVuwf
         R9DnZgn37D+3n8QWQengbilrZV0ECxvJSBB4bq1RFx3idK2423SnD9cQPm1sCck94kE3
         IYo1OU3o1FtlT7zCM64iDheGpZcrumFD8e6508QEv623z+y6VJN9uJ6/ZWmx74yypR57
         Sfzg==
X-Gm-Message-State: AJIora9/KjuJpk5uegAzkzhWVEleT8/T/7Ve4vB0/+tVvAqx+IWvScxw
        sW813CW57Kc/Bu3qONZd99LOwqSSrv/jHkRg
X-Google-Smtp-Source: AGRyM1v8g0Jfz/hb+T3uq/GEK8z2gXtpNn+jl76w8qdJid2cdt7Tod8ZYmFzYAE3Uv9aH6oTMoaqJA==
X-Received: by 2002:a05:6638:ac1:b0:341:830e:d439 with SMTP id m1-20020a0566380ac100b00341830ed439mr804901jab.132.1659071875884;
        Thu, 28 Jul 2022 22:17:55 -0700 (PDT)
Received: from localhost (cpec09435e3ea83-cmc09435e3ea81.cpe.net.cable.rogers.com. [99.235.148.253])
        by smtp.gmail.com with UTF8SMTPSA id u21-20020a02c055000000b0033f3a1a1b60sm1233068jam.171.2022.07.28.22.17.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 22:17:55 -0700 (PDT)
From:   Cezar Bulinaru <cbulinaru@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     willemb@google.com, netdev@vger.kernel.org, cbulinaru@gmail.com
Subject: [PATCH v2] net: tap: NULL pointer derefence in dev_parse_header_protocol when skb->dev is null
Date:   Fri, 29 Jul 2022 01:17:38 -0400
Message-Id: <20220729051738.7742-2-cbulinaru@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220729051738.7742-1-cbulinaru@gmail.com>
References: <20220728185640.085c83b6@kernel.org>
 <20220729051738.7742-1-cbulinaru@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes a NULL pointer derefence bug triggered from tap driver.
When tap_get_user calls virtio_net_hdr_to_skb the skb->dev is null
(in tap.c skb->dev is set after the call to virtio_net_hdr_to_skb)
virtio_net_hdr_to_skb calls dev_parse_header_protocol which
needs skb->dev field to be valid.

The line that trigers the bug is in dev_parse_header_protocol
(dev is at offset 0x10 from skb and is stored in RAX register)
  if (!dev->header_ops || !dev->header_ops->parse_protocol)
  22e1:   mov    0x10(%rbx),%rax
  22e5:	  mov    0x230(%rax),%rax

Setting skb->dev before the call in tap.c fixes the issue.

BUG: kernel NULL pointer dereference, address: 0000000000000230
RIP: 0010:virtio_net_hdr_to_skb.constprop.0+0x335/0x410 [tap]
Code: c0 0f 85 b7 fd ff ff eb d4 41 39 c6 77 cf 29 c6 48 89 df 44 01 f6 e8 7a 79 83 c1 48 85 c0 0f 85 d9 fd ff ff eb b7 48 8b 43 10 <48> 8b 80 30 02 00 00 48 85 c0 74 55 48 8b 40 28 48 85 c0 74 4c 48
RSP: 0018:ffffc90005c27c38 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888298f25300 RCX: 0000000000000010
RDX: 0000000000000005 RSI: ffffc90005c27cb6 RDI: ffff888298f25300
RBP: ffffc90005c27c80 R08: 00000000ffffffea R09: 00000000000007e8
R10: ffff88858ec77458 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000014 R14: ffffc90005c27e08 R15: ffffc90005c27cb6
FS:  0000000000000000(0000) GS:ffff88858ec40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000230 CR3: 0000000281408006 CR4: 00000000003706e0
Call Trace:
 tap_get_user+0x3f1/0x540 [tap]
 tap_sendmsg+0x56/0x362 [tap]
 ? get_tx_bufs+0xc2/0x1e0 [vhost_net]
 handle_tx_copy+0x114/0x670 [vhost_net]
 handle_tx+0xb0/0xe0 [vhost_net]
 handle_tx_kick+0x15/0x20 [vhost_net]
 vhost_worker+0x7b/0xc0 [vhost]
 ? vhost_vring_call_reset+0x40/0x40 [vhost]
 kthread+0xfa/0x120
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30

Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>
---
 drivers/net/tap.c                    |  21 +-
 tools/testing/selftests/net/Makefile |   2 +-
 tools/testing/selftests/net/tap.c    | 395 +++++++++++++++++++++++++++
 3 files changed, 409 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/net/tap.c

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index c3d42062559d..557236d51d01 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -716,10 +716,20 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	skb_reset_mac_header(skb);
 	skb->protocol = eth_hdr(skb)->h_proto;
 
+	rcu_read_lock();
+	tap = rcu_dereference(q->tap);
+	if (tap) {
+		skb->dev = tap->dev;
+	} else {
+		kfree_skb(skb);
+		goto post_send;
+	}
+
 	if (vnet_hdr_len) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr,
 					    tap_is_little_endian(q));
 		if (err) {
+			rcu_read_unlock();
 			drop_reason = SKB_DROP_REASON_DEV_HDR;
 			goto err_kfree;
 		}
@@ -732,8 +742,6 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
 		skb_set_network_header(skb, depth);
 
-	rcu_read_lock();
-	tap = rcu_dereference(q->tap);
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
 		skb_zcopy_init(skb, msg_control);
@@ -742,12 +750,9 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 		uarg->callback(NULL, uarg, false);
 	}
 
-	if (tap) {
-		skb->dev = tap->dev;
-		dev_queue_xmit(skb);
-	} else {
-		kfree_skb(skb);
-	}
+	dev_queue_xmit(skb);
+
+post_send:
 	rcu_read_unlock();
 
 	return total_len;
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index db05b3764b77..71e3f9f7f2d6 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -54,7 +54,7 @@ TEST_GEN_FILES += ipsec
 TEST_GEN_FILES += ioam6_parser
 TEST_GEN_FILES += gro
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
-TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls tun
+TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls tun tap
 TEST_GEN_FILES += toeplitz
 TEST_GEN_FILES += cmsg_sender
 TEST_GEN_FILES += stress_reuseport_listen
diff --git a/tools/testing/selftests/net/tap.c b/tools/testing/selftests/net/tap.c
new file mode 100644
index 000000000000..5851b333d705
--- /dev/null
+++ b/tools/testing/selftests/net/tap.c
@@ -0,0 +1,395 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <net/if.h>
+#include <linux/if_tun.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
+#include <sys/ioctl.h>
+#include <sys/socket.h>
+#include <linux/virtio_net.h>
+#include <netinet/ip.h>
+#include <netinet/udp.h>
+#include "../kselftest_harness.h"
+
+static const char param_dev_tap_name[] = "xmacvtap0";
+static const char param_dev_dummy_name[] = "xdummy0";
+static unsigned char param_hwaddr_src[] = { 0x00, 0xfe, 0x98, 0x14, 0x22, 0x42 };
+static unsigned char param_hwaddr_dest[] = {
+	0x00, 0xfe, 0x98, 0x94, 0xd2, 0x43
+};
+
+#define MAX_RTNL_PAYLOAD (2048)
+#define PKT_DATA 0xCB
+#define TEST_PACKET_SZ (sizeof(struct virtio_net_hdr) + ETH_HLEN + ETH_MAX_MTU)
+
+static struct rtattr *rtattr_add(struct nlmsghdr *nh, unsigned short type,
+				 unsigned short len)
+{
+	struct rtattr *rta =
+		(struct rtattr *)((uint8_t *)nh + RTA_ALIGN(nh->nlmsg_len));
+	rta->rta_type = type;
+	rta->rta_len = RTA_LENGTH(len);
+	nh->nlmsg_len = RTA_ALIGN(nh->nlmsg_len) + RTA_ALIGN(rta->rta_len);
+	return rta;
+}
+
+static struct rtattr *rtattr_begin(struct nlmsghdr *nh, unsigned short type)
+{
+	return rtattr_add(nh, type, 0);
+}
+
+static void rtattr_end(struct nlmsghdr *nh, struct rtattr *attr)
+{
+	uint8_t *end = (uint8_t *)nh + nh->nlmsg_len;
+
+	attr->rta_len = end - (uint8_t *)attr;
+}
+
+static struct rtattr *rtattr_add_str(struct nlmsghdr *nh, unsigned short type,
+				     const char *s)
+{
+	struct rtattr *rta = rtattr_add(nh, type, strlen(s));
+
+	memcpy(RTA_DATA(rta), s, strlen(s));
+	return rta;
+}
+
+static struct rtattr *rtattr_add_strsz(struct nlmsghdr *nh, unsigned short type,
+				       const char *s)
+{
+	struct rtattr *rta = rtattr_add(nh, type, strlen(s) + 1);
+
+	strcpy(RTA_DATA(rta), s);
+	return rta;
+}
+
+static struct rtattr *rtattr_add_any(struct nlmsghdr *nh, unsigned short type,
+				     const void *arr, size_t len)
+{
+	struct rtattr *rta = rtattr_add(nh, type, len);
+
+	memcpy(RTA_DATA(rta), arr, len);
+	return rta;
+}
+
+static int dev_create(const char *dev, const char *link_type,
+		      int (*fill_rtattr)(struct nlmsghdr *nh),
+		      int (*fill_info_data)(struct nlmsghdr *nh))
+{
+	struct {
+		struct nlmsghdr nh;
+		struct ifinfomsg info;
+		unsigned char data[MAX_RTNL_PAYLOAD];
+	} req;
+	struct rtattr *link_info, *info_data;
+	int ret, rtnl;
+
+	rtnl = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_ROUTE);
+	if (rtnl < 0) {
+		fprintf(stderr, "%s: socket %s\n", __func__, strerror(errno));
+		return 1;
+	}
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(req.info));
+	req.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE;
+	req.nh.nlmsg_type = RTM_NEWLINK;
+
+	req.info.ifi_family = AF_UNSPEC;
+	req.info.ifi_type = 1;
+	req.info.ifi_index = 0;
+	req.info.ifi_flags = IFF_BROADCAST | IFF_UP;
+	req.info.ifi_change = 0xffffffff;
+
+	rtattr_add_str(&req.nh, IFLA_IFNAME, dev);
+
+	if (fill_rtattr) {
+		ret = fill_rtattr(&req.nh);
+		if (ret)
+			return ret;
+	}
+
+	link_info = rtattr_begin(&req.nh, IFLA_LINKINFO);
+
+	rtattr_add_strsz(&req.nh, IFLA_INFO_KIND, link_type);
+
+	if (fill_info_data) {
+		info_data = rtattr_begin(&req.nh, IFLA_INFO_DATA);
+		ret = fill_info_data(&req.nh);
+		if (ret)
+			return ret;
+		rtattr_end(&req.nh, info_data);
+	}
+
+	rtattr_end(&req.nh, link_info);
+
+	ret = send(rtnl, &req, req.nh.nlmsg_len, 0);
+	if (ret < 0)
+		fprintf(stderr, "%s: send %s\n", __func__, strerror(errno));
+	ret = (unsigned int)ret != req.nh.nlmsg_len;
+
+	close(rtnl);
+	return ret;
+}
+
+static int dev_delete(const char *dev)
+{
+	struct {
+		struct nlmsghdr nh;
+		struct ifinfomsg info;
+		unsigned char data[MAX_RTNL_PAYLOAD];
+	} req;
+	int ret, rtnl;
+
+	rtnl = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_ROUTE);
+	if (rtnl < 0) {
+		fprintf(stderr, "%s: socket %s\n", __func__, strerror(errno));
+		return 1;
+	}
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(req.info));
+	req.nh.nlmsg_flags = NLM_F_REQUEST;
+	req.nh.nlmsg_type = RTM_DELLINK;
+
+	req.info.ifi_family = AF_UNSPEC;
+
+	rtattr_add_str(&req.nh, IFLA_IFNAME, dev);
+
+	ret = send(rtnl, &req, req.nh.nlmsg_len, 0);
+	if (ret < 0)
+		fprintf(stderr, "%s: send %s\n", __func__, strerror(errno));
+
+	ret = (unsigned int)ret != req.nh.nlmsg_len;
+
+	close(rtnl);
+	return ret;
+}
+
+static int macvtap_fill_rtattr(struct nlmsghdr *nh)
+{
+	int ifindex;
+
+	ifindex = if_nametoindex(param_dev_dummy_name);
+	if (ifindex == 0) {
+		fprintf(stderr, "%s: ifindex  %s\n", __func__, strerror(errno));
+		return -errno;
+	}
+
+	rtattr_add_any(nh, IFLA_LINK, &ifindex, sizeof(ifindex));
+	rtattr_add_any(nh, IFLA_ADDRESS, param_hwaddr_src, ETH_ALEN);
+
+	return 0;
+}
+
+static int opentap(const char *devname)
+{
+	int ifindex;
+	char buf[256];
+	int fd;
+	struct ifreq ifr;
+
+	ifindex = if_nametoindex(devname);
+	if (ifindex == 0) {
+		fprintf(stderr, "%s: ifindex %s\n", __func__, strerror(errno));
+		return -errno;
+	}
+
+	sprintf(buf, "/dev/tap%d", ifindex);
+	fd = open(buf, O_RDWR | O_NONBLOCK);
+	if (fd < 0) {
+		fprintf(stderr, "%s: open %s\n", __func__, strerror(errno));
+		return -errno;
+	}
+
+	memset(&ifr, 0, sizeof(ifr));
+	strcpy(ifr.ifr_name, devname);
+	ifr.ifr_flags = IFF_TAP | IFF_NO_PI | IFF_VNET_HDR | IFF_MULTI_QUEUE;
+	if (ioctl(fd, TUNSETIFF, &ifr, sizeof(ifr)) < 0)
+		return -errno;
+	return fd;
+}
+
+FIXTURE(tap)
+{
+	int fd;
+};
+
+FIXTURE_SETUP(tap)
+{
+	int ret;
+
+	ret = dev_create(param_dev_dummy_name, "dummy", NULL, NULL);
+	EXPECT_EQ(ret, 0);
+
+	ret = dev_create(param_dev_tap_name, "macvtap", macvtap_fill_rtattr,
+			 NULL);
+	EXPECT_EQ(ret, 0);
+
+	self->fd = opentap(param_dev_tap_name);
+	ASSERT_GE(self->fd, 0);
+}
+
+FIXTURE_TEARDOWN(tap)
+{
+	int ret;
+
+	if (self->fd != -1)
+		close(self->fd);
+
+	ret = dev_delete(param_dev_dummy_name);
+	EXPECT_EQ(ret, 0);
+
+	ret = dev_delete(param_dev_tap_name);
+	EXPECT_EQ(ret, 0);
+}
+
+size_t build_eth(uint8_t *buf, uint16_t proto)
+{
+	struct ethhdr *eth = (struct ethhdr *)buf;
+
+	eth->h_proto = htons(proto);
+	memcpy(eth->h_source, param_hwaddr_src, ETH_ALEN);
+	memcpy(eth->h_dest, param_hwaddr_dest, ETH_ALEN);
+
+	return ETH_HLEN;
+}
+
+static unsigned long add_csum_hword(const uint16_t *start, int num_u16)
+{
+	unsigned long sum = 0;
+	int i;
+
+	for (i = 0; i < num_u16; i++)
+		sum += start[i];
+
+	return sum;
+}
+
+static uint16_t build_ip_csum(const uint16_t *start, int num_u16,
+			      unsigned long sum)
+{
+	sum += add_csum_hword(start, num_u16);
+
+	while (sum >> 16)
+		sum = (sum & 0xffff) + (sum >> 16);
+
+	return ~sum;
+}
+
+static int build_ipv4_header(uint8_t *buf, int payload_len)
+{
+	struct iphdr *iph = (struct iphdr *)buf;
+
+	iph->ihl = 5;
+	iph->version = 4;
+	iph->ttl = 8;
+	iph->tot_len =
+		htons(sizeof(*iph) + sizeof(struct udphdr) + payload_len);
+	iph->id = htons(1337);
+	iph->protocol = IPPROTO_UDP;
+	iph->saddr = htonl((172 << 24) | (17 << 16) | 2);
+	iph->daddr = htonl((172 << 24) | (17 << 16) | 1);
+	iph->check = build_ip_csum((const uint16_t *)iph, iph->ihl << 1, 0);
+
+	return iph->ihl << 2;
+}
+
+static int build_udp_header(uint8_t *buf, int payload_len, bool csum_off)
+{
+	const int alen = sizeof(uint32_t);
+	struct udphdr *udph = (struct udphdr *)buf;
+	int len = sizeof(*udph) + payload_len;
+
+	udph->source = htons(22);
+	udph->dest = htons(58822);
+	udph->len = htons(len);
+
+	if (csum_off)
+		udph->check = build_ip_csum((const uint16_t *)buf - (2 * alen),
+					    alen,
+					    htons(IPPROTO_UDP) + udph->len);
+	else
+		udph->check = 0;
+
+	return sizeof(*udph);
+}
+
+size_t build_test_packet_valid_udp_csum(uint8_t *buf, size_t payload_len)
+{
+	uint8_t *cur = buf;
+	struct virtio_net_hdr *vh = (struct virtio_net_hdr *)buf;
+
+	vh->hdr_len = ETH_HLEN + sizeof(struct iphdr) + sizeof(struct udphdr);
+	vh->flags = VIRTIO_NET_HDR_F_NEEDS_CSUM;
+	vh->csum_start = ETH_HLEN + sizeof(struct iphdr);
+	vh->csum_offset = __builtin_offsetof(struct udphdr, check);
+	vh->gso_type = VIRTIO_NET_HDR_GSO_UDP;
+	vh->gso_size = ETH_DATA_LEN - sizeof(struct iphdr);
+	cur += sizeof(*vh);
+
+	cur += build_eth(cur, ETH_P_IP);
+	cur += build_ipv4_header(cur, payload_len);
+	cur += build_udp_header(cur, payload_len, true);
+	memset(cur, PKT_DATA, payload_len);
+	cur += payload_len;
+
+	return cur - buf;
+}
+
+size_t build_test_packet_crash_tap_invalid_eth_proto(uint8_t *buf,
+						     size_t payload_len)
+{
+	uint8_t *cur = buf;
+	struct virtio_net_hdr *vh = (struct virtio_net_hdr *)buf;
+
+	vh->hdr_len = ETH_HLEN + sizeof(struct iphdr) + sizeof(struct udphdr);
+	vh->flags = 0;
+	vh->gso_type = VIRTIO_NET_HDR_GSO_UDP;
+	vh->gso_size = ETH_DATA_LEN - sizeof(struct iphdr);
+	cur += sizeof(*vh);
+
+	cur += build_eth(cur, 0);
+	cur += sizeof(struct iphdr) + sizeof(struct udphdr);
+	cur += build_ipv4_header(cur, payload_len);
+	cur += build_udp_header(cur, payload_len, true);
+	memset(cur, PKT_DATA, payload_len);
+	cur += payload_len;
+
+	return cur - buf;
+}
+
+TEST_F(tap, test_packet_valid_udp_csum)
+{
+	uint8_t pkt[TEST_PACKET_SZ];
+	size_t off;
+	int ret;
+
+	memset(pkt, 0, sizeof(pkt));
+	off = build_test_packet_valid_udp_csum(pkt, 1024);
+	ret = write(self->fd, pkt, off);
+	ASSERT_EQ(ret, off);
+}
+
+TEST_F(tap, test_packet_crash_tap_invalid_eth_proto)
+{
+	uint8_t pkt[TEST_PACKET_SZ];
+	size_t off;
+	int ret;
+
+	memset(pkt, 0, sizeof(pkt));
+	off = build_test_packet_crash_tap_invalid_eth_proto(pkt, 1024);
+	ret = write(self->fd, pkt, off);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EINVAL);
+}
+
+TEST_HARNESS_MAIN
-- 
2.34.1

