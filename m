Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6771345FE23
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 11:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245442AbhK0KjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 05:39:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350829AbhK0KhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 05:37:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638009240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oagZDQega6BQjya/PFnprPuFHhH/qSIhnnW8Za3OLAM=;
        b=jJuiPmngk8dX2D5rsmkuZAkw1+R3I1ioxsvNKhqcrSBNTf/a9SKwPvyLv3VAiHz2nDLps3
        C52e1A5bIqN6jBksWGn1sPhDbxVuTo8yay0mWW7YMOXIsngBKiLiZrFDjf9aOj34MW/XQH
        8TpfdnJyO+hlBQLKAoxnKYbFEjcgeNs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-Nby8gUTROfGk9hbHr_QqpQ-1; Sat, 27 Nov 2021 05:33:56 -0500
X-MC-Unique: Nby8gUTROfGk9hbHr_QqpQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EBF72F21;
        Sat, 27 Nov 2021 10:33:55 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB12876613;
        Sat, 27 Nov 2021 10:33:53 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH nf 2/2] selftests: netfilter: Add correctness test for mac,net set type
Date:   Sat, 27 Nov 2021 11:33:38 +0100
Message-Id: <142425004cc8d6bc6777fef933d3f290491f87c4.1637976889.git.sbrivio@redhat.com>
In-Reply-To: <cover.1637976889.git.sbrivio@redhat.com>
References: <cover.1637976889.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing net,mac test didn't cover the issue recently reported
by Nikita Yushchenko, where MAC addresses wouldn't match if given
as first field of a concatenated set with AVX2 and 8-bit groups,
because there's a different code path covering the lookup of six
8-bit groups (MAC addresses) if that's the first field.

Add a similar mac,net test, with MAC address and IPv4 address
swapped in the set specification.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 .../selftests/netfilter/nft_concat_range.sh   | 24 ++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tools/testing/selftests/netfilter/nft_concat_range.sh
index 5a4938d6dcf2..ed61f6cab60f 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -23,8 +23,8 @@ TESTS="reported_issues correctness concurrency timeout"
 
 # Set types, defined by TYPE_ variables below
 TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
-       net_port_net net_mac net_mac_icmp net6_mac_icmp net6_port_net6_port
-       net_port_mac_proto_net"
+       net_port_net net_mac mac_net net_mac_icmp net6_mac_icmp
+       net6_port_net6_port net_port_mac_proto_net"
 
 # Reported bugs, also described by TYPE_ variables below
 BUGS="flush_remove_add"
@@ -277,6 +277,23 @@ perf_entries	1000
 perf_proto	ipv4
 "
 
+TYPE_mac_net="
+display		mac,net
+type_spec	ether_addr . ipv4_addr
+chain_spec	ether saddr . ip saddr
+dst		 
+src		mac addr4
+start		1
+count		5
+src_delta	2000
+tools		sendip nc bash
+proto		udp
+
+race_repeat	0
+
+perf_duration	0
+"
+
 TYPE_net_mac_icmp="
 display		net,mac - ICMP
 type_spec	ipv4_addr . ether_addr
@@ -984,7 +1001,8 @@ format() {
 		fi
 	done
 	for f in ${src}; do
-		__expr="${__expr} . "
+		[ "${__expr}" != "{ " ] && __expr="${__expr} . "
+
 		__start="$(eval format_"${f}" "${srcstart}")"
 		__end="$(eval format_"${f}" "${srcend}")"
 
-- 
2.30.2

