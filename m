Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287B83943C2
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbhE1OIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229740AbhE1OIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 10:08:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E7756101E;
        Fri, 28 May 2021 14:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622210800;
        bh=HH5q8JJVdKeGGK8p3f7WNYx/WXN66r6JWlTlCE7PF+I=;
        h=From:To:Cc:Subject:Date:From;
        b=fOHvePcjx9TjCo6x2A6NhPi+3gXlqHxc44PM1MG0FKVQHcB8fK3eAgL8PD1xY+tYE
         HWtKO3l5mkRJ7jAoQA+mWr9298xTpUe44bOhCNzLnZBDeZctj1V8AUpFtxD6aylJhQ
         rruAsGYX2+XAu7SaWgJgBVzXapATUToOmCK3DEBswoIa0nd83wymUeupeSpnZpDn1Z
         Hs7VJCEsZN4gUiLxVYEujHanYZ2ur6m1pBlecFwH1shYrwifPaKBPFocW8bnP/D3YI
         +mLtx2NqmAmJ8sG70vDkYYY118Ja69scOBNoGWskhyvBZmOjVGBkqXaV34Cwc3AkeU
         A4C3OUdBUWTnw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next] samples: pktgen: add UDP tx checksum support
Date:   Fri, 28 May 2021 16:06:35 +0200
Message-Id: <cf16417902062c6ea2fd3c79e00510e36a40c31a.1622210713.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce k parameter in pktgen samples in order to toggle UDP tx
checksum

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- use spaces instead of tabs
---
 samples/pktgen/parameters.sh                               | 7 ++++++-
 samples/pktgen/pktgen_sample01_simple.sh                   | 2 ++
 samples/pktgen/pktgen_sample02_multiqueue.sh               | 2 ++
 samples/pktgen/pktgen_sample03_burst_single_flow.sh        | 2 ++
 samples/pktgen/pktgen_sample04_many_flows.sh               | 2 ++
 samples/pktgen/pktgen_sample05_flow_per_thread.sh          | 2 ++
 .../pktgen_sample06_numa_awared_queue_irq_affinity.sh      | 2 ++
 7 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/samples/pktgen/parameters.sh b/samples/pktgen/parameters.sh
index b4c1b371e4b8..81906f199454 100644
--- a/samples/pktgen/parameters.sh
+++ b/samples/pktgen/parameters.sh
@@ -11,6 +11,7 @@ function usage() {
     echo "  -d : (\$DEST_IP)   destination IP. CIDR (e.g. 198.18.0.0/15) is also allowed"
     echo "  -m : (\$DST_MAC)   destination MAC-addr"
     echo "  -p : (\$DST_PORT)  destination PORT range (e.g. 433-444) is also allowed"
+    echo "  -k : (\$UDP_CSUM)  enable UDP tx checksum"
     echo "  -t : (\$THREADS)   threads to start"
     echo "  -f : (\$F_THREAD)  index of first thread (zero indexed CPU number)"
     echo "  -c : (\$SKB_CLONE) SKB clones send before alloc new SKB"
@@ -26,7 +27,7 @@ function usage() {
 
 ##  --- Parse command line arguments / parameters ---
 ## echo "Commandline options:"
-while getopts "s:i:d:m:p:f:t:c:n:b:w:vxh6a" option; do
+while getopts "s:i:d:m:p:f:t:c:n:b:w:vxh6ak" option; do
     case $option in
         i) # interface
           export DEV=$OPTARG
@@ -88,6 +89,10 @@ while getopts "s:i:d:m:p:f:t:c:n:b:w:vxh6a" option; do
           export APPEND=yes
           info "Append mode: APPEND=$APPEND"
           ;;
+        k)
+          export UDP_CSUM=yes
+          info "UDP tx checksum: UDP_CSUM=$UDP_CSUM"
+          ;;
         h|?|*)
           usage;
           err 2 "[ERROR] Unknown parameters!!!"
diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen/pktgen_sample01_simple.sh
index a09f3422fbcc..246cfe02bb82 100755
--- a/samples/pktgen/pktgen_sample01_simple.sh
+++ b/samples/pktgen/pktgen_sample01_simple.sh
@@ -72,6 +72,8 @@ if [ -n "$DST_PORT" ]; then
     pg_set $DEV "udp_dst_max $UDP_DST_MAX"
 fi
 
+[ ! -z "$UDP_CSUM" ] && pg_set $dev "flag UDPCSUM"
+
 # Setup random UDP port src range
 pg_set $DEV "flag UDPSRC_RND"
 pg_set $DEV "udp_src_min $UDP_SRC_MIN"
diff --git a/samples/pktgen/pktgen_sample02_multiqueue.sh b/samples/pktgen/pktgen_sample02_multiqueue.sh
index acae8ede0d6c..c6af3d9d5171 100755
--- a/samples/pktgen/pktgen_sample02_multiqueue.sh
+++ b/samples/pktgen/pktgen_sample02_multiqueue.sh
@@ -75,6 +75,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 	pg_set $dev "udp_dst_max $UDP_DST_MAX"
     fi
 
+    [ ! -z "$UDP_CSUM" ] && pg_set $dev "flag UDPCSUM"
+
     # Setup random UDP port src range
     pg_set $dev "flag UDPSRC_RND"
     pg_set $dev "udp_src_min $UDP_SRC_MIN"
diff --git a/samples/pktgen/pktgen_sample03_burst_single_flow.sh b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
index 5adcf954de73..ab87de440277 100755
--- a/samples/pktgen/pktgen_sample03_burst_single_flow.sh
+++ b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
@@ -73,6 +73,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 	pg_set $dev "udp_dst_max $UDP_DST_MAX"
     fi
 
+    [ ! -z "$UDP_CSUM" ] && pg_set $dev "flag UDPCSUM"
+
     # Setup burst, for easy testing -b 0 disable bursting
     # (internally in pktgen default and minimum burst=1)
     if [[ ${BURST} -ne 0 ]]; then
diff --git a/samples/pktgen/pktgen_sample04_many_flows.sh b/samples/pktgen/pktgen_sample04_many_flows.sh
index ddce876635aa..56c5f5af350f 100755
--- a/samples/pktgen/pktgen_sample04_many_flows.sh
+++ b/samples/pktgen/pktgen_sample04_many_flows.sh
@@ -72,6 +72,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 	pg_set $dev "udp_dst_max $UDP_DST_MAX"
     fi
 
+    [ ! -z "$UDP_CSUM" ] && pg_set $dev "flag UDPCSUM"
+
     # Randomize source IP-addresses
     pg_set $dev "flag IPSRC_RND"
     pg_set $dev "src_min $SRC_MIN"
diff --git a/samples/pktgen/pktgen_sample05_flow_per_thread.sh b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
index 4a65fe2fcee9..6e0effabca59 100755
--- a/samples/pktgen/pktgen_sample05_flow_per_thread.sh
+++ b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
@@ -62,6 +62,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 	pg_set $dev "udp_dst_max $UDP_DST_MAX"
     fi
 
+    [ ! -z "$UDP_CSUM" ] && pg_set $dev "flag UDPCSUM"
+
     # Setup source IP-addresses based on thread number
     pg_set $dev "src_min 198.18.$((thread+1)).1"
     pg_set $dev "src_max 198.18.$((thread+1)).1"
diff --git a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
index 10f1da571f40..7c27923083a6 100755
--- a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
+++ b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
@@ -92,6 +92,8 @@ for ((i = 0; i < $THREADS; i++)); do
 	pg_set $dev "udp_dst_max $UDP_DST_MAX"
     fi
 
+    [ ! -z "$UDP_CSUM" ] && pg_set $dev "flag UDPCSUM"
+
     # Setup random UDP port src range
     pg_set $dev "flag UDPSRC_RND"
     pg_set $dev "udp_src_min $UDP_SRC_MIN"
-- 
2.31.1

