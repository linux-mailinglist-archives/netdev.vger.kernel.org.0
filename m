Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4730F44DD69
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 22:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhKKWAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 17:00:20 -0500
Received: from mga04.intel.com ([192.55.52.120]:23621 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhKKWAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 17:00:19 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="231744048"
X-IronPort-AV: E=Sophos;i="5.87,227,1631602800"; 
   d="scan'208";a="231744048"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 13:57:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,227,1631602800"; 
   d="scan'208";a="534551418"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 11 Nov 2021 13:57:24 -0800
Received: from alobakin-mobl.ger.corp.intel.com (llademan-MOBL2.ger.corp.intel.com [10.213.31.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ABLvLZX026406;
        Thu, 11 Nov 2021 21:57:22 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf] samples: bpf: fix summary per-sec stats in xdp_sample_user
Date:   Thu, 11 Nov 2021 22:57:03 +0100
Message-Id: <20211111215703.690-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sample_summary_print() uses accumulated period to calculate and
display per-sec averages. This period gets incremented by sampling
interval each time a new sample is formed, and thus equals to the
number of samples collected multiplied by this interval.
However, the totals are being calculated differently, they receive
current sample statistics already divided by the interval gotten as
a difference between sample timestamps for better precision -- in
other words, they are being incremented by the per-sec values each
sample.
This leads to the excessive division of summary per-secs when
interval != 1 sec. It is obvious pps couldn't become two times
lower just from picking a different sampling interval value:

$ samples/bpf/xdp_redirect_cpu -p xdp_prognum_n1_inverse_qnum -c all
  -s -d 6 -i 1
< snip >
  Packets received    : 2,197,230,321
  Average packets/s   : 22,887,816
  Packets redirected  : 2,197,230,472
  Average redir/s     : 22,887,817
$ samples/bpf/xdp_redirect_cpu -p xdp_prognum_n1_inverse_qnum -c all
  -s -d 6 -i 2
< snip >
  Packets received    : 159,566,498
  Average packets/s   : 11,397,607
  Packets redirected  : 159,566,995
  Average redir/s     : 11,397,642

This can be easily fixed by treating the divisor not as a period,
but rather as a total number of samples, and thus incrementing it
by 1 instead of interval. As a nice side effect, we can now remove
so-named argument from a couple of functions. Let us also create
an "alias" for sample_output::rx_cnt::pps named 'num' using a union
since this field is used to store this number (period previously)
as well, and the resulting counter-intuitive code might've been
a reason for this bug.

Fixes: 156f886cf697 ("samples: bpf: Add basic infrastructure for XDP samples")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 samples/bpf/xdp_sample_user.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index b32d82178199..8740838e7767 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -120,7 +120,10 @@ struct sample_output {
 		__u64 xmit;
 	} totals;
 	struct {
-		__u64 pps;
+		union {
+			__u64 pps;
+			__u64 num;
+		};
 		__u64 drop;
 		__u64 err;
 	} rx_cnt;
@@ -1322,7 +1325,7 @@ int sample_install_xdp(struct bpf_program *xdp_prog, int ifindex, bool generic,
 
 static void sample_summary_print(void)
 {
-	double period = sample_out.rx_cnt.pps;
+	double num = sample_out.rx_cnt.num;
 
 	if (sample_out.totals.rx) {
 		double pkts = sample_out.totals.rx;
@@ -1330,7 +1333,7 @@ static void sample_summary_print(void)
 		print_always("  Packets received    : %'-10llu\n",
 			     sample_out.totals.rx);
 		print_always("  Average packets/s   : %'-10.0f\n",
-			     sample_round(pkts / period));
+			     sample_round(pkts / num));
 	}
 	if (sample_out.totals.redir) {
 		double pkts = sample_out.totals.redir;
@@ -1338,7 +1341,7 @@ static void sample_summary_print(void)
 		print_always("  Packets redirected  : %'-10llu\n",
 			     sample_out.totals.redir);
 		print_always("  Average redir/s     : %'-10.0f\n",
-			     sample_round(pkts / period));
+			     sample_round(pkts / num));
 	}
 	if (sample_out.totals.drop)
 		print_always("  Rx dropped          : %'-10llu\n",
@@ -1355,7 +1358,7 @@ static void sample_summary_print(void)
 		print_always("  Packets transmitted : %'-10llu\n",
 			     sample_out.totals.xmit);
 		print_always("  Average transmit/s  : %'-10.0f\n",
-			     sample_round(pkts / period));
+			     sample_round(pkts / num));
 	}
 }
 
@@ -1422,7 +1425,7 @@ static int sample_stats_collect(struct stats_record *rec)
 	return 0;
 }
 
-static void sample_summary_update(struct sample_output *out, int interval)
+static void sample_summary_update(struct sample_output *out)
 {
 	sample_out.totals.rx += out->totals.rx;
 	sample_out.totals.redir += out->totals.redir;
@@ -1430,12 +1433,11 @@ static void sample_summary_update(struct sample_output *out, int interval)
 	sample_out.totals.drop_xmit += out->totals.drop_xmit;
 	sample_out.totals.err += out->totals.err;
 	sample_out.totals.xmit += out->totals.xmit;
-	sample_out.rx_cnt.pps += interval;
+	sample_out.rx_cnt.num++;
 }
 
 static void sample_stats_print(int mask, struct stats_record *cur,
-			       struct stats_record *prev, char *prog_name,
-			       int interval)
+			       struct stats_record *prev, char *prog_name)
 {
 	struct sample_output out = {};
 
@@ -1452,7 +1454,7 @@ static void sample_stats_print(int mask, struct stats_record *cur,
 	else if (mask & SAMPLE_DEVMAP_XMIT_CNT_MULTI)
 		stats_get_devmap_xmit_multi(cur, prev, 0, &out,
 					    mask & SAMPLE_DEVMAP_XMIT_CNT);
-	sample_summary_update(&out, interval);
+	sample_summary_update(&out);
 
 	stats_print(prog_name, mask, cur, prev, &out);
 }
@@ -1495,7 +1497,7 @@ static void swap(struct stats_record **a, struct stats_record **b)
 }
 
 static int sample_timer_cb(int timerfd, struct stats_record **rec,
-			   struct stats_record **prev, int interval)
+			   struct stats_record **prev)
 {
 	char line[64] = "Summary";
 	int ret;
@@ -1524,7 +1526,7 @@ static int sample_timer_cb(int timerfd, struct stats_record **rec,
 		snprintf(line, sizeof(line), "%s->%s", f ?: "?", t ?: "?");
 	}
 
-	sample_stats_print(sample_mask, *rec, *prev, line, interval);
+	sample_stats_print(sample_mask, *rec, *prev, line);
 	return 0;
 }
 
@@ -1579,7 +1581,7 @@ int sample_run(int interval, void (*post_cb)(void *), void *ctx)
 		if (pfd[0].revents & POLLIN)
 			ret = sample_signal_cb();
 		else if (pfd[1].revents & POLLIN)
-			ret = sample_timer_cb(timerfd, &rec, &prev, interval);
+			ret = sample_timer_cb(timerfd, &rec, &prev);
 
 		if (ret)
 			break;
-- 
2.33.1

