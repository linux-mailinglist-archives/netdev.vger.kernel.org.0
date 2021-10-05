Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DE0422BF2
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbhJEPMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:12:41 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:51151 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235090AbhJEPMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 11:12:36 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 377B5200F49A;
        Tue,  5 Oct 2021 17:10:44 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 377B5200F49A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633446644;
        bh=I0nEP8vfKGW6TukYOp64csYtSH20p6E70bEMluuQCHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQDFk5iQXIpXpBhBapqVThyTc64ZYtyKvyjdQVqry5j7rygctXVFnI0vSotblh65Q
         Vbqlj5P/VnqGtCI0cXsedhw9ltXJG2pIlcidaDlbkYefCN8oVcbYc784X8bilvHfqD
         EOdTOhHLUhp+bhgl5Fv6NUP+o445csMnBrysmSW+vA9kH4u1T23HLMghsd1sjV2URW
         LRrL0dF+lu5cugJVnwC4BD5bENRpeyUwUf1zd7SkjyzmtokG7pOgrfbTtE63eDmRFm
         GwFhTyA+eiyS12uQhC4tvtjHbAQ5zEGh+wsONKnnVa/FYISnqG2J1SyKPwsAV+uFSY
         ZhyUM6wciS/QQ==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org,
        stephen@networkplumber.org, justin.iurman@uliege.be
Subject: [PATCH iproute2-next v2 2/2] Update documentation
Date:   Tue,  5 Oct 2021 17:10:20 +0200
Message-Id: <20211005151020.32533-3-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211005151020.32533-1-justin.iurman@uliege.be>
References: <20211005151020.32533-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updates the IOAM documentation (ip-route man page) to reflect the
three encap modes that were introduced.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 man/man8/ip-route.8.in | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/man/man8/ip-route.8.in b/man/man8/ip-route.8.in
index c9a9cbf1..ed628455 100644
--- a/man/man8/ip-route.8.in
+++ b/man/man8/ip-route.8.in
@@ -246,13 +246,17 @@ throw " | " unreachable " | " prohibit " | " blackhole " | " nat " ]"
 .ti -8
 .IR ENCAP_IOAM6 " := "
 .B ioam6
-.BR trace
-.BR prealloc
-.BR type
+.BR mode " [ "
+.BR inline " | " encap " | " auto " ] ["
+.B tundst
+.IR ADDRESS " ] "
+.B trace
+.B prealloc
+.B type
 .IR IOAM6_TRACE_TYPE
-.BR ns
+.B ns
 .IR IOAM6_NAMESPACE
-.BR size
+.B size
 .IR IOAM6_TRACE_SIZE
 
 .ti -8
@@ -915,14 +919,35 @@ address is set as described in \fBip-sr\fR(8).
 
 .B ioam6
 .in +2
+.B mode inline
+- Directly insert IOAM after IPv6 header (default mode).
+.sp
+
+.B mode encap
+- Encapsulate packet in an outer IPv6 header with IOAM.
+.sp
+
+.B mode auto
+- Automatically use inline mode for local packets and encap mode for in-transit
+packets.
+.sp
+
+.B tundst
+.I ADDRESS
+- IPv6 address of the tunnel destination (outer header), not used with inline
+mode.
+
+.B type
 .I IOAM6_TRACE_TYPE
 - List of IOAM data required in the trace, represented by a bitfield (24 bits).
 .sp
 
+.B ns
 .I IOAM6_NAMESPACE
 - Numerical value to represent an IOAM namespace. See \fBip-ioam\fR(8).
 .sp
 
+.B size
 .I IOAM6_TRACE_SIZE
 - Size, in octets, of the pre-allocated trace data block.
 .in -4
@@ -1249,9 +1274,9 @@ ip -6 route add 2001:db8:1::/64 encap seg6local action End.DT46 vrftable 100 dev
 Adds an IPv6 route with SRv6 decapsulation and forward with lookup in VRF table.
 .RE
 .PP
-ip -6 route add 2001:db8:1::/64 encap ioam6 trace prealloc type 0x800000 ns 1 size 12 dev eth0
+ip -6 route add 2001:db8:1::/64 encap ioam6 mode encap tundst 2001:db8:42::1 trace prealloc type 0x800000 ns 1 size 12 dev eth0
 .RS 4
-Adds an IPv6 route with an IOAM Pre-allocated Trace encapsulation that only includes the hop limit and the node id, configured for the IOAM namespace 1 and a pre-allocated data block of 12 octets.
+Adds an IPv6 route with an IOAM Pre-allocated Trace encapsulation (ip6ip6) that only includes the hop limit and the node id, configured for the IOAM namespace 1 and a pre-allocated data block of 12 octets.
 .RE
 .PP
 ip route add 10.1.1.0/30 nhid 10
-- 
2.25.1

