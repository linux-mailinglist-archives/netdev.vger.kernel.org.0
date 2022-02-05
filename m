Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A714AA9BF
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380266AbiBEPwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:52:31 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:52550 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbiBEPw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:52:28 -0500
Received: from ubuntu.home (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 4CADD200E1D6;
        Sat,  5 Feb 2022 16:52:26 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 4CADD200E1D6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1644076346;
        bh=Aelfwuvm0x48pZoPzIszTqcwXU1xV/xjeH3wxBJMmys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uW3IccNB0nLT3N0oP6uAzu1Z99nsX5CYH1DGaa2UYwnfKNoVg3CRCpviPVOgnGjzD
         26HvgozsO+AFUB3QHL28ztprMe5T/Qqw8pPr0eVeABrX3BkB63dzmnTb2FAEIsixAs
         k2njLs36GKowkMDxwCP0b/9iRFUbPrOovHlDvAi3IjDeADyIyT9upA5by+qWNfth/G
         mFRXkIfNIE7uTsgf+wSNEJM7CWUbedJmMRHv+fdiz/Q50Zdfat4dcnA1nlwhoNbcun
         GAE7JJBs8JPS7GYMDqlvNiSf0NHczqB/7lL1WQWweglPuwYNeCGp7ckYzBOLAGxdiu
         BluCSUWQ9OcYQ==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, stephen@networkplumber.org,
        justin.iurman@uliege.be
Subject: [PATCH iproute2-next 1/2] Add support for the IOAM insertion frequency
Date:   Sat,  5 Feb 2022 16:52:07 +0100
Message-Id: <20220205155208.22531-2-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220205155208.22531-1-justin.iurman@uliege.be>
References: <20220205155208.22531-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the IOAM insertion frequency by introducing
a new parameter "freq". The expected value is "k/n", see the patchset
description for more details.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 ip/iproute_lwtunnel.c | 69 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index b05dffc6..f4192229 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -242,12 +242,20 @@ static void print_encap_ioam6(FILE *fp, struct rtattr *encap)
 {
 	struct rtattr *tb[IOAM6_IPTUNNEL_MAX + 1];
 	struct ioam6_trace_hdr *trace;
+	__u32 freq_k, freq_n;
 	__u8 mode;
 
 	parse_rtattr_nested(tb, IOAM6_IPTUNNEL_MAX, encap);
-	if (!tb[IOAM6_IPTUNNEL_MODE] || !tb[IOAM6_IPTUNNEL_TRACE])
+	if (!tb[IOAM6_IPTUNNEL_MODE] || !tb[IOAM6_IPTUNNEL_TRACE] ||
+	    !tb[IOAM6_IPTUNNEL_FREQ_K] || !tb[IOAM6_IPTUNNEL_FREQ_N])
 		return;
 
+	freq_k = rta_getattr_u32(tb[IOAM6_IPTUNNEL_FREQ_K]);
+	freq_n = rta_getattr_u32(tb[IOAM6_IPTUNNEL_FREQ_N]);
+
+	print_uint(PRINT_ANY, "freqk", "freq %u", freq_k);
+	print_uint(PRINT_ANY, "freqn", "/%u ", freq_n);
+
 	mode = rta_getattr_u8(tb[IOAM6_IPTUNNEL_MODE]);
 	if (!tb[IOAM6_IPTUNNEL_DST] && mode != IOAM6_IPTUNNEL_MODE_INLINE)
 		return;
@@ -919,6 +927,31 @@ out:
 	return ret;
 }
 
+static int parse_ioam6_freq(char *buf, __u32 *freq_k, __u32 *freq_n)
+{
+	char *s;
+	int i;
+
+	s = buf;
+	for (i = 0; *s; *s++ == '/' ? i++ : *s);
+	if (i != 1)
+		return 1;
+
+	s = strtok(buf, "/");
+	if (!s || get_u32(freq_k, s, 10))
+		return 1;
+
+	s = strtok(NULL, "/");
+	if (!s || get_u32(freq_n, s, 10))
+		return 1;
+
+	s = strtok(NULL, "/");
+	if (s)
+		return 1;
+
+	return 0;
+}
+
 static int parse_encap_ioam6(struct rtattr *rta, size_t len, int *argcp,
 			     char ***argvp)
 {
@@ -927,9 +960,39 @@ static int parse_encap_ioam6(struct rtattr *rta, size_t len, int *argcp,
 	struct ioam6_trace_hdr *trace;
 	char **argv = *argvp;
 	__u32 trace_type = 0;
+	__u32 freq_k, freq_n;
+	char buf[16] = {0};
 	inet_prefix addr;
 	__u8 mode;
 
+	if (strcmp(*argv, "freq") != 0) {
+		freq_k = IOAM6_IPTUNNEL_FREQ_MIN;
+		freq_n = IOAM6_IPTUNNEL_FREQ_MIN;
+	} else {
+		NEXT_ARG();
+
+		if (strlen(*argv) > sizeof(buf) - 1)
+			invarg("Invalid frequency (too long)", *argv);
+
+		strncpy(buf, *argv, sizeof(buf));
+
+		if (parse_ioam6_freq(buf, &freq_k, &freq_n))
+			invarg("Invalid frequency (malformed)", *argv);
+
+		if (freq_k < IOAM6_IPTUNNEL_FREQ_MIN ||
+		    freq_k > IOAM6_IPTUNNEL_FREQ_MAX)
+			invarg("Out of bound \"k\" frequency", *argv);
+
+		if (freq_n < IOAM6_IPTUNNEL_FREQ_MIN ||
+		    freq_n > IOAM6_IPTUNNEL_FREQ_MAX)
+			invarg("Out of bound \"n\" frequency", *argv);
+
+		if (freq_k > freq_n)
+			invarg("Frequency with k > n is forbidden", *argv);
+
+		NEXT_ARG();
+	}
+
 	if (strcmp(*argv, "mode") != 0) {
 		mode = IOAM6_IPTUNNEL_MODE_INLINE;
 	} else {
@@ -1020,7 +1083,9 @@ static int parse_encap_ioam6(struct rtattr *rta, size_t len, int *argcp,
 	trace->namespace_id = htons(trace_ns);
 	trace->remlen = (__u8)(trace_size / 4);
 
-	if (rta_addattr8(rta, len, IOAM6_IPTUNNEL_MODE, mode) ||
+	if (rta_addattr32(rta, len, IOAM6_IPTUNNEL_FREQ_K, freq_k) ||
+	    rta_addattr32(rta, len, IOAM6_IPTUNNEL_FREQ_N, freq_n) ||
+	    rta_addattr8(rta, len, IOAM6_IPTUNNEL_MODE, mode) ||
 	    (mode != IOAM6_IPTUNNEL_MODE_INLINE &&
 	     rta_addattr_l(rta, len, IOAM6_IPTUNNEL_DST, &addr.data, addr.bytelen)) ||
 	    rta_addattr_l(rta, len, IOAM6_IPTUNNEL_TRACE, trace, sizeof(*trace))) {
-- 
2.25.1

