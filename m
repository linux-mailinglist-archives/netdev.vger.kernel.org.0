Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3707477126
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhLPL4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:56:02 -0500
Received: from mga01.intel.com ([192.55.52.88]:9992 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234035AbhLPL4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 06:56:00 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="263631256"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="263631256"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 03:55:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="519217842"
Received: from jetten-mobl.ger.corp.intel.com ([10.252.36.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 03:55:53 -0800
Date:   Thu, 16 Dec 2021 13:55:50 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, mika.westerberg@linux.intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, suresh.nagaraj@intel.com
Subject: Re: [PATCH net-next v3 02/12] net: wwan: t7xx: Add core components
In-Reply-To: <20211207024711.2765-3-ricardo.martinez@linux.intel.com>
Message-ID: <db45c31-5041-5853-e88a-b1f76a1fb9a0@linux.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com> <20211207024711.2765-3-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Registers the t7xx device driver with the kernel. Setup all the core
> components: PCIe layer, Modem Host Cross Core Interface (MHCCIF),
> modem control operations, modem state machine, and build
> infrastructure.
> 
> * PCIe layer code implements driver probe and removal.
> * MHCCIF provides interrupt channels to communicate events
>   such as handshake, PM and port enumeration.
> * Modem control implements the entry point for modem init,
>   reset and exit.
> * The modem status monitor is a state machine used by modem control
>   to complete initialization and stop. It is used also to propagate
>   exception events reported by other components.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>


> +	switch (reason) {
> +	case EXCEPTION_HS_TIMEOUT:
> +		dev_err(dev, "BOOT_HS_FAIL\n");
> +		break;
> +
> +	case EXCEPTION_EVENT:
> +		t7xx_fsm_broadcast_state(ctl, MD_STATE_EXCEPTION);
> +		t7xx_md_exception_handshake(ctl->md);
> +
> +		cnt = 0;
> +		while (cnt < FSM_MD_EX_REC_OK_TIMEOUT_MS / FSM_EVENT_POLL_INTERVAL_MS) {
> +			if (kthread_should_stop())
> +				return;
> +
> +			spin_lock_irqsave(&ctl->event_lock, flags);
> +			event = list_first_entry_or_null(&ctl->event_queue,
> +							 struct t7xx_fsm_event, entry);
> +			if (event) {
> +				if (event->event_id == FSM_EVENT_MD_EX) {
> +					fsm_del_kf_event(event);
> +				} else if (event->event_id == FSM_EVENT_MD_EX_REC_OK) {
> +					rec_ok = true;
> +					fsm_del_kf_event(event);
> +				}
> +			}
> +
> +			spin_unlock_irqrestore(&ctl->event_lock, flags);
> +			if (rec_ok)
> +				break;
> +
> +			cnt++;
> +			/* Try again after 20ms */
> +			msleep(FSM_EVENT_POLL_INTERVAL_MS);
> +		}
> +
> +		cnt = 0;
> +		while (cnt < FSM_MD_EX_PASS_TIMEOUT_MS / FSM_EVENT_POLL_INTERVAL_MS) {
> +			if (kthread_should_stop())
> +				return;
> +
> +			spin_lock_irqsave(&ctl->event_lock, flags);
> +			event = list_first_entry_or_null(&ctl->event_queue,
> +							 struct t7xx_fsm_event, entry);
> +			if (event && event->event_id == FSM_EVENT_MD_EX_PASS) {
> +				pass = true;
> +				fsm_del_kf_event(event);
> +			}
> +
> +			spin_unlock_irqrestore(&ctl->event_lock, flags);
> +
> +			if (pass)
> +				break;
> +			cnt++;
> +			/* Try again after 20ms */
> +			msleep(FSM_EVENT_POLL_INTERVAL_MS);
> +		}

It hurts me a bit to see so much code duplication with only that one 
extra if branch + if condition right-hand sides being different. It would 
seem like something that could be solved with a helper taking those two 
things as parameters.

I hope the ordering of FSM_EVENT_MD_EX, FSM_EVENT_MD_EX_REC_OK, and
FSM_EVENT_MD_EX_PASS is guaranteed by something. Otherwise, the event 
being waited for might not become the first entry in the event_queue and 
the loop just keeps waiting until timeout?


> +void t7xx_fsm_clr_event(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_event_state event_id)
> +{
> +       struct device *dev = &ctl->md->t7xx_dev->pdev->dev;
> +       struct t7xx_fsm_event *event, *evt_next;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&ctl->event_lock, flags);
> +       list_for_each_entry_safe(event, evt_next, &ctl->event_queue, entry) {
> +               dev_err(dev, "Unhandled event %d\n", event->event_id);
> +
> +               if (event->event_id == event_id)
> +                       fsm_del_kf_event(event);
> +       }

It seems that only events matching to event_id are removed from the 
event_queue. Can that dev_err print the same event over and over again 
(I'm assuming here multiple calls to t7xx_fsm_clr_event can occur) because 
the other events still remaining in event_queue?


> +struct t7xx_fsm_ctl {
> +	struct t7xx_modem	*md;
> +	enum md_state		md_state;
> +	unsigned int		curr_state;
> +	unsigned int		last_state;

The value of last_state is never used.


-- 
 i.

