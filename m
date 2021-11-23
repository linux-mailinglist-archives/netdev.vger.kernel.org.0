Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9F8459BCD
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 06:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhKWFlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 00:41:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:29561 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229569AbhKWFls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 00:41:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="258801543"
X-IronPort-AV: E=Sophos;i="5.87,256,1631602800"; 
   d="scan'208";a="258801543"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 21:38:40 -0800
X-IronPort-AV: E=Sophos;i="5.87,256,1631602800"; 
   d="scan'208";a="606690391"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.139.118]) ([10.212.139.118])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 21:38:39 -0800
Message-ID: <6007aad3-d831-297b-54f5-d0ed0c9c115e@linux.intel.com>
Date:   Mon, 22 Nov 2021 21:38:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 03/14] net: wwan: t7xx: Add core components
Content-Language: en-US
References: <629b982a-874d-b75f-2800-81b84d569af7@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <629b982a-874d-b75f-2800-81b84d569af7@linux.intel.com>
X-Forwarded-Message-Id: <629b982a-874d-b75f-2800-81b84d569af7@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Sorry for the spam. Re-sending as plain text.


On 11/2/2021 8:46 AM, Andy Shevchenko wrote:
> On Sun, Oct 31, 2021 at 08:56:24PM -0700, Ricardo Martinez wrote:
>> From: Haijun Lio<haijun.liu@mediatek.com>
>>
>> Registers the t7xx device driver with the kernel. Setup all the core
>> components: PCIe layer, Modem Host Cross Core Interface (MHCCIF),
>> modem control operations, modem state machine, and build
>> infrastructure.
>>
>> * PCIe layer code implements driver probe and removal.
>> * MHCCIF provides interrupt channels to communicate events
>> such as handshake, PM and port enumeration.
>> * Modem control implements the entry point for modem init,
>> reset and exit.
>> * The modem status monitor is a state machine used by modem control
>> to complete initialization and stop. It is used also to propagate
>> exception events reported by other components.
>> +#define CCCI_HEADER_NO_DATA 0xffffffff
> Is this internal value to Linux or something which is given by hardware?

It is hardware defined

...

>> + spin_lock_irqsave(&md_info->exp_spinlock, flags);
> Can it be called outside of IRQ context?

Actually, it is not in IRQ context, this function is called by the 
thread_fn passed to request_threaded_irq(),

Maybe spin_lock_bh makes more sense.

>> + int_sta = get_interrupt_status(mtk_dev);
>> + md_info->exp_id |= int_sta;
>> +
>> + if (md_info->exp_id & D2H_INT_PORT_ENUM) {
>> + md_info->exp_id &= ~D2H_INT_PORT_ENUM;
>> + if (ctl->curr_state == CCCI_FSM_INIT ||
>> + ctl->curr_state == CCCI_FSM_PRE_START ||
>> + ctl->curr_state == CCCI_FSM_STOPPED)
>> + ccci_fsm_recv_md_interrupt(MD_IRQ_PORT_ENUM);
>> + }
>> +
>> + if (md_info->exp_id & D2H_INT_EXCEPTION_INIT) {
>> + if (ctl->md_state == MD_STATE_INVALID ||
>> + ctl->md_state == MD_STATE_WAITING_FOR_HS1 ||
>> + ctl->md_state == MD_STATE_WAITING_FOR_HS2 ||
>> + ctl->md_state == MD_STATE_READY) {
>> + md_info->exp_id &= ~D2H_INT_EXCEPTION_INIT;
>> + ccci_fsm_recv_md_interrupt(MD_IRQ_CCIF_EX);
>> + }
>> + } else if (ctl->md_state == MD_STATE_WAITING_FOR_HS1) {
>> + /* start handshake if MD not assert */
>> + mask = mhccif_mask_get(mtk_dev);
>> + if ((md_info->exp_id & D2H_INT_ASYNC_MD_HK) && !(mask & 
>> D2H_INT_ASYNC_MD_HK)) {
>> + md_info->exp_id &= ~D2H_INT_ASYNC_MD_HK;
>> + queue_work(md->handshake_wq, &md->handshake_work);
>> + }
>> + }
>> +
>> + spin_unlock_irqrestore(&md_info->exp_spinlock, flags);
>> +
>> + return 0;
>> +}
...
>> + cmd = kmalloc(sizeof(*cmd),
>> + (in_irq() || in_softirq() || irqs_disabled()) ? GFP_ATOMIC : 
>> GFP_KERNEL);
> Hmm...
Looks like we can just use in_interrupt(), was that the concern?

>> + if (!cmd)
>> + return -ENOMEM;
>> + if (in_irq() || irqs_disabled())
>> + flag &= ~FSM_CMD_FLAG_WAITING_TO_COMPLETE;
> Even more hmm...
>
>> + if (flag & FSM_CMD_FLAG_WAITING_TO_COMPLETE) {
>> + wait_event(cmd->complete_wq, cmd->result != FSM_CMD_RESULT_PENDING);
> Is it okay in IRQ context?

We know that the caller that sets FSM_CMD_FLAG_WAITING_TO_COMPLETE flag 
it is not in IRQ context.

If that's good enough then we could also remove the check that clears 
that flag few lines above.

The only calls using FSM_CMD_FLAG_WAITING_TO_COMPLETE are coming from 
dev_pm_ops callbacks, and

we are not setting pm_runtime_irq_safe().

Otherwise we can use in_interrupt() to check here as well.

>> + if (cmd->result != FSM_CMD_RESULT_OK)
>> + result = -EINVAL;
