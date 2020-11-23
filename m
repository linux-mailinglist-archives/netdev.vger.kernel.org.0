Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642C92C1319
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 19:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbgKWSa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 13:30:57 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:41913 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729640AbgKWSaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 13:30:55 -0500
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0ANITqgk016939
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Nov 2020 19:29:55 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next v3 6/8] seg6: add VRF support for SRv6 End.DT6 behavior
Date:   Mon, 23 Nov 2020 19:28:54 +0100
Message-Id: <20201123182857.4640-7-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
References: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SRv6 End.DT6 is defined in the SRv6 Network Programming [1].

The Linux kernel already offers an implementation of the SRv6
End.DT6 behavior which permits IPv6 L3 VPNs over SRv6 networks. This
implementation is not particularly suitable in contexts where we need to
deploy IPv6 L3 VPNs among different tenants which share the same network
address schemes. The underlying problem lies in the fact that the
current version of DT6 (called legacy DT6 from now on) needs a complex
configuration to be applied on routers which requires ad-hoc routes and
routing policy rules to ensure the correct isolation of tenants.

Consequently, a new implementation of DT6 has been introduced with the
aim of simplifying the construction of IPv6 L3 VPN services in the
multi-tenant environment using SRv6 networks. To accomplish this task,
we reused the same VRF infrastructure and SRv6 core components already
exploited for implementing the SRv6 End.DT4 behavior.

Currently the two End.DT6 implementations coexist seamlessly and can be
used depending on the context and the user preferences. So, in order to
support both versions of DT6 a new attribute (vrftable) has been
introduced which allows us to differentiate the implementation of the
behavior to be used.

A SRv6 End.DT6 legacy behavior is still instantiated using a command
like the following one:

 $ ip -6 route add 2001:db8::1 encap seg6local action End.DT6 table 100 dev eth0

While to instantiate the SRv6 End.DT6 in VRF mode, the command is still
pretty straight forward:

 $ ip -6 route add 2001:db8::1 encap seg6local action End.DT6 vrftable 100 dev eth0.

Obviously as in the case of SRv6 End.DT4, the VRF strict_mode parameter
must be set (net.vrf.strict_mode=1) and the VRF associated with table
100 must exist.

Please note that the instances of SRv6 End.DT6 legacy and End.DT6 VRF
mode can coexist in the same system/configuration without problems.

[1] https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 76 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 117405985e6f..b257632f635e 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -497,6 +497,10 @@ static int __seg6_end_dt_vrf_build(struct seg6_local_lwt *slwt, const void *cfg,
 		info->proto = htons(ETH_P_IP);
 		info->hdrlen = sizeof(struct iphdr);
 		break;
+	case AF_INET6:
+		info->proto = htons(ETH_P_IPV6);
+		info->hdrlen = sizeof(struct ipv6hdr);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -649,6 +653,47 @@ static int seg6_end_dt4_build(struct seg6_local_lwt *slwt, const void *cfg,
 {
 	return __seg6_end_dt_vrf_build(slwt, cfg, AF_INET, extack);
 }
+
+static enum
+seg6_end_dt_mode seg6_end_dt6_parse_mode(struct seg6_local_lwt *slwt)
+{
+	unsigned long parsed_optattrs = slwt->parsed_optattrs;
+	bool legacy, vrfmode;
+
+	legacy	= !!(parsed_optattrs & (1 << SEG6_LOCAL_TABLE));
+	vrfmode	= !!(parsed_optattrs & (1 << SEG6_LOCAL_VRFTABLE));
+
+	if (!(legacy ^ vrfmode))
+		/* both are absent or present: invalid DT6 mode */
+		return DT_INVALID_MODE;
+
+	return legacy ? DT_LEGACY_MODE : DT_VRF_MODE;
+}
+
+static enum seg6_end_dt_mode seg6_end_dt6_get_mode(struct seg6_local_lwt *slwt)
+{
+	struct seg6_end_dt_info *info = &slwt->dt_info;
+
+	return info->mode;
+}
+
+static int seg6_end_dt6_build(struct seg6_local_lwt *slwt, const void *cfg,
+			      struct netlink_ext_ack *extack)
+{
+	enum seg6_end_dt_mode mode = seg6_end_dt6_parse_mode(slwt);
+	struct seg6_end_dt_info *info = &slwt->dt_info;
+
+	switch (mode) {
+	case DT_LEGACY_MODE:
+		info->mode = DT_LEGACY_MODE;
+		return 0;
+	case DT_VRF_MODE:
+		return __seg6_end_dt_vrf_build(slwt, cfg, AF_INET6, extack);
+	default:
+		NL_SET_ERR_MSG(extack, "table or vrftable must be specified");
+		return -EINVAL;
+	}
+}
 #endif
 
 static int input_action_end_dt6(struct sk_buff *skb,
@@ -660,6 +705,28 @@ static int input_action_end_dt6(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 		goto drop;
 
+#ifdef CONFIG_NET_L3_MASTER_DEV
+	if (seg6_end_dt6_get_mode(slwt) == DT_LEGACY_MODE)
+		goto legacy_mode;
+
+	/* DT6_VRF_MODE */
+	skb = end_dt_vrf_core(skb, slwt);
+	if (!skb)
+		/* packet has been processed and consumed by the VRF */
+		return 0;
+
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	/* note: this time we do not need to specify the table because the VRF
+	 * takes care of selecting the correct table.
+	 */
+	seg6_lookup_any_nexthop(skb, NULL, 0, true);
+
+	return dst_input(skb);
+
+legacy_mode:
+#endif
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	seg6_lookup_any_nexthop(skb, NULL, slwt->table, true);
@@ -851,7 +918,16 @@ static struct seg6_action_desc seg6_action_table[] = {
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DT6,
+#ifdef CONFIG_NET_L3_MASTER_DEV
+		.attrs		= 0,
+		.optattrs	= (1 << SEG6_LOCAL_TABLE) |
+				  (1 << SEG6_LOCAL_VRFTABLE),
+		.slwt_ops	= {
+					.build_state = seg6_end_dt6_build,
+				  },
+#else
 		.attrs		= (1 << SEG6_LOCAL_TABLE),
+#endif
 		.input		= input_action_end_dt6,
 	},
 	{
-- 
2.20.1

