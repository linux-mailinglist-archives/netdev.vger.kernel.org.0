Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383E73DF3A0
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237793AbhHCRKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:10:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:16903 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237691AbhHCRKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 13:10:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="213466142"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="213466142"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:10:21 -0700
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="521327149"
Received: from shyamasr-mobl.amr.corp.intel.com ([10.209.65.83])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:10:19 -0700
From:   Kishen Maloor <kishen.maloor@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, hawk@kernel.org,
        magnus.karlsson@intel.com
Cc:     Jithu Joseph <jithu.joseph@intel.com>
Subject: [RFC bpf-next 4/5] samples/bpf/xdpsock_user.c: Make get_nsecs() generic
Date:   Tue,  3 Aug 2021 13:10:05 -0400
Message-Id: <20210803171006.13915-5-kishen.maloor@intel.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210803171006.13915-1-kishen.maloor@intel.com>
References: <20210803171006.13915-1-kishen.maloor@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jithu Joseph <jithu.joseph@intel.com>

The helper function get_nsecs() assumes clock to be CLOCK_MONOTONIC.

TSN features like Launchtime uses CLOCK_TAI. Subsequent patch
extends this sample to show how Launchtime APIs maybe used
in XDP context.

In prepration for this, extend the function to add CLOCKID parameter.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 samples/bpf/xdpsock_user.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 33d0bdebbed8..3fd2f6a0d1eb 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -159,11 +159,11 @@ static int num_socks;
 struct xsk_socket_info *xsks[MAX_SOCKS];
 int sock;
 
-static unsigned long get_nsecs(void)
+static unsigned long get_nsecs(int clockid)
 {
 	struct timespec ts;
 
-	clock_gettime(CLOCK_MONOTONIC, &ts);
+	clock_gettime(clockid, &ts);
 	return ts.tv_sec * 1000000000UL + ts.tv_nsec;
 }
 
@@ -354,7 +354,7 @@ static void dump_driver_stats(long dt)
 
 static void dump_stats(void)
 {
-	unsigned long now = get_nsecs();
+	unsigned long now = get_nsecs(CLOCK_MONOTONIC);
 	long dt = now - prev_time;
 	int i;
 
@@ -443,7 +443,7 @@ static void dump_stats(void)
 static bool is_benchmark_done(void)
 {
 	if (opt_duration > 0) {
-		unsigned long dt = (get_nsecs() - start_time);
+		unsigned long dt = (get_nsecs(CLOCK_MONOTONIC) - start_time);
 
 		if (dt >= opt_duration)
 			benchmark_done = true;
@@ -1683,7 +1683,7 @@ int main(int argc, char **argv)
 			exit_with_error(ret);
 	}
 
-	prev_time = get_nsecs();
+	prev_time = get_nsecs(CLOCK_MONOTONIC);
 	start_time = prev_time;
 
 	if (opt_bench == BENCH_RXDROP)
-- 
2.24.3 (Apple Git-128)

