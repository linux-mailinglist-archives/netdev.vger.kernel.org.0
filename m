Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 151E2161D8D
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgBQWpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:45:19 -0500
Received: from mail-qv1-f41.google.com ([209.85.219.41]:45939 "EHLO
        mail-qv1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgBQWpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:45:19 -0500
Received: by mail-qv1-f41.google.com with SMTP id l14so8285648qvu.12
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 14:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C8MhAzJWS50BSu4JT4oJxlSc/jYCNNl/m+H/bKAJaOs=;
        b=COkHAoctxRVWi9gwukle5saKxHOvlqmIlK0nQrg+wqXns0RS2785fhUPsSYHUNknKc
         ZRmQALOCFi9VN9QFpGktFYnh4NcbMSxIZ+vcA/h0nkqaCUbxfwHH0GCMmbrvmQezL4/a
         maJJdEwf94V7hG2lWvKhQAdcIteShnEfR5Ro1pToa3UAAz5aze7AK6X/n8OXRhjFlzSX
         hDtcpNtGgya3R+sjJkWkZrUGMpqY97W6vq0LmXOt7Hl0zN0L+NgbUvON+zyHQrSEywzD
         +PpfoGsoG/J1vLm2OtqonKJCUoc8ySYC5Dt8VUD/5gQvWGT9VIRrqpuffDQI3Lg4HYlg
         +4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C8MhAzJWS50BSu4JT4oJxlSc/jYCNNl/m+H/bKAJaOs=;
        b=uh3SHXhnc5HJVPYfc3QT5SW++C1geRZhdmIOPAQyBboFFBJ/JVlcmOVVXmEIgEjpc6
         0BwGSdYp01mgIAv/eF1ySzZsdMkqn1HeqeHdgyfNNZF93TfxNwB+0BNlT9jo7oja2o/F
         E5IkTzrb/1fLcUKNvQkyXWVMzNCTYJkOgMYpg2SMXNrussZerertaDbZfum1P5i+P6gs
         6aMOoh+njUUgqxkqiXSB0ePar3MOPtqfypt2abGrxhFnzG3FzG7sJh2SOwc96m6/y2Ak
         FR2KG22bLg3j5EydUT43orcu6Ssf9rW7Ng2jN21KkuvsSp9AAuze23+/k7pUDo+Cd8Kl
         9SPQ==
X-Gm-Message-State: APjAAAUcraIR3rME+JB89SPsLkhdEElyxqoPmdigkjA0JW9CjP1sL6uk
        Wum/qgRVDGI/S0mGmSDlyZA=
X-Google-Smtp-Source: APXvYqxGUzpmPz/2+jwtiQoIyZpRI7t3j5a17Dx9G3UvLifYzkJmgfi0vUDNyI8BANDUfrZYm5X8Lg==
X-Received: by 2002:a0c:f9c7:: with SMTP id j7mr14608274qvo.222.1581979517462;
        Mon, 17 Feb 2020 14:45:17 -0800 (PST)
Received: from localhost.localdomain ([216.154.21.195])
        by smtp.gmail.com with ESMTPSA id w21sm984725qth.17.2020.02.17.14.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 14:45:17 -0800 (PST)
From:   Alexander Aring <alex.aring@gmail.com>
To:     stephen@networkplumber.org
Cc:     dsahern@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [RFC iproute2-next 2/2] lwtunnel: add support for rpl segment routing
Date:   Mon, 17 Feb 2020 17:44:54 -0500
Message-Id: <20200217224454.22297-2-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200217224454.22297-1-alex.aring@gmail.com>
References: <20200217224454.22297-1-alex.aring@gmail.com>
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
 ip/iproute.c          |   2 +-
 ip/iproute_lwtunnel.c | 111 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index 93b805c9..f636eb26 100644
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
index 0d7d7149..1524b8fe 100644
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
 
@@ -162,6 +168,32 @@ static void print_encap_seg6(FILE *fp, struct rtattr *encap)
 	print_srh(fp, tuninfo->srh);
 }
 
+static void print_rpl_srh(FILE *fp, struct ipv6_rpl_sr_hdr *srh)
+{
+	int i;
+
+	for (i = srh->segments_left - 1; i >= 0; i--) {
+		print_color_string(PRINT_ANY, COLOR_INET6,
+				   NULL, "%s ",
+				   rt_addr_n2a(AF_INET6, 16, &srh->rpl_segaddr[i]));
+	}
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
@@ -457,6 +489,9 @@ void lwt_print_encap(FILE *fp, struct rtattr *encap_type,
 	case LWTUNNEL_ENCAP_SEG6_LOCAL:
 		print_encap_seg6local(fp, encap);
 		break;
+	case LWTUNNEL_ENCAP_RPL:
+		print_encap_rpl(fp, encap);
+		break;
 	}
 }
 
@@ -580,6 +615,79 @@ out:
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
@@ -1159,6 +1267,9 @@ int lwt_parse_encap(struct rtattr *rta, size_t len, int *argcp, char ***argvp,
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

