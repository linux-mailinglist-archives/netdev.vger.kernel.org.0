Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEB048CE21
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 22:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbiALV6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 16:58:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:16029 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233907AbiALV6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 16:58:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642024699; x=1673560699;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RidheGyui6xxspY+TESWCpGNUrp3LEyv3KhaqN6VVfs=;
  b=RvoAedcUthbtLQuDNlC6TaolAFEw62gBMEir2EROqUsocFFqGPVIxZIO
   uLqPYHMEOi3Woi9LcCO5Lz6DtTZzbxyDuO12ClEpSDWIpa8/236+HN85+
   YkjPUnlf7iYPVbHobmpq1uuKZ6Jl8KUq/3U+e4UVctjEszx4d83u1lSRi
   fjTB2YuOwa8NzNSlrVoEcdraXV3HWtbM5x2OQceKG3FslTr+QDe35rVwK
   N2nv7mTbC0F24ClrfLDpdX1fyGKPhGlTYeZ98d68Q3s3DPjwqVZzYnQYs
   GD2lmXiQ/rPgqNLEEvj8rbSo6NcSes0cVAazso4RekqeDyxBEMEiZxHe1
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="231204573"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="231204573"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 13:58:18 -0800
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="515674487"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.104.69]) ([10.209.104.69])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 13:58:18 -0800
Message-ID: <5b15709f-cbc6-d922-1151-4543dc5ffc1d@linux.intel.com>
Date:   Wed, 12 Jan 2022 13:58:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next v3 02/12] net: wwan: t7xx: Add core components
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, mika.westerberg@linux.intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
 <20211207024711.2765-3-ricardo.martinez@linux.intel.com>
 <db45c31-5041-5853-e88a-b1f76a1fb9a0@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <db45c31-5041-5853-e88a-b1f76a1fb9a0@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/16/2021 3:55 AM, Ilpo Järvinen wrote:
...
>
>> +	switch (reason) {
>> +	case EXCEPTION_HS_TIMEOUT:
>> +		dev_err(dev, "BOOT_HS_FAIL\n");
>> +		break;
>> +
>> +	case EXCEPTION_EVENT:
>> +		t7xx_fsm_broadcast_state(ctl, MD_STATE_EXCEPTION);
>> +		t7xx_md_exception_handshake(ctl->md);
>> +
>> +		cnt = 0;
>> +		while (cnt < FSM_MD_EX_REC_OK_TIMEOUT_MS / FSM_EVENT_POLL_INTERVAL_MS) {
>> +			if (kthread_should_stop())
>> +				return;
>> +
>> +			spin_lock_irqsave(&ctl->event_lock, flags);
>> +			event = list_first_entry_or_null(&ctl->event_queue,
>> +							 struct t7xx_fsm_event, entry);
>> +			if (event) {
>> +				if (event->event_id == FSM_EVENT_MD_EX) {
>> +					fsm_del_kf_event(event);
>> +				} else if (event->event_id == FSM_EVENT_MD_EX_REC_OK) {
>> +					rec_ok = true;
>> +					fsm_del_kf_event(event);
>> +				}
>> +			}
>> +
>> +			spin_unlock_irqrestore(&ctl->event_lock, flags);
>> +			if (rec_ok)
>> +				break;
>> +
>> +			cnt++;
>> +			/* Try again after 20ms */
>> +			msleep(FSM_EVENT_POLL_INTERVAL_MS);
>> +		}
>> +
>> +		cnt = 0;
>> +		while (cnt < FSM_MD_EX_PASS_TIMEOUT_MS / FSM_EVENT_POLL_INTERVAL_MS) {
>> +			if (kthread_should_stop())
>> +				return;
>> +
>> +			spin_lock_irqsave(&ctl->event_lock, flags);
>> +			event = list_first_entry_or_null(&ctl->event_queue,
>> +							 struct t7xx_fsm_event, entry);
>> +			if (event && event->event_id == FSM_EVENT_MD_EX_PASS) {
>> +				pass = true;
>> +				fsm_del_kf_event(event);
>> +			}
>> +
>> +			spin_unlock_irqrestore(&ctl->event_lock, flags);
>> +
>> +			if (pass)
>> +				break;
>> +			cnt++;
>> +			/* Try again after 20ms */
>> +			msleep(FSM_EVENT_POLL_INTERVAL_MS);
>> +		}
> It hurts me a bit to see so much code duplication with only that one
> extra if branch + if condition right-hand sides being different. It would
> seem like something that could be solved with a helper taking those two
> things as parameters.
>
> I hope the ordering of FSM_EVENT_MD_EX, FSM_EVENT_MD_EX_REC_OK, and
> FSM_EVENT_MD_EX_PASS is guaranteed by something. Otherwise, the event
> being waited for might not become the first entry in the event_queue and
> the loop just keeps waiting until timeout?
>
Ordering is guaranteed by the modem. Removing code duplication in the 
next iteration.

>> +void t7xx_fsm_clr_event(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_event_state event_id)
>> +{
>> +       struct device *dev = &ctl->md->t7xx_dev->pdev->dev;
>> +       struct t7xx_fsm_event *event, *evt_next;
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&ctl->event_lock, flags);
>> +       list_for_each_entry_safe(event, evt_next, &ctl->event_queue, entry) {
>> +               dev_err(dev, "Unhandled event %d\n", event->event_id);
>> +
>> +               if (event->event_id == event_id)
>> +                       fsm_del_kf_event(event);
>> +       }
> It seems that only events matching to event_id are removed from the
> event_queue. Can that dev_err print the same event over and over again
> (I'm assuming here multiple calls to t7xx_fsm_clr_event can occur) because
> the other events still remaining in event_queue?
>
The purpose of this function is just to remove an event if present, it 
is not relevant if there

were other events in the list, so I'll remove the dev_err.


