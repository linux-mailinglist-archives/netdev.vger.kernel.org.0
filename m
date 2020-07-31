Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D46233FE6
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbgGaHTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:19:46 -0400
Received: from out1.virusfree.cz ([212.24.139.170]:34409 "EHLO
        out1.virusfree.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731507AbgGaHTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 03:19:45 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jul 2020 03:19:44 EDT
Received: (qmail 31601 invoked from network); 31 Jul 2020 09:13:02 +0200
Received: from out1.virusfree.cz by out1.virusfree.cz
 (VF-Scanner: Clear:RC:0(2001:67c:1591::6):SC:0(-1.8/5.0):CC:0:;
 processed in 0.7 s); 31 Jul 2020 07:13:02 +0000
X-VF-Scanner-Mail-From: pv@excello.cz
X-VF-Scanner-Rcpt-To: netdev@vger.kernel.org
X-VF-Scanner-ID: 20200731071301.723535.31572.out1.virusfree.cz.0
X-Spam-Status: No, hits=-1.8, required=5.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=excello.cz; h=
        date:message-id:from:to:subject:reply-to; q=dns/txt; s=default;
         t=1596179581; bh=LfQoxVq1c3lQhb1EHbrQw4VY4TJ2e9/KfLs7oCHukcs=; b=
        WmiQwEYgAoYakLWC7YHlOQ96r3/wW/g6MBUGJdn12fGGlz5D6fpbisPC1CZ9fo5S
        YUZaojMO/X1cfP9XCEELveEDP0/bifCiaJDaLQ0Wqzja7Pu6GSNZRy5bdFrlJwz/
        tJa+KUZ7IG5AbB+pydNrxe47jDNUQbhm6eN139Q1bfo=
Received: from posta.excello.cz (2001:67c:1591::6)
  by out1.virusfree.cz with ESMTPS (TLSv1.3, TLS_AES_256_GCM_SHA384); 31 Jul 2020 09:13:01 +0200
Received: from atlantis (unknown [IPv6:2001:67c:1590::2c8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by posta.excello.cz (Postfix) with ESMTPSA id 002A69DBDFE;
        Fri, 31 Jul 2020 09:13:00 +0200 (CEST)
Date:   Fri, 31 Jul 2020 09:12:59 +0200
From:   Petr =?utf-8?B?VmFuxJtr?= <pv@excello.cz>
To:     netdev@vger.kernel.org
Cc:     Petr =?utf-8?B?VmFuxJtr?= <pv@excello.cz>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next] ip-xfrm: add support for oseq-may-wrap extra
 flag
Message-ID: <20200731071259.GA3192@atlantis>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200530123912.GA7476@arkam>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This flag allows to create SA where sequence number can cycle in
outbound packets if set.

Signed-off-by: Petr Vaněk <pv@excello.cz>
---
 include/uapi/linux/xfrm.h | 1 +
 ip/ipxfrm.c               | 3 +++
 ip/xfrm_state.c           | 4 +++-
 man/man8/ip-xfrm.8        | 2 +-
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 50450f3f..6dfb3c85 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -387,6 +387,7 @@ struct xfrm_usersa_info {
 };
 
 #define XFRM_SA_XFLAG_DONT_ENCAP_DSCP	1
+#define XFRM_SA_XFLAG_OSEQ_MAY_WRAP    2
 
 struct xfrm_usersa_id {
 	xfrm_address_t			daddr;
diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
index fec206ab..cac8ba25 100644
--- a/ip/ipxfrm.c
+++ b/ip/ipxfrm.c
@@ -953,6 +953,9 @@ void xfrm_state_info_print(struct xfrm_usersa_info *xsinfo,
 		XFRM_FLAG_PRINT(fp, extra_flags,
 				XFRM_SA_XFLAG_DONT_ENCAP_DSCP,
 				"dont-encap-dscp");
+		XFRM_FLAG_PRINT(fp, extra_flags,
+				XFRM_SA_XFLAG_OSEQ_MAY_WRAP,
+				"oseq-may-wrap");
 		if (extra_flags)
 			fprintf(fp, "%x", extra_flags);
 	}
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index f4bf3356..ddf784ca 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -104,7 +104,7 @@ static void usage(void)
 		"FLAG-LIST := [ FLAG-LIST ] FLAG\n"
 		"FLAG := noecn | decap-dscp | nopmtudisc | wildrecv | icmp | af-unspec | align4 | esn\n"
 		"EXTRA-FLAG-LIST := [ EXTRA-FLAG-LIST ] EXTRA-FLAG\n"
-		"EXTRA-FLAG := dont-encap-dscp\n"
+		"EXTRA-FLAG := dont-encap-dscp | oseq-may-wrap\n"
 		"SELECTOR := [ src ADDR[/PLEN] ] [ dst ADDR[/PLEN] ] [ dev DEV ] [ UPSPEC ]\n"
 		"UPSPEC := proto { { tcp | udp | sctp | dccp } [ sport PORT ] [ dport PORT ] |\n"
 		"                  { icmp | ipv6-icmp | mobility-header } [ type NUMBER ] [ code NUMBER ] |\n"
@@ -253,6 +253,8 @@ static int xfrm_state_extra_flag_parse(__u32 *extra_flags, int *argcp, char ***a
 		while (1) {
 			if (strcmp(*argv, "dont-encap-dscp") == 0)
 				*extra_flags |= XFRM_SA_XFLAG_DONT_ENCAP_DSCP;
+			else if (strcmp(*argv, "oseq-may-wrap") == 0)
+				*extra_flags |= XFRM_SA_XFLAG_OSEQ_MAY_WRAP;
 			else {
 				PREV_ARG(); /* back track */
 				break;
diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index aa28db49..4fa31651 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -217,7 +217,7 @@ ip-xfrm \- transform configuration
 
 .ti -8
 .IR EXTRA-FLAG " := "
-.B dont-encap-dscp
+.BR dont-encap-dscp " | " oseq-may-wrap
 
 .ti -8
 .BR "ip xfrm policy" " { " add " | " update " }"
-- 
2.26.2

