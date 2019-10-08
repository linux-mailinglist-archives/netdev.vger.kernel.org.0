Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15800CFAFF
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 15:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbfJHNLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 09:11:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36646 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730439AbfJHNLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 09:11:12 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 36F223018FC5;
        Tue,  8 Oct 2019 13:11:12 +0000 (UTC)
Received: from griffin.upir.cz (ovpn-204-214.brq.redhat.com [10.40.204.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55EB11001B08;
        Tue,  8 Oct 2019 13:11:11 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Peter Oskolkov <posk@google.com>
Subject: [PATCH bpf 2/2] selftests/bpf: more compatible nc options in test_lwt_ip_encap
Date:   Tue,  8 Oct 2019 15:10:45 +0200
Message-Id: <9f177682c387f3f943bb64d849e6c6774df3c5b4.1570539863.git.jbenc@redhat.com>
In-Reply-To: <cover.1570539863.git.jbenc@redhat.com>
References: <cover.1570539863.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 08 Oct 2019 13:11:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Out of the three nc implementations widely in use, at least two (BSD netcat
and nmap-ncat) do not support -l combined with -s. Modify the nc invocation
to be accepted by all of them.

Fixes: 17a90a788473 ("selftests/bpf: test that GSO works in lwt_ip_encap")
Cc: Peter Oskolkov <posk@google.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_lwt_ip_encap.sh b/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
index acf7a74f97cd..59ea56945e6c 100755
--- a/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
+++ b/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
@@ -314,15 +314,15 @@ test_gso()
 	command -v nc >/dev/null 2>&1 || \
 		{ echo >&2 "nc is not available: skipping TSO tests"; return; }
 
-	# listen on IPv*_DST, capture TCP into $TMPFILE
+	# listen on port 9000, capture TCP into $TMPFILE
 	if [ "${PROTO}" == "IPv4" ] ; then
 		IP_DST=${IPv4_DST}
 		ip netns exec ${NS3} bash -c \
-			"nc -4 -l -s ${IPv4_DST} -p 9000 > ${TMPFILE} &"
+			"nc -4 -l -p 9000 > ${TMPFILE} &"
 	elif [ "${PROTO}" == "IPv6" ] ; then
 		IP_DST=${IPv6_DST}
 		ip netns exec ${NS3} bash -c \
-			"nc -6 -l -s ${IPv6_DST} -p 9000 > ${TMPFILE} &"
+			"nc -6 -l -p 9000 > ${TMPFILE} &"
 		RET=$?
 	else
 		echo "    test_gso: unknown PROTO: ${PROTO}"
-- 
2.18.1

