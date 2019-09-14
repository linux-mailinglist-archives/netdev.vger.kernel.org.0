Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A80EB2BC7
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 17:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfINPOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 11:14:06 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:37711 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfINPOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 11:14:05 -0400
Received: by mail-pg1-f180.google.com with SMTP id c17so9111845pgg.4
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 08:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qqh05XsaepBtFk2pPhntNSLhXLxR75PiYXfV1t+zxDA=;
        b=pj//mBOWO0LV/IvfCI5oodCRHW+5UqJ5xvW/IYhDQT9CEUZljsZPCzaum4Mht8Yxss
         q0wLIOQZbe84O9sTPTzG4XXgSOielmPAiLWbNY7Eg/N0hh3XA8G385ZCijnomlYnQEKw
         2LOzv8hVshZREh6O77HHVgCboS6RSJtxavZbR5r4e8Hw0+yLLJRpzvbVS5kCAsde4P8N
         m9Bdif7x3he4CBVAOl86X0pm/luFWQBjBY8P+xU+TJdAMiPaujx3JydsTkcLbf4o65fQ
         B6Bi2IaqNns5tG4QsX0yPYcVwY/3SIXMkdLGONpaIWcob7oHdzu04pjZg+KOPOevxthv
         HGzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qqh05XsaepBtFk2pPhntNSLhXLxR75PiYXfV1t+zxDA=;
        b=UJlBnFD4XN4BHQOUSkDFSX5QpBnuF8hplKAamxjJGJwKH7WdfaTajF0V10pfnQku1i
         3nYuV4XdMtoNxF9ihjcll9kdje4f8kjcJn9+/EoaAUa4E5/SuJ6I+aO34RMlxYO9aMU5
         6HCEQ+p7cyhlU18Y71PTBcJSxVPlAedMwKWqDg4tn72RHZg50qkiTDAhnOPvi3T/bRHK
         U9684syeSrZTi/zYpY+D4x9cSUvBVl+XfWf+I/7UMf4ZexXdV7tzx5eMaJFLDocF7kor
         KD6CeVNG9kkHKT+8UjAW4zzH1lrS6GEOe1wvGX72kw/XzSU5m3nS3GMmXhaQV2cW95r8
         qlRA==
X-Gm-Message-State: APjAAAWbUIDptwtE5glf0xobXiLAs2ru4S+WSFYJRBma7fL1KiDWOhZW
        SiiOrme5+pQx90Whovbryg==
X-Google-Smtp-Source: APXvYqzjqlkAMoxKNZ9U6mSg1tsE+ibSAo6n2+53Oydu8gFuak+DjiW4l/mLCbrBGunLFrFYZ+EVKQ==
X-Received: by 2002:a63:3182:: with SMTP id x124mr11992675pgx.41.1568474044729;
        Sat, 14 Sep 2019 08:14:04 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id u69sm28408689pgu.77.2019.09.14.08.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 08:14:04 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [v3 3/3] samples: pktgen: allow to specify destination IP range (CIDR)
Date:   Sun, 15 Sep 2019 00:13:53 +0900
Message-Id: <20190914151353.18054-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190914151353.18054-1-danieltimlee@gmail.com>
References: <20190914151353.18054-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, kernel pktgen has the feature to specify destination
address range for sending packet. (e.g. pgset "dst_min/dst_max")

But on samples, each of the scripts doesn't have any option to achieve this.

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

