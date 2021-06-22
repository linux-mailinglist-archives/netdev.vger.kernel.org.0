Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271363B0944
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhFVPlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhFVPlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 11:41:39 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6241EC061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:39:23 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id r12so601755ioa.7
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yJA/5Mvl949tMU2pXlDwrFE5q1O2yCz39M7RsRvRFvY=;
        b=QYtxqngg5MrDozUAfBl/HYvHN2iSOUgd6RVRkO/wZ371uUM6v4ts0du9wrdPMlR+vY
         NZGBwn40TUZfd+yyDiPtaaqnzBuRvzhPmI9cgekhCc1CrDljW+PdMjd3GUylyjXAQM0k
         YXZtb0OpjahHTWrbgbVmuksk/fODEg97LIYR6BYYYgWz9gFqaESEhvg7m1yZA2BBLms+
         KpuhPy2aTq1gKxhu7Fw6MKPESSrYlbwJAZMxFPkV3/PZQgQNdA/qwUKmRpubmO/4DkJT
         d/rMeiaxCkkiO3JLqW5Mlwe7SRWu0wYKmHl0mWwdRpuHd8J4GvF+2flVI69GR8mTu6GR
         U0JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yJA/5Mvl949tMU2pXlDwrFE5q1O2yCz39M7RsRvRFvY=;
        b=n3RDVP6nQ8Ludh877nAXlB26KvaGm2WW4tFuNGbxV6bfjaJw6G/J0ff2rpuU8fub/n
         iVH7rLLSew18f9hmxc6L0jzWz9dCuGKRMR14ELMMFngbNzhPRn6G8lhmoUFOW/CZbtaj
         DWr9ggorgnNB4+D9BYuKIAKB1KOEL9OpS6lBX/joPB4poVbtN98uqJm36hatuWLYNtIZ
         DX12hv8iPLUCkt2xJ3qX0q4DdfP/6v5aFmSsUCkrdG0td99u46BWN8PkOkbdkq+b7ncT
         dXQE3dwPoRRkQOFxAZ/8rtV6d0oC0Cr7J76RzaVikuGk/ZSVKlm16k/FRXAR/Ws8JTyz
         WhAQ==
X-Gm-Message-State: AOAM530jmEMuOKYJjOcyvkWkVSVNMdMVSJ7u3PAYbkC9OIeu3wW1h0Dj
        k4XibZiYhomEZrr3i+yaXUIJrVSnPFo=
X-Google-Smtp-Source: ABdhPJxIQTiInMuRBVO8RmsitS0Pgd/HYEVBok/Gib/hqu+A5VlguVTxquXzwc2ifOyf2JakZvHIQg==
X-Received: by 2002:a6b:c707:: with SMTP id x7mr1882246iof.160.1624376362688;
        Tue, 22 Jun 2021 08:39:22 -0700 (PDT)
Received: from aroeseler-LY545.hsd1.mn.comcast.net ([2601:448:c580:1890::bc1f])
        by smtp.gmail.com with ESMTPSA id v18sm11851196iom.5.2021.06.22.08.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 08:39:22 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, willemdebruijn.kernel@gmail.com,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next] ipv6: ICMPV6: add response to ICMPV6 RFC 8335 PROBE messages
Date:   Tue, 22 Jun 2021 05:39:05 -0500
Message-Id: <7eb62f437120d8686f50811a2aebd7c0f7f73ced.1624358016.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch builds off of commit 2b246b2569cd2ac6ff700d0dce56b8bae29b1842
and adds functionality to respond to ICMPV6 PROBE requests.

Add a sysctl to enable responses to PROBE messages, and as
specified by section 8 of RFC 8335, the sysctl defaults to disabled.

Modify icmpv6_rcv to detect ICMPV6 PROBE messages and call the
icmpv6_echo_reply handler.

Modify icmpv6_echo_reply to build a PROBE response message based on the
queried interface.

This patch has been tested using a branch of the iputils git repo which can
be found here: https://github.com/Juniper-Clinic-2020/iputils/tree/probe-request

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |   6 ++
 include/net/netns/ipv6.h               |   1 +
 net/ipv6/icmp.c                        | 129 ++++++++++++++++++++++++-
 3 files changed, 133 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b0436d3a4f11..c4bf6e297b64 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2471,6 +2471,12 @@ echo_ignore_anycast - BOOLEAN
 
 	Default: 0
 
+echo_ignore_all - BOOLEAN
+        If set to one, then the kernel will respond to RFC 8335 PROBE
+        requests sent to it over the IPv6 protocol.
+
+	Default: 0
+
 xfrm6_gc_thresh - INTEGER
 	(Obsolete since linux-4.14)
 	The threshold at which we will start garbage collecting for IPv6
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index bde0b7adb4a3..e9671573e504 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -37,6 +37,7 @@ struct netns_sysctl_ipv6 {
 	u8 icmpv6_echo_ignore_all;
 	u8 icmpv6_echo_ignore_multicast;
 	u8 icmpv6_echo_ignore_anycast;
+	u8 icmpv6_echo_enable_probe;
 	DECLARE_BITMAP(icmpv6_ratemask, ICMPV6_MSG_MAX + 1);
 	unsigned long *icmpv6_ratemask_ptr;
 	u8 anycast_src_echo_reply;
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index e8398ffb5e35..50a48fceb9f3 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -67,6 +67,7 @@
 #include <net/l3mdev.h>
 
 #include <linux/uaccess.h>
+#include <linux/inetdevice.h>
 
 /*
  *	The ICMP socket(s). This is the most convenient way to flow control
@@ -725,6 +726,13 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	struct ipcm6_cookie ipc6;
 	u32 mark = IP6_REPLY_MARK(net, skb->mark);
 	bool acast;
+	struct icmp_ext_hdr *ext_hdr, _ext_hdr;
+	struct icmp_ext_echo_iio *iio, _iio;
+	struct net_device *dev;
+	char buff[IFNAMSIZ];
+	bool probe = false;
+	u16 ident_len;
+	u8 status;
 
 	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
 	    net->ipv6.sysctl.icmpv6_echo_ignore_multicast)
@@ -740,8 +748,17 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	    !(net->ipv6.sysctl.anycast_src_echo_reply && acast))
 		saddr = NULL;
 
+	if (icmph->icmp6_type == ICMPV6_EXT_ECHO_REQUEST) {
+		if (!net->ipv6.sysctl.icmpv6_echo_enable_probe)
+			return;
+		probe = true;
+	}
+
 	memcpy(&tmp_hdr, icmph, sizeof(tmp_hdr));
-	tmp_hdr.icmp6_type = ICMPV6_ECHO_REPLY;
+	if (probe)
+		tmp_hdr.icmp6_type = ICMPV6_EXT_ECHO_REPLY;
+	else
+		tmp_hdr.icmp6_type = ICMPV6_ECHO_REPLY;
 
 	memset(&fl6, 0, sizeof(fl6));
 	if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_ICMPV6_ECHO_REPLIES)
@@ -752,7 +769,10 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	if (saddr)
 		fl6.saddr = *saddr;
 	fl6.flowi6_oif = icmp6_iif(skb);
-	fl6.fl6_icmp_type = ICMPV6_ECHO_REPLY;
+	if (probe)
+		fl6.fl6_icmp_type = ICMPV6_EXT_ECHO_REPLY;
+	else
+		fl6.fl6_icmp_type = ICMPV6_ECHO_REPLY;
 	fl6.flowi6_mark = mark;
 	fl6.flowi6_uid = sock_net_uid(net, NULL);
 	security_skb_classify_flow(skb, flowi6_to_flowi_common(&fl6));
@@ -783,13 +803,20 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 
 	msg.skb = skb;
 	msg.offset = 0;
-	msg.type = ICMPV6_ECHO_REPLY;
+	if (probe)
+		msg.type = ICMPV6_EXT_ECHO_REPLY;
+	else
+		msg.type = ICMPV6_ECHO_REPLY;
 
 	ipcm6_init_sk(&ipc6, np);
 	ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 	ipc6.tclass = ipv6_get_dsfield(ipv6_hdr(skb));
 	ipc6.sockc.mark = mark;
 
+	if (icmph->icmp6_type == ICMPV6_EXT_ECHO_REQUEST &&
+	    net->ipv6.sysctl.icmpv6_echo_enable_probe)
+		goto build_probe_reply;
+send_reply:
 	if (ip6_append_data(sk, icmpv6_getfrag, &msg,
 			    skb->len + sizeof(struct icmp6hdr),
 			    sizeof(struct icmp6hdr), &ipc6, &fl6,
@@ -806,6 +833,89 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	icmpv6_xmit_unlock(sk);
 out_bh_enable:
 	local_bh_enable();
+	return;
+build_probe_reply:
+	/* We currently only support probing interfaces on the proxy node
+	 * Check to ensure L-bit is set
+	 */
+	if (!(ntohs(icmph->icmp6_dataun.u_echo.sequence) & 1))
+		goto out_dst_release;
+	/* Clear status bits in reply message */
+	tmp_hdr.icmp6_dataun.u_echo.sequence &= htons(0xFF00);
+	ext_hdr = skb_header_pointer(skb, 0, sizeof(_ext_hdr), &_ext_hdr);
+	/* Size of iio is class_type dependent.
+	 * Only check header here and assign length based on ctype in the switch statement
+	 */
+	iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr), &_iio);
+	if (!ext_hdr || !iio)
+		goto send_mal_query;
+	if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
+		goto send_mal_query;
+	ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
+	status = 0;
+	dev = NULL;
+	switch (iio->extobj_hdr.class_type) {
+	case ICMP_EXT_ECHO_CTYPE_NAME:
+		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
+		if (ident_len >= IFNAMSIZ)
+			goto send_mal_query;
+		memset(buff, 0, sizeof(buff));
+		memcpy(buff, &iio->ident.name, ident_len);
+		dev = dev_get_by_name(net, buff);
+		break;
+	case ICMP_EXT_ECHO_CTYPE_INDEX:
+		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
+					 sizeof(iio->ident.ifindex), &_iio);
+		if (ident_len != sizeof(iio->ident.ifindex))
+			goto send_mal_query;
+		dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
+		break;
+	case ICMP_EXT_ECHO_CTYPE_ADDR:
+		if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
+				 iio->ident.addr.ctype3_hdr.addrlen)
+			goto send_mal_query;
+		switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
+		case ICMP_AFI_IP:
+			iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
+						 sizeof(struct in_addr), &_iio);
+			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
+					 sizeof(struct in_addr))
+				goto send_mal_query;
+			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
+			break;
+		case ICMP_AFI_IP6:
+			iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
+			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
+					 sizeof(struct in6_addr))
+				goto send_mal_query;
+			dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
+			if (dev)
+				dev_hold(dev);
+			break;
+		default:
+			goto send_mal_query;
+		}
+		break;
+	default:
+		goto send_mal_query;
+	}
+	if (!dev) {
+		tmp_hdr.icmp6_code = ICMP_EXT_CODE_NO_IF;
+		goto send_reply;
+	}
+	/* Fill bits in reply message */
+	if (dev->flags & IFF_UP)
+		status |= ICMP_EXT_ECHOREPLY_ACTIVE;
+	if (__in_dev_get_rcu(dev) && __in_dev_get_rcu(dev)->ifa_list)
+		status |= ICMP_EXT_ECHOREPLY_IPV4;
+	if (!list_empty(&rcu_dereference(dev->ip6_ptr)->addr_list))
+		status |= ICMP_EXT_ECHOREPLY_IPV6;
+	dev_put(dev);
+	tmp_hdr.icmp6_dataun.u_echo.sequence |= htons(status);
+	goto send_reply;
+send_mal_query:
+	tmp_hdr.icmp6_code = ICMP_EXT_CODE_MAL_QUERY;
+	goto send_reply;
 }
 
 void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
@@ -912,6 +1022,11 @@ static int icmpv6_rcv(struct sk_buff *skb)
 			icmpv6_echo_reply(skb);
 		break;
 
+	case ICMPV6_EXT_ECHO_REQUEST:
+		if (!net->ipv6.sysctl.icmpv6_echo_ignore_all)
+			icmpv6_echo_reply(skb);
+		break;
+
 	case ICMPV6_ECHO_REPLY:
 		success = ping_rcv(skb);
 		break;
@@ -1198,6 +1313,13 @@ static struct ctl_table ipv6_icmp_table_template[] = {
 		.mode		= 0644,
 		.proc_handler = proc_do_large_bitmap,
 	},
+	{
+		.procname	= "echo_enable_probe",
+		.data		= &init_net.ipv6.sysctl.icmpv6_echo_enable_probe,
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler = proc_dou8vec_minmax,
+	},
 	{ },
 };
 
@@ -1215,6 +1337,7 @@ struct ctl_table * __net_init ipv6_icmp_sysctl_init(struct net *net)
 		table[2].data = &net->ipv6.sysctl.icmpv6_echo_ignore_multicast;
 		table[3].data = &net->ipv6.sysctl.icmpv6_echo_ignore_anycast;
 		table[4].data = &net->ipv6.sysctl.icmpv6_ratemask_ptr;
+		table[5].data = &net->ipv6.sysctl.icmpv6_echo_enable_probe;
 	}
 	return table;
 }
-- 
2.32.0

