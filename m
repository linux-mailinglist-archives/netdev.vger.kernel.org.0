Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA208919DC
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 00:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfHRWHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 18:07:22 -0400
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:54262 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726119AbfHRWHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 18:07:22 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 6F85E100E86C1;
        Sun, 18 Aug 2019 22:07:20 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:2:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3874:4051:4120:4250:4321:5007:6119:7903:10004:10848:11026:11232:11473:11658:11914:12043:12291:12296:12297:12438:12555:12683:12740:12760:12895:13439:14659:21080:21433:21627:30012:30051:30054:30075:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: field40_5b726254885f
X-Filterd-Recvd-Size: 9315
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Sun, 18 Aug 2019 22:07:19 +0000 (UTC)
Message-ID: <83075553a61ede1de9cbf77b90a5acdeab5aacbf.camel@perches.com>
Subject: Re: [PATCH 1/2] PTP: introduce new versions of IOCTLs
From:   Joe Perches <joe@perches.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 18 Aug 2019 15:07:18 -0700
In-Reply-To: <20190818201150.GA1316@localhost>
References: <20190814074712.10684-1-felipe.balbi@linux.intel.com>
         <20190817155927.GA1540@localhost>
         <a146c1356b4272c481e5cc63666c6e58b8442407.camel@perches.com>
         <20190818201150.GA1316@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2019-08-18 at 13:11 -0700, Richard Cochran wrote:
> On Sat, Aug 17, 2019 at 09:17:20AM -0700, Joe Perches wrote:
> > Is there a case where this initialization is
> > unnecessary such that it impacts performance
> > given the use in ptp_ioctl?
> 
> None of these ioctls are sensitive WRT performance.  They are all
> setup or configuration, or in the case of the OFFSET ioctls, the tiny
> extra delay before the actual measurement will not affect the result.
> 
> Thanks,
> Richard

Still, my preference would be to move the struct declarations
into the switch/case blocks where they are used instead of
having a large declaration block at the top of the function.

This minimizes stack use and makes the declarations use {}

Also the original patch deletes 2 case entries for
PTP_PIN_GETFUNC and PTP_PIN_SETFUNC and converts them to
PTP_PIN_GETFUNC2 and PTP_PIN_SETFUNC2 but still uses tests
for the deleted case label entries making part of the case
code block unreachable.

That's at least a defect:

-	case PTP_PIN_GETFUNC:
+	case PTP_PIN_GETFUNC2:

and
 
-	case PTP_PIN_SETFUNC:
+	case PTP_PIN_SETFUNC2:

Anyway, leaving aside that nominal defect, which
should probably leave the original case labels in place,
I suggest:

---
 drivers/ptp/ptp_chardev.c | 106 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 91 insertions(+), 15 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 18ffe449efdf..a77f12e6326b 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -110,23 +110,17 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 {
 	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
 	struct ptp_sys_offset_extended *extoff = NULL;
-	struct ptp_sys_offset_precise precise_offset;
-	struct system_device_crosststamp xtstamp;
-	struct ptp_clock_info *ops = ptp->info;
 	struct ptp_sys_offset *sysoff = NULL;
-	struct ptp_system_timestamp sts;
-	struct ptp_clock_request req;
-	struct ptp_clock_caps caps;
-	struct ptp_clock_time *pct;
+	struct ptp_clock_info *ops = ptp->info;
 	unsigned int i, pin_index;
-	struct ptp_pin_desc pd;
-	struct timespec64 ts;
 	int enable, err = 0;
 
 	switch (cmd) {
 
 	case PTP_CLOCK_GETCAPS:
-		memset(&caps, 0, sizeof(caps));
+	case PTP_CLOCK_GETCAPS2: {
+		struct ptp_clock_caps caps = {};
+
 		caps.max_adj = ptp->info->max_adj;
 		caps.n_alarm = ptp->info->n_alarm;
 		caps.n_ext_ts = ptp->info->n_ext_ts;
@@ -137,13 +131,28 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		if (copy_to_user((void __user *)arg, &caps, sizeof(caps)))
 			err = -EFAULT;
 		break;
+	}
 
 	case PTP_EXTTS_REQUEST:
+	case PTP_EXTTS_REQUEST2: {
+		struct ptp_clock_request req = {};
+
 		if (copy_from_user(&req.extts, (void __user *)arg,
 				   sizeof(req.extts))) {
 			err = -EFAULT;
 			break;
 		}
+		if (cmd == PTP_EXTTS_REQUEST2 &&
+		    (req.extts.flags || req.extts.rsv[0] || req.extts.rsv[1])) {
+			err = -EINVAL;
+			break;
+		}
+		if (cmd == PTP_EXTTS_REQUEST) {
+			req.extts.flags = 0;
+			req.extts.rsv[0] = 0;
+			req.extts.rsv[1] = 0;
+		}
+
 		if (req.extts.index >= ops->n_ext_ts) {
 			err = -EINVAL;
 			break;
@@ -152,13 +161,30 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		enable = req.extts.flags & PTP_ENABLE_FEATURE ? 1 : 0;
 		err = ops->enable(ops, &req, enable);
 		break;
+	}
 
 	case PTP_PEROUT_REQUEST:
+	case PTP_PEROUT_REQUEST2: {
+		struct ptp_clock_request req = {};
+
 		if (copy_from_user(&req.perout, (void __user *)arg,
 				   sizeof(req.perout))) {
 			err = -EFAULT;
 			break;
 		}
+		if (cmd == PTP_PEROUT_REQUEST2 &&
+		    (req.perout.flags ||
+		     req.perout.rsv[0] || req.perout.rsv[1] ||
+		     req.perout.rsv[2] || req.perout.rsv[3])) {
+			err = -EINVAL;
+			break;
+		} else if (cmd == PTP_PEROUT_REQUEST) {
+			req.perout.flags = 0;
+			req.perout.rsv[0] = 0;
+			req.perout.rsv[1] = 0;
+			req.perout.rsv[2] = 0;
+			req.perout.rsv[3] = 0;
+		}
 		if (req.perout.index >= ops->n_per_out) {
 			err = -EINVAL;
 			break;
@@ -167,16 +193,26 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		enable = req.perout.period.sec || req.perout.period.nsec;
 		err = ops->enable(ops, &req, enable);
 		break;
+	}
 
 	case PTP_ENABLE_PPS:
+	case PTP_ENABLE_PPS2: {
+		struct ptp_clock_request req = {};
+
 		if (!capable(CAP_SYS_TIME))
 			return -EPERM;
 		req.type = PTP_CLK_REQ_PPS;
 		enable = arg ? 1 : 0;
 		err = ops->enable(ops, &req, enable);
 		break;
+	}
 
 	case PTP_SYS_OFFSET_PRECISE:
+	case PTP_SYS_OFFSET_PRECISE2: {
+		struct ptp_sys_offset_precise precise_offset = {};
+		struct system_device_crosststamp xtstamp;
+		struct timespec64 ts;
+
 		if (!ptp->info->getcrosststamp) {
 			err = -EOPNOTSUPP;
 			break;
@@ -185,7 +221,6 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		if (err)
 			break;
 
-		memset(&precise_offset, 0, sizeof(precise_offset));
 		ts = ktime_to_timespec64(xtstamp.device);
 		precise_offset.device.sec = ts.tv_sec;
 		precise_offset.device.nsec = ts.tv_nsec;
@@ -199,8 +234,13 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 				 sizeof(precise_offset)))
 			err = -EFAULT;
 		break;
+	}
 
 	case PTP_SYS_OFFSET_EXTENDED:
+	case PTP_SYS_OFFSET_EXTENDED2: {
+		struct ptp_system_timestamp sts;
+		struct timespec64 ts;
+
 		if (!ptp->info->gettimex64) {
 			err = -EOPNOTSUPP;
 			break;
@@ -211,8 +251,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 			extoff = NULL;
 			break;
 		}
-		if (extoff->n_samples > PTP_MAX_SAMPLES
-		    || extoff->rsv[0] || extoff->rsv[1] || extoff->rsv[2]) {
+		if (extoff->n_samples > PTP_MAX_SAMPLES ||
+		    extoff->rsv[0] || extoff->rsv[1] || extoff->rsv[2]) {
 			err = -EINVAL;
 			break;
 		}
@@ -230,8 +270,13 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		if (copy_to_user((void __user *)arg, extoff, sizeof(*extoff)))
 			err = -EFAULT;
 		break;
+	}
 
 	case PTP_SYS_OFFSET:
+	case PTP_SYS_OFFSET2: {
+		struct timespec64 ts;
+		struct ptp_clock_time *pct;
+
 		sysoff = memdup_user((void __user *)arg, sizeof(*sysoff));
 		if (IS_ERR(sysoff)) {
 			err = PTR_ERR(sysoff);
@@ -264,12 +309,27 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		if (copy_to_user((void __user *)arg, sysoff, sizeof(*sysoff)))
 			err = -EFAULT;
 		break;
+	}
+
+	case PTP_PIN_GETFUNC2: {
+		struct ptp_pin_desc pd;
 
-	case PTP_PIN_GETFUNC:
 		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
 			err = -EFAULT;
 			break;
 		}
+		if (cmd == PTP_PIN_GETFUNC2 &&
+		    (pd.rsv[0] || pd.rsv[1] || pd.rsv[2] || pd.rsv[3] ||
+		     pd.rsv[4])) {
+			err = -EINVAL;
+			break;
+		} else if (cmd == PTP_PIN_GETFUNC) {
+			pd.rsv[0] = 0;
+			pd.rsv[1] = 0;
+			pd.rsv[2] = 0;
+			pd.rsv[3] = 0;
+			pd.rsv[4] = 0;
+		}
 		pin_index = pd.index;
 		if (pin_index >= ops->n_pins) {
 			err = -EINVAL;
@@ -283,12 +343,27 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		if (!err && copy_to_user((void __user *)arg, &pd, sizeof(pd)))
 			err = -EFAULT;
 		break;
+	}
+
+	case PTP_PIN_SETFUNC2: {
+		struct ptp_pin_desc pd;
 
-	case PTP_PIN_SETFUNC:
 		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
 			err = -EFAULT;
 			break;
 		}
+		if (cmd == PTP_PIN_SETFUNC2 &&
+		    (pd.rsv[0] || pd.rsv[1] || pd.rsv[2] || pd.rsv[3] ||
+		     pd.rsv[4])) {
+			err = -EINVAL;
+			break;
+		} else if (cmd == PTP_PIN_SETFUNC) {
+			pd.rsv[0] = 0;
+			pd.rsv[1] = 0;
+			pd.rsv[2] = 0;
+			pd.rsv[3] = 0;
+			pd.rsv[4] = 0;
+		}
 		pin_index = pd.index;
 		if (pin_index >= ops->n_pins) {
 			err = -EINVAL;
@@ -300,6 +375,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		err = ptp_set_pinfunc(ptp, pin_index, pd.func, pd.chan);
 		mutex_unlock(&ptp->pincfg_mux);
 		break;
+	}
 
 	default:
 		err = -ENOTTY;


