Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72614A0BBD
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfH1UnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:43:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44028 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfH1UnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:43:14 -0400
Received: by mail-pf1-f195.google.com with SMTP id v12so515674pfn.10
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 13:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MLIHHIpzkC4kCE1PAolGcWi6OOjeYQW3bmTW4v3Jt7c=;
        b=PqNTo9cF12RPGb7lqPb9ccu5B9/v3OHlez6zO0AqIenEOezSBomaLgrloO0i2gpabj
         BlUwktFV1qzHc8QdNUlea9jfcYTfei1TD8TqLOa59qH0Vpq+X62JzYzfBiyHMq3Gef9E
         mPaCIP9puiYNYIkDmdhxleLEzGyDyWQTf7DyBNkcbFUixM6WGjGGW92AMacrNVyDVil1
         st5i4NH+Z4XFu5nng4VhdKyIW1R3o4OnCfJ71KZUk2Z/Lq/5vW8ZUnV71P7MPKx7oI5Y
         0cDJQJAltAAnN5QhYcuvklxrEzfzDf574tgTGJVAupL6FhUaUMXoE0L9b3eWn+ZiQukm
         +7gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MLIHHIpzkC4kCE1PAolGcWi6OOjeYQW3bmTW4v3Jt7c=;
        b=A/TsCsWNwYieY9SaF40rT3/bJGFS00/7YllMUMZLzme3B79vuCNChB5l2nt28iYVqi
         4ghxmk6HgekS5g4kKQpwxAk1Omugig3ohFskgODq5V+MfC/YKhpBk4SViyAX2Yt8OQcy
         +i7OSqGJLKVUCG7ilTz+Gxxy7xhQ3QkpJOAA0paGmg0Ke/CiKbwaru5AEGNIrig9JNvU
         op6+qPG3Q4Xl2ofhtm2YxlefcPbjCun+/Ve14BI2r2rpYsrx0UPBI9jCu2NL1eboMbhp
         n1hTWPTBuJ9qch0BeK7b2DWzukznBV6d0MCKVZJFSt/QIoXn9tcS4lGPc4/MHZ0xvqOQ
         qjPA==
X-Gm-Message-State: APjAAAWWyf6GloXpJROUjQwekkKNvqPUHzA/D3ZYJdVgwjDpdk9TwpiT
        tvm4jtxqQKacJEZ8Myutpg==
X-Google-Smtp-Source: APXvYqz0bzXMqhdZhZxPDGgFBtF0L6pDaz8pJC6cJ9s+fQZV44KkoB2ZYnkl8xqtaT2QfPUK26750Q==
X-Received: by 2002:a63:6eca:: with SMTP id j193mr5007982pgc.74.1567024992854;
        Wed, 28 Aug 2019 13:43:12 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id z14sm36320pjr.23.2019.08.28.13.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 13:43:12 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 3/3] samples: pktgen: allow to specify destination IP range (CIDR)
Date:   Thu, 29 Aug 2019 05:42:43 +0900
Message-Id: <20190828204243.16666-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190828204243.16666-1-danieltimlee@gmail.com>
References: <20190828204243.16666-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, kernel pktgen has the feature to specify destination
address range for sending packet. (e.g. pgset "dst_min/dst_max")

But on samples, each of them doesn't have any option to achieve this.

The commit adds feature to specify destination address range with CIDR.

    -d : ($DEST_IP)   destination IP. CIDR (e.g. 198.18.0.0/15) is also allowed

    # ./pktgen_sample01_simple.sh -6 -d fe80::20/126 -p 3000 -n 4
    # tcpdump ip6 and udp
    05:14:18.082285 IP6 fe80::99.71 > fe80::23.3000: UDP, length 16
    05:14:18.082564 IP6 fe80::99.43 > fe80::23.3000: UDP, length 16
    05:14:18.083366 IP6 fe80::99.107 > fe80::22.3000: UDP, length 16
    05:14:18.083585 IP6 fe80::99.97 > fe80::21.3000: UDP, length 16

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/pktgen/README.rst                             |  2 +-
 samples/pktgen/parameters.sh                          |  2 +-
 .../pktgen/pktgen_bench_xmit_mode_netif_receive.sh    |  4 +++-
 samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh   |  4 +++-
 samples/pktgen/pktgen_sample01_simple.sh              |  4 +++-
 samples/pktgen/pktgen_sample02_multiqueue.sh          |  4 +++-
 samples/pktgen/pktgen_sample03_burst_single_flow.sh   |  4 +++-
 samples/pktgen/pktgen_sample04_many_flows.sh          | 11 ++++++++---
 samples/pktgen/pktgen_sample05_flow_per_thread.sh     |  4 +++-
 .../pktgen_sample06_numa_awared_queue_irq_affinity.sh |  4 +++-
 10 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/samples/pktgen/README.rst b/samples/pktgen/README.rst
index fd39215db508..3f6483e8b2df 100644
--- a/samples/pktgen/README.rst
+++ b/samples/pktgen/README.rst
@@ -18,7 +18,7 @@ across the sample scripts.  Usage example is printed on errors::
  Usage: ./pktgen_sample01_simple.sh [-vx] -i ethX
   -i : ($DEV)       output interface/device (required)
   -s : ($PKT_SIZE)  packet size
-  -d : ($DEST_IP)   destination IP
+  -d : ($DEST_IP)   destination IP. CIDR (e.g. 198.18.0.0/15) is also allowed
   -m : ($DST_MAC)   destination MAC-addr
   -p : ($DST_PORT)  destination PORT range (e.g. 433-444) is also allowed
   -t : ($THREADS)   threads to start
diff --git a/samples/pktgen/parameters.sh b/samples/pktgen/parameters.sh
index a06b00a0c7b6..ff0ed474fee9 100644
--- a/samples/pktgen/parameters.sh
+++ b/samples/pktgen/parameters.sh
@@ -8,7 +8,7 @@ function usage() {
     echo "Usage: $0 [-vx] -i ethX"
     echo "  -i : (\$DEV)       output interface/device (required)"
     echo "  -s : (\$PKT_SIZE)  packet size"
-    echo "  -d : (\$DEST_IP)   destination IP"
+    echo "  -d : (\$DEST_IP)   destination IP. CIDR (e.g. 198.18.0.0/15) is also allowed"
     echo "  -m : (\$DST_MAC)   destination MAC-addr"
     echo "  -p : (\$DST_PORT)  destination PORT range (e.g. 433-444) is also allowed"
     echo "  -t : (\$THREADS)   threads to start"
diff --git a/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh b/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
index 9b74502c58f7..da6cb711b7f4 100755
--- a/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
+++ b/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
@@ -41,6 +41,7 @@ fi
 [ -z "$DST_MAC" ] && DST_MAC="90:e2:ba:ff:ff:ff"
 [ -z "$BURST" ] && BURST=1024
 [ -z "$COUNT" ] && COUNT="10000000" # Zero means indefinitely
+[ -n "$DEST_IP" ] && read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -71,7 +72,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst$IP6 $DEST_IP"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
index 0f332555b40d..355937787364 100755
--- a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
+++ b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
@@ -24,6 +24,7 @@ if [[ -n "$BURST" ]]; then
     err 1 "Bursting not supported for this mode"
 fi
 [ -z "$COUNT" ] && COUNT="10000000" # Zero means indefinitely
+[ -n "$DEST_IP" ] && read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -54,7 +55,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst$IP6 $DEST_IP"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen/pktgen_sample01_simple.sh
index 063ec0998906..08995fa70025 100755
--- a/samples/pktgen/pktgen_sample01_simple.sh
+++ b/samples/pktgen/pktgen_sample01_simple.sh
@@ -22,6 +22,7 @@ fi
 # Example enforce param "-m" for dst_mac
 [ -z "$DST_MAC" ] && usage && err 2 "Must specify -m dst_mac"
 [ -z "$COUNT" ]   && COUNT="100000" # Zero means indefinitely
+[ -n "$DEST_IP" ] && read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -61,7 +62,8 @@ pg_set $DEV "flag NO_TIMESTAMP"
 
 # Destination
 pg_set $DEV "dst_mac $DST_MAC"
-pg_set $DEV "dst$IP6 $DEST_IP"
+pg_set $DEV "dst${IP6}_min $DST_MIN"
+pg_set $DEV "dst${IP6}_max $DST_MAX"
 
 if [ -n "$DST_PORT" ]; then
     # Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample02_multiqueue.sh b/samples/pktgen/pktgen_sample02_multiqueue.sh
index a4726fb50197..9b806e41c23a 100755
--- a/samples/pktgen/pktgen_sample02_multiqueue.sh
+++ b/samples/pktgen/pktgen_sample02_multiqueue.sh
@@ -29,6 +29,7 @@ if [ -z "$DEST_IP" ]; then
     [ -z "$IP6" ] && DEST_IP="198.18.0.42" || DEST_IP="FD00::1"
 fi
 [ -z "$DST_MAC" ] && DST_MAC="90:e2:ba:ff:ff:ff"
+[ -n "$DEST_IP" ] && read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -62,7 +63,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst$IP6 $DEST_IP"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample03_burst_single_flow.sh b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
index dfea91a09ccc..cb067788ceb3 100755
--- a/samples/pktgen/pktgen_sample03_burst_single_flow.sh
+++ b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
@@ -33,6 +33,7 @@ fi
 [ -z "$BURST" ]     && BURST=32
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0" # No need for clones when bursting
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
+[ -n "$DEST_IP" ]   && read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -62,7 +63,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst$IP6 $DEST_IP"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample04_many_flows.sh b/samples/pktgen/pktgen_sample04_many_flows.sh
index 7ea9b4a3acf6..626e33016869 100755
--- a/samples/pktgen/pktgen_sample04_many_flows.sh
+++ b/samples/pktgen/pktgen_sample04_many_flows.sh
@@ -17,6 +17,7 @@ source ${basedir}/parameters.sh
 [ -z "$DST_MAC" ]   && DST_MAC="90:e2:ba:ff:ff:ff"
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
+[ -n "$DEST_IP" ]   && read -r DST_MIN DST_MAX <<< $(parse_addr $DEST_IP)
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -37,6 +38,9 @@ if [[ -n "$BURST" ]]; then
     err 1 "Bursting not supported for this mode"
 fi
 
+# 198.18.0.0 / 198.19.255.255
+read -r SRC_MIN SRC_MAX <<< $(parse_addr 198.18.0.0/15)
+
 # General cleanup everything since last run
 pg_ctrl "reset"
 
@@ -58,7 +62,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Single destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst $DEST_IP"
+    pg_set $dev "dst_min $DST_MIN"
+    pg_set $dev "dst_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
@@ -69,8 +74,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Randomize source IP-addresses
     pg_set $dev "flag IPSRC_RND"
-    pg_set $dev "src_min 198.18.0.0"
-    pg_set $dev "src_max 198.19.255.255"
+    pg_set $dev "src_min $SRC_MIN"
+    pg_set $dev "src_max $SRC_MAX"
 
     # Limit number of flows (max 65535)
     pg_set $dev "flows $FLOWS"
diff --git a/samples/pktgen/pktgen_sample05_flow_per_thread.sh b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
index fbfafe029e11..cb79de073e9d 100755
--- a/samples/pktgen/pktgen_sample05_flow_per_thread.sh
+++ b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
@@ -22,6 +22,7 @@ source ${basedir}/parameters.sh
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 [ -z "$BURST" ]     && BURST=32
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
+[ -n "$DEST_IP" ]   && read -r DST_MIN DST_MAX <<< $(parse_addr $DEST_IP)
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -51,7 +52,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Single destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst $DEST_IP"
+    pg_set $dev "dst_min $DST_MIN"
+    pg_set $dev "dst_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
index 755e662183f1..739adcda5b5f 100755
--- a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
+++ b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
@@ -35,6 +35,7 @@ if [ -z "$DEST_IP" ]; then
     [ -z "$IP6" ] && DEST_IP="198.18.0.42" || DEST_IP="FD00::1"
 fi
 [ -z "$DST_MAC" ] && DST_MAC="90:e2:ba:ff:ff:ff"
+[ -n "$DEST_IP" ] && read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -79,7 +80,8 @@ for ((i = 0; i < $THREADS; i++)); do
 
     # Destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst$IP6 $DEST_IP"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
-- 
2.20.1

