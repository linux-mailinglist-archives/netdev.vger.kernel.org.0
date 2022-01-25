Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFA549BBE1
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 20:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiAYTN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 14:13:29 -0500
Received: from mga18.intel.com ([134.134.136.126]:26303 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbiAYTN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 14:13:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643138008; x=1674674008;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8U2uqQ+7mSsXJgVb92mw6z7879L7Nus9mCGKlA0E61A=;
  b=nVcPLPRrmIs+1q68KeOO+heiZ18Y8gEhzFAUBu0EgejFg2dWLiXVNpjF
   eq+M6HQkxredGAOP+6FBroBxv6n+8k4IR+F9AYUOVm97DUsE1STpKXTR/
   Nk6rwvnLacG6pO7fOgFJOWB7ctlqUj79WyFqyHucm/2FvNwe3ZqyKhe4U
   2ZpjrvaAnZS6furX4tQBYt8/eyBdIylezPlF4rkvdOUjkYx1NS5NiW6he
   +B3w5mRmFFDVIjwxVZgX8CHv53fSBM9JUCJ7UvrmbgeoXyVMtjH9FLoQs
   xKO/5nRBPMYrW2EFZ9089hGwSUP3As9d/jUXDo6O57FjTsi2LZYkwLOmf
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="229966929"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="229966929"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 11:13:27 -0800
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="597231996"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.29.200]) ([10.209.29.200])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 11:13:25 -0800
Message-ID: <b163fdb0-3b86-08d3-a6ef-efde3dde26ed@linux.intel.com>
Date:   Tue, 25 Jan 2022 11:13:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 03/13] net: wwan: t7xx: Add core components
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
 <20220114010627.21104-4-ricardo.martinez@linux.intel.com>
 <21cc8585-9bad-2322-44c2-fc99c4dccda0@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <21cc8585-9bad-2322-44c2-fc99c4dccda0@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/24/2022 6:51 AM, Ilpo Järvinen wrote:
> On Thu, 13 Jan 2022, Ricardo Martinez wrote:
>
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> Registers the t7xx device driver with the kernel. Setup all the core
>> components: PCIe layer, Modem Host Cross Core Interface (MHCCIF),
>> modem control operations, modem state machine, and build
>> infrastructure.
>>
>> * PCIe layer code implements driver probe and removal.
>> * MHCCIF provides interrupt channels to communicate events
>>    such as handshake, PM and port enumeration.
>> * Modem control implements the entry point for modem init,
>>    reset and exit.
>> * The modem status monitor is a state machine used by modem control
>>    to complete initialization and stop. It is used also to propagate
>>    exception events reported by other components.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> ---
> Some states in t7xx_common.h (MD_STATE_...) would logically belong to this
> patch instead of 02/. ...I think they were initally here but got moved
> with t7xx_skb_data_area_size(). And there was also things clearly related
> to 05/ in t7xx_common.h (at least CTL_ID_*).

Originally, 02 and 03 were going to be part of the same "Core 
functionality" patch,

the only reason for splitting it was to make that core patch smaller. 
The result is that

02 uses code defined at 03, note that compilation is enabled at 03.

Will merge 02 and 03 in the next version, also clean t7xx_common.h from 
definitions

not used.

...
>> +int t7xx_fsm_append_cmd(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_cmd_state cmd_id, unsigned int flag)
> No callsite in this patch seems to care about the error code, is it ok?

Even though there's no recovery path (like retry) for 
t7xx_fsm_append_cmd() failures, it makes sense to

propagate the error instead of ignoring it, will add that in the next 
version.

> E.g.:
>> +int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
>> +{
>> ...
> If this returns an error, does it mean init/probe stalls? Or is there
> some backup to restart?
An error here will cause probe to fail, there's no recovery path for this.

