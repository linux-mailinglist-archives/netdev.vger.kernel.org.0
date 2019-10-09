Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D296D0638
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 06:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbfJIEDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 00:03:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55344 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfJIEDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 00:03:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UXxRjFKnC3QApp6K8OrZAzbv2i1MTH0Ch/nW5W/E2gM=; b=DRANkHaXibB83CZpeCf0ci8NS
        z+eqY6Af0LuhPCl0MduH/sKnQiYz9Ih4DYzijM1T+Hp4jbA120HBCubKr1EQdOuLgYRqQnC9yghhy
        eL8k3H4CS+PqUY98GWO6dNR82n7tIGyu+FR2+AX3XDIg7EQu5Y8q5AQ8wfpKX2Yn0nOauUdxN3TjE
        WM3TPPm58C1G3b8oepDoMb9OFLcNHQrqd2DCeDDtUCq1vrYsCm23qcuWOx0zusF/hOXiVy4LEci+t
        5/XY2ucSt8+8hbe43HVpBodxICPve/B2LOfXtz1h0lN0d0vx6AvrAIpkob4PvN0QxZ2FSEyJvqzhw
        QNYsbwo6g==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iI3C1-0007D8-69; Wed, 09 Oct 2019 04:03:17 +0000
To:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Yamin Friedman <yaminf@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] DIM: fix dim.h kernel-doc and headers
Message-ID: <6f8dd95f-dc58-88b9-1d20-1a620b964d86@infradead.org>
Date:   Tue, 8 Oct 2019 21:03:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Lots of fixes to kernel-doc in structs, enums, and functions.
Also add header files that are being used but not yet #included.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Yamin Friedman <yaminf@mellanox.com>
Cc: Tal Gilboa <talgi@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: linux-rdma@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 include/linux/dim.h |   63 ++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

--- linux.orig/include/linux/dim.h
+++ linux/include/linux/dim.h
@@ -4,22 +4,26 @@
 #ifndef DIM_H
 #define DIM_H
 
+#include <linux/bits.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
 
-/**
+/*
  * Number of events between DIM iterations.
  * Causes a moderation of the algorithm run.
  */
 #define DIM_NEVENTS 64
 
-/**
+/*
  * Is a difference between values justifies taking an action.
  * We consider 10% difference as significant.
  */
 #define IS_SIGNIFICANT_DIFF(val, ref) \
 	(((100UL * abs((val) - (ref))) / (ref)) > 10)
 
-/**
+/*
  * Calculate the gap between two values.
  * Take wrap-around and variable size into consideration.
  */
@@ -27,12 +31,13 @@
 		& (BIT_ULL(bits) - 1))
 
 /**
- * Structure for CQ moderation values.
+ * struct dim_cq_moder - Structure for CQ moderation values.
  * Used for communications between DIM and its consumer.
  *
  * @usec: CQ timer suggestion (by DIM)
  * @pkts: CQ packet counter suggestion (by DIM)
- * @cq_period_mode: CQ priod count mode (from CQE/EQE)
+ * @comps: completion counter
+ * @cq_period_mode: CQ period count mode (from CQE/EQE)
  */
 struct dim_cq_moder {
 	u16 usec;
@@ -42,13 +47,14 @@ struct dim_cq_moder {
 };
 
 /**
- * Structure for DIM sample data.
+ * struct dim_sample - Structure for DIM sample data.
  * Used for communications between DIM and its consumer.
  *
  * @time: Sample timestamp
  * @pkt_ctr: Number of packets
  * @byte_ctr: Number of bytes
  * @event_ctr: Number of events
+ * @comp_ctr: Current completion counter
  */
 struct dim_sample {
 	ktime_t time;
@@ -59,12 +65,14 @@ struct dim_sample {
 };
 
 /**
- * Structure for DIM stats.
+ * struct dim_stats - Structure for DIM stats.
  * Used for holding current measured rates.
  *
  * @ppms: Packets per msec
  * @bpms: Bytes per msec
  * @epms: Events per msec
+ * @cpms: Completions per msec
+ * @cpe_ratio: ratio of completions to events
  */
 struct dim_stats {
 	int ppms; /* packets per msec */
@@ -75,12 +83,13 @@ struct dim_stats {
 };
 
 /**
- * Main structure for dynamic interrupt moderation (DIM).
+ * struct dim - Main structure for dynamic interrupt moderation (DIM).
  * Used for holding all information about a specific DIM instance.
  *
  * @state: Algorithm state (see below)
  * @prev_stats: Measured rates from previous iteration (for comparison)
  * @start_sample: Sampled data at start of current iteration
+ * @measuring_sample: a &dim_sample that is used to update the current events
  * @work: Work to perform on action required
  * @priv: A pointer to the struct that points to dim
  * @profile_ix: Current moderation profile
@@ -106,24 +115,21 @@ struct dim {
 };
 
 /**
- * enum dim_cq_period_mode
- *
- * These are the modes for CQ period count.
+ * enum dim_cq_period_mode - modes for CQ period count
  *
  * @DIM_CQ_PERIOD_MODE_START_FROM_EQE: Start counting from EQE
  * @DIM_CQ_PERIOD_MODE_START_FROM_CQE: Start counting from CQE (implies timer reset)
  * @DIM_CQ_PERIOD_NUM_MODES: Number of modes
  */
-enum {
+enum dim_cq_period_mode {
 	DIM_CQ_PERIOD_MODE_START_FROM_EQE = 0x0,
 	DIM_CQ_PERIOD_MODE_START_FROM_CQE = 0x1,
 	DIM_CQ_PERIOD_NUM_MODES
 };
 
 /**
- * enum dim_state
+ * enum dim_state - DIM algorithm states
  *
- * These are the DIM algorithm states.
  * These will determine if the algorithm is in a valid state to start an iteration.
  *
  * @DIM_START_MEASURE: This is the first iteration (also after applying a new profile)
@@ -131,16 +137,15 @@ enum {
  * need to perform an action
  * @DIM_APPLY_NEW_PROFILE: DIM consumer is currently applying a profile - no need to measure
  */
-enum {
+enum dim_state {
 	DIM_START_MEASURE,
 	DIM_MEASURE_IN_PROGRESS,
 	DIM_APPLY_NEW_PROFILE,
 };
 
 /**
- * enum dim_tune_state
+ * enum dim_tune_state - DIM algorithm tune states
  *
- * These are the DIM algorithm tune states.
  * These will determine which action the algorithm should perform.
  *
  * @DIM_PARKING_ON_TOP: Algorithm found a local top point - exit on significant difference
@@ -148,7 +153,7 @@ enum {
  * @DIM_GOING_RIGHT: Algorithm is currently trying higher moderation levels
  * @DIM_GOING_LEFT: Algorithm is currently trying lower moderation levels
  */
-enum {
+enum dim_tune_state {
 	DIM_PARKING_ON_TOP,
 	DIM_PARKING_TIRED,
 	DIM_GOING_RIGHT,
@@ -156,25 +161,23 @@ enum {
 };
 
 /**
- * enum dim_stats_state
+ * enum dim_stats_state - DIM algorithm statistics states
  *
- * These are the DIM algorithm statistics states.
  * These will determine the verdict of current iteration.
  *
  * @DIM_STATS_WORSE: Current iteration shows worse performance than before
- * @DIM_STATS_WORSE: Current iteration shows same performance than before
- * @DIM_STATS_WORSE: Current iteration shows better performance than before
+ * @DIM_STATS_SAME:  Current iteration shows same performance than before
+ * @DIM_STATS_BETTER: Current iteration shows better performance than before
  */
-enum {
+enum dim_stats_state {
 	DIM_STATS_WORSE,
 	DIM_STATS_SAME,
 	DIM_STATS_BETTER,
 };
 
 /**
- * enum dim_step_result
+ * enum dim_step_result - DIM algorithm step results
  *
- * These are the DIM algorithm step results.
  * These describe the result of a step.
  *
  * @DIM_STEPPED: Performed a regular step
@@ -182,7 +185,7 @@ enum {
  * tired parking
  * @DIM_ON_EDGE: Stepped to the most left/right profile
  */
-enum {
+enum dim_step_result {
 	DIM_STEPPED,
 	DIM_TOO_TIRED,
 	DIM_ON_EDGE,
@@ -199,7 +202,7 @@ enum {
 bool dim_on_top(struct dim *dim);
 
 /**
- *	dim_turn - change profile alterning direction
+ *	dim_turn - change profile altering direction
  *	@dim: DIM context
  *
  * Go left if we were going right and vice-versa.
@@ -238,7 +241,7 @@ void dim_calc_stats(struct dim_sample *s
 		    struct dim_stats *curr_stats);
 
 /**
- *	dim_update_sample - set a sample's fields with give values
+ *	dim_update_sample - set a sample's fields with given values
  *	@event_ctr: number of events to set
  *	@packets: number of packets to set
  *	@bytes: number of bytes to set
@@ -304,8 +307,8 @@ struct dim_cq_moder net_dim_get_def_tx_m
  *	@end_sample: Current data measurement
  *
  * Called by the consumer.
- * This is the main logic of the algorithm, where data is processed in order to decide on next
- * required action.
+ * This is the main logic of the algorithm, where data is processed in order
+ * to decide on next required action.
  */
 void net_dim(struct dim *dim, struct dim_sample end_sample);
 

