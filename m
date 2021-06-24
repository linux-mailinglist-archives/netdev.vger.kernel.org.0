Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FD23B368D
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbhFXTGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 15:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbhFXTGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 15:06:13 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFF6C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 12:03:53 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id d9so9589634ioo.2
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 12:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ptq+nvX+WBOcknhEI1NLQK9JpzS9h5ba3q5VU4EypO0=;
        b=dwxrV6kuThvbKyQykQwN70sQs/73HGDPu8DnqZV3bSYB/jH3m/dcj4oo42A0LelrvO
         TbHWRNPPV+cguN/FMZe+1yCq3T8RBjDmBTRBvDK/O6aGTv5qglsoj5M8zrYeyCVsePPc
         jLxtq1GxswSRc1/8jNJDQUg/XT+dy9qKtQyo9yei/DKAua+cupzWsK7uuss5jtnwr3Bj
         lBl68dv4AkQA579muM8oY6C71oIjB/3OEBUnehKDgbFNIjIt5tJmxzve8s5kgNZQBGy2
         oaXieblPa5papSj5Z2s35elPO/C60/waCj1KTHJeUU5NreMmZvia3QE6ABeEjQEWpb81
         B0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ptq+nvX+WBOcknhEI1NLQK9JpzS9h5ba3q5VU4EypO0=;
        b=CleqMgCY2UcraRmnvSKGYfJcTusqNTPO4y9DvMkxcm2ykviunApRoWaC7tyTMjgRSD
         Zww/ZmNR7qOvmmGzCCV68syeASHRoBmp8cjU16Xhm0dHLTOxlNk1O/L6tWfN7wdH23rI
         pgIbEQkNJuoapKFfaWK16/9bKOG4hOnoXvji58hFbdawLiHaBQ0wjiOwGzl9PZMmLd/F
         PkzHL8YRpFKHEq/ZPjKBy04Btp+DJMvixVEi6r1WPwj3LBV5I7qleqjv7noeaV5c1496
         OdWabP5co/A8aKxOJzoxcGixz2totsQAdolQFdh/bRcfA/R1BiHHKU8SPhi+wT7IEOUh
         y+6g==
X-Gm-Message-State: AOAM53270So+RfoGZHhaAm09XjUiCVYRj4QzlU+SDJVvE5L1bn3+JlfP
        NBuIuGObeXssh0vU3+FEVb+TGpDgR8w=
X-Google-Smtp-Source: ABdhPJxcFk+z0BFolw5w+Bq7Ca3N7UiqhyexC6DiUalZOGpGJw5rLCH7KHx9vZLZV8924arWzC+vmg==
X-Received: by 2002:a02:cb82:: with SMTP id u2mr6130266jap.8.1624561432773;
        Thu, 24 Jun 2021 12:03:52 -0700 (PDT)
Received: from aroeseler-LY545.hsd1.mn.comcast.net ([2601:448:c580:1890::bc1f])
        by smtp.gmail.com with ESMTPSA id h6sm1871985iop.40.2021.06.24.12.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 12:03:52 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, willemdebruijn.kernel@gmail.com,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V2 1/1] ipv6: ICMPV6: add response to ICMPV6 RFC 8335 PROBE messages
Date:   Thu, 24 Jun 2021 14:03:31 -0500
Message-Id: <4971c41fb298b1f7c7b72fb5d8863502319e3fcb.1624560898.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch builds off of commit 2b246b2569cd2ac6ff700d0dce56b8bae29b1842
and adds functionality to respond to ICMPV6 PROBE requests.

Add icmp_build_probe function to construct PROBE requests for both
ICMPV4 and ICMPV6.

Modify icmpv6_rcv to detect ICMPV6 PROBE messages and call the
icmpv6_echo_reply handler.

Modify icmpv6_echo_reply to build a PROBE response message based on the
queried interface.

This patch has been tested using a branch of the iputils git repo which can
be found here: https://github.com/Juniper-Clinic-2020/iputils/tree/probe-request

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes:
v1 -> v2:
Suggested by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
- Do not add sysctl for ICMPV6 PROBE control and instead use existing
  ICMPV4 sysctl.
- Add icmp_build_probe function to construct PROBE responses for both
  ICMPV4 and ICMPV6.
---
 include/net/icmp.h |   1 +
 net/ipv4/icmp.c    | 101 +++++++++++++++++++++++++++------------------
 net/ipv6/icmp.c    |  24 +++++++++--
 3 files changed, 83 insertions(+), 43 deletions(-)

diff --git a/include/net/icmp.h b/include/net/icmp.h
index fd84adc47963..caddf4a59ad1 100644
--- a/include/net/icmp.h
+++ b/include/net/icmp.h
@@ -57,5 +57,6 @@ int icmp_rcv(struct sk_buff *skb);
 int icmp_err(struct sk_buff *skb, u32 info);
 int icmp_init(void);
 void icmp_out_count(struct net *net, unsigned char type);
+bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr);
 
 #endif	/* _ICMP_H */
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 0a57f1892e7e..27a6fa29e2d3 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -977,56 +977,37 @@ static bool icmp_redirect(struct sk_buff *skb)
 	return true;
 }
 
-/*
- *	Handle ICMP_ECHO ("ping") and ICMP_EXT_ECHO ("PROBE") requests.
+/*	Helper for icmp_echo and icmpv6_echo_reply.
+ *	Searches for net_device that matches PROBE interface identifier
+ *		and builds PROBE reply message in icmphdr.
  *
- *	RFC 1122: 3.2.2.6 MUST have an echo server that answers ICMP echo
- *		  requests.
- *	RFC 1122: 3.2.2.6 Data received in the ICMP_ECHO request MUST be
- *		  included in the reply.
- *	RFC 1812: 4.3.3.6 SHOULD have a config option for silently ignoring
- *		  echo requests, MUST have default=NOT.
- *	RFC 8335: 8 MUST have a config option to enable/disable ICMP
- *		  Extended Echo Functionality, MUST be disabled by default
- *	See also WRT handling of options once they are done and working.
+ *	Returns false if PROBE responses are disabled via sysctl
  */
 
-static bool icmp_echo(struct sk_buff *skb)
+bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 {
 	struct icmp_ext_hdr *ext_hdr, _ext_hdr;
 	struct icmp_ext_echo_iio *iio, _iio;
-	struct icmp_bxm icmp_param;
+	struct net *net = dev_net(skb->dev);
 	struct net_device *dev;
 	char buff[IFNAMSIZ];
-	struct net *net;
 	u16 ident_len;
 	u8 status;
 
-	net = dev_net(skb_dst(skb)->dev);
-	/* should there be an ICMP stat for ignored echos? */
-	if (net->ipv4.sysctl_icmp_echo_ignore_all)
-		return true;
-
-	icmp_param.data.icmph	   = *icmp_hdr(skb);
-	icmp_param.skb		   = skb;
-	icmp_param.offset	   = 0;
-	icmp_param.data_len	   = skb->len;
-	icmp_param.head_len	   = sizeof(struct icmphdr);
-
-	if (icmp_param.data.icmph.type == ICMP_ECHO) {
-		icmp_param.data.icmph.type = ICMP_ECHOREPLY;
-		goto send_reply;
-	}
 	if (!net->ipv4.sysctl_icmp_echo_enable_probe)
-		return true;
+		return false;
+
 	/* We currently only support probing interfaces on the proxy node
 	 * Check to ensure L-bit is set
 	 */
-	if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
-		return true;
+	if (!(ntohs(icmphdr->un.echo.sequence) & 1))
+		return false;
 	/* Clear status bits in reply message */
-	icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
-	icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
+	icmphdr->un.echo.sequence &= htons(0xFF00);
+	if (icmphdr->type == ICMP_EXT_ECHO)
+		icmphdr->type = ICMP_EXT_ECHOREPLY;
+	else
+		icmphdr->type = ICMPV6_EXT_ECHO_REPLY;
 	ext_hdr = skb_header_pointer(skb, 0, sizeof(_ext_hdr), &_ext_hdr);
 	/* Size of iio is class_type dependent.
 	 * Only check header here and assign length based on ctype in the switch statement
@@ -1087,8 +1068,8 @@ static bool icmp_echo(struct sk_buff *skb)
 		goto send_mal_query;
 	}
 	if (!dev) {
-		icmp_param.data.icmph.code = ICMP_EXT_CODE_NO_IF;
-		goto send_reply;
+		icmphdr->code = ICMP_EXT_CODE_NO_IF;
+		return true;
 	}
 	/* Fill bits in reply message */
 	if (dev->flags & IFF_UP)
@@ -1098,13 +1079,53 @@ static bool icmp_echo(struct sk_buff *skb)
 	if (!list_empty(&rcu_dereference(dev->ip6_ptr)->addr_list))
 		status |= ICMP_EXT_ECHOREPLY_IPV6;
 	dev_put(dev);
-	icmp_param.data.icmph.un.echo.sequence |= htons(status);
+	icmphdr->un.echo.sequence |= htons(status);
+	return true;
+send_mal_query:
+	icmphdr->code = ICMP_EXT_CODE_MAL_QUERY;
+	return true;
+}
+
+/*
+ *	Handle ICMP_ECHO ("ping") and ICMP_EXT_ECHO ("PROBE") requests.
+ *
+ *	RFC 1122: 3.2.2.6 MUST have an echo server that answers ICMP echo
+ *		  requests.
+ *	RFC 1122: 3.2.2.6 Data received in the ICMP_ECHO request MUST be
+ *		  included in the reply.
+ *	RFC 1812: 4.3.3.6 SHOULD have a config option for silently ignoring
+ *		  echo requests, MUST have default=NOT.
+ *	RFC 8335: 8 MUST have a config option to enable/disable ICMP
+ *		  Extended Echo Functionality, MUST be disabled by default
+ *	See also WRT handling of options once they are done and working.
+ */
+
+static bool icmp_echo(struct sk_buff *skb)
+{
+	struct icmp_bxm icmp_param;
+	struct net *net;
+
+	net = dev_net(skb_dst(skb)->dev);
+	/* should there be an ICMP stat for ignored echos? */
+	if (net->ipv4.sysctl_icmp_echo_ignore_all)
+		return true;
+
+	icmp_param.data.icmph	   = *icmp_hdr(skb);
+	icmp_param.skb		   = skb;
+	icmp_param.offset	   = 0;
+	icmp_param.data_len	   = skb->len;
+	icmp_param.head_len	   = sizeof(struct icmphdr);
+
+	if (icmp_param.data.icmph.type == ICMP_ECHO) {
+		icmp_param.data.icmph.type = ICMP_ECHOREPLY;
+		goto send_reply;
+	}
+
+	if (!icmp_build_probe(skb, &icmp_param.data.icmph))
+		return true;
 send_reply:
 	icmp_reply(&icmp_param, skb);
 		return true;
-send_mal_query:
-	icmp_param.data.icmph.code = ICMP_EXT_CODE_MAL_QUERY;
-	goto send_reply;
 }
 
 /*
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index e8398ffb5e35..d32a387b36e7 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -725,6 +725,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	struct ipcm6_cookie ipc6;
 	u32 mark = IP6_REPLY_MARK(net, skb->mark);
 	bool acast;
+	u8 type;
 
 	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
 	    net->ipv6.sysctl.icmpv6_echo_ignore_multicast)
@@ -740,8 +741,16 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	    !(net->ipv6.sysctl.anycast_src_echo_reply && acast))
 		saddr = NULL;
 
+	if (icmph->icmp6_type == ICMPV6_EXT_ECHO_REQUEST) {
+		if (!net->ipv4.sysctl_icmp_echo_enable_probe)
+			return;
+		type = ICMPV6_EXT_ECHO_REPLY;
+	} else {
+		type = ICMPV6_ECHO_REPLY;
+	}
+
 	memcpy(&tmp_hdr, icmph, sizeof(tmp_hdr));
-	tmp_hdr.icmp6_type = ICMPV6_ECHO_REPLY;
+	tmp_hdr.icmp6_type = type;
 
 	memset(&fl6, 0, sizeof(fl6));
 	if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_ICMPV6_ECHO_REPLIES)
@@ -752,7 +761,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	if (saddr)
 		fl6.saddr = *saddr;
 	fl6.flowi6_oif = icmp6_iif(skb);
-	fl6.fl6_icmp_type = ICMPV6_ECHO_REPLY;
+	fl6.fl6_icmp_type = type;
 	fl6.flowi6_mark = mark;
 	fl6.flowi6_uid = sock_net_uid(net, NULL);
 	security_skb_classify_flow(skb, flowi6_to_flowi_common(&fl6));
@@ -783,13 +792,17 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 
 	msg.skb = skb;
 	msg.offset = 0;
-	msg.type = ICMPV6_ECHO_REPLY;
+	msg.type = type;
 
 	ipcm6_init_sk(&ipc6, np);
 	ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 	ipc6.tclass = ipv6_get_dsfield(ipv6_hdr(skb));
 	ipc6.sockc.mark = mark;
 
+	if (icmph->icmp6_type == ICMPV6_EXT_ECHO_REQUEST)
+		if (!icmp_build_probe(skb, (struct icmphdr *)&tmp_hdr))
+			goto out_dst_release;
+
 	if (ip6_append_data(sk, icmpv6_getfrag, &msg,
 			    skb->len + sizeof(struct icmp6hdr),
 			    sizeof(struct icmp6hdr), &ipc6, &fl6,
@@ -912,6 +925,11 @@ static int icmpv6_rcv(struct sk_buff *skb)
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
-- 
2.32.0

