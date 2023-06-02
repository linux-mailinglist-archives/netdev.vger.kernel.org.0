Return-Path: <netdev+bounces-7324-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB27671FACB
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 758A11C20C17
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0362163CC;
	Fri,  2 Jun 2023 07:14:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E131A5225
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 07:14:29 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCB41A1;
	Fri,  2 Jun 2023 00:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685690066; x=1717226066;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=kaELZGISUWFLS4XtC9bVQrIdgfipPly+NlrHL6v0O1k=;
  b=LnDyZXl6ZPuowFSR9LQ77WXFtCgPDyIAr1NusaAeNDk5UtpQI/hMBFIy
   GFOMiUIK2jhnAmvjOPAcSufZs9QO5QxwWo09mhKmZ0ItOLM9kd8wfjwPQ
   x/LeBEOrWBxTevU+nD2NCP2eJfsQx5Bx+b9J0a34XiGmYgWhOeyXUGdOB
   vJcZxrywB5indBpAAgEfeP3BPWm1fhhJKJ12mERd6+uf/2RJ7D+9q10uR
   E4czlJaEDjlTRj65NFprWCXNkNkT66tDRNLLTKrgu5PJrEUMZsQOEjkEf
   IDhrHtS4wDPta5XwDtG8wVhAno9xWQrkd+BoXReDzPepAvIVQb8Vyms4r
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="336161866"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="336161866"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 00:14:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="737420579"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="737420579"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga008.jf.intel.com with ESMTP; 02 Jun 2023 00:14:24 -0700
Received: from linux.intel.com (ssid-ilbpg3-teeminta.png.intel.com [10.88.227.74])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id AB9DC580D54;
	Fri,  2 Jun 2023 00:14:21 -0700 (PDT)
Date: Fri, 2 Jun 2023 15:14:06 +0800
From: Tan Tee Min <tee.min.tan@linux.intel.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	netdev@vger.kernel.org, vinicius.gomes@intel.com, kuba@kernel.org,
	pabeni@redhat.com, linux-kernel@vger.kernel.org,
	edumazet@google.com
Subject: Re: [PATCH net v1] net/sched: taprio: fix cycle time extension logic
Message-ID: <20230602071406.GA31501@linux.intel.com>
References: <20230530082541.495-1-muhammad.husaini.zulkifli@intel.com>
 <20230530194708.zz6wnzaenau54hcv@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230530194708.zz6wnzaenau54hcv@skbuf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 10:47:08PM +0300, Vladimir Oltean wrote:
> On Tue, May 30, 2023 at 04:25:41PM +0800, Muhammad Husaini Zulkifli wrote:
> > From: Tan Tee Min <tee.min.tan@linux.intel.com>
> > 
> I think that the commit message insufficiently describes the problems
> with the existing code. Also, the incorrect Fixes: tag suggests it may
> even have been incompletely characterized.
> 
> Here are some additional thoughts of mine (also insufficient, since they
> are based on static code analysis, done now) which may nuance things a
> bit more, to change the Fixes tag and the shape of the proposed solution.

Thanks a lot for the reviews!

> 
> Now, taprio_dequeue_from_txq() uses the following "entry" fields:
> gate_close_time[tc] and budget[tc]. They are both recalculated
> incorrectly by advance_sched(), which your change addresses. That is one
> issue which should be described properly, and a patch limited to that.

Do you mean a separate patch to fix the recalculation issue for
gate_close_time[tc] and budget[tc] in advance_sched()?

> 
> so this is why your choice is to also update the cycle_time. An unfortunate
> consequence of that choice is that this might also become transiently visible
> to taprio_dump(), which I'm not totally convinced is desirable - because
> effectively, the cycle time shouldn't have changed. Although, true, the
> old oper schedule is going away soon, we don't really know how soon. The
> cycle times can be arbitrarily large. It would be great if we could save
> the correction into a dedicated "s64 correction" variable (ranging from
> -cycle_time+1 to +cycle_time_extension), and leave the cycle_time alone.

That makes sense. I will save the correction into a dedicated "correction"
variable, and make it use with the cycle time at other places, and not update
the oper cycle_time.

So that the taprio_dump() still shows the original oper cycle_time during the
schedule change pending period.

> 
> But taprio_enqueue() is also a problem, and that isn't addressed. It can be,
> that during a corrected cycle, frames which were oversized due to the
> queueMaxSDU restriction are transiently not oversized anymore, and
> should be allowed to pass - or the other way around (and this is worse):
> a frame which would have passed through a full-size window will not pass
> through a truncated last cycle (negative correction), and taprio_enqueue()
> will not detect this and will not drop the skb.
> 
> taprio_update_queue_max_sdu() would need to be called, and that depends
> on an up-to-date sched->max_open_gate_duration[tc] which isn't currently
> recalculated.
> 
> So, one way or another, taprio_calculate_gate_durations() also needs to
> be called again after a change to the schedule's correction.

Yape, the queueMaxSDU and max_open_gate_durations() both should need to be
updated too. I will correct it in v2 patch by adding in the
taprio_update_queue_max_sdu() and taprio_calculate_gate_durations()
after the schedule change.

> 
> >  net/sched/sch_taprio.c | 32 +++++++++++++++++++++-----------
> >  1 file changed, 21 insertions(+), 11 deletions(-)
> > 
> > diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> > index 76db9a10ef504..ef487fef83fce 100644
> > --- a/net/sched/sch_taprio.c
> > +++ b/net/sched/sch_taprio.c
> > @@ -99,6 +99,7 @@ struct taprio_sched {
> >  	u32 max_sdu[TC_MAX_QUEUE]; /* save info from the user */
> >  	u32 fp[TC_QOPT_MAX_QUEUE]; /* only for dump and offloading */
> >  	u32 txtime_delay;
> > +	bool sched_changed;
> 
> nitpick: sched_change_pending?

Noted. Will change it to sched_change_pending.

>
> The choice of operations seems unintuitive, when you could have simply
> done:
> 
> 	ktime_t correction = ktime_sub(sched_base_time(admin), end_time);
> 
> 	next->interval += correction;
> 	oper->cycle_time += correction;
> 
> 	(or possibly save the correction instead, see the feedback above)

Thanks. Feedback taken.

> I see an issue here: you need to set q->sched_changed = true whenever
> should_change_schedules() returned true and not just for the last entry,
> correct? Because there could be a schedule change which needs to happens
> during entry 2 out of 4 of the current one (truncation case - negative
> correction). In that case, I believe that should_change_schedules()
> keeps shouting at you "change! change! change!" but you only call
> switch_schedules() when you've reached entry 4 with the "next" pointer,
> which is not what the standard suggests should be done.
> 
> IIUC, the standard says that when an admin and an oper sched meet, the
> decision of what to do near the AdminBaseTime - whether to elongate the
> next-to-last cycle of the oper sched or to let the last cycle run but to
> cut it short - depends on the OperCycleTimeExtension. In a nutshell,
> that variable says what is the maximum positive correction applicable to
> the last sched entry and to the cycle time. If a positive correction
> larger than that would be necessary (relative to the next-to-last cycle),
> the decision is to just let the last cycle run for how long it can.

Based on my understanding, here are the two cases when the Oper and Admin
cycle boundaries don’t line up perfectly:-
1/ The final Oper cycle before first Admin cycle is smaller than
   OperCycleTimeExtension:
   - Then extend the final oper cycle rather than restart a very short final
     oper cycle.
2/ The final Oper cycle before first Admin cycle is greater than
   OperCycleTimeExtension:
   - Then it won't extend the final Oper cycle and restart the final Oper
     cycle instead, then it will be truncated at Admin base time.

I think you are saying the scenario 2/ above, right?
Let me rework the solution and come back with the proper fixes.

> I guess at some point we should also fix up this comment?
> 
> 	/* FIXME: the IEEE 802.1Q-2018 Specification isn't clear about
> 	 * how precisely the extension should be made. So after
> 	 * conformance testing, this logic may change.
> 	 */
> 	if (ktime_compare(next_base_time, extension_time) <= 0)
> 		return true;

Agree. Let me fix up this comment in next patch.

Thanks,
Tee Min


