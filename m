Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F00CC8C2
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 10:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfJEIZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 04:25:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46144 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfJEIZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 04:25:29 -0400
Received: by mail-pg1-f193.google.com with SMTP id a3so5075203pgm.13
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 01:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YxSRogy08od91Qhrsvv73BFtigGpHBVeZAidJ8OLqYw=;
        b=C2+w94MhfHxS/5il8Kr/9HQSrYxDF3iUhOrKW9tCc7I2v2V+F/WTbvfvEDTPC5UrXx
         HVLMk4Ga0GJtO+3Tl/wVnrnvsictL/zFW7y7uZcWZAKaSdDpt74GaDmOva/4mz2HgI/w
         BvcVwkIU3MlGEe3SLZ/+t5OjFtbSPmOLB57L0GBJHjEq7qzonYmsKDD3+PLVSMrx/Icr
         dypkZun0KTjDn6OvuQYBinweGQRE2TYzzGM/DRiJ7K4I8GyrWlNVW5OKu2zKMzJyseTd
         1QidaTIup0FiUEAYMXl9nfrHXrjXeso5Ur1jsqJTboRRAEIp3+zGeV5zDET371kGC2Dm
         2OtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YxSRogy08od91Qhrsvv73BFtigGpHBVeZAidJ8OLqYw=;
        b=fm7hDKqby9zC4RKyI31HqIy3xvcin4pfGgI4wpAe/efNFT+nLXh4K6yNbOOAqaJdUS
         hAmEIXFNJ2g2ICcikpwZfpIrtRihHe0YWakPYu8Cm2E7SN+QwOThjRqmX/ILLWIwmiEd
         bXYCWT3u9Zgl2cRQf+Mv3aewwdIpKI498ZaNqln2+tuHbSCoTHdtxiCT/p7Cu/724Ww/
         xDMDzAMV9JkH2h/MHBw6OSM0uOr83quJfhu9oSZnkxkWVPd/aRtgQTKAsI+Xy1cIhJ95
         6fwJo2ZUv4GCvPtDyRV1Arrk/LzAAamOv7BII5H2jFh/kRWP2Vw6uLBPwJQ4GAiZXY0c
         b5Sw==
X-Gm-Message-State: APjAAAWnrpNSaD1Qv+7aVceH+4oUZGdIpHsjvkWCMKLk04dIHgWXBfuo
        WJt/cULHEGmzdUeoEq0vNNXSu0W+zEd0
X-Google-Smtp-Source: APXvYqwzoEdRB0RUjfLUuGHsPk4YuK2jDFwNdTMtw048aKmDUuuWXI1JPv6+TXYvOgR6XFBHCTXHMQ==
X-Received: by 2002:a63:ca06:: with SMTP id n6mr19398947pgi.17.1570263928165;
        Sat, 05 Oct 2019 01:25:28 -0700 (PDT)
Received: from localhost.localdomain ([106.254.212.20])
        by smtp.gmail.com with ESMTPSA id dw19sm7161838pjb.27.2019.10.05.01.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 01:25:27 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v5 4/4] samples: pktgen: allow to specify destination IP range (CIDR)
Date:   Sat,  5 Oct 2019 17:25:09 +0900
Message-Id: <20191005082509.16137-5-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191005082509.16137-1-danieltimlee@gmail.com>
References: <20191005082509.16137-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, kernel pktgen has the feature to specify destination
address range for sending packet. (e.g. pgset "dst_min/dst_max")

But on samples, each pktgen script doesn't have any option to achieve this.

This commit adds the feature to specify the destination address range with CIDR.

    -d : ($DEST_IP)   destination IP. CIDR (e.g. 198.18.0.0/15) is also allowed

    # ./pktgen_sample01_simple.sh -6 -d fe80::20/126 -p 3000 -n 4
    # tcpdump ip6 and udp
    05:14:18.082285 IP6 fe80::99.71 > fe80::23.3000: UDP, length 16
    05:14:18.082564 IP6 fe80::99.43 > fe80::23.3000: UDP, length 16
    05:14:18.083366 IP6 fe80::99.107 > fe80::22.3000: UDP, length 16
    05:14:18.083585 IP6 fe80::99.97 > fe80::21.3000: UDP, length 16

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
Changes since v4:
 * 'validate_addr' is called prior to 'parse_addr'

 samples/pktgen/README.rst                          |  2 +-
 samples/pktgen/parameters.sh                       |  2 +-
 .../pktgen/pktgen_bench_xmit_mode_netif_receive.sh |  7 ++++++-
 .../pktgen/pktgen_bench_xmit_mode_queue_xmit.sh    |  7 ++++++-
 samples/pktgen/pktgen_sample01_simple.sh           |  7 ++++++-
 samples/pktgen/pktgen_sample02_multiqueue.sh       |  7 ++++++-
 .../pktgen/pktgen_sample03_burst_single_flow.sh    |  7 ++++++-
 samples/pktgen/pktgen_sample04_many_flows.sh       | 14 +++++++++++---
 samples/pktgen/pktgen_sample05_flow_per_thread.sh  |  7 ++++++-
 ...tgen_sample06_numa_awared_queue_irq_affinity.sh |  7 ++++++-
 10 files changed, 55 insertions(+), 12 deletions(-)

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
index 9b74502c58f7..1b6204125d2d 100755
--- a/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
+++ b/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
@@ -41,6 +41,10 @@ fi
 [ -z "$DST_MAC" ] && DST_MAC="90:e2:ba:ff:ff:ff"
 [ -z "$BURST" ] && BURST=1024
 [ -z "$COUNT" ] && COUNT="10000000" # Zero means indefinitely
+if [ -n "$DEST_IP" ]; then
+    validate_addr${IP6} $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
+fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -71,7 +75,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst$IP6 $DEST_IP"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
index 0f332555b40d..e607cb369b20 100755
--- a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
+++ b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
@@ -24,6 +24,10 @@ if [[ -n "$BURST" ]]; then
     err 1 "Bursting not supported for this mode"
 fi
 [ -z "$COUNT" ] && COUNT="10000000" # Zero means indefinitely
+if [ -n "$DEST_IP" ]; then
+    validate_addr${IP6} $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
+fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -54,7 +58,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst$IP6 $DEST_IP"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen/pktgen_sample01_simple.sh
index 063ec0998906..a4e250b45dce 100755
--- a/samples/pktgen/pktgen_sample01_simple.sh
+++ b/samples/pktgen/pktgen_sample01_simple.sh
@@ -22,6 +22,10 @@ fi
 # Example enforce param "-m" for dst_mac
 [ -z "$DST_MAC" ] && usage && err 2 "Must specify -m dst_mac"
 [ -z "$COUNT" ]   && COUNT="100000" # Zero means indefinitely
+if [ -n "$DEST_IP" ]; then
+    validate_addr${IP6} $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
+fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -61,7 +65,8 @@ pg_set $DEV "flag NO_TIMESTAMP"
 
 # Destination
 pg_set $DEV "dst_mac $DST_MAC"
-pg_set $DEV "dst$IP6 $DEST_IP"
+pg_set $DEV "dst${IP6}_min $DST_MIN"
+pg_set $DEV "dst${IP6}_max $DST_MAX"
 
 if [ -n "$DST_PORT" ]; then
     # Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample02_multiqueue.sh b/samples/pktgen/pktgen_sample02_multiqueue.sh
index a4726fb50197..cb2495fcdc60 100755
--- a/samples/pktgen/pktgen_sample02_multiqueue.sh
+++ b/samples/pktgen/pktgen_sample02_multiqueue.sh
@@ -29,6 +29,10 @@ if [ -z "$DEST_IP" ]; then
     [ -z "$IP6" ] && DEST_IP="198.18.0.42" || DEST_IP="FD00::1"
 fi
 [ -z "$DST_MAC" ] && DST_MAC="90:e2:ba:ff:ff:ff"
+if [ -n "$DEST_IP" ]; then
+    validate_addr${IP6} $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
+fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -62,7 +66,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst$IP6 $DEST_IP"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample03_burst_single_flow.sh b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
index dfea91a09ccc..fff50765a5aa 100755
--- a/samples/pktgen/pktgen_sample03_burst_single_flow.sh
+++ b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
@@ -33,6 +33,10 @@ fi
 [ -z "$BURST" ]     && BURST=32
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0" # No need for clones when bursting
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
+if [ -n "$DEST_IP" ]; then
+    validate_addr${IP6} $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
+fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -62,7 +66,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst$IP6 $DEST_IP"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample04_many_flows.sh b/samples/pktgen/pktgen_sample04_many_flows.sh
index 7ea9b4a3acf6..2cd6b701400d 100755
--- a/samples/pktgen/pktgen_sample04_many_flows.sh
+++ b/samples/pktgen/pktgen_sample04_many_flows.sh
@@ -17,6 +17,10 @@ source ${basedir}/parameters.sh
 [ -z "$DST_MAC" ]   && DST_MAC="90:e2:ba:ff:ff:ff"
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
+if [ -n "$DEST_IP" ]; then
+    validate_addr $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr $DEST_IP)
+fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -37,6 +41,9 @@ if [[ -n "$BURST" ]]; then
     err 1 "Bursting not supported for this mode"
 fi
 
+# 198.18.0.0 / 198.19.255.255
+read -r SRC_MIN SRC_MAX <<< $(parse_addr 198.18.0.0/15)
+
 # General cleanup everything since last run
 pg_ctrl "reset"
 
@@ -58,7 +65,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Single destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst $DEST_IP"
+    pg_set $dev "dst_min $DST_MIN"
+    pg_set $dev "dst_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
@@ -69,8 +77,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Randomize source IP-addresses
     pg_set $dev "flag IPSRC_RND"
-    pg_set $dev "src_min 198.18.0.0"
-    pg_set $dev "src_max 198.19.255.255"
+    pg_set $dev "src_min $SRC_MIN"
+    pg_set $dev "src_max $SRC_MAX"
 
     # Limit number of flows (max 65535)
     pg_set $dev "flows $FLOWS"
diff --git a/samples/pktgen/pktgen_sample05_flow_per_thread.sh b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
index fbfafe029e11..4cb6252ade39 100755
--- a/samples/pktgen/pktgen_sample05_flow_per_thread.sh
+++ b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
@@ -22,6 +22,10 @@ source ${basedir}/parameters.sh
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 [ -z "$BURST" ]     && BURST=32
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
+if [ -n "$DEST_IP" ]; then
+    validate_addr $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr $DEST_IP)
+fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -51,7 +55,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Single destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst $DEST_IP"
+    pg_set $dev "dst_min $DST_MIN"
+    pg_set $dev "dst_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
index 755e662183f1..728106060a02 100755
--- a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
+++ b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
@@ -35,6 +35,10 @@ if [ -z "$DEST_IP" ]; then
     [ -z "$IP6" ] && DEST_IP="198.18.0.42" || DEST_IP="FD00::1"
 fi
 [ -z "$DST_MAC" ] && DST_MAC="90:e2:ba:ff:ff:ff"
+if [ -n "$DEST_IP" ]; then
+    validate_addr${IP6} $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
+fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
@@ -79,7 +83,8 @@ for ((i = 0; i < $THREADS; i++)); do
 
     # Destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst$IP6 $DEST_IP"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
-- 
2.20.1

