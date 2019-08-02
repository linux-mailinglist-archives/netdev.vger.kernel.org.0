Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5EF7FFBF
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 19:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405609AbfHBRhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 13:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56072 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729364AbfHBRhN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 13:37:13 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 297E0315C002;
        Fri,  2 Aug 2019 17:37:13 +0000 (UTC)
Received: from renaissance-vector.redhat.com (ovpn-117-29.ams2.redhat.com [10.36.117.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99D7260605;
        Fri,  2 Aug 2019 17:37:07 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2-next v2] ip tunnel: add json output
Date:   Fri,  2 Aug 2019 19:38:10 +0200
Message-Id: <a7a161117f3a68e5a0cea008a8ca7e80b42bf2fa.1564766777.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 02 Aug 2019 17:37:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add json support on iptunnel and ip6tunnel.
The plain text output format should remain the same.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
Changes since v1:
 * Use print_color_* for ifname and ip addresses;
 * Use print_null() instead of print_bool() where appropriate;
 * Reduce indentation level on tnl_print_gre_flags()
---
 ip/ip6tunnel.c | 66 ++++++++++++++++++++++++---------------
 ip/iptunnel.c  | 84 ++++++++++++++++++++++++++++++++------------------
 ip/tunnel.c    | 37 +++++++++++++++++-----
 3 files changed, 125 insertions(+), 62 deletions(-)

diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
index d7684a673fdc4..80f16c35f0618 100644
--- a/ip/ip6tunnel.c
+++ b/ip/ip6tunnel.c
@@ -71,57 +71,76 @@ static void usage(void)
 static void print_tunnel(const void *t)
 {
 	const struct ip6_tnl_parm2 *p = t;
-	char s1[1024];
-	char s2[1024];
+	SPRINT_BUF(b1);
 
 	/* Do not use format_host() for local addr,
 	 * symbolic name will not be useful.
 	 */
-	printf("%s: %s/ipv6 remote %s local %s",
-	       p->name,
-	       tnl_strproto(p->proto),
-	       format_host_r(AF_INET6, 16, &p->raddr, s1, sizeof(s1)),
-	       rt_addr_n2a_r(AF_INET6, 16, &p->laddr, s2, sizeof(s2)));
+	open_json_object(NULL);
+	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", "%s: ", p->name);
+	snprintf(b1, sizeof(b1), "%s/ipv6", tnl_strproto(p->proto));
+	print_string(PRINT_ANY, "mode", "%s ", b1);
+	print_string(PRINT_FP, NULL, "%s", "remote ");
+	print_color_string(PRINT_ANY, COLOR_INET6, "remote", "%s ",
+			   format_host_r(AF_INET6, 16, &p->raddr, b1, sizeof(b1)));
+	print_string(PRINT_FP, NULL, "%s", "local ");
+	print_color_string(PRINT_ANY, COLOR_INET6, "local", "%s",
+			   rt_addr_n2a_r(AF_INET6, 16, &p->laddr, b1, sizeof(b1)));
+
 	if (p->link) {
 		const char *n = ll_index_to_name(p->link);
 
 		if (n)
-			printf(" dev %s", n);
+			print_string(PRINT_ANY, "link", " dev %s", n);
 	}
 
 	if (p->flags & IP6_TNL_F_IGN_ENCAP_LIMIT)
-		printf(" encaplimit none");
+		print_null(PRINT_ANY, "ip6_tnl_f_ign_encap_limit",
+			   " encaplimit none", NULL);
 	else
-		printf(" encaplimit %u", p->encap_limit);
+		print_uint(PRINT_ANY, "encap_limit", " encaplimit %u",
+			   p->encap_limit);
 
 	if (p->hop_limit)
-		printf(" hoplimit %u", p->hop_limit);
+		print_uint(PRINT_ANY, "hoplimit", " hoplimit %u", p->hop_limit);
 	else
-		printf(" hoplimit inherit");
+		print_string(PRINT_FP, "hoplimit", " hoplimit %s", "inherit");
 
-	if (p->flags & IP6_TNL_F_USE_ORIG_TCLASS)
-		printf(" tclass inherit");
-	else {
+	if (p->flags & IP6_TNL_F_USE_ORIG_TCLASS) {
+		print_null(PRINT_ANY, "ip6_tnl_f_use_orig_tclass",
+			   " tclass inherit", NULL);
+	} else {
 		__u32 val = ntohl(p->flowinfo & IP6_FLOWINFO_TCLASS);
 
-		printf(" tclass 0x%02x", (__u8)(val >> 20));
+		snprintf(b1, sizeof(b1), "0x%02x", (__u8)(val >> 20));
+		print_string(PRINT_ANY, "tclass", " tclass %s", b1);
 	}
 
-	if (p->flags & IP6_TNL_F_USE_ORIG_FLOWLABEL)
-		printf(" flowlabel inherit");
-	else
-		printf(" flowlabel 0x%05x", ntohl(p->flowinfo & IP6_FLOWINFO_FLOWLABEL));
+	if (p->flags & IP6_TNL_F_USE_ORIG_FLOWLABEL) {
+		print_null(PRINT_ANY, "ip6_tnl_f_use_orig_flowlabel",
+			   " flowlabel inherit", NULL);
+	} else {
+		__u32 val = ntohl(p->flowinfo & IP6_FLOWINFO_FLOWLABEL);
 
-	printf(" (flowinfo 0x%08x)", ntohl(p->flowinfo));
+		snprintf(b1, sizeof(b1), "0x%05x", val);
+		print_string(PRINT_ANY, "flowlabel", " flowlabel %s", b1);
+	}
+
+	snprintf(b1, sizeof(b1), "0x%08x", ntohl(p->flowinfo));
+	print_string(PRINT_ANY, "flowinfo", " (flowinfo %s)", b1);
 
 	if (p->flags & IP6_TNL_F_RCV_DSCP_COPY)
-		printf(" dscp inherit");
+		print_null(PRINT_ANY, "ip6_tnl_f_rcv_dscp_copy",
+			   " dscp inherit", NULL);
 
 	if (p->flags & IP6_TNL_F_ALLOW_LOCAL_REMOTE)
-		printf(" allow-localremote");
+		print_null(PRINT_ANY, "ip6_tnl_f_allow_local_remote",
+			   " allow-localremote", NULL);
 
 	tnl_print_gre_flags(p->proto, p->i_flags, p->o_flags,
 			    p->i_key, p->o_key);
+
+	close_json_object();
 }
 
 static int parse_args(int argc, char **argv, int cmd, struct ip6_tnl_parm2 *p)
@@ -357,7 +376,6 @@ static int do_show(int argc, char **argv)
 		return -1;
 
 	print_tunnel(&p);
-	fputc('\n', stdout);
 	return 0;
 }
 
diff --git a/ip/iptunnel.c b/ip/iptunnel.c
index 66929e75c7448..696f3b92bff55 100644
--- a/ip/iptunnel.c
+++ b/ip/iptunnel.c
@@ -289,17 +289,25 @@ static void print_tunnel(const void *t)
 {
 	const struct ip_tunnel_parm *p = t;
 	struct ip_tunnel_6rd ip6rd = {};
-	char s1[1024];
-	char s2[1024];
+	SPRINT_BUF(b1);
 
 	/* Do not use format_host() for local addr,
 	 * symbolic name will not be useful.
 	 */
-	printf("%s: %s/ip remote %s local %s",
-	       p->name,
-	       tnl_strproto(p->iph.protocol),
-	       p->iph.daddr ? format_host_r(AF_INET, 4, &p->iph.daddr, s1, sizeof(s1)) : "any",
-	       p->iph.saddr ? rt_addr_n2a_r(AF_INET, 4, &p->iph.saddr, s2, sizeof(s2)) : "any");
+	open_json_object(NULL);
+	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", "%s: ", p->name);
+	snprintf(b1, sizeof(b1), "%s/ip", tnl_strproto(p->iph.protocol));
+	print_string(PRINT_ANY, "mode", "%s ", b1);
+	print_null(PRINT_FP, NULL, "remote ", NULL);
+	print_color_string(PRINT_ANY, COLOR_INET, "remote", "%s ",
+			   p->iph.daddr || is_json_context()
+				? format_host_r(AF_INET, 4, &p->iph.daddr, b1, sizeof(b1))
+				: "any");
+	print_null(PRINT_FP, NULL, "local ", NULL);
+	print_color_string(PRINT_ANY, COLOR_INET, "local", "%s",
+			   p->iph.saddr || is_json_context()
+				? rt_addr_n2a_r(AF_INET, 4, &p->iph.saddr, b1, sizeof(b1))
+				: "any");
 
 	if (p->iph.protocol == IPPROTO_IPV6 && (p->i_flags & SIT_ISATAP)) {
 		struct ip_tunnel_prl prl[16] = {};
@@ -308,54 +316,70 @@ static void print_tunnel(const void *t)
 		prl[0].datalen = sizeof(prl) - sizeof(prl[0]);
 		prl[0].addr = htonl(INADDR_ANY);
 
-		if (!tnl_prl_ioctl(SIOCGETPRL, p->name, prl))
+		if (!tnl_prl_ioctl(SIOCGETPRL, p->name, prl)) {
 			for (i = 1; i < ARRAY_SIZE(prl); i++) {
-				if (prl[i].addr != htonl(INADDR_ANY)) {
-					printf(" %s %s ",
-					       (prl[i].flags & PRL_DEFAULT) ? "pdr" : "pr",
-					       format_host(AF_INET, 4, &prl[i].addr));
-				}
+				if (prl[i].addr == htonl(INADDR_ANY))
+					continue;
+				if (prl[i].flags & PRL_DEFAULT)
+					print_string(PRINT_ANY, "pdr",
+						     " pdr %s",
+						     format_host(AF_INET, 4, &prl[i].addr));
+				else
+					print_string(PRINT_ANY, "pr", " pr %s",
+						     format_host(AF_INET, 4, &prl[i].addr));
 			}
+		}
 	}
 
 	if (p->link) {
 		const char *n = ll_index_to_name(p->link);
 
 		if (n)
-			printf(" dev %s", n);
+			print_string(PRINT_ANY, "dev", " dev %s", n);
 	}
 
 	if (p->iph.ttl)
-		printf(" ttl %u", p->iph.ttl);
+		print_uint(PRINT_ANY, "ttl", " ttl %u", p->iph.ttl);
 	else
-		printf(" ttl inherit");
+		print_string(PRINT_FP, "ttl", " ttl %s", "inherit");
 
 	if (p->iph.tos) {
-		SPRINT_BUF(b1);
-		printf(" tos");
-		if (p->iph.tos & 1)
-			printf(" inherit");
-		if (p->iph.tos & ~1)
-			printf("%c%s ", p->iph.tos & 1 ? '/' : ' ',
-			       rtnl_dsfield_n2a(p->iph.tos & ~1, b1, sizeof(b1)));
+		SPRINT_BUF(b2);
+
+		if (p->iph.tos != 1) {
+			if (!is_json_context() && p->iph.tos & 1)
+				snprintf(b2, sizeof(b2), "%s%s",
+					 p->iph.tos & 1 ? "inherit/" : "",
+					 rtnl_dsfield_n2a(p->iph.tos & ~1, b1, sizeof(b1)));
+			else
+				snprintf(b2, sizeof(b2), "%s",
+					 rtnl_dsfield_n2a(p->iph.tos, b1, sizeof(b1)));
+			print_string(PRINT_ANY, "tos", " tos %s", b2);
+		} else {
+			print_string(PRINT_FP, NULL, " tos %s", "inherit");
+		}
 	}
 
 	if (!(p->iph.frag_off & htons(IP_DF)))
-		printf(" nopmtudisc");
+		print_null(PRINT_ANY, "nopmtudisc", " nopmtudisc", NULL);
 
 	if (p->iph.protocol == IPPROTO_IPV6 && !tnl_ioctl_get_6rd(p->name, &ip6rd) && ip6rd.prefixlen) {
-		printf(" 6rd-prefix %s/%u",
-		       inet_ntop(AF_INET6, &ip6rd.prefix, s1, sizeof(s1)),
-		       ip6rd.prefixlen);
+		print_string(PRINT_ANY, "6rd-prefix", " 6rd-prefix %s",
+			     inet_ntop(AF_INET6, &ip6rd.prefix, b1, sizeof(b1)));
+		print_uint(PRINT_ANY, "6rd-prefixlen", "/%u", ip6rd.prefixlen);
 		if (ip6rd.relay_prefix) {
-			printf(" 6rd-relay_prefix %s/%u",
-			       format_host(AF_INET, 4, &ip6rd.relay_prefix),
-			       ip6rd.relay_prefixlen);
+			print_string(PRINT_ANY, "6rd-relay_prefix",
+				     " 6rd-relay_prefix %s",
+				     format_host(AF_INET, 4, &ip6rd.relay_prefix));
+			print_uint(PRINT_ANY, "6rd-relay_prefixlen", "/%u",
+				   ip6rd.relay_prefixlen);
 		}
 	}
 
 	tnl_print_gre_flags(p->iph.protocol, p->i_flags, p->o_flags,
 			    p->i_key, p->o_key);
+
+	close_json_object();
 }
 
 
diff --git a/ip/tunnel.c b/ip/tunnel.c
index 41b0ef3165fdc..88585cf3177b5 100644
--- a/ip/tunnel.c
+++ b/ip/tunnel.c
@@ -314,24 +314,43 @@ void tnl_print_gre_flags(__u8 proto,
 {
 	if ((i_flags & GRE_KEY) && (o_flags & GRE_KEY) &&
 	    o_key == i_key) {
-		printf(" key %u", ntohl(i_key));
+		print_uint(PRINT_ANY, "key", " key %u", ntohl(i_key));
 	} else {
 		if (i_flags & GRE_KEY)
-			printf(" ikey %u", ntohl(i_key));
+			print_uint(PRINT_ANY, "ikey", " ikey %u", ntohl(i_key));
 		if (o_flags & GRE_KEY)
-			printf(" okey %u", ntohl(o_key));
+			print_uint(PRINT_ANY, "okey", " okey %u", ntohl(o_key));
 	}
 
-	if (proto == IPPROTO_GRE) {
-		if (i_flags & GRE_SEQ)
+	if (proto != IPPROTO_GRE)
+		return;
+
+	open_json_array(PRINT_JSON, "flags");
+	if (i_flags & GRE_SEQ) {
+		if (is_json_context())
+			print_string(PRINT_JSON, NULL, "%s", "rx_drop_ooseq");
+		else
 			printf("%s  Drop packets out of sequence.", _SL_);
-		if (i_flags & GRE_CSUM)
+	}
+	if (i_flags & GRE_CSUM) {
+		if (is_json_context())
+			print_string(PRINT_JSON, NULL, "%s", "rx_csum");
+		else
 			printf("%s  Checksum in received packet is required.", _SL_);
-		if (o_flags & GRE_SEQ)
+	}
+	if (o_flags & GRE_SEQ) {
+		if (is_json_context())
+			print_string(PRINT_JSON, NULL, "%s", "tx_seq");
+		else
 			printf("%s  Sequence packets on output.", _SL_);
-		if (o_flags & GRE_CSUM)
+	}
+	if (o_flags & GRE_CSUM) {
+		if (is_json_context())
+			print_string(PRINT_JSON, NULL, "%s", "tx_csum");
+		else
 			printf("%s  Checksum output packets.", _SL_);
 	}
+	close_json_array(PRINT_JSON, NULL);
 }
 
 static void tnl_print_stats(const struct rtnl_link_stats64 *s)
@@ -417,6 +436,7 @@ static int print_nlmsg_tunnel(struct nlmsghdr *n, void *arg)
 
 int do_tunnels_list(struct tnl_print_nlmsg_info *info)
 {
+	new_json_obj(json);
 	if (rtnl_linkdump_req(&rth, preferred_family) < 0) {
 		perror("Cannot send dump request\n");
 		return -1;
@@ -426,6 +446,7 @@ int do_tunnels_list(struct tnl_print_nlmsg_info *info)
 		fprintf(stderr, "Dump terminated\n");
 		return -1;
 	}
+	delete_json_obj();
 
 	return 0;
 }
-- 
2.20.1

