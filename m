Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF851CFAFC
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 15:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730904AbfJHNLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 09:11:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31804 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730439AbfJHNLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 09:11:11 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0AB3F30BEBE5;
        Tue,  8 Oct 2019 13:11:11 +0000 (UTC)
Received: from griffin.upir.cz (ovpn-204-214.brq.redhat.com [10.40.204.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2878B1001B05;
        Tue,  8 Oct 2019 13:11:09 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Petar Penkov <ppenkov@google.com>
Subject: [PATCH bpf 1/2] selftests/bpf: set rp_filter in test_flow_dissector
Date:   Tue,  8 Oct 2019 15:10:44 +0200
Message-Id: <513a298f53e99561d2f70b2e60e2858ea6cda754.1570539863.git.jbenc@redhat.com>
In-Reply-To: <cover.1570539863.git.jbenc@redhat.com>
References: <cover.1570539863.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 08 Oct 2019 13:11:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many distributions enable rp_filter. However, the flow dissector test
generates packets that have 1.1.1.1 set as (inner) source address without
this address being reachable. This causes the selftest to fail.

The selftests should not assume a particular initial configuration. Switch
off rp_filter.

Fixes: 50b3ed57dee9 ("selftests/bpf: test bpf flow dissection")
Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 tools/testing/selftests/bpf/test_flow_dissector.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_flow_dissector.sh b/tools/testing/selftests/bpf/test_flow_dissector.sh
index d23d4da66b83..e2d06191bd35 100755
--- a/tools/testing/selftests/bpf/test_flow_dissector.sh
+++ b/tools/testing/selftests/bpf/test_flow_dissector.sh
@@ -63,6 +63,9 @@ fi
 
 # Setup
 tc qdisc add dev lo ingress
+echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
+echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
+echo 0 > /proc/sys/net/ipv4/conf/lo/rp_filter
 
 echo "Testing IPv4..."
 # Drops all IP/UDP packets coming from port 9
-- 
2.18.1

