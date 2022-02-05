Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046F24AA9C0
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380265AbiBEPw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:52:29 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:52548 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380261AbiBEPw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:52:28 -0500
Received: from ubuntu.home (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 28C19200E1CA;
        Sat,  5 Feb 2022 16:52:26 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 28C19200E1CA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1644076346;
        bh=aValCkateL77rejlKxcKeLo6+p8cavReFz3Kr0QQPIM=;
        h=From:To:Cc:Subject:Date:From;
        b=lOeqJWJws3THS6J9bQ64O21NBl+R8qEWQOWE30FQOE7SfUCjnNK7WtMeWZBnoa3Ew
         loLyzeqp72yad+l2LjRCxi8/kEnvHQtjSp3pBHwKkCPG7IjWwAfXWAkuLlsy+QlN2m
         eajPwlfi3++RVwBYptneEkXZVqssm2cDeUB8s8AocAP4+Getq3O44BLEUGWXNSAD0l
         CaDxtffzovCqL/fW66uYjj4tiBBMV8ujASRCZFBkQ3SdOYHn4yg4r/chUdREHWG0RK
         sOco2nEd4LARJoKCsckVLBa9ZjlotM/+qc83AMGpGmGCVSkIHe3Obf/4g5h19iFW2Z
         PyrmFUAEo789g==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, stephen@networkplumber.org,
        justin.iurman@uliege.be
Subject: [PATCH iproute2-next 0/2] Support for the IOAM insertion frequency
Date:   Sat,  5 Feb 2022 16:52:06 +0100
Message-Id: <20220205155208.22531-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset requires an update of kernel headers:

diff --git a/include/uapi/linux/ioam6_iptunnel.h b/include/uapi/linux/ioam6_iptunnel.h
index 829ffdfcacca8..38f6a8fdfd343 100644
--- a/include/uapi/linux/ioam6_iptunnel.h
+++ b/include/uapi/linux/ioam6_iptunnel.h
@@ -41,6 +41,15 @@ enum {
 	/* IOAM Trace Header */
 	IOAM6_IPTUNNEL_TRACE,		/* struct ioam6_trace_hdr */
 
+	/* Insertion frequency:
+	 * "k over n" packets (0 < k <= n)
+	 * [0.0001% ... 100%]
+	 */
+#define IOAM6_IPTUNNEL_FREQ_MIN 1
+#define IOAM6_IPTUNNEL_FREQ_MAX 1000000
+	IOAM6_IPTUNNEL_FREQ_K,		/* u32 */
+	IOAM6_IPTUNNEL_FREQ_N,		/* u32 */
+
 	__IOAM6_IPTUNNEL_MAX,
 };

The insertion frequency is represented as "k/n", meaning IOAM will be
added to "k" packets over "n" packets, with 0 < k <= n <= 1000000.
Therefore, it provides the following range of insertion frequencies:
[0.0001% ... 100%].

Default frequency is "1/1" (i.e., applied to all packets) for backward
compatibility.

Previous command:
ip -6 ro ad fc00::1/128 encap ioam6 mode ...
    
New command:
ip -6 ro ad fc00::1/128 encap ioam6 [ freq k/n ] mode ...

Justin Iurman (2):
  Add support for the IOAM insertion frequency
  Update documentation

 ip/iproute_lwtunnel.c  | 69 ++++++++++++++++++++++++++++++++++++++++--
 man/man8/ip-route.8.in | 11 +++++--
 2 files changed, 75 insertions(+), 5 deletions(-)

-- 
2.25.1

