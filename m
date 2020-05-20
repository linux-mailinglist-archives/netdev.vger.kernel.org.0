Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1001DC34A
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 01:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgETX6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 19:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgETX6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 19:58:22 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76801C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 16:58:21 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id dh1so2254616qvb.13
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 16:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/HkxzjlRxargQu7uKskFYZwFE9VgfTL3cLyn7uOIW+c=;
        b=hTVHWfrDbBfNrBhDfDgsETKJ1pAQG13lCPEVqdxtbBpN2TH6YfW35GVt1NI/uNVpUI
         AszuHfgzzFDsaWsMuvnur5tUtaOfF9g94PF7SaQqAM03l+RLCzgwuWh/UlSh3neqdFxl
         qfTWYBy8DGvi2HSLK4GHzO+LAdy/Sworxn2q65s4MsofhFuB1JXcOaMHqXXPnjlEDmAt
         I0rtoFXqkK47++KcrgiHaOlZcr7nsav4RcdCEduMPmj1gZFND6k1UpkrMh6SWUDzrQf+
         vRV3NVKhtCPTm3Gj9G4YiaMNIoaijRzzi58VXtUC47pb5/IdujK50RZioFI54kh2xyk6
         Ds+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/HkxzjlRxargQu7uKskFYZwFE9VgfTL3cLyn7uOIW+c=;
        b=YpGP3mF4ikIEQgE67+XYq7AcsJsvJKIje8oqu5ED1jKLSfswcZANmnsUJo6SBgaSDE
         OA3XMEZHhpmd71osuPSFaca14FWycPur8JkI2MFm24nX1csV2iHgN9y6VZDUxi8obfaD
         qY6l1xLKxikbNSH5Vs3uXH726UJEsgfBSgXtX6wYKWDLRWriVitf+Kve9z13KS85vbHg
         WldvD0X3FaADxDRUsOUSCO0hyrF+VWUXfP2XD2S6QxKGlimOSiwuQ4XVqH3cuC27nhlH
         zHvOMrdmy0xO3Xt6TyYbnPgcj7i8FwwT4lw1Z0ySQkoTw4yDS8rOA0ezgKsLGesOvwh5
         25nQ==
X-Gm-Message-State: AOAM531xo4bjHSvywArsmj2p5+qDnAz6ZfzcFCYRpJb3D7amwzoFu9pO
        FkNsYSKAND5jfWAlqdPNc6A2sCX9
X-Google-Smtp-Source: ABdhPJzeYg9oTcg0W6GdSDY3lJup8dZtrSOhCuUG4kyapNu+qOOTSVZTIXS/zZlXDZZUTQ6+6ndWuA==
X-Received: by 2002:a0c:f811:: with SMTP id r17mr7660249qvn.67.1590019100340;
        Wed, 20 May 2020 16:58:20 -0700 (PDT)
Received: from localhost.localdomain ([108.161.122.19])
        by smtp.gmail.com with ESMTPSA id c26sm3357981qkm.98.2020.05.20.16.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 16:58:19 -0700 (PDT)
From:   Alexander Aring <alex.aring@gmail.com>
To:     netdev@vger.kernel.org
Cc:     mcr@sandelman.ca, stefan@datenfreihafen.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCHv2 iproute2-next] lwtunnel: add support for rpl segment routing
Date:   Wed, 20 May 2020 19:57:27 -0400
Message-Id: <20200520235727.28045-1-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for rpl segment routing settings.
Example:

ip -n ns0 -6 route add 2001::3 encap rpl segs \
fe80::c8fe:beef:cafe:cafe,fe80::c8fe:beef:cafe:beef dev lowpan0

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
---
changes since v2:

- change output to display segments count and nice segment brackets
- fix json output, sorry.

 ip/iproute.c          |   2 +-
 ip/iproute_lwtunnel.c | 121 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index 07c45169..05ec2c29 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -101,7 +101,7 @@ static void usage(void)
 		"TIME := NUMBER[s|ms]\n"
 		"BOOL := [1|0]\n"
 		"FEATURES := ecn\n"
-		"ENCAPTYPE := [ mpls | ip | ip6 | seg6 | seg6local ]\n"
+		"ENCAPTYPE := [ mpls | ip | ip6 | seg6 | seg6local | rpl ]\n"
 		"ENCAPHDR := [ MPLSLABEL | SEG6HDR ]\n"
 		"SEG6HDR := [ mode SEGMODE ] segs ADDR1,ADDRi,ADDRn [hmac HMACKEYID] [cleanup]\n"
 		"SEGMODE := [ encap | inline ]\n"
diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index ff7c9d7f..9b4f0885 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -29,6 +29,8 @@
 
 #include <linux/seg6.h>
 #include <linux/seg6_iptunnel.h>
+#include <linux/rpl.h>
+#include <linux/rpl_iptunnel.h>
 #include <linux/seg6_hmac.h>
 #include <linux/seg6_local.h>
 #include <linux/if_tunnel.h>
@@ -50,6 +52,8 @@ static const char *format_encap_type(int type)
 		return "seg6";
 	case LWTUNNEL_ENCAP_SEG6_LOCAL:
 		return "seg6local";
+	case LWTUNNEL_ENCAP_RPL:
+		return "rpl";
 	default:
 		return "unknown";
 	}
@@ -84,6 +88,8 @@ static int read_encap_type(const char *name)
 		return LWTUNNEL_ENCAP_SEG6;
 	else if (strcmp(name, "seg6local") == 0)
 		return LWTUNNEL_ENCAP_SEG6_LOCAL;
+	else if (strcmp(name, "rpl") == 0)
+		return LWTUNNEL_ENCAP_RPL;
 	else if (strcmp(name, "help") == 0)
 		encap_type_usage();
 
@@ -162,6 +168,42 @@ static void print_encap_seg6(FILE *fp, struct rtattr *encap)
 	print_srh(fp, tuninfo->srh);
 }
 
+static void print_rpl_srh(FILE *fp, struct ipv6_rpl_sr_hdr *srh)
+{
+	int i;
+
+	if (is_json_context())
+		open_json_array(PRINT_JSON, "segs");
+	else
+		fprintf(fp, "segs %d [ ", srh->segments_left);
+
+	for (i = srh->segments_left - 1; i >= 0; i--) {
+		print_color_string(PRINT_ANY, COLOR_INET6,
+				   NULL, "%s ",
+				   rt_addr_n2a(AF_INET6, 16, &srh->rpl_segaddr[i]));
+	}
+
+	if (is_json_context())
+		close_json_array(PRINT_JSON, NULL);
+	else
+		fprintf(fp, "] ");
+}
+
+static void print_encap_rpl(FILE *fp, struct rtattr *encap)
+{
+	struct rtattr *tb[RPL_IPTUNNEL_MAX + 1];
+	struct ipv6_rpl_sr_hdr *srh;
+
+	parse_rtattr_nested(tb, RPL_IPTUNNEL_MAX, encap);
+
+	if (!tb[RPL_IPTUNNEL_SRH])
+		return;
+
+	srh = RTA_DATA(tb[RPL_IPTUNNEL_SRH]);
+
+	print_rpl_srh(fp, srh);
+}
+
 static const char *seg6_action_names[SEG6_LOCAL_ACTION_MAX + 1] = {
 	[SEG6_LOCAL_ACTION_END]			= "End",
 	[SEG6_LOCAL_ACTION_END_X]		= "End.X",
@@ -567,6 +609,9 @@ void lwt_print_encap(FILE *fp, struct rtattr *encap_type,
 	case LWTUNNEL_ENCAP_SEG6_LOCAL:
 		print_encap_seg6local(fp, encap);
 		break;
+	case LWTUNNEL_ENCAP_RPL:
+		print_encap_rpl(fp, encap);
+		break;
 	}
 }
 
@@ -690,6 +735,79 @@ out:
 	return ret;
 }
 
+static struct ipv6_rpl_sr_hdr *parse_rpl_srh(char *segbuf)
+{
+	struct ipv6_rpl_sr_hdr *srh;
+	int nsegs = 0;
+	int srhlen;
+	char *s;
+	int i;
+
+	s = segbuf;
+	for (i = 0; *s; *s++ == ',' ? i++ : *s);
+	nsegs = i + 1;
+
+	srhlen = 8 + 16 * nsegs;
+
+	srh = calloc(1, srhlen);
+
+	srh->hdrlen = (srhlen >> 3) - 1;
+	srh->type = 3;
+	srh->segments_left = nsegs;
+
+	for (s = strtok(segbuf, ","); s; s = strtok(NULL, ",")) {
+		inet_prefix addr;
+
+		get_addr(&addr, s, AF_INET6);
+		memcpy(&srh->rpl_segaddr[i], addr.data, sizeof(struct in6_addr));
+		i--;
+	}
+
+	return srh;
+}
+
+static int parse_encap_rpl(struct rtattr *rta, size_t len, int *argcp,
+			   char ***argvp)
+{
+	struct ipv6_rpl_sr_hdr *srh;
+	char **argv = *argvp;
+	char segbuf[1024] = "";
+	int argc = *argcp;
+	int segs_ok = 0;
+	int ret = 0;
+	int srhlen;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "segs") == 0) {
+			NEXT_ARG();
+			if (segs_ok++)
+				duparg2("segs", *argv);
+
+			strlcpy(segbuf, *argv, 1024);
+		} else {
+			break;
+		}
+		argc--; argv++;
+	}
+
+	srh = parse_rpl_srh(segbuf);
+	srhlen = (srh->hdrlen + 1) << 3;
+
+	if (rta_addattr_l(rta, len, RPL_IPTUNNEL_SRH, srh,
+			  srhlen)) {
+		ret = -1;
+		goto out;
+	}
+
+	*argcp = argc + 1;
+	*argvp = argv - 1;
+
+out:
+	free(srh);
+
+	return ret;
+}
+
 struct lwt_x {
 	struct rtattr *rta;
 	size_t len;
@@ -1537,6 +1655,9 @@ int lwt_parse_encap(struct rtattr *rta, size_t len, int *argcp, char ***argvp,
 	case LWTUNNEL_ENCAP_SEG6_LOCAL:
 		ret = parse_encap_seg6local(rta, len, &argc, &argv);
 		break;
+	case LWTUNNEL_ENCAP_RPL:
+		ret = parse_encap_rpl(rta, len, &argc, &argv);
+		break;
 	default:
 		fprintf(stderr, "Error: unsupported encap type\n");
 		break;
-- 
2.20.1

