Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66C41B6FE1
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgDXIjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:39:12 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36752 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726383AbgDXIjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 04:39:11 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O8a2jN026673;
        Fri, 24 Apr 2020 01:39:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=0a52gfI0mDrT3jOTxWY44wvZqA1iaR7BjoKPP92+7Rk=;
 b=cud4atK6X4AA6bOoHUfvqNXlwo3KLgyyb73EBwQGWFsscHIzbCuWTOiWaMSOhJ38DuJx
 Lr/GWqlaoEXBeBIHptVOiuY3oG4EhFyD6mREVyTq1mx7E3sDqbN37ZEXmE5EFa4lHpuw
 f4zsgRIOoKa1TdD8OLvDG6keD7N6GIV5hP4Xo4wYpz6e+8KSP0ROkGiAZ9rtPDctBhkT
 FfyIXviboxnzEYCGX6dvVoLE5KqwFCDLemkAPyfvoJV7Di2VmkXDinoSER00/a0z0TGX
 2gbxFSXzeZRcJMYjqoebpzidhaYFTzP77u8HvElrKsHQ57G9OdtdJO5PWTbhAgq8o9l5 jA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsbcgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 01:39:09 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 01:39:07 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 01:39:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 01:39:06 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id B1FDA3F703F;
        Fri, 24 Apr 2020 01:39:04 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH iproute2-next 2/2] macsec: add support for specifying offload at link add time
Date:   Fri, 24 Apr 2020 11:38:57 +0300
Message-ID: <20200424083857.1265-3-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424083857.1265-1-irusskikh@marvell.com>
References: <20200424083857.1265-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch adds support for configuring offload mode upon MACsec
device creation.

If offload mode is not specified, then netlink attribute is not
added. Default behavior on the kernel side in this case is
backward-compatible (offloading is disabled by default).

Example:
$ ip link add link eth0 macsec0 type macsec port 11 encrypt on offload mac

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 ip/ipmacsec.c        | 20 ++++++++++++++++++++
 man/man8/ip-macsec.8 |  8 +++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index d214b101..18289ecd 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -1220,6 +1220,15 @@ static void macsec_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			     validate_to_str(val));
 	}
 
+	if (tb[IFLA_MACSEC_OFFLOAD]) {
+		__u8 val = rta_getattr_u8(tb[IFLA_MACSEC_OFFLOAD]);
+
+		print_string(PRINT_ANY,
+			     "offload",
+			     "offload %s ",
+			     offload_to_str(val));
+	}
+
 	const char *inc_sci, *es, *replay;
 
 	if (is_json_context()) {
@@ -1268,6 +1277,7 @@ static void usage(FILE *f)
 		"                  [ replay { on | off} window { 0..2^32-1 } ]\n"
 		"                  [ validate { strict | check | disabled } ]\n"
 		"                  [ encodingsa { 0..3 } ]\n"
+		"                  [ offload { mac | phy | off } ]\n"
 		);
 }
 
@@ -1277,6 +1287,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 	int ret;
 	__u8 encoding_sa = 0xff;
 	__u32 window = -1;
+	enum macsec_offload offload;
 	struct cipher_args cipher = {0};
 	enum macsec_validation_type validate;
 	bool es = false, scb = false, send_sci = false;
@@ -1398,6 +1409,15 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			ret = get_an(&encoding_sa, *argv);
 			if (ret)
 				invarg("expected an { 0..3 }", *argv);
+		} else if (strcmp(*argv, "offload") == 0) {
+			NEXT_ARG();
+			ret = one_of("offload", *argv,
+				     offload_str, ARRAY_SIZE(offload_str),
+				     (int *)&offload);
+			if (ret != 0)
+				return ret;
+			addattr8(n, MACSEC_BUFLEN,
+				 IFLA_MACSEC_OFFLOAD, offload);
 		} else {
 			fprintf(stderr, "macsec: unknown command \"%s\"?\n",
 				*argv);
diff --git a/man/man8/ip-macsec.8 b/man/man8/ip-macsec.8
index b2ee7bee..8e9175c5 100644
--- a/man/man8/ip-macsec.8
+++ b/man/man8/ip-macsec.8
@@ -23,6 +23,8 @@ ip-macsec \- MACsec device configuration
 ] [
 .BR validate " { " strict " | " check " | " disabled " } ] ["
 .BI encodingsa " SA"
+] [
+.BR offload " { " off " | " phy " | " mac " }"
 ]
 
 .BI "ip macsec add " DEV " tx sa"
@@ -86,7 +88,7 @@ type.
 
 .SH EXAMPLES
 .PP
-.SS Create a MACsec device on link eth0
+.SS Create a MACsec device on link eth0 (offload is disabled by default)
 .nf
 # ip link add link eth0 macsec0 type macsec port 11 encrypt on
 .PP
@@ -109,6 +111,10 @@ type.
 .SS Configure offloading on an interface
 .nf
 # ip macsec offload macsec0 phy
+.PP
+.SS Configure offloading upon MACsec device creation
+.nf
+# ip link add link eth0 macsec0 type macsec port 11 encrypt on offload mac
 
 .SH NOTES
 This tool can be used to configure the 802.1AE keys of the interface. Note that 802.1AE uses GCM-AES
-- 
2.20.1

