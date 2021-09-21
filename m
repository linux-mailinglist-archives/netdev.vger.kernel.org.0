Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DE34135BD
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 17:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbhIUPBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 11:01:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233815AbhIUPBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 11:01:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632236414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=3MwZzmpHG8Mwf8BTXwTBaHrIO2FY3JgB8JQjnzprEJo=;
        b=WwZfWHHuK2EIEgTrQThBJ8ngr11Z0azwao0bPkSiflgviKfSQv1DsRMTtNKx6JqMx98ZOe
        dKI4BbEeB3ZNCK7jn9Wp96mzx7T+rWAOHS4JWJo60nerSvAoD1Zf6Htx19clPaiWenbg5g
        51tGrOydCfg4qhz+SFZNyZiLgb2bS14=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-SQaV9CJWOqOnz244bSWZ0g-1; Tue, 21 Sep 2021 11:00:13 -0400
X-MC-Unique: SQaV9CJWOqOnz244bSWZ0g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B4CE196633C;
        Tue, 21 Sep 2021 15:00:11 +0000 (UTC)
Received: from griffin.upir.cz (unknown [10.40.194.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC39517AE2;
        Tue, 21 Sep 2021 15:00:09 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH bpf-next] seltests: bpf: test_tunnel: use ip neigh
Date:   Tue, 21 Sep 2021 16:59:11 +0200
Message-Id: <40f24b9d3f0f53b5c44471b452f9a11f4d13b7af.1632236133.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'arp' command is deprecated and is another dependency of the selftest.
Just use 'ip neigh', the test depends on iproute2 already.

Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 tools/testing/selftests/bpf/test_tunnel.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_tunnel.sh b/tools/testing/selftests/bpf/test_tunnel.sh
index 1ccbe804e8e1..ca1372924023 100755
--- a/tools/testing/selftests/bpf/test_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tunnel.sh
@@ -168,14 +168,15 @@ add_vxlan_tunnel()
 	ip netns exec at_ns0 \
 		ip link set dev $DEV_NS address 52:54:00:d9:01:00 up
 	ip netns exec at_ns0 ip addr add dev $DEV_NS 10.1.1.100/24
-	ip netns exec at_ns0 arp -s 10.1.1.200 52:54:00:d9:02:00
+	ip netns exec at_ns0 \
+		ip neigh add 10.1.1.200 lladdr 52:54:00:d9:02:00 dev $DEV_NS
 	ip netns exec at_ns0 iptables -A OUTPUT -j MARK --set-mark 0x800FF
 
 	# root namespace
 	ip link add dev $DEV type $TYPE external gbp dstport 4789
 	ip link set dev $DEV address 52:54:00:d9:02:00 up
 	ip addr add dev $DEV 10.1.1.200/24
-	arp -s 10.1.1.100 52:54:00:d9:01:00
+	ip neigh add 10.1.1.100 lladdr 52:54:00:d9:01:00 dev $DEV
 }
 
 add_ip6vxlan_tunnel()
-- 
2.18.1

